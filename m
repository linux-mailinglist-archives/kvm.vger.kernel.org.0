Return-Path: <kvm+bounces-69555-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMLYC8h2e2mMEgIAu9opvQ
	(envelope-from <kvm+bounces-69555-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:03:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84051B144C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3148301544F
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F152D060E;
	Thu, 29 Jan 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IWzT3OeV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CB54739
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698986; cv=none; b=dOQ8vjOKx2r9He/R3sMLOX5GHnUf75+/kzKx3tFTAP14RQkMdyGUmO3zd5ylFUKvUfDI/4sidBBUIwfTXqGA6B0+a/AC90mtG6z9CFxmpOsL8PcgBBm7I5/svZbD9SmBZmEtecq+aobxCGb9haadffq+/XTdj1jx9d8Fx8S13ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698986; c=relaxed/simple;
	bh=RLrR5vZu1hse1rtaEo4YuhDR0aPp1tqT50orJU6D6JA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NKn8CZ9CY/Z6RVMUg4EggDoQP4OLVe4zVUbkztOnETn/AH0Yg+XmQVfGr0V/bypRI1JAqcZJyw3pX/MQpLiIbrzQXK/tyeh6RWkO2WLqkUMpC2SfiA9Ut+tqf8UDc4oM4h2J7CG9iztDvD1n8WvNvniCB5r/Qyd3i3WFdz1HXV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IWzT3OeV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so785283a12.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769698985; x=1770303785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5vZNLrr7nRtWhRyWO6FkaZdOZiRAk95CNQQuZ+PLjs=;
        b=IWzT3OeVUkg/V6EzmGU4h2We07X2gXQYEGHFfCzOsvgMKTF0dPkZV8hPMBNsv9ad9j
         qITp1hoD+pfBWzBGPlNBioPBvkdujkA4QZ1335L3ja7lsejsrBWSXdLDpWD/QJ8i1F0V
         gJwYpovQcER/TUs6TL0rnfo1RXLqUhsTm3QbiwVw29uTa27ezpBJF5yJkxxcR6RoaIdv
         O42ZkULFyrMof4XSEPECXnMRboFR4yAy8Y/Z1pk5z2VZV49MxPO9z4xSJm/wQSicrxp8
         MS1Z4hL3M1I46uvdj48RWd/hCX80yjNf4slOQBqBN3H7ryJHeElmqfE4oJn6Jxckz4Kr
         wAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769698985; x=1770303785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+5vZNLrr7nRtWhRyWO6FkaZdOZiRAk95CNQQuZ+PLjs=;
        b=tson9eiOFVK+teJiJvBmd7sFoWYc2bSJH6HgdFBc09qytkVKfdxapQH8/TcpKBRrKd
         SVGtsZxRSpKqp8bW2HrRfkOrI09Pzg2h7mrimeWzhMJT3WFMuCJFXFDtEbsXaz6xuvzQ
         8ZSojyydNmHdgCtzd5FaeqaOuvjYZrUTO6w4Ov1jKEMmn0mLkN3viUIBlUv41cvAAXzO
         Bke8vdKlrOzXeMgL/uzv9tmer514cm6YEexkXAel6MV8/OiExl8F5q3PJcalfJ7Vw4SS
         b0EZzRAhjMmJG+tTPybKvaBPA8MzUcj4LfKUu6L09RPnme+M1BTCFp4VXH00nmOaBc18
         T2MA==
X-Forwarded-Encrypted: i=1; AJvYcCWRRzsjpfdPsUz4IfNxeth5nODWXsyQA6b67Z1b5EfZF2e70h8fQNUMYq8E/1b5KED05dg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqeb+liOG5b4Wo+YQyfSOs9tWd+jhMiITZs2rMgHrJj+0a0lj7
	aaEZ6HITtEKFUFBNAzTDoNrOdHgZZ88F7rszgjtXiAH/c2vBtpJuGKJ3v8XeymRtdX6bUEg61s0
	Z6JjQMg==
X-Received: from pgac22.prod.google.com ([2002:a05:6a02:2956:b0:c61:380f:996e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:398e:b0:366:14b0:4b10
 with SMTP id adf61e73a8af0-38ec658140amr8781777637.76.1769698984978; Thu, 29
 Jan 2026 07:03:04 -0800 (PST)
Date: Thu, 29 Jan 2026 07:03:03 -0800
In-Reply-To: <0eff82fe-e3e9-43bb-907f-3279163489f0@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128014310.3255561-1-seanjc@google.com> <20260128014310.3255561-2-seanjc@google.com>
 <0eff82fe-e3e9-43bb-907f-3279163489f0@intel.com>
Message-ID: <aXt2p4OXTOKKzsW6@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69555-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 84051B144C
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Xiaoyao Li wrote:
> On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> > Explicitly configure KVM's supported XSS as part of each vendor's setup
> > flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
> > to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
> > VMX is enabled, i.e. when nested=1.  The late clearing results in
> > nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
> > when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
> > ultimately leading to a mismatched VMCS config due to the reference config
> > having the CET bits set, but every CPU's "local" config having the bits
> > cleared.
> > 
> > Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
> > kvm_x86_vendor_init(), before calling into vendor code, and not referenced
> > between ops->hardware_setup() and their current/old location.
> 
> I'm thinking whether to move the initialization of supported_xss from
> kvm_x86_vendor_init() to kvm_setup_xss_caps(). Anyway it can be a separate
> patch, if we agree to make the change.

Hmm, I definitely don't want to do that, because then we'll end up with asymmetric
initialization of kvm_caps.*, and I don't want to move that initialization under
{svm,vmx}_set_cpu_caps() because it's pretty much guaranteed to lead to different
ordering issues.

One idea would be to call the new API kvm_finalize_xss_caps() instead of
kvm_setup_xss_caps(), but I'm not sure I like that idea.  Or maybe
kvm_constrain_xss_caps()?  That feels awkward and unintuitive though.

All in all, I agree that having a "setup" API rely on prior initialization is a
bit wonky, but I don't love any of the alternatives either. :-/

