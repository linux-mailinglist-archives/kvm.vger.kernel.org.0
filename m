Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6136E695217
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 21:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBMUn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 15:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBMUnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 15:43:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568BF11678;
        Mon, 13 Feb 2023 12:43:19 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676320994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dp1zvkaoXZwXPfB60lKlFJ79KNQWFIG6r/rAvzVX2j0=;
        b=ATrfQerDAcuySUZMGbGGPfRvpO7npAochf0y/gEFwyOLTIIOPsj8F5UdAkSxAuzSynghnf
        IOTO5EIYTFw2xf6RGjBfpTmauEVcwJiCqQTA8T05F3f6G6s+EevdtwTTdJBsWR1QssCmgg
        aM+QcYbSdIBPGV/kNmC4Aqdeo/qW9Jr4Ont3IYOzB5kclf8eCe7Aemz4r0sbYiNy+1ef3F
        GnxAWxol9HnUs1qrXHAsf+4gVMHvgXlV/nxH082t6orE4Tsf+elk0lhY4ikDJqDwdo5CnK
        HrQtSy+hD7BEAD4hExx+eXs4e9INIQhxzIky2MxurVGaDq8YEnf9jIsB+9bjiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676320994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dp1zvkaoXZwXPfB60lKlFJ79KNQWFIG6r/rAvzVX2j0=;
        b=6eDvXLZWiDP8EzoHgPZhWlwqyjjkAVVINrVfhH+zO1xQGi/EoSnQT2gRD64pSmE2WioiC2
        v5mGOkovIxH/GsAg==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v8 9/9] x86/smpboot: Serialize topology updates for
 secondary bringup
In-Reply-To: <20230209154156.266385-10-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-10-usama.arif@bytedance.com>
Date:   Mon, 13 Feb 2023 21:43:13 +0100
Message-ID: <87v8k5s3dq.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09 2023 at 15:41, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The toplogy update is performed by the AP via smp_callin() after the BSP
> has called do_wait_cpu_initialized(), setting the AP's bit in
> cpu_callout_mask to allow it to proceed.
>
> In preparation to enable further parallelism of AP bringup, add locking to
> serialize the update even if multiple APs are (in future) permitted to
> proceed through the next stages of bringup in parallel.

This one is also only relevant for further parallelisation, right?

Thanks,

        tglx
