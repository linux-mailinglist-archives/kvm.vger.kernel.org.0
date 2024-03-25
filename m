Return-Path: <kvm+bounces-12595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8492288AA8D
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3494A1F373CE
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C8E48CCC;
	Mon, 25 Mar 2024 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FKuLKAG/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4231D69B
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380722; cv=none; b=YQHNJoKD2oY6Nio8aG9ke+1lf1CHcmB9cYVWNITlrsMuZ2iILCIuspVUD8xZDvfFH4SZvBkbJfRknxHfQxe2uXxF2cWw8voYk9llpx9lL3qoFQsr352xE6qSVOfK9QgS0WRfsGaF56M3Gss7zlOg98KxpcuBlaQ4oURV26Eid3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380722; c=relaxed/simple;
	bh=gx2vTofXebLP6JVlkEb2oQb0fWvIH2qsTnYAPuwH21U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LjWyfJBLe7V42Mx1Htg2A9z0jpIzI/LIrrWD2jQSwbtwLSFYch1s39p2jTvvZs7K5hzpBhoezWfPyDxMr8PF9nJgvEDwYSHxpCRmlXFaETW8gzOgDiAa6o129w5vHa7f8JwPkUTImlhQkNEKlrQmberT9evgsh0LmTecdGI+cxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FKuLKAG/; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6fb9a494aso3459375b3a.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380720; x=1711985520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HozRKN9wrxi5PL0DaVXWcH0x0hBsJpBpA/05xqOENN4=;
        b=FKuLKAG/BcpS0Dtd9uFeJ0J1McFKfqxbAo0/dPV6tYiGa5whmvrBx90Lx4jxyUj3aD
         fqm27WVJ385Wg2MQDRxbazTk66ZiEs2PRAzY54ZaIocWVNcl4wOEXisZlyWfGTgJvi5r
         eby2WFubHHwHDVE9zMMko8LujbZw+WfmghJGDsYXXGeLopZih382+lcUSjbVyn00ISXa
         SzlfW421tsv+HcKKO27E4WwYVjGiRZMO6xb8rK1EZJE7mWCLdHHAEnBrKv33R/mCAxB0
         jhq3sCRqSeZsFSeABgRBhk73BUFJJYfT1exg7itl8JYpVsTETb9poG3f4CPU0G+dDfqg
         FW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380720; x=1711985520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HozRKN9wrxi5PL0DaVXWcH0x0hBsJpBpA/05xqOENN4=;
        b=qTHtO2ps6fe6sb2M8x4B+h8sN9t0/AGEJ5eBqbodSj+z4y+1H6gx5U2uglajJfEdRr
         G1v6sGVK7z72pE7UZHLg9RX8Uf9nYL3MbXtZlpAPM8MHQc006/JNZ+ij9bX+GNmAp2Nv
         1Cas46ar6Hfv2XhaSL+PZW/7I2BZJCkTJ+GK0N8VyqtDyEvr7oAbe87DZj+feETjQCZh
         td15HvbqbJxRv4K5021q7n7Z16AmITzLMXHK4Cjrh1I3+jgumscayU/Lvsa+2Yj7+/mW
         VvAG4kkZroy4XhVFiB932H8Of/xQ140zvZZjV9SEdrPn79Cs+REfyr3BTgmlkbs23uud
         66Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVQ/hIsk/Tts5SOxMI4+haBXES+mJR8RMmLbrV34qVzdMX/HBi79tgBca0vzvf1DCt4xlW/uPoDCM5H2JX3Zzx3B3hs
X-Gm-Message-State: AOJu0YzMdpfgDvV1GdSCs3J80PcSoZm5odLub+g68TgPkNgrAqBPMqq+
	Y4xWnSGsDaAjmShyXHBbrq8WrHjNBpyoAzuWsUbSvAw0RWl/JVw/h7RMUtVof6M=
X-Google-Smtp-Source: AGHT+IGgCsS+vxU2FHTscoGAW+/TuWSqpGlQQADJWzmCBbL3CpLtJkxhJgat1JMj3DtVFxdIylb1/g==
X-Received: by 2002:a17:902:f544:b0:1e0:d0e8:b083 with SMTP id h4-20020a170902f54400b001e0d0e8b083mr1246206plf.51.1711380720508;
        Mon, 25 Mar 2024 08:32:00 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:00 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 02/10] kvmtool: Fix absence of __packed definition
Date: Mon, 25 Mar 2024 21:01:33 +0530
Message-Id: <20240325153141.6816-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The absence of __packed definition in kvm/compiler.h cause build
failer after syncing kernel headers with Linux-6.8 because the
kernel header uapi/linux/virtio_pci.h uses __packed for structures.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/kvm/compiler.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kvm/compiler.h b/include/kvm/compiler.h
index 2013a83..dd8a22a 100644
--- a/include/kvm/compiler.h
+++ b/include/kvm/compiler.h
@@ -1,6 +1,8 @@
 #ifndef KVM_COMPILER_H_
 #define KVM_COMPILER_H_
 
+#include <linux/compiler.h>
+
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-- 
2.34.1


