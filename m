Return-Path: <kvm+bounces-31135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BB79C0A0B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D531C21FB6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5900A213149;
	Thu,  7 Nov 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3bD8yNNH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B7212F13
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993107; cv=none; b=gpO8Od4+xQcQTz4Vy4MsBjsTHAGW/UUXOswGxRR1pxzZRkK/OmVMMsXqP/AL0h654LqaiGyqHSvAJSMzk/IzdtWrwesGqTiqdt95x+HZkyQ+vvMKRuq18lEA1/FDaPRz5z/Bgwg4y8/1FiumPi/E51xgqjf0VF1eZvXNgWlBZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993107; c=relaxed/simple;
	bh=p7dJkGag38x6jmOuugAhlDPsy/e762twANsn0sug05U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ic8M4AUOY+55WkmEnYdxodo3X3djQNrgNC2jpMzFukw8cVegcRgF0QWh096q+5UmHT44fxk6AITeYTkQ3NOFS4m307Uq9I15xmacAR5WHg1tD5Pz8CPSVnzmf6Vy/p2vbFNtB2Pn9YpVS7b3AUapSXrcoz2zUa0MxK87+KecSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3bD8yNNH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20e5ab8e022so10542895ad.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 07:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730993105; x=1731597905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1i/NT8kDl1I5UdgWhggo9LMsrphRB6xVVGaoWe7u/PI=;
        b=3bD8yNNHMf3Z0rhlkjYiO7Z61ASVi7kElXwKRUwomA5rES/Y9NQwcIB0UXIPDb4W1W
         qnyiQK8/LrIXtRi47P5eyGgMoOpxpHjZhkNa68cFmmVx5E1YoxMVr2O3mEZjpjHmVKuP
         CQ4TPQvIrOfsE+X+u62u/F3IBQtbl+3lQKAlurCZovPDpBYxTLYV6uOxyi4onIrPf0sf
         z1PVG9G/dkYfoANmoFcl1A582Qt6MU/xGbrVwqq240ORF+tAV+qYhCU7tSPqSdVCWKpC
         2XC5DFXRK/JskBiKBbd272wFcrDlwxO7iEZwtq8srEcKIFdZT3HNNOwfoRP+XZ+xVU+b
         j9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730993105; x=1731597905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1i/NT8kDl1I5UdgWhggo9LMsrphRB6xVVGaoWe7u/PI=;
        b=CdVl4OSDOiRpKioTg0Nb4/42I57ik+vJl6d+bcK0iyRaR9UszH6VWRW8BKuAihPOic
         xHhel7v2FnkTXJnwGOURQ9lUoPnDSKX34MT2DC78TfOFX8Qb2dR0X6Rg82Ht1kLSeK4y
         MvlgR7wTnaKqluej2L5yrwLDFGr3Z+g+cTcWUP+NsXn1ZF2ouA+tT7reXpXrygY4k3ol
         p6VhKetS980GYlssxwy/hJczIfHrdpuoly/rK2d1yryS2AKw5QyyMUI0O8Hdql8X98uA
         3BLVOR/jmN6L8qNJuQHroxQSrlWrg9+M/6iq5q1bCYhzwNf2UKzxm7zknu7ZIjIBMTOf
         ykGg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ2H/yrDMVbSE56lb4ArYXnRS0vZedQ3eqEeqsGsUvKdyAJckLLsw5rNtglX7BZPmOluM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSZpUfI7I8j8/2aADHi2qrR+aVvKPBKVvld/QmAXG92+gB9Of3
	Oj4sGqwxP629lKel5efEb6Vf7QLRMQkc/E6nMEA0bX8QnppFQlEY/HMOLF12VnazQ8JYnYcETrV
	j+w==
X-Google-Smtp-Source: AGHT+IHPf44zPu0w6mRTvI9zgBOzfAIWQRG6xMMazGzKoTTtcnxVL4NPfPHzTXy46v9QHxXsNcsXsXr29n0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:22cf:b0:20c:857b:5dcb with SMTP id
 d9443c01a7336-210c6c1493amr8234475ad.4.1730993105409; Thu, 07 Nov 2024
 07:25:05 -0800 (PST)
