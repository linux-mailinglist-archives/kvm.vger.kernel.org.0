Return-Path: <kvm+bounces-72863-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMRnMRC7qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72863-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:19:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D4B462160DF
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 606B7305E8E3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E873E3DB3;
	Thu,  5 Mar 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zwE/aN6E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DD83E1208
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730743; cv=none; b=pqKIkzGucznZ4RTbefOX393/9ohE38OobzAFvtHPh0T4WLHKXZJ81bDdVJw1jU6TzXRXEljgCZ8W6oui1b+SbvyYHNIcia9ynpd19SSrlvIJDoB8hsUGv2fNW7K0c3Oim0P9EgaEF930rBP2pQVQqM902uSU9N0k9XOAmYDDFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730743; c=relaxed/simple;
	bh=0YcuCYKbOHUmBTWzBYOX6sM0jXxOTe0nbkZLsHLm00k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nxcu9YTymC9taVVTHbq8o/qZSx6LVVVY9w7mzHdRXtHHsgZaEYChLZCf0Uu+bn3O1+Cl4DWnCcN70uiJbACnVJYtRnWDhrMuOS8iig7liqpfVz63/9jw8gv5T9Eb3tvL+eez3KlvaKxqQz+Ncc/G3cTlY28Wc+Uwk4Yn2RouRsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zwE/aN6E; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598007eb74so26332665a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730741; x=1773335541; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fBweeXurjejND5FGgARfRQmSdgOGZL+WGJ3LwuMfVoo=;
        b=zwE/aN6Ek4+MCNuZ7ta8Bpoli/hpZ3li90rartIz95B3HsFoZqHctlA7tW+66eX3Bs
         grxUI9WP3i9OfZ3mIY2r8CaqQ9gJBfr5B1YTmKZOnNvQqrpuLj2uxnrsLL76zLD6fN09
         fT+0R47m4MTF4BUhPu/uHhLioUXH+MxmZMF4muVT3G7tL1yaCpBqI3kyh3Fx65Djau09
         w0TJa+tIYndHaXMI/7GoRcdf+mF/p44L8u3jmeVdY07I+FW94SUCEHDesRK6ZBwDNaX1
         D7lDj3pLYkJNeryLpNTOWp9jgBd8t/lo3SlhJr4FDF/ung6DMwfeOHJWzqI0U4I6OvQt
         XVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730741; x=1773335541;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fBweeXurjejND5FGgARfRQmSdgOGZL+WGJ3LwuMfVoo=;
        b=DGEGyKRFpGOLUnRXCO3crGTtnoCnfVvPvtD9upLlmgXztNF6aF+E6PJEWR7Fk2NtBy
         bkq70u3JyU5/sERBCN8+SXW2V3CflT6fwCf2XLi5ORQM+FlXWtHURyhDRtpGExg8gs0n
         8aPK31D+EndX2IB83mMi77yQkgowG/7BpXSYYkyjoL/YxgEv5Nqvo4erd2T9lfM0YAtH
         zRj4WdCeJlvNuK8pjXYFKViLLvogtvE2COeAr/AvOHs4J4ZbFn5+D4DzLQWotKufx7fx
         TvitpxrBXoQ4srD3alzEt+CGSMRei82Y+Aele42kJt869ZTULQJfoccuHjI+x0VnCPQ7
         YnBw==
X-Forwarded-Encrypted: i=1; AJvYcCV4VAWK1U/s7VxTaPcdvMlyH2qV6zxk28nTX76YsqNX4mA6K7y4bEe4j08Um0IgYS0/RGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfH+WKZfytPZPJ5S2HMh1REqSXg1qngEGvaoDnBWreuoayqWXO
	JJxj7sZGhAG+grkIzk6WekcPuEAPk1brB4USH7ny6CCbiWpQPbAPIMHj4JQRw/AWl3qn/HWFNjt
	lBknExQ==
X-Received: from pjsv10.prod.google.com ([2002:a17:90a:634a:b0:359:803b:2e2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c4c:b0:34c:2db6:578f
 with SMTP id 98e67ed59e1d1-359a6a3c1d2mr5563533a91.19.1772730741143; Thu, 05
 Mar 2026 09:12:21 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:15 -0800
In-Reply-To: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272539552.1534392.5805217887456485623.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: nSVM: Handle L2 clearing EFER.SVME properly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: D4B462160DF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72863-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 09 Feb 2026 19:51:40 +0000, Yosry Ahmed wrote:
> Add more graceful handling of L2 clearing EFER.SVME without L1
> interception, which is architecturally undefined. Shutdown L1 instead of
> running it with corrupted L2 state, and add a test to verify the new
> behavior.
> 
> I did not CC stable on patch 1 because it's not technically a KVM bug,
> but it would be nice to have it backported. Leaving the decision to
> Sean.
> 
> [...]

Applied to kvm-x86 nested, with the discussed fixup.  Thanks!

[1/2] KVM: SVM: Triple fault L1 on unintercepted EFER.SVME clear by L2
      https://github.com/kvm-x86/linux/commit/cdc69269b18a
[2/2] KVM: selftests: Add a test for L2 clearing EFER.SVME without intercept
      https://github.com/kvm-x86/linux/commit/3900e56eb184

--
https://github.com/kvm-x86/linux/tree/next

