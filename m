Return-Path: <kvm+bounces-70079-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MJRPLa5VgmntSQMAu9opvQ
	(envelope-from <kvm+bounces-70079-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:08:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E7BDE5B8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A28030F18FC
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E25325497;
	Tue,  3 Feb 2026 20:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3O+5qWUx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF383195FB
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770149193; cv=none; b=uQYwbSkA5IDY8Fvf15zNgGE9f9zQU1smaXEBAOKav0rlNBEgZwMFHnAnbzbVgVoWnrhG4hkY9LpjCa3URxYn7QwGWDgGLZwQ6J82mghf2jeTwT/VybkS8lLfeK/2WcIfCKGrq/awf67K9ygyvJgcEXbJUyYtpCYjwiwdza+EMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770149193; c=relaxed/simple;
	bh=1Ib3pwxKHmKqNzWuh8gauUn0Z+GM1AdBwnBeI2qs2L0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YGYRhLVS8W+8otIHJDa5hEQXmE+EKsb5EA3jwqy+qp4lP3H1NjMZn/LXemgcWkmE6yt0HiJgXbmy1rTtkBNRgXBG2/ijf+qEzZDmkNPMBuYnIMXADyCKOQIzrMSstxqYtdWWOnpbHLorbqJGMuBWmr3hhqJ3zEwaT7QpygihvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3O+5qWUx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f1f79d6afso67126295ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770149191; x=1770753991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxuGQhnhiUSSgKfkg98kr3VXsZ5hp0LNlVLYQ5k5le4=;
        b=3O+5qWUxTbXha7H06Qw+p3w3XCo1xA8rcg2eMapbBKt+mR57K+3LsUe2TWd0A7QLjO
         dm1CZh/ggxh2JZu2RGNB2cfl3+pJVWXAUm+5ekRH2Fl+Kn9AN2EICxY7l5LpPI6ydOz2
         w6lcrjkr0gaH7PA8s+oXcgXTPfkxME5ilZafzBmUGE2jMC6FvGna8828s8QCdhm5d74x
         maC43RaiDYXldAqVdZo6FPryAGralXP7vydD2U1iYhgNYlGI8QCfh335Efphl9n8VAGe
         fm5zPjKXefxWHDC+cix+WOxq0K1ENyG+2w+4kpVeREIz+Iq8igoFBQyatne55VIN2LjW
         h8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770149191; x=1770753991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RxuGQhnhiUSSgKfkg98kr3VXsZ5hp0LNlVLYQ5k5le4=;
        b=OSN0bZA/PhPGlnEsiDmYk+kwTBYFwkSCfqAChHuioj3My5cfXi4Jf/vQzbtLd5U/o+
         9XnGFiLvbEP9W4qQGmtSJJqZskvDVflTXxRfdzhYw8GKCRcvRKglqoLsQt7VisaAwDbb
         gGBaiw7jrI1/DkrVbu9mN8mvr5DD8a9bkxgyTv7MqDkwjgjsR6YRXOM+wODTkfUNBaH7
         WiiMh6sExhR0bs46Cb1141jWmdliVp9vw4klkZC/mjhgGPGnUeTbft9vpbLD77hfAXnx
         Jp9y0KFL/drF6mnedZry7xNX7+XVjw8wlV1QAoM7pQE+NPGkVv/ZNzeKxxDGbzzeq7r1
         ySrA==
X-Forwarded-Encrypted: i=1; AJvYcCX4BCZyqOaWz4Z2NeaWXdMClXAPzEOTERiUzQ7OK7mwAXZroxMzBboLg4qr5Hbu6CoYCGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YySheoaVwsB5dPXVJHtKGvxhwBCH2lxyEyO0PNmpHYsGdzpNmi7
	vWcFqm/O7HNmcTkvi0ZtR6+k4+nDOYBsVMcgBnpwdCRUrjcRJQpzKjgm7RGsb8Bo3yGAnLO69Bq
	OF/TXRw==
X-Received: from plhn5.prod.google.com ([2002:a17:903:1105:b0:2a7:62c7:4431])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:983:b0:2a7:d7b8:7661
 with SMTP id d9443c01a7336-2a933ce935emr4755565ad.4.1770149191214; Tue, 03
 Feb 2026 12:06:31 -0800 (PST)
Date: Tue, 3 Feb 2026 12:06:29 -0800
In-Reply-To: <1c4bdb3613ebaf65b5dcf9a2268b06fa0c5a6ef3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-3-seanjc@google.com>
 <1c4bdb3613ebaf65b5dcf9a2268b06fa0c5a6ef3.camel@intel.com>
Message-ID: <aYJVRQMW8yeTkRxR@google.com>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70079-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 20E7BDE5B8
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Kai Huang wrote:
> On Wed, 2026-01-28 at 17:14 -0800, Sean Christopherson wrote:
> > Pass a pointer to iter->old_spte, not simply its value, when setting an
> > external SPTE in __tdp_mmu_set_spte_atomic(), so that the iterator's value
> > will be updated if the cmpxchg64 to freeze the mirror SPTE fails.  The bug
> > is currently benign as TDX is mutualy exclusive with all paths that do
> > "local" retry", e.g. clear_dirty_gfn_range() and wrprot_gfn_range().
> > 
> > Fixes: 77ac7079e66d ("KVM: x86/tdp_mmu: Propagate building mirror page tables")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> 
> Btw, do we need to cc stable?

Probably not?  The bug is benign until dirty logging comes along, and if someone
backports that support (if it ever manifests) to an older kernel, it's firmly
that person's responsibility to pick up dependencies like this.

