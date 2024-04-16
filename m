Return-Path: <kvm+bounces-14852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AD18A7405
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A97641F22905
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB02137933;
	Tue, 16 Apr 2024 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S5YTLDcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9A913777B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 19:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294006; cv=none; b=mubQfjJtJvhX4Swr10lQDZG+xqH5OhuTPhFUwgjvIBeRTUyVFDrFDfHcg1zqYq1LurPygDOrFPLHKI7+i866jDmi2mJilZe6LO/30fXpV2+rkVlW5h0ZcoegdOoCKBQACCfsYzVBshLveilrBEJFOdqndBfNwQghkJFQyMC/R14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294006; c=relaxed/simple;
	bh=s5BNHanKTVkZzTrNBYqwkJxjuzy+pZZ7Ijfcbr7SnH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dEtAY0jtJEDWkq6rS2NNSKKWl5zIhXSEuL0zs+GhB+Ub4L+jTZXeyPQIOTm/JCCT3TSEd+NeqaH8VfiNcxzGdOlDH1qbo5tZNyAYmSBuBUHwKiWZ9+ZZiN/0ns/aVCet37IhvyjKs/mKmuVjxz2+wcqF5CLyCE5z+osvFFlndKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S5YTLDcM; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5544fd07easo144953666b.0
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713294003; x=1713898803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/B5UTN+VVzZIBHg8vuvzaIXLhoLwQMP7eYF+iW6nSk=;
        b=S5YTLDcM70KGJGFJvuX3OTsXd9ylkTVXFD0/zcQPLeW93+3RK5UKTc4Wg0Wm7ncRky
         j8uW1YxRbjvaG1mfAj99ZfWm0UsOVMZE2TDvGLPc8bPAdh+2mLnOHt2vCQmRT2eEL2l5
         I0lw8Y7S7MPlXwFnDJFAG+5wrlSw+NVZI1Vr158lOYq46G7yb8eW85E8IBCDrijcTz+m
         Mos73BdDkhholLjdJf9dxxINJ9lIyfAZt+zqO9JeNNeY7nXCmiLL6PJZk5z+1+v8fOeV
         35x5HhRcfiXSzDvR1rn9O/uz+S3kecsXxhiebFltGbCOb4HL7GskDuUB2lm8CtkREQrs
         mE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713294003; x=1713898803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r/B5UTN+VVzZIBHg8vuvzaIXLhoLwQMP7eYF+iW6nSk=;
        b=CU27GpzvlV7l+0j47IzPdpCq43ZGeBU8Nm91AmYkQbnePBVTwo78YeHACy0z1J2Acc
         q422T8xf0aa8DcO3siGAKoKssmIvAhKJqLgwhyVKoMeeJ4i3hYDCWNz9ZNpn5KFFopEP
         qx9QdIedLW5iTH2Q7CWWAShtvrLOMFWyM7m7Rp5HFf7yImxckOU5J8UfEZ0UBUGMNner
         2JtAuWjixXJ6mYRu7jqa3upR/gqsT4DrKMyP1Ph3ws8FqsCSeBDlpAbN6V1i5a26sAFY
         ruUFfSaxwkZ5U+OmeJ+9thqa/7nZln0yLnYAz3Jyqe96RoLVbd0qefI5lzS93+iTMhZz
         pTqg==
X-Forwarded-Encrypted: i=1; AJvYcCVWNo5hTzASeNRfksSCTpoIaNGiou9ltMA/U+p+y8T4MPO6bhUT7GGMI7x9xOxK89W0VNXh/m1wQuFB7QIyxEvL/uZ+
X-Gm-Message-State: AOJu0YxK07SYzNjpC9DfD+EmiXi478dTi82QuEWuv0ygi+XrsMwU4NS8
	yyjyl0Cz5Cgvx1DZMFkZ7xBySXDzrT+4GixCrwgokdna3njN+FXOydhkUl+7eaQ=
