Return-Path: <kvm+bounces-72869-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMknHqO7qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72869-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:21:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA55216142
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 60C933070156
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6AF3EB7E7;
	Thu,  5 Mar 2026 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZGiIbA9t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D43A3E3D88
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730785; cv=none; b=ZjlU0mxUrEeLfSTt2oXqZl51+V6JALkAhhcX2qClnV350nBr1JjkSHf3Mj+JesMAIiTx7fg3pYXEki6lJZPRYHQrQpKiU0xvhGzgqi2e7H+woVa5u6396PirXzV73brEAL1eYQ9/VjKvXuV7ovYp04+8/rXZvj7T8v5OzyGLVJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730785; c=relaxed/simple;
	bh=ixNnjRisEKC2+6IAmQnjI9ab+lvosDmX4lcTWF/0UkA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LboUKVw6DsWKzoX9rOsxGziGc7knpSrU+F1pJf4HV7aB65ByHe5HSa+6gLulB9hyheBAVksXP8qYweciRazLHbq485mBcOlDvuShv0iSmM8kfOJv75fWDd7wR3+prjBKcXgei/xfUJcti0OBHmkDhjmpcFd6pGo6v3/EQu8Zc40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZGiIbA9t; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c739120475fso483883a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730784; x=1773335584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tnolfb6uQBsYaAshkkXBLdzTSf21J1HsPObGa5E2rzU=;
        b=ZGiIbA9tZD1LkwuijnPqvA6nmvxLl6WuSxt81BKxinbPGtntWDXPhqkr1/uiJFjaH5
         PefThkHP/tmY8+gyh+zeeHkEAKs4iECirniuCHi0njpjiKMu7+1U5uonKmuk3Wcfw83d
         hlSUoWqfpOIP/h7dDHIxbdlyRQdUjeu2CDQb2yemlsOytCO0kSd7yguw1M9t8kqZHcQ/
         VHZxwyns/ugG8eUAViJAYiVSFTsKP8jkhEa7reutatBpcoe7tVwrd+Y5INBsrkH1kuRO
         SssdRs5mb+BPnmp7nClWGZDFwb9Sw6mFWWQ/QGqZLBxDO6LWKYdrL6xrpKqQyXRaUabG
         Dm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730784; x=1773335584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tnolfb6uQBsYaAshkkXBLdzTSf21J1HsPObGa5E2rzU=;
        b=sei2ucAXeIWIK62UxqvIn7R8gpurwt6Ry0f0alBfQZmYBhDsngPpPqVNdNTK0VwvVc
         Dw/SZi3TqzBebzzLydWLAnKmudBmbxI2cgE4GbnBvIe2s+4IXBkZwNnGfa2MYP871+JW
         Sl669qJlycFG9s0tgcijycJFs+kOW1AK3a0seGGWR3fhD/jPlhRs3bY7gExENQ3OwGTo
         i0FlyDG7a+X9C71o9+RU7guUGzra75EV6Zoxyth4JgGiUp97CFlCadUmtx+YMoKRwlQr
         npxqe5Qnq5JrKTRoyfLhKIf4m4jP/XUiQMswurfFzwk/wvw2hmu4vrUQk8D/hiQXT2AZ
         wT8g==
X-Forwarded-Encrypted: i=1; AJvYcCVqMwYQBUZ/MtxnmSta7WAbro3luhr83SyJweZbVNic4Jo2Ro+1lunEqOYzYLTb4nF9nHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP7eQgYMMovZXM5nZU05zICz2lrWKinrwh/9W5ZM+BQ3L0bamw
	M9F/BmXAOyQKg3Uo3FkuyEo+43XffUFd1JmpkzinWvdZnM2MVQ+hIbaJXYHHKRk+ouODsYzb6QM
	7Ly9jMg==
X-Received: from pgix2.prod.google.com ([2002:a63:db42:0:b0:c6d:cc16:8cee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e8a:b0:38d:f2a1:a43f
 with SMTP id adf61e73a8af0-39854a814d6mr239546637.42.1772730783352; Thu, 05
 Mar 2026 09:13:03 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:27 -0800
In-Reply-To: <cover.1771630983.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771630983.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272511649.1531226.15957182226632150956.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] Test MADV_COLLAPSE on guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kartikey406@gmail.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7DA55216142
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72869-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[google.com,gmail.com,redhat.com,kernel.org,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,oracle.com,linux-foundation.org,kernel.org,linux.alibaba.com,arm.com,maskray.me,linux.dev,vger.kernel.org,kvack.org,redhat.com,gmail.com,syzkaller.appspotmail.com,nvidia.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, 20 Feb 2026 23:54:34 +0000, Ackerley Tng wrote:
> syzkaller identified that khugepaged, operating on guest_memfd memory,
> could cause guest_memfd folios to get collapsed, leading to a WARNing
> during fault [1].
> 
> Add selftest to guard against similar regressions.
> 
> Changes in v2:
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Wrap madvise() to assert success
      https://github.com/kvm-x86/linux/commit/58f5d8eebd5c
[2/2] KVM: selftests: Test MADV_COLLAPSE on guest_memfd
      https://github.com/kvm-x86/linux/commit/9830209b4ae8

--
https://github.com/kvm-x86/linux/tree/next

