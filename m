Return-Path: <kvm+bounces-71054-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJcPIdw+j2llOAEAu9opvQ
	(envelope-from <kvm+bounces-71054-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:10:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA621376DD
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5361B303F042
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E7434F470;
	Fri, 13 Feb 2026 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kktNZnYp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873FC350299
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770995372; cv=none; b=oNd3b7Xk1qDDTg6bLs0rUD1kXOaCa9s0e+sc4mKSUyK4ShNOcXSCD8ZSlQ5VzPXVqjnrf1Ofj0ne/q4hUBOafVSwrVC0viLEqk+DDxdDqxKQ89Qctzysj0WF7QtNZyhyJHEcKTF3dx0hlxJxY3nCLt2v7S0rOePbRMLwf/bF5xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770995372; c=relaxed/simple;
	bh=leQAZ/VqItxILR/20qgaUrb5R3I3Mtb4M7v8QRSUzh8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cEs1oiUowxaFPoPgDVQTLOi/NBFdplXJ1I2tleHCP95id7byOKf4Xp1jR1YrvZX8ASo0DngkmqsVf5nGhzj60aLpGPN+CPSnUpqTCBnPBMHDPZzwcRxv26Uin67vrZbfiafNNlQgLq1y9DfL8JKzhTOgzH+o688he+g9M/oab0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kktNZnYp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fec175so29033275ad.2
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770995370; x=1771600170; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DmPok8TVljD6OBh3x850TFLE5gpc1T2JrYmL8CImN54=;
        b=kktNZnYp+vZ/BpibKW54e9lubhvXW6CvvnVXkRZQa6NqV4jLI+5XayFUIGmjLl9kcX
         8YrT9N66be2VYBDt67kgg0X+4aykxoWHx2p7kiOKwpnYlEUJjyUlh8o/mPERKRakO9VK
         jm7MzjIdqKowB2RJIYZLXF0UAXVZQxsQzkNafFP0elHmGYDE4Xe8hPREF8TML50bHjNI
         MmDH3GVM8+SH49araG0jQUMxvxqo+y2QpfcSsLWMOVqakckVfvNd5Z4ppsIRlJGuQoN1
         kJaXPIKmH6jG5Znfrn9CSC1aQMgApVQ+gKLEwZruMLYS0oFE31WKzCQljJfRsj2J7+pp
         djog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770995370; x=1771600170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmPok8TVljD6OBh3x850TFLE5gpc1T2JrYmL8CImN54=;
        b=jUoDBk9RDcrw7UTQwhFtlJkrK6rS6l9MuKKTdx5+f1lSdzip7fTNMmgo4x1Ww4JWfu
         cXnaz8Tsz5M975DQkK29KvXgarUIFkIWuETIfrujrw6LM7RRW4bPnQn6kXEuqbRJHxdG
         t2s0ZuKoWHNNCqRmCMilQsiFEG2B4TlRALIX6ULN7bGVdGl61WVyJd4oU9XC1XNxC6BN
         OgBE0jq+8ig3dQ5OlulHmKFO33Z6coZY3TpFcOYSwf/xS2O0Z8+2fIoIKfLKlZVSwrKx
         iU0Hw+XAfg5LLk8Ch5J0J10h+Oh1Iq6tdSmJ9r+ctB1+TmkW+v355eg/ttypu4gtMbfg
         yCoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+2iTtel5odoKuDiwQNQZIIfTbyKd6xN/cfVqjf5RBS3022u8j2dadge6np4RGxXvLgZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx74ShIrsYuBEMxyOJHRCO/PvH+OXpCnlDQnKuZwcjMEmdU/0xa
	FgpFwdamwqmKC0EslVXtILshOmgibPE/xPqEYwEx1+7dKMyV9FSs+LJR2f+oGC2YlERXwGuJdiW
	YXC/9VQ==
X-Received: from pldb1.prod.google.com ([2002:a17:902:ed01:b0:2aa:d80d:395d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e787:b0:2aa:d11d:5c36
 with SMTP id d9443c01a7336-2ab50598a38mr23517555ad.30.1770995369706; Fri, 13
 Feb 2026 07:09:29 -0800 (PST)
Date: Fri, 13 Feb 2026 07:09:27 -0800
In-Reply-To: <aYxBCINUG80GYfus@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-45-seanjc@google.com>
 <aXt_L6QKB9CSTZcW@google.com> <aYxBCINUG80GYfus@yzhao56-desk.sh.intel.com>
Message-ID: <aY8-pxmoYSg5oloB@google.com>
Subject: Re: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting
 S-EPT hugepages on conversion
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71054-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0CA621376DD
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Yan Zhao wrote:
> However, I have a question about kvm_tdp_mmu_try_split_huge_pages(), which is
> called by dirty page tracking related functions. I'm not sure if we might want
> to invoke them from a non-vCPU thread for mirror roots in the future. If that's
> the case, would they need some way to acquire this lock?

More than likely, yes.  But that's a far future problem, at least as far as
upstream is concerned.  I.e. I don't want to plan _that_ far ahead in terms of
writing code to avoid churn.

