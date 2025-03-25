Return-Path: <kvm+bounces-41981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2435EA70613
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 17:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA313A508E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 16:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D887D25D204;
	Tue, 25 Mar 2025 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e237kyBQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60722256C89
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 16:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918876; cv=none; b=eKOT2ATPYsHcdnQ2oOAudNoYJbsLY4eA9hE3lALBF8bcxgYoqMi5DL+6IzbpY8IyhvK+JXJLJnkCceFwXCyeSEzBFN9B4QZ12EXM3NiteJMmkxQhA1UTFhek2DP/lWe24wNXYyI7doyJbocFG/PBrzjpKiRefUmuTbFjfAkNi4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918876; c=relaxed/simple;
	bh=0WONtvv0Wmjtmqi4fbLAdYH6E3j310jc4o7aK+McS3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoFDC2coCj9E7dAb4EPKkMkapfUlkqCEAHRDo+PQIgv5XELRjseomnLAdNth2hV+gEnRHjx4G/b6nHOUdJ9BNr9OISDqugE1jDjcVrNniK5/LfEugxyarB4SVPhfqYW4FJftPK7Q/v2vXUca7qr1g3ayj2qgwHl13ytf7/8Vs6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e237kyBQ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43d0359b1fcso36830785e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918872; x=1743523672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/KkYF0WM2eQ4j8En4HnzFELDHrNfXIe/+MMpGwXHj0=;
        b=e237kyBQf6257TzayhqSW69h1NiVBQB14Aud4D8RpWZTVwq/Lz5NeHJ0xyZaw2bmwC
         A4JMtuigYsGrywhpObRhl8p34w9zzjnFB96vBOI1eZMWk73aTye791ZK11O8al0NA8fC
         vPleOq5aufOA1tpQisieghVCP1gdRmevtHc/7N9tRKp+nzxXPIYgaUh5vgj7t7Ktam5/
         2CVIqf+tkFFGsyJHkpyhYgsfl6/lHuoVXT4VTF0+e2YqicHcXhSUcoe6viTENrmMY/od
         mO/RL8XEse/teLk6WbNN/jAoGTnyeqHu6aCaYhSyBM7jnc4NoA9Hm86nABgYeD9QRYZB
         +t8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918872; x=1743523672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/KkYF0WM2eQ4j8En4HnzFELDHrNfXIe/+MMpGwXHj0=;
        b=pSidFYnluHe/x51/xXp3UB1wh5h+VA7lTV/D9KGiskZUOb34G6of8acL2EcCzJBtTu
         3ERNBxngwYkSJ5zX9a2TDmyLTGq6/n1mNZ2dm3bEI0HuU7n+i3aEdpn4kpj/zTOodq7Y
         /Kpfy8ob2GIUBUVjkxaMNzbzPnMk+t07iXrqWQ9RrndbC/O0O3QqkLJpsp0vRsdII6Or
         02CjernxUt3jnXPIvW3o7aNNtn+2w6fj4ed5uhp2M37Zvatd3ubsC4ooOvjhPSOfp2NF
         0cnV2nCMyz76JYc/4VFozxsHy6s2xoniQVYG8D1SM2k1o6C9Ot+F403uGrODDmcbBzBM
         V6jA==
X-Forwarded-Encrypted: i=1; AJvYcCXqhp+HEaPywk1TStaP1SukaXFe2753ya3J2330fjxmGZRMGh1u2iG2HlVen/ijkf81CVg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4XL3WOyV67Ik5Ojx9DTLvYYaHFBalFJKoHXaFPSnD4kz0LXrC
	m09+0DIWK5pQqCbPfnuXbBMnlnLxJkBIUEHpCSrMsQBLJLUwv/WuSwZHjmFiB4U=
X-Gm-Gg: ASbGncvY2+gHpGtUw6nAD5ZZ/jmhYxTLOUyCBfEVM7Ab+NekPFAos3QgSxKIlZj8KTu
	9BRQYNSpsr+N1fJpPPYQX/spfm8y3WmwX/P9Hx6pcdDVmZ2BKzigMdpx8ibY0+oeh2+qF1mIXdC
	CTUhI79a5ruNj32DOdj1Kn6NFcnTiPjENbQvBly2bSjR+tsTuxg9NEeizDrohB7zn4dJB2YefPx
	H7/nLLBy6XakIjMT5hzJbdnrFpNeqMn2J6mrYQ5TJ0uH8fQ8Bl9fwULeqvb1+Kj06B2tJeijwjh
	ozx9Ro1QoVAlKG3HL/a3a/jVNI8aR4ldeZ2RbgfcaDWkd1GGgVRncq82ebtOxKw=
X-Google-Smtp-Source: AGHT+IFq4u+jQ8viBriHlPpSVQQmxgDxEvO7i8h+fg3MJkOMdTrOtVoXDilCPLi/MpwsyJ14xZjz8g==
X-Received: by 2002:a05:600c:c0e:b0:43d:1bf6:15e1 with SMTP id 5b1f17b1804b1-43d77547eb1mr3370805e9.1.1742918872581;
        Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:52 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 5/5] arm64: Use -cpu max as the default for TCG
Date: Tue, 25 Mar 2025 16:00:33 +0000
Message-ID: <20250325160031.2390504-8-jean-philippe@linaro.org>
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

In order to test all the latest features, default to "max" as the QEMU
CPU type on arm64. Leave the default 32-bit CPU as cortex-a15, because
that allows running the 32-bit tests with both qemu-system-arm, and with
qemu-system-aarch64 whose default "max" CPU doesn't boot in 32-bit mode.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index b79145a5..b86ccc0c 100755
--- a/configure
+++ b/configure
@@ -33,7 +33,7 @@ function get_default_qemu_cpu()
         echo "cortex-a15"
         ;;
     "arm64")
-        echo "cortex-a57"
+        echo "max"
         ;;
     esac
 }
-- 
2.49.0


