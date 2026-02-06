Return-Path: <kvm+bounces-70391-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBrHGgJChWmA+wMAu9opvQ
	(envelope-from <kvm+bounces-70391-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:21:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6757F8EF6
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55417302D5D6
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E086523ED5B;
	Fri,  6 Feb 2026 01:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hM26NsTG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024C423B63C
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770340828; cv=none; b=LAlywrbauBH4BnPGNAzuKMioPkn7pJFC+OpcO3+1XnywvYS+dc2nBsiEhIAFIzdMg+mb3cWwTn1XilBpP+WFoJM6Qn8QobzGx0p2nOM0117L2cdj3twN9cTlItqASr9IkJI38xUcDtaJCWqryDPqmc7K0uGXl75wzR/qSMf+tEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770340828; c=relaxed/simple;
	bh=aXXx4a7HRCOQLrHiRmrwTqtV4sqi2oXBKeSkyKaj3tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1s3DFnsLygtjLLi2nBjuetuy5MDAov8O5IFHQA82JKeryZDoUrC9M3eyA1u29jRgddCrA+wyTRkoKZOU4djaigfophdtW1++TQv3m3Fbfq6uOnLnXPJyXlMPjZcewF8KK9sniW9euBYz3nVI16GiCSg0bQetL5lS6NMwpmbOd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hM26NsTG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a943e214daso35668725ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770340827; x=1770945627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaNLpZPtKqlc/2giLWuacVY9PXV/N+L9JNqLWxBwmqk=;
        b=hM26NsTGr5YMvPZTyoF/ed5Mn8+IY4Y56w1dr4EgAr0m6dOfa+29rp3DsUc3MAl7WM
         GfMHsqqvd23EzCOzV9jFJFtGJYfH3F1FKqA2HdAesjR9/73trLSBVJP+I1t0L7JE16aM
         vK40Jnb6pMGh4r8yHykePbbeBegt9fsSj2d2LLdCktNta1rDXaAlpe5T+MtCJcnGMKNi
         wx3Dbt+1cQ5yDMVsA82SRH6MKp2YQshSXU8dE2DOg4kyt8a/PGUragyRstwE5pTRrT5J
         JhiA/9cHfsLTR6ZUw3IdaE8NgDG32NmiSplDK2WQhEWbkDTRyFjWFxnOwuCjGzGhqpcJ
         pYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770340827; x=1770945627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaNLpZPtKqlc/2giLWuacVY9PXV/N+L9JNqLWxBwmqk=;
        b=lDlhGJgx9KIZppOZKoOYmX4eY6qxncEenVEhYy45VFV6Vu06S6PpfTyuS4ux40wiUw
         6CkM+BWCihWFyB+tu7X+5dP2y6UCiioz0+/+UFwCyVqzpM19BHB7bAksV/rDuH4hNCkX
         fj64elq9GVAFMOd9cNNkdjRxD8vkZKg0dCf7xa5CX26eqWYy6rXmGb8t2spIRv2XKJ9N
         kcjduyzPjRUDNoZOdH1efq1sACBupVWfkDNt0DDP2Uby19GJ4PHU6tsGbIhIN/6jWe0k
         5burE7ekaQN84HhKYst1OTrbGXaocAQgyuPoD2Kq4v+8SXC3KMyaM/mWICcUHQet/WZ3
         nt7A==
X-Forwarded-Encrypted: i=1; AJvYcCVgWrj7iLn4VCY4NYi5HihiGjqszjeIMbjLTVk9HKPutMh5NZHbc0ZhachFJXHNEcjpmMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV4oagsOKo1+GNgiDhKADko9UbckbwYJgEHH4HJO0owJ6ziaAI
	a/Us+5aK4SkhCSeHh29w06jSJFAbJ4VtPwYyW6fWVBLeqJpuKEjHjZl3QApavVvzM/0D53gWloQ
	YlekY9w==
X-Received: from plbms3.prod.google.com ([2002:a17:903:ac3:b0:2a9:4460:be67])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74e:b0:2a9:411a:c5c6
 with SMTP id d9443c01a7336-2a9516fcf5dmr12129195ad.39.1770340827335; Thu, 05
 Feb 2026 17:20:27 -0800 (PST)
Date: Thu, 5 Feb 2026 17:20:26 -0800
In-Reply-To: <20260115011312.3675857-14-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev> <20260115011312.3675857-14-yosry.ahmed@linux.dev>
Message-ID: <aYVB2qYZh1smeBBL@google.com>
Subject: Re: [PATCH v4 13/26] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-70391-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E6757F8EF6
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> There are currently two possible causes of VMRUN failures:

Might be worth qualifying this with:

  There are currently two possible causes of VMRUN failures emulated by
  KVM:

Because there are more than two causes in the APM and hardware, they're just not
emulated by KVM.

