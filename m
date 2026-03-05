Return-Path: <kvm+bounces-72932-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CN0PC6LUqWmcFwEAu9opvQ
	(envelope-from <kvm+bounces-72932-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:08:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 861F22173F2
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E97FD30B12FB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D284303A32;
	Thu,  5 Mar 2026 19:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KVJCRHzB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D50A2DAFDE
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772737657; cv=none; b=qed4TUCqooH60hO0HOW2FPo88MNryP6g7xjVqjvKjMPSqXYDHDA0fHwET2xtnN5H7p2bVFj7nVjtV13D1mx9PLDs9s8JoX9mR3DTe0APFVld9MnBDd9XjnsMX6F00ZhaAFmoV+cfSf5sLKUsQG+eE0yaZvMsupFgvUXVXmS/vbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772737657; c=relaxed/simple;
	bh=w0X3N8sFCQEBgD5yEveEJ43+yCciQZqBxhhVxI62qSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VXMJk7F1Y53w2Rb4VBfncj9QO69w0HmHmvFL6H8/WMBU+7wYi8tSEmKCIcG/g30XZ5IqzdW+DbkomnXll1lY0J8kASNZibVExfm38+h+cGWObOrbQ2nWqJABHvOUcl3x6MDMOKdzEhlQkszt47dQM7LRMhMjMqUE57/VGCPO2+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KVJCRHzB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82739095656so3279146b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 11:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772737656; x=1773342456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcJ0mjA5TJQ4bh2w27jq35LKUnDhiU4/pHqlNtaddJY=;
        b=KVJCRHzBwYVJpkJf6hJRGx6IeRuEjXJQrCNShUB7CCv61UiXjY6BFtid2eI5lfHnpz
         0NpGe2ExZLmEJqWm7uX/lEm4ah6M1noa/6uOudL4RJf3nx0Augr2xiFZvxVcVEG/BPFp
         CwG9pxoDkiATStGAtRkMurTGaEA5y6xGiatuRbSCMYtEM2puGhYRPCVLpF10aQgbENNB
         aY/4qFZoojbuEopYbXHjv95XNuHAwADP6/TrrWfkbeiS0T9QGOYVfFvzwcHvSktq9xQA
         nLqLcujwTqxZZA1n5Q0iT0BvkNhH1UIK9OvfaOP/D9aumUC1zBrR+XqtWgx8Ed59qEB/
         aBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772737656; x=1773342456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcJ0mjA5TJQ4bh2w27jq35LKUnDhiU4/pHqlNtaddJY=;
        b=VzTl3Ac7wzIu1vZuwR5yKRXLrh7RTfRml3d7lX4MJB/G/QAkYfZGOZt4H4fks0rqnt
         OVVB7jib6bPkVbtU9+6VuLdIYDyzN6lV2ZLXu8+CaVSEelVsdIT28nRM71AM5eydnI1B
         jY8PtHf2SRSXHqTdPcgo79K168lX3eiA8ysyMNyFWlrvdBQODyoN/nfXbyrbgPAYmlCI
         MklznNaYucwRu36l7f+O/lc6K3rzLfSNRHLOVV0f4Ux++v8avLQqLXDuV8NM6nuTjaBF
         NPrBDQ3kpA1JQaXpf3Y9TiM1FWcVBdkD1yroJMCIlo29XNfY6WMZDuAVvI9gJkjzR+2D
         Vb6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXalQzHAqwX0Eo1klKKVM6Aue5B1wV0tX7a/UpLwOvdasMEUIcjEEyj7sTYFuTwMDOyCug=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnGN7BMfFjHMvkR5a2/BYhF8uuq7XzzJv/9Y/k+uXdVOPwUTpN
	H46h8foAl4Gh19CyiiyW71HUjl22t/y9v2xK9Dlqc7TGYpwukSmXmEnBH7F6gE4FIN0tElaxome
	RwORcNw==
X-Received: from pfgt42.prod.google.com ([2002:a05:6a00:13aa:b0:829:7f86:634])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1916:b0:81f:852b:a939
 with SMTP id d2e1a72fcca58-82972d8d990mr6555196b3a.63.1772737655656; Thu, 05
 Mar 2026 11:07:35 -0800 (PST)
Date: Thu, 5 Mar 2026 11:07:34 -0800
In-Reply-To: <00406192-932a-4cce-a579-48fe18b9f777@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <177272960351.1566277.2741684808536756847.b4-ty@google.com>
 <69a9d0645bc31_6423c1006@dwillia2-mobl4.notmuch> <00406192-932a-4cce-a579-48fe18b9f777@intel.com>
Message-ID: <aanUdsXdskcugrqj@google.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during bringup
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: dan.j.williams@intel.com, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 861F22173F2
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
	TAGGED_FROM(0.00)[bounces-72932-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, Dave Hansen wrote:
> On 3/5/26 10:50, dan.j.williams@intel.com wrote:
> > My proposal, unless you or Dave holler, is to take the first round of
> > TDX Connect enabling through the tsm.git tree with acks. This round does
> > not have kvm entanglements, i.e. IOMMU coordination and device
> > assignment come later. It also does not have much in the way of core x86
> > entanglements beyond new seamcall exports.
> 
> Sounds sane to me.

+1.  If there aren't any KVM changes, ignorance is bliss :-)

