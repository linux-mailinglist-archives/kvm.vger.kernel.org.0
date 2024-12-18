Return-Path: <kvm+bounces-34057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD90A9F6A9D
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58AFC172507
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C151F239E;
	Wed, 18 Dec 2024 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xzxVwNOR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989ED1E9B09
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537558; cv=none; b=rp3ohicNgTsK0KZHMjx4tMAlufCGtlc1Ndk1G1eYlC7IahxCfnqk05xNWXmSt3bPCcKXwYvjjtCnXQr0PeatyrDyo2nUNsZM9uFATjK/2L5LB5nYWicntUe58mLwlltoe2Ny6UH+tSPm8YIDbduf/7JKqjZQjz3lDUeGeWx6Poc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537558; c=relaxed/simple;
	bh=ry8HfpfC+kZEiVKDjXPRFoyqUscbKyjdliANu1nPYo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WSLyd7sMrlRMUN6Sm4MiwRqK7njF1rtzB41W6mGg4QAMdSjcQl6Mamp2KhwIsqoEVAV1tcndbTZQ0mzEQj6tHEa6gqu6X22o7ugbivHz08KTOGXc2zNEFitbHh3vKB2P5cj1QATNeEtS9eUGSyohwmHrSSJwmc1EO4vJ5JCZam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xzxVwNOR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3863703258fso629238f8f.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 07:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734537555; x=1735142355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o7TTefP9nXOqik7RDcZbvdDuVx9jkgFOarBEq8+dT6A=;
        b=xzxVwNORfQS3zP4ZCsTpaH7Zi56ay9S1aCkGf6RXpXZBrXkqeuADbH1e6ctzOuVw8Y
         WL0zpoQ06C+1DSEA9lEmLfyr3A9RZUOz5QiwFDQGyUOeEImDpZ5eF6oHWzHLSZsLWarS
         5I2D4aiYdsscrZkEBYXidQg72mk3oPd6z9NbBLoxWlLKwgwd4dw5+n7bNtP3S5UtcgfF
         qjGlfaTiKOrkP39bnTmTvDvCIWl5sS9tR2VG1P1DYu13Rb77MhiYUnJqsUpoGXvizAt1
         qADJSHxyoaMy6GzWi5iAuUClPc3nm/zL84yqCZBLKS2iQJspBmMekbIf5t+URgnL5MrK
         e79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734537555; x=1735142355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7TTefP9nXOqik7RDcZbvdDuVx9jkgFOarBEq8+dT6A=;
        b=H2FTQzcWdaJ2Bz7dPUW3G7eTO9wOm3t2uC5bf7I9SRFWMIWtKOIsfk+fCQcufvSEFl
         CSmlj+MxTrQQo5mFuFEXtqKNiz+isiTQVczDcxZKzxpf7Fz8VjlluMUiSTS6OuA2bZj6
         IEQnB7LCtz4/VRYkIkW1zZLr2AR1dNShyX1hqfRFcn4OYw9yHa+AdQ7vmNKJnirqLntd
         fHfmKgOOpbQ541hIBulP6jFmX8iOYAxNbCzoB9HFw9B3zU8ZzWtzegDsJ9wSnlW8Q4j+
         OTqm/dwIFIFu7H/BSibzEI8V6yIPvuYsT+UDFeKmxVNMfYYOcS9YgmRWxglcqsESo0Ka
         +ohA==
X-Forwarded-Encrypted: i=1; AJvYcCWbg+VbJMm/1uGCVf15m2fc5W4/n5kiUzOGyte56QbSNnDN2QRHf5+JkehWxeHx4nArNdA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2l9MePkZCNoW1LharaJCPBNICxUjMiRcCl+SRYYsaWeKcMAht
	xqy3f7gccBCgb+4MfEPp+0X9a9wTlGOWvjTZjO1W1BBDnd3boOr9MPTK/HJ5+dI=
X-Gm-Gg: ASbGncskNjZmXoVlxfQTiNz70Usgx+f5kqwXA3z9U5xbI/b/07egy0a93vjAS6jSgxR
	5jpy3R3oCRUU5AV1OWS87h43bEVNodv66pCfgc145vmjBa+VnxSQMs6H9seY1+6lZkmYXhgeJgd
	0NeDUFs7/jiUxM5Ok5rR6sNm6BOMntoHdaBu8oTDzLrP+14yQwf25OSMzdD5flWngbA3Oxzth8u
	vwR4raLPK5hMwUV+KUurXzPytCt0/wbpd5r5ExsbIpEDlY8PmhbIa4bXiiWGgNmSdTNA+nRHzeB
	pLat
X-Google-Smtp-Source: AGHT+IELZ+GggeTZx48MEhW7+44jizCcSkYTHAep0mIEWWuSZqv0/tl8cNaTNgN3QB2V/mBJ1CUGnQ==
X-Received: by 2002:adf:fa0f:0:b0:386:4570:ee3d with SMTP id ffacd0b85a97d-388e4e79284mr2556298f8f.24.1734537554946;
        Wed, 18 Dec 2024 07:59:14 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801a628sm14684705f8f.47.2024.12.18.07.59.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 07:59:14 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-s390x@nongnu.org,
	Yanan Wang <wangyanan55@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH 0/2] system/confidential-guest-support: Header cleanups
Date: Wed, 18 Dec 2024 16:59:11 +0100
Message-ID: <20241218155913.72288-1-philmd@linaro.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Restrict "confidential-guest-support.h" to system
emulation, remove few SEV declarations on user mode.

Philippe Mathieu-Daudé (2):
  system: Move 'exec/confidential-guest-support.h' to system/
  target/i386/sev: Reduce system specific declarations

 .../confidential-guest-support.h              |  6 ++--
 target/i386/confidential-guest.h              |  2 +-
 target/i386/sev.h                             | 29 ++++++++++---------
 backends/confidential-guest-support.c         |  2 +-
 hw/core/machine.c                             |  2 +-
 hw/i386/pc_sysfw.c                            |  2 +-
 hw/ppc/pef.c                                  |  2 +-
 hw/ppc/spapr.c                                |  2 +-
 hw/s390x/s390-virtio-ccw.c                    |  2 +-
 system/vl.c                                   |  2 +-
 target/s390x/kvm/pv.c                         |  2 +-
 11 files changed, 28 insertions(+), 25 deletions(-)
 rename include/{exec => system}/confidential-guest-support.h (96%)

-- 
2.45.2


