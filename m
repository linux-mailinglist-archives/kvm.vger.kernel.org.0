Return-Path: <kvm+bounces-64280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78176C7CB21
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 10:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0790C3A86A2
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 09:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F99A2F1FFC;
	Sat, 22 Nov 2025 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGLpprXK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fWcd4W1s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EE926E6F2
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 09:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763802554; cv=none; b=RreJe+YgfxDS/hqHz1w6unUFLe2efCwilUNDFn7c6byrKIFlTPe9CICeSuzV2WYUZcvUA21D4TFqh1bgiIfvA15pR5qHTypEVbT5vBnp35QWXzMYM3WnvkGbizYDHxpHboZpofTTZ9HLqxuZxkhFcLM6KJcqk4kpv4VYZn6t/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763802554; c=relaxed/simple;
	bh=TwGtLeyLLi7YyE3RrIM2s7vEQwBTZUsPJ24wCK9jEsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YMxO40H9CeMsOXCtZY05w1BBf5eweguGCT3Iza27vaufy6yOHCYEc0U9z0nYH89lH+rOEHy+zHROKHDTLUjO1pGN38nUz1l7K0FUumEobi5Br8twLtSnN5qELQdtFUAmtFSdSmWoul9vwJ7/x+kZ8XM2yVLWjDKd09H4+hXYNoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGLpprXK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fWcd4W1s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763802550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p3GaxkYsnMwulitUB48P3Qz5M8Yniy4BOYL3CNBCuHU=;
	b=bGLpprXKpmm9oMCEAl8IjNpmx+NkQMgTGCTE0cAZUZS1WzKxNOU1jo7Mce3dXgZnPCGZOi
	iKxFtAbJUmDacj349sXYf9p/Yc/aU2oWtLZUW2CqfC/ZpZBxtaxDNzqWEv+lvoQqZ/0rbO
	WIZuJV0UyUiD0+60dd/DNI0RFxtO+ZA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-L7CqpZHTPZSmvrxmQs3sFA-1; Sat, 22 Nov 2025 04:09:09 -0500
X-MC-Unique: L7CqpZHTPZSmvrxmQs3sFA-1
X-Mimecast-MFC-AGG-ID: L7CqpZHTPZSmvrxmQs3sFA_1763802548
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7b90740249dso5338701b3a.0
        for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 01:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763802548; x=1764407348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p3GaxkYsnMwulitUB48P3Qz5M8Yniy4BOYL3CNBCuHU=;
        b=fWcd4W1s78eMTz+IGLJnur3++lzTp2qvuyAmErMXlLXUFGZJ1ydt3p3DDVTs8h9vf6
         I2eh5Y7RNVXLD3ERlz7Us9fA9dHqYHiu0jL4g3e/5uk1FMRC79oGiDGzfDFVkMVDCrfZ
         VHCDkPqB41WY5cH/Fyw6U6BigGftYtTJJql28YiJHvsom98+pzHaAFMkEsWOx5vFZyzK
         AG4o4zfnFwH1Yb06GNcaTTJgMAPvUZHT6sR6RdS28BEyayhLXkhhxRjKyzGMiSgV36qw
         +WZ0bSex+MMSmnsMonlk12WTKmxBawIsfbuerNrOo8bg7B7KnrQds8n4ZGZDsVl/f6CT
         959A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763802548; x=1764407348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3GaxkYsnMwulitUB48P3Qz5M8Yniy4BOYL3CNBCuHU=;
        b=XUAxDfHSWKKCS8l8d4JlKdkwsxAenAq+3zrhywHXgokAycGHQ0J1LEGWEC/ZmFHJ01
         9omaI8kWit5SWBK1AGHm8n8DOHCW76prA2Oy0krHzX/VGpeqYtEH8UrDmcYrKsxMA2bX
         hSd1Ca1zj/0N+rC/PquOR+5p5yUKqCxbq1JiIJRJzK8lqp71i8b4sUp3IcJknLRmDRHq
         4Sg/l9Ju0A5yF05fwE+glkDeA1M8SdCYkoKAGLZrkoxtlwWcANSCL38trUJs7dcGrK00
         TZcdzuKWMZ5gre1P+Z3SFJuHMVnGSAQ533lXjMzF8EwEtOQoKcKZRC6upigl0YlbGbQr
         1txw==
