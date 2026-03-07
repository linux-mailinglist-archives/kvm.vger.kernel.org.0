Return-Path: <kvm+bounces-73190-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6B2EDMN3q2l+dQEAu9opvQ
	(envelope-from <kvm+bounces-73190-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:56:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 870CB22928A
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75C023096A4F
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 00:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EEC2D7DF2;
	Sat,  7 Mar 2026 00:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LNzzOMXG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F5F28B7EA
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772844983; cv=none; b=dZ6+H9ytfUe8zwBjhPtgPUIyRWCzmU9pcOCazOMRgJ3jjyoYEUI6ba32BzWfr2Vo4GMFDSUbZY9zklNij8X+rwLUEeLMgn7QrPOyOe/ozQhUN+hs7EFGRfB8huYwF+X2ZtP3t6HERiit7Cmrh5XJxhBVUqYXF3yNkJ6hbjR5pSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772844983; c=relaxed/simple;
	bh=1m13UFepxi8vBneZxZNY81BKCJukqFX3H7//5GS9Pzo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DwHLyTQtFrq42ONN3DAT0sQWqgmsBgCI40mLUyCeH2R4VZEVU4v9BBGJLRw6T4m5NSRVJDNNCUz4oWd7oDsT51qnu5CdGYbhZLFbdGFFkuGMTN1p43giI+2rqg5HtnBj082JZKC4m99DkqoHjoJYq/AQlpWWaGJ2VaibE59lPjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LNzzOMXG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae59e057f1so67975505ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 16:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772844982; x=1773449782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dIjbhoDQye7OtYRjc13MZ8awPXBgsWkB1DkXIBBQwYQ=;
        b=LNzzOMXG3ynpDNYadHkZvk7wBlM1M1SMSqsrcI4R1e34hx7fltsc94tfdX1uGn0/dP
         JrHYl3umEo98UJBtB03fscS1sGS7mnteDDbflu1gdBrunInzi8m7Lg7qQsWf1sL2DLiC
         3+5v7rLSt0radYk7DGI8K0AsRpeEZglkKFkLBMKP1Cf4ZhFyxCiLvG7Ifw6Y3oOPgejp
         SSeXYMZscndDPHbnF7oHWuHH5dK9KPMSEhJOMY3M4gwGK1EldDi0R5etAIzUuFbqJ51n
         bCXYQvAzGkYplDr88G4methTc/3tE87/1LhkmxL/E1/ppwC2WlAkXqd3MFZIKvioVASs
         uFVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772844982; x=1773449782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIjbhoDQye7OtYRjc13MZ8awPXBgsWkB1DkXIBBQwYQ=;
        b=AJppVYnERnIFGtH6PuyuUcvAmD3cphF+JLgywp37gY1w8c3jmtkxMRE5VHhrNOWVkm
         qMbT0A7PYnyFxZy/LjiDFJZlkNYCamJY361MQ2lg4hizzPceTL23EeSXU7Sm3V/muuPL
         1NJlAWOWKcxckhuQ3zwtc/BDuUvlMzfIz5MOQZdDCuK4Tpn5VWOXmfwvPXrfobubEquG
         c/rxe/TPoT4/z7WO6X7qfjPc0OirXY2yH4JPCMmW1vyxlaSOJBzpVM1Fwo/Xgi+JYDLA
         m1c+mTH+Khdlv/J5QjA+Exb9a0QFIvy3K/y6PTGi0imeDU7SUgCtkHyVgE9IokAj1vgQ
         /Zuw==
X-Forwarded-Encrypted: i=1; AJvYcCXpOItJ9fuw9SL8ADacsQTi5aXXIelOfLYjNcgf3kjhj7JRePtwVuNgK0UGl+d6Si+GIP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YytkZhq3Fg1QbwRRfWkR2+qsV4UCyiPNp04kzgrI4yi3J7ExZKp
	db4hzwpf3rscAihDZIXWdQCTQ67Ye7ZwCnyBtJYza/kYJgkfSZ726lpEbKImnjbprlXkOhXc+zs
	0XRqSOg==
X-Received: from plbkn5.prod.google.com ([2002:a17:903:785:b0:2ae:478e:82bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:244e:b0:2ad:d0ff:2ed4
 with SMTP id d9443c01a7336-2ae8236740amr38087585ad.6.1772844981812; Fri, 06
 Mar 2026 16:56:21 -0800 (PST)
Date: Fri, 6 Mar 2026 16:56:19 -0800
In-Reply-To: <CAO9r8zO+sTttrKscx+9Sr+TECLrb5rHFTPThHYZG_e1qKSo+Cg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306002327.1225504-1-yosry@kernel.org> <aar-gDulqlXtVDhR@google.com>
 <CAO9r8zO+sTttrKscx+9Sr+TECLrb5rHFTPThHYZG_e1qKSo+Cg@mail.gmail.com>
Message-ID: <aat3s9EjKB_IsQQf@google.com>
Subject: Re: [PATCH] KVM: SVM: Propagate Translation Cache Extensions to the guest
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 870CB22928A
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
	TAGGED_FROM(0.00)[bounces-73190-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.941];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Yosry Ahmed wrote:
> > Hrm, I think we should handle all of the kvm_enable_efer_bits() calls that are
> > conditioned only on CPU support in common code.  While it's highly unlikely Intel
> > CPUs will ever support more EFER-based features, if they do, then KVM will
> > over-report support since kvm_initialize_cpu_caps() will effectively enable the
> > feature, but VMX won't enable the corresponding EFER bit.
> >
> > I can't think anything that will go sideways if we rely purely on KVM caps, so
> > get to something like this as prep work, and then land TCE in common x86?
> 
> Taking a second look here, doesn't this break the changes introduced
> by commit 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks
> for host-initiated writes")? Userspace writes may fail if the
> corresponding CPUID feature is not enabled.

No, because kvm_cpu_cap_has() == boot_cpu_has() filtered by what KVM supports.
All of these EFER updates subtly rely on KVM enabling the associated CPUID
feature in kvm_set_cpu_caps().

If we used guest_cpu_cap_has(), then yes, that would be a problem.

