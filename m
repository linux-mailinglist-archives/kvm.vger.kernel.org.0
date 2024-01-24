Return-Path: <kvm+bounces-6858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2A083B1B6
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 20:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E8A11C238AB
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 19:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80944131E46;
	Wed, 24 Jan 2024 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kBZmiRAv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8812AADA;
	Wed, 24 Jan 2024 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706122932; cv=none; b=Hu3J9LNTwysJ02sfsuPRQIiIFwr+RUKQg293GDAKkFxj/gI6cVIrHDu+K5/Ql6PyflRL4Wo9h2sCvrNGbRJu26H6smCy3dg3+KqVGHkBnM2V4Vxe0x1AJCQXTsJQpIkqTDZdQhZwtYGTvZ11gKYwSEX3MjP6RKQlYOMCN31xqUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706122932; c=relaxed/simple;
	bh=Z5LHA3KO/IElNz60krWfZQZYfSUzZ5zOKhAj36Daqa8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SwUt9I9G5XTFdcUQCkKpsjsk6+h7YCmQCom/ujIFLsJeuo2Rqsgihp6iM9eEYzJZnu96ZFF1Zf8+AfojhdwosGH6wGAnmDF6m0109qwMXnbUonViO/rtqd7BA/8jYfP91BKfacfHp9U+HsSDWPASBPak6eXM1BAppR52FrsTKcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kBZmiRAv; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-290b1e19101so2402931a91.0;
        Wed, 24 Jan 2024 11:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706122931; x=1706727731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YL70uPYw3iC0KrQMlpVNvFT6gCBu7Ww1Ci4N5SVbXQ=;
        b=kBZmiRAvftDKZhaQxiW4p8cSbNTkjdyCEQFzx37Wlz3J4MSwcVdfbEu9SR7E9NF/za
         2Z0DB5CHvsKxpHuPgcJtNzzW45+3IuxtKOemt8IEy3WoK8DMJGMxJEh91NDrWniYMVS1
         o5NoPMUjk/CwcPpBx7E1CXbuLcFvb68BxHstYLbxuhpCIYnWP1ocXDdWOhj20faTNLWh
         la6FMpzFqQRcYuRRKbywahgMKI2YFSHWeQdWfoKuJ5Pdb53AkmmhAB7Ll/cxZFmH37kK
         ZSfEBHPvQ581G6M+jAwrU8RoM5vsksPXTILXWRBociARmSrksRYgoQaE08O6HQyS3bKJ
         8RHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706122931; x=1706727731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/YL70uPYw3iC0KrQMlpVNvFT6gCBu7Ww1Ci4N5SVbXQ=;
        b=Nd6fkqJ0k4KrthoC387ZNb2XICN2O192rDXkV/5fYh2HQ03PG7nWECdSliLdMv1/pn
         0MPeS7P5xUmxKdc4bJMT0RiwhXPLDYArTFLjKfSGZ8Yh9RhPmEHxVmvMJM9vmqIQTDNA
         7eps5b3C9nFMdQvuJUqiN4tlG47cI+CaiAK5ehmnH+xTSXXjeaApm9bAPpYy3fIk31nN
         L4YCmduDMPxpYu4LBVqrIQ/5JhZVYkG4CTlVTdFNwbDmgVnDS/5i9NW+1yjl0LM8DpnT
         GDFf4wzCG0Y7pnsQpcFmU4AsKa8wcVtroM2jaTOP1ixjPqWXOHBWeMDWdDKJijvuIt15
         e5cg==
X-Gm-Message-State: AOJu0Yz/Vqx5yG4W8QV/N0TEA4XTmQ/de2kFseyQ7Ala6BV0WJdNiy7g
	BQlW4ZmtolTckp03Qx9sEKWbk19yPQ+5pVnDZPIUzmrZFWY7f8a8
X-Google-Smtp-Source: AGHT+IGoiiFDiz3y6/A5EPti1fn5hvZGCgFJ+K1iBr935lLKy1llsoOUvq4GOcK+jq6iIYVM0gLnmw==
X-Received: by 2002:a17:90a:38a3:b0:28d:a535:ca23 with SMTP id x32-20020a17090a38a300b0028da535ca23mr107433pjb.20.1706122930641;
        Wed, 24 Jan 2024 11:02:10 -0800 (PST)
Received: from localhost.localdomain ([117.177.61.99])
        by smtp.gmail.com with ESMTPSA id sc2-20020a17090b510200b0028ce12f8cdasm14174138pjb.10.2024.01.24.11.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 11:02:10 -0800 (PST)
From: Brilliant Hanabi <moehanabichan@gmail.com>
X-Google-Original-From: Brilliant Hanabi <moehanabichan@outlook.com>
To: seanjc@google.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	moehanabichan@gmail.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: Re: Re: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
Date: Thu, 25 Jan 2024 03:01:58 +0800
Message-Id: <20240124190158.230-1-moehanabichan@outlook.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZbFMXtGmtIMavZKW@google.com>
References: <ZbFMXtGmtIMavZKW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, Jan 25, 2024, moehanabi wrote:
> > > On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > > > As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> > > > KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> > > > support via KVM_CREATE_IRQCHIP.
> > > > 
> > > > Without this check, I can create PIT first and enable irqchip-split
> > > > then, which may cause the PIT invalid because of lacking of in-kernel
> > > > PIC to inject the interrupt.
> > > 
> > > Does this cause actual problems beyond the PIT not working for the guest?  E.g.
> > > does it put the host kernel at risk?  If the only problem is that the PIT doesn't
> > > work as expected, I'm tempted to tweak the docs to say that KVM's PIT emulation
> > > won't work without an in-kernel I/O APIC.  Rejecting the ioctl could theoertically
> > > break misconfigured setups that happen to work, e.g. because the guest never uses
> > > the PIT.
> > 
> > I don't think it will put the host kernel at risk. But that's exactly what
> > kvmtool does: it creates in-kernel PIT first and set KVM_CREATE_IRQCHIP then.
> 
> Right.  My concern, which could be unfounded paranoia, is that rejecting an ioctl()
> that used to succeed could break existing setups.  E.g. if a userspace VMM creates
> a PIT and checks the ioctl() result, but its guest(s) never actually use the PIT
> and so don't care that the PIT is busted.

Thanks for your review. In my opinion, it is better to avoid
potential bugs which is difficult to detect, as long as you can
return errors to let developers know about them in advance, although
the kernel is not to blame for this bug.

> > I found this problem because I was working on implementing a userspace PIC
> > and PIT in kvmtool. As I planned, I'm going to commit a related patch to 
> > kvmtool if this patch will be applied.
> > 
> > > > Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
> > > > ---
> > > >  arch/x86/kvm/x86.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 27e23714e960..3edc8478310f 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > > >  		r = -EEXIST;
> > > >  		if (kvm->arch.vpit)
> > > >  			goto create_pit_unlock;
> > > > +		if (!pic_in_kernel(kvm))
> > > > +			goto create_pit_unlock;
> > > 
> > > -EEXIST is not an appropriate errno.
> > 
> > Which errno do you think is better?
> 
> Maybe ENOENT?
>

I'm glad to send a new version patch if you're willing to accept the
patch.

