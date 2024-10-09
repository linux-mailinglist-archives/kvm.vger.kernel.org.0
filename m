Return-Path: <kvm+bounces-28247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD015996D4E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73209B20307
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 14:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1806119C563;
	Wed,  9 Oct 2024 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3iWbKCp3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7116F0E8
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 14:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728482924; cv=none; b=E9kiSUuFww4lUUI/gwcjeTERdgC39zb4ZenAOp0lULVL/0LbtuzL15N6XQQDSTkv5tP9yjmKB6z2iHdQMh/Nw5y1mA4csGs8Xmsg/LOrlKMsoTQoMbUfrfAeus+UCH7kcOaq8YNG2I1Y6ixSK9DSxVqlB8TnUgv9JUe9KK1lFD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728482924; c=relaxed/simple;
	bh=KljJxQ/OWT71XfVWKRRyLm/W+KW1HyZb0g/1eexmMM4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=O/GePKqCIN1DrBXago+ovUxSH4eMSqqOiVHhqb582mPTfzESUYaAqwNSRgpXcuyMyTJKXsTKTk8EtRmwfQ8wj4xdTE38/dLTeIAs2ANrcVVqJt2+Y312sMSbDR6aLWbqhnUTTufG4EbvJ/PUyQc5eCKb0uv8fnnmp+36Eh7lNiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3iWbKCp3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea00becea0so4829757a12.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 07:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728482921; x=1729087721; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a/TgKPDJtlyGGleExLO5W0VtSazwFjGgCKY+93bmZ9I=;
        b=3iWbKCp3cxMKZ+CecI+q2+yfl4TdOv7l/sXRV5JDlTpXKWMQFqZx+9TLb/3qSfU4Ow
         m50oNFGTalWGjorycanidTd/I1zNGiuM1VGHBePRM/45fpdlt1s2ujvjnvXPB+u0y1Bb
         55CswlsuJhCCkraqWLFtcLGnQp4ObqPBYpf9O7WkrDBarMHYbVdeYw/Gyvlci0wuMdH5
         6ocqCEyJhJGqdBqsFMolGhgWhV7gDhkoFG09KkN0mg8f4cNbAY5nvk/Dzz/NW6pWbz1K
         rt85Y4trHNiaQn9gJ2q1GGfgVEKJrTC56wEF1yP15qRkZ/vyhtcWY+2D/Ns2BFSZA9RD
         JStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728482921; x=1729087721;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a/TgKPDJtlyGGleExLO5W0VtSazwFjGgCKY+93bmZ9I=;
        b=sh3Debz17DcI9OlADRu+G7vUwAso+HfFXK125RiggXnZ9ID2YGnNpRq31/344teHKk
         PLeidrnASD1wFEFWG+AGsAhisgjeyFN2ESBabZUs3mKGg+KC4sdtr4mwbYt9Dh1HfLYk
         y859YU8M8EDDVkYU/uSdzHPjuN7FaQ8ulBwkK2LzAe/NKYd/whmFJ0Ub4Ksp1wTOysd2
         FvUCf4sEyzZV7itQALVvkc2oR9WeAkbhZhFnnByCMpZ5/NS+gKJ5kqfWaCgQhQ+Msjrn
         g8BmW7n25EO8n5I6g1jZYqBLbUYkMlsy5bIWE7m19OFLjq4X4rAO7O3Yo6eduvnT2VuT
         AxLA==
X-Gm-Message-State: AOJu0YyKmWTV2hk8yhq9HaNSKAAW0KfAXAzGqFpI5e+4M9xlFn0zOMeY
	6i58DWlIPDwdNfiyY5yMK+scLSrMXrPgbT86BxLyNyNjHrr1qV7bL/tBdLr05vHF1wGceMQ/saG
	OKA==
X-Google-Smtp-Source: AGHT+IHntPVw5fd0BlDT/g077iqrcOvcnBRJX+HnjviW7h72wCo00ygJwdJoZdAmZWM/SPfDqFzQU1v0bH8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:db52:0:b0:7db:1b12:5e08 with SMTP id
 41be03b00d2f7-7ea32095d1fmr4582a12.4.1728482921005; Wed, 09 Oct 2024 07:08:41
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 07:08:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009140838.1036226-1-seanjc@google.com>
Subject: [PATCH] KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kirk Swidowski <swidowski@google.com>, Andy Nguyen <theflow@google.com>, 3pvd <3pvd@google.com>
Content-Type: text/plain; charset="UTF-8"

Ignore nCR3[4:0] when loading PDPTEs from memory for nested SVM, as bits
4:0 of CR3 are ignored when PAE paging is used, and thus VMRUN doesn't
enforce 32-byte alignment of nCR3.

In the absolute worst case scenario, failure to ignore bits 4:0 can result
in an out-of-bounds read, e.g. if the target page is at the end of a
memslot, and the VMM isn't using guard pages.

Per the APM:

  The CR3 register points to the base address of the page-directory-pointer
  table. The page-directory-pointer table is aligned on a 32-byte boundary,
  with the low 5 address bits 4:0 assumed to be 0.

And the SDM's much more explicit:

  4:0    Ignored

Note, KVM gets this right when loading PDPTRs, it's only the nSVM flow
that is broken.

Fixes: e4e517b4be01 ("KVM: MMU: Do not unconditionally read PDPTE from guest memory")
Reported-by: Kirk Swidowski <swidowski@google.com>
Cc: Andy Nguyen <theflow@google.com>
Cc: 3pvd <3pvd@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d5314cb7dff4..cf84103ce38b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -63,8 +63,12 @@ static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
 	u64 pdpte;
 	int ret;
 
+	/*
+	 * Note, nCR3 is "assumed" to be 32-byte aligned, i.e. the CPU ignores
+	 * nCR3[4:0] when loading PDPTEs from memory.
+	 */
 	ret = kvm_vcpu_read_guest_page(vcpu, gpa_to_gfn(cr3), &pdpte,
-				       offset_in_page(cr3) + index * 8, 8);
+				       (cr3 & GENMASK(11, 5)) + index * 8, 8);
 	if (ret)
 		return 0;
 	return pdpte;

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc0.187.ge670bccf7e-goog


