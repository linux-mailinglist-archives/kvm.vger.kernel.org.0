Return-Path: <kvm+bounces-53679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E6BB15577
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 603AF7A23FB
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEED627FD62;
	Tue, 29 Jul 2025 22:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qt+YBH7D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B1C1DE2BC
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829692; cv=none; b=aGPfNqgQcXvdVj8m9AGg/1sD+zYOLEDXC7M77JKCDyrElJiuBEnz+/b/AZOvMbxhiJehL0mPtEcobzKieDobioYMf9LLPip/byqVt76xDyZw5QdVhATx64ybrjIwbOES81JYbBqe667EqU5z5QyPLQqncwpNwoHxMH6mdTj8pcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829692; c=relaxed/simple;
	bh=+s0ingcyIynwN0QqOokA30dWONviuLrNc+vRCAq2gq4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dGUHkTVBB3nO3znDcGmgJa4wR1PsK7NRbxopfpAZ4e7oLRJU0sdArlhn9j2c5axDrUwpfxb/mTaq9npMS0X/dkjyg96299K5rKiSYfA/TWaRt45yp5nlnHxWll1AaBKDG04HnbqI/4HmAmQ74vMPOq9hafIO+h1rlW/Rj1RW204=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qt+YBH7D; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso10558121a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829690; x=1754434490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9IvAMOvcbhlU5W8QZLEdB4U1p9VX42TgZ9WfVdMPu+g=;
        b=qt+YBH7DMRHHreQ3JDdR2401Sj90Vmk2ODCZAkYUu1CBx9N85IlITSKpU8fY80LXEC
         CJlA6vr6oAIhj9l4BtbfBNd7hkgMlXWm5m9+V1K6n6Tt0aDiVk+B5Qzi85vLtbOCvFdG
         XVbFuDLWqNhTnxTPsmCObh8++IdNZL9O/urXc87KuYrunJ+qy9bZfgvWcpiPYB+3mpqf
         egSzqa8/jpWncJr35+Ibp27iRQddtBXBaRZSWNt1ag34odp5YH3EUwotXwXyXksXRfdG
         ejguwq/Gy4dpW7Wclfo3xkvwacKVYSBjhjVCF7XmJYDG7S6BZ+2SNEWx8khJ134Mz94l
         Vrug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829690; x=1754434490;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9IvAMOvcbhlU5W8QZLEdB4U1p9VX42TgZ9WfVdMPu+g=;
        b=XSjXlb5UJRBrQcUbpMqekCvpi0+4Xg0WoIegoUorYnWl+lxurw0HPZIJ3vdLywjJKI
         LacKxWglV0n1JDkPLSga8wU3hzIX4c5kjiVSqgTVxLw7XtgQHkYGqOfFqsSTEkyCocbE
         ZJgEkySMbFTOhomq4ga4JB1AB3L847v3mYIEuryszuPELkzZuXKV9O0pffGCf1SxY1kH
         sMZs2GoYqHJrpnOQdn0qYyLZAOiKpyTtDZiI6JgzlxgM7NPemqEGC2ICWjpFa2yqP2Lu
         +TY7aEVrEdyy/bYC1foEn4NFVnaN5mYpm7oIN8DfAUWxkPYRIC94txTrXEzrGcojVF7a
         ojQg==
X-Forwarded-Encrypted: i=1; AJvYcCVb6x4jQQzUU4B7c51shjzf392eo+8OFcIweIwUjSRYn6YVYEXrwojrMdj/cItDIqMOh+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YweQ57DUe3eCQVG3bIkLA1HufPNQ9GAEaNqEY0XEsVh29NKc+y9
	vUDn5WEcsUQXUQ3SINyRsSjXz08g7QRnm7WrAMo/dALPsTL2e/LehFcYKho4G4uv1MNqI8hnXf2
	sT6PV8A==
X-Google-Smtp-Source: AGHT+IGQQ1/q92PLrkeNoYQwXKazYVHZno9fNiuzRJmcVNPJlU7fDI+A2fWwC+0aM4sd5YoKaOkjLYsx6S8=
X-Received: from pjk12.prod.google.com ([2002:a17:90b:558c:b0:31f:3227:1738])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0c:b0:311:abba:53d2
 with SMTP id 98e67ed59e1d1-31f5de42527mr1515007a91.17.1753829689699; Tue, 29
 Jul 2025 15:54:49 -0700 (PDT)
Date: Tue, 29 Jul 2025 15:54:48 -0700
In-Reply-To: <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com> <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
Message-ID: <aIlRONVnWJiVbcCv@google.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Adrian Hunter <adrian.hunter@intel.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-29 at 12:33 -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3e0d4edee849..c2ef03f39c32 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_v=
cpu *vcpu)
> > =C2=A0
> > =C2=A0	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
> > =C2=A0		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
> > -			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
> > -				gpa, vcpu->vcpu_id);
> > -			kvm_vm_dead(vcpu->kvm);
> > -			return -EIO;
> > +			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
> > +			return -EFAULT;
> > =C2=A0		}
> > =C2=A0		/*
> > =C2=A0		 * Always treat SEPT violations as write faults.=C2=A0 Ignore t=
he
>=20
> The vm_dead was added because mirror EPT will KVM_BUG_ON() if there is an
> attempt to set the mirror EPT entry when it is already present. And the
> unaccepted memory access will trigger an EPT violation for a mirror PTE t=
hat is
> already set. I think this is a better solution irrespective of the vm_dea=
d
> changes.

In that case, this change will expose KVM to the KVM_BUG_ON(), because noth=
ing
prevents userspace from re-running the vCPU.  Which KVM_BUG_ON() exactly ge=
ts
hit?

