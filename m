Return-Path: <kvm+bounces-41976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F993A7060C
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 788213A8671
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC5E255E32;
	Tue, 25 Mar 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BQu3N/8x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C4C18A6AB
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918873; cv=none; b=cERaojOCKnlnJ4bRauTsL6h9u/POGb+mM7yfNFD6Nj5W95u3w0tcM3JIi0cHdbKRwYy3KC8XwBSvuqqdvYVOPk21OeIlPz676FEmluBnD+Adqff2WbFWG9qhD3WTzoq8xRBLB6VRl1BRPJx9tyOS9hxvUg4aPo5vMShcxKUt0m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918873; c=relaxed/simple;
	bh=NbA+n7cBicvkCk21uXZmI/fvdlcThsInEqcdoWNUAtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hcdeYqmBemaOP+lCGwWZLzhtqinV2rvLEcLmKTLSciMcf9arA+qvNrxRIeL5F1MpwHpAb+oBlbDaz/N00K5XAU/fPDfVw26RnUMahYLvjO+VkvY9mhhOStUBXozEz5fuJxHZLhvFflY0AdTAYAAXdQ9jWvvBl8EZlh1y0FJVsSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BQu3N/8x; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-391342fc148so4070671f8f.2
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918870; x=1743523670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yQTSPvF1hw0TOBoPMd31WqVvKG9w/U98Z3g9Yg4clUE=;
        b=BQu3N/8xoACA8GFWdWcbiS9nBzYDM9JOJWhArvCJrqHt76ckiN+LMnqCcmHTvJn1On
         4aPyC6CfCjfckEuLS/PxcMp9z2PO4XoWqqmYItgic2yWQmXwwKW7AWY0el2XMidjLzCd
         OM7TGHg0uHaAGOKxAtH+IUuBnI/kvMjpU4mjuXb5fXIlQQLsdcK2iEko4KBoKaq9s/vX
         VRNIAEmAsR5jujcJoSpMAOgEx0m46lxazhBhkPR/nBlPuhP9RoqdqbHizHxAZP2fPtO0
         qcIlyQmOecrQlSj/ORhC/7KJhkX7RsN3deamGBXyB3fm1Kxb0dM4+I7uvBASVVFXN7Fp
         neMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918870; x=1743523670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQTSPvF1hw0TOBoPMd31WqVvKG9w/U98Z3g9Yg4clUE=;
        b=dqdp8+/0kpDjE0awsjxDthcQ3Z8JF8nbFOK1YqtOUDqpsR80a3kMKBIysDNMObJnIa
         tP3udHqYrRXL1toP/qPgxQ4NlvaNdN+sj4Zp1fICUUAunyjWPJK8HzJs9P5l0Cngm6AZ
         tT82zigKExEiknGoiHLG5z27E7tJqhGnVLGcTSqUOk6sWTsp+FQM98rh7aYy5aEaiHnu
         E5Td8OlCMrvwMMZwKj+Nfywy4fMbfrpq5Ed/Fdr8dadFjeyWFOSAeRDl3d1w1cbAQt3u
         xMMVush9ma0kXHQgiS9jPwdFkikmjvrNtJ5SyR0UQ4IXrUAvQ1mzlr9GT2LToMDb8wZS
         Wxeg==
X-Forwarded-Encrypted: i=1; AJvYcCVMOLrFrGmhwmSMdnR3rRhHk1k2opyySM8o9MlzJKzizQxHvvTyj8OGBAG1jEFOhRQrUw0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuni9pm+LlUHzKEEo7NnbyAkvHGC+/RzlkiU5i2IKMb6YJ1cWi
	g39VIZqBWHdu/vrA8C4D+AuiYrvsbxV2V7brJUxXRikUWloXmJhCy9i/9ApcbeE=
X-Gm-Gg: ASbGnctnDmyLL8WrpOTODGnR67fpuU0gj+qtStjvYi9YURS1RjPQm1KkYjvAKuxIL6u
	3oWUzjR3588+dKMit8XayI9uNX8KVJKA4aNaK0BcncQzLrO+pQuREy1HOv9sIjbcF+nmOU+pGhW
	UFmLej+x6AMiw0pg77mAPmf/WoyDOu/pEPOsKOac7aCVeruN+hgF9FEr9g5Yj9p78vADFOgnVYZ
	qDejxfPptK8LT8uNbfCVwTv8TgbnIaQDMfoVnBYdIBg3T2ntuBKjSoApgNEvVwMwixmcv5JLB9j
	/MfWY98QLDaSfJWQJeX3nK5djI7Ff4XdmixDl8R7CnQ99h7IgUt/d37ZipTOnns=
X-Google-Smtp-Source: AGHT+IHOT5jOCGHfjXZiwn0hAT2YJ2NpVHcZDDE7JLfDT/x7D7gnwHssedDwTGk0WlzARWAy46l2EQ==
X-Received: by 2002:a05:6000:184b:b0:390:d796:b946 with SMTP id ffacd0b85a97d-3997f932d65mr17628426f8f.44.1742918869724;
        Tue, 25 Mar 2025 09:07:49 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:49 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 0/5] arm64: Change the default QEMU CPU type to "max"
Date: Tue, 25 Mar 2025 16:00:28 +0000
Message-ID: <20250325160031.2390504-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v3 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64, in order to test the latest Arm
features.

Since v2 [1] I moved the CPU selection to ./configure, and improved the
help text. Unfortunately I couldn't keep most of the Review tags since
there were small changes all over.

[1] https://lore.kernel.org/all/20250314154904.3946484-2-jean-philippe@linaro.org/

Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --qemu-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 ++++++-----
 riscv/run               |  8 +++---
 configure               | 55 +++++++++++++++++++++++++++++++++++------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 63 insertions(+), 20 deletions(-)

-- 
2.49.0


