Return-Path: <kvm+bounces-51330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8C9AF61F7
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65C0A7A2FCE
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5E22BE630;
	Wed,  2 Jul 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GeEmr6hB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC19F2F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482518; cv=none; b=GcT3goBnyDbCt97Yr+ViLF9+Scsw10Oj3GLllDsO5X4pvWfIH8z/ck+sPEELmKYDohPCPvUxS47w7WE8kdCfa6hIUhBoO7TspKQyiFasW4nVimZIAAo29XNUjG0xQAuZhF/fn7Mx+gyLy04JoLVbXNWBQNr5ISWkHl2HWgQwrZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482518; c=relaxed/simple;
	bh=N4GGBaFbzTp4F2dQqNXizYn4DOLyoHTJvVTraigaENo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGylJ3ZoSfDDq7g/3qqa2aZf2ooo2XPwO+t5ssORrXpNCXuozabosk/TG/CvRZ4Glmd/cLQK7VMtGwojBpXM22TUPGfnkW8t6I9H54ZLzcU9+SPvBOf5+el7J3lIPrmr/P7iIKE1BNEH1XpvsBBoGUpVWw6tahj8qATqM8Z9u7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GeEmr6hB; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a528243636so4567076f8f.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482515; x=1752087315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEXuTiZx4NBtgct91pluD9hB6GRxEbVAf5qByawcXe8=;
        b=GeEmr6hBh5SY8A6q4fLTsxBHlI/Gg3sZU32/0iUvvB2ZrhTISSah3WrgqfvCkrtnD7
         HuLFBn7+pqrjaleOwY9zZETDNZk2j5NCgMLEc3yMcDgOUD1Lt2b9qkdaninqVdYIidAM
         W7jrtbWeMFWouO/82dpM36gcVYEPfi+bEfo4VAywVoGu1QMVEmWPuPPDcKG7EbGHJg4U
         ppmugQNrvHeaHn/aqMub1AtEe61pCORBtprcj1satu3rLqtRhATtyQ0JgL6wjiwQzmwr
         ymn58zKydsdw+Lrng8nwyycHM9HuJ7Mq+nw8+DXP9g6z+tTIyPOeIaeVpoqgnTv9XTai
         HfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482515; x=1752087315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEXuTiZx4NBtgct91pluD9hB6GRxEbVAf5qByawcXe8=;
        b=MMorgUHF9pYoB2YSEbPKgw7TUnJT2eVkc6X7/POCljxaqeUNK6Qwn7k1bK0BTQxZzZ
         JPW4ABfUw44UjBdLlQANkxeHhcFggrDGBvDqxacl4jbp2K1DWYKQkuIfpAOcSQd558Xn
         AKmTyPSY3DBmq4MJzunumPB13T+6pVOBtui2ZA6liyHOYRkVTCyioEKjHGXOyvA3FxhU
         HyTi8W281X0qhRId57esk5cvQLw9myfzEb3ePFLoNX2jAknjMN8VYPiXPEnLatF3q6Cw
         6x/F5NxO4iy4KxDlmnXoIbR8q23Pb+I3qb5c+pstyp0eISsLNahz6/cio5Tnq/zusH0L
         gG6A==
X-Forwarded-Encrypted: i=1; AJvYcCUOMcbJS6fnJ9vNEullEH9fXbiFOWbL2M2wVjPSfORQ5nyPN+1RqgEdJLBSbDKQ8EsZ5Ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YygO9nxLUAsclvYqhl26eGRz3ZwTkHoYUHyUm3uHhLB4OMFvytZ
	6fteqHo3/EzN2zkZfEj37STnVrYOqF8aFifTRj4kp5df23yHubDR5sCg089duw5sQJ4=
X-Gm-Gg: ASbGncumK65To+BR2xJQCZmDpMYmzfyLsVnvxvxMf/PwYQp1/KTUQSb8EinC1IO7UJj
	2F9ZMq+uPP/gZQR+r9SxbBmzMT55OM1ftqMV7cvwV+T0AMeUJPznUZUXYVTGfeMVFfh/7RuUJL3
	OsA4xaUqUD6Got8WnMpGInbB+awKtQp4Ptmq9EJi29ClG+w0hMqGPI6Mj/n6vhy9E7AJk2rs3xE
	sbAhj/EutGNeh6DIVR71Ry9XXVDbzWJHxNavlnjBPchcuuukag9fSQz3vyFgS6naZib0CnzYkoB
	PFgz/JMlCt12tK/lvzPK4TzTHi8WYrFpVlJ4XJrC0cjvNddsZYN7MB4T2EU50UZIbloYAeVW4Cb
	TG18vcTuRp3FFbEYxPT/UJEuw3xpFV8RRfhHr
X-Google-Smtp-Source: AGHT+IGC/drp3yMryelqlsaojOmXUZ2K7xqD5U+6AbjKxisbXRDLHdj212ng2Dwl9BWxNzsTwldHpQ==
X-Received: by 2002:a05:6000:651:b0:3a5:51a3:3a2 with SMTP id ffacd0b85a97d-3b32f383792mr212092f8f.45.1751482514898;
        Wed, 02 Jul 2025 11:55:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52c8esm16870330f8f.55.2025.07.02.11.55.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:55:14 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 14/65] accel/kvm: Directly pass KVMState argument to do_kvm_create_vm()
Date: Wed,  2 Jul 2025 20:52:36 +0200
Message-ID: <20250702185332.43650-15-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f641de34646..6f6f9ef69ba 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2470,13 +2470,10 @@ uint32_t kvm_dirty_ring_size(void)
     return kvm_state->kvm_dirty_ring_size;
 }
 
-static int do_kvm_create_vm(MachineState *ms, int type)
+static int do_kvm_create_vm(KVMState *s, int type)
 {
-    KVMState *s;
     int ret;
 
-    s = KVM_STATE(ms->accelerator);
-
     do {
         ret = kvm_ioctl(s, KVM_CREATE_VM, type);
     } while (ret == -EINTR);
@@ -2646,7 +2643,7 @@ static int kvm_init(AccelState *as, MachineState *ms)
         goto err;
     }
 
-    ret = do_kvm_create_vm(ms, type);
+    ret = do_kvm_create_vm(s, type);
     if (ret < 0) {
         goto err;
     }
-- 
2.49.0


