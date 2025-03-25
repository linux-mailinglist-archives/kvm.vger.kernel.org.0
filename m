Return-Path: <kvm+bounces-41909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3689AA6E90D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F768168340
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BF11AB6D4;
	Tue, 25 Mar 2025 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MffCb5M9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB2D1F150D
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878781; cv=none; b=F7pqaXiJxW6bjiZHDJrhpjQ06tNRD03+1LpbV9Kr7lKq/efwVtGcXw3uJGJ27vWs8E4q6hwh51AVzmJiIAFgg0q4toGPNkj8yHhfW97aKsAAaT1yEv6004ZCaFImszufMtMJklchoQuiNwL9+3mceeA44vO7uAAQc3yOodR6IDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878781; c=relaxed/simple;
	bh=k9MtLjxvHtMf1ojeSdFvdJVTcmy8hZOXMf4EdWaNOC4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qvUuhO2xvtDUrYTwSvGMjagZ7SaAb7CfPzL2mXVIZ2mpMqZju7hGxABNvlvP0KEbCqn5Ko0E20x+mF/RrePG1NqFgGePBFgQD51DjkM/AWJwaPxns7nuewGgwdZJCk6jnfJS4h/aK0kO3jb75wRp4OW3L2oYVGHaSsage0FVwJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MffCb5M9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2239c066347so115054495ad.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878780; x=1743483580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+5iQ3rOTBSPEFMTgcjt+dky/l4beaGAM9ptuF8lc/c=;
        b=MffCb5M9ZAVKA54vg2wSUiwSYTa/yOHPl19qX4JuEnLlWPxZ0c6EQ1qaAA4mGdlV9F
         K9GF2xGe5jjQUj7mPKjotCXh3nWgUQv4ORYYKLgvlUzeRY/zRxOiF3rRQkfGR3pS8R2q
         xQMzssqSh17JTnh202gfiFI4PxYdTIjZUVoPjw3u0uSPxbfhx6mf8YxdGemjHFC2ffYh
         DTS3+FJpy7SnR/UE1Im7BwHammZ/5VoiVRMf2WboqYjhHRFBEkPyVd8a1uiTH4l+dVgk
         05eIyX22BrXYvKEhsc5Dgfft0k/2WiG7O6DsPKpWDh+oaVPKilrARoPEZxu0ibC6Tc3O
         R6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878780; x=1743483580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+5iQ3rOTBSPEFMTgcjt+dky/l4beaGAM9ptuF8lc/c=;
        b=tNjC2R+oTHkMVuMOBffvVMzE3JQIVOcACm8O0GmPuwFcmkE2orbODCxINTXAZ32rb2
         5wbSkuVtHlw7OEpTdRwtHY+c6nzCRrx2S/h7tTOPSiW++7PifM07sMFsreVFDJcZ2eXr
         JQvfo+hU3nsdWu+iXfEpAjjGodUlPN3Wmy0IbxsR69khHIo7RZ+8F5WUIhwCfzmroHd3
         LeGWhjaF+Yo9SK508lsjP8+ECbEb8u1AgZZnowb3KdYZM/zYxCPWfL5TOGOkPevzSomO
         dFEAM9wjB4vYGxM2FEZyqHritJbXDTCxFKsv+sroISnEL2bTQ40vF18zWPkcwmRsZXx6
         6zCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHK7pafR67SpAMYeIZRJEc6pc1+KnQSNewyT/FWLBcBcFSs4u5n2ake5RyNiuPymws6iw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/Qwr5tMPSE9K86sErBrpq4LCcExJy+Fq1DQLtR2L4POS2K+X3
	ITZYVB+ZiQny7ez8JJJf13tw+TVhH4L1TnU+d02SE33HS+TcNK1v3dGRpLvH0Fs=
X-Gm-Gg: ASbGncsBxtwk002rIpcNLdTALrQxFsJKkPfbylIZc2OVSfUnryqgxLB/Zlsy9OxUfkY
	La5SsKKEntvKTOYmb9NXpTCp33XNE5l3JBxbqeaz02L83vLHhQWw4UANGi4/ffykX2c4dGP17Hl
	PBqPZZGin0ycQFfevuAT6yjyI4essI2OC8XdwXUOWSHKzXwgoxwR+UijCUeeN1CjCzLAwb2Lk4W
	R8/S7gvO1dh8HcTGeB/VABZcFCKuBO2IQFNotYs1uQetciwXL0nUbLg6soEgvG8zbYjOBBWEMGp
	ByRnZqXbUV0C552GOfsq1b+43CUaTFH6uVfJJGgGu2FBnSGklObAL2M=
X-Google-Smtp-Source: AGHT+IF9WVopZDKCf5Wmew5zTPELxpFqytptelvRItKxrWFJ/xOYMD7CXHGJsHww4nAXXVInApX4MA==
X-Received: by 2002:a17:90b:2647:b0:301:c5cb:7b13 with SMTP id 98e67ed59e1d1-3030fe552f1mr22108739a91.3.1742878779554;
        Mon, 24 Mar 2025 21:59:39 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:39 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 19/29] target/arm/cpu: always define kvm related registers
Date: Mon, 24 Mar 2025 21:59:04 -0700
Message-Id: <20250325045915.994760-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This does not hurt, even if they are not used.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a8a1a8faf6b..ab7412772bc 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -971,7 +971,6 @@ struct ArchCPU {
      */
     uint32_t kvm_target;
 
-#ifdef CONFIG_KVM
     /* KVM init features for this CPU */
     uint32_t kvm_init_features[7];
 
@@ -984,7 +983,6 @@ struct ArchCPU {
 
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
-#endif /* CONFIG_KVM */
 
     /* Uniprocessor system with MP extensions */
     bool mp_is_up;
-- 
2.39.5


