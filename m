Return-Path: <kvm+bounces-59245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B59BAF937
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 10:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C573C6DD2
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 08:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E63E27FB0E;
	Wed,  1 Oct 2025 08:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AkfZuNvI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73F5279782
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 08:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759306909; cv=none; b=j5pIcV3Srdh0ppWf4FhTS+Trv5ZbUEDeCAKgObKkx3wGQyjRVk7FgMIEoMAEmJf6AHEvire7ikyyhufoyZN5RHeQCCHil5F00rkONX9fUkP5StskqA8NSEnfwrmRAfWw3jpVESYXnt6xlo9UEdQVUWj/pFTwNgIimroUqO1rJg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759306909; c=relaxed/simple;
	bh=7A/Wf04fZUM5YpaQrkxKDHkugwwbV0gJcE2nCP1/yrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCEJTtXL5ftQGsF+/D8GYzKGM+RU7MvJpi6Z18SNStQrmo96ZNKSG1HVp+oA4e0QWckGskVykq/KQSodRL17EFFE2dmXCHZLYnuCNQtjgR4meF6J+UYRBntx+IlB+UYRGENIqfT9NkepNGy4d8XTv5kMPkwsaBadUkfHWz/cQMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AkfZuNvI; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e37d10f3eso53838835e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 01:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759306906; x=1759911706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUDa5xnsT6LdBUx7EhioTD823LxktxWEacMY6wYwfL0=;
        b=AkfZuNvIV1vhhQSy7wafsyQiJ4UhsdRz7/qhRCz9eUBZkDUaJHe4mIhHemQ9/5F4Gp
         9+yv12197yeEEv5YLiKITlseE4Sh9DqviGPFHMh1USG2FTKyPsUzE7qqYpxkmPo7EmXF
         DOVuyDz7VPD0MM8Wrf1g8yQatzev5wTG+DmFxAh9bPL/ltkaSe64ojY4wzmfVXWiAT1S
         Im0Y6q+JZJFyJR58JfKVO2cOj70qkGWEX67aK0fkX5a0wNmgeiIyAKZtWYS1tPAaV5gO
         DkHvasLN8EeWfAF0B5H1GWvLHt4siVaY3KsPWyWlmFejRH1oHNFTKnvzDGRJeE0DEyOD
         Xtvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759306906; x=1759911706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CUDa5xnsT6LdBUx7EhioTD823LxktxWEacMY6wYwfL0=;
        b=U8mdCuBXCbpqle7yTAosBu3Vve29LpRHFh/QOETDNIEA00cmfwutt1n+yj6MZO57oK
         uCjXtY49GMtiJczJHc/vmubUXdpiqTxmTGGDSZ34gNunmyYaXKtmxhMGzzaFIeZW0Ja4
         BkBc1xfrSKDma5glVTOldolJjRlwiPbesW2abDe12RBsBQBPcpwr9tTKzRvI4FyXxzV6
         ueoDQEL/tbWhf8OF9ZD7gq41+HDodGPb8h0rzJaX5JBjelLXNWnj0YGuIBDsWrmOjx1b
         RPoJo63u4WKq8sCEv+FmhBS0A7SRDdpd4uR8HIz9kQCmeW13Grlwjp3zRdytYPAm6mnZ
         8ptg==
X-Forwarded-Encrypted: i=1; AJvYcCWEnUXSRpmUdZnKLxI1myqGdF7xOSabF79DvviwsxvtMWyFqLVs9XbF2Uh9OWjgWipGn1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxigqZt3/QuftT49C1erQp1gRgbs+/5PbOngRDH6kKCbTnrwyYq
	7/2c3dNzpM4MLpgNntPrfe0md5ydOGsLxgRje17t28Eo7/hbL2tHEz1XHZorG8wX5rY=
