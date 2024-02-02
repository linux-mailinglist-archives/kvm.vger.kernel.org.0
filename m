Return-Path: <kvm+bounces-7815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4E18468D3
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 08:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E2A28667B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 07:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000FD17BD9;
	Fri,  2 Feb 2024 06:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKTbAn1q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EC717BA1;
	Fri,  2 Feb 2024 06:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857091; cv=none; b=StNFiy6GVJqfUnjHflNEYlh5Zpg/S1Xtt9QfbwJivGU6DfDhAnv/055UomBjwDIE6hfZIMRpyn99wnEbDxIX3Awqfwd3E6p2OYHQVDVgjcgByvd2cjx2z6HBZtXNnQbPZjHg7MxOD6EXyiFycXDpmVeUxdfG9rylGSfUlpbBjzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857091; c=relaxed/simple;
	bh=b+QxyzhsvZN3OwzcPJaOYnXe1uuKxDesUKwJYAtosxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SooEekvaUUFjOH7+gVcBd70i93ESpyvgT0MQCXRyYchqzoNGh/qY2K8QqtZi0mLp4lWoL9RzAMofK4np2rpiAFTDpZdoPBezqJjGb/bpUEuxcTJPB/tXoxh8Mbh+eG91zmUCr2wA47+x92+pRwUWsmtcs2BrWdBwXjZTKYmxMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKTbAn1q; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d928a8dee8so20121385ad.1;
        Thu, 01 Feb 2024 22:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857089; x=1707461889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISYOFWMJ8Ya9qR54XDhg0pvkVFnzxzaLNa6Ru0XuDgY=;
        b=BKTbAn1qThrnIWvVB41bje/SGmdpwsf+zgt0usYaU5bAEAuncyfNP+ZHGKbtwy3OFO
         ilpBL2qQmzI5AygVyfPSeyQd0UoostECTTsC/a+crsQgwnzDQ7zecODymDnAWHL3R8UM
         Pk/d1+jb+TAneix4Ei/mz0Ls1v0MBNZSj07ZhlzQugQx5DSXp/lhjbv3lAk4lMOQEFJr
         VFdmaTOgGoqB5OZ0fgPqNxGd+kiQlEChcDEX9YbDqK3abHNsPXtfl5sXT6CpcgPaenWF
         M0ZL+3BOA/LGS4P/vp7NgTKHrLfoorHKSc5AdW+ASKXfLVGKWFIyWq1HRudnkOgBx0fo
         zXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857089; x=1707461889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ISYOFWMJ8Ya9qR54XDhg0pvkVFnzxzaLNa6Ru0XuDgY=;
        b=QgNHtzmkJxrnAypFzMkWR7zdYfxG2fFedx2YeMsxKZykxy8CNxLk3AXnJOY0Rhz0Ny
         r3PZiiiJCAUBwk4pmCeMoTv0yr/hIYigyjuP9xyU35HfGzgGTA9aVxFWCuN5FeO//qeF
         zY3F5g/QA6VkD5auSo8E5RUjIoa8fUFqSNTfp+nr7nri3LJ81E04okzS0eHh7mXomYp9
         Phqz1xiUeqGHVsdUjq3zgbEqWyG88JK/y/iNsdyoiL208t1RAPI4IBHwS3B7gua/RSKM
         UtKnkWAAG0G7rudKhlE22fF8X5s8RwgKxgUwQmqLQOZn00NodAXURWoTIAji2pKPWzii
         N00w==
X-Gm-Message-State: AOJu0YwXdnZY45Db2s34jrOE3bheisixeKdzECX6Gu7+TKxQQF9QTFw4
	8JElavuk3OlMgD4dRBdLL+TCg5gQ4Wro5nlM0pLNpQCbkd6MHmLt
X-Google-Smtp-Source: AGHT+IHuRTzUNEDoBrt5G53jiaYXfJZtXJVA0vZJoFpKTVNkOajG1pLBiy86JSnIBL/sauMLQIgPVg==
X-Received: by 2002:a17:902:c20b:b0:1d9:30e3:ea84 with SMTP id 11-20020a170902c20b00b001d930e3ea84mr1670212pll.2.1706857089045;
        Thu, 01 Feb 2024 22:58:09 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWjZNe27ib/vYkFoWq6/PqYfbalOs5zAPw9skB+ZgcK8jg9IvDXE9J+CmHt9/N5zRNbuarqznq7Q4qopRSOqZX2cn9N8IgrYYggfQalfDEBinpojSGVWOT/EUIfWj16iA7eMjjbF9xT/aeq1KFiH2OriigGgcx/JOmtm/bu/PB4qwkshtB8p/24b9LK/rvjJ41vh1YFLdy13VZGXmTAgSqseL5L2VuWBtBaGkypdBLoRkYX2ODngQHJ1LN7EXIzX/ToWEwUbOsvUzQTdXEd26i5jE2nHMk6k1YUOPq4uEUj3WVbE9EdmpS52VgYk0FqSiry4mg+XLFagmWYk7cJDMr37edC1DZbObWmmZsb5HBPOTFs5UYkR+wZ1f8hF83cM4b28GvJiZm6Irid1eoOsd0ThO6B9s/31Z7jYPgg5YzzBggQrhRnvihG5vRvumkQNDNelKznW16NnTC6/ktXq9qy1yXpuoRkjqKCDvxb68MO3ZFcGim9OZPwXv2fOMaV0AVd1R2NojYBw3M=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:08 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 1/9] (arm|powerpc|s390x): Makefile: Fix .aux.o generation
Date: Fri,  2 Feb 2024 16:57:32 +1000
Message-ID: <20240202065740.68643-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Using all prerequisites for the source file results in the build
dying on the second time around with:

gcc: fatal error: cannot specify ‘-o’ with ‘-c’, ‘-S’ or ‘-E’ with multiple files

This is due to auxinfo.h becoming a prerequisite after the first
build recorded the dependency.

Use the first prerequisite for this recipe.

Fixes: f2372f2d49135 ("(arm|powerpc|s390x): Makefile: add `%.aux.o` target")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 s390x/Makefile          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 54cb4a63..c2ee568c 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -71,7 +71,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 
 ifeq ($(CONFIG_EFI),y)
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $^ \
+	$(CC) $(CFLAGS) -c -o $@ $< \
 		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 483ff648..eb88398d 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -48,7 +48,7 @@ cflatobjs += lib/powerpc/smp.o
 OBJDIRS += lib/powerpc
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
+	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS += $(arch_CFLAGS)
diff --git a/s390x/Makefile b/s390x/Makefile
index e64521e0..b72f7578 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -177,7 +177,7 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
 	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
 
 %.aux.o: $(SRCDIR)/lib/auxinfo.c
-	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
+	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
 
 .SECONDEXPANSION:
 %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
-- 
2.42.0


