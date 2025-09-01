Return-Path: <kvm+bounces-56443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AAA2B3E4E4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E358A16CBFC
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3168B326D5E;
	Mon,  1 Sep 2025 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lidaR9y3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ADB2FFDDA
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733197; cv=none; b=Wn68qoC3a7uCs/C8zspcNuXOLmyTLSsyBtgjs/NWEAi6dBhhETILB5n06ryjhDRpfcyvH6CbpcEGRyXZWgFGkxUr1UXLGzYvjSM6B3n9q3PYQH/9vERL1CB5rbeGw2OewCRPZJ9a0hIIMbN3oh5+AQjsLTLM+XyBzcSPf2TlQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733197; c=relaxed/simple;
	bh=hJS4jhtkLlFOIVClBUpOI4BbgIGAcp/tbeqwMzvkYSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QX+EeD8w3oWzzvAy/vKJsqQPoSks8NFwiWGT8IePQUrE62fIqISMdU+dGvqlm10OgjZK39geXroXze0emD23xy9j8FhJF/dA/CzvJxDUiSL62oF34ltQjHqttI+6C8H9hMOakcNLu7qJ+srbeWK0IAQRJNFMSVW/x3fjYtI0NqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lidaR9y3; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3cbb3ff70a0so2688376f8f.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756733194; x=1757337994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3w1FiZdw8VHp7vBmM8UDjk+CIU/+vapRQH5dsIqp3U=;
        b=lidaR9y3qEveecLVH6RBTndFbjye4V80v0J1LsjjgIQFexBe4DfDGLESN+xn7bqHjZ
         9VaEh75IgB2RQ0cULBWOprZ+P5vprM3xoYQemDLzDIEfyCJEvPC/KNAfsNMMMXK+bkYr
         2i6J9ytmFDqnyzsuzD1ESJ5wTtUId6nrWSTahOBb+y9juTRrIrSoOtO1B/a1IqhILnia
         rVdJRYNO1vrrfkK7Oo5Aq/vPSXqt6vcCoEeyZN4u9uuy5pJx22U6Rr9fEzm7ESMr72lp
         AcYhUOhB/QvkuxS21lm+M0eaZm+JSxhuP0uG0kgZXDjFQXK2wDVwF6xci5uNvAJPX8lB
         27ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733194; x=1757337994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3w1FiZdw8VHp7vBmM8UDjk+CIU/+vapRQH5dsIqp3U=;
        b=c25iPKpcZhwOiXpvY46XPC/PPWe1sLaswYUalEA0khETAzqpGq7emH6vrKtrGgTrYH
         1/V+YtN1Pb5XJEcoVt4+yYz7S1ajWq/5xPCD3WNEJ6v+7Zku1oj4YmJ6bCeJc7ue+Ziq
         X1kkIZz4lD/ICWTxOeRYoVuYPzSBtkvBuX222Cn7ah+u2rYSr0OAaNqBWEQ5vBX4ML2Y
         px8+hRoV06tOebbPT9+fhes7BVPI04n5Vy6JdeS6isUxr4WRMTOaWxYOB53Pb9LW4iGA
         wTzlhW9cmv1LfxoWJQ7Lmg3dh6asJ+DNxH8N2AZttco9Kje9fgkO9yAEixv1+NW2CiYC
         aMbw==
X-Forwarded-Encrypted: i=1; AJvYcCWVCvkyxj1n0h/lo/X4fk5KRYwk4EtgjctTUZMUbpY7GW9h2i+e3fY9GN32Aqa+6ajYgUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+VcTbPFdPxbgT0wqYUpkWJx2uxhtAwCMHtimvT0m4oKK9Rc0U
	b1ASZqWqQYcNJCwjOkEhprqmC1/PZIV22BJFCwjkLryx1Jf2bM+MOHpOx94ElFonzn0=
X-Gm-Gg: ASbGnct9K0JlIZNnU/+YaDmo7ruik6pLBZNCt1sthsJOv+RWmBkbfxwJVVUieybDRcb
	I9pIWQvlFuO9aZWaoAATY0aVMSFMrLziLPkq9iHc2ximkoS4Nmu//R2C7Mrb0HsRpKTN4MVCqvk
	4Miu8SDow4NLFPocuqjl6WQqTmE6LSG3oe/6PjFM9cppDf9kP7Vn21yBq0LUjXv0h4Ja8BKYoal
	37AOfuYGfW+hg0VnkA1o+BEgO+xY1/9lpWRghRwchjwbjVwQ85U+ZTk9R8zPbWiKTDYzDj75Mrw
	xQfepWjCr2br2a6EZM5e8qXrYjZOAkR0rneKAnDrNelteqPP6AMXF3/f/MHBJKNkwn/LyECwmG7
	yftivCFuUlTNMRJaeE4JuxRc/pX35/ZQjnsGA2cY0627oHR8b22JoP7XzLXZrc6c0aPhd3BPks/
	VIbTclKpo=
X-Google-Smtp-Source: AGHT+IH/QAHlxPbNMTYaJUtn3zT3bO63FA0TSMUQyXWPqmbg4KgBIu8+2jjlf2Aul+/W+uLb9CMgDQ==
X-Received: by 2002:a05:6000:230d:b0:3d7:b12b:1312 with SMTP id ffacd0b85a97d-3d7b12b1a47mr1452198f8f.9.1756733193793;
        Mon, 01 Sep 2025 06:26:33 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d15f7b012csm12130896f8f.63.2025.09.01.06.26.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 01 Sep 2025 06:26:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 1/3] target/ppc/kvm: Avoid using alloca()
Date: Mon,  1 Sep 2025 15:26:24 +0200
Message-ID: <20250901132626.28639-2-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901132626.28639-1-philmd@linaro.org>
References: <20250901132626.28639-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kvmppc_load_htab_chunk() is used for migration, thus is not
a hot path. Use the heap instead of the stack, removing the
alloca() call.

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index d145774b09a..937b9ee986d 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2760,11 +2760,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
 int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
                            uint16_t n_valid, uint16_t n_invalid, Error **errp)
 {
-    struct kvm_get_htab_header *buf;
     size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
+    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
     ssize_t rc;
 
-    buf = alloca(chunksize);
     buf->index = index;
     buf->n_valid = n_valid;
     buf->n_invalid = n_invalid;
-- 
2.51.0


