Return-Path: <kvm+bounces-72847-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KG43FAC5qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72847-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E5380215E93
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC85F3014A12
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E083B3E0C54;
	Thu,  5 Mar 2026 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Juu/zVXj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7E3CE4A0
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730606; cv=none; b=A4uHo9ZYcwz7DMuy91sUlHfRO1HIUhkXmpIVmmgse3+XH9/Smz3Vzdm4XAh/RkP/aqVHVdafo33Tny9FTHU4D+qfnuzpWGwDL63R47UbAlj4cEJFrJg2t6/azh59U+l4tq3e/T1/0S6axlvZqmVZGVCmo6PotYh2L6jf0jqGQ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730606; c=relaxed/simple;
	bh=L3RYSu1T2N19K0U1xTMmiGCiOFUx1IC/oSSIOr8cyKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TUMIJdrRd1HaGySdi1OpYuJ3wj1oHHC7pdaGVhP4VoBX7BUOgLyVcsBEH2kXLisTfMRN0mj/ZQTM3ezpl84/YUtr+Zn/k/wt4j7ftdG5CnEppNN2PCKFYdHJbdc2v3pfYW09Bt/9LnNWHsUmUYdiKmdZ/UFnk65mRuiRCMSRtZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Juu/zVXj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae3f446ccfso51330965ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730604; x=1773335404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJ+V04ocRWIJudwBCiZNPVDH3Kw+t4jmYStMiZHQYXQ=;
        b=Juu/zVXjgJLfcgeeHd6JGCg4yoU3+sz2x5QJzT1++sjHkIePvF90wpekxCKqY+RrO1
         cF1ZW7rxkBzJgMw/CCRKGQEcpAx0vM320mkvQgjyt/el/AUeJfamNvNeWdG8vRYbQ2mE
         DfwvHZYbz7xKRJN96QDsUyhy6RBqNVjBfGb6y2lZwmvF5A7ZvZBA3ss5U5UfqQzO4NQi
         kX9a+i2/lcKBdfLwTNkuN5p5NTrJQbZdJ4/L3GsDQM5jEvyPXU4TFm3OPUAH64W9broo
         mCi3yrpjPUG6apn/FUKFchS6NIhA5l0uNJ1AK0ARU+7KcoIVo6yScnSl30fOICd5cLNb
         QZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730604; x=1773335404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JJ+V04ocRWIJudwBCiZNPVDH3Kw+t4jmYStMiZHQYXQ=;
        b=GctusS4asBbv8HhyaCFzihCQvnCBIeNa3AQgywAAk5ykte+vMCb2cjpmNy76VbHDPz
         JEbT9qZ1e5Wbid/FEvB1geGZ0brBK/O8Vh5Sbgq8lnK3R59Nef3e2tcIrVCqO1nQtZBm
         YpIiH5ZFb09jU1VYHaV9tmktPzu0zBXdqb8ydsAjWUn7hvYnCuKXGOu2h4B7ciK18O1L
         s51oPbcPVqm6oIMnPpFizuxkpHp4PRia2KIYvZ9n21bVhD60WBZa6h15QPpcUvRruogd
         9cPJpsDqQOhF3IHig8hL2QqiUifqq49JrYQx7ycUCwkZlhvnoC0MiemIOG91llTiudlt
         oiog==
X-Gm-Message-State: AOJu0Yz/fZZo9sD7Cciqes5s4h34D3pnwCXnOZjOEAW/f3fWPOT3WF18
	hnbUs+wdmmKLH0OQYjqYfveDP83f4xP9rE+nt+okkOw2ECojgilyAF0+T0G1HeeUG5c2C/SfJAT
	DiuCR0Q==
X-Received: from plrd24.prod.google.com ([2002:a17:902:aa98:b0:2ae:4655:2b3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:190:b0:2a0:8ca7:69de
 with SMTP id d9443c01a7336-2ae6ab1f727mr65695835ad.41.1772730604332; Thu, 05
 Mar 2026 09:10:04 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:43 -0800
In-Reply-To: <20260302170239.596810-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260302170239.596810-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273035456.1571669.11141510645130203244.b4-ty@google.com>
Subject: Re: [PATCH v2] Documentation: KVM: Formalizing taking vcpu->mutex
 *outside* of kvm->slots_lock
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: E5380215E93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72847-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 02 Mar 2026 09:02:39 -0800, Sean Christopherson wrote:
> Explicitly document the ordering of vcpu->mutex being taken *outside* of
> kvm->slots_lock.  While somewhat unintuitive since vCPUs conceptually have
> narrower scope than VMs, the scope of the owning object (vCPU versus VM)
> doesn't automatically carry over to the lock.  In this case, vcpu->mutex
> has far broader scope than kvm->slots_lock.  As Paolo put it, it's a
> "don't worry about multiple ioctls at the same time" mutex that's intended
> to be taken at the outer edges of KVM.
> 
> [...]

Applied to kvm-x86 generic.

[1/1] Documentation: KVM: Formalizing taking vcpu->mutex *outside* of kvm->slots_lock
      https://github.com/kvm-x86/linux/commit/f8211e95dfda

--
https://github.com/kvm-x86/linux/tree/next

