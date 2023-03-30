Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682A76D0D98
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 20:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjC3SRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 14:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjC3SRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 14:17:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB69F751;
        Thu, 30 Mar 2023 11:17:07 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680200225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEar+cnNvLMrO9daEBtqnzruxGox6aVxDs6PfvPU/EU=;
        b=XOP/lf70k5ZzwPwnaAT/knMDB6J2hJzNyqH9m1jyfnvto9XY5ar1Y27ouiOfMYW6XmBVyS
        9tnwy2qrNmNsI1bRl9JnIFU0rPCPkynQEPkgejka8u1PHpwy3frN6rHNRHzbAvYyajlzvW
        jT20Uf+l5ZBdVY8myinxbkfBbT45sQOycyd+qdpn/AZttCQsM5kfYhQrDhPGtqXUS5mN+I
        JSgxlhC+gzQdl2HaamRoK2ZXjgPtnRshwieJgZ7jbIAduD8mz1J/4/vIQNrHGpPYkuva9S
        hrWocqg7cMW3gscymFkD2pBs4drHJri44FY4V02uHmdmNOcU0ku55xSHHFi06w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680200225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEar+cnNvLMrO9daEBtqnzruxGox6aVxDs6PfvPU/EU=;
        b=2AQe4HprrpxFMzkT0TW0NQ+GeEDlT5PY5wCF/iCAnj8M3DIMaeMFhqSFbqG7ZbD2204tQP
        LjL5zADSrao9nQDA==
To:     Borislav Petkov <bp@alien8.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v17 6/8] x86/smpboot: Send INIT/SIPI/SIPI to secondary
 CPUs in parallel
In-Reply-To: <CAFC43E6-97E9-4E89-AABB-78E31037048A@alien8.de>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
 <20230328195758.1049469-7-usama.arif@bytedance.com> <87v8iirxun.ffs@tglx>
 <CAFC43E6-97E9-4E89-AABB-78E31037048A@alien8.de>
Date:   Thu, 30 Mar 2023 20:17:04 +0200
Message-ID: <87sfdmrtnj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30 2023 at 19:05, Borislav Petkov wrote:

> On March 30, 2023 6:46:24 PM GMT+02:00, Thomas Gleixner <tglx@linutronix.de> wrote:
>>So that violates the rules of microcode loading that the sibling must be
>>in a state where it does not execute anything which might be affected by
>>the microcode update. The fragile startup code does not really qualify
>>as such a state :)
>
> Yeah I don't think we ever enforced this for early loading.

We don't have to so far. CPU bringup is fully serialized so when the
first sibling comes up the other one is still in wait for SIPI lala
land. When the second comes up it will see that the microcode is already
up to date.

Thanks,

        tglx

