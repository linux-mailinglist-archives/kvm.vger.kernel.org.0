Return-Path: <kvm+bounces-63132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A18C5AB9D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B03EC4E6AA2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A50322B5A5;
	Fri, 14 Nov 2025 00:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1xwDwIC4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FEB221F0A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079194; cv=none; b=gdtgDZZ+jFuzQ3xNkoew1GJWHLPx29ZY3VkvpHs/tgCU6eozGEjS6bTJMEjwzPM55wcmnTXbOafM9Dwip95OfzEXFrvqZoeLQxhUNWrGpN5bdI7iCRy+fH2e1cOh0BRAcPOOv6UJ6iQo7NXt3DsMGi4eVCF/sEWDytFjbSbZnv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079194; c=relaxed/simple;
	bh=jdSKjrHVw1kD1z76pWRk/bHYsHbnRs+JKfYF1XRkQzo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KOUG0iV1JTQgTepO7NKn36yzSGtHpGcpLXHBb7VOgHEgJlQgOxVs24Pv0AvgX1ZoiaaqNZGt9GD85xo81IL7oryXJ9k/xvjB5byO+5YUIgbmageUQjd5MmKp4Odqqdyurs/5X6iboy2TfowvxcTddT996vNuftT7Cxhbkjh7MvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1xwDwIC4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so1815438a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079191; x=1763683991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wt+ZxcJaGvnwjfF/rLmeGe7gA9vGkxC3E/uhiQD8M/M=;
        b=1xwDwIC4OG3Fdx7wgRwNLQSfKgL4OK+T662yQX5tpYNUpmMFT0JTDFPkhGq4Qr7ljg
         Ft6kKvJBsFJ8SI5T5S2wwHoa1fSIO9PYDWvXBOJsXf96Rb5q3UjsNR3CIaioBJv1HnOP
         ES2FSpDopesojHrTm1a88vJ9i91UW8ugNodH0i9+fJqLZ1nzIVwvx01RDhrOutDWbqUC
         JFeBs9Crxk0kfd/LMMknvla4kG48ZGhoy5dZxBDKEVm+zyMwZlbySpoDzs3mnSZhR7Ux
         odvMa6gvqrVHLeDwpXsA/TKqsMKjftocu1IboHIxfJF1dAexbSed3oytEP8e5Sr3oRrQ
         18GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079191; x=1763683991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wt+ZxcJaGvnwjfF/rLmeGe7gA9vGkxC3E/uhiQD8M/M=;
        b=g+eAxDffS8vTYMBEmPiaOuIKx0ZFnnrMq0AHxfXPIG3J19p59Gs/dBhF2M5+FAa1OU
         2fFyzEotUBmX8qh7hTar7G7SU+hvdeF2c6VK4yB4sL6gNcvdfsObJ5X5SrmYbTObfgYG
         bppcf09eaOA06ceae5ROVAP9XZVctwCEgWcRxZueL0AlzkzsL7yuFSPhLT1VmlrI5TpB
         67F4QSBaNtgFQVbS+8hQ12uQOATRbUJz5DNKPhVmSZ4brqyQgYvO+kFLPDwpI19JfASE
         Rt7TNZkgGuirRaKsaSNqkKrTfrqJs0m6ZAi151w0nAkO0uXt5l7jqLD1OpC+mCp8rk4/
         6b9Q==
X-Gm-Message-State: AOJu0Ywm0uqndB/J8k6eQkF+HihGdvyDbA5qPxrL/yWEUeImjl141f4Y
	jnhWva1yeib0cbxF42YvbkQbuCcjRY9sBjuuB4x7LkAS8uGuaXk0AxfgmVOJxHo5rD5n6teyuBH
	NwhB8MA==
X-Google-Smtp-Source: AGHT+IHs8zMlt6kUbb9tg35AK3OXmGHABc3H2Jic93c3nwnrxf+XNPNUcQBhcNSJqiMgsJbEJWArXUddMhA=
X-Received: from pjbnm16.prod.google.com ([2002:a17:90b:19d0:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b04:b0:340:d578:f2a2
 with SMTP id 98e67ed59e1d1-343f9d906c9mr1104363a91.6.1763079191094; Thu, 13
 Nov 2025 16:13:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:47 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 06/17] x86: cet: Use report_skip()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

report_skip() function is preferred for skipping inapplicable tests when
the necessary hardware features are unavailable. For example, with this
patch applied, the test output is as follows if IBT is not supported:

SKIP: IBT not enabled
SUMMARY: 1 tests, 1 skipped

Previously, it printed:

IBT not enabled
SUMMARY: 0 tests

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 0452851d..d6ca5dd8 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -59,12 +59,12 @@ int main(int ac, char **av)
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
-		printf("SHSTK not enabled\n");
+		report_skip("SHSTK not enabled");
 		return report_summary();
 	}
 
 	if (!this_cpu_has(X86_FEATURE_IBT)) {
-		printf("IBT not enabled\n");
+		report_skip("IBT not enabled");
 		return report_summary();
 	}
 
-- 
2.52.0.rc1.455.g30608eb744-goog


