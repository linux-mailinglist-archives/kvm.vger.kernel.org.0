Return-Path: <kvm+bounces-26057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65C2996FF24
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC15EB2424C
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412CB107A0;
	Sat,  7 Sep 2024 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxsjOv5B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF0171BB
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675214; cv=none; b=flULHVQkd+0zitlKiuVosmtV9Yx6ibIjL8whhSY6k0QzLe9LJ85gvY32+CyCjVTUF5CsMT8XVMsp3+om4TYIJ3AHR3Sdh89A8bGSvrq0E/0dTTxuMaC22g4MAVNlSOjNux6gVwKJ7DEME8wcVk3d3FM/8Cgz/DTDRAgOfe9ocQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675214; c=relaxed/simple;
	bh=2kzd7G/Pe4tgcXPkQ62/SfYOrC0tBK4PckC6GHZzlpQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrFPp2wMsOJgKNgGkBbzwcwW09c62WjZO0LN0lFTGu75jxkn49m9ONBMa311WlVY8p8NvO18M/t1eo69PjHCP7FwFSZhLwwNiOkGabxWGpghGqsEOsy1uC3OaJNuFkYfTJ08+K9akY1QB1i6tRFbStdCtnC9MpGfp9ZKutnvVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FxsjOv5B; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-206e614953aso20068295ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725675212; x=1726280012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/E8CEOT1/HPFlUo2VocSkNU3W/VJweNzQb1pGEp2ypE=;
        b=FxsjOv5B+NbDML7YvFcZWk048atIWJOETSI18FTeCfcPDGVzxBSn6ZbjO7NvlUj/3S
         VK26MoaZR1xPqry9eyibqvkvJZ6nleo40836Rx3iUk2gRv+smXlJMWf2FAk7KWnVuZWi
         8cFk622DWO8q9BPxGIQEt8wQ9TsjjyB+ykbO/Vl9IKU6MJs7J9GfDlTnog7aY3CYzjTw
         rBtf0OwSBohncJVr59ZfNSY+9VyzvNxjg6R9DdV4WkxCYKxGvwHoTxit9cpOpPEpTX3A
         gmh5XUPCXJVWH5htJxBObzK8W7phv3xW5tEVZF8qTYnkP0dY48AdEezwAPTXFchWFUHL
         7CyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725675212; x=1726280012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/E8CEOT1/HPFlUo2VocSkNU3W/VJweNzQb1pGEp2ypE=;
        b=nK/V+IQUAUJ6R0hMUnNvHj17nmU9q2DKkApTdTInP+ftX77fmKKmLHM80yFiWmHu5a
         quvT6zHOF7+a3TDxnmkjqlldzYsTFAiuVlhAoDub6G/RsQLkTGXDpBkqmYGJfHqNgII+
         UbkdleZYRn+26nAHPxMX5DEY8XxUToT03x2m/tkPCc9FHnEQ3cLWD7IDW9x7ufvZncQt
         lluJyVYZ6HXSdYcvA+PRIivFGF7i3UNm4Rq2nELOI/iTWov8FAn1dFZv8U7CMWJW/71s
         8IrV0BucWvFgmssnfOqR60nyd/GhyIMQHnXShccEyb1dkMI59/iydrXDfmTCij/WY/HI
         jGSw==
X-Gm-Message-State: AOJu0YxpIkDDp5Dr8bGu4W8N+07ccmgALVnrJlCPtt84a/relGlbdGZw
	2P+YplYIF89/GzUpFf0Y/OEUSWbSNuSQXWMRqM8nl50dYJfb9F/CMNlBnM4TCeBMNw==
X-Google-Smtp-Source: AGHT+IF6i4fuIfCs7KqxVZzdo78J/2sg/wIfq1IKL+WntEwhv7G/Wbrw8ObdfxEZ0JIL08LvoE2Wxw==
X-Received: by 2002:a17:902:f68e:b0:202:9b7:1dc with SMTP id d9443c01a7336-2070c1c74c7mr14217415ad.54.1725675211867;
        Fri, 06 Sep 2024 19:13:31 -0700 (PDT)
Received: from localhost.localdomain ([14.154.195.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f20104sm1215845ad.233.2024.09.06.19.13.30
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 19:13:31 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 1/4] x86: Set the correct srcbusirq of pci irq mptable
Date: Sat,  7 Sep 2024 10:13:18 +0800
Message-ID: <20240907021321.30222-2-sidongli1997@gmail.com>
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

The srcbusirq should be pci device number where the
interrupt originates.   Fix it.

Fixes: f83cd16 ("kvm tools: irq: replace the x86 irq rbtree with the PCI device tree")
Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/mptable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index f13cf0f..f4753bd 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -180,7 +180,7 @@ int mptable__init(struct kvm *kvm)
 		unsigned char srcbusirq;
 		struct pci_device_header *pci_hdr = dev_hdr->data;
 
-		srcbusirq = (pci_hdr->subsys_id << 2) | (pci_hdr->irq_pin - 1);
+		srcbusirq = (dev_hdr->dev_num << 2) | (pci_hdr->irq_pin - 1);
 		mpc_intsrc = last_addr;
 		mptable_add_irq_src(mpc_intsrc, pcibusid, srcbusirq, ioapicid, pci_hdr->irq_line);
 
-- 
2.44.0


