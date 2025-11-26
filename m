Return-Path: <kvm+bounces-64735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FF6C8BA5E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 59DF44E9105
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C07311969;
	Wed, 26 Nov 2025 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c7OdERCp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA27D347BBB
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185794; cv=none; b=pJXA3W0Hsa0nb3euk4bQFBEzFaBBDD0eveLBuUHNdfGhyWc+Jp5nEn2IswS0P8dp5Lvtwro2SWzYnSL91Iy6pe06g0VKBfH/udWMY3SqrHnUXftKemtYWNRWMpbJklL7tLQA8lsYZ7x7cf7OfqAFfYTLCZlIpydMA9b+cACwFKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185794; c=relaxed/simple;
	bh=2C91XLgizRzxrlYCyNq+ckn1edftrGddg/9ARO85DKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i4uxKztA/6aAf5JQ/ejQHparT4orCFu8HSgradHMUXIT0TiHEFqDBAd0wDw34JGeqTkxcRJsjdcmw1wlaMCODsfUCWpo+TJPUFExa6eRDtQddW2Mmp1iRdeT2PZ44qbshIdZR4uWzYMxaSWZnxSsXFQ2sCo9T7uLfoA2r0izWsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c7OdERCp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343725e6243so811230a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 11:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764185791; x=1764790591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+RPQzdHtB0lCBw9QZTDQVrKsYUywm29Ltc1imWZcj7k=;
        b=c7OdERCp4K4Lst3D604HWJ1Hdu08QBB7S6QuQtNhXD22a/ZdUDs5lj4EygqUPNnxYQ
         ZiLWizqSKzZoR1Vb04qx4wrTV/HNWXXyL14cm3ndPgHC9OX0+br9ROhT4YPLjeDJJgHu
         WpHPKJapZJbi1tcyWCGoFw8Z4+m9ESspCNL0TGsjFVnXr04XuhUChKT1+memJo2AQuic
         Zj3ExfPQ9Y9t5g520Hfjsyvp/evzGcy1r73mBSnsUwM5P51wc6XdiVhAwgq5FwOM7sE2
         Dcn+5ddwbsy3vpur5Zo3pSby7cSbO6r4KKmJI84qz7zCBJZxEEZwlux+SlymgRQ0l523
         Xcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764185791; x=1764790591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RPQzdHtB0lCBw9QZTDQVrKsYUywm29Ltc1imWZcj7k=;
        b=tubptEuNFTzQVUr0zoC4baC+HECTI+69aVX5KXfuFv7hnM4lJQA6FRAzKapcClW90T
         nEAJDshLu5rrxAetn0PJGQsjHXj+cstIdRGqrqXmeshgtznAvzUpVqerq6cWLhX7tEXR
         0LHsZDomyLmGMGM4zfQiyHHaTCZquU0lJv+Vu5TMJdssWccTdBA7LxQSes0gyHQEi3hR
         JDbHwOfWg4hfgL6ulZhQXdVjF7tDB55OCXnmILcXi0b8ptBlb2gN30EQ+yMqBCkBWwKI
         SXg/QDuES0aPBLmlLybMxzXDfDESHxJ6JFj+gtWK2JWIGpdw2+xSGxjk/EzRZPQLMT59
         Z68g==
X-Forwarded-Encrypted: i=1; AJvYcCXCpX6iLInkVDzOnZu9lKPFLjT/9G3I+tSOEVfpq2gP6ioFUNaQY/muw8JxgSyHb0XLkHw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFyWWWtXkxT/dpIjoUH1QOSkjubeGvCUm+xnsi8xIk4QONTT6Z
	sgRnkaNs+2Z4oT/PHhMUa+Dbby6ChEUHTdNwU9vt/IIIl0m9uGJgcZhWDDzZu4NK8kmKWp93MDA
	/OSkG85X1u0hmdQ==
X-Google-Smtp-Source: AGHT+IGJKvfpLG416BGAixM+h/ZidHbUlKEaobKY4EEVzwZO2KNhNqrg2ZdlLp8R7DryVcFhcu4pbfPELtL2yQ==
X-Received: from pjboi12.prod.google.com ([2002:a17:90b:3a0c:b0:33b:9921:8e9a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:dfcb:b0:343:7711:127d with SMTP id 98e67ed59e1d1-347298a9fabmr23577307a91.9.1764185791103;
 Wed, 26 Nov 2025 11:36:31 -0800 (PST)
Date: Wed, 26 Nov 2025 19:36:00 +0000
In-Reply-To: <20251126193608.2678510-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126193608.2678510-14-dmatlack@google.com>
Subject: [PATCH 13/21] vfio: selftests: Build liveupdate library in VFIO selftests
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Philipp Stanner <pstanner@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Vipin Sharma <vipinsh@google.com>

Import and build liveupdate selftest library in VFIO selftests.

It allows to use liveupdate ioctls in VFIO selftests

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 8bb0b1e2d3a3..8e6e2cc2d8fd 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -11,6 +11,7 @@ TEST_PROGS_EXTENDED := scripts/run.sh
 TEST_PROGS_EXTENDED := scripts/setup.sh
 include ../lib.mk
 include lib/libvfio.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
@@ -18,11 +19,15 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
+LIBS_O := $(LIBVFIO_O)
+LIBS_O += $(LIBLIVEUPDATE_O)
+
+$(TEST_GEN_PROGS): %: %.o $(LIBS_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBS_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
-- 
2.52.0.487.g5c8c507ade-goog


