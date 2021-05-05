Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDCA373406
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 05:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhEEDwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 23:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhEEDwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 23:52:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29017C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 20:51:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so853898pga.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 20:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuxcvPcqx3Qh8O3Sq29dfGaL0R++3U+nMmQ4FMxjpIw=;
        b=CdY0H0uP/8CzhwMU2IZMSdGk/14qPmAabI2Au2IoJbDwZaMhtH2BczE8TH7iSliSmQ
         V56tOCibWU783hVxnDhwloKWcBJ2eWUrBubjNOlsiiPT2syIGoJgA6R6pvJULvmWbbni
         Z84i6LqlLkz/QtF37VAsM0lQXIeoTtiPLc0oEuHvXl3DttmqMwlo9TfuN9T+tV+30Z+9
         c3S6VYEVmp5X5ee+47Cgj7MhE+Nc1FhoZ+AaH+6Kin1HTbs7n8yyzc02itWbNiI1SYe9
         yODQplY1cid2J6loIiw4kJ3Vt8+/bznP2oE6HAfM8VcJ0JkOg/jLrpY7aDUv70DJymky
         M4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuxcvPcqx3Qh8O3Sq29dfGaL0R++3U+nMmQ4FMxjpIw=;
        b=sGMhJ9YoEdzTawa3f0dgh2uVvBe/MscBt+IoUoHKNUgyh/RyNkDl5hAXFqtTeXEepn
         WVqS9fI2WAdoLzkkWKIOHt3hgVCrWJyAX0+MqvuugLYPhsnkNt+dv2gUBF0VYTPlljwA
         p0timVD1zPaJVBSIi0IMPDItxlFkERbkLNPI5eWxWzH7VZVQRvwpacopq/2ra7JSHIhY
         xt08n7PJ8RjQRZQGq15d4TLo8yU2pLi45djQBEkd3a+DB3WTl6cxw+uAXsDUCk8ZVmu9
         Y6zMfH7DffwJVf3pRcS6bNa74oAYe9W7TIeDr8eXCUsxOZzOxBHBsuFuaC2AyH7Z4qRc
         AstQ==
X-Gm-Message-State: AOAM530WTOPvMsh9BJEJOfTSukfWxrDjXjplBHwijKuMXqhmOgSLjj7f
        3fyU011AK5qZMOxVbwY1NQwE/fPaT16Vyqxk6rcI9A==
X-Google-Smtp-Source: ABdhPJwDLHHt3gB4j6l8YHg+grKB6QKNCwosKbgTlmk3oqH7q1XRXnFjHw4qyT6HoAVdR5ZwNIHy3U5TIlyJqMbzYs8=
X-Received: by 2002:a63:4f50:: with SMTP id p16mr26180867pgl.40.1620186717576;
 Tue, 04 May 2021 20:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-3-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-3-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 4 May 2021 20:51:41 -0700
Message-ID: <CAAeT=FycnR2BonmiHSWobsLCGTuQuTS3kg9x_eYCKLRQGOvYzQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is supported
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>         case 7:
>                 entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>                 entry->eax = 0;
> -               entry->ecx = F(RDPID);
> +               if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> +                       entry->ecx = F(RDPID);
>                 ++array->nent;
>         default:
>                 break;

I'm wondering if entry->ecx should be set to F(RDPID) here
even if the CPU supports RDPID natively.
(i.e. kvm_cpu_cap_has(X86_FEATURE_RDPID) is true)

The document "Documentation/virt/kvm/api.rst" says:
---
4.88 KVM_GET_EMULATED_CPUID
---------------------------
<...>
Userspace can use the information returned by this ioctl to query
which features are emulated by kvm instead of being present natively.
---

Thanks,
Reiji
