Return-Path: <kvm+bounces-40368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5EDA56FFB
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670C93B9315
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A50623ED6E;
	Fri,  7 Mar 2025 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BISUG5Ru"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DEE21C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370629; cv=none; b=Ukss5Zxc2ttVU2FV2EaCCC+cmhLYZgyZv9fn1KVd7vcq3ruuAdUlKRU9SOzxaLvh7IFA0KnBWeozr84YYMea2syOoP5HpTD86JrJ3kVMX+xpOCc59tEgPHSGFG67gYCzDTxlsic4FJ69FHhzSk/uHolDFurn/i26dPf+u4U+gQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370629; c=relaxed/simple;
	bh=bu59tL9L5VROU2Hbljq8VbPEC8f8dcQOMNoTWWVJojY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTTzEgfgTBzH1KKujw5gbdMtdTN0X3DfrzYQHLAVv8fpYv+yu2Fd6HiZGYxPDGxPnufSZwmIC9MvwLUJxQHcnJLP1vCp4HvF7ufXTCkRmmYgE8XRCQvmnlIaYYPCPt5RBQ3xotCj36GRCrc4g6bO/jxTBOgrZH0ftr7YTmhVuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BISUG5Ru; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43bdcd0d97dso12778765e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370626; x=1741975426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4WceDIEs6qy2mz0/CkEqDnKb2HdT3DG3c81fgnQQN8=;
        b=BISUG5RuPt4R68QrK4o739qXe/5xFIlMmPVEgtNrsNNbXCmeC+kLiuX1MVyqIgZJsp
         +UGfGrrK9kE3APb68pbJ6waQ8hFk2pjdHsJPBgssnzJr6E+3W7Fz0X1Q5BiH81zdIoRJ
         /3glp4khQhyvL7xpuh+L0L44FSEvOFu0I3EBqw1Xzev7Ww3QmGR6NqlxA6lTqR2RPrnH
         C8BKeUmYYZ8vSgt4Tc0D5RATVmyAFcd/YV+OTitpHFXT2dqggVKLB9f+TD29I4V+e+xg
         I/mXKbsc4Rqx8B6FkGhnMxTvj2GEebapxCNUfmzn8C7qAu0GVP8BcBYNWd9q6xfDHVkm
         xpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370626; x=1741975426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4WceDIEs6qy2mz0/CkEqDnKb2HdT3DG3c81fgnQQN8=;
        b=ooxr1GV1/m5489gNDw/lzqHeFUZifAd/Jc3mDxh+qunCVeSNe+UGDytKJjQ86gaoDN
         AETMv2UbEXBXzLRdd6+8JzGm3Qc2rXyYIJ5BvfvpRcfiuioa09xyBUHeGOgqDhbw+axh
         z/cs77pdpjG2P2cNr0j+ya2R70+/nJAhQ34E8bc4cvn4qSX210m6MW1M/QePnEADEZlc
         UyTA+YloinpuhOvU8fH8xy+hX0jJG1o2OowAGnrWsvIlOZnAOxDsnnyBy94N7R2JbDDh
         /osQOXm6ICSr9YOUylPXDfn3b/91lY80XqN6FZwSXMcHv4NQcE8QNQSfPDrQNJDuM7fr
         QLKg==
X-Forwarded-Encrypted: i=1; AJvYcCWCrEWaNPrnf6oJN71yYlz+09crPs0htcYq3qlTVB7hmH/iqWsVfa+S2dsq2JOqWizZSDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDzrEhFR5wWpJ8iCb6hpgM+kvfGES8ga8vIL6pk58WrNceCd0v
	4QPHmcqhH6qLaJYrpwEArT3N5E7ezErnwniU+HHUnQse/IM4wbcO0s/ps9kIje0=
X-Gm-Gg: ASbGnctF1p3fowVnvXA4QpdeXDYMHSdbCvZKROr3GRO9bPUcNqyRPGFBCTXoSIJiCTW
	oyxEPbOFjIFQBBpFyE58OxGMv0tVyykF22mX6rhENoZ28/R8v7esTa8J8rYlq7Q0AWt5Gj2NRpq
	RunLor6MTxdKVfw/loFDUIgjl3Vdsy5gTyvxho5G3F9erZUtb/FenqMikPhIdvOEFWs7lz8XA6u
	1+v25y3/zRZ6VdgsgXTpPcvBu/ULV1WASOoPVneMnOuXsf6zlm/mJ8ZaGPPy3zWzB0YVSd7hZD8
	imuJq+lyVFBHkJdCrqadFj6wiDV+JQa3qukj7HKaUZR8xk7FYd+DQB/57R7nKM4gE6kmTLTkYnW
	cueE1/C/e5qs2EKDNvj8=
X-Google-Smtp-Source: AGHT+IENdobWa78DHN7taYvyUia80YoI2km9M/IOHa3nNnJsg+wiICIpvLN5fVTrb2DUViXZ9quCCA==
X-Received: by 2002:a05:600c:4447:b0:43b:d0fe:b8be with SMTP id 5b1f17b1804b1-43c68718900mr35580865e9.30.1741370625106;
        Fri, 07 Mar 2025 10:03:45 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd831719sm61522465e9.0.2025.03.07.10.03.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:03:44 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 01/14] hw/vfio/common: Include missing 'system/tcg.h' header
Date: Fri,  7 Mar 2025 19:03:24 +0100
Message-ID: <20250307180337.14811-2-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Always include necessary headers explicitly, to avoid
when refactoring unrelated ones:

  hw/vfio/common.c:1176:45: error: implicit declaration of function ‘tcg_enabled’;
   1176 |                                             tcg_enabled() ? DIRTY_CLIENTS_ALL :
        |                                             ^~~~~~~~~~~

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/vfio/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 7a4010ef4ee..b1596b6bf64 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -42,6 +42,7 @@
 #include "migration/misc.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file.h"
+#include "system/tcg.h"
 #include "system/tpm.h"
 
 VFIODeviceList vfio_device_list =
-- 
2.47.1


