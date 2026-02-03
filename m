Return-Path: <kvm+bounces-70081-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOGHF9tWgmntSQMAu9opvQ
	(envelope-from <kvm+bounces-70081-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:13:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFCBDE632
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:13:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01F373095148
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB9336B044;
	Tue,  3 Feb 2026 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OnzGRLty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850243659F4
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770149568; cv=none; b=jWJtlN5PJxEVt4awXwn4cFqAHlr2V3WW7heEwI9kbOTW1RdQBitONXEP00TWD9IfzmIEMtkgBJvfe8nTwOFob/zFiiMNAyY8wQl7fdaC1RMTS5lB8UvPkEn2oYYARONim1a6Gev0kzDvcZBtKwl0jXkkKU1gMph5xm9xylH01sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770149568; c=relaxed/simple;
	bh=FIof7DYQ8YAnpUNQ255+qFKJqv7JLf9E6vtY6I2uHL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gKbLQn3CBPQ+LIe9jQpmcCbZQ7bQnzk0ESf73IIUKSwElEUZFJQ7vap0aY/OiIGb/568wWlzqwydMyPNWXroCV6m0o+1oj2vemHbYS/lRe5uGG4CxAW5xh/LG7cqcO4IMdWKiiPoj+VUoTWbtWLmwBz40LDmUmp9gvATw/R3qN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OnzGRLty; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0bb1192cbso177165ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770149566; x=1770754366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6/I6jJ9cFq/C0EPaMkedZtBiJ7Dv2IDfYAyyp9jzoo=;
        b=OnzGRLtyPMODUdj57mQXQ6g74M4fsKXhLyZ6Yvqf6KOJlqG79iBpMyDMw7A25c+yTJ
         6RrqyDPxPFeE/ckLOxo38NIVUW8Kwn/FHzvU4wC3b/7EwWyzy641WvJgH+qSCHZVs/rB
         MfRMFIjQw18epIPjH/rHZrpOMxfM4S7XElPy+XtvNwFrwHwPr7KGYDWKHbb3MfD2h0E8
         IXQtLRd1jJfE8cOq32RwqJLhBvg9hi+9rRnwCE8cNhUnQzY06ProVyMlQWmuA2HmW6mU
         H7i0Pr7nHJUvx3xQXetQlITq21Ef3uAT4j58sBrB3hBCjDoOb75EaljnbZy2Q5qKRhND
         jPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770149566; x=1770754366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6/I6jJ9cFq/C0EPaMkedZtBiJ7Dv2IDfYAyyp9jzoo=;
        b=DvfiKCRrh14LjR8/LHa7XzUxMFwf0iBemXmiN+YRamnYfaEGAtR6/8OEWQYVT6uS71
         JZeIuGVRHeje53b6vwkWcJW4bj+pz2evJypyxbr0hgpWigXo+CtEk3FyXt2VUURGKldp
         cY4Q917L31nFPGIniZmaurIJUOMZH0LVHX86wcX4u77nXmFSrJ0YMyTck4QOCsaWb78b
         ErnyxYUNEJpj/H+JhQhXfJQ0hnb3ye1YXOctmZcX+pWwe0vtfKqTD15rNTgD4fr+d/eo
         q0dXIaf0rXSHyXUz9e+fLLcnUe5+THxI2GEO520H4dfLIY9ykRC3LwQnlsu98ecNfdnX
         zLDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV40L4kHucC3oqGDsHlFYqbYYydBt6bzX3J8iHbshAV1AAAAfsqialvcXOcmeAidMQVKpo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZZiV015Zw76yTLH4UzpujLqLAilY0OnEzSzxF1YAff0Zqui2f
	bgKzU7izrfD95DKYGpmb8n0FQBINielnwowyYLZysmXRegM3mrTYndHzwL8pmNKW3Fjssh+wZwt
	oCPVo9g==
X-Received: from ploe16.prod.google.com ([2002:a17:903:2410:b0:2a3:1bf9:d25])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:194:b0:393:372c:dedf
 with SMTP id adf61e73a8af0-39372498a63mr518728637.68.1770149565819; Tue, 03
 Feb 2026 12:12:45 -0800 (PST)
Date: Tue, 3 Feb 2026 12:12:44 -0800
In-Reply-To: <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-20-seanjc@google.com>
 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
Message-ID: <aYJWvKagesT3FPfI@google.com>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70081-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BCFCBDE632
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Kai Huang wrote:
> On Wed, 2026-01-28 at 17:14 -0800, Sean Christopherson wrote:
> > Extend "struct kvm_mmu_memory_cache" to support a custom page allocator
> > so that x86's TDX can update per-page metadata on allocation and free().
> > 
> > Name the allocator page_get() to align with __get_free_page(), e.g. to
> > communicate that it returns an "unsigned long", not a "struct page", and
> > to avoid collisions with macros, e.g. with alloc_page.
> > 
> > Suggested-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> I thought it could be more generic for allocating an object, but not just a
> page.
> 
> E.g., I thought we might be able to use it to allocate a structure which has
> "pair of DPAMT pages" so it could be assigned to 'struct kvm_mmu_page'.  But
> it seems you abandoned this idea.  May I ask why?  Just want to understand
> the reasoning here.

Because that requires more complexity and there's no known use case, and I don't
see an obvious way for a use case to come along.  All of the motiviations for a
custom allocation scheme that I can think of apply only to full pages, or fit
nicely in a kmem_cache.

Specifically, the "cache" logic is already bifurcated between "kmem_cache' and
"page" usage.  Further splitting the "page" case doesn't require modifications to
the "kmem_cache" case, whereas providing a fully generic solution would require
additional changes, e.g. to handle this code:

	page = (void *)__get_free_page(gfp_flags);
	if (page && mc->init_value)
		memset64(page, mc->init_value, PAGE_SIZE / sizeof(u64));

It certainly wouldn't be much complexity, but this code is already a bit awkward,
so I don't think it makes sense to add support for something that will probably
never be used.

