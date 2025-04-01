Return-Path: <kvm+bounces-42321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94166A77D6A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F0C21888A36
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 14:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6465A204849;
	Tue,  1 Apr 2025 14:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPLawSXF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4AF20469A
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743516815; cv=none; b=Uu0A10vACK15ym+AVsgVaTMyEBVsrf4oqCbQ4MqbPwhMu7H3pxgDKNcVaOY0r7WueCvM+BjqrIjPIlKerafIxJ4gVE3yclqgMTWWB8WE3A58WMbiXoe+lVKhYbGd+c6Li5WwGeoULMngRJnSiypIQ6Z4blEEJz9EruOTM2yfudQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743516815; c=relaxed/simple;
	bh=60vth6cJit52DiML66Gu7ir02coWDnGZZIZt/BMDB6E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aOZ3QIOISdQ5FJfQbhO2jky8+PClOsS80iNy3yQ3FtQyANOr41Jmm18ebWrpeVI+WNQV0/Qut+XjLOzEvB5J57C/vSdgCHABx6iyRY84bQBynbsMuzZHvcOS18N527grcpkuadRyPA2A7DqIO7/ilK/a/G3oDtU8ERq1dnURWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPLawSXF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743516812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3FUwbXFE5tYMNuex9XNn7jA/FNHhE1HOAMFzcppmAaw=;
	b=WPLawSXFgN2WvTuve0v1laNKZy41uNyh8eXBEeklIf0vTkdyDJllaYNfmiWUHCsaBD2mwE
	7Gs9r0Af8uxRr0iUk/pnDCcmOfcRCumOQnrNZ3x4hOulH9k1d7eOMrpJR/VOMASvNRvDuU
	qW7OgWA6UVEkzE4dTBKiDhuIkvX8WI8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-TpWBM6-7MWSyYCK_EThwQQ-1; Tue, 01 Apr 2025 10:13:31 -0400
X-MC-Unique: TpWBM6-7MWSyYCK_EThwQQ-1
X-Mimecast-MFC-AGG-ID: TpWBM6-7MWSyYCK_EThwQQ_1743516810
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so41108515e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 07:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743516810; x=1744121610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FUwbXFE5tYMNuex9XNn7jA/FNHhE1HOAMFzcppmAaw=;
        b=DPDPSLfHTQU/PqFAE4NpNzc8In7w1tiHIiCasZNLhyEIWzlhJKewV5RJcfm7w8izt+
         yJUxtw52Kvqj5KH8FuhXj5KEW8ojPgWm8JQruHRA40xAUjZuqjsafc34F4P335UbVvB4
         USY9aamAKInAFuQ1P0kaUkGiIm5yg6kB9ryjdosFU6I+sqTerRv28rWeS0l322vDwy52
         vazYM0lUlKjNWnvlLTTo0Vk7QFkQRrJrTRoPAL3cloSTdPK6D+qaKei2DmvBDhfZjwq7
         klNqXxEH8CuLWkfoZf9V7cYEiV9QMk1Y3E/wTvsOcxw87Q59Zzd49JaaNB0lPZ60od09
         WykQ==
X-Forwarded-Encrypted: i=1; AJvYcCXABFgLtjJANp1kZRaGxyZFIY757+WpuMI3t1Wb93MCviEHsoNqdsqJ+FHCTa9QLj5JrmE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxypGwNo+fcv4NutfR9TffH3NxD9gosh0lNc2FcPhey4phmKi+V
	wTv8215eZv7vUUjfyKF0tbQvk0I3u04UyLKuclV0bxO7gOggl1nQCryYhmxILR5RaRKgIlfSnPY
	7UOeDZ9W3e4vMvcQBDEb3jPrqzAks9b0q+Mm/G0PUbR4iQcGTSViDldq7vw==
X-Gm-Gg: ASbGncuD3jZ/AARt1f57e/6C816KmIzkKjmw4qSzOAlkiif3/Bk5Z3mHaYGbiuHzHow
	9IOO4YNEQK3Kd3oeX9ePk+dyacKcOrhS/oWjDvCBfF0Hghmxx77gxbKAg9Pfalzl5TDGghdLpfv
	dRR5rgYT5tIjh1bLr3TNviY60IrXON6O9lXkAS+MhfPlh889f8GDeYUW16o2cp+bZ1pvfKsY2Mm
	UJTcg0wfs0ltWMmbVfjtVET2u39eWNeTrJLdrsMQJjoRqV47yIiWzKvwruZoDwEwiFG5XlqAnQ4
	XacC7bIJGSkXepJnifsIZg==
X-Received: by 2002:a05:600c:6748:b0:43c:eea9:f438 with SMTP id 5b1f17b1804b1-43db6247dd7mr144936185e9.15.1743516809900;
        Tue, 01 Apr 2025 07:13:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoO04bc+b5OyMs9RLOm34hPnaog2+aZZ3sv8mZSge41zqvdoDw62pEMiPrGIM5btfjBDByvA==
X-Received: by 2002:a05:600c:6748:b0:43c:eea9:f438 with SMTP id 5b1f17b1804b1-43db6247dd7mr144935685e9.15.1743516809494;
        Tue, 01 Apr 2025 07:13:29 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8f404ac3sm164856265e9.0.2025.04.01.07.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 07:13:28 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] selftests: kvm: list once tests that are valid on all architectures
