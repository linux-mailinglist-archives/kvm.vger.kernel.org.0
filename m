Return-Path: <kvm+bounces-5150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D60A781CAEF
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75C211F24A51
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4DF1A58E;
	Fri, 22 Dec 2023 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMSqAxZf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0AD1A707;
	Fri, 22 Dec 2023 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-28bec6ae0ffso1169602a91.3;
        Fri, 22 Dec 2023 05:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253087; x=1703857887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=kMSqAxZfEDQeg8xWgGEemkcYd1pVcXa+VWK0sGSPTEXPw4fLazxSA8ImQ1phX5keOl
         KwLqWpaf1q7XRU1bl06YsXMWW0W3D/Owsoh6G3a934zLFvEUb+/Yx26SrxTOJBG/4Dxi
         dQ+QDew3Z80oYuTnvDRKmAor3H73MSCNibKpcqjMoV2psiyzWoyFsQhdDxoB9ZO8IXK9
         WxiyNQmBd37OFLfj11CQ11nuJfjY82tlMN8p7AJdXh1XY1Yle9qiuDUT/ZkqTXC+Urju
         oXhG4f0qO69hij8pqIrUw7ZZDWy4r9P4BuPjdwhdgus+K9O2NjtyYZ0Ni5POn6rYcebz
         McfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253087; x=1703857887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EawXcrWZcj4wjBdULRz+yh78MdJFfpIVMXufen8CLio=;
        b=iJkS4/q8cYnsiZ/tMkDahtYnGrzxdRewdA/IsKqtJrBZu43FTCPrhco8gw2r2U/vdC
         q3e/9RZnSEmDQEH2LvH22L4S5J1AOw7b62Azb8pv7WpB0WlPiK2EviPRbVQURdcYdisu
         u8Zzzm/7nzoKGUWmJB9GpvG3PJIbJY24bS3KcOr+g6UXi1S3KkWiqVtUJhEYQLf9jWNz
         ATsePcLWLHPsEyArjbUVSv1FEASX+zhgz0MHUHRcE66v3xnBY1ecEjlv+Q+FytyU2lnO
         XBf5cyfJ9RQuwlXIFMRQ0SaCgPxNAKt26kGKoSMZmxeXYcY03wD6uLEsPvDRcKZDdzn6
         1+ZQ==
X-Gm-Message-State: AOJu0YzLsiTPysQ2FnKZKGP8i/wr1JfDit89Sld2gokcf0utP3aGyDnf
	ihnD5aBPtDfL0tQNZ0lPY+A=
X-Google-Smtp-Source: AGHT+IFxYHMd3mIJhG2htlTQipJ7HFZrRdouAmWJJ2UmxbUBkbfOshxr2F261fmorF3DjDY21EJ+3w==
X-Received: by 2002:a17:90a:158f:b0:28b:bf26:3ba8 with SMTP id m15-20020a17090a158f00b0028bbf263ba8mr829664pja.6.1703253087364;
        Fri, 22 Dec 2023 05:51:27 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:26 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 3/9] arch-run: Clean up initrd cleanup
Date: Fri, 22 Dec 2023 23:50:42 +1000
Message-ID: <20231222135048.1924672-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f22ead6f..cc7da7c5 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,10 +271,20 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+		unset KVM_UNIT_TESTS_ENV_OLD
+	fi
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


