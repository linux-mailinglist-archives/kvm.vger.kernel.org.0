Return-Path: <kvm+bounces-50090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0C7AE1BAE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E04F71C20675
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4920728F930;
	Fri, 20 Jun 2025 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PK1LP3Ko"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CED28DF41
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424965; cv=none; b=O5dJl4pof6viuNt0blsg8POs+FjC1d4EfANDKb6BM92C0Y7uY+AmxLtY9KXOSqg8aiNtr04LK+oJ+Nok01Q5ovhiy7Fp5ite7oCLpWjljXtGP+jhwM9O98rCyOK/fN2+KiDuwhrHj8aoBIS7ks0IJ/z88OXolaD7uj515h1FJ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424965; c=relaxed/simple;
	bh=brvMu5FdUWRVrvn9P0CWHiseUEdQgKlmqYXGnGAVwTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqAul4r0wn2PnzNmRGk21c6yYBctUk86FaED6ps0uYmSHhD6QeZxnExkT2K7/Ycf3hT0ylB8JE3Y8VN1XY5D56I7l0M7aGA1vH3qeposZk5sN9JhIL4siDEqkbiFiSZiE4rYWeyg7tbOvBhP+UY6lA8XcmCrYHXZT5xAF98OKFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PK1LP3Ko; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-450dd065828so13314755e9.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424962; x=1751029762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V640ljTD2H/6yk77CGg8pqgiDQ7Rk/byXNy/qGehgeE=;
        b=PK1LP3Ko9MtpQ6bh7lLsUkOTHN/b4CeZS6ceKqiSN0IbuqdYxPgoyGhksoc7JoRufW
         tYZLg5lbTBQVovW9bYTk7agW5LtShAmh+ysKehqtUdufrnV/rgb0FrtxP21a3SF+J5B8
         94e3AD0XTDoDRGg5H/vYi+EPrwSmwVKDcummWV/zOHrgdFEa55/ST/8T7jOv0YUbWjBR
         wSbvbavkWNhUog6wL5d5i3buyeEL1nEBqFaZHMDClensAGxo4UQDgKfzL1QXJyIjXo+b
         DyDBADuZCSkEEWTrSlZg8MC3+FYUE+t7paOvEcC54YCyo390Xce700CSZM758XlRlg76
         b/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424962; x=1751029762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V640ljTD2H/6yk77CGg8pqgiDQ7Rk/byXNy/qGehgeE=;
        b=g6coJqfiJHPSSA6j1xHcaWq1bTGP6owVmt/KO89+dDKIfpAadkn25D7t3JRc3aKtsM
         geXAhJh4WAoATDmdc8eQjYJhwo9ygt8w0WCXVu7nixfcas2GdqlboJEbCqjLOFY/9OhD
         +yaHw7ovi4Qpuwp8dgozUzG+OZ6B1KAI4DDaPTIY/mNeUrv4lGE2PgXfoJT14yYef00o
         2gPXbquEyOiRyc4IGn03fyp7sSeXuGOq/tsQm1wdcWS1smuP10zjOQqT3kudsU2Bam6h
         fXUnqwauQnXzdrS6xoeGgF7xWtYh0bprt9W8+adaFVMz+iewPAuaUUEbFe130Px2jpvu
         6j8w==
X-Forwarded-Encrypted: i=1; AJvYcCXXDQgM+ZUpgQcTjr2LEyQ6RYEPkJmGrwhcwcTnmEvSYtweNhEgsS5xSBAZ5bwnB1/2ytM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeX8z1/tnoDvZARo0bJzduMJdoTulygYhfB3wQGYIJevtSa5mH
	mq3wArbTqk8/aoxSvJuB9/m8lJ5eRgC7zX0NGCts8pmgYm8SxDAAByJlh06QHz7E5Kg=
X-Gm-Gg: ASbGncsWbxh1gg6w9b1x674uvXR17kNN26dBwk2MPVWuK1eQycbQsIkaxoMINBY8X3/
	GkWpQ3Yz+QPC2pE4042kqzu/mRuxUkLPhAD/iZ1fKNRORSS6cTV2fwsnFU2ZHvBbsIFYOZ3VSt0
	/0c80GQKG8BNv7PNr5I3QmBSzyyJJk7+trkSRm6AgDVmFcCktIjbaekAJwKGpHoidtTmAccEooz
	7WmCtOUsV2UTqBURbsynukyiOFy3qPjShb/lFXARcrue8gQNN1OEXHD0XfX7Litq1gUsqEi9sWi
	jtB2iYdqWvOjqbZ7dZxSNWVetEsbt/YIR0GIktiUiSV4YDK1uEcGbAxUTntMbHdGExyzrayl7Lo
	Rq0OUD7STfDzNK4LiI/j9/4dP3Zw+cyQb9qOB
X-Google-Smtp-Source: AGHT+IGgGpF8T6F/eU2syTxh0rLMvaVCXrLMi432W+jy74ylNB4a4nTNwHJAEpagSMq8fk2NTIgxGQ==
X-Received: by 2002:a05:6000:65a:b0:3a6:d579:b78e with SMTP id ffacd0b85a97d-3a6d579b7f8mr393678f8f.46.1750424962155;
        Fri, 20 Jun 2025 06:09:22 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646dc66fsm24808055e9.18.2025.06.20.06.09.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:21 -0700 (PDT)
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
Subject: [PATCH v2 23/26] tests/functional: Restrict nexted Aarch64 Xen test to TCG
Date: Fri, 20 Jun 2025 15:07:06 +0200
Message-ID: <20250620130709.31073-24-philmd@linaro.org>
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

On macOS this test fails:

  qemu-system-aarch64: mach-virt: HVF does not support providing Virtualization extensions to the guest CPU

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 tests/functional/test_aarch64_xen.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/functional/test_aarch64_xen.py b/tests/functional/test_aarch64_xen.py
index 339904221b0..261d796540d 100755
--- a/tests/functional/test_aarch64_xen.py
+++ b/tests/functional/test_aarch64_xen.py
@@ -33,6 +33,7 @@ def launch_xen(self, xen_path):
         """
         Launch Xen with a dom0 guest kernel
         """
+        self.require_accelerator("tcg") # virtualization=on
         self.set_machine('virt')
         self.cpu = "cortex-a57"
         self.kernel_path = self.ASSET_KERNEL.fetch()
-- 
2.49.0


