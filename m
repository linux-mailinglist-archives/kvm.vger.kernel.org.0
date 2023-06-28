Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6E740714
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 02:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjF1AOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 20:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjF1AO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 20:14:29 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02D2E8
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b82616c4ecso7476085ad.2
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911268; x=1690503268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZjcXPxOnEy7+SOVIdg9yFzDIlL6q00qvIVRkRmdKtM=;
        b=DKB7JOxPefuZO7KixVJFWWixhZBrTUmoOWjWM6HbkNPtDJ7RbVMWVl6G+QYa8/0Nez
         VHQVCnrnSTflid3YqbihoTRbjdG7G0cJHmZOgIfoEorGz8Op/66NSyMDNTTtlUDzw4JU
         aMKiH+2Vw0Tgx2tMg9ITPTCQP69+dvxX1tatkgiK5oR8pL+yrznMTNWbHvORRCs5Sp++
         XEh0e9zrdznltdWvWNkc3wOlpsb0AuPPu0LN+zg7fj/OzOWE+EIsND1JVrKHMQZ4ZY2p
         TAZCmwRU4oT6/4tm6fmZGWH4Cni0vHZG5naAUjbEM4lu6mgCdpx3HiPS7zENgM9B0V5k
         GdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911268; x=1690503268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZjcXPxOnEy7+SOVIdg9yFzDIlL6q00qvIVRkRmdKtM=;
        b=g8HGq6hGIeLIQ4Xm9pjkDHWtfzZvu+LzBuaGTnCk6tZEwwfTPZf3dYmGN8akqAXnxH
         S2O+z58JMA0+AAqas3B2y8/N0mbg+Aoo/HIIdoFws947nj1HM1EFcn4tN0b0iPe2maHD
         rBsFMYWHW8axZotve9dNRnnhLEZhzatt2pdR+msxXEbx4Uf3X5G/YIVvyCkE3XckQbR+
         sx3+1lvX5zOJ05U1/y0sC69MNTW87IoF9HiIKDKS0m04J3Z2++n4iShkDeCQn83OkL3L
         pFpC5coWc7Ac9Usf7iHEJzBzsc3W1y3Enp+akyhf7Suwt8LqX20KmcVGjLllFeRTBXX3
         8LUw==
X-Gm-Message-State: AC+VfDz0Hn8rZkUrED3oTCVCJ7pG23Ot8T5ZWRn3A8CPcqEHpzrA8i7q
        zqVRLtrlM7jtQTXV7Ct0JHU=
X-Google-Smtp-Source: ACHHUZ4ajl/K9Afuy4wmkbZFJTlHaXfzvMo7K6CnfYtIi4x1dX/K2YDRLAr1sl1b7VUp9WmPnjfpFA==
X-Received: by 2002:a17:902:ea06:b0:1b8:50d:9dd9 with SMTP id s6-20020a170902ea0600b001b8050d9dd9mr7276070plg.51.1687911267850;
        Tue, 27 Jun 2023 17:14:27 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:27 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: [PATCH] .debug ignore - to squash with efi:keep efi
Date:   Wed, 28 Jun 2023 00:13:48 +0000
Message-Id: <20230628001356.2706-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 29f352c..2168e01 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,6 +7,7 @@ tags
 *.flat
 *.efi
 *.elf
+*.debug
 *.patch
 .pc
 patches
-- 
2.34.1

