Return-Path: <kvm+bounces-42091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C62BA7281D
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 067A91895602
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C181E1714B2;
	Thu, 27 Mar 2025 01:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFDpO5vg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6997DA95
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743038705; cv=none; b=MkI34e1Y/CtWAVeCMimF/pF6UfEmdWk6LX7iEmdGnTeu2GDqmENV/nqF66oHbVD/C68AwFY0qcRrAsNDCH7JiqBbcrMPFxjO26j6MAzAhcmG/imGptl14zlWCL+bFGMGdq27+79bEmwRhKPWWly4dwT2iiguUzpn6EiyP2hQpoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743038705; c=relaxed/simple;
	bh=zLlqYxdhGw0cqRRjDi96z+MiFOFcknIK743A4mTOODc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nIt5Jm8Ox4zsGtU1UbtunApuNSm6PzDtnjQhwwoHDsIF4+RAm9u/xzxMEwe3iG7Y3x370bhHg9Ir/mTJV6rElNJo9RX5vRQA52cfLRmzTFjg0+gGqHgo5J46As7ifbQfeTeyRsVaEnf4WS6/WhePJI5KkH1bpdAnkgE/W6mG+ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFDpO5vg; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-86d71474a4cso95319241.2
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743038702; x=1743643502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h0gV2Hykp1nZANVivobuz4rpzhYTiIcgA3xTmvOSP0Q=;
        b=OFDpO5vg6rmLLlky+r5POeXYQXf3GYRT8jp/LN2TBpZvY2bY+Eq9l3CfvWbpUs6BzO
         Lx05cX2//I4yKjrtlXEFMoSqFeNyBWG8taLEr2MxkBNfzDvNHNVxfVGgswwZiPCbtInb
         geYrSQSUrwE8NMGvgxn6E/do/oYu9B5dc9zvNBGskhcOwnD2jT/4dFAVn/gS9YsOPE8f
         9cowvT/WlIIPp5zmaa0RqBsdJUI7BK4im2wZJupoIf+Sxr3xTjUtFP+7KoLCD5gOHUrI
         BmcFK2mvu59pr05l2884oBRKphVJd2cvn9Tzj4AT2A7Zv3OxCS1dG6FeunyDdAPUuA2s
         I/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743038702; x=1743643502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0gV2Hykp1nZANVivobuz4rpzhYTiIcgA3xTmvOSP0Q=;
        b=B8FXOu/F6rGUOSxH+K9b+fDB18En6LUnhkDxPyoCKfNHzQ0RFLvZmLCevLYtoYw65w
         f/qh22Yx+FNtzH6Xos9OqmlNoxPAxWEiImP6ZBL8AA3zarxAKOuDC+bLRRgtYWVoS5Sw
         vuXsGgAAmzotPh1K6jvKZwQWysf+dNSVvVh2M2FQsnJfQhvOG6HxQTHhtrooAdEEcM9l
         U+Z/CQ2Z15v+TWVmqaQ9lfjvfITKG2ArzRp2umYj3OSstdUXTBjeXMKtF65FcnOrCQO3
         e9dVPf/MIRQpUijvvmHX4cj4Yn6qz3C09RqTAOJAuWO/mr0AYEKtzebfaPhefTwMGNpa
         W3qw==
X-Forwarded-Encrypted: i=1; AJvYcCXSmB+BfkoHcAynP0+x1zKP/hLmiQ50dHnJdrzC6Jm12RIYfXVnqVUjeZ9ewgVTKMOxlIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza9PhU4XXyt70GP+I7wKpurACClfgG3O9JoY69EMAG3FGaNIg9
	6jvBVmrFLoGdfSGl54K3px+CYYpV9JwEFi7MQ9jslFYf4MfXhahhOrB55kyOg2vQV/gennGr5qT
	/PwCqhz0MSrQAa11hTQ==
X-Google-Smtp-Source: AGHT+IGJmEiF1OitEok2mFLmVWOSM49l4tKCl8gfyYUS8Qjj9MZO3Hq+PCEaZnJlxmlEaGvIhaJ2wvGNJri11VQA
X-Received: from uabfv8.prod.google.com ([2002:a05:6130:1a88:b0:868:f371:5d73])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:8015:b0:4c3:9b0:9e6b with SMTP id ada2fe7eead31-4c586f5f8d9mr2292397137.10.1743038702744;
 Wed, 26 Mar 2025 18:25:02 -0700 (PDT)
Date: Thu, 27 Mar 2025 01:23:49 +0000
In-Reply-To: <20250327012350.1135621-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250327012350.1135621-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250327012350.1135621-5-jthoughton@google.com>
Subject: [PATCH 4/5] KVM: selftests: Build and link selftests/cgroup/lib into
 KVM selftests
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yu Zhao <yuzhao@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

libcgroup.o is built separately from KVM selftests and cgroup selftests,
so different compiler flags used by the different selftests will not
conflict with each other.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f773f8f992494..c86a680f52b28 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -219,6 +219,7 @@ OVERRIDE_TARGETS = 1
 # importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
 # which causes the environment variable to override the makefile).
 include ../lib.mk
+include ../cgroup/lib/libcgroup.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -272,7 +273,7 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
 
-- 
2.49.0.395.g12beb8f557-goog


