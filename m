Return-Path: <kvm+bounces-36046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F63A1707F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:45:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE7493AA3E4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164461EE7BD;
	Mon, 20 Jan 2025 16:44:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051EB1DF989;
	Mon, 20 Jan 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391459; cv=none; b=YA5D0eBp9OUXrTtj6zF0XoTyKr6QjyB5tnvYWLQjbQ2K/fIPPz4x6+pRPO/Phprx5mHNzBBnM3pxGLbTKPy+ld8vnbs3SFWWgDl7Hj2zvSHMUqBEp29GADA+YV+qkhKZ7VDNwESjnwKZxqVtb3/zlACnR7PYingTDH9Z2cvB4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391459; c=relaxed/simple;
	bh=ovSjkdUX7BuXHroB0uRQIMIyN52F0thSyV5KanQXoeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+W8iKqnAufEShJNlh3L9hvmcSb4hC+TOWwJ+9WJd5Bo3fXjfIH4hNIaQkArbGKjLwhLJuVxx+KTqs2mBJoDVwESEPnCsr6FZamNgJ5QE/e5PvTVrAc/cXItWhIXH+7Ar9eByHHUEaHJB08lKlZ8XKX0MeIdyWr3CNyZHuIlxxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A1D106F;
	Mon, 20 Jan 2025 08:44:46 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A9683F5A1;
	Mon, 20 Jan 2025 08:44:14 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 13/18] run_tests: Do not probe for maximum number of VCPUs when using kvmtool
Date: Mon, 20 Jan 2025 16:43:11 +0000
Message-ID: <20250120164316.31473-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250120164316.31473-1-alexandru.elisei@arm.com>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The --probe-maxsmp parameter updates MAX_SMP with the maximum number of
VCPUs that the host supports. Qemu will exit with an error when creating a
virtual machine if the number of VCPUs is exceeded.

kvmtool behaves differently: it will automatically limit the number of
VCPUs to the what KVM supports, which is exactly what --probe-maxsmp wants
to achieve. When doing --probe-maxsmp with kvmtool, print a message
explaining why it's redundant and don't do anything else.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 run_tests.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 61480d0c05ed..acaaadbb879b 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -89,7 +89,15 @@ while [ $# -gt 0 ]; do
             list_tests="yes"
             ;;
         --probe-maxsmp)
-            probe_maxsmp
+            case "$TARGET" in
+            qemu)
+                probe_maxsmp
+                ;;
+            kvmtool)
+                echo "kvmtool automatically limits the number of VCPUs to maximum supported"
+                echo "The 'smp' test parameter won't be modified"
+                ;;
+            esac
             ;;
         --)
             ;;
-- 
2.47.1


