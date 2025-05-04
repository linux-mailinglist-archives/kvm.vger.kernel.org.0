Return-Path: <kvm+bounces-45328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DD7AA8414
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D055C17A0D9
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795811C9B9B;
	Sun,  4 May 2025 05:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KeHETUqp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329651C3BFC
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336592; cv=none; b=p4srmqu5CTDpkAmRhPfbqcce0V0N/fz9aKa+vc7ONjVpTG4gaOM7CfSdOz3kJcP3b2CD2xofhLMreKdS4YdGPZaAvd8wl3Gb2ObHfWBybmb9YRf1GgwFZB+TYrO6xhMxvZ8Zz2osy1Vlt+gRHF6+3SkLOgCAZWpTXU6ytAuTrvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336592; c=relaxed/simple;
	bh=JFv4YlTrDm1SIM/o00YgUrqEFpXOxh+2IWOwbnFpb2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pzpj7ljJlRKWYRakwHnvI28NTMTx023d5vK1x9O5+9ImuZrrNkMu0lawBx17sMVMEXE41YudzvjUF1xHgJgFNCkdQ1FNToPVbb31jsGE7P9w1v7uTuJ6bIrxrR/L79XXCHg0qCW+jbU2Hv1/DmKV4Hz2PF1MPNwMLxTKIrcFO3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KeHETUqp; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2279915e06eso36888735ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336591; x=1746941391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=KeHETUqpgzqXFjMda6GApgHmVU7VaTOXkgdYJXnXishPuBG9DcFEgdz4TYz9rXI3dS
         3htoW4HYKv+2X9LaBWA0dmhYOsWzCIgYT5ojuWiCcmbmeMRrddxRu5RqfBq+tTpLh/Cf
         /JxlfZ4AyvGRIqVGEer3oWa922mc536bDObAuWiRQFGyAfYzt24K0yshmMLemJ69xeVA
         P/cHJNWVHINxJXjcvpnVQKNXz2Y8kDip1E7O5MaZUfkkLj1+vb8NnCFZ+pxTuq/5WOv+
         5oo11IO7t/PXbnu0UAHxNqQKQ5xOgIEBl3iIEJrLEHYl7styi3eyCMOTO0JEXd4LQ2KD
         EL0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336591; x=1746941391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXLXuVNGEyfjK9Yd01QUJZvt/uyYRhxbr8cOAxNhYLE=;
        b=OPXQZpJz2SQ8Q/xLL9aN5JzfvHMh/Sh81I7WyM0Jjn6k3loK7mM6u8UPQ4Tmp03oN2
         ySanZSKgenX1k99vc5+jA0tce5Cl55pUIIiJaJtSGXMVdUpaS5ms5SA5SNU7K8jjJ1oz
         NPK9u9SPvRk4x0vCf7lZsZEXJavhp5xGmK2K5MW9N4IRvAvVLr+Reuo5zHva9qODp3XJ
         HUU2Il6/rIBHEn6rcdGuAhThNMqWlSpx85T1xmabzOlQ0VyyYol+y7pbjWtAKGNB1TvZ
         7lxK+eTvKS2tiCjaBgD4u04RMX9SyUdi/li8vScqRcAPLDHCcCofr9jL3SHsgU/IBFPm
         MixQ==
X-Forwarded-Encrypted: i=1; AJvYcCV87AHzWLusZm/2KCu6+tz+htvNjSUhkDqxqXW1dISgm2oklcdBVhH/LJAahaHL1+1aP+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPQC/RqFuW3oJ3NsUoUdOZwymI2zSWZ1fLBNKFcYJ57MqrALm5
	Xd08rbGT2ZiLGfqM53wYWF/IRK8W57aW1AKIshzH10UCd73WkoP5bQn5lllobUs=
X-Gm-Gg: ASbGncu7W41BWrQv8mbN/LH0IMVEQf8wm4tJWVw7DDMITFjkyl+C9M+tJVJ9gqNtKcE
	vpdIcH3MzrgaFMXYIBGOnfCx4JjF+6JW3L9LGNVBKKfWin0FZytV73DIvhJbIjSJafIKqoGOxHL
	3dvio+DnVZNblc+64GBjWuKKFk7S7CoFccuM3ut8qUCHfhGb6Yg8VABTTec8I3dMD5yLBiTMlxe
	paMD3r2j5n26WlN0n8vEMHFWslb8RkflSm4wXho09uQcFHMe4l6P1fYfOJ+WUp2j60lr8+8jW+d
	Rm0barlznuRhIGnYaWMRZ7MH1MQIq+0xHmt8avbY
X-Google-Smtp-Source: AGHT+IEw7LdFolSK1L01aWRSXu0ZYhSFBV06ZwXjbG/l61w2CauR9M4H+Y+brnPiGKAodZUYp8tXtg==
X-Received: by 2002:a17:903:19eb:b0:224:1eab:97b2 with SMTP id d9443c01a7336-22e1ec3e7c7mr45995215ad.53.1746336590793;
        Sat, 03 May 2025 22:29:50 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:50 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 35/40] target/arm/kvm-stub: compile file once (system)
Date: Sat,  3 May 2025 22:29:09 -0700
Message-ID: <20250504052914.3525365-36-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 29a36fb3c5e..bb1c09676d5 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,7 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
-arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
@@ -32,6 +32,7 @@ arm_user_ss.add(files(
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
-- 
2.47.2


