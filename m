Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E22453B1A
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 21:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhKPUoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 15:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhKPUn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 15:43:59 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F88EC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:02 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g18so502865pfk.5
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1AE+HQrLi6BxdLK3n3GfzMpS9PYJGXdqFTYhG0I5PN4=;
        b=CQNFR7NOP7hkZb7c0hL0VBiZNje2CdB/E2DvYx6r9Jn2i8RZ0BVM+KlK2PK1hkMglY
         AjFvlfEl9D0dRuBXG7y8mUfAG2SsEFzI+na8Xl80FGNnvGQ/15cJB/S09Exrv0nGOIgS
         90UV9LhfgtYVtxmFub5q+YnEZrmgXvUSIGUMJlPnT21ESJtV17L+KWn7u/VDk2sW/ZVX
         dOjyu4LVfdvQIglSeK+Jx0lUE2gEN6+UFkC+gqHGbLDhMh36wvdrzi++XrT/h46o2dhZ
         CzxwZz6Nn1wQhDfr0KMdPsOoUnjYhAGnVhcLzTwDun9rwULs8jMWmp43b7idj0uB5SFU
         t7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1AE+HQrLi6BxdLK3n3GfzMpS9PYJGXdqFTYhG0I5PN4=;
        b=iBDUXa+veB8Hz8PJMdGpGo0UphIu0YKOTCtWN2zB1Cf+hoBS3cSdtvMgkfu7n1k4HE
         FPI8YiSJeQyfBH6CCMacntHLBM6iBXc85dKNtyDMVxxTa6+kPI0DzBJBgHakX/EYViZ3
         TnydyDKaFkUyx5FRtnGDH4mM3G6r5Hwq6yZhn/pI2MmsYdKb2yJuaITWMmSoO1PfTbPm
         /Ga9rblL6q4tNnJCXDsKjs+oCGY7b3OzbRdeXU/AkxQZwx7lR+q030FBTWHiplBBVCde
         nmrTFPfwoXP5rpTzmL3p6GOsD70Mlg9Y36nKSxfsLRf+mMZJkWUIbPvUfcLwvdtMoH/N
         nMtg==
X-Gm-Message-State: AOAM532FL2J+c6YGwgxthGUEktKewsY6oI0lbn67tbZVVnraFw6WWF4b
        VwuyK4kl2D15L6g0IkBzai2E/CTBTWy6fw==
X-Google-Smtp-Source: ABdhPJwE8Dsms2V2K60CmGEakBLb7kONv0fZsLxvGQPl51bmBvzafVbOxLWw16Rh7PVypS3lUCeyPg==
X-Received: by 2002:a05:6a00:847:b0:49f:9d3c:9b4b with SMTP id q7-20020a056a00084700b0049f9d3c9b4bmr2025839pfk.16.1637095261623;
        Tue, 16 Nov 2021 12:41:01 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id lp12sm3652359pjb.24.2021.11.16.12.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 12:41:01 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v2 05/10] x86 UEFI: Set UEFI OVMF as readonly
Date:   Tue, 16 Nov 2021 12:40:48 -0800
Message-Id: <20211116204053.220523-6-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116204053.220523-1-zxwang42@gmail.com>
References: <20211116204053.220523-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

Set readonly for UEFI OVMF image.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 x86/efi/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/efi/run b/x86/efi/run
index a47c0d5..922b266 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -54,7 +54,7 @@ popd || exit 2
 # UEFI's largest allocatable memory region is large enough.
 EFI_RUN=y \
 "$TEST_DIR/run" \
-	-drive file="$EFI_UEFI",format=raw,if=pflash \
+	-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
 	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
 	-net none \
 	-nographic \
-- 
2.33.0

