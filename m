Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4CD6CF800
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjC3ALa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 20:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjC3AL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 20:11:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E396199;
        Wed, 29 Mar 2023 17:11:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680135057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=2uZm0m4ATE7oe+dpoxdgdmEUwhVm/L5sQVQOSDCKIJo=;
        b=g4Tpi/ZrAmHrcA5ajf4WDofLgdb95sLtiYjqjxvAIYuvaKbY+sBhgl87kElpd03ipBWSmt
        XKxg8hzzUvMlHCdB2sMNfRh7bmbeVZoYCbo3BBss3ZAUOA1uWJomxRYzmtuuW4o+dfC6V+
        0COBes66oDvRlU2+JfhoO5IeFEWfunWn8QxTi+metDqEIrYmBRYG3DuvQmSdaQqBwQCf1r
        tgFTULMKUiC2kertC3h5rKsQNLYE6xhP1Gi/bcSRULZy6dGa1jzZC4l24oHW9MsBSG7Bj9
        j4e4MTU2VvyxLpJLaQyC6yG0i4T1VTCD6ITpSjeR87UjMZARAc+uMDLQDqMZbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680135057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=2uZm0m4ATE7oe+dpoxdgdmEUwhVm/L5sQVQOSDCKIJo=;
        b=oo0ukT8mTCUGnajU2H+wPAxYb/9JOQhSs4vfLIb8MZcrr1khsxuBlxL/TFDxpPL618LFjI
        WNcipSWMvlgXo/Aw==
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
In-Reply-To: <20230328200725.GHZCNI/dHoUMwhsfiC@fat_crate.local>
Date:   Thu, 30 Mar 2023 02:10:56 +0200
Message-ID: <871ql7t7xr.ffs@tglx>
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

On Tue, Mar 28 2023 at 22:07, Borislav Petkov wrote:
>>  void cc_set_vendor(enum cc_vendor v);
>> +enum cc_vendor cc_get_vendor(void);
>>  void cc_set_mask(u64 mask);
>>  
>>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
>
> You don't need those hunks adding cc_set_vendor() anymore:
>
> https://git.kernel.org/tip/5ae57743f578725a5dadb6f31d7798ee55e6e967

That's not really true. The series is based on the x86/apic branch as
the prerequites are in that brnach and that commit is in x86/sev.

That's an x86 maintainer issue to sort out, really.

Thanks,

        tglx
