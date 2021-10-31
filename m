Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64E3440D4A
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhJaF7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhJaF7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7018C061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t11so9520159plq.11
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1AE+HQrLi6BxdLK3n3GfzMpS9PYJGXdqFTYhG0I5PN4=;
        b=EitNloUirz5xkSxpOfPQgKhb7+FYdDgIJYKwSCxEsV3JPxip1IXQG4RCxJXZJndYVN
         QMT1i5AGrNZABQveJKIUR7g5jOgLRChARixFdNp5btHnvAETBd63DnRrS1b2FTLJ6/Th
         k5gWtH3dmOQWXYbdMUNdxA1v3YiDN9Tjp0rnsnG29NRQT7C0/xO5aHfWEiDwsCqQYO3n
         eBhPWWWP1BYDrR9aezpjx5/rpwcTjqltmBjN+/dEYi31lOHzKYlyOwrv4f3xs7r+0vqm
         tIe3xO4egIbt6NUt5QMdivKPjlUsKCsRSSExcqVplXTyoCsW3fPd1ayABL3RWt9qssNd
         uMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1AE+HQrLi6BxdLK3n3GfzMpS9PYJGXdqFTYhG0I5PN4=;
        b=Y7CA7Q9lJywPiJb1AhP8j2my0+rHvr73sP/ERrlaIHZCg0DASS5ajJ4Kzq7xsB44T7
         8HSDWmzvwP3ngRK0tl4BAt4oHEyHzAoHMV7J09qFDCouaD1VjSnlVZoUh2FhgzOJbIg5
         Oey02bkZPeQa3RMLEarAuBqPxuG+DU5xoWopav63qrntHWNx/9BdMWlfDGE32bagcuCy
         PENm4nrjUHBO+aFKCmhL3AWk+65lkbNNbqg6DyduG6qS41lh9vWLkilCRpq/FL1SARdL
         5xs0e4FnVp9EpR2267++SUFx++vrVK0Ev1ggA9keXDEkZv9uS9Riun8opzmmBsI1iSB1
         awgA==
X-Gm-Message-State: AOAM530i2bKTT09sLoKDEQnzTz2k/M8dznclgmBPs7Zv3/mb0LhKmG4i
        Z05waSNYE1OD1Ljv6h2Zy8vvOSSNk8jhOg==
X-Google-Smtp-Source: ABdhPJznpFPaJYmMSiHP9U9DR8docdU1O/2t+o09yBuH6RsBPLh0XqvnlXqJ+YLxVa5KbQqq9J3J/Q==
X-Received: by 2002:a17:90a:bd04:: with SMTP id y4mr21692293pjr.99.1635659802909;
        Sat, 30 Oct 2021 22:56:42 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:42 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 4/7] x86 UEFI: Set UEFI OVMF as readonly
Date:   Sat, 30 Oct 2021 22:56:31 -0700
Message-Id: <20211031055634.894263-5-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
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

