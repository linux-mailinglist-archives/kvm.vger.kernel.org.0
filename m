Return-Path: <kvm+bounces-10985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CD6872088
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF08C1C222DF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF9785C79;
	Tue,  5 Mar 2024 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jjoQcnce"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732635915D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646162; cv=none; b=AuxGKLQJ6wrI6nXkvkKHFRYoZpgt0rkbr8REwt2b+VLCdAruSFmiJ4kWtHGFScsBMiXX7VAKuWcPtR0fXKjHysquiyo3x728r6scYtnZstony9XQiZUZwta8FvHAYfwciH3mj5W4iGlT7Ry3G0ZEUdq7oquSCZc7LUcy/GTj0M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646162; c=relaxed/simple;
	bh=9jcOe8BIomrPzOFhdHjgHgL3RllniifNg57EqqtXPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izgIetjSycY1ZGaCIWA9XVBMVW4iGfBpHampRDgbBemFnP2aeYQp0r3PIoi8ggUOPdqGsXST6DhE0tQeKfw8zpUhbsIdd/b9XZMmhB6Z1U5UOob+XI3LUwuRoCHuPElXm7aLhT1TdsHJvtCLeak+z8Ji5SFWGmL5PtevEoRA0tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jjoQcnce; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a26ed1e05c7so958079066b.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646159; x=1710250959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBiR1NjnNqmb5fA74myd/4THTKWykiIDh39Z8PAr++Y=;
        b=jjoQcnce6+aa0yd4guFCyHPIe72vAlQfj7aUlnup9bnUeScUE26M05tjvPvsExnBvo
         0xBsSUaHz/BqozgCDxDm6G74qXzMQEOR4F6z7fCEcW2Xd/yz9DMK9Ga81tVChr2fwY5B
         gjsd02T4Cl4dh9Y8HaM913Ds/5PJJnwSLr41Fosj4h1Xn2f/g+5zI9vgwZaBfNzduDVJ
         OOYIH22ng9pfvYxEJmByzA5E/cdYOTWnIWLXBclwbmOr+qP8zKW+4+Gf/LS5v002ErIJ
         Yw8uUgjY6CgCMQcHkpIp2zJ4OBY1/NxG3uW9Ja9iOe02ZiqI7zYcrUi03XhuRD3UPOvb
         +btA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646159; x=1710250959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nBiR1NjnNqmb5fA74myd/4THTKWykiIDh39Z8PAr++Y=;
        b=AiJru4whNfJ5egybJjYlj1lsUlcyZaXKWZaujAHx4vXN+cVXQ2vQbC4J7VUVzBXpVv
         qKtm47Vrcya69/vUjHw/cfNsR9/irDLVjDxFvImY6EBN8eM/WnGg+8khyCJEJPBHmwT/
         P9vcTdy4CRM+4YrdDRLS6Ep+e45twXuNLNRG5hcgx3TJ8NfBxULy03/6NKfcVIx5dMSZ
         KgnBJ3nInmZE+odjahgHCihBzH7W9/oDWJs9ar55JRzDDkjemHYTgHv9ZdObgqGTf7dc
         J/uHG7kyQdrU79cKuewFHVMM510o4fF7RrDnGZcdvCEw3gJHAr+w3iIlD3avdqkuJJ3Y
         fVqA==
X-Forwarded-Encrypted: i=1; AJvYcCVx2gcYRnVQkXIBRAJSPvRn+/gvqZzkV8PnADwDX8sHchNCSE3TLCB+AwUELKiXMCOO/wxZmCxfIvQAYlZ4AKaWBujR
X-Gm-Message-State: AOJu0YwbDgzn+I9/5HKaeiE0TWrZs0G0DURSdZ7PPoDZZpVVYVUg7dOe
	aFZ2+7XlUk1DVKa7ZEdmZil+e413wxObRyhGDvY3m+EdxJVpGQGGwixpMZVKMS8lKxeMwWsEzxb
	E
X-Google-Smtp-Source: AGHT+IGlCzBdHb/CuP3L39CooS3sdPaa/BoyfCLBRe8pyO7DyPl6RRC6hDIlmTp4c2pez14Nn4jddw==
X-Received: by 2002:a17:906:830e:b0:a45:446c:6beb with SMTP id j14-20020a170906830e00b00a45446c6bebmr4144176ejx.50.1709646158911;
        Tue, 05 Mar 2024 05:42:38 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id f27-20020a170906085b00b00a44ef54b6b6sm3648391ejd.58.2024.03.05.05.42.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:42:38 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.1 02/18] hw/usb/hcd-xhci: Enumerate xhci_flags setting values
Date: Tue,  5 Mar 2024 14:42:04 +0100
Message-ID: <20240305134221.30924-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xhci_flags are used as bits for QOM properties,
expected to be somehow stable (external interface).

Explicit their values so removing any enum doesn't
modify the other ones.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/usb/hcd-xhci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
index 98f598382a..37f0d2e43b 100644
--- a/hw/usb/hcd-xhci.h
+++ b/hw/usb/hcd-xhci.h
@@ -37,8 +37,8 @@ typedef struct XHCIEPContext XHCIEPContext;
 
 enum xhci_flags {
     XHCI_FLAG_SS_FIRST = 1,
-    XHCI_FLAG_FORCE_PCIE_ENDCAP,
-    XHCI_FLAG_ENABLE_STREAMS,
+    XHCI_FLAG_FORCE_PCIE_ENDCAP = 2,
+    XHCI_FLAG_ENABLE_STREAMS = 3,
 };
 
 typedef enum TRBType {
-- 
2.41.0


