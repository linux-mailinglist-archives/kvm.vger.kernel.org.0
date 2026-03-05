Return-Path: <kvm+bounces-72876-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGr3Nb27qWlzDgEAu9opvQ
	(envelope-from <kvm+bounces-72876-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 484F7216162
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F2570324F9FA
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1353ECBC0;
	Thu,  5 Mar 2026 17:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iyii2bst"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E72F3E1229
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730833; cv=none; b=ld7SJ9hQsP7pv2jSjlS6LUApokSUeBh42rUTSrCz0GMZTgWZhHOGgFa4qL31YgN4yeZDwdC/Q/emmAEBP6kFcpnSRt4y8GZrXmXVgcay3K2+epdPZmBZyBL4v7rpTrHT9Q4AqkPaNSTFanrI/zaIwFAq3M4AAG7Z2ZotBr4tbnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730833; c=relaxed/simple;
	bh=0XUD5BAnUCRqJrt5J3VfKN54QNwr0xLXKDTL1rvjViE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C3ltTFH8RtquRXT7nRo0BKFhNy4+EnB/KfCMDPD+C7kGQGZ62KME9IM9BVkcA5jKTAa7mtIfAzJ9egO9+aiyred2/1tEWjU2SFJDio9akFn08Ova04IbEFolPTofXYYdykxx13o2S3macVEWojKuQBEAxw/j7bTwTAPRPQg4648=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iyii2bst; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-359812e4fefso3529125a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730832; x=1773335632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CRZNdKY8tcJVfQEc8w3qKnNfGaHAS44lUi77zj94QkM=;
        b=Iyii2bstoZp520uCQzk25DnB1mZ7R2cMiBWbD/+XfBe8Z+3nvE+MfMsFmJ8Msg/nYX
         w7DRV4m1ymWbrNmMJbtqshc1Eb6pTY3fwWu4RfoWm7cghT8lksenxPJXMIYV/0iDzaGk
         agu9Wk/z5aNmxjv0O9JjQQWpafp0ZHkuVuk8iYmrWu3Ks3YW/kzS7Z6KYnJASmWStEe5
         gICOoAG32G+GfQFqHtnlxsmNCRGYUC2AUT2vae+H3MFUW98FJOL8kaUp5I8zAmlZEcR9
         ZWmFEEZr8PpyjTDzUG1Hbhhyha/yKwEZpo0NJgEtNzpusJxC9LvRiX2NnciU7gJTV3K9
         OkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730832; x=1773335632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRZNdKY8tcJVfQEc8w3qKnNfGaHAS44lUi77zj94QkM=;
        b=pk7TSTuOTS9S1YntGf7fexlxberVDGRY3N4gEmkUnaxXZ0UhXZl33BbwGTwO9TBwSz
         fzoSAwvE2b6NqKZo5xbdEnc8zSGmH40krFemL5gXK8s/W94ocXa8bUjz2kSkS+ALaSkY
         UcpoeE7p3fMpCr1f+INDqerz3WeuLFvItZ6oLtzrFQWWsLf/sLwr9whhYo8Qvyc5tQzz
         YhvpSpyRHBQB7k9BGsihAUngU+knPCU1GWeC0DTttas3pvbPSbCYVUzEzRKEXmgFuRTC
         Zc2XLZW4KgwcXL0aCjrREZR1S4itMy5C6wiCUrRqbfnqNhW+ucX3EfJz8WXcs1tH0yrr
         J1gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHqohc3PXiMkGYJ7aU+SAuNi1iXhs6vX3qjSq07nq6Vnu6dGFvfsAsmPHgsD+mQE6RSPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwltpFgnUKGX723vRSAiI9ZVOxWfHh5nCYkPoUowHqeL6vDbt72
	x1pHKs/jBuKYTiq8aSOEGNYaUhWETjuXFpEapYU+9EB5TU3XznyK7Gh5G1mUtE5TAVy9m9RKPit
	2Mdla0Q==
X-Received: from plbbh8.prod.google.com ([2002:a17:902:a988:b0:2ae:3c5d:ec0e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c410:b0:2ae:5346:d4e6
 with SMTP id d9443c01a7336-2ae75c6c932mr33611435ad.28.1772730831639; Thu, 05
 Mar 2026 09:13:51 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:41 -0800
In-Reply-To: <20260211102928.100944-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211102928.100944-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272954596.1565167.8442601996349101861.b4-ty@google.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 484F7216162
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
	TAGGED_FROM(0.00)[bounces-72876-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[google.com,vger.kernel.org,kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 11:28:49 +0100, Uros Bizjak wrote:
> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> inline assembly sequences.
> 
> These prefixes (CS/DS segment overrides used as branch hints on
> very old x86 CPUs) have been ignored by modern processors for a
> long time. Keeping them provides no measurable benefit and only
> enlarges the generated code.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: VMX: Drop obsolete branch hint prefixes from inline asm
      https://github.com/kvm-x86/linux/commit/6dad59124e15
[2/2] KVM: VMX: Use ASM_INPUT_RM in __vmcs_writel
      https://github.com/kvm-x86/linux/commit/192f777b3af0

--
https://github.com/kvm-x86/linux/tree/next