X-Google-Smtp-Source: AGHT+IFYPRtucDga6LKg9OYiy7Lp1H1gYO0dq5T1mdbxUJVv5BVKlYTRGjoZPSqqHynS6LcsQRYSwQ==
X-Received: by 2002:a17:906:bb17:b0:a51:98df:f664 with SMTP id jz23-20020a170906bb1700b00a5198dff664mr8257297ejb.76.1713294003357;
        Tue, 16 Apr 2024 12:00:03 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.155.61])
        by smtp.gmail.com with ESMTPSA id ne33-20020a1709077ba100b00a51b26ba6c5sm7137906ejc.219.2024.04.16.12.00.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Apr 2024 12:00:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v4 03/22] hw/usb/hcd-xhci: Remove XHCI_FLAG_FORCE_PCIE_ENDCAP flag
Date: Tue, 16 Apr 2024 20:59:19 +0200
Message-ID: <20240416185939.37984-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240416185939.37984-1-philmd@linaro.org>
References: <20240416185939.37984-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

XHCI_FLAG_FORCE_PCIE_ENDCAP was only used by the
pc-i440fx-2.0 machine, which got removed. Remove it
and simplify usb_xhci_pci_realize().

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/usb/hcd-xhci.h     | 1 -
 hw/usb/hcd-xhci-nec.c | 2 --
 hw/usb/hcd-xhci-pci.c | 3 +--
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
index 98f598382a..1efa4858fb 100644
--- a/hw/usb/hcd-xhci.h
+++ b/hw/usb/hcd-xhci.h
@@ -37,7 +37,6 @@ typedef struct XHCIEPContext XHCIEPContext;
 
 enum xhci_flags {
     XHCI_FLAG_SS_FIRST = 1,
-    XHCI_FLAG_FORCE_PCIE_ENDCAP,
     XHCI_FLAG_ENABLE_STREAMS,
 };
 
diff --git a/hw/usb/hcd-xhci-nec.c b/hw/usb/hcd-xhci-nec.c
index 328e5bfe7c..5d5b069cf9 100644
--- a/hw/usb/hcd-xhci-nec.c
+++ b/hw/usb/hcd-xhci-nec.c
@@ -43,8 +43,6 @@ static Property nec_xhci_properties[] = {
     DEFINE_PROP_ON_OFF_AUTO("msix", XHCIPciState, msix, ON_OFF_AUTO_AUTO),
     DEFINE_PROP_BIT("superspeed-ports-first", XHCINecState, flags,
                     XHCI_FLAG_SS_FIRST, true),
-    DEFINE_PROP_BIT("force-pcie-endcap", XHCINecState, flags,
-                    XHCI_FLAG_FORCE_PCIE_ENDCAP, false),
     DEFINE_PROP_UINT32("intrs", XHCINecState, intrs, XHCI_MAXINTRS),
     DEFINE_PROP_UINT32("slots", XHCINecState, slots, XHCI_MAXSLOTS),
     DEFINE_PROP_END_OF_LIST(),
diff --git a/hw/usb/hcd-xhci-pci.c b/hw/usb/hcd-xhci-pci.c
index 4423983308..cbad96f393 100644
--- a/hw/usb/hcd-xhci-pci.c
+++ b/hw/usb/hcd-xhci-pci.c
@@ -148,8 +148,7 @@ static void usb_xhci_pci_realize(struct PCIDevice *dev, Error **errp)
                      PCI_BASE_ADDRESS_MEM_TYPE_64,
                      &s->xhci.mem);
 
-    if (pci_bus_is_express(pci_get_bus(dev)) ||
-        xhci_get_flag(&s->xhci, XHCI_FLAG_FORCE_PCIE_ENDCAP)) {
+    if (pci_bus_is_express(pci_get_bus(dev))) {
         ret = pcie_endpoint_cap_init(dev, 0xa0);
         assert(ret > 0);
     }
-- 
2.41.0


