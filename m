Return-Path: <kvm+bounces-70119-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEjtLLaOgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70119-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D530DFEE2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4399330C5306
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B202E33993;
	Wed,  4 Feb 2026 00:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fa0FlzXV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892CE182D0
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163841; cv=none; b=a4seZ9Yvi4ZY5M62Jy6jPCiZMT+Frn4gZ6iDlI+EZk91JUS7tjvsWpZ5crEKviyHPbkbcfxu11Q/HTPIQz6dys+Yf0v/6ZP5a7+eHUY+jSeAUvF+XWKDaJvv04roBl9/9V9JeA6KJJXuGa/JAb2zZ1KNiU6Zm5hkAYhpmxJegzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163841; c=relaxed/simple;
	bh=jZ3vlTcO/4ulnqY7jw5dZ3hjdbQMjCoVlfVlP4fF10M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nTulwTcw+ChU2EKeFMXHkge7hOXGKOp86rlwwFDS+dBIcUPBpCAL5taJNj6BopEDs0u3vXLv2xOSem3cjbT0YqS7tW4tRvLhyIhT+J1YVGra5s8FHg53gqgURSuiB3qEkndW0klNotbi1mIEfmqXsVf2LaxT4Pd+PY/cfeqQ5es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fa0FlzXV; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66485ced4cdso18348743eaf.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163839; x=1770768639; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8p8NbRPCPDmkixC3vF525swc1H8aTdK9eIWx03vtzI=;
        b=fa0FlzXVRr/enafgCyiyX4UMj9XCyZF2U3aMYQfQa2IMpdX30RFqS4uvg4rzdz0vn8
         +LqgkSliBeV/zaYCaXvYnuwma1qV7/rMhpj2iNV2h4pS1hhxkEfJ5Kt2ghNU+CHkVsLU
         vmtf7X2I/icICQcaSR6FBEdckEgd9ZYPLhrlnVV5f4lQUEjGvasCnp0lXQ412NjyWTp2
         CEeJ+NbKFIQqYVgKDuLPS+dVgalyLOb2VBhCV2hSzRZaqy+KzRr0AC89GKnCLqdceRAK
         aZrCNbxAfaUzRZBANrgQOpytuWSIVPnjhf+2h7Jo5FuqpM7P5TzLFQ2+zoJjFaeW6Gzj
         8QpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163839; x=1770768639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8p8NbRPCPDmkixC3vF525swc1H8aTdK9eIWx03vtzI=;
        b=mXmfA1rFlIWzyGzcRu/8gTa8i5KsKRb7bhWWXI75+E6wWqJ+O3tBQOcE/eCA0HGUBq
         50G6mcQeRxj5Gow8Fep30Ss0j9W4M3glO1ktvr4Xlfz6/lIzFENhlw1B1eP6xm6lNOg7
         YTwWEW1917r9FGNNgwwqH+/uY4h7NQm7jw7CDNonSRF7/+zUNFIjbDhV19znyGPC9qPV
         lEezDwKNn4g8mvTvd9RzMCtmJB5kf/qULXFTKWLzU0BaNJ28HknX2sGTLrm0a7pP/CB0
         35I5xbovfUT5CgNSIYHBsILr61nSkrSH9ZwEIasRzZtyTUDBXJnJ5vG+uySbUeFcg4WX
         NrrA==
X-Forwarded-Encrypted: i=1; AJvYcCUVBi369GvjJqqDssFUvvIkVXfU2gyaJ9cHGMi362xTNDsuv1iKHGwOh/h/3TeR7YG+n3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4gpHNZvYmgg3IssTdP+szs5NaUJMnp+A+Mdv+GBHO47SCAw7y
	sKKeA7DtMTb0sHo5nJsrm0IDGr/LXCDo7tGdkfmn6partJWFKLA/S/kXxF+kitequ67cMIr8LRA
	vZcLIBA==
X-Received: from ileg11.prod.google.com ([2002:a05:6e02:1a2b:b0:447:81b5:ae2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4889:b0:663:859:c429
 with SMTP id 006d021491bc7-66a23334fb3mr580988eaf.59.1770163839458; Tue, 03
 Feb 2026 16:10:39 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:19 -0800
In-Reply-To: <20260123222801.646123-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123222801.646123-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016337221.570259.7480661884479606401.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vasiliy Kovalev <kovalev@altlinux.org>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="utf-8"
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
	TAGGED_FROM(0.00)[bounces-70119-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6D530DFEE2
X-Rspamd-Action: no action

On Sat, 24 Jan 2026 01:28:01 +0300, Vasiliy Kovalev wrote:
> Add SRCU read-side protection when reading PDPTR registers in
> __get_sregs2().
> 
> Reading PDPTRs may trigger access to guest memory:
> kvm_pdptr_read() -> svm_cache_reg() -> load_pdptrs() ->
> kvm_vcpu_read_guest_page() -> kvm_vcpu_gfn_to_memslot()
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()
      https://github.com/kvm-x86/linux/commit/95d848dc7e63

--
https://github.com/kvm-x86/linux/tree/next

