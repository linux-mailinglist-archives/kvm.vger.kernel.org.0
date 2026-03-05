Return-Path: <kvm+bounces-72844-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MHNRONy4qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72844-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 993CD215E48
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 37A4F302087E
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDEA3DFC82;
	Thu,  5 Mar 2026 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ci4byus8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999E3DFC87
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730563; cv=none; b=sh/1yKMRdbtm8mQjuQN7yWDI2Y2p33QZmD+cDamFpoBOAPnqhTYpE6sOqgEj/KIK1/dr/qUfDu8jq6MbpUOFL8aMUVq4bCSnYHyezuO8IBYUq5kCP2yDNO0SVAbgtIK0u9+pzHn1jrezVwZvhnoJdlg1t2OZkgkFQNQpeoIN2zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730563; c=relaxed/simple;
	bh=pmd0kgsXpifQv4RFlJtOfO+z0ZUbvCTIE8UEmMwTzlw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZYwmqQmBqH1Wl7s0KpnMSm8ZeNJxQUDlUFDEPcgiS026FI3gSq3AJsqa8agD54gp+eCO5JQlgQQtIguAYJjAJOVBrQJv6Qtn5fxhdc5CDSteqats5ZNJkRq1pgiqWEDDIJ24/xR4dhohD+SW8G9WbX0AytXNSTWX4Cgn4g7V4pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ci4byus8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae405e95f5so56460825ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730561; x=1773335361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXHR39iK88pUvmfbC1CZBCR/+Uyn5F0o8E7v0BeMRFQ=;
        b=ci4byus8NnQPgN2WTHQR2iUaXEuqTeBN0JMkWJvW8OvPHTwebjHJFTQ/8yqu3WO4Ii
         Wo9sLavrDEcmGTWcSPzpM2SMhFHqBDsTBO+ugT7fxyg3+JwIo7wA4IYphKtgYzgwogRv
         f7F7yhN/b5D8skhh/iZ0MwCwasKwFIWF9m4BAGs3DVLPgSQxeQbRQ5WgJAJRfatjDqPa
         +R7YMicNM+tP5kxN1fWeh7NShinzkxpO2QNvflep+bxxb+8nCLl/1FMjXwh47tChLQit
         CesD48Rj8gI9WWzyJ09qTqL8EZiWMve+uF2ghOBqmSUgk6J0U4s3B5WgL/qMgMOF293Z
         z9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730561; x=1773335361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXHR39iK88pUvmfbC1CZBCR/+Uyn5F0o8E7v0BeMRFQ=;
        b=u24y4b/LcMFasCOxHkpxSReTX+opYqSkL9ERAbAxaC4W1ezoD1F1O/5j/C5QNmZLPm
         gdWKR3JpTMQjy6l+wpxUjdQuTrmlYmZMeAtDU2yMUzsI9hZG4hKDjO5k8dOFvGs6v81f
         d5Tfx8je839B1eVAxpGjTxcS6cH+c2a1nx63Q3q0PEkhTqTpKVmzhiH+i3OgXJvzJ3/O
         MPgOwKVfzEOMRRpoZ5lIu64LgZ2DW+WVWZFWL5NCI4qLhNJe0Nan8Me6GbYv2G0RSe+g
         d+WvWZRiPC9l12j8Ljh5b7H79RDgkCsKv4GYMR55+WiH1z/bsRR7dqKwnIWCU1x+2jO6
         0W9A==
X-Forwarded-Encrypted: i=1; AJvYcCUu3UjFxgK26zNLRyj/mj0ME8pHzjkCqaeoqHGIglqq8G7gQdMtTsd5bIUdpNlpudU3maY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWm5bcIlV/Sbl5S4FNXn5oWYx5GPcs1doWCRvMTDpnh+2oe4T/
	eklhLrTZoWU9kTXYwlAnv4ra1roUlTwVXGDotfmJDmxytyrnUD9NMWjKB/BCRKDcOYsdY+Z9PTU
	JDCMmKw==
X-Received: from plbz5.prod.google.com ([2002:a17:902:ee05:b0:2ae:4edd:69c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b47:b0:2ae:6d9e:ed5a
 with SMTP id d9443c01a7336-2ae801506c0mr3897215ad.13.1772730560854; Thu, 05
 Mar 2026 09:09:20 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:39 -0800
In-Reply-To: <20260303190339.974325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303190339.974325-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272543796.1535167.14939828079649935273.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: PPC: e500: Fix build error due to crappy KVM code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 993CD215E48
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
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72844-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, 03 Mar 2026 11:03:37 -0800, Sean Christopherson wrote:
> Fix an e500 build error that was introduced by the recent kmalloc_obj()
> conversion, but in reality is due to crappy KVM code that has existed for
> ~13 years.
> 
> I'm taking this through kvm-x86 fixes, because it's breaking my testing setup,
> and obviously no one cares about KVM e500 since PPC_WERROR is default 'y' and
> needs to be explicitly disabled via PPC_DISABLE_WERROR.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/2] KVM: PPC: e500: Fix build error due to using kmalloc_obj() with wrong type
      https://github.com/kvm-x86/linux/commit/a223ccf0af6e
[2/2] KVM: PPC: e500: Rip out "struct tlbe_ref"
      https://github.com/kvm-x86/linux/commit/3271085a7f10

--
https://github.com/kvm-x86/linux/tree/next

