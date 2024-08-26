Return-Path: <kvm+bounces-25067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3479295F900
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F052834E3
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC75A194AEF;
	Mon, 26 Aug 2024 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DjHeUdV9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD40B2C1AC
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724697100; cv=none; b=jQt/ZPoPU5vy6JFkacY4F2N7RjmZweTfCk54cxQijnpe4or1wiRKCaau+44eajramimvm3rqP1i2TbTbMPL6bJHV4lHPLrLzbPiAUi4NWs45Hcn9d4Vqdn1/gbPyGr2KNWyl+vZWcbb0/DP4ladnR9GBt9/i//tNJmG4W4ZlTQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724697100; c=relaxed/simple;
	bh=mLy1vgHmE/jdzt3VgHm2OHzYuPjcX8WTmOb+o6YMWp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cg3Y30yQQ4XempEcU+Ssc34Ent9MOUNe0SlAvP1QBGIgAEiv8EaK5+YgUgnm15Gh+qbtRJOFyUyaRYPgzJBsiykuR2YtcDHA5nuv2Ti/qFt4M2WYMc7ZaPG3Rlt3DtKHJYdU596byQnf7AbmsUPJ0TELBJQQVaP1ryRjEzKG4Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DjHeUdV9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1159fb1669so8080474276.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 11:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724697097; x=1725301897; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oYs4/XGahzBT4qBo/4ZIs3WQHA47MKX2vPkz30h9+7Q=;
        b=DjHeUdV9FoT3RQpj4W+uwfk/mC4nFHRZu3MSPfjKvYp+DWkV4YLCYL9GB1QsxOlcmG
         +HI0UsVVvBarrOKwtsgZcYbIE7DmCOZ8gRPlt0sKlHOQID+5kxljDV5famgWcVML8JLr
         f6KhvcM4NIHzryBrvclanMzx3NPmBuNo6zzyaIjaxMZdnf6lZ88rkjh+koKMyZjeQWWr
         b0M6O0DK4HXPkMuJPlFIvj3iG9H3Ed/tLup/CXjjDY34uK8siz5VCdLArbbZaFp+a2io
         JognSKEHd8T0eFn4DPakVZUp5lCfp/QUF5qxxRiqnEih2X0SCeCTjBzbA5Hwza7lr0Lz
         E7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724697097; x=1725301897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYs4/XGahzBT4qBo/4ZIs3WQHA47MKX2vPkz30h9+7Q=;
        b=Ty6z8V5zmn7lAQInt7lWIUcvTEI2Tq0wORfoqvCN2PbJDM1N8b8Cew57gOkzc/1xx8
         gMQm41KpYq02oSgCGWxAdy9OEI2FpRbRXWAEYvD9kQRZENssj7NjHctMX3nQPJXG38Up
         JI7Udpl5IhDTtq4r0f9J6acMlmsO76WS8fsRfdt+PIIoM6Jwj0MkWiqnA1cJfFEuh20c
         v/Aui3KfBIiSy0rpNJbV0eN5ds4D75xdFuKlBeup1OXo26cDR3NQi3KP2lMEFXG592kN
         9KMGxQPlxAVJPFafQL3NLt6s9TEm+OvxoMWXjF9qDAKusohyXyCpaTMQdoEkIBeGBZTx
         NbHg==
X-Forwarded-Encrypted: i=1; AJvYcCXRh14KZUNbODsf0c839Rl/FskC0AQi2He2MosZN7uIwyt5Sg0ZfDgK8iXicRQNjWo19UI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTbiy5z7zyn/IX98ft1J5wziSbpfwcgfm5usybUhTLmg4I6K0T
	DM3WmQfKSPgrYWRyjBjIhx8czovsYzuIkj1YFC2oaIxHjlggjtNq566N3+16HmV0BA4B2k4C2KN
	U2Q==
X-Google-Smtp-Source: AGHT+IEZVzpeG0G0tHxTLIM7OwZkYTrzg2NvTEAhQlUNRbdJi8Gn+6CbL5ryMGABFu9BH/rPP+zE67W44Ts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3617:0:b0:e13:c772:5c18 with SMTP id
 3f1490d57ef6-e17a866a769mr18546276.12.1724697097393; Mon, 26 Aug 2024
 11:31:37 -0700 (PDT)
Date: Mon, 26 Aug 2024 11:31:36 -0700
In-Reply-To: <5fe11dfb-2a33-4b52-8181-c82bc326b968@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240808062937.1149-1-ravi.bangoria@amd.com> <20240808062937.1149-5-ravi.bangoria@amd.com>
 <Zr_rIrJpWmuipInQ@google.com> <372d5a95-bce5-4c5c-8c74-6b4cc5ab6943@amd.com> <5fe11dfb-2a33-4b52-8181-c82bc326b968@amd.com>
Message-ID: <ZszKCCXE7yT4zCEd@google.com>
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk, 
	peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com, 
	arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn, 
	nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ananth.narayan@amd.com, 
	sandipan.das@amd.com, manali.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 21, 2024, Ravi Bangoria wrote:
> On 21-Aug-24 11:06 AM, Ravi Bangoria wrote:
> >>> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >>>  		if (data & DEBUGCTL_RESERVED_BITS)
> >>
> >> Not your code, but why does DEBUGCTL_RESERVED_BITS = ~0x3f!?!?  That means the
> >> introduction of the below check, which is architecturally correct, has the
> >> potential to break guests.  *sigh*
> >>
> >> I doubt it will cause a problem, but it's something to look out for.
> > This dates back to 2008: https://git.kernel.org/torvalds/c/24e09cbf480a7
> > 
> > The legacy definition[1] of DEBUGCTL MSR is:
> > 
> >   5:2   PB: performance monitor pin control. Read-write. Reset: 0h.
> >         This field does not control any hardware.

Uh, what?  So the CPU provided 4 bits of scratch space?  Or is that saying that
5:2 controlled some perfmon stuff on older CPUs, but that Zen deprecated those
bits?

> >   1     BTF. Read-write. Reset: 0. 1=Enable branch single step.
> >   0     LBR. Read-write. Reset: 0. 1=Enable last branch record.
> > 
> > [1]: https://bugzilla.kernel.org/attachment.cgi?id=287389
> 
> How about adding cpu_feature_enabled() check:

That doesn't fix anything, KVM will still break, just on a smaller set of CPUs.

The only way to avoid breaking guests is to ignore bits 5:2, though we could
quirk that so that userspace can effectively enable what is now the architectural
behavior.

Though I'm very tempted to just add a prep patch to disallow setting bits 5:2 and
see if anyone complains.  If they do, then we can add a quirk.  And if no one
complains, yay.