X-Forwarded-Encrypted: i=1; AJvYcCWSAYDfTnZn8KCSYgLlU51xqhrUucHaxBGQTjuxxxH0/PDt96Y6G+j/geel5ZfHtyRffB0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrHbVHzeRUPZUl0vze55Jci+KcYSXbNXTZRCpkilMeIQY8LXXo
	b4sxhZLwa5ediGekceVMUD1V3e4pnmyHYMzPalAtjgC5miSaH5ETUR2cFfBPHSku0lGB2VPBfgi
	1kjbAAuRvemYbi3DR0jTlPRMRO4wveTVLgKdDFejQA8igSQ80Hzdp3Q==
X-Gm-Gg: ASbGnctIFO2WsLGjJsDsM95drXl1ghcPVZ2j6eHZD4x+/8skDsd+mbhznaMub5a56RJ
	woILqgm9MdzmsGLXCYNFKYBzREMW/t3ilbA0J9MpDgAqwjeauJRZBVQTx3lQM2iPQm30MsiLr9m
	1iU//ylI4QU5ZYrOJybzShz0IMW6D9xLvgBmCmtynnQ/1AI21KNJ6+MyGxsaUIU04HJiJ/WHMaZ
	OqCUg1eSOSpJkxS33e4b03UQw1cKGh18zgRBKRU43WPK71k+I0/XLiAae+ExnyypV88AVuZFK4B
	mGQ01Y/BXN7mviPecy8CJCXoHnKmdTxWg/dNUoBt58NFUxe6XOzPAl5sqaR7hdLzeVCf5bd3m/A
	6JzUw
X-Received: by 2002:a05:6a20:7d8b:b0:35d:bb66:5cf5 with SMTP id adf61e73a8af0-3614eb185bbmr6278575637.3.1763802548089;
        Sat, 22 Nov 2025 01:09:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEgaX+nLSLXHn2V9mu3wqNyKEhlSdKGbz5UeadF74X1dtCVoGyu/ayX8nVUh1GbnJnrIm+dmw==
X-Received: by 2002:a05:6a20:7d8b:b0:35d:bb66:5cf5 with SMTP id adf61e73a8af0-3614eb185bbmr6278561637.3.1763802547621;
        Sat, 22 Nov 2025 01:09:07 -0800 (PST)
Received: from zeus ([2405:6580:83a0:7600:6e93:a15a:9134:ae1f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd7604de4cdsm7681733a12.20.2025.11.22.01.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 01:09:07 -0800 (PST)
From: Ryosuke Yasuoka <ryasuoka@redhat.com>
To: pbonzini@redhat.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: Ryosuke Yasuoka <ryasuoka@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kvm: Avoid freeing stack-allocated node in kvm_async_pf_queue_task
Date: Sat, 22 Nov 2025 18:08:24 +0900
Message-ID: <20251122090828.1416464-1-ryasuoka@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_async_pf_queue_task() can incorrectly remove a node allocated on the
stack of kvm_async_pf_task_wait_schedule(). This occurs when a task
request a PF while another task's PF request with the same token is
still pending. Currently, kvm_async_pf_queue_task() assumes that any
entry in the list is a dummy entry and tries to kfree(). To fix this,
add a dummy flag to the node structure and the function should check
this flag and kfree() only if it is a dummy entry.

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
---
 arch/x86/kernel/kvm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b67d7c59dca0..2c92ec528379 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -88,6 +88,7 @@ struct kvm_task_sleep_node {
 	struct swait_queue_head wq;
 	u32 token;
 	int cpu;
+	bool dummy;
 };
 
 static struct kvm_task_sleep_head {
@@ -119,10 +120,17 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
 	raw_spin_lock(&b->lock);
 	e = _find_apf_task(b, token);
 	if (e) {
+		struct kvm_task_sleep_node *dummy = NULL;
+
 		/* dummy entry exist -> wake up was delivered ahead of PF */
-		hlist_del(&e->link);
+		/* Otherwise it should not be freed here. */
+		if (e->dummy) {
+			hlist_del(&e->link);
+			dummy = e;
+		}
+
 		raw_spin_unlock(&b->lock);
-		kfree(e);
+		kfree(dummy);
 		return false;
 	}
 
@@ -230,6 +238,7 @@ static void kvm_async_pf_task_wake(u32 token)
 		}
 		dummy->token = token;
 		dummy->cpu = smp_processor_id();
+		dummy->dummy = true;
 		init_swait_queue_head(&dummy->wq);
 		hlist_add_head(&dummy->link, &b->list);
 		dummy = NULL;

base-commit: 2eba5e05d9bcf4cdea995ed51b0f07ba0275794a
-- 
2.51.0