X-Gm-Gg: ASbGnctGl5LNo49e3Ui3oVIOfrtURjyxkRitJqOIjyYc6rLFYwwUpeko9VF9JI+8iHf
	OmfCgRmtAAzDMV6ngZ++p/7S1b/4n88EgOTnbYkHX12RTPJgpIIPGK2R9d54VD8OH3+I+EWXvpp
	LmQeWcZcX23kk8mLKJwh8+48JbYsD51yr6jL0iM59hdae+z+uaymTUk+Dp6+a+xvd9jT8bf8tay
	7gKi3xTAcXEjosQKSWK4Md9WkAfnIaKxAgq1dN0Fjz2/RsWQBqaYXlOB5Pa/76KUGDSs8pstost
	ZJB6D7gistmeSC4uc4rBosfyPTd2QTUn/NAqmEmH7p83DtPwlf97/Z5GckNXkGQGeqT7oXkDoEm
	dp2aurBA2mD4SRu5ykVJuQ7TyF22hygloHDXa6MzrXpIYUGJncdcNZVVUDayNUIqpmAqXlbPY7c
	Ha6OUZHqwaKYfWn6i8DY7X
X-Google-Smtp-Source: AGHT+IGupbg9/lAN7fK0YZ5iNSEbaJIxNUI7X13KRbrcfs3DgvFIGFl1v0k+/aPUDlPoG1Y+QWnAwA==
X-Received: by 2002:a05:600c:1f10:b0:46e:32f5:2d4b with SMTP id 5b1f17b1804b1-46e6129588emr20005035e9.37.1759306905959;
        Wed, 01 Oct 2025 01:21:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb1a3sm26551095f8f.10.2025.10.01.01.21.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 01:21:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH 03/25] hw/s390x/s390-stattrib: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 10:21:03 +0200
Message-ID: <20251001082127.65741-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001082127.65741-1-philmd@linaro.org>
References: <20251001082127.65741-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "exec/target_page.h" header is indirectly pulled from
"system/ram_addr.h". Include it explicitly, in order to
avoid unrelated issues when refactoring "system/ram_addr.h":

  hw/s390x/s390-stattrib-kvm.c: In function ‘kvm_s390_stattrib_set_stattr’:
  hw/s390x/s390-stattrib-kvm.c:89:57: error: ‘TARGET_PAGE_SIZE’ undeclared (first use in this function); did you mean ‘TARGET_PAGE_BITS’?
     89 |     unsigned long max = s390_get_memory_limit(s390ms) / TARGET_PAGE_SIZE;
        |                                                         ^~~~~~~~~~~~~~~~
        |                                                         TARGET_PAGE_BITS

Since "system/ram_addr.h" is actually not needed, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/s390x/s390-stattrib-kvm.c | 2 +-
 hw/s390x/s390-stattrib.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-stattrib-kvm.c b/hw/s390x/s390-stattrib-kvm.c
index e1fee361dc3..73df1f600b9 100644
--- a/hw/s390x/s390-stattrib-kvm.c
+++ b/hw/s390x/s390-stattrib-kvm.c
@@ -10,13 +10,13 @@
  */
 
 #include "qemu/osdep.h"
+#include "exec/target_page.h"
 #include "hw/s390x/s390-virtio-ccw.h"
 #include "migration/qemu-file.h"
 #include "hw/s390x/storage-attributes.h"
 #include "qemu/error-report.h"
 #include "system/kvm.h"
 #include "system/memory_mapping.h"
-#include "system/ram_addr.h"
 #include "kvm/kvm_s390x.h"
 #include "qapi/error.h"
 
diff --git a/hw/s390x/s390-stattrib.c b/hw/s390x/s390-stattrib.c
index 13a678a8037..aa185372914 100644
--- a/hw/s390x/s390-stattrib.c
+++ b/hw/s390x/s390-stattrib.c
@@ -11,12 +11,12 @@
 
 #include "qemu/osdep.h"
 #include "qemu/units.h"
+#include "exec/target_page.h"
 #include "migration/qemu-file.h"
 #include "migration/register.h"
 #include "hw/qdev-properties.h"
 #include "hw/s390x/storage-attributes.h"
 #include "qemu/error-report.h"
-#include "system/ram_addr.h"
 #include "qapi/error.h"
 #include "qobject/qdict.h"
 #include "cpu.h"
-- 
2.51.0


