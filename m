Return-Path: <kvm+bounces-45513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA78AAAD5C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FBCD4C2FD0
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213E63ED7F7;
	Mon,  5 May 2025 23:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="idSAaXrh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9C13B2F73
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487254; cv=none; b=Tc3NVbQBHQ1AKFERT8UTeIyF+LaHKTHdecofNo9dZ+6AFSP19qAeZuoouekH+ZptRSivAsPSNOw9IOoYIs27mnu5PqLRfE2sc4GLgZTkWqjxwmzbLqry6Uxk7GSsEBmMz/U895eRnLlqvFtqpfB/Fb/lSNGJV0PjzV/ozXBtCY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487254; c=relaxed/simple;
	bh=3RsKZ1Pgza19E1HBaBnLbv5wQ1rc1mFEhHbZHJJ5Hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmFhiyujmX8a4RKzsPs9tjt7K9c0r0jlT4xLhZBBhN7F9fsGbqWCLuMftjFwNFQ19UDou3cyVZ7PoukXyFoFrYkTo9+DmGU8IHcAa5B4zU06FECBLY0IWWEnD52TwY8VFPoW/Uxx35/uvpdveL2hhfTQhoW7nuUdEDXwSHEpYhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=idSAaXrh; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-227b828de00so57592425ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487250; x=1747092050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=idSAaXrhnG7AXtCizARZq0aYxIynSd9xIJbMsn5jfqFopZNNs13OXzWKhO3TAmAP72
         LqDcToh0lbASg5x0uC40VilMlw9b+JiOniA6b6iJGwvkMrUyZA4fHrmQvgpUb3sJKOz0
         F/sw4bxCxNvuHHnOt7YyS+v+SHJHDMH8YCk0N+FYtNcMUjrEJ9pxaQjxhe/JiZe7XVMx
         StmHZqfBu1f+hEAm5o4sGhcvcateIu/yQaexjMAxHR3Iyxf4sc8NnZhsdZQsNKOmCuzg
         LgmK+JQTY0dPyAodoUGsHixnpxbfYZ44EfaoVptvJTpQPRQ5OPbra5eDlN8OnUBbQecB
         R3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487250; x=1747092050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=X7PUdCaWWRZtxZ2m0BnrpLL9ETVHsRzfm53SRuYEj+X9mDkNUZvxEvYD0pvIH3GiYL
         0b7t1g80zdML6CRhtYcEUDGP1DDU5BkNXgB1rdiYJyEcj5JYVBcFoSIBBEjl9fa6B7ON
         p8IMCisTM9G2kan+jHGgk+TDFir7gvPLJHKcVgRnPRawL/gfGLz3kjkGl2Bv6bBWtDkR
         05AIrsXoLzJlWgwbn18cC5jAcQTT+S+5B8bI/6XhTT23wV8TgecyJSeZHc29EgKVRuby
         9nddWqY8ApnbZVFYKgguW5leD+2+ZMAt4OxgCXzlznvBnxC3RtCebZFRcl6ip8czQ4Ht
         hT5A==
X-Forwarded-Encrypted: i=1; AJvYcCUihF49FqXtzDAN/qD3Rtpg0PGYVN3r88mwlEBQ3xikoGyysRg0AG3Dv4wNqNvgOr7/x3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzacZyXrjvbrMDTElAJJT2Loagwpy2/TZpZhcTBpxhXfZRMvLN9
	oE6el5XBm4u77iYqXyq4weYXLH2LEVNC89kg3oH5uS4gdK6RNMY2/TUmDZGL13EJJK0iVUSqWm1
	3G/c=
X-Gm-Gg: ASbGncsdtPSZvn5Q1M3vCPngbWrStCVUqvQz9RQ/8PNsaoFmgK1/tzP9ksWMNqzPdJH
	f1oFP9hzKJydw0PHItclk1j7Ml6mR+gSIThHYoX/NiKuJ5I7pq18fqU6gcSgJFR8EScxR4xxmBW
	ytqHkcrbm167YI3tFD2439xAjXNcO/JtNqZCDYA1fdk9YN/4VZwlJ3Cvc6Ey2j7gnryAsvamVQr
	g6lkHmQ/T2swo7ZAEJLOkGciUQmVTptMg9GWGYtlMoj+6v4WOnkXnGpEn1m/F7qrvgHalNcEhD+
	1h83PbMgkwui+UOid3QRqmY0vB3bCcB+8Xb9/mYc
X-Google-Smtp-Source: AGHT+IFVn+o02q7YLHYWbNJDn25BoizahTDh5kkjLLSkKyaYVzM3AQo7VDnS2nKlNPl290g0JQUCiw==
X-Received: by 2002:a17:902:e752:b0:21f:4c8b:c4de with SMTP id d9443c01a7336-22e363b5382mr9664615ad.42.1746487250712;
        Mon, 05 May 2025 16:20:50 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:50 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 34/50] target/arm/meson: accelerator files are not needed in user mode
Date: Mon,  5 May 2025 16:19:59 -0700
Message-ID: <20250505232015.130990-35-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 151184da71c..29a36fb3c5e 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -5,9 +5,6 @@ arm_ss.add(files(
 ))
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
-arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c'))
@@ -18,6 +15,8 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
-- 
2.47.2


