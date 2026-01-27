Return-Path: <kvm+bounces-69291-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uA5yIeAyeWmNvwEAu9opvQ
	(envelope-from <kvm+bounces-69291-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 22:49:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D5A9AD30
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 22:49:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6700302A7F6
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 21:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C19330B14;
	Tue, 27 Jan 2026 21:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2XPAPOGt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7293732C925
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769550546; cv=none; b=bh2fWrvepI90+j+ijcbNxMfxk/i+KhFXLgJKB4MEc11OKgIEWb23A3vBZof8A4M4ZVzk6Lct8e5s7G7VItdNhbkt93vkaBfNK7F/kAXJiaJBC6UFG3zIKSEX8QFT/3ho7uAm8kg58945nSxTzaUatfG7JC4pi/uJ+hmm3SyCBXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769550546; c=relaxed/simple;
	bh=32/7uNYRgxf/5SrKCtVb6Zp58mIwDfc3pKo10hrxRLc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NmFhla/DUd4CdhdqKbubj83ZNPorzd15OdOyTbZgvwE14Va/waFNsPYr9pvh4KKeET99Te0X/p99uZkh4xxLeGEG0PQyNaJBkGHkSCz9RRdhxO/XpQpM/CJa0XC02LKF6cLLDfClyk+QqF6htz0FZ2On5loqvSf72QYZdm9Z2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2XPAPOGt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c38781efcso5709322a91.2
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 13:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769550545; x=1770155345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RseyKerlNoyh3vi0kxCbLqcOQVQ8xdIGRqnXmOL4o8E=;
        b=2XPAPOGtyG3AtJQcIPOenRqq3cvJ7GjaJdjobyKSp2lvXceiC3M1xYEgNyNEijSyde
         Rmo79lQ/2CHq6OPH6f3NUY126HWI/tN4FkmaBCwHpDwLcF9MTgU/Ds+WCZwiwSigiSCG
         GXn6XVCRt1G6Zl2pcw4IYTL0lisLFEzGpk/8GwFjxa05/NXexEXW8NMzj7WQvALrFwc/
         T14lLVmy1JjcfchCRoJnIlCI5XQwussruJUpyCp93iTCF9YoyM56+7m7Hzkj2ObwzHre
         H0rMrA4l2qWPJqZYbw8tkB0uSmXb4MsSSFshgVVi6XIVhjCl4mTICmK05mIvmv7T1QH8
         lZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769550545; x=1770155345;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RseyKerlNoyh3vi0kxCbLqcOQVQ8xdIGRqnXmOL4o8E=;
        b=emrHD0PY61M6sfyEcm9pLluLJyvRX2XqJRDBM1zsc6T+G+buW+ZCPhT76cNR7qGqBC
         xUEYpTSXTVkoZIMbbsE520URHaxR/MV86+VpommHLPZ34tqRQFqFFpyBE+BDsa9FB+RN
         NEfHWVIWntYgDKWN15WCN8PNz4ogYwQsM18GttDcC59MXrzO67/LZQGF/rYoE0E06p1w
         k0BIfinkFdE0cSivpHsWtw///rWVL04o9qmIKVVjrbMKLaS0+JL5Ev8qMNiSsNwu8KZq
         SLsmmDYw8wD8DxWW4w48VRLkkCwYk3TuDOOYTQS13rsOtk0mB4vfDR/izwvXAYwbS7GM
         HGHA==
X-Forwarded-Encrypted: i=1; AJvYcCVdLORZ4kM9f4D8cv8ohmTnxv/8mqJApH+aDaqG8+Ez2LlhFcD0TOsJgDiUi3a0b2XodeE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhJWqijnM4eZmUeEaby5Sq6fgu02LZsWHTLlG++EQqDtC6aGH4
	uIAVBa5zfT7KO9RdE4g8WFY2mNVS4Zkh/uUERhcTPSVt1rTQlXqgMUf4FeBt6+rQhc2GgO98rmX
	5PObFYA==
X-Received: from pjuy19.prod.google.com ([2002:a17:90a:d713:b0:34a:b8e4:f1b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e2cc:b0:353:39bd:3ad2
 with SMTP id 98e67ed59e1d1-353fecd0958mr1793042a91.5.1769550544803; Tue, 27
 Jan 2026 13:49:04 -0800 (PST)
Date: Tue, 27 Jan 2026 13:49:03 -0800
In-Reply-To: <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123125657.3384063-1-khushit.shah@nutanix.com> <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
Message-ID: <aXkyz3IbBOphjNEi@google.com>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, pbonzini@redhat.com, kai.huang@intel.com, 
	mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69291-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 03D5A9AD30
X-Rspamd-Action: no action

On Tue, Jan 27, 2026, David Woodhouse wrote:
> On Fri, 2026-01-23 at 12:56 +0000, Khushit Shah wrote:
> >=20
> > @@ -4931,6 +4933,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> > =C2=A0		break;
> > =C2=A0	case KVM_CAP_X2APIC_API:
> > =C2=A0		r =3D KVM_X2APIC_API_VALID_FLAGS;
> > +		if (kvm && !irqchip_split(kvm))
> > +			r &=3D ~KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST;
> > =C2=A0		break;
> > =C2=A0	case KVM_CAP_NESTED_STATE:
> > =C2=A0		r =3D kvm_x86_ops.nested_ops->get_state ?
> > @@ -6748,11 +6752,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > =C2=A0		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
> > =C2=A0			break;
> > =C2=A0
> > +		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
> > +		=C2=A0=C2=A0=C2=A0 (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_B=
ROADCAST))
> > +			break;
> > +
> > +		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
> > +		=C2=A0=C2=A0=C2=A0 !irqchip_split(kvm))
> > +			break;
> > +
> > =C2=A0		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
>=20
> Is it possible to set KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
> *then* create the in-kernel I/O APIC?

Nope, we should be good on that front, kvm->arch.irqchip_mode can't be chan=
ged
once its set.  I.e. the irqchip_split() check could get a false negative if=
 it's
racing with KVM_CREATE_IRQCHIP, but it can't get a false positive and thus
incorrectly allow KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST.

