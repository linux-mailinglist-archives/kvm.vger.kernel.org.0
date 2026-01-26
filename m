Return-Path: <kvm+bounces-69145-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHs1OFaCd2m9hgEAu9opvQ
	(envelope-from <kvm+bounces-69145-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 16:03:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6154E89E55
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 16:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A2EE30A48AB
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 14:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15143385BE;
	Mon, 26 Jan 2026 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+PUX0Ad"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A35330D58
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439450; cv=none; b=VezRwFryL/1ockJhzISWD42GDlzIvU8xILViM4BRQ5ohDQO8FCaDfG1h7gXdB1f7ZwmT02xaHVfC4jQEzmge6YL/Qcf4r7CYf41Bc3GPQjEQtGNAvTQVlGuj0teIAHThXPebysUDujK+lIz85L7s3wexwQToqtzzEd3KGdNQZqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439450; c=relaxed/simple;
	bh=g13mJzKITyrJw453TccRfmH4RjQsSnIihls0owb326c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=BJq4H5bStwq930AIvCuFEeu1WFU9MScNY18NSzM8kZzyS8Bkt5TGlOLybGKhqtfOCgeS1fuizxVi5w8s9PLSEouJqB1lVaPxV18xwj4fDXWk0SgBDxN8Wof8BorCdrRXM7Wzz3ENmkdYGXq1oryRzdqgUVSC/yseen9rvN1bbXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+PUX0Ad; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a755a780caso33944415ad.0
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 06:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769439448; x=1770044248; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oOMBIjxfOAbSp2wu0vCnQ1KN0uen4cEeCaPWeLIPvTE=;
        b=T+PUX0AdHuSWxSKl1G31YZl6GUeeHACyKYCgl8RWZYSFXosyWN7bkei2Hp3UC6pGu8
         n9ve/lWruS3nVwF0zvZ8wNbK4UPvc6U3yYkhISkuh1CcA2atlypCZLhM9kOnnGIM7jLY
         GEdGtkzrMN3AFmw3GuvExo1KROplj5nysniHTREUJvRc6GH0ZdrFahzI1Dxz+QbWF6UE
         ah/7KwabTsrazRSRrfNBA+6OJr8yRscAxaW+JkWEKNIus7q02xLfxHJcAwr28gt7f5rN
         s2UYp2yR6sLXdCwGisxPY+a/tadS7zCiPe7OVZ+2rEMJ3DrafWZbUDU/sksgTlt5czvk
         lTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769439448; x=1770044248;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oOMBIjxfOAbSp2wu0vCnQ1KN0uen4cEeCaPWeLIPvTE=;
        b=pDXIdFbqUyxEphyOoXBVtbqDVWkvVXR8M/edwbvoAzkS9+7DFsuvq0tL4LBHtU8tkP
         VqCLjLf5fOAZHb4rJ6psEDwjm/9E9k74h1Bx5AVRtbJvNQ284n104Ph1Fh+14O1kyMp6
         wlkjhp5uuN33WdvYEtHybEkJ/16Pmdj6oompQaPIQbQuORX258LzOoc3Mw7hNzDh9O1e
         k16bpA85QFkQaxlSz2LEmvu6Na15w3Ae1WtUDSQPLt9Evqoia7FwvHi+umrFI2KXbdh2
         mn2uHDCXlkgndW3ALVLd6kECuh/Tv82W32LQjCO6W5Cqv5kW9Px3+19kAq1PQFQ9aer2
         Mkdw==
X-Forwarded-Encrypted: i=1; AJvYcCVVcZ4HddJPWRuBF932qNPBs7s0ApII6U+thd5zrCJXlZ8DB/+xUeD0ojbtBPnLEhnaTsk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbbaLLEYh90MypwFE1/2bbQCRm/ze28hE/DQUZC3+GUEWQ3RfK
	OCLkgXz5nS93tMY/KMzb5g6aFzANRefGQ+LfGuaQ+6xEujZZLC2MGBbVxTX4E4V7nEwdHpJYv7E
	TYnkevA==
X-Received: from plrs9.prod.google.com ([2002:a17:902:b189:b0:2a0:b7dd:e3d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc7:b0:2a7:5e7a:5e80
 with SMTP id d9443c01a7336-2a8455b5cbemr40119485ad.26.1769439448029; Mon, 26
 Jan 2026 06:57:28 -0800 (PST)
Date: Mon, 26 Jan 2026 06:57:26 -0800
In-Reply-To: <20260123221542.2498217-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com> <20260123221542.2498217-4-seanjc@google.com>
Message-ID: <aXeA1pTiDDtikdWD@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS
 config mismatch
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69145-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6154E89E55
X-Rspamd-Action: no action

On Fri, Jan 23, 2026, Sean Christopherson wrote:
> +			pr_cont("  Offset %lu REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
> +				i * sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);

As pointed out by the kernel bot, sizeof() isn't an unsigned long on 32-bit.
Simplest fix is to force it to an int.

			pr_cont("  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);

