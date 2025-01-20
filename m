Return-Path: <kvm+bounces-36041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D01A17070
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E1B216396E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3DD1EBFF9;
	Mon, 20 Jan 2025 16:44:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140C11EB9F7;
	Mon, 20 Jan 2025 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737391445; cv=none; b=uJAyqumckMIll5TWWnQ61B4FwrW/oyMzQM/Aqt6A5GiEXTw0+iGX42Y5R8u3fnHOv59iDbex+l/PLvMVX2YyC6WvUjwO8H2a+jUW2+67VGyFHJJ76Sf/4QkUW60uYp6lVKRdKoHqbCbtDGtyzJWUslDXtvp6i5QktiRfXiuqOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737391445; c=relaxed/simple;
	bh=l+ue9QwjC4bgshR3VQ8gPW6MJGNAunyoEVncSkoXgiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBeRoVWJ6suEQqEnEc06XLYuH29FkdvfPRFXhd06KvGSsPHpxwuTuUTJADa0kbq0Z8dyOPXab9T0IdCMAcF8ei63WLgHgDw0+P5poJapqgd419GPqsdHbiCcud+I/y5bAXjZcQXB+7aVloR/6tmPlWNAQqEWlS8ZTN6qNP6LuuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 272631D13;
	Mon, 20 Jan 2025 08:44:32 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 837D33F5A1;
	Mon, 20 Jan 2025 08:44:00 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 09/18] scripts/runtime: Skip test when kvmtool and $accel is not KVM
Date: Mon, 20 Jan 2025 16:43:07 +0000
Message-ID: <20250120164316.31473-10-alexandru.elisei@arm.com>
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

kvmtool, unlike qemu, cannot emulate a different architecture than the
host's, and as a result the only $accel parameter it can support is 'kvm'.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/runtime.bash | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index ee8a188b22ce..55d58eef9c7c 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -153,6 +153,11 @@ function run()
         accel="$ACCEL"
     fi
 
+    if [[ "$TARGET" = kvmtool ]] && [[ -n "$accel" ]] && [[ "$accel" != "kvm" ]]; then
+        print_result "SKIP" $testname "" "kvmtool does not support $accel"
+        return 2
+    fi
+
     # check a file for a particular value before running a test
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
-- 
2.47.1


