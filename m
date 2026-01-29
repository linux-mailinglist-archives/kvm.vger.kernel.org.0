Return-Path: <kvm+bounces-69557-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MC0GAXR6e2kQFAIAu9opvQ
	(envelope-from <kvm+bounces-69557-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:19:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9376EB15F0
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36D96302445C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E0A27A45C;
	Thu, 29 Jan 2026 15:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFTXwZ+5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5350F221F03
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769699943; cv=none; b=kQaovx2BjJVQTDEzucrwbS4OFGJSddSsHABW+gD8s2qshDBpBnIHJ4EBP0Cb9n3ITofUZ7BMrHgxbwMigg178H+ZuZf/LY7ZKQfGCa4aNOulXtND1vrEDsrjtEfdsojmgahAzxgnAa1mAUk0Sp//Ok+hbLzFKGUi4fyN4k9i+u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769699943; c=relaxed/simple;
	bh=ySriXi3YnNaDwn3sZpZdzB6TStZI9xdCvV8wCi/xJ/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ad52OkrieqLy80ICzfJrNa7za1h4AIhq78G2i0H5KqnS9a99qO4khMHv0xCYZmFGCDYf3Jnzwdo636T9wi1FRNKtujWzARyOjvXcI7+ahr8MC/G4W7sq9F+OWI680x++jp4DIvOVIKVRDN/H0tBP37bk2sYPi+auQ3nwQF+jNIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFTXwZ+5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6136af8e06so692818a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769699942; x=1770304742; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDN7CJht/IWwUBFi7bH7QZjmbW94TeIdtC+sbINM/jw=;
        b=JFTXwZ+5/f9/Chp9YsjKhzAxGF/dVQxIrdHdQvmrlzlAvxB7ftlSni1B2Oi9hwL/nk
         EgNj0YIfFfgbo2sGGk6lIvXgEgvvqGwAoQ10D9dGhBwy59WTCCJapAgYWsTvzQe1c58j
         Uj0bE1yFMpPh943OIlRETBjP9DJDMV1oxE7q3+0n3Jox89E1IrpnB2XieWRQPI+7QhH/
         sdyzVjjCofdacQWMLKAmzLL/hV7HB9KwD6Hm8ppsYWuZtHOq9Rq7E3qGFAyVCUqiow+K
         xkuuNGTOIkENdCeBjLOhle+BE6kcdH6mRAHe979T5DHhHnQTet5WjOvrz6GxzYrC/2b/
         ApmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769699942; x=1770304742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDN7CJht/IWwUBFi7bH7QZjmbW94TeIdtC+sbINM/jw=;
        b=EtIO2Gbo3z8/Z4yliN4F7PunpBlBpXdMOuAXt8HY4YXnNppTCC1MLvHXlv+LxddYu+
         KQ79Fxor2zVW1JnrhPmaKiC5deSPp4dOiXSXRVi5Ac2fbT9fskYmUUsluYaMyB3A6mWR
         2FikvRWCBbFQaLiz0FIqe/LU/LYCtHHE1X1sRJSkeAJuh/sjsOj/pqch9f2C1Bqv5+W2
         NWWzvazI3z0yppbLrMlLjEwODkcWHvVgUVO3Te2TlNGH7BsKBT8hdaeYL+ItnwZdO7U8
         LmnzVrB6c9SpeKq+/+ufCHKwmWzHxAr0K/oCQrhE40SQ4euvL03hNAIdePisgg420txA
         ZSJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0yRLdBu2rHMtFS92FSES+YrRMDiaqBU9iMBZCBGRf8xht93V4Eho34JCwZMgTGRU12PM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbXWg5k2qDBViOr09lznMkVi2uiOo0xXdrVVeGm31tNlhFxl/N
	pqP7+n+NKSl0tK1FtKg3KZF7/FT4bTfxflDrgnwfu/gcRBxVxNte9VpDJSHmnXMtttxVyeMelb8
	klO5vuQ==
X-Received: from plbli4.prod.google.com ([2002:a17:903:2944:b0:29e:93e9:f1b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:320e:b0:2a3:e6fa:4a06
 with SMTP id d9443c01a7336-2a870e350c6mr88609495ad.39.1769699941666; Thu, 29
 Jan 2026 07:19:01 -0800 (PST)
Date: Thu, 29 Jan 2026 07:19:00 -0800
In-Reply-To: <83f9b0a5dd0bc1de9d1e61954f6dd5211df45163.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251229111708.59402-1-khushit.shah@nutanix.com> <83f9b0a5dd0bc1de9d1e61954f6dd5211df45163.camel@infradead.org>
Message-ID: <aXt6ZEgZRGPPPtTB@google.com>
Subject: Re: [PATCH v5 4/3] KVM: selftests: Add test cases for EOI suppression modes
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Khushit Shah <khushit.shah@nutanix.com>, pbonzini@redhat.com, kai.huang@intel.com, 
	mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com, 
	shaju.abraham@nutanix.com
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-69557-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amazon.co.uk:email]
X-Rspamd-Queue-Id: 9376EB15F0
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Rather than being frightened of doing the right thing for the in-kernel
> I/O APIC because "there might be bugs", 

I'm not worried about bugs per se, I'm worried about breaking existing guests.
Even if KVM is 100% perfect, changes in behavior can still break guests,
especially for a feature like this where it seems like everyone got it wrong.

And as I said before, I'm not opposed to supporting directed EOI in the in-kernel
I/O APIC, but (a) I don't want to do it in conjunction with the fixes for stable@,
and (b) I'd prefer to not bother unless there's an actual use case for doing so.
The in-kernel I/O APIC isn't being deprecated, but AFAIK it's being de-prioritized
by pretty much every VMM.  I.e. the risk vs. reward isn't there for me.

