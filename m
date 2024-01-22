Return-Path: <kvm+bounces-6549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B83D3836667
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7199F283C90
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8335E46537;
	Mon, 22 Jan 2024 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XMaeIYkD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1190741762
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935377; cv=none; b=aGBtZVcGkFN2RLbOtXQqpphnemNj0aGB048ww7XaDuGiJwmo7ZuaAOl677ffzp6RFNKvEHDTwNBevOsZhEqy35F0ryN/DcDcKJJ+aJNYQ2XqZqyDT0wEFSWG1tmBWnJCfSEjq0KPfFMM3O10QHKdAmrEEL8kY9EPv5Kfjiy2B3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935377; c=relaxed/simple;
	bh=mI3TAyIt8kZYgPFh+H/7nzvGA9PxGvn5qANDjkV0tOk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EB8u+VhsQ6GZJi6ugaHjVL1NeU+3MeSmc7MO2j92QuIFWtMkKWmXcSyLKRcSb8Tg23I2+xPGOP3mae/DnhzJLVTfksbL9iuEpLCNCBRuRErGBGR3t48F86OvYZ5iGdfwN3zz6spnlx1sS7zIXpfIOX/9aS5NBfw1iCvumr4u3Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XMaeIYkD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-337d90030bfso2867866f8f.2
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935374; x=1706540174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ622lHwVBog+czBBq32/xN+pBjDFyqMlLTTXp/L7FE=;
        b=XMaeIYkDGYvlBqNDLQ//m/VtMRJIh/Lt72e/vStMaZq8CVnj5O+tPkZSwcWTngGNr8
         3WbKW1I4bo3ib90LqK4OEg42VnJnz86d58BJUjVzIkaB/kKGbETG64/UeyzMR8WdVpA+
         1D9aBkdy5RaN7CJUXmaDljRaWdHgIHZ2fVB0iIoR+brQtNGxUER/DpHaBg2vAMW2ItNI
         yz4PQjY8rnZokNDNhdjr2xEMPCKkWX8oZlBvIMpmAahvBqOxEV0NnmCIIArHpb7ZQdNR
         q2W7vVDFd4bhA4coByrwq37BrBp4uIPgTWCQv+4h80Mc1tgqw+HDIgSC6IKfubGdiuIj
         ECxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935374; x=1706540174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BZ622lHwVBog+czBBq32/xN+pBjDFyqMlLTTXp/L7FE=;
        b=L4g3Gf4QxivXa0xvde9zP6XzuemCMBC8SsfPNkHry3WmQA/kGjSrQYG4i1PeGsK+pd
         TdkYqmRIOcRbRFlHpdKGs5H0bLzBnU5nGsVe7CuRpfITJV03KIkfy3EBG07RDRxLA1HF
         uzna9iw+g7G7d7oEN0I60sDhT4wqimzc5niIfIcGiTjRDm0q2G3KQkcxAG2/P3FqBTkE
         WKwqZb3OaLWTH/bxnxdZECcm86VtnPU3Ge7BnnDS7NQVeH+DtLeJzKtp+CMEfYTefwgv
         1O1PjE8Bg1f9xC88YPF/pNR9Jc4Y+kgu8icFvXEQ8MpRpGkPPquTsCqarnASaI2uJPMM
         qA2g==
X-Gm-Message-State: AOJu0YyRnXWi65oB6XhPZDL3Qr2GZ3I9c4riMN4wO24loE1WNkBOM369
	k7wLy5Biio+5UbHK4NS6QQ7Gem+gYubOFIChPQAGtIUr/GF7Ge1iKv1QRVLrKMU=
X-Google-Smtp-Source: AGHT+IGUiBOYuklVBedFu0zJPcyJZhLYk6Yc3D80C+JJViqQnNQPQ46i6Ialq80OWcx+wdU+nLE0+Q==
X-Received: by 2002:a05:6000:dcf:b0:337:b636:993a with SMTP id dw15-20020a0560000dcf00b00337b636993amr1179443wrb.185.1705935374305;
        Mon, 22 Jan 2024 06:56:14 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id n17-20020a5d67d1000000b003392f229b60sm4368629wrw.40.2024.01.22.06.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:56:11 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DBEA75F8F5;
	Mon, 22 Jan 2024 14:56:10 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of misa_mxl_max
Date: Mon, 22 Jan 2024 14:55:50 +0000
Message-Id: <20240122145610.413836-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

The effective MXL value matters when booting.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/riscv/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
index 0ffca05189f..bc67c0bd189 100644
--- a/hw/riscv/boot.c
+++ b/hw/riscv/boot.c
@@ -36,7 +36,7 @@
 
 bool riscv_is_32bit(RISCVHartArrayState *harts)
 {
-    return harts->harts[0].env.misa_mxl_max == MXL_RV32;
+    return harts->harts[0].env.misa_mxl == MXL_RV32;
 }
 
 /*
-- 
2.39.2


