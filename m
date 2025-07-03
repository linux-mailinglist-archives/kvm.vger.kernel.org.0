Return-Path: <kvm+bounces-51418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 903BBAF711D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F26D21C81598
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7D82E3B1E;
	Thu,  3 Jul 2025 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XFb3AsL8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EFE2E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540224; cv=none; b=Ha6yc2QrrHstw1NQs0HW02NXGe8NElGjRFlRq4zW8EYHa4Gm0bcVhBVLJVKudttMoBtXRVkC5o60wrwVAmsxzYIao+preNYvLecNqh/FMBkBYmdEpuTL5NRDYKf7V44matgzqpffBSJ0cc4zgfzlh0vjDfhL+xHb1/EswHXnkfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540224; c=relaxed/simple;
	bh=N4GGBaFbzTp4F2dQqNXizYn4DOLyoHTJvVTraigaENo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LuGowLFPckIrIK07WPnTuWhlUJ9bdltK0ecDC61lknCP4S2+Muwo6CgAJMdgppDHqY8xPogaZFStXoYhcfEWTvWin9kUpQ2nbwEq+Y1Ze/Pvuj9t/h6qpHbVXai5qRSbtABaf0jiFPOWqoc+Ck6L3enOaO3goEhmH9ScJmL5FgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XFb3AsL8; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a531fcaa05so3317628f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540221; x=1752145021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEXuTiZx4NBtgct91pluD9hB6GRxEbVAf5qByawcXe8=;
        b=XFb3AsL8+B1q7W4aaMpqUHBWohF91yqM2osaoFvQoM0VWZ87M+iH8BdbGkQFKhgoH6
         +ySAYpaLbhDjlY4yF/jSPlxvnSjCSVPVqWsZSBNtLCxtFl9NknAWlig1VHo13PlluQEi
         pEjE/KfEMn7cjtuwcU6pnqFCIrRqYTiip7UMPTPvk7LwJ5wKbBhupBC6j6v4zeS2Ej7B
         YSjNSAxcalTk5HoXaQca4bAPPE1TmaQgogWuuvjTFfttHG6rhV1l/dyy13KQqdxiawxu
         DJBE2LyTrt6tYWMxdKID6d9bTP9fz2OivB+JGFL6fX/k4AhQHmHnWDVaUHHxg+unYdQw
         +L/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540221; x=1752145021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEXuTiZx4NBtgct91pluD9hB6GRxEbVAf5qByawcXe8=;
        b=BJZdQNehZGKR0rh84TUmwZa4ixPPdOpLxdYhMY9nMPa+yny6L3LT2HbdJTGq8qSXZp
         4kSrffaJYwamL9uG9sjucr5dBqCK5lRoYnUK51evN+4NYs8tXyzLzpzpVe/IfOrl/pNQ
         3IFLa9O6hUEKUpKf+v9nOJJHxeddIrDEWPpSrHW8EtjYLOMcRuOznBpF+OdVps/xBub6
         35iYw7klyktkUG7mGzkkYRZJMUGWhap9j9nl6JAQ7GeCgQIf0aWZfg46qBGPHMg+geeW
         XVkGqsUVwA8FEAOS6JAWQG/+fMIgxdaHY4Ysd0PwBI47yjY0FOogB77cIEqGmWPD7gqK
         QPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWM09HZaSutskN9VhZT2gnXHE5Yrnc/L+IDw+O5JzuS0p5kZAeujjUKoNg5W8xs2nT/RA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZmsQqqJMtatdHO1CsDBcrUXEX7W/QXHfSIslvNNHv6tGcE2aO
	k+vImxgzxR1wfnDuwhBNZSByLOifmga7FmGM73luYHG+77zLzvcn5miTkODwF+k9wfY=
X-Gm-Gg: ASbGncsd/N7y6+D2puRjOiF+ivcElYtUVqTR98NNeXo/3MRzkx58OykQ0fgBeTSu+EU
	q17vSgxAFVa4vy7c6oN4hHEPomd99ZMKs28uZcFzvYcJRykyA7C/geaYrbnbuHeG8oPLq9bD8MC
	ruOyln4ZBGD7M3r3ebnxWFEeMbQ9E17bYK21gm/nkRN5nYdtEbXK4rws1oyjEBLbhGqkBxEBXjF
	taCv1kbD7LPqkyMxPPiGu0fAqUdGtU+a/pFe/el5JGxTSdBW+kSk72ndryumfWaBVU2HuVsK3YO
	SuVWoJlqN1nu637YM0WSaLt8PXTYC6T+VGjfukSTtPg4ikonlQc4aaxWRQmZQGjwtkLt0bLP5Bz
	qT2S3/NI4X7M=
X-Google-Smtp-Source: AGHT+IFNM5ZpiX2WKqQdPL7BOWUOxixS1vmuU5TwVG3w0N1duZ8jC9VD+EDPeCfYp4SAphhNgUesZw==
X-Received: by 2002:a05:6000:2307:b0:3b3:bd27:f2ab with SMTP id ffacd0b85a97d-3b3bd27faa0mr1140102f8f.5.1751540221194;
        Thu, 03 Jul 2025 03:57:01 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454aa3d7455sm20870755e9.5.2025.07.03.03.57.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:00 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 15/69] accel/kvm: Directly pass KVMState argument to do_kvm_create_vm()
Date: Thu,  3 Jul 2025 12:54:41 +0200
Message-ID: <20250703105540.67664-16-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
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


