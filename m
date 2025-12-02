Return-Path: <kvm+bounces-65056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 511FCC99D24
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:03:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 551534E27D0
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00DE1F37D4;
	Tue,  2 Dec 2025 02:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hym4x8nl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336A61A0BD6
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 02:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641018; cv=none; b=N9Ap9ZSUQVB1+hBEIypbUF6nT8yecvtCQDNHnEGc4tJ1dWzABcYs2r+957fqKxxzIz/pK62iPHjOm5pItPQFcQWCDUfv+REMMtUekvSMTNjyy3XIND42pSvkdL4KxpWithUU8Q7UuC78FFHYb4xjNQY5aNga375nu8xw5G6Rcqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641018; c=relaxed/simple;
	bh=8rVJ83FzmRhqZVUzcIEknO74P8qXDaJF37XTfxZBEtQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ShntH2SWk3pb76GpGD7Of4vYcZG+hnBjXIxlRGlxvajvxm+I0TkTZ5+Q2UtUZUZiKPq5342PpO6KsTKWVtlywWirtPFkELaHfDiEdSL6uSqqQJ1hPorrniyyitst19NaZ/kqAcDtuTIXWpne0ybNWmHrB/dnWbNbf1v91uRieFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hym4x8nl; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e1cf9aedso83998735ad.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 18:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764641016; x=1765245816; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saqGmG+fZVbqKzI/92Gz3sReZk08mzLEAomu2owol5w=;
        b=hym4x8nlsv5inu+PMp8yQMHPEXGImMikc8K0UzD2NUKqZpZiq5u2AtyenWwMmkvQM+
         AJyQCtDpnz555fRAcxYWiU7W9hujCvWyW8UHyRKOaNcIgZdnmGazfr6WpqZ3qZEsjzgG
         xnQRmChehT54mOooa/uSJoDv2/u/SeS/u1/yTRjAqndjzaFBwXC+L1kkuXcitSTzdVip
         XQLY+u1oxvgBrDtfVqXsz2048EJYrEbs9Q2Ga3Hl1G2Pl1GJwPZnlB+lYgrdWFq+/2me
         dJExdA03fctyhHtePgG6GgiVkoozPw5Q00FcEDMDbL1uA/Sscf0fZE/yLe0RMMlDfqvj
         ybiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641016; x=1765245816;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=saqGmG+fZVbqKzI/92Gz3sReZk08mzLEAomu2owol5w=;
        b=k9GSICS8weN+jnb3Rt92XxZloEJScT6ScCMmJ5l0unKlpAdBBGy4Q5NVtIC50+2Pab
         C3Nkotqba6EPnYVAFqAu5ODbMNoX2a+jG9TE2r57Rls3zMxl9GZPxCXI7aMOwzlxSpdc
         Qs1rOS3peCudXMuV9KHjicC7hhGONCk7X9GegYPH4/5ogKbfQk7MYJ3tJs28EbTZFunR
         hXJyb0xir3m/dECSxVTb51Gv0HkwjDghRguA/QZCBhDmCZ8BeoDYLOwo2INmmzPr1VYc
         aiDSRfhpifH9h8JET3eSnfkjR1SQ4gsQvQlLnhBV+KemH8OTkh3nZeQpDVzFD1/vZjEK
         SUCA==
X-Gm-Message-State: AOJu0YxloKU9QG4sQSIVUeDkzj6BRLhrG24oDpUbUG3gEnXVxRMuHeWi
	2xpJy6CjAJyoeSPTWIPVUW9NCsbJhs0w/mJ/WzlxujvC700ACE8IYRldKCWWfLEp3mcUNg4rP2R
	2Wam8rQ==
X-Google-Smtp-Source: AGHT+IHgSAn/YbvGBhdNn6idmhgEikIPAjobi4JltdgUMHtsxTHHZEuJ7jWsllG19H/W/DzAXJFl9uYCRNU=
X-Received: from pleg22.prod.google.com ([2002:a17:902:e396:b0:295:377d:bfc5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:38c4:b0:297:df17:54cd
 with SMTP id d9443c01a7336-29b6becd454mr529105385ad.27.1764641016331; Mon, 01
 Dec 2025 18:03:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 18:03:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202020334.1171351-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Fix a guest_memfd memslot UAF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a UAF due to leaving a dangling guest_memfd memslot binding by
disallowing clearing KVM_MEM_GUEST_MEMFD on a memslot.  The intent was
that guest_memfd memslots would be immutable (could only be deleted),
but somewhat ironically we missed the case where KVM_MEM_GUEST_MEMFD
itself is the only flag that's toggled.

This is an ABI change, but I can't imagine anyone was relying on
disappearing a guest_memfd memslot.

Patch 2 hardens against the UAF, and prepares for allowing FLAGS_ONLY
changes on guest_memfd memslots.  Sooner or later, we're going to allow
dirty logging on guest_memfd, so I think it makes sense to guard against
that so that whoever adds dirty logging support doesn't forget to unbind
on a FLAGS_ONLY change.

I'll respond with the syzkaller reproducer (it's comically simple).

Sean Christopherson (2):
  KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
  KVM: Harden and prepare for modifying existing guest_memfd memslots

 virt/kvm/kvm_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


base-commit: 115d5de2eef32ac5cd488404b44b38789362dbe6
-- 
2.52.0.107.ga0afd4fd5b-goog


