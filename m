Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BD768E4AC
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 00:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjBGXzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 18:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBGXzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 18:55:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8F820696;
        Tue,  7 Feb 2023 15:55:53 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675814151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7bMsFqexife+ywZrYCgkFEhhv4UjPGRPsQk7cMNeYE=;
        b=lCpFHGmEc0aKNMD7/Og+w0z0X2azQAypfr+EbGXzzuCUVLDTyHjMVcyTWqerx+Qb2EzJOs
        4BffxTjMB2izlCqGPqfhndft3//rV+kRXH04k6YIMaVw4u6obVnAjDZ21G90KGXwgtPzdL
        AuSgpU3O7wXbi6tjr/w1GOigrhKVrlGtg27SgAzkhcTLck1zD2Ttl3JzpxQipeRYAWM2tf
        e2sGjvo28NLt97ZgHBy/wBpJIMVpmviUlSQTbQCZSDns+Atlo0HI/Y3e1+wGnoFe3GY1Iu
        +MvV56vL+dd+Wm8h2RC2/IE5kO//0BNs7Q8E+jXkgHzKzGoSpb8d0li8nk33+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675814151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V7bMsFqexife+ywZrYCgkFEhhv4UjPGRPsQk7cMNeYE=;
        b=Cyzxy2vY85R/VCKQL76eoAYsmkrxvsLC0ROhgDhEsRRqc/egyz/4MHuEEBH/09oiIzCtIP
        7KMktk9vg/YxgdCA==
To:     Arjan van de Ven <arjan@linux.intel.com>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v6 11/11] x86/smpboot: reuse timer calibration
In-Reply-To: <ca89ed9f-3869-9556-0eb3-c5dc84511d95@linux.intel.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-12-usama.arif@bytedance.com>
 <ca89ed9f-3869-9556-0eb3-c5dc84511d95@linux.intel.com>
Date:   Wed, 08 Feb 2023 00:55:50 +0100
Message-ID: <875ycduj21.ffs@tglx>
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

Arjan!

On Tue, Feb 07 2023 at 15:16, Arjan van de Ven wrote:
> On 2/2/2023 1:56 PM, Usama Arif wrote:
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> 
>> No point recalibrating for known-constant tsc.
>> When tested on a 128 core, 2 socket server, this reduces
>> the parallel smpboot time from 100ms to 30ms.
>> 
>> Not-signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>
> you can turn this in a Signed-off-By:

Please post your patch separately as it is a completely orthogonal issue
and can be reviewed and discussed independently of the parallel bringup
effort.

Thanks,

        tglx
