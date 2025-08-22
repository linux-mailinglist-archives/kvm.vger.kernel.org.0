Return-Path: <kvm+bounces-55551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB9EB3246C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 649E8621868
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3158350D46;
	Fri, 22 Aug 2025 21:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="01fbC/9W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E8C35083E
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755898001; cv=none; b=qXhV/m1NSvkj4pBr2CKiSUOMreVUgsk4S1vgyLn0Ebwldz3h2gmE1689vHJvpJynTg7ToneDKcwGRwrxfnV0uYFAvctfpxikVwyH5sDg+MRl+Rc4l4dVWL2I2bY56jijj4Xx8zXpL1SL2VStYgk6wmCRtYMucj04kE4kHQiqY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755898001; c=relaxed/simple;
	bh=PH4BNmL4j1oTedv99HmaZlHHjgHjW0yJS2VjqLuYMsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n8UyhLAd9+jrZUOYTlJ/9p2Lh2G9JN/a4fZCQ/jtIjm6AqGaMMN5HFe6goLXiwGmlEq4Z/Hgiu7eGElbHEufMURqOIp9gK629odJQHOVitfTKlDcEA5vJrL1nnMUjRN6XNuklR6XYN7imECZe5DqKBn0YaqlQ71z31wftpVRpU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=01fbC/9W; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32515e8e4cbso2841023a91.2
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755898000; x=1756502800; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UK7Q+9AUfaqveTp0dvJV4DUGXRbDetwM3vZUKcGC+KM=;
        b=01fbC/9Wh9vtnsqruKx09jnePZBJRkQryaZJ4LAh7ikvgjO6P10IwrbDP9RUXXbbw9
         8zR5ShJTT++owajEShhWi1fz515/Q7oQ8GRAZoCZYL9IowF0K3uFTRlmIG8ArKN8+QiO
         b/fF4wA95FBBOr/5hA1B8pkvbyFoak1ixtQTG6widRraRedPsSqRjzSurxQn52+HQPdk
         Sg6FYqlWSO5cGkqe6pCGLtNlKcY6TruRaeieXGMULX1GWrLLRa/l4ezaAo1zu5ZgMbeU
         x7yRxATryMS77G0/+KnK+3R7RkJmQAh4srdR32LDYranK+JVQoPixXVzrKwGFnh+Zixm
         mI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755898000; x=1756502800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UK7Q+9AUfaqveTp0dvJV4DUGXRbDetwM3vZUKcGC+KM=;
        b=FlD0nFwbxNx83MNopFH0u0bmu3TQEjP4TxP1n94yUi7l3qzqQHcO+4jWrev2jwZzLW
         R63MG8rZn4T8zPai/r6Yp5Uo6Os6RsCGJKnpunGWEk7hbh7tJr/EewOK15+0fAAxD3Cb
         ERlryyvV/hhGdv8CtFLXvozomom9KoOQtaAqib9gF/8zFt2HSGJQcNoGv/Pnr1e7JO+k
         itK82loxiva43CQ7yZ4+4/ymuWBHgetyclubS9mIbSymVkc1MBoxLThVEz8oNSB6wr5w
         rBRhuP/ML2bQeqnxgDt4PCy04LW2RYiCJfsAjvns4+TO0Qlg/8ViyeBtNn2nvMAcoirE
         9iRw==
X-Forwarded-Encrypted: i=1; AJvYcCUgzDwn1RQ32yTKzAapsUa2esp+ttaxBZA6E06wK2lsxsbj97RtmCikeYnEfWevyQcVDEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlrtbvsJzIFAxPy+v8HpjPh8LM30tAv57QdX3ZWC1swI3mg84O
	t4gd0DcZ9tUrGzNWjJPtd3jN0pvyEOXYdWx5qRh9Bsog/WRL62U239bJU8+htg6krBurCmS9pAW
	6DOXQrGNBv2wtVQ==
X-Google-Smtp-Source: AGHT+IHyMzZ1btZjsaiimjf+KhNRS17D5VjPY2ftKJ/LCnTGKnhdff6k/oQDK0ClOf/fC8qyK4uuXPSsGaIbUA==
X-Received: from pjee11.prod.google.com ([2002:a17:90b:578b:b0:31f:37f:d381])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3842:b0:321:75c1:65b2 with SMTP id 98e67ed59e1d1-32515eabbb3mr6183819a91.18.1755897999801;
 Fri, 22 Aug 2025 14:26:39 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:08 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-22-dmatlack@google.com>
Subject: [PATCH v2 21/30] dmaengine: idxd: Allow registers.h to be included
 from tools/
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Allow drivers/dma/idxd/registers.h to be included from userspace in
tools/ by adjusting the include path to uapi/linux/idxd.h if __KERNEL__
is not defined.

A subsequent commit will use registers.h to implement a userspace driver
for Intel DSA devices in tools/testing/selftests/vfio.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/dma/idxd/registers.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 9c1c546fe443..02bab136385e 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -3,7 +3,11 @@
 #ifndef _IDXD_REGISTERS_H_
 #define _IDXD_REGISTERS_H_
 
+#ifdef __KERNEL__
 #include <uapi/linux/idxd.h>
+#else
+#include <linux/idxd.h>
+#endif
 
 /* PCI Config */
 #define PCI_DEVICE_ID_INTEL_DSA_GNRD	0x11fb
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


