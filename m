Return-Path: <kvm+bounces-40220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5816A542EE
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C6E87A76C4
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F9771C84B8;
	Thu,  6 Mar 2025 06:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tLfQiFV0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445101A727D
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243293; cv=none; b=NNZfwidYG9ds54rB90Xt60R5Afbwbca6j7lcLdk/6qE0YEUfPnYNrTvBNTIJYu9SX1c8nD8ROWVXdfAdH0/J6+jIyKlQq4XBS59BbMzlFt4Q76ilqwBLY2ONN1fntCnhQ6FJDIfDy3A6lNBn2s6mLdk90/5VOYphG5gGBq34Vj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243293; c=relaxed/simple;
	bh=EF3nJZPeIRU0ZlDv1uOs9eGWyEsrIGrAWMWZE3GcAro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cJQ5Szaa/NSu3CcrB2ahLZY6po2M8asYHM5IC5gSN5Fqq6hvSLtzDO2I+zvC4YqRyi+8XP8avqXSH364jNjcwpSfw7VhZxaWc2R6ul+YbKZv3NXQEeS8jt/S2X77H5nGHGBgAhTGhms6K4KLfJYg9datSf1u3SmvZDErYjOt2no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tLfQiFV0; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223378e2b0dso3622555ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243291; x=1741848091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnhPiWQ46KHFDBAFB5FNYntK+UjbBUc/XRUUAjHcGsQ=;
        b=tLfQiFV0QLjD68J9rNYop+r1D6Fruyj0racY2a2iXlJ9qiM794Us3KWXfSquS59tma
         smsKyLKI35GZEhaDUy2sADBoWu4908ne8anBSGIxeJjQQ0tuQvuPdKvFJDUEMRXpeiZp
         IYtePCfQf7HFXDJhPHFyM/0fs9pomwbUYpIdqZ4A52WOiaugr8tzSrml/3YQteuGhFpb
         hB/P4syBXdT14ghrm9Tb3b/oYrlVX7NaevVDhCFcWpCwwmwHPi1fDTziAMq9yX/yx6Sj
         liMl+2RlNIc3oHSnr0GZArH+DhhLrsgCBhl//bcOuIArut8bpiTXY+SN8ERVlPcw3x/3
         fRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243291; x=1741848091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnhPiWQ46KHFDBAFB5FNYntK+UjbBUc/XRUUAjHcGsQ=;
        b=KfVWiggffEW0Xwfpyl2lcS5sZHuaGMLUDvY4D/QYQcClGUSavwhnJqa3oGNYChpzNw
         8htsLh7BrPVt9FDqojQQEnZtz1C+EvASukb8YLs3zhN/Sn0IcxsaH9+GzYWCvSdkcxZ8
         YfuLccDNRpHsVGp7b9VzdvGV+PufXejedZ7YEKMcsi5bbr1dm8YUlm9ivzYF97i9k0Te
         GijiTHxt5FRqSUlRakbVZ3hRXtYT4nVNjolpQrbZPqCOZ7sckgRWuY29+LFd3MbVhXXJ
         1Gb138IRqIYKY+3JCQSTsnXq5IIoQ44i/+JlMguIbYEffxlpX5Wzy0ciqNeVl1Q4j2uS
         e/gg==
X-Gm-Message-State: AOJu0YwUtP+C8EVHZuMvksokTRGXV24Xh+0Bb6towOxAUALY3qXq99kx
	PKGMiecZ6kCIHCc1M95Fpnlmlhn4kJWj9qgUX9IqHpIbZTM9zdSMNypRZVC+jdQ=
X-Gm-Gg: ASbGncvP0j4qmjpggOaYkYyDctxeVThB/UuXRoabJztFm9dmcOF3ixDU9O9v82+q9/n
	Rteisl1BpEpwwfbkTTusMo+bmNMQo7cs1lTK5121GbHTh1GIaicLdxRguAeIOWnRZgR4NhuS0Yb
	nrQXyQ8FMY51BXsXq/8IJJmrtz93Vjtpknh+aKGBX2Ei2ZZtzMZXcAc/IJeCpXE3b6Qgl/ygF39
	kOwJaIXH+CMTPFUAEmxSl4EEPUvmNHF1r7MyVyAs7R7NDmBX1hw6AdJqpIHhB2aSw5hjer6hLaX
	9xHBKRMQ5dM+KvioLAyo/CwbOt5Es64TOY+s2nT8O5sS
X-Google-Smtp-Source: AGHT+IEq64VAzi+4aQJPN7hRWSuCMxEBlLQ6WpVavzM/G3w68jHWfj5WK0DeS8abR956/Zd3+Yllmw==
X-Received: by 2002:a17:903:19eb:b0:215:b1a3:4701 with SMTP id d9443c01a7336-223f1cd9503mr98970205ad.13.1741243291712;
        Wed, 05 Mar 2025 22:41:31 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:31 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 6/7] hw/hyperv/balloon: common balloon compilation units
Date: Wed,  5 Mar 2025 22:41:17 -0800
Message-Id: <20250306064118.3879213-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
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


