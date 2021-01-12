Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA26A2F37C6
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391743AbhALR5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 12:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390417AbhALR5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 12:57:41 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D94C061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:57:01 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id j1so1811974pld.3
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=juupzti4DjJGDkZymRZ4Hc4aNwh9m6UznVRuz/k6aiY=;
        b=D60dxrI8s7RNFc+y8vuVvZajug7r9YdHgFOUSCbNl3jQHnymRLHAQs8PA9hCQtCiJp
         /a8zU0IqB1a5PFkVIO71nW8vOFQyfvmzrBa5e+y/bIkaSx8OAFqmV0Jvw7W/J3xfdTBG
         mAvtHc1Quj9Bs6vf3J4NI+Fi2bdAh5GDrUnNoyhOl8f9v8bb5sOg425c1unqaXDj0kad
         sJKHBudJqInEYt1KvW5/ptn6QaEcgxikAQVfItlwAxiZajIH/X3qK1WBCABeFeJF/sKC
         viQOgBSkd77iH8Phoe4et2xOHWTmd2Y+721p9vVSTYAf80hsyFnHz5WZzw7YpqIcpWCT
         hHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=juupzti4DjJGDkZymRZ4Hc4aNwh9m6UznVRuz/k6aiY=;
        b=UEU323NrY+uNH03USRGbJMKtBLT4g/obk+N2ie/dnlib+lJiFMZBkjLmo9a/Y23nJW
         Ltri6C5+T8c/Dz1wafsJV6kNm6E3I+A/u4mUXEKAQhWzPndDFvbbkDtEWiNp8ycCmZlg
         hsy4NKA9fbL/k8CyYuuVdpMIUL16cPMR54t3BeXMlZYhxaUF9cqVBjGZSz330ZiZicIT
         WQfIrkZ5Wtc+3QVJZ0ALTd9K/h9DaLCtVRzRsgmR9yozoimeAo9j92faO+icWDwIzz41
         vFDznu8K4aBlmsnLwIbZFmJ/T8gb9RjzUaxDzsbp2EC1tcoNGSKM1+OpQW18OjRedcOX
         NGpw==
X-Gm-Message-State: AOAM5313FHU2h6Q4EFtMQzk3ZjsfA3dhyhcThgvQZMS2f3Ol6V6EQMqz
        SkntFiBUkBktOwkIElnBDvtDwA==
X-Google-Smtp-Source: ABdhPJxHvo/hbTRzG6K/o9EJ08MZoMACr7cc3HKgSc8EzOuNUCLwlGY7c+sN4tTAPxiW2yu8tRFbNw==
X-Received: by 2002:a17:90a:5513:: with SMTP id b19mr267855pji.99.1610474220588;
        Tue, 12 Jan 2021 09:57:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 17sm3821852pfj.91.2021.01.12.09.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 09:56:59 -0800 (PST)
Date:   Tue, 12 Jan 2021 09:56:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Bandan Das <bsd@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <X/3i5Pjg1gEwupJD@google.com>
References: <jpgturmgnu6.fsf@linux.bootlegged.copy>
 <8FAC639B-5EC6-42EE-B886-33AEF3CD5E26@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8FAC639B-5EC6-42EE-B886-33AEF3CD5E26@amacapital.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Andy Lutomirski wrote:
> 
> > On Jan 12, 2021, at 7:46 AM, Bandan Das <bsd@redhat.com> wrote:
> > 
> > ﻿Andy Lutomirski <luto@amacapital.net> writes:
> > ...
> >>>>>> #endif diff --git a/arch/x86/kvm/mmu/mmu.c
> >>>>>> b/arch/x86/kvm/mmu/mmu.c index 6d16481aa29d..c5c4aaf01a1a 100644
> >>>>>> --- a/arch/x86/kvm/mmu/mmu.c +++ b/arch/x86/kvm/mmu/mmu.c @@
> >>>>>> -50,6 +50,7 @@ #include <asm/io.h> #include <asm/vmx.h> #include
> >>>>>> <asm/kvm_page_track.h> +#include <asm/e820/api.h> #include
> >>>>>> "trace.h"
> >>>>>> 
> >>>>>> extern bool itlb_multihit_kvm_mitigation; @@ -5675,6 +5676,12 @@
> >>>>>> void kvm_mmu_slot_set_dirty(struct kvm *kvm, }
> >>>>>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
> >>>>>> 
> >>>>>> +bool kvm_is_host_reserved_region(u64 gpa) +{ + return
> >>>>>> e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED); +}
> >>>>> While _e820__mapped_any()'s doc says '..  checks if any part of
> >>>>> the range <start,end> is mapped ..' it seems to me that the real
> >>>>> check is [start, end) so we should use 'gpa' instead of 'gpa-1',
> >>>>> no?
> >>>> Why do you need to check GPA at all?
> >>>> 
> >>> To reduce the scope of the workaround.
> >>> 
> >>> The errata only happens when you use one of SVM instructions in the
> >>> guest with EAX that happens to be inside one of the host reserved
> >>> memory regions (for example SMM).
> >> 
> >> This code reduces the scope of the workaround at the cost of
> >> increasing the complexity of the workaround and adding a nonsensical
> >> coupling between KVM and host details and adding an export that really
> >> doesn’t deserve to be exported.
> >> 
> >> Is there an actual concrete benefit to this check?
> > 
> > Besides reducing the scope, my intention for the check was that we should
> > know if such exceptions occur for any other undiscovered reasons with other
> > memory types rather than hiding them under this workaround.
> 
> Ask AMD?
> 
> I would also believe that someone somewhere has a firmware that simply omits
> the problematic region instead of listing it as reserved.

I agree with Andy, odds are very good that attempting to be precise will lead to
pain due to false negatives.

And, KVM's SVM instruction emulation needs to be be rock solid regardless of
this behavior since KVM unconditionally intercepts the instruction, i.e. there's
basically zero risk to KVM.
