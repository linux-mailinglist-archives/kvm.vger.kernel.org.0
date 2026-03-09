Return-Path: <kvm+bounces-73308-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wAgoFM7brmm/JQIAu9opvQ
	(envelope-from <kvm+bounces-73308-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:40:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB2A23AAFA
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 15:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DFCD630233C5
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 14:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CF13CD8C7;
	Mon,  9 Mar 2026 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MPIOx/M2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B869E3C3C00
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067164; cv=none; b=ZRYC6HxAkFw545QQCgF/goI4SV2a4dVIwBNzTjz5sx01o3sYZe1/8dfy6EsVB0UCqmuNgh4nGM1J6I9AePvsT1Nx3zYZi1nqv090bVwCVAdUfvb4wJ3qQfp2QVpFJSIxcno5EEIUwIZ/efQAxplIKR8Rr42MPf1m5aG2/Fc1jN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067164; c=relaxed/simple;
	bh=BIM4Heb2uzUyQruP5xoLyEqYs2MA8E9GLjscLzPwHlo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYuNmJFk/x4giZOkU+IHU/Cw8b2u1RZz8yhx7um4JEkByi2XHG+WfcggvoMYyPOxe/aWXWD/wuGdTZpifF3VnZjAG0J3XIr3Zfox2tjQM6cAH0CrMD8pnqRQpapVvAK9ihZLDJDF7VeOzIVL2Rx1bQ/u58r4jD/wepFyjUna0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MPIOx/M2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae4e20a414so460195325ad.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 07:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773067163; x=1773671963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hN9R5FLcgFk8CiIMd7b9HeLWPaKouwQ/dWho0PeKE1I=;
        b=MPIOx/M2K+50RNzSyWcA0cBIRh6ypHaDW6ARLJsF90M4w5cPZmGxaXWwRXmXB2Eiub
         5191QjSJbVOSOoI5Nt5VD+flCJK5FaNFgRPDY/r2JkeuNswY6NWdf87GGwxB/DNky9Zo
         /8CuQCPQu1Sy+hLnJKWnKJb3d8t4qj9aCvABXXaLh8vGyYd8rk5ONTueGXXDRk3GMO2E
         WxWvWpn2Yb7Pxasv6mDRHzgn7jfTlXyAJg3mhFW5vO938LzFEF94CD1dNqAudd7euTtD
         oaPJDdvHHS7bmo6oMDXh9DNJS3jIu7xgLe+2cyFOkehHLZJJtRFWiesbLLPVKPvo8uzP
         hLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067163; x=1773671963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hN9R5FLcgFk8CiIMd7b9HeLWPaKouwQ/dWho0PeKE1I=;
        b=qloTWQumt/I74DpJm7Np/ElWBfBn88xl0ggCJJrNSCKWXOyCldFJZYeoOx2/J73OXQ
         NIuO0aK9X3I+UJwf4oCDA1YmKNt4CithuZ77oxlgcRZM7wJoMTRr+TA1ie/nMQzfpBMs
         j51J1QupkWrQ8hE12WngzjMAheUa9+SpW6GlE0KxR94QT9zLwOuUC8CvzjJtnwxhuuyf
         A4SQZFAnucrmxgOuA66q69X/l/9GboUZNXP4XAR92i6ncodA4ZBQBtlXr2CK0OBWyZJu
         2Y37VezZvrwW15SigmAohYCq6YPhZDCxIxCFnfiEyiaziBQQrNzoEkQe3AkPSCgvHN4m
         Wnyw==
X-Forwarded-Encrypted: i=1; AJvYcCWZwwUjBNmpL2BrKgrYG/BdOlw8KzvcLNziqNdI+/t5D/sjM/7BmsGTqGS0HgUNx8VzFgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNqiGbXzqnyJznzp1LrwosN41cg9POOSeWDzY3mBy4S18+irsy
	bi+GR8ajXNRkL5zv4rfIDGQbYZutia/reKq0LLEoJY0sf7FBzD+wvsnZU/PR6dr1SwNWQkmGszX
	pUx0v4Q==
X-Received: from plblc5.prod.google.com ([2002:a17:902:fa85:b0:2ae:3a49:7600])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:182:b0:2ae:517a:6c28
 with SMTP id d9443c01a7336-2ae8242d431mr121241785ad.29.1773067149822; Mon, 09
 Mar 2026 07:39:09 -0700 (PDT)
Date: Mon, 9 Mar 2026 07:39:08 -0700
In-Reply-To: <20260309075629.24569-2-phind.uet@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260309075629.24569-2-phind.uet@gmail.com>
Message-ID: <aa7bjEJ_ICGjuiy5@google.com>
Subject: Re: [PATCH] KVM: pfncache: Fix uhva validity check in kvm_gpc_is_valid_len()
From: Sean Christopherson <seanjc@google.com>
To: phind.uet@gmail.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: BDB2A23AAFA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73308-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.937];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,cde12433b6c56f55d9ed];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, phind.uet@gmail.com wrote:
> From: Nguyen Dinh Phi <phind.uet@gmail.com>
> 
> In kvm_gpc_is_valid_len(), if the GPA is an error GPA, the function uses
> uhva to calculate the page offset. However, if uhva is invalid, its value
> can still be page-aligned (for example, PAGE_OFFSET) and this function will
> still return true.

The HVA really shouldn't be invalid in the first place.  Ideally, Xen code wouldn't
call kvm_gpc_refresh() on an inactive cache, but I suspect we'd end up with TOCTOU
flaws even if we tried to add checks.

The next best thing would be to explicitly check if the gpc is active.  That should
preserve the WARN if KVM tries to pass in a garbage address to __kvm_gpc_activate().

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b488a..8372d1712471 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -369,6 +369,9 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 
        guard(mutex)(&gpc->refresh_lock);
 
+       if (!gpc->active)
+               return -EINVAL;
+
        if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
                return -EINVAL;

