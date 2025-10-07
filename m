Return-Path: <kvm+bounces-59610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 43267BC2DD4
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0EBB04E64B2
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A52258CCB;
	Tue,  7 Oct 2025 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z7Snv7u/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFF91A08AF
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759876057; cv=none; b=C1DwEWc0cKltHhodznFyXUdJ1E06bi77+upR/MArklAob4JYZHm6vwSn/D9yhN+YVXfD59ZR70/TBejA8Srp8EsK7GBoCQViH2cgIS4dmQYfJ1KrqnEzJQoMHS0DuyzCwpXABWXOv34L0RtggRI2Z7z73yH2chgevRPuMZ8UEmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759876057; c=relaxed/simple;
	bh=boDfZUYJ+H6634/MALrOlMiRqYNUMI2ix73TsdhnqKI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=me+HmtnRFAu+aJPeP9ro8WQ11iR+CPSdyekCt9J/7zbcWuN9qLdAFAdKEsoRbBt4S9si4/m8NfHhoQu3+Nnt25SLX9186/WK66zdNaTfvYcOgzwLbLfnrP1V8q5BXvzyGOAe2ZkjeJKsZ6/F2uF8+uEnFH9qt3ZCWlpqZZwkelk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z7Snv7u/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso8402075a91.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759876055; x=1760480855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nemErtkM3sps/Qprvfk0CxBBJIRtCuUQx5Na0YrmCEY=;
        b=z7Snv7u/l1acVSCetw/3lPDkwP4oaf6aYqGBYFozwW1KS7PBngo2DJPhVVXZSSeC07
         xW2rLmDJGQANChLVQf4qxIVl7EfFMurairvajaAnp9bFV58pMh+K8NqwJZRZnhMXWMbA
         4yDr9lodULQOn0KXZJjHobxAGN6RzA11mQrcLDCeH41jCZbEO84wLaQZHGMD/qA7blXL
         wWfzqybZduJH7CTzeR5URFTOtaJndgyT70KwjKGyMfljsFXOrulsIjt5nYg1xxVbzeA/
         2jH8u+4xAfTV8rAN7QaykNNUfQWMtGbksODDCZq+cMJbnGayFREqVBUUrUo/RirtMKKq
         if6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759876055; x=1760480855;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nemErtkM3sps/Qprvfk0CxBBJIRtCuUQx5Na0YrmCEY=;
        b=opRLdQ/hvKLAl+D8moXfuUijA+r4lokVTnvc+hy0B713GC4R9YEzZgnccCt7JTTo3l
         1o1+MjtRE0jL8OZ5gJlVkTIUzS7YQrtFNMY1dcKpQjw3M5hVUsrtC6dZSNEuO6M6F+dQ
         McEBPzOwDxlmfR8pG1/JlVaYDGdt1arQm/QEycRz1L/JCpPinjh77AsHP1lhPfvdBcAQ
         L1MMQ/CX7hoVoJcCv6YL5pwR1EFCrJUdA9Vu/Ae2QG7FO0mdQepQdAmwpayuVe71wI0b
         XsyP3Uoo+BKNpN1/CHMrQmj/KSAxR+etJpVKJj4hg5L+vWWuQl8lwAnENynEzCpqO1sQ
         +TwQ==
X-Gm-Message-State: AOJu0YwbZtv8DIeoKi8pZdnvk/Kp5dITSxMpjJBO3ouKKqXMTcPoK2pZ
	I77JBfP30/ZtyjTDRnmVCR2P2macQNgOgJhH8d8h4DJ111ePPQhndBSpn5TzjhggIKdX0vQc1nG
	G+W8g8A==
X-Google-Smtp-Source: AGHT+IHCXMcYKNWSsv61XAkjfnUkhMqw6aPlFj2DkTkT+0UR1Ffi2JkCaAGL8ygnGp6zS6I4Oc5vhHNCMRE=
X-Received: from pjbgo20.prod.google.com ([2002:a17:90b:3d4:b0:330:49f5:c0a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e82:b0:32e:32f8:bf9f
 with SMTP id 98e67ed59e1d1-33b513841abmr1305469a91.30.1759876055267; Tue, 07
 Oct 2025 15:27:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:27:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007222733.349460-1-seanjc@google.com>
Subject: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the local "int err" that's buried in the middle guest_memfd's user
fault handler to avoid the potential for variable shadowing, e.g. if an
"err" variable were also declared at function scope.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 94bafd6c558c..abbec01d7a3a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -330,12 +330,10 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 	if (IS_ERR(folio)) {
-		int err = PTR_ERR(folio);
-
-		if (err == -EAGAIN)
+		if (PTR_ERR(folio) == -EAGAIN)
 			return VM_FAULT_RETRY;
 
-		return vmf_error(err);
+		return vmf_error(PTR_ERR(folio));
 	}
 
 	if (WARN_ON_ONCE(folio_test_large(folio))) {

base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.51.0.710.ga91ca5db03-goog


