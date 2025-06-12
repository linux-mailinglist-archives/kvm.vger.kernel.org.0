Return-Path: <kvm+bounces-49279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3381BAD7591
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18BB81885516
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3772299AB1;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceGV069n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E853729898D;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=i3dd2MHxqiGUX6u60G1zRmHmi8ADRBe+0YaHUk2mlUtXABh0GdxsEp86tAj2q3/E2ijOSNU9N2WE82+0n0hxwCcunWbHDYmTVbvUgbx+3gYKKNiAMQ7Atz5kX6Yq0an7NGWWsCRNbUPQkTpBF0uLbigmgFOXIwRINsrXZkPN+Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=12fECthY6pkGs+Y6n/4fbZ5eWnjF1raHBzKHenr6KjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRZ2IBnZ1mzZ2AiuTdsKvP8+bGN6AefNyxjcAyezIImUCdkJpw7/NlcFy9FJJmby01cPUI3kU8p6Kk2FV+dzv9Rse5eRMQiBdGEu6d43wVEFVjIGE0CxMoYqps1MeqcTcphGCWYIHfhIzZ7YtncXBeRq5nYfDjs1i8fUvvCMrGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceGV069n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC39C4CEF1;
	Thu, 12 Jun 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741468;
	bh=12fECthY6pkGs+Y6n/4fbZ5eWnjF1raHBzKHenr6KjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceGV069nAXMj1R0JWOfcBYhLfetJ70/gc2BV93shds6zrYH3RjhHJqNQuLMbnQ7QM
	 qBHeyKbV8uNuVPaw1ylPJZKO0+pLriYQ+4ivviAZbWH5aRMjT+F7I0KW4pNpxdKoMB
	 N8i+SjrqmBgUSXMXFjR7cnMhx+ApM6T3FeMJlG7Pnsi1B0hnayNuNE+YN9R4xFTS6J
	 lxFhMDJ624LQL40N9gdZ7yXXM2QxghSTGEYpwATOtu2s5m9EovbiRq5IB4G7mgPcw0
	 6INeKdtele5OQVrzkuJnSbkOV7MiBWaNj/bGAWjPvkdbKL2AZwUO1HFHufshdkbqk+
	 MdCg5tZLJeHhQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgY-00000005EvC-2rrM;
	Thu, 12 Jun 2025 17:17:46 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Ani Sinha" <anisinha@redhat.com>,
	"Dongjiu Geng" <gengdongjiu1@gmail.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	"Peter Maydell" <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Shannon Zhao" <shannon.zhaosl@gmail.com>,
	"Yanan Wang" <wangyanan55@huawei.com>,
	"Zhao Liu" <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 01/20] tests/acpi: virt: add an empty HEST file
Date: Thu, 12 Jun 2025 17:17:25 +0200
Message-ID: <e25ea751a23c7d8da812233c83ce943efbeaaf91.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Such file will be used to track HEST table changes.

For now, disallow HEST table check until we update it to the
current data.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 tests/data/acpi/aarch64/virt/HEST           | 0
 tests/qtest/bios-tables-test-allowed-diff.h | 1 +
 2 files changed, 1 insertion(+)
 create mode 100644 tests/data/acpi/aarch64/virt/HEST

diff --git a/tests/data/acpi/aarch64/virt/HEST b/tests/data/acpi/aarch64/virt/HEST
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index dfb8523c8bf4..39901c58d647 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1 +1,2 @@
 /* List of comma-separated changed AML files to ignore */
+"tests/data/acpi/aarch64/virt/HEST",
-- 
2.49.0


