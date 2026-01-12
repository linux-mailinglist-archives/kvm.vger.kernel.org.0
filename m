Return-Path: <kvm+bounces-67819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC690D1489C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 16F963019E29
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D5134FF57;
	Mon, 12 Jan 2026 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dbgll+02"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBC83090D4
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768240276; cv=none; b=ixIn+8lT0UsocGCrPv25o5oAMuIpMUcNgKZnhLYDnlSeEjY18tWuCnMwzx2V5eJTp2jwd4pTUknaklnLfVePa2XzMW4S0BSNqfwhR8ZYlo5l77oguCNQ+/qkcEjlWQ9u9HEOTdM+kWJvx0hi9HZFHbhaC+h440WsvV/YgmIUyXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768240276; c=relaxed/simple;
	bh=LrFB4UFo6TPYH27QP3oPdi1iHfmysVG8Hjr8H2qOYPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O+7L+PR+oO0o5qJvdqJGSMMFDelfIAoNg8SmWBj/yQEDZ+Ui0xSdZcldM1N56i7VQC9k+tBOUFKYeLGAvxMyHJCuUvfDTBw+N35Hi6DKBbc+LrZrkoGiViDzPFalWj8EvkhLjo8S22ssEYPy02n9RhTASfBkZbOV8tkJRjNcDRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dbgll+02; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0bae9acd4so49174235ad.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768240274; x=1768845074; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YUR1KrggRucIOKz0xpy1KoutyssE0Qt3ng0v3tUWw8=;
        b=Dbgll+02aQ947bsEInxtseTUnfOEn+A6/rglkKCpDxOsDmJBUTDVdGZCwgIvsorayE
         spxacsCUAlQVuE682kltJ3IC8IK7fWhz6ar7h3vAjDpELfgEVVpp/KUNSLevnBPZZSSd
         ooUHmIvrJP096/v8czH28HVmrMJt1UUCaWaIUFNX8SWB5fLJj3f6hWNJcQHsmh26QFv/
         F+iwM/PwJ8Tx+iUlpEzWdUHvq23Y6rzHGSZU6ORj21IbRWu488bgjlRROFFE4nPaTL7u
         +hWMocpFDmWbtgIgN8Eom65f07Ny8KZqFcd4G9pc5X60cOQTVUtdISnzGLA7XIhkdzVG
         VwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768240274; x=1768845074;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5YUR1KrggRucIOKz0xpy1KoutyssE0Qt3ng0v3tUWw8=;
        b=geEOOKYSjuwlTuBwyGUTqCn4bFJaK8b1d0n/2lepLXkqBP69cvu/PHDUUuuZelzJKz
         QPEsZkSBpBh83GNDEtPJLIiNYvVBLMXfMRTz8As+YKiOoRcJJ6Y17W6YgA1bp4O2TzOm
         HokPR37iBDAJJAf8J7RpMTIT2/ZS3ZLAZP7IJz88T41Mvo9+l1xfEPbPyH2h6FZXQOpx
         Jxh+ZrEnNarb/r0L6AE3d5gqUKcKk3huVllIUX2NMgwSnlTkPCRe9gNg4sqcAr8NUiRH
         mviSqQSm0mgetKcLIAi7RVrehNZSkbOoGTu+/vECm61DfCAWKpPYKfG/L3DXP2Ri8mkA
         xUvA==
X-Forwarded-Encrypted: i=1; AJvYcCXQJT1SLgoEel1P0bYYvitSWC+GV/UmBtxnBT+zT8eb3D8qaacbelOrLVIpnMGv9mb6gM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdcLFPpUCj9x9iNlAkl0Q+2v72IOeQitkcixp2XudG4zPB9Bdx
	ufhE41UYqZz7e9fJM668h6OzBnlJL57AxHLsekzQIgp5J1yXLYGXBU1a1CD3ox3Z9DOnnLk0mpM
	e+M8UVw==
