Return-Path: <kvm+bounces-41977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98001A7060E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16053A8C61
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A1B25A2C0;
	Tue, 25 Mar 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kIjY3phS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC0E18DB0C
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918873; cv=none; b=icphnNYgi4XBJpxNMeStD51bJ5qIvBNQ8JlIqZQXazVC+2XubupizW2RJUWyPKiyb2u/ld+ofNl68wR2DHW4ly1Afv0CyaaY998jSpwmbT7GCPURgAiGcv77esmH2qXVMFHPEOfZ0e7YbPAC2rBaPkFU8vVUWwPTXzHX+hBk9vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918873; c=relaxed/simple;
	bh=Mjz+dmxCYSCza0clR0zsI/0WXyyGJEvEQrlUQgo2L9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufy4pt7R7ElPtKIb/jHPFDBDLIgwjXVgIdRkJC6Y4dbrNu3G5bZMtFGSoUezgAkQNpE+FcC5W4hBi7i0MgNU2Aj32NEAMtoijyNofRxIkxLO2N6vTilRFFn8F5hJ9WxNSZtjeIo5LGcHn60rDe6m1JEbMRAole4lPiC4ur7nMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kIjY3phS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cf257158fso39477735e9.2
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918870; x=1743523670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fK2tkGsZN3Ahq6Hp1U78FfDDer2UDSH1+xmbDUmwofs=;
        b=kIjY3phSb4UDIRQHWp0eof4jYXqbKIFufMyjpSR5+cn0VnRbSF/ysAp5tVe8Gx9N7j
         XrfA+3W3jfplt4pUjdS0O2FBhFJuCP6qquo8/c7K61Q94V/Eq6WEbI0zsN/cizFw+qGY
         qQEPB6SkW4T7vrWBWsPCoK22ll37+kc9GMmBPurjBQwEwVHqj4MG7nwxzRnDn4mmxB93
         RVVrjmOcvWU8DfQtn5vXPymgxn5/MbP+0E/XNavRAUpZJxS9endkhO7URABrNS/f00cP
         Q4hXppgYX7pl2KA09avAkJqciLdVZOWUfpOtR1aU2eFSySqKZzuXOpvCoaph/zDM5RJ/
         hwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918870; x=1743523670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fK2tkGsZN3Ahq6Hp1U78FfDDer2UDSH1+xmbDUmwofs=;
        b=qG8wj745fp8I2KOrfi8QIBPBBGAnmgOEMF7dWyThbhpqJJufnCeNmnaYEMtI8j6B8p
         wR8mvco3i16rMJ6swg3GuoE5UsCi6SxRrekk6+f2opToj9utdPp6tMKpo78JpM1wUmbl
         sja0d5zQfSSmNU8MV5VvQxSqSfthokCpEL8AYtsTODdbkGweH3+XnPqxhVJeP7Nz3c6c
         XYv0seRa5Lz1GXEwUQ5caJ1XOx5hdLa/b4MkhC6hjQlaUk5q4HapCZMp6Dp7ceqOpNjH
         HXiv98yEUYYPcVxyA3b7biMBzLeZbmKHhgBcHdT/7ecYvnvmtzeZ7i8l5KMm9EkU6Y4k
         dX+A==
X-Forwarded-Encrypted: i=1; AJvYcCUsC+nWfN7rtwwt9liV0VKTZvX/UjewoZ4Wc8z1vQKRPxZX0qi/PR+sGO4jS749ySyUX0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxbWC/86jJvW2QrnTImEo1fh4Ltd7KypvLeJxdfIEPk6vsMig+
	/XZdNPKKLFiGDRdpDLyMFnay7G6aEQhCnZYjjdK45Jnf4gAVpYpA34BHJyFeWL4=
X-Gm-Gg: ASbGnctWBhvF6pPhqm/pG54MHyUbWNViceUwgCEiZUyUaS+B2V0Tu5MLgBMJCW+7mDl
	LJ9IZivmdV4nFVPHsioILsd29Yk7ybVYj9lj0+oX1vMdE8gzUOUHsulf2/icPD6K1lbnkVpEwoI
	3GLbWr9dSCWOohBgN+aWf4sxfUH/Jy+llA2SQE4PM6t5QZwEwqdBo4yqXpfoFheYwKb6XDcHTBL
	EWnBLyfzm7/KuJzIdxo4Fzl3Zwf+29j5sfvZr8qkmPI64+mLf6ki8cZAfo9n2lGQE2viXpPRkJv
	yuNBcbvkA9N8dLYa1eE/WPpTH+zaoq3b62oaeDjbRIVT+eSPpgwVd5z8luJy8MCee/FzcB42lA=
	=
X-Google-Smtp-Source: AGHT+IGMPJ/vzfbmk0M4EXxA8yEhXdjHJu8uBAqrg18jftKydcKcsI8JHQeO/UcY0KzF+hRvMYRRpA==
X-Received: by 2002:a05:600c:1e8d:b0:43d:a90:9f1 with SMTP id 5b1f17b1804b1-43d509e64ccmr178534705e9.6.1742918870382;
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:50 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 1/5] configure: arm64: Don't display 'aarch64' as the default architecture
Date: Tue, 25 Mar 2025 16:00:29 +0000
Message-ID: <20250325160031.2390504-4-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

--arch=aarch64, intentional or not, has been supported since the initial
arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
"aarch64" does not show up in the list of supported architectures, but
it's displayed as the default architecture if doing ./configure --help
on an arm64 machine.

Keep everything consistent and make sure that the default value for
$arch is "arm64", but still allow --arch=aarch64, in case they are users
that use this configuration for kvm-unit-tests.

The help text for --arch changes from:

   --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

to:

    --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index 52904d3a..010c68ff 100755
--- a/configure
+++ b/configure
@@ -43,6 +43,7 @@ else
 fi
 
 usage() {
+    [ "$arch" = "aarch64" ] && arch="arm64"
     cat <<-EOF
 	Usage: $0 [options]
 
-- 
2.49.0


