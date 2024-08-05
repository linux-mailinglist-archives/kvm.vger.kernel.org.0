Return-Path: <kvm+bounces-23237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01977947F4F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 332B61C20752
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D5215C158;
	Mon,  5 Aug 2024 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qY6MB4L5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A09715B13A
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722875173; cv=none; b=JYTq06I0DkyaxxhfXMXyUWKEoeMBfG8KN/UQKYzWX+bQB4q7TI2qVNozZbHvlW9zzB7DrMsV5A1hyPMfLJvR9bc1uyAEZadSElMOIf+Oa8F7tG88JLBWXZExzGO2DKCGo9zmTD49S2aw2fqgzAgGF9Cpa39PBV22AN4S27VBv4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722875173; c=relaxed/simple;
	bh=V7wy/IY78ADKe6MCQ9wGcOxH7LMu1vqwY8ggZZNETsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kBXa4kXHbzsx2xVXp6fJ5p4d8sqHNF+UD36V/aLSw8xxzOxHTLUYeXv/jqmIISAlREFrV2feGFtHsHS3pRVjSFcgnsp8YpPrdkbC1juZThSa2rl27gBGuiSejgN20AjfEEpr1oPwmUPYJsBXkFlKklDXykFLoz4vv35Q/Aesyi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qY6MB4L5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a1188b3bc2so8919897a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722875171; x=1723479971; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LTrtRaPSzzv6povC2MZbVu/ikbGDz5GKGualsN8e2oo=;
        b=qY6MB4L5Lwi31rkl+bvZzaYqBl+XPnHuBcWu5CE/d5szt00UxkuBzG5B57wDEWIu3t
         LKHInBSXlHPHHBGu/pjLj7TcU7pxyqA6+Yzvt0ZyRdzli5o134jHG00eYiuRTbrS/egD
         ej9nZUtxAEv0zwPXH5nABT6eC99x2dTFkIiLfG7AS3OLOnEOzrFK/fVgbtmKve8jKmfJ
         rI68daVLPCdmtx84mBWJiXYGbImLInBKB+wf6zAfcEvuW+pykNoqAcq0TMX/ACvSEi9H
         zZxJHYXJFf3BUAz0PLu/u3WtF46zY63dmR/mU5+As4zbGHyIQ8PMHJYlsS5HT30kDbAj
         L5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722875171; x=1723479971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTrtRaPSzzv6povC2MZbVu/ikbGDz5GKGualsN8e2oo=;
        b=ADsGvsUooxDf2nfAT5FnCeI3UEAg1hTriFuL0dYQiRrsRmxJSvimU4yCMO4T52iqIv
         SgzwztppNGmVUB2wmktNOg4pF2CwMgyOygAOXewrMgHbA8pRmLT8IK7PDt8KfNuSaTV/
         aJBU4EyE6M7T3vgLraBacBLt4CEv6UEjvj+ytnTMlqV6b0WK2KOnaEzhtWK9D9/tTjjE
         YoDG6gdzIUmCVx2Aw1H5j1GVaBTlKCHqDCthT6yrZMGhlOxSxGw7wRrcvx9rBT0e4K14
         sncz8vcBJSTLhwyaPZh7vsxFO3htnUacSY8wpCgu2iamGHEp6DuX0pLIvK9PS+4UUNq5
         NLnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAyvOqdGW2p0SI4uQM5VDZyVzCGpFf5AVFW1GJ5iIql4m3N4i0QMhdO5P3XI7hiUcWCT3Ct+jors/PpDIL68tfP7z9
X-Gm-Message-State: AOJu0YzRT4Tut0aXFI+uzwMqHrZDnlM+Z6r2vQyNa9rVyOIaKoDg77tS
	aT69FWGADgKYX5FNZugj7kbSh9ac7x4tQdBT+gmQ5kH9Swbm+Cs5KmXFErkTaOMlhiap+EXGO90
	74Q==
X-Google-Smtp-Source: AGHT+IEw6cjRWnePzyF97nk0/YCd4IV9HttqCP5c4LXLKTNvkvgZNp5EEi3fIHSWkDuAjgZYuZu0HrMv3+A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3f41:0:b0:7a1:2fb5:3ff7 with SMTP id
 41be03b00d2f7-7b7438b1dc8mr27331a12.0.1722875171415; Mon, 05 Aug 2024
 09:26:11 -0700 (PDT)
Date: Mon, 5 Aug 2024 09:26:04 -0700
In-Reply-To: <eaa907ef-6839-48c6-bfb7-0e6ba2706c52@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802202941.344889-1-seanjc@google.com> <20240802202941.344889-2-seanjc@google.com>
 <eaa907ef-6839-48c6-bfb7-0e6ba2706c52@rbox.co>
Message-ID: <ZrD9HHaMBqNGEaaW@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Make x2APIC ID 100% readonly
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Haoyu Wu <haoyuwu254@gmail.com>, 
	syzbot+545f1326f405db4e1c3e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Aug 04, 2024, Michal Luczaj wrote:
> On 8/2/24 22:29, Sean Christopherson wrote:
> > [...]
> > Making the x2APIC ID fully readonly fixes a WARN in KVM's optimized map
> > calculation, which expects the LDR to align with the x2APIC ID.
> > 
> >   WARNING: CPU: 2 PID: 958 at arch/x86/kvm/lapic.c:331 kvm_recalculate_apic_map+0x609/0xa00 [kvm]
> >   CPU: 2 PID: 958 Comm: recalc_apic_map Not tainted 6.4.0-rc3-vanilla+ #35
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
> >   RIP: 0010:kvm_recalculate_apic_map+0x609/0xa00 [kvm]
> >   Call Trace:
> >    <TASK>
> >    kvm_apic_set_state+0x1cf/0x5b0 [kvm]
> >    kvm_arch_vcpu_ioctl+0x1806/0x2100 [kvm]
> >    kvm_vcpu_ioctl+0x663/0x8a0 [kvm]
> >    __x64_sys_ioctl+0xb8/0xf0
> >    do_syscall_64+0x56/0x80
> >    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >   RIP: 0033:0x7fade8b9dd6f
> 
> Isn't this WARN_ON_ONCE() inherently racy, though? With your patch applied,
> it can still be hit by juggling the APIC modes.

Doh, right, the logic is unfortunately cross-vCPU.  The sanity check could be
conditioned on the APIC belonging to the running/loaded vCPU, but I'm leaning
towards deleting it entirely.  Though it did detect the KVM_SET_LAPIC backdoor...

Anyone have a preference, or better idea?

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..67a0c116ebc0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -352,7 +352,8 @@ static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
         * additional work is required.
         */
        if (apic_x2apic_mode(apic)) {
-               WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)));
+               WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)) &&
+                            vcpu == kvm_get_running_vcpu());
                return;
        }
 


