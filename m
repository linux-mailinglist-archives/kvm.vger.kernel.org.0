Return-Path: <kvm+bounces-50087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4798AE1BA8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6947E1C2098F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C86629ACE6;
	Fri, 20 Jun 2025 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q4v2Q5at"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A166E29AAF0
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424947; cv=none; b=FKQb9l7wMt4fFGs0JDcw5H4DKiJyc2lYGNCG/MSNv+SsX15ng2Hgpc+yVEbxQ8QPFXbrNNA2NlCDx3boklFII7Xn1OZszE/SfeLV/CBTOT1AsEE2cSu9PTMeEhT+c4E7fcde1wke4UgAoafHRKLA3hfcc2t4p8T3BdT6m3emT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424947; c=relaxed/simple;
	bh=azX8GAyIJEKy8HRPNAKoeinWDh25+oBDKSQcGmjkIi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLIa6bi0YshMUiw4Zygtt6bKyjZHIV0vzquGEhCVUSoRnGxw5kDhcTEYIYDabNqBk7q0f2TM3jA0Fumtb8mQC9rYf4E1VQGZp5DmwHVt8K3XIfjReo9Mosy5RJcWRmcZWJIt4TherPvFB7OgiT1QELwd5+gzGcvLcwwdv1MqUWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q4v2Q5at; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a52874d593so1761688f8f.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424944; x=1751029744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKb7+45W8wr+DNWypSxWBKVEj0bAIAzVgg/1Er2vy8s=;
        b=Q4v2Q5atEbtGr+Dl+Zl5zfVH/Fp3xa6uKMbLBQ9LZ//hu5U5KIbEOsEj13kM8LucMP
         pAlt3pYiorNbbZIQkJbiwQGO8+twRAlH3CEmckPkzwK8D4C02MY8+/zZS11N3B27Bi99
         6At8jBNsZJt29UoNKnVOO1iTGeHCsMRCbleQf4iet/9Lsi5uJOk6XYpi4hQG8F3H7znT
         YUSMxXZWgVJgeL4C+lOrN6mvUgjzWs/58ie+K6PFcxY4qBcy3jLv8kmSgu1BF5pk0ma/
         WspDrtvMBkayeViiKhJ2e+IEH5bDni00EOhYxqyaXrws4s7PulfnLmhN9/mCQwfIdm/w
         OH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424944; x=1751029744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jKb7+45W8wr+DNWypSxWBKVEj0bAIAzVgg/1Er2vy8s=;
        b=BFU2h81EeMepWd2LKm9r9hIZgRGm70LWfwMWXsZXubcEEF/UG4JWtnbfLFQKjP6+nk
         tz0r5iCKwxCWo70UOI4w004UkrfHPoxvLred75gkmEYNqLkWssqWDDHmZV+2nM/U4Ev9
         P6cRN5BxDQ/WlumeGk6XzCTaeNRYCXZF97pz/HAXJOprD/ofxvFdnwiUvVMpBW7/94PR
         0ElgZUoMjz3I1hvi40DdB6uWC0F3KbB7RF2iOT3AAA48GpLpmt60BSSsuOhkRC/96SMS
         JaUAJ0WgyB/6w7SSLSKrwLOataS28PTZJcN/bjvm5GSzmALosCajzfYQzEkL4cpeTfiv
         wIpA==
X-Forwarded-Encrypted: i=1; AJvYcCV9o8EY5QCSBsIZUAtuhoGJrDIkWK6djvi1BB/RfhOfiNLaIXXJZWbtE5h3uCxhDQ3j+/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxudw0aCkDhQuIYjFO8Z1lIoBn6ckcu4jNSTSBegWNsXXI16oON
	Q6ZtMdildfiSt/8hsmsCTj7zrrxCRaKwIBR4utlfsarCW3plqZRdlhk9TG21Gz9eiAQ=
X-Gm-Gg: ASbGncvFrjoA+LGRluqSbHENeqKeuWoA0RrnujOwzE5Dg8hIUKcqbly0Y8MNY/lVZJO
	7VG0fg5qV4e5IJgBsLuKo3BjbqfX0oTUFWemN/6BVAt4H6lCmriUStpAeUCJV91KqiF8O2CdPMD
	U3mGVcCGTmYi6JhiA2D9H+cwovozQeHzAQlE3DFCv2sjhvCmBOiGArAcyL9ufI6ph7ZEmpyKQAQ
	dYpKh6on58iA6dyXjCrIJjZuIcvjF7haG4f+JJR0AUQbOGvo8GZrhZRrq8vrWKjOkPfSOtsKWND
	ng/TShM067UOzA53AC68kuO4BY2hcRvgaAmjAq0LqzmsH5RHz6YNNcQVVmCM85dsl6JZEQQ/d9Z
	tdiqNPUcl3EZmVIFZiZ9Ddyo2ETO6+MC+H5PN
X-Google-Smtp-Source: AGHT+IGU/PISgWAUAam3cXO827+5Gf2StC7Q8MM7jO79fbKmCjBYcioqe0LeMR+lxX2cddMN2HDweA==
X-Received: by 2002:a05:6000:4109:b0:3a4:eb7a:2cda with SMTP id ffacd0b85a97d-3a6d13071ddmr2045022f8f.30.1750424944090;
        Fri, 20 Jun 2025 06:09:04 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f1ac5asm2117585f8f.33.2025.06.20.06.09.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:03 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 20/26] hw/arm/virt: Only require TCG || QTest to use virtualization extension
Date: Fri, 20 Jun 2025 15:07:03 +0200
Message-ID: <20250620130709.31073-21-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We can not start in EL2 / EL3 with anything but TCG (or QTest);
whether KVM or HVF are used is not relevant.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/arm/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b49d8579161..a9099570faa 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2210,7 +2210,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->virt && (kvm_enabled() || hvf_enabled())) {
+    if (vms->virt && !tcg_enabled() && !qtest_enabled()) {
         error_report("mach-virt: %s does not support providing "
                      "Virtualization extensions to the guest CPU",
                      current_accel_name());
-- 
2.49.0


