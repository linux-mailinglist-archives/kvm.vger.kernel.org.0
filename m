Return-Path: <kvm+bounces-26060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFCA96FF27
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2C201F23D2E
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E23215AF6;
	Sat,  7 Sep 2024 02:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSmrPDgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069ED18EA8
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675218; cv=none; b=tffCQQrlxhDk/l3ezfh6RPTGMAhfLXFFAtiHW1zMlaJBjx08J8TmyO0+drYPgxwlhvsjWnGSoMTTnKfbGZcbaQW3IU0icr/zNpe5drDz/zOLIi38MK5zeDUD77TwaMa+lfNSQtS1LLP12GHNBeugzKnZ9uBsjOOIDrEdLZU4UiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675218; c=relaxed/simple;
	bh=4hklxyNUlvbMhY5isYEfK16mjKhTfZdZJYUzsuumq38=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaFnT/o4io1G46tJXgnoSuxD/hetmvriNwqBJcJvusFy/dB8kzicDSa5mSyS4jUJ7MPjJFe8BMb6/VxwBbcbzw9+qy4rZArB2MCzbR4ZDeFd0M8jEGvb9pVtZEZ6xw5KHY6Be/IU72bd35EQ5kNzMHAPucxxkTMjkdjFSf1jIsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aSmrPDgc; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-718e3c98b5aso287013b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725675216; x=1726280016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gsKMTLFsabjdxtWobRt89f6wrjqfDU4EnRWT7bF37OA=;
        b=aSmrPDgcijaAi31wDYy1K61vTWnQRxPzvnLgxlgBWySdUN8+SayPJDWiOmgNq1vhHe
         /PucLAU/zln6JOYU3GNPLUCbgvsP2ql0RxRYb5SpcVJde2UTmPrSAwo32Nx7aEV2BJR0
         hS2KN0YGiMAGbKtTvFIOo8nTRzwJZPZv8Q0YBq8bkohQNhO0jiVBpAjRSCzZNpji6Mu8
         tcS33hupzVylP3wN5GjTzzZEE5PYeBKPsHD3hzMH7GqnpCtwytA75fnsCD8s91Ned74t
         9zkMbL1b+bVjuNaHdK1XYQlwchZj47vwafLqxfopyr5iPDlSlTx5TbXhvPG8OVMPZAAe
         Q+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725675216; x=1726280016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsKMTLFsabjdxtWobRt89f6wrjqfDU4EnRWT7bF37OA=;
        b=crGFhrVjVfI9v6JT8JN6OJwdUZId9H2quP64g7OcUm5jGPlSad0i2UkRegoTkf/c0D
         X0zFSw1k3iTy7P/HMP82FO4TIepNsjZ1xxQ6RO5asxT9HBr5ModpujOD+KzvDi68CrUY
         PNmCfv7+PjZzGwa5QivNpacqzYQaeblpbsyb0O7t1jMz9P1+VZUAkHYr009nx9N84Ezf
         umGItd0nZwC7P4OKVEVumuKvH/lG2wTGkUbSs4GyW3yb0K6vZYEtnwrst7MgiLMlsdI1
         vr3f25459iPhsgVC5G9r6Q7rKLO18ZbOubIdWKjGxLwc0v6oC/BBnJfFi+9K7WWNfp6R
         2KcA==
X-Gm-Message-State: AOJu0Yzfx4Lw9OywZOA1K5mRxCBtJd9llRWMvi6ag7d/FkhFNddYINYH
	DuQbxj1ZLU8J7uLWjYMz8MhcaNumXw9ElLBrUx1WSU+CheDcHEtf87zEDV0IGiHj8Q==
X-Google-Smtp-Source: AGHT+IHvFRAJR2mp8rl0Uoq/JcI20c+8wVopVX5QJKkPiUC0Nj9maPiR2NTc+4irpP/Nl8sq0m+2nw==
X-Received: by 2002:a05:6a20:d492:b0:1cf:2aaf:6d7a with SMTP id adf61e73a8af0-1cf2aafa123mr1284006637.17.1725675215861;
        Fri, 06 Sep 2024 19:13:35 -0700 (PDT)
Received: from localhost.localdomain ([14.154.195.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f20104sm1215845ad.233.2024.09.06.19.13.34
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 19:13:35 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 4/4] x86: Disable Topology Extensions on AMD processors in cpuid
Date: Sat,  7 Sep 2024 10:13:21 +0800
Message-ID: <20240907021321.30222-5-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240907021321.30222-1-sidongli1997@gmail.com>
References: <20240907021321.30222-1-sidongli1997@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running guest kernel 6.9 and later on AMD processors, dmesg reports:

[    0.001987] [Firmware Bug]: CPU   1: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0001

This is because kvmtool does not support topoext but does not tell the guest,
causing the guest kernel to read the wrong Extended APIC ID.

Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index f4347a8..fd23429 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -56,6 +56,9 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 			}
 			break;
 		}
+		case 0x80000001:
+			entry->ecx &= ~(1 << 22);
+			break;
 		default:
 			/* Keep the CPUID function as -is */
 			break;
-- 
2.44.0