Date: Thu, 7 Nov 2024 07:25:03 -0800
In-Reply-To: <ZyxJMoYMfQKug02q@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101193532.1817004-1-seanjc@google.com> <Zymk_EaHkk7FPqru@google.com>
 <ZytLLD6wbQgNIHuL@intel.com> <Zyt1Cw8LT50rMKvf@google.com> <ZyxJMoYMfQKug02q@intel.com>
Message-ID: <ZyzaxakxCPMxT7Hs@google.com>
Subject: Re: [PATCH] KVM: x86: Update irr_pending when setting APIC state with
 APICv disabled
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yong He <zhuangel570@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Chao Gao wrote:
> On Wed, Nov 06, 2024 at 05:54:19AM -0800, Sean Christopherson wrote:
> >On Wed, Nov 06, 2024, Chao Gao wrote:
> >> >Furthermore, in addition to introducing this issue, commit 755c2bf87860 also
> >> >papered over the underlying bug: KVM doesn't ensure CPUs and devices see APICv
> >> >as disabled prior to searching the IRR.  Waiting until KVM emulates EOI to update
> >> >irr_pending works because KVM won't emulate EOI until after refresh_apicv_exec_ctrl(),
> >> >and because there are plenty of memory barries in between, but leaving irr_pending
> >> >set is basically hacking around bad ordering, which I _think_ can be fixed by:
> >> >
> >> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> >index 83fe0a78146f..85d330b56c7e 100644
> >> >--- a/arch/x86/kvm/x86.c
> >> >+++ b/arch/x86/kvm/x86.c
> >> >@@ -10548,8 +10548,8 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >> >                goto out;
> >> > 
> >> >        apic->apicv_active = activate;
> >> >-       kvm_apic_update_apicv(vcpu);
> >> >        kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
> >> >+       kvm_apic_update_apicv(vcpu);
> >> 
> >> I may miss something important. how does this change ensure CPUs and devices see
> >> APICv as disabled (thus won't manipulate the vCPU's IRR)? Other CPUs when
> >> performing IPI virtualization just looks up the PID_table while IOMMU looks up
> >> the IRTE table. ->refresh_apicv_exec_ctrl() doesn't change any of them.
> >
> >For Intel, which is a bug (one of many in this area).  AMD does update both.  The
> >failure Maxim was addressing was on AMD (AVIC), which has many more scenarios where
> >it needs to be inhibited/disabled.
> 
> Yes indeed. Actually the commit below fixes the bug for Intel already. Just the
> approach isn't to let other CPUs and devices see APICv disabled. Instead, pick
> up all pending IRQs (in PIR) before VM-entry and cancel VM-entry if needed.
> 
>   1 commit 7e1901f6c86c896acff6609e0176f93f756d8b2a
>   2 Author: Paolo Bonzini <pbonzini@redhat.com>
>   3 Date:   Mon Nov 22 19:43:09 2021 -0500
>   4
>   5     KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
>   6
>   7     If APICv is disabled for this vCPU, assigned devices may still attempt to
>   8     post interrupts.  In that case, we need to cancel the vmentry and deliver
>   9     the interrupt with KVM_REQ_EVENT.  Extend the existing code that handles
>  10     injection of L1 interrupts into L2 to cover this case as well.
>  11
>  12     vmx_hwapic_irr_update is only called when APICv is active so it would be
>  13     confusing to add a check for vcpu->arch.apicv_active in there.  Instead,
>  14     just use vmx_set_rvi directly in vmx_sync_pir_to_irr.

Ah, right, and that approach works because the posted interrupt notification IRQ
is guaranteed to cause a VM-Exit, and KVM keeps the destination CPU in the PID
up-to-date even if APICv is inhibited.

But on AMD, the GA log interrupt is per-IOMMU and so isn't affined to the CPU on
which the vCPU that generated that log entry is running, i.e. won't force an exit
on the destination.  Oh, and the vCPU's entry in the IPI virtualization table
needs to be marked as not-running so that the sender is forced to exit and kick
the target.

In theory, kicking the target vCPU in avic_ga_log_notifier() would allow keeping
the associated IRTEs in guest/posted mode.  I'm mildly curious if that would
yield better or worse performance/latency than going through the per-IRQ handler.

