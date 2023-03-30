Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8FA6CFDEC
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjC3IQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjC3IQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:16:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F7355B5;
        Thu, 30 Mar 2023 01:16:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680164158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6TYGlcN916YLwgEhLrVT2gbEofIUMte1lkYxUuiC30=;
        b=3p0YHLN96un+4ZlUQ8MVI3d0IpJggs9GC8qWiD/Z5gq4c9woIrm0vvXh6U0G4nzJ+GGCgz
        qQ3V2qddJoUD3I6qFX5gq/7O18SQgi6r3TSdpxhnmXtKJtdIkziDGKsR3DbExch2q+IFWj
        W5D7xz99FpcCQxBZDsGiIlL7jQAnLqAxqdipyfXrhDwd32nxXXFsaMMSCHrciJy1DnFqG5
        QwP9Gwl9F0VeKgDH18Nx78NmxVFKOYCmBPPOf723u6K7o/vCxzZt50CQQKhbZKW1d2CbJQ
        +0/VgYIflyvjMlrnMCQO1Az6wg1LidQpvGdSWKw+R2V1bJ7yxB6TnId/8nTPkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680164158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6TYGlcN916YLwgEhLrVT2gbEofIUMte1lkYxUuiC30=;
        b=imWChKu+qXkjV3GEJ3BMKSrgNCQUsZDFhEMAj8Mc2MrUuU3jckkUjyVvuhjFZ7YuyCl0gF
        XIiHGZla57pC91Bg==
To:     Borislav Petkov <bp@alien8.de>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, kim.phillips@amd.com, brgerst@gmail.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>
Subject: Re: [PATCH v17 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
In-Reply-To: <871ql7t7xr.ffs@tglx>
References: <871ql7t7xr.ffs@tglx>
Date:   Thu, 30 Mar 2023 10:15:57 +0200
Message-ID: <87y1neslhe.ffs@tglx>
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

On Thu, Mar 30 2023 at 02:10, Thomas Gleixner wrote:
> On Tue, Mar 28 2023 at 22:07, Borislav Petkov wrote:
>>>  void cc_set_vendor(enum cc_vendor v);
>>> +enum cc_vendor cc_get_vendor(void);
>>>  void cc_set_mask(u64 mask);
>>>  
>>>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
>>
>> You don't need those hunks adding cc_set_vendor() anymore:
>>
>> https://git.kernel.org/tip/5ae57743f578725a5dadb6f31d7798ee55e6e967
>
> That's not really true. The series is based on the x86/apic branch as
> the prerequites are in that brnach and that commit is in x86/sev.
>
> That's an x86 maintainer issue to sort out, really.

Aside of that, this needs a wrapper when CONFIG_ARCH_HAS_CC_PLATFORM is
not set to be usable outside of CC specific code...

Thanks,

        tglx
