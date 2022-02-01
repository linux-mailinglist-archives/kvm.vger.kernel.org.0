Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9B4A6521
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 20:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiBAToy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 14:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiBATox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 14:44:53 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3781C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 11:44:53 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g2so16297747pgo.9
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 11:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLUYsPWsZ3gWFEc3WUsQBFuy3jyJ9IS5Qr2rNhtAogo=;
        b=WP4fhiCwUKuenhgLkNnSJQ1wkxqCGAvEsEnwA7lPfH61D6xrlzPHhbvy8iP5QMGqVg
         BIp9LB4sBDY2IBMVlRnwjDN6h6ote/88AbwGAwDGsUEyor72pbA3JBpA/chT8vCCtqPQ
         Z0DkEc7i/UYJlkQHREkZjonpm2eaX0WFAnE5yHbTCOMOIDMKWClHsgz+0/PdKokqUo2C
         OZUUbmPwE2Sjxu+oOOMgSvbxfZ2EJQYS1w/lWEeTZ94eUNtwpuIKNt1+ajZUptiOs3OO
         uSSeN4zX0bCtl27bid51IZKgVvR39ng7j3wVea/gp9YKAeBdxPUZP/yh61mDs+MBcasY
         8+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLUYsPWsZ3gWFEc3WUsQBFuy3jyJ9IS5Qr2rNhtAogo=;
        b=fvvQbj3BPH0iAsYKurDDhDk0BQ2AIzsH86UwREz8wJa2FVl+Yd1z/CKNCiEe2lSdmU
         pjeaMHCvaVEcWa/l7lX5MOVO/rYuchl6Ut+S5F1+826if0A4gdLAhvH0KCrbEM4jjJkl
         el8ZnTpeSOgcp0ge1jOkGqF0BtbCrHDoLnJF6xaK0+qiR7HSPVEYJ6Ymb4wqMwBIa2jv
         7VEoLNhNJgMppSo9xG8ydjObK5fUNBVI8S9dilLB0FUllHe5neuaXpNdEE8NAd4t8cYc
         V/4Pp8X52G+REOGw4E02CEO5T8vkdLloKQlZcRWLHaLg75am6bEicPi4sIPYp0hJVPbb
         GQdA==
X-Gm-Message-State: AOAM531rYXsFQj82SEtI5BWTWvW8QWRLHkePPAh8IL3xPIHFkL87/kjW
        Dluz6LBG3+VUe9Nk6wOeC0WNfg==
X-Google-Smtp-Source: ABdhPJxNhi4swR9br3qpPd4PvS2tuVE80PwWO1z5EGGnP0NA6BhvY6Soya7Zeb53xZuJ8NuJoAeCrQ==
X-Received: by 2002:a63:171a:: with SMTP id x26mr21809360pgl.447.1643744692111;
        Tue, 01 Feb 2022 11:44:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v12sm2445761pgr.68.2022.02.01.11.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 11:44:51 -0800 (PST)
Date:   Tue, 1 Feb 2022 19:44:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: x86: Use __try_cmpxchg_user() to update guest
 PTE A/D bits
Message-ID: <YfmNr8OjOWvsQBKx@google.com>
References: <20220201010838.1494405-4-seanjc@google.com>
 <202202011400.EaZmWZ48-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202011400.EaZmWZ48-lkp@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022, kernel test robot wrote:
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/x86/kvm/mmu/mmu.c:4246:
> >> arch/x86/kvm/mmu/paging_tmpl.h:244:9: error: invalid output size for constraint '+a'
>                    ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
>                          ^
>    arch/x86/include/asm/uaccess.h:629:11: note: expanded from macro '__try_cmpxchg_user'
>            __ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);   \
>                     ^
>    arch/x86/include/asm/uaccess.h:606:18: note: expanded from macro 'unsafe_try_cmpxchg_user'
>            case 1: __ret = __try_cmpxchg_user_asm("b", "q",                \
>                            ^
>    arch/x86/include/asm/uaccess.h:467:22: note: expanded from macro '__try_cmpxchg_user_asm'
>                           [old] "+a" (__old)                               \

#$*&(#$ clang.

clang isn't smart enough to avoid compiling the impossible conditions it will
throw away in the end, i.e. it compiles all cases given:

  switch (8) {
  case 1:
  case 2:
  case 4:
  case 8:
  }

I can fudge around that by casting the pointer, which I don't think can go sideways
if the pointer value is a signed type?

@@ -604,15 +602,15 @@ extern void __try_cmpxchg_user_wrong_size(void);
        bool __ret;                                                     \
        switch (sizeof(*(_ptr))) {                                      \
        case 1: __ret = __try_cmpxchg_user_asm("b", "q",                \
-                                              (_ptr), (_oldp),         \
+                                              (u8 *)(_ptr), (_oldp),   \
                                               (_nval), _label);        \
                break;                                                  \
        case 2: __ret = __try_cmpxchg_user_asm("w", "r",                \
-                                              (_ptr), (_oldp),         \
+                                              (u16 *)(_ptr), (_oldp),  \
                                               (_nval), _label);        \
                break;                                                  \
        case 4: __ret = __try_cmpxchg_user_asm("l", "r",                \
-                                              (_ptr), (_oldp),         \
+                                              (u32 *)(_ptr), (_oldp),  \
                                               (_nval), _label);        \
                break;                                                  \
        case 8: __ret = __try_cmpxchg64_user_asm((_ptr), (_oldp),       \


clang also lacks the intelligence to realize that it can/should use a single
register for encoding the memory operand and consumes both ESI and EDI, leaving
no register for the __err "+r" param in __try_cmpxchg64_user_asm().  That can be
avoided by open coding CC_SET and using a single output register for both the
result and the -EFAULT error path.
