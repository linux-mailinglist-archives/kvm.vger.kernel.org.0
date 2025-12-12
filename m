Return-Path: <kvm+bounces-65839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 506FCCB90FD
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:09:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42D9B30D1FF9
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7722E320A0B;
	Fri, 12 Dec 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWc6uhru";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EA97vV8H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261B83126BE
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551922; cv=none; b=buB/uT30RqSXVcbILrpzqBlLAm5eCEQcgSssseOUk18s5ngcds1/pOP651+aYcKwxNIeQy7x8rLMjgCRbkNPVyPOAZyHSpqFgwKAcjRqK+vhhEiAZsTPLiUwBzfAbDvUmGSajolE/uyexEJ16Mv/x8S2iM+pGPCOMYAvReUGHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551922; c=relaxed/simple;
	bh=dM6zRTicy1Z8G5h8F6kzvavtDyiFbxGXN0TS8QQUCLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px23gr66tBmNzzl+1SBwWoLpxIbRwvJQy00o3XeN3+bTyoBUKrtuhMlcNKIH5M5l2N0NLYFY8oc1JPG24njTbIcOJpPSjtng/1E0u3FTo9Vky+NdvAzZmblZ6Eh6WK+qVsdUuJjfOSWZMyfGqgeRq4H2zvg7cDK2loVHwySlKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aWc6uhru; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EA97vV8H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1D9QAx3RYKk+TBo6axZVKqP/pAZIQxzOmmqfA8IeuY=;
	b=aWc6uhruTwYWga6FLPcb39f+xZEwk7DyS3s+94nIGi1gSyQ//UtF4JqTyaLl/F6jpwbWwm
	HEaTX+OHMtNTqZ8MaaR2Jltc2aq4WmuzsQkl55svjgYGT8ivXSKgW0avJYSA74Ukx0j8HD
	ql9k4Q34c8R4fbEVSGwNUTIQmDTcLFM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-rjqwpdZSPUeQM7pR4uZWmA-1; Fri, 12 Dec 2025 10:05:17 -0500
X-MC-Unique: rjqwpdZSPUeQM7pR4uZWmA-1
X-Mimecast-MFC-AGG-ID: rjqwpdZSPUeQM7pR4uZWmA_1765551917
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f25e494c2so7659785ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551917; x=1766156717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1D9QAx3RYKk+TBo6axZVKqP/pAZIQxzOmmqfA8IeuY=;
        b=EA97vV8Hu2cNQmrb2Gy67Pn/KxAwV1aqnWWF/NwA9gSuzvfuOxPYLPzMorcFXzaRst
         zCFBKNlVthvN4d+QJQq6jK8/RNxgmyrCy/Y2s6CEEWba6W4afF3HQeyYNruzPwiHUTXn
         lm7WAu738sS9xzXQ7zljPKKMlZ4yQ+0JbNJXPRMJ1ISbglmKAW1RaNjyLEm6c6fsxAj2
         1mPiKU+9DA197kiwdvl97QKcptdB85eKFuYi4kWtCt5kC2W3W4lhD61HlBnlBg6aIcyX
         ODTqAChjnar4ej4SRFELi0PmQGYxkgYXDckHdzjKZwvYwyegs8VLQ9htZW6d3469FsJn
         UXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551917; x=1766156717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W1D9QAx3RYKk+TBo6axZVKqP/pAZIQxzOmmqfA8IeuY=;
        b=RWjasiIHmTLUzyUEVar0KMno1u34LK9WWzJNUkaEhZ6dO10UrZ7wbETik30kxMCBWi
         Yh1SuFGhoUeEePoDECq4xyh0DfvvimbpA4Z2U7+iihQMQ9Jhvecc1kec3G42ZEl/2yzW
         Zg+AhPimnhCmzpzlBz/2nht1bvKmNHJrt8cZ8SbNeBmpt9U9UEII9l1SNfQirJm6Qa2E
         XZ0WhVVaQSK8GQpzTG880UZ5E2SqRVvg56pOeWx8bbRPRl8Ykjv4192M4jSKNEI2uB4X
         vjlvQXpFro07vFLcC1GSFdH30BrKoU3xJhrGB4Rgn7Uln9oChhpvpLONPldBywB5idPt
         dy3g==
X-Forwarded-Encrypted: i=1; AJvYcCXRzMmrPAe14WoF5bXXXsG1cg0yLSc4Oi9BII+GR07GflBci9W21oV/k+GOVX0iGY4TRCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqYZb+L0D3qeCkoHJxucnNO3AwZXk2Dc25gqVUEfB47WUDeC/C
	hB1jwsl8aF6HGcbNl1CPD3ltLuBS9y+x4ocZOSv8f/wwd82uHnOmDv3XQnydirjP8Y8yMJJkcog
	tMB9RXvoUIks1RVA6Dz7nJin04ibukWZXPVip8C1HinZEx6aAedeAqQ==
X-Gm-Gg: AY/fxX692UtwyjGchJT4nzX8Oy36QtBFXcWETDyoSJq7aNcw6+4PnpoDwzJSy0QEjkV
	kYlenNoUUiSC0oiOtqQyJvqxlGp+MPqdBZ8tQd9/xTDoibsNkxWRyLWFB5vLg2q/Qw6bcgqsCLk
	o/5ZKYmGykeAXwElG0LRPYrRSHTplSF5ExmTLe22R/MnguCLxngtKAgyHYiOylZgb04Ms3PXS9B
	KcLDSHoh3a73jXeK8amxx8h8zIzJPFYFDFohwR86BrC7yQYWKJ260F4V18R+PIAM0OOeO5AIUwp
	PxnP5JKb2XwXreAMz1r563hHkuM6Hp8iTQD3//m3sOfRB0sAMkL1mQivPs12CfOR+rpAif6YAzc
	0uni1MRnv4i2Jy4F3tTIKdmi6TYXuxOfvWkGdQaNILHs=
X-Received: by 2002:a17:902:d50f:b0:267:8b4f:df36 with SMTP id d9443c01a7336-29eeec1e3edmr62250335ad.29.1765551916610;
        Fri, 12 Dec 2025 07:05:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErKXvfIsf0XdT2uZ5tfa/p411BIgMfaEjii4Bb7zfmVemQkpUTySz8wUPcvpT+r2XZ3sY+qQ==
X-Received: by 2002:a17:902:d50f:b0:267:8b4f:df36 with SMTP id d9443c01a7336-29eeec1e3edmr62248315ad.29.1765551914504;
        Fri, 12 Dec 2025 07:05:14 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:14 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 16/28] i386/sev: add notifiers only once
Date: Fri, 12 Dec 2025 20:33:44 +0530
Message-ID: <20251212150359.548787-17-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vm state change notifier needs to be added only once and not every time
upon sev state initialization. This is important when the SEV guest can be
reset and the initialization needs to happen once per every reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9a3f488b24..1212acfaa1 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1789,6 +1789,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
+    static bool notifiers_added;
     struct sev_user_data_status status = {};
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
@@ -1939,8 +1940,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
-
+    if (!notifiers_added) {
+        /* add notifiers only once */
+        qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
+        notifiers_added = true;
+    }
     cgs->ready = true;
 
     return 0;
-- 
2.42.0


