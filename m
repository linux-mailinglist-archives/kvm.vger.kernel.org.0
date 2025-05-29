Return-Path: <kvm+bounces-48008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9A0DAC839F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C0E94A2BAB
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3E6230BE0;
	Thu, 29 May 2025 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aDc8KHn0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6720E00A
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748554502; cv=none; b=eNkJfVXWk05CyLVlaBTF8il7FNL6qE6DWu6AP3jOjc05oUxZNHjBhXp8pC4k9VQLbIyQ2j3B9+Ytvd8jmEnpdlxRZxFCVW6585FgmvQw1MAz+nR8fkGFFB3veJziymHpzPW1OPUnL6gF3QVns1caXXsY0udOQJi7XNrfSdlJ5wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748554502; c=relaxed/simple;
	bh=C4JaJOE/8OsDbMwl/dkN7bqgvn0uYwV/7qBaUPkkhbk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qJurklatF8jrh6JqWuj3D7V3Vlu0s/I8eDPwuzuNsNLjo3RcaL1uRV4GJPeJXu/JhEqnwzvysJlB2t4VJ2m/Ufg3rHypg7uljVLsYj9LNb/H7x/QyKTGtCpkmsVvzOh+z1Cuy8gQKYyI6GPM9G5ypySJOrBAZJL7YMJNUmQS0eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aDc8KHn0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74089884644so1211781b3a.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748554500; x=1749159300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/JE/cZQ5HDpmHH/RSFCmBCsrCJ3w/Bp4gRnxXkHi4bQ=;
        b=aDc8KHn0zyVoj1fU0gxGku16yWxTS+ruiIKKnEijAeubDw0FP0pv6SYZ0bbFn+ZW48
         Xtq6TshGUmDbZvXHTIhFqYg9OrBV0zJa+S4+Ae7wX9oj6vz9gAqz3737ucgVdDRMeirQ
         zYiEYiytUm/9QBj6ANcGdDP+Eqgh2q2Xl/LivrO3uNxUg1ryVdFZPh38JNnTqdZ5xHzb
         xtoaZzzTjzYywP3Ldyhad0G4RJ2ApS1WPAEC9JEGQ7el/XtmJw6vvUsMumog7Ihg6Ihe
         8Il47tVeVyQvHSDRbHVFGMXmwT76E9fJJERTnyVPHf8zVz7wTi6KawIv+HlkeYai1owt
         ooAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748554500; x=1749159300;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JE/cZQ5HDpmHH/RSFCmBCsrCJ3w/Bp4gRnxXkHi4bQ=;
        b=bx/FxrbigJJHIlgFfZy0rgFqVXf110+AQEhi1qGqHZKrPJKUvZ/xsbVd5rt3pEW0G8
         BfK4l3vBodJksgTPP/nifvi6EvnaECKA2FyWQik2EvlYEloh6/1rLA1xhTtAbFA4q6tG
         sqReTbvUxUzToUSkhzXJVgAaWYxrO5M9iBEGNCtmYY9zSzErJKF/o4KCE5y1ErSkcqb3
         kzXlaaChMlqC7Lg3vmUZ6JygwpJ1BuK122Je1dMhS4Pgb9nEANIshu0hVQ4EdIBoOOD/
         eGYAMA6R9DnGXTluyLRY2V3EE4oa/5kgGKtq+64LxOmEk2tlxwR1Yv+SFGTzCa9jnTpm
         +iuA==
X-Gm-Message-State: AOJu0YwNQb1lp4Xf/WpPreJSibTxQ8ZL6Nbm9CVDL9ya5YTIWferLYkc
	70zJo/wbsSYhroQb36iYUucoIvWzKAHnkg+TI5YnhYf/id0hprYzHJaVh9IbFdUkm0XRkMLBwt3
	g5nmiUA==
X-Google-Smtp-Source: AGHT+IH543ybVFC1zh97liri0TRI9Nq0g+ftNOSUyGkz18999VN1YVmsu+x8tBOS1/c66iEGFCQKIjQTK4w=
X-Received: from pfcj3.prod.google.com ([2002:a05:6a00:1743:b0:746:301b:10ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8886:0:b0:746:2591:e531
 with SMTP id d2e1a72fcca58-747bd983ed9mr1314693b3a.12.1748554500027; Thu, 29
 May 2025 14:35:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 14:34:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529213458.3796184-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/run: Specify "-vnc none" for QEMU if and
 only if QEMU supports VNC
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly disable VNC when running QEMU x86 if and only if QEMU actually
supports creating a VNC server, as QEMU will somewhat ironically complain
about "-vnc none" being an unknown option if QEMU was built without
support for VNC.

Fixes: 0b8c3946 ("x86: cmpxchg8b: new 32-bit only testcase")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/run | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/x86/run b/x86/run
index a3d3e7db..bfdf365b 100755
--- a/x86/run
+++ b/x86/run
@@ -36,7 +36,15 @@ else
 	pc_testdev="-device testdev,chardev=testlog -chardev file,id=testlog,path=msr.out"
 fi
 
-command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
+if
+	${qemu} -vnc '?' 2>&1 | grep -F "vnc options" > /dev/null;
+then
+	vnc_none="-vnc none"
+else
+	vnc_none=""
+fi
+
+command="${qemu} --no-reboot -nodefaults $pc_testdev $vnc_none -serial stdio $pci_testdev"
 command+=" -machine accel=$ACCEL$ACCEL_PROPS"
 if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"

base-commit: 08db0f5cfbca16b36f200b7bc54a78fa4941bcce
-- 
2.49.0.1204.g71687c7c1d-goog


