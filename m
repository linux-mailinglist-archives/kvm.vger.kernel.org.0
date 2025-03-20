Return-Path: <kvm+bounces-41607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FE8A6B0CC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B2DE4A36DE
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DCC22AE59;
	Thu, 20 Mar 2025 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L7X7/3Rf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C27E228CB8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509821; cv=none; b=OxPm0Lufdoj8gjI7yRrwvsVpDaEer45CFNPlInU8dIdNCL0/TanyifTFD6R8DbPPwIrJJqFggQMNOGUJH7bcdk67WlCf5c1cqWEMwhGOp49qeYnrK+4LXUWVNYVGpqE4Mntyl0Dh/tQOkgUfjNEPGZPsICw9EadIwfuwTE+Ttcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509821; c=relaxed/simple;
	bh=Uf/zIvNhV8OqPPr6MhntwsPHqyZMiLzpAQILN5oCQQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sdxhmLnDZxazKdfUQGyXFLOqmMDTK6QI4lMhECK9hdEpNutvuqBzAB+/O7GRya2XTAtL5HMtQuGxQVhm9DQQGs5fFfTVTBUfQj9lL6bp7n17doDIOCEuTeNgPcoEJKCKroDXdkZpwiXlLLyumxwyV57PPPjaCMduUdKG9TcpcGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L7X7/3Rf; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-226185948ffso26872225ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509818; x=1743114618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HMVcutgyuXMGRqprNJQ4jtFGs2OPO1Jy4KbSNXvsaY=;
        b=L7X7/3Rf8AtslzMuskF5xn9FVHlxK0oUZTsZzfPshcmROabJrwaGeteCscVkhRd41a
         vc2VUCRCUfE/OEsZO0EHTds/xlE7wa6aLmUXCq2Il5KtvOj/DVTg3Be2/5FZlh4vHVit
         zO7SDNmYaQJ83EfD8bXb5BJZZfCXefu75mC8x5V0yF0DNt6bObNpL+8aDzLKRHtHAvPD
         gsLu0//gNuUeYVzuabTWvT7k0GY7S3+hC/smiyx5+Op2v76v70ylMOpj2CJ3C8avzhJ9
         NnB365sN8kYDrHvYPwWNh2RGbMpHFhd9vvEzeSS1riCdJj3TyRn992egGP083CkPonc+
         B4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509818; x=1743114618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6HMVcutgyuXMGRqprNJQ4jtFGs2OPO1Jy4KbSNXvsaY=;
        b=FTRMlSlP8cte/0HpCtnQeUfKbKKoAsRTHUgfUn6fsgTj1cUN2yp8C4BuYWb1jQ8h3V
         EQpKxuYMu6R7WpUqWPrKmB30qy3uU/pFIO603/pHlhX6AJj+nsPY16uJKFP7sPi7zsWl
         mYczzx2OTqtx/OWbIAJnWsvpB3LUe6DCccMZ8nMHQw/FAigNnFhgQrtUpGX+PB69smy1
         PiJlhLsOyd0oawaF0sFalp0eQoKjYdAUAlZQGX8Rxn0A71AFEjPJDkzllBJQ4SCp4m1V
         MkPU9keNIe0ZERfGeXdUy/vEPEhcjIEkA0ZWfjh9x6fKzrpllytY1SxHxDnzQOOa5RK2
         iBUQ==
X-Gm-Message-State: AOJu0Yy2LiNmTzFV39UaBRkrtYSK1Ek+07AOz4VGaAkskDfRoF2MSdD3
	VTQlbfJPTHWurqQCoPT+BTae9jQXl3Az/3cGS24twnRD+9+g7wC+ugk6qC0lGRU=
X-Gm-Gg: ASbGnctGhK2l752dwHk8dKmrfTeGurXqA7N73Cy+2tN/7ye3NFIhGhrh3Eiwsvu+z/2
	tiRcgssxZVxF4a+UnGUP5Oe8s7NQ7xWiUKASMSxnLz35veRM2FpVPmilcdL421qUHvKXxcRk/O+
	coDaV8ybtX63WMnteVNA9EN9ZixtttBU/vDzMsSrS5eXKZM+rbcVquuxxU8e/gcKG3jxKO0XmNc
	CX+w7Va4l1tsho2kfICVp35Pzjh84PuV91Jq9kkSVaEx3JTfuCk7xv4D6vFdnXIV5blP3oBT6Il
	aw2S+l+9JkKt9lyEQ2YHsC1kLCNbTNyriYFzw7SlPi1k
X-Google-Smtp-Source: AGHT+IG6+hbG0wVW/t6Amtifybw7dZc7IOQNafgewk+tDppyXQ5h9nASpMX/jqywf9Wi/q7Dg4LTxQ==
X-Received: by 2002:a17:902:fc4b:b0:226:38ff:1d6a with SMTP id d9443c01a7336-22780c68a1amr17451725ad.7.1742509817869;
        Thu, 20 Mar 2025 15:30:17 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 04/30] include/exec/cpu-all: move compile time check for CPUArchState to cpu-target.c
Date: Thu, 20 Mar 2025 15:29:36 -0700
Message-Id: <20250320223002.2915728-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 4 ----
 cpu-target.c           | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 74017a5ce7c..b1067259e6b 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -34,8 +34,4 @@
 
 #include "cpu.h"
 
-/* Validate correct placement of CPUArchState. */
-QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
-QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
-
 #endif /* CPU_ALL_H */
diff --git a/cpu-target.c b/cpu-target.c
index 519b0f89005..587f24b34e5 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -29,6 +29,10 @@
 #include "accel/accel-cpu-target.h"
 #include "trace/trace-root.h"
 
+/* Validate correct placement of CPUArchState. */
+QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
+QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
+
 char *cpu_model_from_type(const char *typename)
 {
     const char *suffix = "-" CPU_RESOLVING_TYPE;
-- 
2.39.5


