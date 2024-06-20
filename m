Return-Path: <kvm+bounces-20153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC323910FE9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5824A283EE9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10DB1BF31F;
	Thu, 20 Jun 2024 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqmRxU5q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934921BF30B;
	Thu, 20 Jun 2024 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906267; cv=none; b=fJpkiqwvhWg/4qW58S51Dy0lyisFEZeNAcQlfB9T6Wz4eZ3iB1fRe2QshR89GFFJK69Q0rebPRH9fTfBWWv/AVF3U1ld60vJt37RhqdEqqSX/vBlxYmNhk1k2Waw4fyLHJZ3f7tIIQIa/38zSRp21RFNpLvX1vlHmq8LxgLerBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906267; c=relaxed/simple;
	bh=4urYLJw0UpvAK2blqcUY9JMaZPzQLSOYCfTIDKdM0wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3SbdjmQ36N9pTG//C4G+U4f5/xV2HbFUsbZjovJh/bZ0a8mEE742djv4FDbeiv+MMRenixhTJ1A1yzXN9HcAzxxHRzdGO0HGpCJsHFOAvI8gH8lOQNK2nmPbPB+l9pUbl/d6a1rV+kW7u+bxGcq2FZpPJtnZmf5kRz/+jjaJmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqmRxU5q; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-70b2421471aso912993a12.0;
        Thu, 20 Jun 2024 10:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906266; x=1719511066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t63yqlV4wLLuWcSezXBxdfBk1sgIeDP3Cs2mWXS4mPM=;
        b=UqmRxU5q008n8Hk/SZhgqSyMGikfKTeSfXfCO35p/hkRT1vs4T+HtpSmhpGyDIsMyz
         Wm1k/eys49cNlMuoFrQjcMSKFD1kB1VDevOYxR6ulPUIOIuxjpHO6ROO7uH8bPLAVZRZ
         m4FlK20xDGxCbgL60HLs6yPVClP6bkJCFpSlW5XdPujwwhmA4QUVhkydD7OgnTqrGM6u
         JqEb3LolGMsUhngBKblL0TSAiO3gScBhyH3OHw9RXhL1flr6YxSOxsXPWlj2A4c0sZ/5
         fsUfoB9wLiZC5O/N81yKricAtPNecDPwgqK2uBdN9m2X6fZcvjgBzkdc6xxEU9cE92TZ
         UbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906266; x=1719511066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t63yqlV4wLLuWcSezXBxdfBk1sgIeDP3Cs2mWXS4mPM=;
        b=VGOFXT/wytJTtIckbsjZ6PdmcJQysI4PJN4Ll3VtHWljomdYp4+nMNZS7j60JiiYQe
         tzTFEs6DWW7aUc/oZWAon3k0YH7blVlJVnXadhsjnLmf9jITJX9J3yH0u7NoYxlAzPC1
         nZLom0dGE7QXB35oC1pYKnNKfn9jOlWvuoejx4Fah6oO+b75S63VVxXtwCJJUxJqpyzD
         VVW5QdLFGtbgvaoLegfleRHNo1XFSpS9beD4kN4JcaN35OEVyVWnuyQ2/7/3XbqD1d19
         WZEMs2u8S+7UfNQifqcncbMcV9Wldm5TZPlk/s1drJtLAi/DTy7quNNjTf0/vaJ94sHO
         IGEw==
X-Forwarded-Encrypted: i=1; AJvYcCXGaQKfpaVnUAiOaZjMnydkWuRx/PNTrFcbYQnXhA/8cnt7FE8FiRVpdbfOTDhA8jursQdHNdtswYdXKrPfvtVjE7Te
X-Gm-Message-State: AOJu0YwU+jduzWIZu79ff7r3PZFcdLw6G0DOmCMOJEPvR+h9+6kOIHHp
	A7an1v1+dczhtaSrA+hFJ6mYO7d6E8SpCyr8UIWd9sptMJU67CSxnIH5nGWEE3g=
X-Google-Smtp-Source: AGHT+IFx76sQ02XBcANL8DcVNfxhLC0tLCAwAsMFhiQVAC5yOXkmJulbSByKVrlRFBXWR+fdSTy4Gw==
X-Received: by 2002:a17:902:db0e:b0:1f7:124:b820 with SMTP id d9443c01a7336-1f9aa45eaf1mr62717175ad.50.1718906265990;
        Thu, 20 Jun 2024 10:57:45 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9d0c8341csm15936625ad.162.2024.06.20.10.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:57:45 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 13/40] KVM: x86: hyper-v: optimize and cleanup kvm_hv_process_stimers()
Date: Thu, 20 Jun 2024 10:56:36 -0700
Message-ID: <20240620175703.605111-14-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
References: <20240620175703.605111-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function traverses stimer_pending_bitmap in a for-loop bit by bit.
Simplify it by using atomic for_each_test_and_clear_bit().

Because there are only 4 bits, using for_each_test_and_clear_bit() will
generate inline code, so no excessive bloating with the new API.

While here, refactor the logic by decreasing indentation level.

CC: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a47f8541eab..96acbcf603f5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -28,6 +28,7 @@
 #include "xen.h"
 
 #include <linux/cpu.h>
+#include <linux/find_atomic.h>
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
 #include <linux/sched/cputime.h>
@@ -870,27 +871,27 @@ void kvm_hv_process_stimers(struct kvm_vcpu *vcpu)
 	if (!hv_vcpu)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
-		if (test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap)) {
-			stimer = &hv_vcpu->stimer[i];
-			if (stimer->config.enable) {
-				exp_time = stimer->exp_time;
-
-				if (exp_time) {
-					time_now =
-						get_time_ref_counter(vcpu->kvm);
-					if (time_now >= exp_time)
-						stimer_expiration(stimer);
-				}
-
-				if ((stimer->config.enable) &&
-				    stimer->count) {
-					if (!stimer->msg_pending)
-						stimer_start(stimer);
-				} else
-					stimer_cleanup(stimer);
-			}
+	for_each_test_and_clear_bit(i, hv_vcpu->stimer_pending_bitmap,
+				    ARRAY_SIZE(hv_vcpu->stimer)) {
+		stimer = &hv_vcpu->stimer[i];
+		if (!stimer->config.enable)
+			continue;
+
+		exp_time = stimer->exp_time;
+
+		if (exp_time) {
+			time_now = get_time_ref_counter(vcpu->kvm);
+			if (time_now >= exp_time)
+				stimer_expiration(stimer);
 		}
+
+		if (stimer->config.enable && stimer->count) {
+			if (!stimer->msg_pending)
+				stimer_start(stimer);
+		} else {
+			stimer_cleanup(stimer);
+		}
+	}
 }
 
 void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
-- 
2.43.0


