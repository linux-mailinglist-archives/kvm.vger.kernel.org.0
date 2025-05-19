Return-Path: <kvm+bounces-47024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4FFABC77E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23B073A482F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A87521A92F;
	Mon, 19 May 2025 18:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C1qV5YPU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A521CC70
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680938; cv=none; b=p0pglK5C8waGivAAw8+71TlNnrlDKGrfQoaU0RPpOPQKQcK1sme+LkocrfzN4YEu2Tlw8YC/Yg4Mxg4qpVO0Hht36g3X8cpYaMfPTymiTcmnVdpHOI2cYcaj/nd43lJusVI5PM8aHQbHqZO2z7rSBDDll1MskJSbb85V3Q52964=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680938; c=relaxed/simple;
	bh=lKEiDtco8Zjxw+6Ce1l/2Woozc6T4pKTzIMLnMhgjbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jsWzUpiliOrjJMKToxyWY1atNSPDq2O0uUhUrT+d7EuKPi2VhYDWq8s02rX4BI7g8KLWgMzpOkrMXeN5K+C0JjbR4RppiCyePOvapK2eIZoVidrq4iap1Hm9La8VOM1fQA+tkOEDUWM1hS+kAwI/G59Gp6AUpwz6fKXJwkSjo9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C1qV5YPU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so4901164a91.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680936; x=1748285736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=svZAfnlSTeaMolfrtcaOq/xEYvu0qCBcCbJ0k6qFXts=;
        b=C1qV5YPUAoBNllBUn6ZmJFZwSzjmhIqiIJySHKb79Tv36ERidwG57S63kTJDt3AQJQ
         WbDYxChybdc/zKc6hQCRt0IBQpk9lL6LIHFOQks+x9EM/XyEAohpG2UkIr1hie/XTcLR
         s1q/P+i6/tMKZUlkqOAbPDKNuYVUOvXRmXIrMP34veqb13n5vFLwUIxP/fmoS7ALl5f6
         BKALDg/17qGA30pCUAR7ZEABHh/L5fVUWPI277D4SfjWHE+RspIbE7ZV1w2ZGIX5hm9/
         +96jzgkvEn6fKra598JqEIbsi0JWy5tLDzQ2Plnq/70OzKTYsckduq1vxbA7JNzehFt3
         2mBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680936; x=1748285736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svZAfnlSTeaMolfrtcaOq/xEYvu0qCBcCbJ0k6qFXts=;
        b=ZG77hINxN8aqd4JQXRtWkitKYIwxQe/Ul9BHdrs0q/HjqvEFVcZC9sCxyDZ60IuegI
         qlM2h1uJ2oI65wIgFqfRYEf/df5JRwGaOM6F0MfvXmrcYxlE7bJEQHpp30nlHlhFt/FB
         o1IqsDp1BjGyY/OoL++x9GFD+WzSm4MPEtDMDMXj0BzmUaHVxad4SNlG+fmNv0IQsM42
         dyu71zzToBg6BDtx075NTKCBlnIZBd55B6zehvvq+acj5ve83KNHFyL1f8E2a2RiVrZW
         e4Q+/HXUQIv8Hdvy9BXPQhg9Ki+fn7QL1JeBqLIlKkpG8SAv3ot+vkRG1OAEsWy6Iuin
         vibw==
X-Gm-Message-State: AOJu0YxUp8BSJQuH9eAm4SUwoRcMHK6xtKrr5nRNi6m6zuKGapag6LUM
	DT7tX6Q+p7CRy4JcQRFOZe+CVRyZEOCu2hGVErbYRJUbs7cwi6mJC5zQ7WCG4wGoPM9I6cxOr/D
	+Z7SxxQ==
X-Google-Smtp-Source: AGHT+IHFHSV2Ke7uVRMojNlgnegTrMTQP9GQqHVO1VwR0CTBk3daaqGT0xYoclFSkFU0/yQOifv0EZ0lYtM=
X-Received: from pjbsb5.prod.google.com ([2002:a17:90b:50c5:b0:301:2679:9d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:2fe:ba82:ca5
 with SMTP id 98e67ed59e1d1-30e7d52221bmr23752952a91.11.1747680936483; Mon, 19
 May 2025 11:55:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:12 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-11-seanjc@google.com>
Subject: [PATCH v2 10/12] KVM: selftests: Assert that eventfd() succeeds in
 Xen shinfo test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Assert that eventfd() succeeds in the Xen shinfo test instead of skipping
the associated testcase.  While eventfd() is outside the scope of KVM, KVM
unconditionally selects EVENTFD, i.e. the syscall should always succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 287829f850f7..34d180cf4eed 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -548,14 +548,11 @@ int main(int argc, char *argv[])
 
 	if (do_eventfd_tests) {
 		irq_fd[0] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[0] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[0]));
+
 		irq_fd[1] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[1] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[1]));
 
-		/* Unexpected, but not a KVM failure */
-		if (irq_fd[0] == -1 || irq_fd[1] == -1)
-			do_evtchn_tests = do_eventfd_tests = false;
-	}
-
-	if (do_eventfd_tests) {
 		irq_routes.info.nr = 2;
 
 		irq_routes.entries[0].gsi = 32;
-- 
2.49.0.1101.gccaa498523-goog


