Return-Path: <kvm+bounces-72699-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPhZHztfqGmduAAAu9opvQ
	(envelope-from <kvm+bounces-72699-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:35:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A81252045E4
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 491D2310968C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A003365A05;
	Wed,  4 Mar 2026 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qttMyaJY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21134DCFD
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641416; cv=none; b=XdY0L1f4+ZeS10+BNsj0uD2rY1ADZwjq9MZHd2Nyllqpc+4G/hus1yUxObWTGawyPNyM0ZDDXqx2OXMsnIA/ouR3B5hYUnCY1QjlaJiFe5K8Nr7jf5Hrcq1T2YOk1l6UzUtoiuFwOqk9on2JXnJ0qvQTSuDiQ+BD+SSDaquQ8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641416; c=relaxed/simple;
	bh=+59wknHGTRW+W9SSh+h7PF3GSLLzGVapIaIAou5Ber0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IufNJeLMPRka7qaaIDkoS+Xl/NIwPcnM/USpnDeORbgBBM5e2NZ9gaHQrqu4j4++vB4rWFv7WEm++3QQI659h44DluRO1OAhXOthMC8cyL6lO4u54qF5LtJuhT0EXLl9C8edQPeh9TYqa5yTJF2KAJUOs/fnu46lsFDgK8Px1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qttMyaJY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae57228f64so33020375ad.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 08:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641414; x=1773246214; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrzSKo5+wXzomm7lL9SdcMFqNMmtfJshxUqsLyJWiLk=;
        b=qttMyaJYEkbbGPVshz/281IVwU/9Xus572XoR7cZ/lJhVdLZwGGGo0qSNqOi7zd+kO
         8dxI/FIHnMJYBd64NhGYhgGdTB2O7L0RhpejDVKzVeMyCou2bfPsuoZDKdZsQ+Dv/lVS
         mLunqPQAYUupxi/U/PmgW5EowL9CQKCqarelt4pb2Aoche0PNojPzSaRVE0ZeeZFcK7K
         uVa4u6OQF/hZMowLwsxmU3VBwL3Fk0xqP+Mat9Kgn1Dff5KvYA4gDwlHplL9GMM9gS0f
         SS+QSWGs28kxsys8+SYuYOLO5rsricW3+MH7T8ovNGXhVmvy66/nyXOqFEEHhcIC9h3R
         l0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641414; x=1773246214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrzSKo5+wXzomm7lL9SdcMFqNMmtfJshxUqsLyJWiLk=;
        b=LzypLqBo65jdP+tHSncC2vw4oYlpgrDdBN0dBUCWYeY1IPmYDcm/o4FCdS4X9iOTYq
         hCRZEC7pfKlNfrcbBDiqtAWcLeXPxePS9I/DucPqLTdGwuCOwwA/HMRyxH5dLcfjQ9yL
         gsDV4PkelkrYTnBDMzPZgY3ndKP63mVA/wWou7Dq9lRSvJH8YRNqCEHdHkhV/emTDZWa
         g0Zpi0wCRIrpNhZXQ6pehSTjr7dW1u25O9Se0HQkMV7roIVJGouJbzfJunIrNHxJjWo9
         uChxn/NS9uis+wusU6Yz0rzFfoWh1W2BcoSlNUsm51ucxlmw6sQXmnOh8kY+LLnqk9XY
         rC2w==
X-Forwarded-Encrypted: i=1; AJvYcCX+vcoamhsrJo5ssaEYQ34JPsgP27QneP0yebxsmuq6Du/6Ki1NUpmPoZRzSyfnibcjJLg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI6rQm9mitFm0QxqxKjKCr74uia7jwTckuU4Ouaxb3CWc2jRNr
	cRNUS1gZksVwuAVR5DJmf6HhFEYDHXA2tC93RykWPFrnlPPnCP+D/5ywRCWk2NYpy3Uv0aqKkAX
	/TAfbYw==
X-Received: from play21.prod.google.com ([2002:a17:902:e195:b0:2ae:5075:50d4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b4f:b0:2ae:3b9b:db41
 with SMTP id d9443c01a7336-2ae6ab4305fmr29611105ad.38.1772641413940; Wed, 04
 Mar 2026 08:23:33 -0800 (PST)
Date: Wed, 4 Mar 2026 08:23:32 -0800
In-Reply-To: <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
Message-ID: <aahchI7oiFrjFAmb@google.com>
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: A81252045E4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72699-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Binbin Wu wrote:
> On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fcfa99160018..c8b5359123bf 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1459,6 +1459,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
> >  				    (unsigned long)(cpu_entry_stack(cpu) + 1));
> >  		}
> >  
> > +		/* Per-CPU FRED MSRs */

Meh, this is pretty self-explanatory code.

> > +		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> > +#ifdef CONFIG_X86_64
> 
> Nit:
> 
> Is this needed?
> 
> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, this
> path is not reachable.
> There should be no compilation issue without #ifdef CONFIG_X86_64 / #endif.
> 
> There are several similar patterns in this patch, using  #ifdef CONFIG_X86_64 / 
> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and init_vmcs()
> doesn't check the config, but here does.
> 
> > +			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
> > +			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
> > +			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));

IMO, this is flawed for other reasons.  KVM shouldn't be relying on kernel
implementation details with respect to what FRED stack handles what event.

The simplest approach would be to read the actual MSR.  _If_ using a per-CPU read
provides meaningful performance benefits over RDMSR (or RDMSR w/ immediate?  I
don't see an API for that...), then have the kernel provide a dedicated accessor.

Then the accessor can be a non-inlined functions, and this code can be e.g.:

	if (IS_ENABLED(CONFIG_X86_64) && kvm_cpu_cap_has(X86_FEATURE_FRED)) {
		vmcs_write64(HOST_IA32_FRED_RSP1, fred_rsp(MSR_IA32_FRED_RSP1));
		vmcs_write64(HOST_IA32_FRED_RSP2, fred_rsp(MSR_IA32_FRED_RSP2));
		vmcs_write64(HOST_IA32_FRED_RSP3, fred_rsp(MSR_IA32_FRED_RSP2));
	}

where fred_rsp() is _declared_ unconditionally, but implemented only for 64-bit.
That way the compiler will be happy, and the actual usage will be dropped before
linking via dead-code elimination.

Actually, we can probably do one better?

	if (cpu_feature_enabled(X86_FEATURE_FRED) && kvm_cpu_cap_has(X86_FEATURE_FRED)) {

