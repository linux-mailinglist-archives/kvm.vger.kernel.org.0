Return-Path: <kvm+bounces-64155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F11C7A680
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 04CDE35BCAD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D025A2C3250;
	Fri, 21 Nov 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ig2Cq5my"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C31E1EB19B
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763737137; cv=none; b=KWK3hDI0hF1u0NPirUI6C1but9HoU1XZ6jzkqkybllou7v5TTB+aMAinK+iStY7BWnk2CLG4P7Txa9eAPK3F9dIe1VBZCnsOXnxWeoD8T4FaZOZKTyecoVqvm0At2WAkToHcdrRbAIQySvbFtgmFCwSSSMnmmMKe+zFSXewxX84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763737137; c=relaxed/simple;
	bh=kQOa/7Vqn/o+DGb1Epy5e3sacOvXgFJLQ8VhQtumi84=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K6s/s+0u2Huj+zGOyuYasrbPfSdJBB02cRKK1s5lDqEx0J72oqoi3GRtvfECVF12WR3GARUvrnTkchTLsfJJ0gC1gACilFu4wDZWJlsIjmv61WLUsm75HpNpeqaJsvMRIGB/3plejq4vmDKhj0y68pI5TCrbb55tFEFZIO+b6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ig2Cq5my; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2982dec5ccbso50447625ad.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763737136; x=1764341936; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOQ6Md0ZoYsLIfnoe91ZJxKLCoMUEeHUzr9dwQ+JQ7k=;
        b=ig2Cq5myyisVEdqlUvcoKfgi8X6jxJrMEHm8tHH5hB+A9aT7xXWEz7J7NhxHzqsBvE
         FlyPKSKUCeMNG2Fkb+S90apNtM/ok589xCQOgLOoOKd8BFhc7hBipWcaoO/Xs3K2GwnD
         +LWOZrN7mMvppDntVr4CyJbUHRxfSL4j/EzV9a48CyB9PsnxOpAkJdPwVTVMMBHFZuxu
         GSzH821N03mBgaEcFE7cgo7yLAi1E/+keTFkRL0iZBPOGPuHOj7KuALz2PXEh1Sxv61d
         PAfG/Oe5+xDes5W0c3OfnwX9Tv3ScgpY2UYsjJT7051/+pt09GNQPD8WBnQQPB4ZOrO4
         240g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763737136; x=1764341936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uOQ6Md0ZoYsLIfnoe91ZJxKLCoMUEeHUzr9dwQ+JQ7k=;
        b=d/LFfiSEThF6T3jpTo/M2g9jxka/nsuz4oKMcA5JgSt84ob9Pc74u/YCU879ha0wxw
         ZSUpxL33rUraS48FQAWvqI1IqrfrVY+w2Y/665ajO5YhJA/HC32K+dro8gFK9NPMv/W/
         jK6jabYp/KdV46S90DERATzRQhroWUE/KNjkyqR7xR0rYoGu67xJsNKKyclEnYxPR72R
         B+mPWWzqzOJ15+4D437FALBqI+MPuT9ZB51AUpo1KIJZHWdFd4m7vgYnuSpoGU14NIul
         vLaeBCLl0g37nZbjUdzCZy9Cow/lnV8lAHClT5vBPz+RRHeucvrgWU/oK423dySWEYeR
         pVRg==
X-Forwarded-Encrypted: i=1; AJvYcCWrRWwjb8mykgTFz4HhNaYHzA1sWsMXediVIT1r75hxv1DLxDq92oUp2wJul1B4mIzu/B0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfD87cC0yvjkqr3oxGnnWEmsZMh25LJGFlT5MZgb0pFK6/uw+i
	GKjt4MsuKBdk0eHL+wg7n1brSTyaEQmhXn8h1TqzENtMmVxqYlTggxx6kuyR0AdNfxtvb+50/zw
	B2A7O6g==
X-Google-Smtp-Source: AGHT+IF9h5oFf5Yj0ERVvTP57cPFeQWYcSTjzk5WJKy+t2KY+UTJyP91sFHwzrMblOiNnxG8TWkWRGNQM14=
X-Received: from pgcb184.prod.google.com ([2002:a63:67c1:0:b0:ba6:5f4d:31c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f706:b0:295:7f1d:b02d
 with SMTP id d9443c01a7336-29b6c50eaa9mr33830385ad.22.1763737135785; Fri, 21
 Nov 2025 06:58:55 -0800 (PST)
Date: Fri, 21 Nov 2025 06:58:53 -0800
In-Reply-To: <1c76cb00-1fe1-4fd0-b7b9-86ddca6115ba@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107093239.67012-1-amit@kernel.org> <20251107093239.67012-2-amit@kernel.org>
 <aR913X8EqO6meCqa@google.com> <1c76cb00-1fe1-4fd0-b7b9-86ddca6115ba@citrix.com>
Message-ID: <aSB-LUfcyx8B9MLr@google.com>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
From: Sean Christopherson <seanjc@google.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, linux-doc@vger.kernel.org, amit.shah@amd.com, 
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de, 
	peterz@infradead.org, jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com, 
	sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com, 
	david.kaplan@amd.com, dwmw@amazon.co.uk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025, Andrew Cooper wrote:
> On 20/11/2025 8:11 pm, Sean Christopherson wrote:
> > The emulation requirements are not limited to shadow paging.  From the =
APM:
> >
> >   The ERAPS feature eliminates the need to execute CALL instructions to=
 clear
> >   the return address predictor in most cases. On processors that suppor=
t ERAPS,
> >   return addresses from CALL instructions executed in host mode are not=
 used in
> >   guest mode, and vice versa. Additionally, the return address predicto=
r is
> >   cleared in all cases when the TLB is implicitly invalidated (see Sect=
ion 5.5.3 =E2=80=9CTLB
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   Management,=E2=80=9D on page 159) and in the following cases:
> >
> >   =E2=80=A2 MOV CR3 instruction
> >   =E2=80=A2 INVPCID other than single address invalidation (operation t=
ype 0)
>=20
> I already asked AMD for clarification here.=C2=A0 AIUI, INVLPGB should be
> included in this list, and that begs the question what else is missed
> from the documentation.
>=20
> >
> > Yes, KVM only intercepts MOV CR3 and INVPCID when NPT is disabled (or I=
NVPCID is
> > unsupported per guest CPUID), but that is an implementation detail, the=
 instructions
> > are still reachable via emulator, and KVM needs to emulate implicit TLB=
 flush
> > behavior.
>=20
> The Implicit flushes cover CR0.PG, CR4.{PSE,PGE,PCIDE,PKE}, SMI, RSM,
> writes to MTRR MSR, #INIT, A20M, and "other model specific MSRs, see NDA
> docs".
>=20
> The final part is very unhelpful in practice, and necessitates a RAS
> flush on any emulated WRMSR, unless AMD are going to start handing out
> the multi-coloured documents...

Does Xen actually emulate guest TLB flushes on all emulated WRMSRs?  A RAS =
flush
seems like small peanuts compared to a TLB flush.

> The really fastpath MSRs are unintercepted and won't suffer this overhead=
.

Heh, if an unintercepted MSR is on the "naughty list", wouldn't that break =
shadow
paging schemes that rely on intercepting architectural TLB flushes to synch=
ronize
shadow PTEs?

