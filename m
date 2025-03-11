Return-Path: <kvm+bounces-40796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB2BBA5D02C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1885416BE3C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6BF264F99;
	Tue, 11 Mar 2025 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qXSR1OUZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C7F264A9C
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723103; cv=none; b=L/Aywcx472v5nIo4xjGJc9pWk2VP/la1siLdWW3ZF+NzZ+voULX8KBdjt3UrllI99Gso79DHig5L9w8iS7G2mxS42kG8bvjZGwzkMgSE31b65wcFqyAzt16tzF+XwgUR87M8AsLtiFeWmSb8ow9NyxVr0d5YpXKpui+SVFeU8KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723103; c=relaxed/simple;
	bh=gsSv2px28tuWsGYFfY5TQSDt49mfWpFIGYwmtj+tgSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aWexIFUIw8NOSwjV+EiJ37BQvB2eBNHuq03rK+7NmED4PjJtsMY55mt5nDYHjWSiix+PHSN23Rorq1v0Y+E/aHWgl/k2JwAKCh6sP1rQ4CCMWbIaIzkK9yjydGWayfi4KSCbEQxVRE6pJdDiiHqwfBl+SlYyatw+j+FjItHyXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qXSR1OUZ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22580c9ee0aso38784895ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723101; x=1742327901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8l5XLcA1+OCzVWAzWmOGo6RbdXUAYo+RpTNM4YWpKg=;
        b=qXSR1OUZ/ozIqDe0arlp/OcIpL8uq0XoUhrYxnuxyeYSYskvhpJWT9mE0UI1Mn3ZRq
         TyZ31PZ+eoBCc6dfyCyyADw0DV//jo/ThpKX0bXliPWVQIEnMm0MpYyLPi38Zk5nwaz7
         gAE54/MCwbBqsGWLwUPRtFlepqiiCPLdUBhehOA+ZHdDGTm/uDc4ZntbjJdoegVG3lgl
         t4L+dE2LoDajXNkR52uKvfxkI1yz0XF1yMvSlK8P8L+dZuqH9E4O87BX9vppt9dR9HMm
         tqGWpaTTiFN/FSoHOoM0/YR5QRp1APtuXc4FmXJOnf8nOHgVbRjW7+1Vx9qdhh/hGEK2
         yrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723101; x=1742327901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s8l5XLcA1+OCzVWAzWmOGo6RbdXUAYo+RpTNM4YWpKg=;
        b=R2xd8lb5kHQWtTUWTm4gz3nBKqsQ1X5oZWeyyiuvjJDS8ir7QlTnpST1NqpR/7Z9mF
         Eumn0KtwWnvOEee0LCSy8OELYGObBPxsjsGab9YN7NkVgnfp/eOALOSEfDrb2sQzLI6t
         6i21vuMXc1XDQZyxnsD2UMZqO3z4wPh6qvtddMimARoRaojX1M6xNQWyoZYImeSJdaqF
         i5hnmt2wfA/OoaMWec8Wb73cpNvh/TrDwOP6gy3vTyLsh2KWlSJoj4XK1mX94G+q6GyA
         6Ek+YdKOmymxbXFkl073W6dKs5Pk+kAoRLw+8l8M12i3jtk/BngXELXbkdHiploL5ExH
         V1NA==
X-Forwarded-Encrypted: i=1; AJvYcCXpvJZVzPSF713LJ9Tru1fiGBSJGkojdqD9UFJUtjFI5bCCHFupTWuW7rJ0E4KC7MotJm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGkQboUkMI1A4szx6tXxV4BgWdMlESQQgHe7aNMjquo16DQEz2
	GcUWKtD9WpBc9wgspxwFDQ4xOF5dLNy7YPJWVd/nF58pDNvrlhtpEGHuFqIzENM=
X-Gm-Gg: ASbGncsp12bp9yqpsgIZqukQxuNceghO5qV+P/S3L+EHcKXWdS2LgbjMs2fpyG0Ejsj
	cVfVaDyatKwhILN4m7eOqDn5vC4nTo1zNhV8/IfZXKr0+ucQ3/rzgxPtXVdA2tAI/r3GhP0CiYW
	MO43D+biVagQ8ZxVstlWu4tDhDlYASaFEjn//Zs0q9lDn8DcHrMe/RP7Tis2v04W4D/WrD57Dw/
	6iljIR38U7FkR3m1asvQ0arAr3FMIdqqANiiwJFejigW7QpHTY1ylSFns4rAq1YXUGrnPufq7WT
	+L5GDwPa7BDN+LLDJlQPRP+Px8usd+74yc1r9PfEIP3W
X-Google-Smtp-Source: AGHT+IEgYvc9dMvCeCMS1wOBfk7GI8sssnnWj2guiDlIPD98ekjEveZX8r3rPhR4gVsvHIzZwJ8+qw==
X-Received: by 2002:a17:903:1a05:b0:224:1294:1d26 with SMTP id d9443c01a7336-2242888bf0fmr253744785ad.13.1741723100980;
        Tue, 11 Mar 2025 12:58:20 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 09/17] exec/ram_addr: remove dependency on cpu.h
Date: Tue, 11 Mar 2025 12:57:55 -0700
Message-Id: <20250311195803.4115788-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed so compilation units including it can be common.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/ram_addr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 3d8df4edf15..7c011fadd11 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -20,13 +20,14 @@
 #define RAM_ADDR_H
 
 #ifndef CONFIG_USER_ONLY
-#include "cpu.h"
 #include "system/xen.h"
 #include "system/tcg.h"
 #include "exec/cputlb.h"
 #include "exec/ramlist.h"
 #include "exec/ramblock.h"
 #include "exec/exec-all.h"
+#include "exec/memory.h"
+#include "exec/target_page.h"
 #include "qemu/rcu.h"
 
 #include "exec/hwaddr.h"
-- 
2.39.5


