Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0105AB8E6
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiIBTf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiIBTf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:35:27 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDF785A9D
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:35:25 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1225219ee46so7260594fac.2
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 12:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dwSqW+EES0kZUKahPvUQsT2romYUFeGN5IYICq6KYkA=;
        b=LzRUaZ8D2IVgsndue4ORGdjpjHnVj0lRMSAujokM4ES2FfcX/n8sbdZdglQjlzqC/6
         0gSvzZqQVcZrDGZzHK95GAz7I0oExhKRzZxFa8sGb0q6PBFS1i8UmK2xOvmEFKysssaz
         ArABswb+XeHMGsPPFxu6F8slc1uzMUjyKTst/NCXJ66kMqrFXeo5r4mfiSLgwPJItkPP
         3Ms1Zth/K/iC+Q4MNLh/WxzCcBNFCKwUbPAxjdWc/PWK6dK4hjRTgbVOHPp/J2NzrbaP
         qqMBt6xfeYwAmRHWr0gAwEFntIpq6QlAwOecfHu+5OvccORtyvh1SWjO8Qlc3KC7g9Ku
         jVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dwSqW+EES0kZUKahPvUQsT2romYUFeGN5IYICq6KYkA=;
        b=iPjrLd8tE3xiDriieorTzjNzxTANBCemDWZAEjzE4QvfZsZvZxFhrT9jYAAm/R5ON6
         RV+vd7aTVFtjsTWfcxghZ8NMjUEgSK36c1I2uRDBBvlFz1wgZOsKn35ymqsOsH6ziZU3
         9s47QETMmNIHWyDK3jvX7XhY7npLxc7IXxUYQdeeoKsNBMRva0GJq3q0uVNVpnOwhs/Z
         bPDG6d+IgqVbdYSzY259u7Q3Q6xSJHtiFJ4ZvZEKFdEs/85yKLUALtXkfWezbtZf5pL+
         dR48dv7NVPJzmA2CQx4uD55TzashmpYkiKtohu4cTKrPyTl8HxSiEfFduYnSJk4Sf7N+
         ptNw==
X-Gm-Message-State: ACgBeo2sNb9AFXRCTGTxO5Kgj8ySJtlSaTlgVyi1xaAV/32cx1B6QyfM
        M2X41TIlyBUw8wULRF/88EKGlRYc6KoMCXHkUyiYqQ==
X-Google-Smtp-Source: AA6agR5ecKSwMzDI2RN5dwUdXI/C2ZUxIO8z02GK/PsD5Jd/9AnsJDNtO2qsJxcjdwC6JDHLQCcn5NJYCegcNLRGiko=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr2543211oiw.112.1662147324591; Fri, 02
 Sep 2022 12:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
 <Yw8aK9O2C+38ShCC@gao-cwp> <20220901174606.x2ml5tve266or5ap@desk>
 <CALMp9eRaq_p2PusavHy8a4YEx2fQrxESdpPQ_8bySqrv61ub=Q@mail.gmail.com> <20220902191441.bbjfvniy5cpefg3a@desk>
In-Reply-To: <20220902191441.bbjfvniy5cpefg3a@desk>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Sep 2022 12:35:13 -0700
Message-ID: <CALMp9eTAedQDHe8FQN1TvQgSxO4+2Sb-fB6FDCBh3gKMUe449A@mail.gmail.com>
Subject: Re: BHB-clearing on VM-exit
To:     Pawan Gupta <pawan.kumar.gupta@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, chen.zhang@intel.com,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 2, 2022 at 12:14 PM Pawan Gupta <pawan.kumar.gupta@intel.com> wrote:

> It may be possible to use shared BHB to influence the choice of indirect
> targets, but there are other requirements that needs to be satisfied
> such as:
>  - Finding a disclosure gadget.

Gadgets abound, and there are tools to find them, if the attacker has
the victim binary.

>  - Controlling register inputs to the gadget.

This is non-trivial, since kvm clears GPRs on VM-exit. However, an
attacker can look for calls to kvm_read_register() or similar places
where kvm loads elements of guest state. The instruction emulator and
local APIC emulation both seem like promising targets.

>  - Injecting the disclosure gadget in the predictors before it can be
>    transiently executed.

IIUC, the gadget has to already be an indirect branch target that can
be exercised by some guest action (e.g. writing to a specific x2APIC
MSR). Is that correct?

>  - Finding an appropriate indirect-branch site after VM-exit, and before
>    BHB is overwritten.

Is it the case that the RIP of the victim indirect branch has to alias
to the RIP of the "training branch" above in the predictors?

Presumably, guest influence diminishes after every branch, even before
the BHB is completely overwritten.
