Return-Path: <kvm+bounces-72772-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COsFL/vdqGlmyAAAu9opvQ
	(envelope-from <kvm+bounces-72772-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:35:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24667209E67
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11F6B303A25D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED6621767D;
	Thu,  5 Mar 2026 01:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpt2H0j3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7B38003D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674540; cv=none; b=J/MInMxo12Yz/OB2TxaDm8wXmD/VHHm0K0x7kVKGu1ooyKYzK3CU0UaqmUteDNuc0kV3On/kaVVRsZOMKEN+kR6r4BBlgRNDzCcRIrQKtXkwtPNy0/nLQ6O5aAADIQmIV1qTUC8U1hgk2dx8K/G1rxYdIMPRwKHlYZlzHPMGrTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674540; c=relaxed/simple;
	bh=nU+kiMy3ux5LITsewJpWfREDqwcjohElsw+dahV6WtI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YAvAxEd1J8WBjw55JigUTU2s44QHhZYMhJuN7HxhuCz5WCcQ+UUp48Nj4JH402Klsgh1ptoHVMjvGfHhzUr0bY/XICeHFJxKjJuUZSbeW/NYnbFlATPDlCSqsB97dEQJvAEVuAeRCN9/pEujY+gabkl5I7mmBqXUibacZEkPARQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpt2H0j3; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so4722715a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 17:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772674538; x=1773279338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eToFNrL4npkETfbdyyrNvZSNlVUc+rj5T/HrzOpoia8=;
        b=xpt2H0j3d7evFV5Ym8P3dKjOAK8buW7Ui5VMfKHun3SKATjZiDfdfVYWrLiayRiCFW
         PIKbMl8oMmLYQyw54NqMOPAhSNlLttYk06mpyFgQh7HuBVHx2qEzB2guTh9lZA+oWOI5
         oGTrl+6cWPG1OLS3O/lSi24fibrvSRvAfeetuhD4wkeRAVwV+yTN+vc0judfNgJTujfH
         SakpH5frJah533ZEqSfYopJJWkVU9gpJZgAyxcHetMo/KXZ9RqP1fuBmUWu7eACEcEhX
         e6GfWxwb1By0ffT+F+sH+ClzL8AhgUE7m/UOIUl2AGv/qOPkbbgHmKjIpvJhS1I9qA2q
         9kWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772674538; x=1773279338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eToFNrL4npkETfbdyyrNvZSNlVUc+rj5T/HrzOpoia8=;
        b=IPtH3dDAk/N54XidifvD3B1Rr0Q/ko+EqJPrU/k4SegWzrxFUjc3LGa+rG3QN4G7FM
         aZ1rfzrX5I0Vcl2Tt2yFNCN1TWg1romP1lPI7WJ1yoNA3A+8oyBFC6cyhQi0Nvlvaw2z
         uzAcIprkPJ5Ze2+E/8GQBP2f6XAUi1kMSytIpZM7kv0ZflFuMgUVg5XkZWq26jdWyDzs
         SVTAihuZ35B62Ort/Pj757ej+RCPKo+DNYkwnamHYVs0UAe7v8dCGsmcLGwhe4WU1DpA
         5axeU48wnCMUOxLEQqkXbNUUPKZi+ufEvTP5tB9Lsmw88ptuFDidCCOl3otODBFCg814
         La2A==
X-Forwarded-Encrypted: i=1; AJvYcCVvlfdNexbQoXwVGX4vljk9GFFEWdRQdBPgj6xdvwPINLSJLU+wcBUOH/xjVF3X8k3b5H0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNXY4/pcCHrtAQLRlAdCvKtLTWCounUfKuWfSgE1EU1+Wigm3h
	CtmoGGhhjNXBzfJI1ivGU13sFx35qe7mLem+qvKFk97fcl/RuciuGz7tbM0BvllQFeRdG9imu7I
	FzSM2xw==
X-Received: from pllx22.prod.google.com ([2002:a17:902:7c16:b0:2ab:194e:4d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da4d:b0:2ae:47f9:de12
 with SMTP id d9443c01a7336-2ae6ab729bemr34506245ad.46.1772674538033; Wed, 04
 Mar 2026 17:35:38 -0800 (PST)
Date: Wed, 4 Mar 2026 17:35:36 -0800
In-Reply-To: <20260112235408.168200-2-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112235408.168200-1-chang.seok.bae@intel.com> <20260112235408.168200-2-chang.seok.bae@intel.com>
Message-ID: <aajd6Fa8gHz6lW78@google.com>
Subject: Re: [PATCH v2 01/16] KVM: x86: Rename register accessors to be GPR-specific
From: Sean Christopherson <seanjc@google.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 24667209E67
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
	TAGGED_FROM(0.00)[bounces-72772-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Chang S. Bae wrote:
> Refactor the VCPU register state accessors to make them explicitly
> GPR-only.

I like "register" though.

> The existing register accessors operate on the cached VCPU register
> state. That cache holds GPRs and RIP. RIP has its own interface already.

Isn't it possible that e.g. get_vmx_mem_address() will do kvm_register_read()
for a RIP-relative address?  One could RIP isn't a pure GPR, but it's also not
something entirely different either.

> This renaming clarifies GPR access only.

But then later patches use for Extended GPRs, so the name becomes a lie.  I also
don't like unnecessary use of acronyms, even though GPR is ubiquitous in x86.
Everyone looking at KVM knows what a register is, but only x86 folks will know
what GPR is.

