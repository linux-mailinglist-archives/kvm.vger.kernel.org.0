Return-Path: <kvm+bounces-22582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F392B9407A3
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 07:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264941C21526
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 05:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458A81662F8;
	Tue, 30 Jul 2024 05:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCO5AqJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C833D5
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 05:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722317546; cv=none; b=NxUPyhyvPjMj97Voqt9BJn8sEvGoOaYQg6sO8SJD10vh/EjPllTtt2jS3ZwY9YfdYS+8QdrC9K3rRUbpL741CRcBqPw4YqAQBK6aQ/MQ3aMnMMfSgVxg/5kxjrqI5UT7zEhA4QiFkQsJ6Gx2JdcKN7tG/s6mtuXOI3mo8+SQAeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722317546; c=relaxed/simple;
	bh=H3f/fZr6eWvMdQc/Xoqd2ZMCl8+HT+lIfOYh7RDpL5E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h6xYYmiAlj7oG32p7fdM5BGliS9hCFFqp1To5vSCiBaoj3CXeXezSVzRSpeJPgIjwA/bpyJcl5rRIdIKis8Es2Nv2vdM9yOl+afFmxqJbEtu6sGJ1LO9NOvs+hPQyJIoz2L0qu1pnVnnmtXIhN2uFhFZAAyeK9d5pa7K0jf1GrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCO5AqJD; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70d357040dbso3154047b3a.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 22:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722317543; x=1722922343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TEGO2zngG9zin3F/xHIMWUx+KFuRRiyMD15zsVav2vI=;
        b=UCO5AqJDG+wmbPw05Fb0jM3299KpU9XZE8XpHxWsV7/TWrRTRNNn7qouY/RjrANQCn
         ZyUpgGaTaCp6FGy3UFYesL71pkwXDXm/nnsv+QaNmItbmTgKHcMIQRjjH4YWTholOW/M
         njLty5Rs/FK246IkU1r9IVN9VENT4us+/x3hlL2aUKbRV6MfagPXON6oxITuGbWlzais
         EJQ2lKq1k7czo53wDzALU3gLxTTuWPIC+kwKgDkYihJzhujxQa56zzkDmh8NToL+PoW9
         U6D/aJa5N0YUXeViVxWPR72043XODJcUJ6+EJiZBJOHZYA5FJ3uMx3QC3uHuYwgeZf2O
         pF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722317543; x=1722922343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TEGO2zngG9zin3F/xHIMWUx+KFuRRiyMD15zsVav2vI=;
        b=L9HZ44QWUWIH1anE0V+hWYPfZpG1whaprjCLXUWfMZ8RMehcnOSOHookb8pY2hX6jf
         R5TTEioNgrMpFZivEiGM0KRJPp6UTGaA+jMyip9CztFbWZIV+QCzU8eDPEIp0O1kklm/
         faNqhEK6TwffV7Y40mxjx+tn22iy9ulNklkdHqatPUXi8eLEK5MZS8+PMxS0K1JBTkxZ
         qqBgWO42RES/hRPBWmoShzFXNjBG3/LXKMIfdksoyjGyUN8mWMw/7KVj5wey7FcyyOMZ
         HpSlKydNwzAGFBi0rWbo2ymlCGBS8BLy29airQUnFsnznih3cjpPJNauseJPLwPJGfJv
         g8/Q==
X-Gm-Message-State: AOJu0YzIgJXA34LFARq6MTnT+JaLJ0cddxinQaX+R4zWEQk9AolLP0bV
	3CmHzWlm933HletkicDfV2l6pYVg+OCw1WyNMxG+TA8FhKSXbYcM
X-Google-Smtp-Source: AGHT+IElJZvuWPkCtd40btdYB0kwyNDD3nPjgLmQu/Jbd1tvXCs2AqHTQVUz1nOIfnKbMjjNptCUhg==
X-Received: by 2002:aa7:88c6:0:b0:70b:a46:7db7 with SMTP id d2e1a72fcca58-70ecea32df1mr7915124b3a.16.1722317543329;
        Mon, 29 Jul 2024 22:32:23 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8af074sm7665696b3a.218.2024.07.29.22.32.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jul 2024 22:32:22 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  KVM: x86/mmu: Conditionally call kvm_zap_obsolete_pages
Date: Tue, 30 Jul 2024 13:32:15 +0800
Message-Id: <20240730053215.33768-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

When tdp_mmu is enabled, invalid root calls kvm_tdp_mmu_zap_invalidated_roots
to implement it, and kvm_zap_obsolete_pages is not used.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..e91586c2ef87 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6447,7 +6447,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
-	kvm_zap_obsolete_pages(kvm);
+	if (!tdp_mmu_enabled)
+		kvm_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
 
-- 
2.27.0