X-Google-Smtp-Source: AGHT+IGtsanUz74PgJV7AAnA6vaG3LCmS5pgi54E5TKj9ojMdiu1/d/IWpd0suoCnfgC8UmHSkaejG7pVEM=
X-Received: from plhz1.prod.google.com ([2002:a17:902:d9c1:b0:29a:1de:14aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:37c3:b0:29f:2734:6ffb
 with SMTP id d9443c01a7336-2a3ee434de2mr164169645ad.22.1768240274529; Mon, 12
 Jan 2026 09:51:14 -0800 (PST)
Date: Mon, 12 Jan 2026 09:51:13 -0800
In-Reply-To: <aR913X8EqO6meCqa@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107093239.67012-1-amit@kernel.org> <20251107093239.67012-2-amit@kernel.org>
 <aR913X8EqO6meCqa@google.com>
Message-ID: <aWU0kWomCX0lrtf5@google.com>
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	linux-doc@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org, 
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com, 
	daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com, 
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com, 
	dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

n Thu, Nov 20, 2025, Sean Christopherson wrote:
> --
> From: Amit Shah <amit.shah@amd.com>
> Date: Fri, 7 Nov 2025 10:32:39 +0100
> Subject: [PATCH] KVM: SVM: Virtualize and advertise support for ERAPS
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> AMD CPUs with the Enhanced Return Address Predictor Security (ERAPS)
> feature (available on Zen5+) obviate the need for FILL_RETURN_BUFFER
> sequences right after VMEXITs.  ERAPS adds guest/host tags to entries in
> the RSB (a.k.a. RAP).  This helps with speculation protection across the
> VM boundary, and it also preserves host and guest entries in the RSB that
> can improve software performance (which would otherwise be flushed due to
> the FILL_RETURN_BUFFER sequences).
>=20
> Importantly, ERAPS also improves cross-domain security by clearing the RA=
P
> in certain situations.  Specifically, the RAP is cleared in response to
> actions that are typically tied to software context switching between
> tasks.  Per the APM:
>=20
>   The ERAPS feature eliminates the need to execute CALL instructions to
>   clear the return address predictor in most cases. On processors that
>   support ERAPS, return addresses from CALL instructions executed in host
>   mode are not used in guest mode, and vice versa. Additionally, the
>   return address predictor is cleared in all cases when the TLB is
>   implicitly invalidated and in the following cases:
>=20
>   =E2=80=A2 MOV CR3 instruction
>   =E2=80=A2 INVPCID other than single address invalidation (operation typ=
e 0)
>=20
> ERAPS also allows CPUs to extends the size of the RSB/RAP from the older
> standard (of 32 entries) to a new size, enumerated in CPUID leaf
> 0x80000021:EBX bits 23:16 (64 entries in Zen5 CPUs).
>=20
> In hardware, ERAPS is always-on, when running in host context, the CPU
> uses the full RSB/RAP size without any software changes necessary.
> However, when running in guest context, the CPU utilizes the full size of
> the RSB/RAP if and only if the new ALLOW_LARGER_RAP flag is set in the
> VMCB; if the flag is not set, the CPU limits itself to the historical siz=
e
> of 32 entires.
>=20
> Requiring software to opt-in for guest usage of RAPs larger than 32 entri=
es
> allows hypervisors, i.e. KVM, to emulate the aforementioned conditions in
> which the RAP is cleared as well as the guest/host split.  E.g. if the CP=
U
> unconditionally used the full RAP for guests, failure to clear the RAP on
> transitions between L1 or L2, or on emulated guest TLB flushes, would
> expose the guest to RAP-based attacks as a guest without support for ERAP=
S
> wouldn't know that its FILL_RETURN_BUFFER sequence is insufficient.
>=20
> Address the ~two broad categories of ERAPS emulation, and advertise
> ERAPS support to userspace, along with the RAP size enumerated in CPUID.
>=20
> 1. Architectural RAP clearing: as above, CPUs with ERAPS clear RAP entrie=
s
>    on several conditions, including CR3 updates.  To handle scenarios
>    where a relevant operation is handled in common code (emulation of
>    INVPCID and to a lesser extent MOV CR3), piggyback VCPU_EXREG_CR3 and
>    create an alias, VCPU_EXREG_ERAPS.  SVM doesn't utilize CR3 dirty
>    tracking, and so for all intents and purposes VCPU_EXREG_CR3 is unused=
.
>    Aliasing VCPU_EXREG_ERAPS ensures that any flow that writes CR3 will
>    also clear the guest's RAP, and allows common x86 to mark ERAPS vCPUs
>    as needing a RAP clear without having to add a new request (or other
>    mechanism).
>=20
> 2. Nested guests: the ERAPS feature adds host/guest tagging to entries
>    in the RSB, but does not distinguish between the guest ASIDs.  To
>    prevent the case of an L2 guest poisoning the RSB to attack the L1
>    guest, the CPU exposes a new VMCB bit (CLEAR_RAP).  The next
>    VMRUN with a VMCB that has this bit set causes the CPU to flush the
>    RSB before entering the guest context.  Set the bit in VMCB01 after a
>    nested #VMEXIT to ensure the next time the L1 guest runs, its RSB
>    contents aren't polluted by the L2's contents.  Similarly, before
>    entry into a nested guest, set the bit for VMCB02, so that the L1
>    guest's RSB contents are not leaked/used in the L2 context.
>=20
> Enable ALLOW_LARGER_RAP (and emulate RAP clears) if and only if ERAPS is
> exposed to the guest.  Enabling ALLOW_LARGER_RAP unconditionally wouldn't
> cause any functional issues, but ignoring userspace's (and L1's) desires
> would put KVM into a grey area, which is especially undesirable due to th=
e
> potential security implications.  E.g. if a use case wants to have L1 do
> manual RAP clearing even when ERAPS is present in hardware, enabling
> ALLOW_LARGER_RAP could result in L1 leaving stale entries in the RAP.
>=20
> ERAPS is documented in AMD APM Vol 2 (Pub 24593), in revisions 3.43 and
> later.
>=20
> Signed-off-by: Amit Shah <amit.shah@amd.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Applied to kvm-x86 svm.

[1/1] KVM: SVM: Virtualize and advertise support for ERAPS
      https://github.com/kvm-x86/linux/commit/db5e82496492

--
https://github.com/kvm-x86/linux/tree/next

