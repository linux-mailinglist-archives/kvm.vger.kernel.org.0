Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5747243A7
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbjFFNFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbjFFNFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:22 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCBBE78
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:18 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f6e13940daso61926955e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056717; x=1688648717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJve2gG2xkfjku6DUmV88NrnWL7jRqBntctBajIvbRo=;
        b=XImr9kOS5lS9h86FQQwWgbanzCLPXe3BCROPUSTK2zsFxxSOGQ1O/HEv10QLbd45DX
         gz6JJnwzpjC2P9/bLhUMErPjkae62KGKMnnLimdu/43rtY0oSMteCsodX/gMLFC7fT0f
         OQWjPs4FC1bp/l+fHKo00kWql8ei1kSmMFJdywuOIniBEEc/Q/OH33/LtS56xixZOX9Z
         hT4UMYQ4Ht79DToaCB28LPVJ4ZXmxyR14BLKilG+FnQQVg0Uog7apr3ufVPuU6gEuvzO
         /K+AuClATC0tbn6ZAjm6JYyxxSke1wakOZcjM95b1SFD2YNEUDVZXqTebplmGMeuUxkR
         DEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056717; x=1688648717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJve2gG2xkfjku6DUmV88NrnWL7jRqBntctBajIvbRo=;
        b=GDaQ3K0YuEikmdyu1nFY7LABCkNsmORbpfUsAjqjlFXns7aF/3LEsgn/ahfi0DiKyG
         n/uzl/nQeqozo+MbGtE+aAGxgj48vlBzl3edjCCfSQAQULmfegIZfl1xxmE4saYT47rT
         cExNyA9/yI1PxXXKtJ1eiuQv3VCMzSwmXmEz/M1rdwNj5Ez2k4gVlvR4YEbVZfZG+KN8
         aGq6NiXaYqfQPGRCBia+6mtPqb2mVgsmwljmIkYaipxsX82AUTk0/Xr2xuhRHE3nN+bK
         crt37jm6+v5EImT88Pgdc8pZLRseGtIfQVB0+TvQWjopkTi2zl91jb+HWSmuLD1N5aPN
         oVVQ==
X-Gm-Message-State: AC+VfDwHiY7aHsy3IORylRI78WcarwdWvV0fp3R9WoVWCCYOC/0N8+Jd
        qlqS1mPCEvpIwoHEX6MkEMbz21Z7cG5H64H7axCBiA==
X-Google-Smtp-Source: ACHHUZ5GVkG5KeRrr91RmSwQMN1YpkPYxj0aQlG2S7XskI8eG0W5YGPZ+B8ucBlrr5PJNxvstx1z4g==
X-Received: by 2002:a05:600c:291:b0:3f7:e6be:bba5 with SMTP id 17-20020a05600c029100b003f7e6bebba5mr2127802wmk.28.1686056717143;
        Tue, 06 Jun 2023 06:05:17 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:16 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 08/17] virtio/scsi: Initialize max_target
Date:   Tue,  6 Jun 2023 14:04:17 +0100
Message-Id: <20230606130426.978945-9-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux guest does not find any target when 'max_target' is 0.
Initialize it to the maximum defined by virtio, "5.6.4 Device
configuration layout":

	max_target SHOULD be less than or equal to 255.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index db4adc75..4d1ed9b8 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -73,6 +73,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	conf->cmd_per_lun = virtio_host_to_guest_u32(endian, 128);
 	conf->sense_size = virtio_host_to_guest_u32(endian, VIRTIO_SCSI_SENSE_SIZE);
 	conf->cdb_size = virtio_host_to_guest_u32(endian, VIRTIO_SCSI_CDB_SIZE);
+	conf->max_target = virtio_host_to_guest_u16(endian, 255);
 	conf->max_lun = virtio_host_to_guest_u32(endian, 16383);
 	conf->event_info_size = virtio_host_to_guest_u32(endian, sizeof(struct virtio_scsi_event));
 }
-- 
2.40.1

