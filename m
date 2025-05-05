Return-Path: <kvm+bounces-45515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F44AAAD61
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B6A316EDDF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90133B40BE;
	Mon,  5 May 2025 23:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dHrPNaBR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291B33B3598
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487256; cv=none; b=T1wFRfu25tlnh8SyHnkWfu9N/vtp9wcKZWNbqRbH6ZP3OdRSD09Kwd6NLIa6ARsJ4PR99AK4hkXghFZ+7WHMi7s03WMTBghQ/lDRdKIuIQ9Ir5Iw27ZYIyj+FNEUKmt53tYvkf06WE7ObQTh6HW6el7O9SCIFSUEJIVF5xzqbjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487256; c=relaxed/simple;
	bh=jmUdrboFzyga4mrTnDHClA3zNyFy9mK8dkNEdQa4KPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVf4sHQy9GA7cUA/aSvwXBMuboMwFyJHfHEjUIkgjF/36i8rviz+Q6tjVwhbLaNLVTlET/QbB3B+krgyrtg5yRL4I6N5+kV5A6lZMnvll8qsEjSX9corercys5UXXKqZQd4hPJZCTdty1hX7HCuIIUTfKIy5nbyVRK8LvOJL880=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dHrPNaBR; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22d95f0dda4so72238205ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487252; x=1747092052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=dHrPNaBRcgAwl/LoEv+V79E4KYdOgKSTBZ7/GTBAPXmowBzuUrCsg4WpE0QJ7jZKWG
         XqPjGfL80CiNfjV+88hmp/QeLnfp4MpE/UCfkiBBRJO5Zkz7zB2vdGJjdNhTf9XrFopf
         CYaT1cqWrHaqrNJjJUl9sJ0ptg6IGv3FzgKQI+QuYkCSPHM25hgICUfyiVU+AKfPSuY8
         yFFVsK7f115mn7vcjcN17MzwqN9nJyBcotveQdu7Om/MT0b/B9765zb7DfvGeRd75BB9
         aEm5GwcKW6CYzaaFjMuQkKxe10+Nm0mihGUJAgbgdg+KIXQw1nhnS9ixRWc8lYodoH5d
         4OOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487252; x=1747092052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=Lnx9pIeDUgG+NUR4yGldrKJ2V24MqX3UeysKnim9GRFuJOVciaFuXPy0KHXd5JyuJ8
         QtvStS32FSoAaBNpWFBkMmOswZz/TSNJRffFSJy9MDZ49FvkcZ+Uu2IK5Hfo/ssUi1Mu
         31GkWKML/MJAG69OAJ+1xyd9T0lrrpy1UeKUTgwW+9bZlHjsCZVqaaWssn+PcC4WkZui
         aN1NsXMrmv0RHY7CVmBtb3balyD1qGaiJmeJQ3LnpYLs0nPxkhsbPWVQwBiA2qJwMERL
         Ibq6IayqrIQ1008kSj/nVIs0a3fCBfNsINp0WEBVS8XWC8V+wQp4bCh40DRvpUqgjqsC
         MT4g==
X-Forwarded-Encrypted: i=1; AJvYcCWGOX98k2uU4p+KC3ecUtB+b6To/J0ERLnAOWbXBNW7t3OYIj8/HzS56Yk+lzUlNb3FEGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQQNxAenfkvx5U+AM6+a08rOU28eyQhJz3+KCGIBm5K/6IISzS
	pHfs79R+GlhrWOcRpTd3+oJBs8cJSWDf0g55ecwfZXEZuDNCLfCJDMEkElUrEpU=
X-Gm-Gg: ASbGncuS+k9YyDTxokGxZ0HG1HskHkbbOutBPLcK9cFWm2+v7X2K+h/+VZvKQGDjK5x
	7MfeFYamwp6qnBbzwLI+gVe92gLT16L+y3TxqTWCW3302gpuRMdgMh7ScqrfqZhHvuNxe1XSGDE
	stUxGHJqY/W3dDmE9gQUxfyTT6bzmh4aYSTJmJlv+ggHLGRSp3xON4PRHChsKCtez3ymtwYulIs
	lal0wpMNogquxpXQm4gw6XulQQ87dD2jTcy7Q64/8gMc+A16gQrkt0l1k3wMIPc8d/Gkb9Rxak3
	lMRbPM5xpvrPYG6kByoCfkehAdtWi2Wns9lpVc/t
X-Google-Smtp-Source: AGHT+IFKCrJfIDo/31BgGwDwgpaARmni7MMqsmZbFLEssmnSeYuJ1cHa2Ln0JoRRYGFqfKT1x0RIAQ==
X-Received: by 2002:a17:903:1ce:b0:220:faa2:c911 with SMTP id d9443c01a7336-22e35fdf665mr13176195ad.14.1746487252440;
        Mon, 05 May 2025 16:20:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 36/50] target/arm/machine: reduce migration include to avoid target specific definitions
Date: Mon,  5 May 2025 16:20:01 -0700
Message-ID: <20250505232015.130990-37-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index 978249fb71b..f7956898fa1 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -6,7 +6,8 @@
 #include "kvm_arm.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "migration/cpu.h"
+#include "migration/qemu-file-types.h"
+#include "migration/vmstate.h"
 #include "target/arm/gtimer.h"
 
 static bool vfp_needed(void *opaque)
-- 
2.47.2


