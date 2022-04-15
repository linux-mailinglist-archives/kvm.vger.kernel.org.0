Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094D5503168
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352961AbiDOVMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 17:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352224AbiDOVMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 17:12:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2207A2D1E7
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:09:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p10so7956565plf.9
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LPajdb3g+LFqEb7zxx+mJ8Pp5q38lO4WZRS//6zsW5A=;
        b=lTOVQQ3RWsbuiCaMKk4EX37aPHUG34dV8qYGLALne7qhFw4eypIAiHmQNLMlP2aeyo
         542QyNA+aU52WNn37MYbWRnej60xiV/Dn/hkfHa1lTQiS27uNJRfGkFnuUgtBkwh7l/d
         uDjPUmM5aDsU0+Xh2voHb/yGZ9WArIiRlgURdQHBfCLvHQ/B6qKQ84ZLQvTa4c410nGa
         pSCbMc36ZF/bJy3z+ww6hLpwaaaIpwwOuUlB51Z8n7d2qiCgKCNc1z6s+mc+FL1/h6PG
         FQucgbCix0gMrpNbW2OP/iVRQVC1KcUd+wqzZDqodm/fecOSnMVfaZxXc3PJWn9dE+LY
         wuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LPajdb3g+LFqEb7zxx+mJ8Pp5q38lO4WZRS//6zsW5A=;
        b=A+SId6b3VINOKM1Uf8f7f+ZFtMnr5ZvvbvIsum5jOmpjqiMC7wFW8occTaQsp81Ohd
         TUmyagveuWup6XZg1Xnhpcu8vQcNorrHajN+e/m4vb3fmGmkAktq7lVbpD4JdaMmH+cY
         LEKCSfGWxRMDvQxabqIBumVZBcCUVW4ZO3X0Rm5aeJLiWm0oHOtEGJrNBOFAbtdZ7qjr
         7iiloLaR6Dk1CEdG4vfZR/zyVJw6a1AJc5ouBOiTKa1E6XXYQjozcluKlnogW+d+Vk1K
         eXN5xDt10aPvYx+7K2tB2UsOUiXQ6gv0QfzyKqsR+yKRMzjX11FGa6oGfjtwlHObYJMc
         GWOg==
X-Gm-Message-State: AOAM531fVdiC9Qxika6HudtrBxYme64MrK2MgGtMTMEi+ZKwJ2CoHjad
        DxglGxYxVeL9U6SKy0HPsBR69A==
X-Google-Smtp-Source: ABdhPJwflp/hO2AJCFbRTgnQmnJUY2rmHxmi5NZ8H02JW44VJF+GwN0yBuW3QmlpEzyTHXzlJj+nPA==
X-Received: by 2002:a17:90a:b890:b0:1cb:7ef2:8577 with SMTP id o16-20020a17090ab89000b001cb7ef28577mr754635pjr.45.1650056989193;
        Fri, 15 Apr 2022 14:09:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k20-20020aa788d4000000b004fb07f819c1sm3944370pff.50.2022.04.15.14.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:48 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:09:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?5r2Y6auY5a6B?= <pgn@zju.edu.cn>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        secalert@redhat.com, syzkaller@googlegroups.com, kangel@zju.edu.cn
Subject: Re: 'WARNING in vcpu_enter_guest' bug in arch/x86/kvm/x86.c:9877
Message-ID: <YlnfGOGQPCxkAb03@google.com>
References: <ca5aa7c.e8ca9.17f71bde91a.Coremail.pgn@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca5aa7c.e8ca9.17f71bde91a.Coremail.pgn@zju.edu.cn>
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

On Thu, Mar 10, 2022, 潘高宁 wrote:
> Hello, This is Gaoning Pan and Yongkang Jia from Zhejiang University. We
> found a 'WARNING in vcpu_enter_guest' bug by syzkaller. This flaw allows a
> malicious user in a Local DOS condition. The following program triggers Local
> DOS in vcpu_enter_guest in arch/x86/kvm/x86.c:9877 in latest release
> linux-5.16.13, this bug can be reproducible stably by the C reproducer:
> 
> ------------[ cut here ]------------

...

> Syzkaller reproducer:
> # {Threaded:true Repeat:true RepeatTimes:0 Procs:16 Slowdown:1 Sandbox:
> r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
> r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
> ioctl$KVM_CAP_SPLIT_IRQCHIP(r1, 0x4068aea3, &(0x7f0000000000)) (async)
> r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) (async)
> r3 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x400000000000002)
> ioctl$KVM_SET_GUEST_DEBUG(r3, 0x4048ae9b, &(0x7f00000000c0)={0x5dda9c14aa95f5c5})
> ioctl$KVM_RUN(r2, 0xae80, 0x0)
> 
> C repro and kernel config are attached.

Reproduced, should have a fix posted shortly, thanks!
