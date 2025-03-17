Return-Path: <kvm+bounces-41301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C01A65CC7
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83FE2171FF4
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4E41F5852;
	Mon, 17 Mar 2025 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qCltbtIL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789BF1F3BA5
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236483; cv=none; b=s0nXxABkf0hAr7/4WBZygCyCKZIU6BxXsZPg8MTXT3PSj5lC/gvHs0onALys7thFhovtcRXu0sIJTYIGWp66WOrkgW6PgJjnPnnc5o56v9Ad3Bt7CPGZ5u2M/W7Derd+DKoyKXbMk2g2B6t1tOrAX3Ducn16Fr85tqNp6WxLd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236483; c=relaxed/simple;
	bh=CzPhR8gRelKLEDtp1LKolN6jwIOO5jPAQq57RMOd2W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JgvBdq32FmQl7bWdhVk1RIEjbVvnntbc3vWgtm6N82ardxNqwEZPlJnq4khl5bqm+4ozfBCBtdtWbudzkVnAUGZobUmAldaXF1lvTqGkTuu9OZ2narFbi9SgXt/KhrzTQmCbs/pLQX/XYf0ENuWP0OpqNjLqHj2TI3v8LrT7Kug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qCltbtIL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-226185948ffso25819305ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236481; x=1742841281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=qCltbtILQKAFgK6w2hvQqh0GP8EOHvhwAaqvLX+9GaMID1NkjGLXMVPbUSyAKnqlLH
         s0RNtCUopaWCjle7Xn/KVJFiL/8hAa3+5nHLaSDenSr7uE11DdqvsflEoYr/CqhoZiri
         OPezN/8nnhs7ECu7jA/gRaiJzw+T9jkiTsKC9fG6CHv3+f/2rGymmEpZDkaqyURI2rs3
         X2/nfSDw5OLmfYjTCmQQP0cFUIB7XUlFOQHR1UiW5V+oj9EkEoGq5U7dKC+3+G5BAX2T
         qVCwlnqgCT1SEuH7P3Ei4JWuG9mxk6u1fssm3kfkHFPiWOQfOBf6pwoWaP2maawBn62I
         dwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236481; x=1742841281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOa15ppvF5kxsldjPkSIJYe5T0c824L9GaUvR3via0Q=;
        b=OrOo1g8ci1dGIeeuwbYzIe7Wg0cbJi8Ayewxivl7aoLTzhOf/Mx+mEsbff0Z6v0mKZ
         ysDeT5faIsxbsfFth9LEJjZmFvCnZ5R667WVxHoczluMJJgmnECZ8HlmKM5coIaBZbx4
         U8w1yTY1mUyRORpe7qiWfrn0s++x5fxWQ3RDRJDAbZSp/+LDfCU6AFtuq6hM5qu/yct9
         hRoWCkyaSOTk4bTeMmqp1DT0LhaI/19PVnyEV9YNe3kHkurOJUQNuB7nbtnjK/u0YPV3
         ZWrwKZlHsm9GpvVG0anowa9hmY7hhNGVLNdXmZnhglKjnMeWwqD7/aF+UL09igKxZz1c
         Pq6g==
X-Forwarded-Encrypted: i=1; AJvYcCW7hwx6ieGjmZSAeRnjRIsSX8fKwbn8CjRnzZFjkBhe369Yzh/Y5YOMwX/8/VZ0gLJVYG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYtR+chdvNNlN59eoppcFgpXek/c4yN+goIAxHa2IXj6HMDAzr
	Qo4/uiiwixftKL1lGz9r89xr5J9rxFhtRyzvrsKNvFO0sA7jTtx86t7NGv6tBvw=
X-Gm-Gg: ASbGncvx52a4xGRSRTioWKNNZUTXU73MIlA2D3iCCjADr1XuYLYZc8K0aX9NHYVbWaV
	fvziWlFP/jOcYgjg3PjI5VPRcYVGqebpXwA/LBOiP7ZKsfODqOgQz9grbLf7b5OGE/AiNQ74u4p
	x+8w2FpYitIoerC1sD7ZRsM8H+9z64Qqsv9MRz7/dn67+Fus5SaxMX3FxrLuV/DoV6wSOXJVARe
	ThjVoF9VL7j8MhIzYK4gmlos45x12Ma8mpwA/iqmfF4wfUlCaAxHl1BnECccm/UV8m746u+9GWk
	jK4hOh+vTxam2ssnzDL41W/4jaXdZq2IzEm3g3A37o7O5VvBJggl9YU=
X-Google-Smtp-Source: AGHT+IHJvFyPD498ouch6ktpEIoYmR6xx3vtpzwDFb0ar1DtZX7lkpskC+JCwilCa8dJd3A5JvQbZw==
X-Received: by 2002:a05:6a21:7895:b0:1f5:9961:c40 with SMTP id adf61e73a8af0-1fa43acdf8emr1048891637.8.1742236480716;
        Mon, 17 Mar 2025 11:34:40 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 14/18] system/physmem: compilation unit is now common to all targets
Date: Mon, 17 Mar 2025 11:34:13 -0700
Message-Id: <20250317183417.285700-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
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
 system/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/meson.build b/system/meson.build
index eec07a94513..bd82ef132e7 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -3,7 +3,6 @@ specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'ioport.c',
   'globals-target.c',
   'memory.c',
-  'physmem.c',
 )])
 
 system_ss.add(files(
@@ -16,6 +15,7 @@ system_ss.add(files(
   'dma-helpers.c',
   'globals.c',
   'memory_mapping.c',
+  'physmem.c',
   'qdev-monitor.c',
   'qtest.c',
   'rtc.c',
-- 
2.39.5


