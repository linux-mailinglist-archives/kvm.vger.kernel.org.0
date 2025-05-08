Return-Path: <kvm+bounces-45881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE984AAFBD1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2592CB2437D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5BF84D13;
	Thu,  8 May 2025 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f9QiGuua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134D22CBE4
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711835; cv=none; b=BgOrmtOSe+ctBRR7RpP1ANA0k0jB0pjcWHVtTG0+NgOfzF4dYGRWbFC3uSyDmWrLOkJocyCzS3kTMKyGtf8/fxlQsAwI5CFpumAG7SpzWbA9iV94ilXMvHAKSPKVH4Cp0lva13/ulMDVJ6p6Jbs1Q1zGsftV6uQ2+Jf6wqJOYCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711835; c=relaxed/simple;
	bh=gPkwhCaD1a6EmQ9w51OEcrO2iMjnxafo6wMU+dhcrhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSr/SoENAovN3xYw0yvmQB/BmX1fPCso05a3tpdSETTHeM8i1ms28ehh5zGBSo57vfba42d/Bg68/sLUdDKX3dCCQ+NwoAdRY4SWX0EI+xOO65AoA0m1eVmuJrwucaTvb1+oayShU02YtZPBZfPLOpeYHCB3GQwVUfS1hw2q/Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f9QiGuua; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-736aaeed234so902593b3a.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711832; x=1747316632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iz56OqXDxt7nqC4LwA+a7OYiuZlEyLYttSp20fJi6+I=;
        b=f9QiGuuaSXQWC7nIfiLgGELrfhkxJ7wVt3VneG/2jbLag3umZgOV+QrJUJMySk2QWy
         pQ2aBXc/OKW5FeS8revqS8C+TVIVQNNwYI4SRjBEED4cDdvQ0IGRx4WO39iM2rM8Hz2z
         CQ68KYDRQXsBCqclFWeSRPQ9yqnTr7iCUERiYHK8y47u7aJjQEGTedqpYPPA2CmNR0NM
         tWRYlfD+d6Eu1mYhNgnZERnzCtn4gzSH9E6JXIve7ITwkg4adSmrmMwsrXYVQtS9pCwc
         4C33woFuPCcg4ZVy3Tii4QDO8aDLBxL5/fVM01a4Lepv9VJexFHL/9LLiFg3MA0uRlBy
         JcMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711832; x=1747316632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iz56OqXDxt7nqC4LwA+a7OYiuZlEyLYttSp20fJi6+I=;
        b=LVufcb5bLa1QkSnx8oujjp+2AAw9Bij/acUpJSvrGV0NZBAkPubmQCoX7/4s7i3bwe
         5wfg1gzrTo2FGjG4gdEHFN2bx48L39/SEZ4HcIxZuXoXsdUhz/55EKNLJc9lIXp8WkZc
         YTXh9Z7U5mu1A9CoD9lMSWddNpTBe9Y1bY3V4A29XNTESDOVoZI+3+2bLxC+jYspKy8w
         3lCwFE0Ox8yZm6lpx/aBhPQ8WHk1i4fw4Sz7swEC0Bucm76tFJKX4nYpqN1/DkjeyPue
         f6afVIl/KpBRWecTWjPaLFTq6SfECOgRYCnjhuuzolvDFe41cuGmkkEsxoDNEuDs/DqA
         CxvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK/M/Y/Jn+ONXILgPH+vv96SSxlCetPq8SrVixRgfaSrhcRU4yPJdAtG0biqV52cr1SJs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Xzv8/+Em9MOc6KpR87XOHQBSPZCSB39XxM2gC3CeSSFHzKR3
	Wc7sSWVsxM+1mQp58msTYmzcTFQEnEG813h/+HSK8kTlaDrGuiFQMsaK33kZDIk=
X-Gm-Gg: ASbGncsIoIuOx4cXZmp1ktvfg3l1+NlGb1mlasY1waGkjKLuHmCKzepbFODhRZgVB9B
	SCuO5zf6wLMG35YHWa+CoEpgaWDa4HaAUk9HUau7Tdnd6iIKsxtmCyCoT/p2ul6WkeayOu1NUR0
	EkpbOWga05eufEsUzUMYfutqno1U/aSeb0OTl46Z1b6PWEFTXEXohszcDfINUxRlNRsccC1XVKy
	L7pEr+u9UNn3Sdla0MNqV/0o3Wc2cHIAbtJQN/qm+ZuW6zywkVGWmSNt7ZYNrSTGG+qb5omat9o
	Q1Gm3E2B5qxCPtaERqyLzeIF+FO11pFt5BwIDQ746O+2tPu2I3LgHxeE7mCi8dc9M7CiaPW5suz
	fS+QIXPoyVydpxnA=
X-Google-Smtp-Source: AGHT+IHYW6laMjiHc6hZ9CXPvMKDRBiIggZW6kdWUwxA5qsOS+e0Hn9w40Bkb0wK958QO+bMwwTmhQ==
X-Received: by 2002:a05:6a00:418d:b0:736:4e0a:7e82 with SMTP id d2e1a72fcca58-740a99ab539mr4600433b3a.10.1746711832328;
        Thu, 08 May 2025 06:43:52 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405902154dsm13751300b3a.90.2025.05.08.06.43.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:43:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v4 21/27] hw/audio/pcspk: Remove PCSpkState::migrate field
Date: Thu,  8 May 2025 15:35:44 +0200
Message-ID: <20250508133550.81391-22-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The PCSpkState::migrate boolean was only set in the
pc_compat_2_7[] array, via the 'migrate=off' property.
We removed all machines using that array, lets remove
that property, simplifying vmstate_spk[].

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 hw/audio/pcspk.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/hw/audio/pcspk.c b/hw/audio/pcspk.c
index a419161b5b1..0e83ba0bf73 100644
--- a/hw/audio/pcspk.c
+++ b/hw/audio/pcspk.c
@@ -56,7 +56,6 @@ struct PCSpkState {
     unsigned int play_pos;
     uint8_t data_on;
     uint8_t dummy_refresh_clock;
-    bool migrate;
 };
 
 static const char *s_spk = "pcspk";
@@ -196,18 +195,10 @@ static void pcspk_realizefn(DeviceState *dev, Error **errp)
     pcspk_state = s;
 }
 
-static bool migrate_needed(void *opaque)
-{
-    PCSpkState *s = opaque;
-
-    return s->migrate;
-}
-
 static const VMStateDescription vmstate_spk = {
     .name = "pcspk",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = migrate_needed,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT8(data_on, PCSpkState),
         VMSTATE_UINT8(dummy_refresh_clock, PCSpkState),
@@ -218,7 +209,6 @@ static const VMStateDescription vmstate_spk = {
 static const Property pcspk_properties[] = {
     DEFINE_AUDIO_PROPERTIES(PCSpkState, card),
     DEFINE_PROP_UINT32("iobase", PCSpkState, iobase,  0x61),
-    DEFINE_PROP_BOOL("migrate", PCSpkState, migrate,  true),
 };
 
 static void pcspk_class_initfn(ObjectClass *klass, const void *data)
-- 
2.47.1


