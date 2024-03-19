Return-Path: <kvm+bounces-12131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A0087FE46
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF6571F22B74
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCDE981754;
	Tue, 19 Mar 2024 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RsrEOHmG"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC1581729;
	Tue, 19 Mar 2024 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853814; cv=none; b=kyk85X/fnxzffwSka6OWoYaiFrcleMUJHw+EV8ARKFwo35vX/Q/lUrGImxtBBNzTAqg+PO21r+R/XAbL4pmjsb9xEdOcEnN0iKMHNNaFZ+/ydzqkCGunYylvgm05nNXfYejwwQzFHbeXlWDT7iJDESWeoYNC3kFElkA6W3ex8Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853814; c=relaxed/simple;
	bh=JVi4X3Yp8llR/EjNT7yP76NQ5cLtcJoGUEbvuYaKKYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHCCcA117+Q3lxvZhn3a2ESK1ksw4ZZx1LAPCeWcdw/RtVckMmPDqrQkxAo7UB2BItPnmTU6ZXZQxAUMqN2gmMtlrVIoAKFuF+aLtRRASK1UARHP5UTDRVhYInYECSkVyYm6rFt5jjs0tSSho8tXg5PuHZLgJ3T8wjKvH4WerpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RsrEOHmG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4Zpz2JcjWhGlazAgpId/FsjMBJt7sqHYOH/Rw/CmRqw=; b=RsrEOHmGYscdscCLy/l5STIE3U
	9t5Uqfyswjc11nctCwx9zSrRCsx79QJJU/lCHr3HccMvvhfQVR671u2QSjBuf/ZhbLzZp/4M7jMZ/
	J7QmlhJKZ8SrHE3UPX6wlwqHuUpB3rnqPOX7W9Qh4ga3a9e9lvFksk+oHv2bezWm0rkbWiyu29vFW
	3DSn+4bucYlNPF7j2JM2PHEjqvXUlkDqgFeTudEpCG/sLeDxvKXwCDMaTtkwB86sfLizzxdnYxYGl
	/J7z2RVej7ohygRk1W5ZOCAhSkjkifDKMY2/Cg+fS4h3UBsAMFITcf5lBJ+sShvy5o/iJAF+SoHFf
	QyqHaS/g==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000001zLU-26EJ;
	Tue, 19 Mar 2024 13:10:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000004PN2-0Uut;
	Tue, 19 Mar 2024 13:10:01 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v3 4/5] KVM: arm64: nvhe: Pass through PSCI v1.3 SYSTEM_OFF2 call
Date: Tue, 19 Mar 2024 12:59:05 +0000
Message-ID: <20240319130957.1050637-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319130957.1050637-1-dwmw2@infradead.org>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Pass through the SYSTEM_OFF2 function for hibernation, just like SYSTEM_OFF.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index d57bcb6ab94d..76c7643e7eff 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -265,6 +265,8 @@ static unsigned long psci_1_0_handler(u64 func_id, struct kvm_cpu_context *host_
 	case PSCI_1_0_FN_PSCI_FEATURES:
 	case PSCI_1_0_FN_SET_SUSPEND_MODE:
 	case PSCI_1_1_FN64_SYSTEM_RESET2:
+	case PSCI_1_3_FN_SYSTEM_OFF2:
+	case PSCI_1_3_FN64_SYSTEM_OFF2:
 		return psci_forward(host_ctxt);
 	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
 		return psci_system_suspend(func_id, host_ctxt);
-- 
2.44.0


