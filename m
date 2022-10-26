Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B660D8D6
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 03:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiJZBcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 21:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbiJZBcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 21:32:45 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666FA1EAC4;
        Tue, 25 Oct 2022 18:32:44 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n130so16801885oia.6;
        Tue, 25 Oct 2022 18:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g9R9+PxTrlRrkkZmEELhL8CZSvfBezTCEriP1+VflcU=;
        b=n4xrKM8m8sxo17OO6CGkjRgNDlZNbcgP19Ni7RoDzWR58ALVXLfL8NTVWcW/mSMzB/
         4OfObsBFmY3j5RniDrQ1AywBdcVVsv3kBfkE+HwTFqMp1si6m1ba/bxCPtuMkyRToEf4
         CKMnTbFG00Gfd+/1TkZoAeyG2p+QeXFzDiZFRPOMRsxc6gMDNfvCny5NZVtDcvLEeZEb
         YVm1Wj7PJXTUBKXl0QXJn76rsASRvza+Lw4TzHzEyQOh9Lj2A1B/u1DtO87h7Yb+jyUx
         rPcXLXg0aTZay37NiZ/l3jG12TybKUOdCdGVSSjFgTtbELlUBy6WydoHd+Arcamjg9Gc
         pjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9R9+PxTrlRrkkZmEELhL8CZSvfBezTCEriP1+VflcU=;
        b=Tl7j8+FDO0KZDyw2PRZG6C7rr3IJUZ3Q4ntUOdmWuAU50IlvELZyEXFST4hUYTSUl1
         5kkNMHV4NGc1yP9gD/t//4QPun05P4EOZY0h/DxWyYpO/+2Bzb2ShWMQxr1e547GyXcs
         17VqLcnFHVv8ANA5gE3NdVXRPNSdOmtYmfrqeAr7xkA8YcN9uc9LV3rrStvrDVgz4GPB
         wa3gGDgSO3JIW3LLKBAOtTKiNdOrNirVUAEYJ1pjCN9DKG4dBkNXoS6+eLcqjPzm+QUf
         l3uYyraVSLmBj7Hv/Ag5NafygbyiOKmkal0FbC3C6f9tPft4pM0IONb3et0tMwqtBT1X
         vNgQ==
X-Gm-Message-State: ACrzQf3M3oGktPex4cIQZm063bJ/w0c+CkK5ku/qP474VgVZbS7aWAhX
        xQ0WA9L8FE/xBY9RvcSdhXH9tp5LrNJRuA==
X-Google-Smtp-Source: AMsMyM5iahaklTBzdGpL+EGlNjfWzzcFzL6ttfvdC5spRCD+RTcF2bNEd0xJuaZHfyN3Yp3xv+zCcg==
X-Received: by 2002:aca:bc06:0:b0:354:cf3a:b81a with SMTP id m6-20020acabc06000000b00354cf3ab81amr626942oif.53.1666747963702;
        Tue, 25 Oct 2022 18:32:43 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:c8c9:a9dd:b961:7f3:f8a6])
        by smtp.gmail.com with ESMTPSA id d2-20020a9d4f02000000b00663d087dd36sm1730403otl.23.2022.10.25.18.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 18:32:43 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: pci: Fix allocation size of aift kzdev elements
Date:   Tue, 25 Oct 2022 22:32:33 -0300
Message-Id: <20221026013234.960859-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
'kvm_zdev' structs. Allocate the proper size accordingly.

Reported by Coccinelle:
  WARNING: Use correct pointer type argument for sizeof

Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index c50c1645c0ae..ded1af2ddae9 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -126,7 +126,7 @@ int kvm_s390_pci_aen_init(u8 nisc)
 		return -EPERM;
 
 	mutex_lock(&aift->aift_lock);
-	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev *),
 			      GFP_KERNEL);
 	if (!aift->kzdev) {
 		rc = -ENOMEM;
-- 
2.34.1