Date: Tue,  1 Apr 2025 16:13:27 +0200
Message-ID: <20250401141327.785520-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several tests cover infrastructure from virt/kvm/ and userspace APIs that have
only minimal requirements from architecture-specific code.  As such, they are
available on all architectures that have libkvm support, and this presumably
will apply also in the future (for example if loongarch gets selftests support).
Put them in a separate variable and list them only once.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 45 ++++++++----------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f773f8f99249..f62b0a5aba35 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -50,8 +50,18 @@ LIBKVM_riscv += lib/riscv/ucall.c
 # Non-compiled test targets
 TEST_PROGS_x86 += x86/nx_huge_pages_test.sh
 
+# Compiled test targets valid on all architectures with libkvm support
+TEST_GEN_PROGS_COMMON = demand_paging_test
+TEST_GEN_PROGS_COMMON += dirty_log_test
+TEST_GEN_PROGS_COMMON += guest_print_test
+TEST_GEN_PROGS_COMMON += kvm_binary_stats_test
+TEST_GEN_PROGS_COMMON += kvm_create_max_vcpus
+TEST_GEN_PROGS_COMMON += kvm_page_table_test
+TEST_GEN_PROGS_COMMON += set_memory_region_test
+
 # Compiled test targets
-TEST_GEN_PROGS_x86 = x86/cpuid_test
+TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
+TEST_GEN_PROGS_x86 += x86/cpuid_test
 TEST_GEN_PROGS_x86 += x86/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86 += x86/dirty_log_page_splitting_test
 TEST_GEN_PROGS_x86 += x86/feature_msrs_test
@@ -119,27 +129,21 @@ TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
-TEST_GEN_PROGS_x86 += demand_paging_test
-TEST_GEN_PROGS_x86 += dirty_log_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
-TEST_GEN_PROGS_x86 += guest_print_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
-TEST_GEN_PROGS_x86 += kvm_create_max_vcpus
-TEST_GEN_PROGS_x86 += kvm_page_table_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86 += memslot_perf_test
 TEST_GEN_PROGS_x86 += mmu_stress_test
 TEST_GEN_PROGS_x86 += rseq_test
-TEST_GEN_PROGS_x86 += set_memory_region_test
 TEST_GEN_PROGS_x86 += steal_time
-TEST_GEN_PROGS_x86 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86 += system_counter_offset_test
 TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
 
+TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
 TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
@@ -158,22 +162,16 @@ TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 += access_tracking_perf_test
 TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
-TEST_GEN_PROGS_arm64 += demand_paging_test
-TEST_GEN_PROGS_arm64 += dirty_log_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
-TEST_GEN_PROGS_arm64 += guest_print_test
 TEST_GEN_PROGS_arm64 += get-reg-list
-TEST_GEN_PROGS_arm64 += kvm_create_max_vcpus
-TEST_GEN_PROGS_arm64 += kvm_page_table_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
 TEST_GEN_PROGS_arm64 += rseq_test
-TEST_GEN_PROGS_arm64 += set_memory_region_test
 TEST_GEN_PROGS_arm64 += steal_time
-TEST_GEN_PROGS_arm64 += kvm_binary_stats_test
 
-TEST_GEN_PROGS_s390 = s390/memop
+TEST_GEN_PROGS_s390 = $(TEST_GEN_PROGS_COMMON)
+TEST_GEN_PROGS_s390 += s390/memop
 TEST_GEN_PROGS_s390 += s390/resets
 TEST_GEN_PROGS_s390 += s390/sync_regs_test
 TEST_GEN_PROGS_s390 += s390/tprot
@@ -182,27 +180,14 @@ TEST_GEN_PROGS_s390 += s390/debug_test
 TEST_GEN_PROGS_s390 += s390/cpumodel_subfuncs_test
 TEST_GEN_PROGS_s390 += s390/shared_zeropage_test
 TEST_GEN_PROGS_s390 += s390/ucontrol_test
-TEST_GEN_PROGS_s390 += demand_paging_test
-TEST_GEN_PROGS_s390 += dirty_log_test
-TEST_GEN_PROGS_s390 += guest_print_test
-TEST_GEN_PROGS_s390 += kvm_create_max_vcpus
-TEST_GEN_PROGS_s390 += kvm_page_table_test
 TEST_GEN_PROGS_s390 += rseq_test
-TEST_GEN_PROGS_s390 += set_memory_region_test
-TEST_GEN_PROGS_s390 += kvm_binary_stats_test
 
+TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_riscv += riscv/sbi_pmu_test
 TEST_GEN_PROGS_riscv += riscv/ebreak_test
 TEST_GEN_PROGS_riscv += arch_timer
 TEST_GEN_PROGS_riscv += coalesced_io_test
-TEST_GEN_PROGS_riscv += demand_paging_test
-TEST_GEN_PROGS_riscv += dirty_log_test
 TEST_GEN_PROGS_riscv += get-reg-list
-TEST_GEN_PROGS_riscv += guest_print_test
-TEST_GEN_PROGS_riscv += kvm_binary_stats_test
-TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
-TEST_GEN_PROGS_riscv += kvm_page_table_test
-TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += steal_time
 
 SPLIT_TESTS += arch_timer
-- 
2.49.0


