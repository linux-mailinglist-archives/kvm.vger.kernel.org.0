Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22511791607
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 13:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjIDLHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjIDLHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 07:07:46 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB6C1B5
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 04:07:42 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 38308e7fff4ca-2b95d5ee18dso21521671fa.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 04:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693825661; x=1694430461; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zQMeI/gTGz6lTcMMUigGnHBa8WiicAhxPVz08NA+suM=;
        b=mk3qLmDc417F+l+es8DEvz3HzPGxRsC87NyYSQx1H1Zg1u7UstKaIwC+VFQJbufAHS
         tP0rA8D0fFYbQ8UwV6GWadk0/VH14XLWHEPw9QUU2uOFmw1JCXtEui1AheRNdXSiIdct
         yGnjTfNoQole0S8PZ0NXgmpJYBOL0oujLtmjN1qWg7KS3+sAFW2o4tHe3Tt6MqEptDdU
         nVP8sK6YRugV0p7GV8G0R9UR8eWY8EMQvcI6wZlNwcwxSEGKfeBqoFApliBD5wl0ys/X
         TIPfhmwONeMlB40frX4hmY+tmgOtIZfupF+o4M9tbxN8aieAJmNmecaLWJ96QPBzDH0/
         TE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693825661; x=1694430461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQMeI/gTGz6lTcMMUigGnHBa8WiicAhxPVz08NA+suM=;
        b=kPGL8Q398QmpB5Ose+mKAl1e7oXAnZRSaUEYu2gslOxMiak+dzs5yPL05ECxisdKzG
         QwNRc5EmTlHKidv+5zzz5XsFeDy7MS9PaZQb5g80jWBWdT3UvV3mTMO2QcNy65AdqGMq
         HIyeRv7NKXBRS68SJsS+GlImX35mT848ydezLHdTxjGzoAvOv+mXPsGmN7s6xHZC0IzN
         WMfawzbkMYbMvSPBsLiBQL1wYHwn5o/MvWCfBw5NxzOBniANEqkIb/04aB9xt5aa6DFA
         31UcJ+lBcXjxb0rd1uPszU0OMzV63p3EGl5s2OH3w5S2z+vfWepDcARxQxZvvkzDl/1o
         lVlQ==
X-Gm-Message-State: AOJu0YzLICzlxjhARsL3Sd2Zu9ItmSvDNhQoAy+Yr/XOslPHq9Bmbt1m
        W3HPQsSge8YDm1llsOop5Cg6CQ==
X-Google-Smtp-Source: AGHT+IHXJXUGNGiWKQKrOeRD9bizgcc9xl31FnzvzOAy3Xc4+CVwx9AZwjwTmMkrHYASRhmk0BUUQg==
X-Received: by 2002:a2e:3c0f:0:b0:2bc:ffcd:8556 with SMTP id j15-20020a2e3c0f000000b002bcffcd8556mr6730713lja.12.1693825660382;
        Mon, 04 Sep 2023 04:07:40 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id d3-20020adfef83000000b0031c6ae19e27sm14125194wro.99.2023.09.04.04.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 04:07:39 -0700 (PDT)
Date:   Mon, 4 Sep 2023 13:07:38 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <andrew.jones@linux.dev>, qemu-devel@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, qemu-trivial@nongnu.org,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Message-ID: <20230904-2587500eb2b77ed6c92143e2@orel>
References: <20230831190052.129045-1-coltonlewis@google.com>
 <20230901-16232ff17690fc32a0feb5df@orel>
 <ZPI6KNqGGTxxHhCh@google.com>
 <cfee780b-27ab-8a49-9d42-72fd2a425a17@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfee780b-27ab-8a49-9d42-72fd2a425a17@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 10:18:05AM +0200, Claudio Fontana wrote:
> Hi,
> 
> I think this discussion from ~2015 could potentially be be historically relevant for context,
> at the time we had the problem with CNTVOFF IIRC so KVM_REG_ARM_TIMER_CNT being read and rewritten causing time warps in the guest:
> 
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/1435157697-28579-1-git-send-email-marc.zyngier@arm.com/
> 
> I could not remember or find if/where the problem was fixed in the end in QEMU,

It's most likely commit 4b7a6bf402bd ("target-arm: kvm: Differentiate
registers based on write-back levels")

Thanks,
drew

> 
> Ciao,
> 
> Claudio
> 
> On 9/1/23 21:23, Colton Lewis wrote:
> > On Fri, Sep 01, 2023 at 09:35:47AM +0200, Andrew Jones wrote:
> >> On Thu, Aug 31, 2023 at 07:00:52PM +0000, Colton Lewis wrote:
> >>> Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> >>> in unintended trap and emulate access and a consequent performance
> >>> hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> >>> access.
> >>>
> >>> Quoting Andrew Jones:
> >>>
> >>> Simply reading the CNT register and writing back the same value is
> >>> enough to set an offset, since the timer will have certainly moved
> >>> past whatever value was read by the time it's written.  QEMU
> >>> frequently saves and restores all registers in the get-reg-list array,
> >>> unless they've been explicitly filtered out (with Linux commit
> >>> 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> >>> restore trapless ptimer accesses, we need a QEMU patch to filter out
> >>> the register.
> >>>
> >>> See
> >>> https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
> >>
> >> The link can be shorter with
> >>
> >> https://lore.kernel.org/all/20230823200408.1214332-1-coltonlewis@google.com/
> > 
> > I will keep that in mind next time.
> > 
> >>> for additional context.
> >>>
> >>> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> >>
> >> Thanks for the testing and posting, Colton. Please add your s-o-b and a
> >> Tested-by tag as well.
> > 
> > Assuming it is sufficient to add here instead of reposting the whole patch:
> > 
> > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > Tested-by: Colton Lewis <coltonlewis@google.com>
> > 
> >>> ---
> >>>  target/arm/kvm64.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> >>> index 4d904a1d11..2dd46e0a99 100644
> >>> --- a/target/arm/kvm64.c
> >>> +++ b/target/arm/kvm64.c
> >>> @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
> >>>   */
> >>>  static const CPRegStateLevel non_runtime_cpregs[] = {
> >>>      { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> >>> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
> >>>  };
> >>>
> >>>  int kvm_arm_cpreg_level(uint64_t regidx)
> >>> --
> >>> 2.42.0.283.g2d96d420d3-goog
> >>>
> > 
> 
