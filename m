Return-Path: <kvm+bounces-57438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23901B55920
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF1CE5A31FF
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 22:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13DE428469E;
	Fri, 12 Sep 2025 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqIm6oK2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B42741C9
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715940; cv=none; b=hUnM48uFXACSX0WxiDtp1c2N6/O58IW4txupIVfZ/stvDCjsNClWMfZWy+SclxwATB0as8UjOfnzUdru3U+q9iu9vbW4TMuLdVfKgkz57SFh5XgfUNo4aBRAYTVtdd0KK12eEJxt+FhwZ/eJqmwjYQULxEVX6qP5QoRBe2LiRN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715940; c=relaxed/simple;
	bh=psx+NERoNJo4/HhihU9sbPPzE9T744Xou1CgVA4z4L0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O4zS53Nmmum7/DBj2vHMxJGFfj7uylm/wE8zWsXx0fuboXOLOU8Exo/2mZsyhWb5JZuS3qZApYnzkjQHYlIIbPS86cW4Fi2n71GYqwDLo1mWDReHFKedaObyIP1EB7GU3dhpszPKXli0/tHLvbQX9cl4FFn2xwqLzOnmrmcKtrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KqIm6oK2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2507ae2fa99so43384715ad.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757715938; x=1758320738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vwfWDEmcgfshuybXT2K41m0iYILW842GWaIfS8sv4Og=;
        b=KqIm6oK2Z+z6w955C02eVL4GzQiEQ5Sdf+mA2up9oFZtMlGrIqAjGvpSHQa7BWKZAV
         c0W/pAKiPyEIXXEvtkxnflxYQjKO3dq0fT9s2MMcFJrPk3ekpQdk7wIj3W01qxTny2qy
         ko+XnV2LXfE4wOAea8+Z42YdstAvVKjXYUgdFEp5FPTupfmsleQeglsJ+yeoubvwreVN
         i2BCEEraRdhb8IyXPQx/P3v6XCsFyk1K5uczUbIJ1R1zRWGJraYGiglJS3eLxBZtB5R/
         XWpJtZvpCpu/wj3/qGvUyC135+Eb36Ag/EI4QMHw3f8Xg4CBvnJxqlp6vOlSJEvu0ht5
         rtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757715938; x=1758320738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vwfWDEmcgfshuybXT2K41m0iYILW842GWaIfS8sv4Og=;
        b=W8/y8OhC9OyJoKkojo0SqL2FaWqJ1zqeIYbsoAiy7DaGgQHBJAKI4wBxi7SY45hfmw
         TH4BrEpTIXChBzs4JEK1YpwonJTUOUivqRGETFENdlJsxypqbsfFMv/JA9MdM3gu3Spe
         +I1kAcIapDkrPxDm0v9CdvoalZu8mcrDmjnDsQF5My3N2ozq5Fj1PWHOWfRcyIHEKpjB
         s6q9aFkQzMQVDmr3Kz0zX859/E8FPY1ihloe2oHvUgccLMGEJ4yB/CveW0yygikj5BMY
         O8RcDyo7O3fMjHSL4lhydFONiFnVKeY39RtX0Xyr7HHnoGv/y/OOMHyVN3jQElUBYhyr
         SZLA==
X-Forwarded-Encrypted: i=1; AJvYcCXO6Asd0L72bBJuJPJrK9AVC0IyhTCi4M95JNi4ezKwY8i6LUFb6w6asznH951tnnnzJ68=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCdTDKkrAHznQlr0kPRAbqxy23Gn2YEQmky8J2qmirRx9OOMr/
	MaZy+FsvbJ2sLRnifOvtPteLDuZ09nYCadIsmqo9n5r6pzW6trp9VsL/gh5STIoMhEIydrqwL92
	d6St0k2fDg6dk8w==
X-Google-Smtp-Source: AGHT+IFZ0pKLLn5TqH6MobggzBkvTKMCSloSjSZFg3k6m3b0Mu4Vm7a/FcizSkvt4x8JkRaxfVyNg4tFm5GNaw==
X-Received: from pjbpl17.prod.google.com ([2002:a17:90b:2691:b0:329:d062:585b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f78c:b0:25d:89ca:35d4 with SMTP id d9443c01a7336-25d89ca40fdmr41015075ad.4.1757715937704;
 Fri, 12 Sep 2025 15:25:37 -0700 (PDT)
Date: Fri, 12 Sep 2025 22:25:23 +0000
In-Reply-To: <20250912222525.2515416-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912222525.2515416-2-dmatlack@google.com>
Subject: [PATCH 1/2] KVM: selftests: Build and link sefltests/vfio/lib into
 KVM selftests
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Include libvfio.mk into the KVM selftests Makefile and link it into all
KVM selftests by adding it to LIBKVM_OBJS.

Note that KVM selftests build their own copy of sefltests/vfio/lib and
the resulting object files are placed in $(OUTPUT)/lib. This allows the
KVM and VFIO selftests to apply different CFLAGS when building without
conflicting with each other.

Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 2f7a0ed61452..ac283eddb66c 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -228,6 +228,7 @@ OVERRIDE_TARGETS = 1
 # which causes the environment variable to override the makefile).
 include ../lib.mk
 include ../cgroup/lib/libcgroup.mk
+include ../vfio/lib/libvfio.mk
 
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
@@ -281,7 +282,9 @@ LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
+LIBKVM_OBJS += $(LIBCGROUP_O)
+LIBKVM_OBJS += $(LIBVFIO_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
 SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(SRCARCH)/%.o, $(SPLIT_TESTS))
 
-- 
2.51.0.384.g4c02a37b29-goog


