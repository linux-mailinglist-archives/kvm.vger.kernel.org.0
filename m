Return-Path: <kvm+bounces-45365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A031AA8AC7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D864167E99
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDC61C84C5;
	Mon,  5 May 2025 01:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k3nXVAp1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEBA1C5D53
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409967; cv=none; b=I25eZTWKFvzCfgus4tCnfYYIrs0Ld2v2aDOESQtCKupLU51iUnGoZOaUkwAPP2vwB4QeQdWrsuwE5kMCeuxVEt8zQA6GOGtMgEgUzGQvuZSV9OazYecrCq4bTROoxk8TbI0YL36Wr/taf0hW6IO9yjiL4HkdmWrWOJh4PSnUpoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409967; c=relaxed/simple;
	bh=6eg1WWrFLrfY5Gs8TGczDifr0kodUvtUH3+j4IU8lnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTIYpHmWiozWk/eACH9tQT0orA6fmTWozO0d13RCZMhbnEVzT0PJjKgr7ilpNak1Htk/iMt4PLO9wbOo/w9VebrmxWUu1G6ErnC5D0J8HLd33mB+dL+plcnA47ESsrB8CX6epeHp8xubms90ORO10YVZUoWMF5piqQz/16C+9Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k3nXVAp1; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so3816213a12.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409965; x=1747014765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=k3nXVAp1Mwlf6ZsYpt4oSmwPgn56kem8lb7C2nIHV5mcVPsLZu/WWJ3UNucBAsE2M1
         MG7WenC7JOX7s63uJeenGp5vyRNMwwn8DECP5ev8Rq926rHMh4MWZgYkuxPE1PbHpPnL
         xlw3UEoWP40cSfPiMLFFvykjfZV4X78bVRxNyYPXEPv9iSP9Ny1KP4QA+XJl8fD9YxwQ
         RvI+byBMWTMPhlIaGOTKi4RrRCoFBqYImA9cnib5L0HQRHBJ/Vz+FFvg3Dw9CjCqclZi
         U71iR0dmFFfcjgei6A4LWQdU7H4cDaK6XNmiZp4MC4GBfNHaCeVHFXgITEwgTCaMop31
         IQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409965; x=1747014765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=uojN3x/FSUQkZJEVPwPR8bOvyOiH6UyLTkFFqKoDJ69wv9sNrMBu89ngvv9EAXowGJ
         C0/9X4nyqWRTaHjYm8k6w9M+q7e18/iNaU1xZSMbRbjSurkcRz0MSlP+rVfn48+5V/DM
         hqrApP1mVw3Hh7wQlrJWrrJ3aknZt6lnMnJP+88kmTWrpqUH2uS7DxFZ4iNUzZ1PecHL
         Kqx8SKIN2DnjM8BZE7QQN4jN9qtZ2KnIJe3YJdVmYq0t1r3sKppuwM4NzU214bAkOrki
         COMH2Sz3lQu3X2wqZFJZuNZVLWALa77/oPJJR/+vE585mqCObOhzS1/Z/+/tzMHVwbN4
         m5Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWuwhqb85rlsKduL6Td+OvBZPF+/1fR75nn7xfC+Z3ijBPC1U5b7JSOveVcDrGt3u7yYZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzjcUs6b56DuufoBte/+Z/G0NsE6D1+0KhL/h95JK17syIqHMw
	uMDDr319kEIERV4fHDFrm/6nIlNEyhmBb5aN30enGOdYXIuBfUyXhn6MR6vdIPg=
X-Gm-Gg: ASbGncuTAs9qT/uZvXHxjNlGw7mahp93SDKo/9fOH3IKvQDiAfOfUShV+JjIB6hNjSD
	4mt+p9MPEQjkwJhiqkVB+P2hqUuJY4JbW0uzzRQjuXmZdk3WYx900ic5Czy4wvoUK7A+3fDMool
	suamziveCTLkPnISR4Uze3H7tOaXNKl2DJ1iw5LAPl88OQkc6FFBDSR1iG0r4Wl+ewS/0n3SHaC
	uq5iCYvu4OQRUGAw8Pc/+7TqYMC2rj+wWHhzQqPUqneS38vZDd+YEjI+0DBWEVKkY63PEdEirSg
	2JA6D3cwUle9bU8niRnbDAG9+Y2MXLrkxLSJ76/o
X-Google-Smtp-Source: AGHT+IEdEQhyDtvpOmBsbLxVZ35ACEJ8Qp3GYlqIZlG1XakJNo2D3KbXjIylsJzSXoYN2mahc1rK+Q==
X-Received: by 2002:a05:6a21:31c7:b0:1f5:889c:3cbd with SMTP id adf61e73a8af0-20e078fc982mr11730268637.35.1746409965255;
        Sun, 04 May 2025 18:52:45 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 19/48] target/arm/debug_helper: remove target_ulong
Date: Sun,  4 May 2025 18:51:54 -0700
Message-ID: <20250505015223.3895275-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 357bc2141ae..50ef5618f51 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    target_ulong pc;
+    vaddr pc;
     int n;
 
     /*
-- 
2.47.2


