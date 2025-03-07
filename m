Return-Path: <kvm+bounces-40394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A08E6A57125
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 140CF1894F2B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EEB2517A6;
	Fri,  7 Mar 2025 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TCIwDFhA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8161250BFB
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374618; cv=none; b=cXXwNlGAYA7U0YmDrOXFdDrPul7dqNpNp1aZe7bBHzONV+xeI/4Gej9G4+BjRUrwN6jieuRwYYIgpGkYo85MN9BrMty5G3j9E04DUkc3wgaih8p25ZAlu9ZISEaOnEbldu2evveapboROx0tkMi64IvHsZABGOS5qflhDq1/pAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374618; c=relaxed/simple;
	bh=EF3nJZPeIRU0ZlDv1uOs9eGWyEsrIGrAWMWZE3GcAro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hr3sqGVYAmSpHJrDQL0UEwa9RFs8aaMpNVy7FSN8PAKXbFb9lVe3XqyYwSp3Bo0PXcs70QpyUifKpHWord+AH2HLfm2kXcbv9zPVqWg2xOZPslQflOFPDw/kyifl2PzSvTuQ/KneQlzyeiBfzUQOUX4CexEmq3fNjSWIMw51Fn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TCIwDFhA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22409077c06so15222225ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374616; x=1741979416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnhPiWQ46KHFDBAFB5FNYntK+UjbBUc/XRUUAjHcGsQ=;
        b=TCIwDFhAQ8bXDjcJKVyBdUO/5AA+9Sermqg6uw5ftEFpacWmr8+MWiVQXOqEPM/um1
         vdGr1NUhGGhmJT6MGuiemTKSymCnLZAwSS7gAllYzM/LJ/mAz+fOxt0rm1K+x4fLpU7A
         fnBOW+gFRk1gdjoi0zMY2H1sUnDP+B8QvK3BrK1Tx6qbcWGnNJCU5FFXWweltii8gJ+B
         UPYgpHWcwsO7Zf6nwcgjddHkVpBzNRFro7RyiLdoE1Jv5AUYeCuLHUnlHVHhCQ9/ssu/
         VSZg7hVRQp3Meq8ypndQTL6Wp34Oj4bwkQDVvdDCoJFojqbF1hqwIoq1X8ff4MkuVUBR
         Ng7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374616; x=1741979416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnhPiWQ46KHFDBAFB5FNYntK+UjbBUc/XRUUAjHcGsQ=;
        b=so/JKxEElkxDGr+kr+ZfOE+4okv6tn0WGPvrvatyOAfRc/Ru3GQlIVtp7WcunttWDw
         pHNcTRrldA09msIXaom3++6uS1Rxa97qq284f8rnrIPfS0IeCz7wx92gITPaUH4+Y+9X
         m9WZWB0ueBPL2KagIvh/NcRN4T97f/mvSGArxqlSJ+v7GgTBTbbucD/ldGvE9sIsYpHC
         P4CAI/ZwZ6MkXj2y57/65NVy9U0gueBTGwFrK8K65rMOsTsoRJ0xrGVhDRfuSlP3kKIN
         Hx1cmiuviVpnhEIcjxCQNcpU/egdd8FmAkfvlMp9NnmHe0dvYSsY6BdTduK5kWeC3x0V
         qKKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFWX4vpTQtLlui4mAXTcUSM1VW2dRk3jen+rY0eSGLiHvHp15INDqR60q7SzzTHLkvL7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcT4ePyCEF7V9I3CdYSeKZMps2I2gfk1HJWLMD+zXG2sbqQz4c
	yjc/lWldcIKCs3SJI5Hcn/NEOAxZSnEhoDvNWg0qrooHZjjyzny+X9zz7jfCczk=
X-Gm-Gg: ASbGncvBVjjjDRFnNhqq4KXLI7iMpJmgtH8I9oKbrPbqQKFn1UVOv6VnGkOzMMImdT3
	UipOV3uBc1UK9jneaP7tqlikcU4FOCIuZWJQFoedBOij3f+utT9oljQz+7hSQRm6rGouTC0YYeg
	HRetWhXwlzS+RKBAcETvhkf6k5WglzI+Y3VGK3qGneeoASxrgBcdYyeaObjuXOEyzukQwm5PLiy
	O4RAvlcCJ6dzyU9fC5jbcAUajKE+Sob9cqq/u7kp9P26fv2/jBAdQPzYmraZKSiAlrN8zzU4Kkw
	w2z7euxA76Dt7FiusXddyNbvcwsDOFnPmY3si7CUY5/I
X-Google-Smtp-Source: AGHT+IEGvvA50bGtGnRgvOVX3N9VYhhII+Do9EFRBDHvk9BNSJg0ZhWlPN1xhGl54jgDafvpI4oJEA==
X-Received: by 2002:a17:903:40cb:b0:223:2aab:4626 with SMTP id d9443c01a7336-22428880264mr75741745ad.11.1741374616138;
        Fri, 07 Mar 2025 11:10:16 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:15 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 6/7] hw/hyperv/balloon: common balloon compilation units
Date: Fri,  7 Mar 2025 11:10:02 -0800
Message-Id: <20250307191003.248950-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index a9f2045a9af..5acd709bdd5 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,5 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


