Return-Path: <kvm+bounces-44237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F6FA9BB41
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 229AD4616E6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B36291165;
	Thu, 24 Apr 2025 23:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NgrhgbSp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199A42918D2
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537327; cv=none; b=C50t2lPf0S/znHAW3ViPWVkBszqyFMwcbu7mahlUJWpjmZ830EBZ91zz/vPvgA3CaPahlN5Gf3Oa+yXrHvFLAkjGhT31BsSXJ59+w7gJG8yysLG8UzYhLzwCD81pebPX+RcuE7LpfnF8oUeW0D3vY1iTQ9rmhl7ceANXUMXOQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537327; c=relaxed/simple;
	bh=26FlIbUf9V+GP6YoyCGDgDWxVMXm+rZ6SQZ9hhE16q0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=powpSLmZAnHVvehPOzIXy0/pr0j0c98ebPHWl+c1ZNtw6CcsXV53Hf9p/ae+TefHTaHH7ak7f14X3vbmlBkZbUOp7gkijyTrlrk4oFJWmGtddqSF1bD3H1zwOJnojLzS9rBN4FN8AasX/55E/RzvUIdrLy+dcpQ3N/QkZOXkX8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NgrhgbSp; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736c062b1f5so1444493b3a.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537325; x=1746142125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SiYnJ44kk9NCrgcaAGeA1Z13fMIq5NQl+K06XxiBL1A=;
        b=NgrhgbSpV+zQKnLVgSF6jOdvUXAtZ0E8nM0uzT2o1i0iP0bYgYagCvJLVVKNIfCwIq
         /NZ5Jf9sNWrX0KbnMUc3N18J6GwQPtVo9/+YuFhpTcGEVBDZaP4TuCugZ8HKKKiCLJAO
         5rf/Mzgj0vDHWUdYvhl/T9g42Lx1eMhq3iyjxVp8G6e5RT20lo4tuJTulqITqjRLHiC5
         IT1yeLw/oKWMWQOhdfSFoLE4TmnFjAl+Gp8/cpJsxJd9lga0wkMHs/s6HKlNpykVUTVI
         /1Mm5YW9RjfkJ79f6tzWhUASPaaPxp/g/CY7OrFFBuW/b6jXxIzE0oabVDyOdjUsNAAx
         wc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537325; x=1746142125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiYnJ44kk9NCrgcaAGeA1Z13fMIq5NQl+K06XxiBL1A=;
        b=XCPvhAucczQjnOUdREeRNq+J1l2+0SbX0iVKfwch3V4bWmBrlO7q9ITTB/DgRSmLy/
         1/Khz/8zkz01Gv+ieqO7RWgKMLC48o0LS+L1GwaxtRnClQjxi7wA65JkXnxFc59Z8W5e
         +WGNfPDTBBIbyt2jYhXEhwLOqzGJb561B/RCJQsyoik2HvxCa/8SPxCNPU0BDEvfUKkE
         KsyMBMhtdDudHGvAmGgpecHUE6Lu/Oul+Q+pVG3jqm5w9pQOhFtpf3MY41OSnnCBjP9x
         GsDxkz4X3QQnJMwObK0DX6jDH/D6pNqg3/cfH2Xqw3+j1BMjFsg5HMhXco5gAtDpW0ZG
         egTw==
X-Forwarded-Encrypted: i=1; AJvYcCUmzlXkNrOwNdC7fnplsKtMaElpJ0zm6g9bgzCH9jz4FKBqBlrYXrFxq206MpB5w9LY7+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8HY+XSpeMkmCYeU2GxXxDHAeKZ6fewUpjrCY4UzwVN1HuejAH
	3ierzTio/d2Ww2a0U1U2bEnDuw0zmtmZ8W+8qhqi5Og6lN2LBpWOPZlbeyxtxeE=
X-Gm-Gg: ASbGncsdvoRmIz38lsNoFixqDsj2D8kRLmxRqL6uyQJcZic68Xqs4sJ39OOmR9w0hWe
	wooPA1tGcNlSDw9Jtw3TiWWXk2fqkbJhQku9N/uhpV+V/2z0M6OBoRicBpv+GjWeFLn+KEIWKBM
	XJrQRaC4j013u3qE1r2tvNynBQxe1/u3a+eGsV15H/eqfwApWmQTOp+J+ofnlrFF/d3G/D9XFD/
	XrI9I+TZ8yX6Vy8PMxNRuLBb/AlioJEI8Qi+nf30HraldE9KQpNCDUHIhyzinhDJ55LqKWK8wE5
	rxSpVryHPvccwLXzhBuEDDPdWyrvSvFnIXQ8si1N
X-Google-Smtp-Source: AGHT+IFxSHqiCOGNaPFpL5Pz9zgvzRwj53s2AvZo4vsG82hlX+g5LdHj7uN9QSJDob8FWejArOc0/A==
X-Received: by 2002:a05:6a00:21c6:b0:73e:359:acf4 with SMTP id d2e1a72fcca58-73fc7866454mr191129b3a.0.1745537325420;
        Thu, 24 Apr 2025 16:28:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:45 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 8/8] hw/hyperv/hyperv: common compilation unit
Date: Thu, 24 Apr 2025 16:28:29 -0700
Message-Id: <20250424232829.141163-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/hyperv/hyperv.c    | 3 ++-
 hw/hyperv/meson.build | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index 8f193fd0bdf..1197a403efc 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -13,6 +13,8 @@
 #include "qapi/error.h"
 #include "system/address-spaces.h"
 #include "system/memory.h"
+#include "exec/target_page.h"
+#include "linux/kvm.h"
 #include "system/kvm.h"
 #include "qemu/bitops.h"
 #include "qemu/error-report.h"
@@ -23,7 +25,6 @@
 #include "hw/hyperv/hyperv.h"
 #include "qom/object.h"
 #include "target/i386/kvm/hyperv-proto.h"
-#include "target/i386/cpu.h"
 #include "exec/target_page.h"
 
 struct SynICState {
diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index ef5a596c8ab..d1cf781f049 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,4 +1,4 @@
-specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
+system_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-- 
2.39.5


