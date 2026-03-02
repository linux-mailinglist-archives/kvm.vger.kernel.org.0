Return-Path: <kvm+bounces-72408-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHdsMb3XpWmuHQAAu9opvQ
	(envelope-from <kvm+bounces-72408-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 19:32:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DC71DE68E
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 19:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 75296302E7FD
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 18:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDD934FF6C;
	Mon,  2 Mar 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YxNB+z6a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264BA34250E
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 18:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772476344; cv=none; b=pC4eq3JMXhnpE7DfwpMOh93Zlrfez7ViLfoApI1Kb3AJ6/zLdVD9+WlJUwXyoyTmWNO2ktblyDyEkjQB5y9scFMQNH6lt6MeZqFKRY/INL1nKOEx1SJWoLclQfzKSKvWjwCdbbNpfR4dfrCe5X1ekFvdgDQuWRLTpBCRFL/TBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772476344; c=relaxed/simple;
	bh=2UhGjQu+VQRXM2/9fNEm8gXzs8rDwPUHo//z+dwv8+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UZfipMoZevTVxtft6dhsCain82vC/8kCns0vVFRsZK1jW8fjlOmSllyLP+eQ6ehjaOf82rGgDV2oY1ed5wh8DWBWuJMutmBToPrgmS60XG3rJpE0JlTbKYBcdHa0SN5ODZNexoerBUk4HrwQZQGtwI3Q+OFtsN+skwUZwPMPbxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YxNB+z6a; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70f137aa4aso2801751a12.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 10:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772476341; x=1773081141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=99qbGvoBd/oUypUr1ElAkaUmFzKfhUf+q3r8gcDVjGE=;
        b=YxNB+z6aYDVdzFaoyhQig5/QPvS4ZVF25Ya7feEdZkCHmyWs+hZLKTAvAeWaBkGFTl
         2qQ5ahWAO4HM0nZaP0EFCxq8yAHEawNMapQ9fnbgr8s1uhyw0eUP+iZJgeJJsq8/bTXm
         LvNGY51hVUUxw+JXVsJhzNjYZg7y6BZwBQTdWR7PmkVKr6be39vyJjN1R7YQTRi2es5F
         oylE8RUe39BLzVdzbCSrkXPUAceXMGFp1ETu64FcggMgfBstl6tPJIbm2Q0lfW7gKHU8
         cndxLHnZiFPI3UGStvxDXr23UMDuwBpyr3fSZL6dKkk4B5cgEAuEYvVH5ANAZ5iV/tKp
         xPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772476341; x=1773081141;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=99qbGvoBd/oUypUr1ElAkaUmFzKfhUf+q3r8gcDVjGE=;
        b=nSCSjU5qj+U9bj9uuZmVgtJXSFVWJPEtkpj6RGbcUSOwHweaV3yLRRUcwqTaYkrPAX
         Mx0o9aKB/VaFrt85o1g9ZZuQTRNVf07dukAvHiKtJo1A3CTdFGEaotTLw7snzKxRQHze
         gV8QqfM2jEm1T96PyjbbnKdzdEfoukDAwYMmNA91usSzp0k60QGQHc0iGgd2TqBuf67w
         NL6S/cxEp4vUgxnCJkZfTJazZ6/5nkvS2SBWdIRtyactBkNuInY1SLsVIeXs/4kHV7jR
         n0venBJI5Iur6QhoSeWsZFj1ZEh6vm1tDbO0WvFLmRlj7xmnsTcLWcqh7didC7JRPUQj
         EG1g==
X-Forwarded-Encrypted: i=1; AJvYcCWlQhbnPwwWjgV5bVR2E4QzjPVvE3IUNieJLSdSbRQx7Y8hGC4eClDa2lddYPYGFFq/SYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKTXsEzWVoZ/GT3Aj+syQ3HJMEcoeJ7syr8/3BvMyvgHTisvyM
	nZrRCiqhNF+OHFrdMqOes8G3sTKdDcgVjKWIu7u8mCBVC7fxxy6bHih51eLPrTqfXMSX+XyBg++
	XeX5slw==
X-Received: from pgiy6.prod.google.com ([2002:a63:de46:0:b0:c6e:7493:db3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a34b:b0:395:3677:2be4
 with SMTP id adf61e73a8af0-395c372dc51mr11458549637.0.1772476341107; Mon, 02
 Mar 2026 10:32:21 -0800 (PST)
Date: Mon, 2 Mar 2026 10:32:19 -0800
In-Reply-To: <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
Message-ID: <aaXXs4ubgmxf_E1O@google.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 43DC71DE68E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72408-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
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
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> On Fri, Feb 27, 2026 at 7:33=E2=80=AFPM Kevin Cheng <chengkev@google.com>=
 wrote:
> >
> > The APM lists the following behaviors
> >   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
> >     can be used when the EFER.SVME is set to 1; otherwise, these
> >     instructions generate a #UD exception.
> >   - If VMMCALL instruction is not intercepted, the instruction raises a
> >     #UD exception.
> >
> > The patches in this series fix current SVM bugs that do not adhere to
> > the APM listed behaviors.
> >
> > v3 -> v4:
> >   - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=3D0 and SVM Loc=
k
> >     and DEV are not available" as per Sean
> >   - Added back STGI and CLGI intercept clearing in init_vmcb to maintai=
n
> >     previous behavior on intel guests. Previously intel guests always
> >     had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
> >     because the clearing of the intercepts was moved from init_vmcb() t=
o
> >     the !guest_cpuid_is_intel_compatible() case in
> >     svm_recalc_instruction_intercepts(), the CLGI intercept would be
> >     indefinitely set on intel guests. I added back the clearing to
> >     init_vmcb() to retain intel guest behavior before this patch.
>=20
> I am a bit confused by this. v4 kept initializing the intercepts as
> cleared for all guests, but we still set the CLGI/STGI intercepts for
> Intel-compatible guests in svm_recalc_instruction_intercepts() patch
> 3. So what difference did this make?
>=20
> Also taking a step back, I am not really sure what's the right thing
> to do for Intel-compatible guests here. It also seems like even if we
> set the intercept, svm_set_gif() will clear the STGI intercept, even
> on Intel-compatible guests.
>=20
> Maybe we should leave that can of worms alone, go back to removing
> initializing the CLGI/STGI intercepts in init_vmcb(), and in
> svm_recalc_instruction_intercepts() set/clear these intercepts based
> on EFER.SVME alone, irrespective of Intel-compatibility?

Ya, guest_cpuid_is_intel_compatible() should only be applied to VMLOAD/VMSA=
VE.
KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject #UD.  I.=
e. KVM
is handling (the absoutely absurd) case that FMS reports an Intel CPU, but =
the
guest enables and uses SVM.

	/*
	 * Intercept VMLOAD if the vCPU model is Intel in order to emulate that
	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
	 * SVM on Intel is bonkers and extremely unlikely to work).
	 */
	if (guest_cpuid_is_intel_compatible(vcpu))
		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);

Sorry for not catching this in previous versions.

