Return-Path: <kvm+bounces-72851-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eL3gAry5qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72851-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:13:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1A7215F33
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DD932303543D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AA53E51E4;
	Thu,  5 Mar 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+KyoYl8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4B3E5EC7
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730636; cv=none; b=UDss/NH4t9lermyIhLha9dZDpYtXpahRHPZxXkgQ9wCtRUNTatMVueYme3waMG0XbXPenSkQPN6dr9vsWdgrgp+PXmwaXicIQxMdtASA4uzgmcCIn9xW7KNgUE6xGK6D/F8dN9vu+9A13ZVNLbWI4G960fa4zD6hj10Q9TL7+3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730636; c=relaxed/simple;
	bh=WkA6bhqVHXNAD0AW/O1ZNRlebfhi7iBwu82y10qmV8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=RnGRnWfa68NZg1uWcPFcwaEKuCDvKX5HUa1vmNtxCmIwDJL2sArSw6NEdpuPyLSiSIHVnskTXUUwk8Nj2bEBYYAr5PkbYjeOwUR9x8qNQzsm1u8R5YMRi06Q6aTZdfmjZl70+Hr/MK/LlbqvH6wOdceUaEXzN88VgxjkbscQV58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+KyoYl8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-359918118ebso11805778a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730634; x=1773335434; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vpF5XUAklAuINmdzxno5piEgS6vaMNJ9l+NrLb6WWA=;
        b=x+KyoYl82fX/E7TJ5mjLTQfs/Bxuji7cAjn1xm30sN8JevAaELTLs/R2htdrUab22J
         gWSbWT+eYlYmUX11gRnRlMWfExrqIVdoMLqYHTBz4KRKAJAewZiFDckFNKKarPULjmQO
         jAkQFyilI+via+ljVgF0vZgo+4o6Z/hWZgg68u4I4Z1UJQI3G3jV1D8JfMw2x4YDJrXw
         aOOoewE+aJskMOns2VB38gb/NZGu1+nEQ7vR81qx6gNd7tZ7Ak2WqfrllOjcjoAEoLX9
         tubFwgIOK7OuwObIsym5fW9YifTM2yfgalCZ/4kaIXhg4MIUxMoVXTgbo5K7fLg1cQL0
         InMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730634; x=1773335434;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vpF5XUAklAuINmdzxno5piEgS6vaMNJ9l+NrLb6WWA=;
        b=k3AdwgU6EqpBmMim9873KGJldAB1HDavvruhfDOwSgbO9e4M/npLs5lj/kWBskBXct
         wlc1c++iZItrW2ce89wjhUd+MC5jd9MIbJpjGSryLIJJEr8IMS2EZn1ZZU3aMtxST+Kc
         uFJGbO8FK77HYvBXWNaEYYBNK4hrVK1p0sCqgqcSEejeCXWRMRUFm+ittklYUvESqkvi
         WdpFKi03qqm9J3KdWs4QgaAZSWdtqzium/M27zSLqtyglbjYacXDc7M5DojApjiqqI2O
         XwojthCttRJUpjPnraBqOS5snGzRcKjRVyn9ocDRLWwtiwpP6EeG9LPO3K/jVlzT4oLc
         puGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+zscsgkOQx7kubfwOzMQjiVtGkc/SqIINOKsCUn19aGDyzz8KDhQATJ2Nm25Sp16MMOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwotJhdvivQYHnky/QPxBLMcF4NA5RUL5sE/Ovgg1+MfknvmCRx
	0Dy4Ylblb6KLiUBTl48tG14jd+TNu62H1TIOjRODxRP6ZNTYLENY5/MK7ttqY+vQR6wU5dxPJU5
	1A6s4Ew==
X-Received: from plse5.prod.google.com ([2002:a17:902:b785:b0:2ae:5e9d:8d52])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e54a:b0:2ae:6205:2345
 with SMTP id d9443c01a7336-2ae6aaae62bmr63658705ad.35.1772730633427; Thu, 05
 Mar 2026 09:10:33 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:51 -0800
In-Reply-To: <20260210062143.1739-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210062143.1739-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272955520.1565395.2506283536176940927.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Mark halt poll and other module parameters with
 appropriate memory attributes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1F1A7215F33
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
	TAGGED_FROM(0.00)[bounces-72851-lists,kvm=lfdr.de];
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

On Tue, 10 Feb 2026 01:21:43 -0500, lirongqing wrote:
> Add '__read_mostly' to the halt polling parameters (halt_poll_ns,
> halt_poll_ns_grow, halt_poll_ns_grow_start, halt_poll_ns_shrink) since
> they are frequently read in hot paths (e.g., vCPU halt handling) but only
> occasionally updated via sysfs. This improves cache locality on SMP
> systems.
> 
> Conversely, mark 'allow_unsafe_mappings' and 'enable_virt_at_load' with
> '__ro_after_init', as they are set only during module initialization via
> kernel command line or early sysfs writes and remain constant thereafter.
> This enhances security by preventing runtime modification and enables
> compiler optimizations.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: Mark halt poll and other module parameters with appropriate memory attributes
      https://github.com/kvm-x86/linux/commit/46ee9d718b9b

--
https://github.com/kvm-x86/linux/tree/next

