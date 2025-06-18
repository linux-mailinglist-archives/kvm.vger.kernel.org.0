Return-Path: <kvm+bounces-49800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF56AADE279
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47D6A3BA5FF
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6FE21C161;
	Wed, 18 Jun 2025 04:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1RqjUi/L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4732C21A428
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220682; cv=none; b=CrG2BE3GYh6E51rPx9INIofBaTzyTaVQXNiH3mdkCrDkaQyW0j7CfvdMfIv+N6ANef/Q4pi8ZGR6+Nx4ueNEL8flZPIkVuD3kxxh9Z3wjTYt8u9w2ynuO8K2NLCGHbZROXMa5ovPzi9kSTk+iH+1MrwlIvf5jlSwdbmjKkAvMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220682; c=relaxed/simple;
	bh=2bZIqpioQGHINFU/EiphRLQAzeRmXnkDiiTDnIIiQmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MwwJB/BCwsdzTXfq4DwZbjcDrJK2uUiVP4CkUC7ytF5Wm/Wwefq3xO2x2XgJbZekc8h9ygmR4XYQw49rAyaRP13PtvCCp4Deyqv8E2QDlnYeqvTtR8cet7oTvAj5i6lYTT1nb9Y6becet+p2N2KAy4VmJ9p8yFS8ZIcIQjNtd7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1RqjUi/L; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2365ab89b52so47192655ad.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220681; x=1750825481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mIb2ZAeP1IApX8KajcoQdMg+K+X03gdKKVOXgy4uxAM=;
        b=1RqjUi/Lqtf8B4bqGv8uCzLjMH/uxDca5PmvLJbmPWGSoNUIbvFxBXM/xCQmX/b7Ul
         N9qSh6HA1j67OsAvAXGEtxnGGMJIAN8EgFEXuZkyZ2dJ4ny0tu/h9W1Rpik9MuidSmI7
         uMseHRLO6OYF4RBZy9lX0COPgPKnG9WewduNITNRCRMzxTwwc8MEkVMnZSqMJGuRkH3U
         C88tWETm53Td1bEipIsQI4jlhUDcElNK4Sw+y7hYPITpACzNsRWAC2Nk1oBBHmHyH2KJ
         NCP69EKiyF1YfcU0eH/fLh9/xz6BO8S4j9lrXU+pJUxxjeU4HrEcIwlC/Zlgjj0ZA0br
         uvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220681; x=1750825481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIb2ZAeP1IApX8KajcoQdMg+K+X03gdKKVOXgy4uxAM=;
        b=pjXgyV0Vbod5QkGX+E425QmuQ1edmkSZSFc+5k9OQHC1rwHTmPLC5dUW8Hvi5NuzXX
         itkwHDZqyxkJfUfRfX7tyxY9QA3YebZSOXLKy69VlkZ0s1B1FU/nVFzZCkmLqrUYyJHf
         +OSpmOOpnjwOs0wLQ6PPMRd2q008aKxCILOatO63RUqy5B9grUuJahEmTQomvMIO4/je
         Iw+MDAy5dN+TbWFh0wArx+KfXqOe9cbK/yKG5lioaosQo3U2Qt4KVVZRlFAR4oJ/jikQ
         u9N4qnPDVzqN3J3AulmfzHEhZeTBoiCAUZelhXB0tz8pfDbvq3VnKoYwyYYgsSUH00xy
         bwig==
X-Forwarded-Encrypted: i=1; AJvYcCV/HDVr52KTcATvQtDYQ64EPghSQ46oVG75QuRRM0gRva3Mpvdv99/5j6+/RGXiqsodFbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvgEIGi3QKwlPe9+vIkHz2g69AVXG8YtGPknGIWgIJcKF9eka3
	sVmyPO+gZQKP8I5Lg/KnpBV4A97/fhYeqKHV+g+rqwV3mVn6aVEFBmOpMj75imRyGlCrzEBfWM+
	hCYLKLVckTXEJ6nrMEYRqTQ==
X-Google-Smtp-Source: AGHT+IHIvgUZR0zBF5d+sewo95QOsT/HjDVkEn+tDLrOgLskqZ9xDvbZRR23CwdW2Cit9o8BMVaShYmHas3nnjqN
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:312:eaf7:aa0d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:228b:b0:235:655:11aa with SMTP id d9443c01a7336-2366b17b16bmr234970365ad.39.1750220680638;
 Tue, 17 Jun 2025 21:24:40 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:18 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-10-jthoughton@google.com>
Subject: [PATCH v3 09/15] KVM: selftests: Fix prefault_mem logic
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The previous logic didn't handle the case where memory was partitioned
AND we were using a single userfaultfd. It would only prefault the first
vCPU's memory and not the rest.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680a..315f5c9037b40 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -172,11 +172,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		num_uffds = p->single_uffd ? 1 : nr_vcpus;
-		for (i = 0; i < num_uffds; i++) {
+		for (i = 0; i < nr_vcpus; i++) {
 			vcpu_args = &memstress_args.vcpu_args[i];
 			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
 				     vcpu_args->pages * memstress_args.guest_page_size);
+			if (!p->partition_vcpu_memory_access)
+				/* We prefaulted everything */
+				break;
 		}
 	}
 
-- 
2.50.0.rc2.692.g299adb8693-goog


