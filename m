Return-Path: <kvm+bounces-18432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A17D38D5275
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 318291F220A4
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249BF158A14;
	Thu, 30 May 2024 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yRjxVp1r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97615886B
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098175; cv=none; b=SQI4PAAd4i0naj/4DKgNQaPPZUgR97bqTHlTPvIwL+nsXcz+8VxmXyxWPe25LAiqqOZDUxJ7IkkREJbVh6z9WGiclqFDyasVAOSN41f3oEtnKgQMwv0GtT1en6+FlfauZzldePzeKDqzuAoNVQoP1qm+fvIemwbVNPayEmyh8w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098175; c=relaxed/simple;
	bh=Zu/scKpfMgM1BABTUFtARd2WDozR0rMC1YLexXBGNTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJwLTXRFojbyFbC5vaE52wNsI5NW4Qa2B3CfxPcXd1DErDf6iOC277aTK7UNLnGive8JGLPtRtizklqRx++WYRshdBCgI4YIpEMmIGwU7mfddhJdUFpn4rCAfl2znn/af1UIH6R5IpdacsAlF+Ag0MHa8FZY5e+UvCelc33PQTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yRjxVp1r; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a62614b9ae1so155638966b.0
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098172; x=1717702972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uF3iE8sM7cMEjCs0SvCbRt/oMMRILi0hvudECvvT8YU=;
        b=yRjxVp1rTgSUkkfvhfaDkoc/8f8NU7sk3mmjYeAwFLkOqvFG3m9RRLfv2WQbEWL6nh
         QZsZb6H2qMtSoCpTs7/zgpLFyPGiwFkKHXGmr08oUsTqz78bSAqYj+KhnT1otRVrumg6
         MAOxaiej2Z5LoRf5oBEX69/2AGQiBzYxng66/hZUsY4bso+NShH8gNz5UeXHImXLgKhP
         2DWCiMlrZ6kwFaABeiEUFr+/ojazWdhZk7Tk+bAsxFTl+8QdQ4L4dyC4rJ/NV8cdWB1f
         V0Lk42jOnYLVY5jzO0ZaezQ3UL46519x3YA969DFxBvcAVjYz/lXU4OESrNx01xM8rpN
         3SRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098172; x=1717702972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uF3iE8sM7cMEjCs0SvCbRt/oMMRILi0hvudECvvT8YU=;
        b=rrlMMX5inE9merwmg3vooPei88bqSewo8McNCxsOwB/8HF1s80WMMM2tg7kxbhw6aW
         kssJMPsn1Saz62TaZZ/Ch71nQUJsV3cOzXtYTV5KuwrCgKu8jBAXjE/bRYu+3+nSd0rB
         w9FpqaqIUY7TiBTzmIhrtFE5jesuZjmuKU1LE5mvqZXe2GJwXyx7bGj1rw4qPZ+bMMaK
         HqheldlkHXwEKoeVYbsJSp8sBLvJ5WdDVOjLGAem+MoYBeFAVgkk9eNWCQb6Vb5jipx3
         5RrwgrABivHa39SuO4C00EnwY+fdJB/pt6DW1ZDfLkGz3OafSF9eb7ZbQX8IvSzqnkIt
         fJ7g==
X-Forwarded-Encrypted: i=1; AJvYcCWra1nsbHhjw0JpY6/L1ae/txhB7WQDkIh0nOKGVdM+AKh/UnZWac+WEzMCQzkOco6QajZ7+IV9HMQBIAXG97O8Jc/m
X-Gm-Message-State: AOJu0YyR351vYPGZOByIWJeIv1MQldZUIgAiqInIVheFx2vCQgva5hlU
	J7t8oM05pYz4Fb6QGcDUBtzDnk/JNHJrg8x1dq+b8oeZlXgjuXZ1ipTRi+EO5CI=
X-Google-Smtp-Source: AGHT+IGq5go7pjxVXZoiDIctGP4OrpbOzSdrxavQVhZcrfZhYA5v6u0JB+p8JidVC79uF/koqWAkCw==
X-Received: by 2002:a17:906:ae8f:b0:a66:ebc8:ad2c with SMTP id a640c23a62f3a-a66ebd812e1mr100669966b.42.1717098171713;
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67e73faa76sm8314766b.75.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A25505F8D5;
	Thu, 30 May 2024 20:42:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH 1/5] hw/core: expand on the alignment of CPUState
Date: Thu, 30 May 2024 20:42:46 +0100
Message-Id: <20240530194250.1801701-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240530194250.1801701-1-alex.bennee@linaro.org>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make the relationship between CPUState, ArchCPU and cpu_env a bit
clearer in the kdoc comments.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/core/cpu.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index bb398e8237..35d345371b 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -391,7 +391,8 @@ struct qemu_work_item;
 #define CPU_UNSET_NUMA_NODE_ID -1
 
 /**
- * CPUState:
+ * struct CPUState - common state of one CPU core or thread.
+ *
  * @cpu_index: CPU index (informative).
  * @cluster_index: Identifies which cluster this CPU is in.
  *   For boards which don't define clusters or for "loose" CPUs not assigned
@@ -439,10 +440,15 @@ struct qemu_work_item;
  * @kvm_fetch_index: Keeps the index that we last fetched from the per-vCPU
  *    dirty ring structure.
  *
- * State of one CPU core or thread.
+ * @neg_align: The CPUState is the common part of a concrete ArchCPU
+ * which is allocated when an individual CPU instance is created. As
+ * such care is taken is ensure there is no gap between between
+ * CPUState and CPUArchState within ArchCPU.
  *
- * Align, in order to match possible alignment required by CPUArchState,
- * and eliminate a hole between CPUState and CPUArchState within ArchCPU.
+ * @neg: The architectural register state ("cpu_env") immediately follows CPUState
+ * in ArchCPU and is passed to TCG code. The @neg structure holds some
+ * common TCG CPU variables which are accessed with a negative offset
+ * from cpu_env.
  */
 struct CPUState {
     /*< private >*/
-- 
2.39.2


