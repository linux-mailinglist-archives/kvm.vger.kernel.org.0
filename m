Return-Path: <kvm+bounces-25029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5066195EA32
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 09:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83B731C2121C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 07:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE1B139D07;
	Mon, 26 Aug 2024 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iTRiaFj9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBE612DD8A
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 07:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656616; cv=none; b=IYlQ23U9H7eMuQl+z4XG04yFKOqV7ARoQjwMPK74C0U83S2OWVvpFFfTXG6urh0IBRq1ow6vj+S4mcWaA5hsZaCxOpm3ZNdSKalMUpl/5UFPo+5TyAsA0ub2v2I+oHSEqsw42DZOFjjdPqgFEQKiAQnJTyYOHzXwxzbYQcucF6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656616; c=relaxed/simple;
	bh=HP374hzQKt1PoMnLVLHbgO5xbnjTW90EAECCpEBd9MY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NbTOzOqYdvqFAXxSNAZ1q0QrxnZB0lzSEDdEB9HwQkmM3V9ZrXdRJxfesvgc/t6YdNVFR6LuPlb5WMau5kWtfBrXhCbTd93CVn9CTVKF/K1J2bpntaai/K1gLkGnPmndrBl6Vmta83hKSA31lWthpM437AwBD4Wnw1k2l3Bk7Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iTRiaFj9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--manojvishy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso7084126276.2
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724656614; x=1725261414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIcgUoBTp9GuGTx+59sM7fDXSn2WoTkdtpOjFEdC9AM=;
        b=iTRiaFj9DVQv5vMxurVVHm9QF8PGaaxslhibr4dOqZgEmBXS0qd0Pe9NgxqPZoShKI
         oWTP6JOaplLGzEoKYlsl2wqKGg5SGAInS+L1cxLnGCkLekvS7AM5i8ERN8qNGLxP+DfV
         XO0MOKFo5ev3blh8TCW+gI6z9XVx0u0wRi1PECfkYidYjFlDoQnOAiMAT23Cy7PHZo4b
         +mKnAkb1jkwkXOq5Fa25/PTg1ZKlR/+AeCLv/hSoSft4BOf/gPtkOQ9YkFRhdsFCxFtB
         YqpHUHT9TtkmnVrH3Pc3GZamSNYa0EWAw5cEq13PO5DxFOzl1dvqQa3MRshFJuTsArOr
         ScDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724656614; x=1725261414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QIcgUoBTp9GuGTx+59sM7fDXSn2WoTkdtpOjFEdC9AM=;
        b=chrL8Hr2QUctXmc4akKQSVPpSgqL5emZ93QooinjzIJJfi9nZOWLfPhd4wXzuK9Hu6
         e3SmTJsB7w9mD4sIcG/2qd25LORccL6yV7h/CrKaSju12zW9m7uQNwp3y2vq70wEAIkb
         uz7PjQrRXq2olNOfGGKc5G75IgKX6kllhJp3Gc/kTQXKB94qWXUW0TbXZJvMn68a3XTZ
         QstkhA01g/xbo+xYlV1TXr0nseAcI8jU87OQpAMOtqNzrdwbpu4XEdW9FL2YsYXxlvD6
         AmcrRN1B6wfJJRwQ+T6T/fmvBTPjXN+Q3RGmkd+SFdipAaHT6qRcFLtg4pky9GIvJVwC
         Tt3Q==
X-Gm-Message-State: AOJu0YwXWeCuu6KG36kVj0BGmI9BYQwRKKwoEfdYoT2nw3LdKwUi73Q/
	N20uucSEBS+ozLL5msh2FLdNbiYZL09ilIGFhO1SOJ/sVa+TSQScstLwc0ChZIzJCb4aHwpUCzW
	M8dzjzyBW/Do8kcJZDQ==
X-Google-Smtp-Source: AGHT+IHrlol7Anpnd920uxfnTbedTgfOoLRdg3g5Rtafipisfy+CH2cN56NbbUf6MkXF303FuBbETzycPNKV+61W
X-Received: from manojvishy.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:413f])
 (user=manojvishy job=sendgmr) by 2002:a25:ad5d:0:b0:e16:50d2:3d36 with SMTP
 id 3f1490d57ef6-e17a86208demr247806276.7.1724656613663; Mon, 26 Aug 2024
 00:16:53 -0700 (PDT)
Date: Mon, 26 Aug 2024 07:16:38 +0000
In-Reply-To: <20240826071641.2691374-1-manojvishy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826071641.2691374-1-manojvishy@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240826071641.2691374-2-manojvishy@google.com>
Subject: [PATCH v1 1/4] iommu: Add IOMMU_SYS_CACHE flag for system cache control
From: Manoj Vishwanathan <manojvishy@google.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Joerg Roedel <joro@8bytes.org>, Alex Williamson <alex.williamson@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	David Dillow <dillow@google.com>, Manoj Vishwanathan <manojvishy@google.com>
Content-Type: text/plain; charset="UTF-8"

This flag indicates whether the associated page should be cached in the
system's cache hierarchy.

Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
---
 include/linux/iommu.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 04cbdae0052e..ca895c83c24f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -31,6 +31,12 @@
  */
 #define IOMMU_PRIV	(1 << 5)
 
+/*
+ * Flag to indicate whether the associated page should be cached in the
+ * system's cache hierarchy.
+ */
+#define IOMMU_SYS_CACHE (1 << 6)
+
 struct iommu_ops;
 struct iommu_group;
 struct bus_type;
-- 
2.46.0.295.g3b9ea8a38a-goog


