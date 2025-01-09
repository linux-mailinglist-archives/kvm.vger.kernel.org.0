Return-Path: <kvm+bounces-34961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A67DA081BD
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 21:52:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5137E3A0668
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBEA1206F0B;
	Thu,  9 Jan 2025 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WlCdUd61"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC809205E24
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 20:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455806; cv=none; b=aHHcaAf8BMbMIMANZfOxZrip2iXksAbvAPZuczPj0rkynoxKfQXt+EUEo7XEha7PLy7951Wyf/WY7QFw/iRhDigB5re98CBVeupomGMaX3tcnY3cSSjF6LpE4gMGkDd01uGiybLOns5zpWi/vIl+Dgh6nKe+d30yRy2D+wIErdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455806; c=relaxed/simple;
	bh=wX30xj9sJm8y6Ulhl1IoKeVlsOrKZuVPq174Ef2/lmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BlCysF5MkG1fgB87WKFvx/hR1OlyO9I3d1xyt9pcTIU9pIF7P52dwoGMn+Z6CpLW0RU0LKtSMGwplBLKOP4vH4MrfDPnmAWGR5xo3lLmoHIA1M2GL4yQ36/t+dVNwPsRCV/5BJAO6kczrydvj/1sosWtN5Ml0/kKCNVKfpE3qOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WlCdUd61; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6d8edc021f9so20742756d6.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 12:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455802; x=1737060602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O767jE59AeAMsTglDWemPeR1CkI5EMgHAt7K2sI2JAg=;
        b=WlCdUd619YU8lYk986ZY4xjT3n6gmOwDPGl5+xf/JRzVAaIN7N9QmlRJx0dlHQ4BxR
         eX8r/UJ8YTO2Fglf+hSatu3nSIvBc8kN0o4/C1YK5FYVsyeBjmxecijdFVqZTU/BogUf
         jtbcbgd41FIzi7Tz8wgb9IEs8phkhwf9b6H3PauPzdi3FaKQR/fluydOUL0tJmEEOMRh
         tFHArHoI3yTVHm64fj1JwlHpkbguH9RnUh2pmvz9hgNSC1lsVh5fDTeJ/f/MzghN8ZXf
         V3J10OLS1/zvXt4LA6UyHn9fAAsBx/aziEqsNt3v3pNBJOFZTd/v6ZOP74bJJnlj9tD/
         RsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455802; x=1737060602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O767jE59AeAMsTglDWemPeR1CkI5EMgHAt7K2sI2JAg=;
        b=UDtA1JhTgYuEd5nVqlMxZodCgafR/G2zHRsXKjt+pQj4jNp/emUpmUy01PMdflzmdK
         YK9n8XBkIMCJF12AUjORVIRR0O3AWq4UPOXVs937dI8xUvC4Fcxp6An3dZeVn7JBB3f1
         ulgyNSS/QcjUmmmvm1Cw6UFrS0QucdYGnLEqrjpkS+RjViEe0naxoNN2wPMGg1VSG0Av
         IQnrSouJK3lSvSV+L9xrgV0EwjskgZ5U4fYaua0tHhTDQOKkob8ks7yD7x9iQI3Iyvzs
         Q9eKzhSa14/65q2y+r7bIGZW2WPOhc588GncdH7h8SSDdkrdNuncP8Ar6VjSrUMpBM6D
         lmvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmDjOYjvWwUIWLCxOd90PHh+EZNFHDO/M1G8IxYOfEO9+mawy78TePPtt0oWggOws83Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8OtQyPUD2Fdal4xWwYeCMLqSZxWsvkjaTD/0n6F/axKQF8rKd
	gEckHAAOT1DM2nK0RFzd9/w0qriqRvds0XWL193kQpcr/wQPIoOJVIdcXuWCzqzad5R0ULMPE6u
	6nahPPEJNnay8g0uMGQ==
X-Google-Smtp-Source: AGHT+IFgx6gAPenNPcGigBK2pqFto4Hhpu9WmCDI55SJzVOesvWzc1cj0nZb4kbFOEWQTb6nHd4wPYt7OTvCG9XJ
X-Received: from qvboq1.prod.google.com ([2002:a05:6214:4601:b0:6d8:f326:1f33])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:2688:b0:6d4:1c9d:4f47 with SMTP id 6a1803df08f44-6df9b238643mr125150226d6.13.1736455802071;
 Thu, 09 Jan 2025 12:50:02 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:24 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-9-jthoughton@google.com>
Subject: [PATCH v2 08/13] KVM: selftests: Fix prefault_mem logic
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
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
index 0202b78f8680..315f5c9037b4 100644
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
2.47.1.613.gc27f4b7a9f-goog


