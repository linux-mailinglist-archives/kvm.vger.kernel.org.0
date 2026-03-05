Return-Path: <kvm+bounces-72871-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MChLB9S7qWlzDgEAu9opvQ
	(envelope-from <kvm+bounces-72871-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B3A216170
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 26C9C30766E4
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312F73E7157;
	Thu,  5 Mar 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKiQ/uvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793263E3D9D
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730797; cv=none; b=Qnay6K4WJ+AQcOmLhFgyRHuqt2BYhIolymYiCq9rlCQDYbm5Iu4znBA0aVxnniWxhgX7U3RWop/aH8xpy8kLj54NvlV77DYh9aJBfPfcXVivZuxAWRqCu2dirTH+CuouWgjqL2b7spLcyA2Gy98VuNY+oAVQ0SOtXKDak/Un760=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730797; c=relaxed/simple;
	bh=W/r3dwP6bXFVtGKujLs+8VnddyYvLsyKE464gcZ7qbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=UBZM8AvvejFTsRA12f7pgrpg6wCqDuG8omqhGgvpks1P5+zRrbgreWwsV7oFIef0rGJ5ma38HKzgjwNVKMM2yWA06KsMhy8bPpV7r7PgMuO97YaS2lNPlIXVybzVcWzpMLalWQBpSnDu9wlbP0RxeHoneMDQ+0u/0ccDRm9LDjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKiQ/uvZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598d3e3bc7so4228659a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730796; x=1773335596; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMq62r48M5GsRj1/5/v+Np0zZZ8DbhH+mNzDWiPVhuU=;
        b=CKiQ/uvZNM4jZfz7kBebShR05llqzBoiLw5DXyppxkphguykQmnYERbP5o+gB527Iz
         92zzbPWdJ/xt8mNhFfufKBHZ0bx7GgpYUZqt5NMSCsMNT4d1W63Jk9trMpagh5zFX0RB
         cgho9b8pjz2HBQjncKGmXNDyDHGVhkdGWP28wYRfaAQg8jGTsatoObArqdTCc0EdTGJV
         GsRVaZ1SHql+los3oOqd1tDdbHzx5WXoZAYbKRR7ZkVP+qX9RM3hHXu/pz6CTHJvtIFy
         zoXWUyF/10bIaOl6aFwudlaAOLwcC15sqi5PAWbusVRs8t9wa/TgQgTvsSpiNJYAoR6R
         jPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730796; x=1773335596;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMq62r48M5GsRj1/5/v+Np0zZZ8DbhH+mNzDWiPVhuU=;
        b=JQ3QzKYAn3jbRZINUvYM/8a3jnlZfxYvSsZY8p52lA0ylUSysGLJG8rCnr2YDB6nPa
         f5lgpy0jb3iDU/sLLVVPyS4WzKQXZqUHrho+qbayL8ZXHLUIYvNBb5nN5mV9EqeV8BGz
         mK4oll4oBQYesJl4vbIGUDWoWa1EN+JPt0bjHmXQdIE1xiRZAEtdmfS5glpBtgxoxEpF
         syt3CKXEa2Ai9Dd9Ca+AoyGqJy4b/PwF3PziHhF9Afo9uyrCh/5QC/kOPI67enWLQjyM
         mL1gFLcwK7gbotKj3m9DNgabsKf29LeDzcUIc9XIjHVw507Y9XtpzCsEVPETDUTluV42
         mOjg==
X-Forwarded-Encrypted: i=1; AJvYcCXf+IStaUxLHOvv12twC9bNJm2ooswn9NsESi4SkI/4IEXq8+Grn3qtDr4HFXaud4wUHlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyExfE5SS6gs+lGfFHgPEZHQ9/zXTHXz3fJs1C5rpa5w+St+qsF
	Zah0R9xysYRwE7Qa9HD9MjXdfJXECNflWj3egnOfrIItygjhWwap0Udlrw8H9Z15EDnDAGrvCqY
	9wk9zuw==
X-Received: from pjqx18.prod.google.com ([2002:a17:90a:b012:b0:359:7c35:fda7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1848:b0:359:8c89:96e5
 with SMTP id 98e67ed59e1d1-359bb375be5mr244510a91.12.1772730795784; Thu, 05
 Mar 2026 09:13:15 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:31 -0800
In-Reply-To: <20260225145050.2350278-1-gal@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225145050.2350278-1-gal@nvidia.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272734484.1548728.2810524761723768496.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: x86: Fix UBSAN bool warnings in module parameters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 46B3A216170
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72871-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 16:50:48 +0200, Gal Pressman wrote:
> Several KVM module parameters use int to support a special -1 (auto)
> value, but rely on param_get_bool() for the sysfs getter.
> When userspace reads these parameters before the auto value is resolved,
> param_get_bool() interprets the int as a bool, triggering UBSAN "load of
> value 255 is not a valid value for type '_Bool'" warnings.
> 
> Fix both instances by implementing getter functions that handle the -1
> case before falling through to param_get_bool().
> 
> [...]

Applied patch 1 to kvm-x86 svm, and patch 2 to kvm-x86 mmu.  Thanks!

[1/2] KVM: SVM: Fix UBSAN warning when reading avic parameter
      https://github.com/kvm-x86/linux/commit/2b1a59f7ef96
[2/2] KVM: x86/mmu: Fix UBSAN warning when reading nx_huge_pages parameter
      https://github.com/kvm-x86/linux/commit/1450ab08108c

--
https://github.com/kvm-x86/linux/tree/next

