Return-Path: <kvm+bounces-9244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B653B85CEB4
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:28:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74C021F21BCB
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E349D38DDD;
	Wed, 21 Feb 2024 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KmCy2mfu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64AE2E632;
	Wed, 21 Feb 2024 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486117; cv=none; b=V3XCk7i+vCcwb0mPtl/BskudG9g0zgfkIieYTsSqxuBxHC9BblFOfhbeBPghhPnBqASo62SFoFiS1Hb+M2Q4T9ocnfTbLBfWgnXn/wVL5e+qtM3tYcRVl/fUOwE+EcHGYZTTY+oAlG6+dvvIFZSNkY8xU/GlBeeGeETbwFZ2bDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486117; c=relaxed/simple;
	bh=y2BU4+PN8T27EuGhaIHzmKLCmns9lA/wgYSlFtfkTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyaPF0vDvCoQjWvnsU9MnOLPRYqJVKNWZEqci2ERBi50rSpA1UEt/SBYydAS2sRjiKCpELqey2DG+nLgJ+xms4HMapqMcFWTZlYHjIF816lgjWEp5oozc76lSiTitGEe9WWQE/9QSCy9j2UT1rjuV4PeAAFZqzxUsAEsY3crEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KmCy2mfu; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so113380a12.1;
        Tue, 20 Feb 2024 19:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486115; x=1709090915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FLaKcAirk3CTYgyOfE+aKJ+UIKz3IbgFgbToFNpwyg=;
        b=KmCy2mfu32UBKKX0VkLB0N6pDX3LnbNVU4x7TUswhyuzSrpngpYHn2cyInF3yys/1Y
         yTanvkHM1vRnPaW4YLfPCIZjYJnO1kooFXVF/A+5EhP+k6S9XB+eq+Gs7plNifgj1Kmk
         mjBNpDQIYGZAnos/ejrd/pbayejv5oRiGes9TyC+l36kzXeWjF5cJ/7ms2rVJAZ+2PXi
         DddIavGMqoHFxG5UVfZhXsr4zZ6GC4uJSo73FYYCprC7DuBJ95ion07T7c0NE2cP3VKK
         rr6tcIXoaOtnIz/ydaaWct/1r1fvtg8v/YXaTBTcjWYeJdVTA+FULCZeH5xVuPZL7eQJ
         lB4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486115; x=1709090915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FLaKcAirk3CTYgyOfE+aKJ+UIKz3IbgFgbToFNpwyg=;
        b=wrVBVXSU+o/6Nm79wvM0Tq8YR4uCYbJUO6N9S3TjNbZf37nm4svTDCXfYd1Qs0Cqzg
         pFNlo+w9+p9AEEHyrTRtZfwabHWsn8oJMJoTIl/ltfQ8yQjELtb8k+xcm3ZB20Ck7QOT
         PxO/fcBLMgsGBO9b9CTCildJKSTjWRZ9bZbmk7POxkvj96IajX1qrLTgMf/5/XmGtBS4
         TVSOraelnAHt6Cl9P1XXDiOQ0tmsv10nYIY2SM6bF37j2vUWDSVPr7fQiGYX2mPJ5uIu
         fMIzYk7EAqN2zCFMsCQ9yWfZLYmLbAPn0V81UTofUXpo9hZLsfAisF45wMNFmb40rb2B
         in7w==
X-Forwarded-Encrypted: i=1; AJvYcCXoUXvHfe3rx4H6EVszVS2A5DUHMCExmeV5Au3J0sBIKkGjPQ/es7C3LUSWEu6KQvI6W0nQVMINPSzKP5jy3lUMz7osFg5EB/H//dblt4yE649A26UI/Q0OcGuSQlUDJA==
X-Gm-Message-State: AOJu0YzFJmDyplEwHiLUKQolHw3Wd9D3OswK4VggNGcb1iT3GXJaRTBF
	fTVkfpGXdREB++EXPpFfgVlTNQtzBm0fv3aWvST+FbnnVntybAGy
X-Google-Smtp-Source: AGHT+IG+5kUDxEEdP+IqiK5SZK+gSM7uxbwCRRCoyT5fAJOZNRoAtH8MrNNdmRsQBrctGqSWy5fX0Q==
X-Received: by 2002:a05:6a20:d498:b0:1a0:7e2f:ad44 with SMTP id im24-20020a056a20d49800b001a07e2fad44mr19469432pzb.31.1708486114991;
        Tue, 20 Feb 2024 19:28:34 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:34 -0800 (PST)
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
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 2/8] arch-run: Clean up initrd cleanup
Date: Wed, 21 Feb 2024 13:27:51 +1000
Message-ID: <20240221032757.454524-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85c..c1dd67abe 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+	fi
+	unset KVM_UNIT_TESTS_ENV_OLD
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0


