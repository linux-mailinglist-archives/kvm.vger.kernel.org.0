Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120BE79D492
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 17:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbjILPQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 11:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbjILPQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 11:16:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34F912E
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7e8e12df78so4977144276.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694531788; x=1695136588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fQ49c/JFjecdsJrrBTctEITpCH+bABhw0PFfyjYBy0Q=;
        b=L0egMgxGShKidylFPaLzfcGNvoqulGGgHpVnZXKt++vQ7UYs+Dk65CPxZJpxrD08hy
         wjJBr42w83ggJ86G/8WTQ+KzLnDwNBScrWn/j2fdIt5A4/8zGfjPMYXwfgIpJ9O46w2T
         AnttR80osewTdZpQ+oTRIYNba+FK7kWO+YYZM3nzokRc+XEMX7iXf/eKLctfq1lTXGHB
         EdzYSyC6XedxNMWWudzqmPucJTXBjF3P7s1TqQdGgKHgGrW9a4CBU/vqLLSn/nfkz2TT
         7ms9FwnOg2vnlk5IJx1fyi+ylHihPMnBb9w58hWRMl/gofooZslPIvslJ3h0If7Nug1x
         3r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694531788; x=1695136588;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQ49c/JFjecdsJrrBTctEITpCH+bABhw0PFfyjYBy0Q=;
        b=ddlZjnc+wj90ujgFBZRRzZaGnd9rCIp6W5xImSNwacBk8aKYox+JMQx1GkaP89BVXl
         WwYOX+p2NLICruRlUsyM/YHz0oqtd7q9Dq24f2W8v/xBqrDGQR0iQFtsBBy4xvxP/6c7
         AAHtIHFwIck2pnyKneE7FBmfay61PsOeGDy1zRJ7e1N7KAI0XZKUjoDGA16ZPsuwotX5
         6P8KptrvNhW54o1fdlkJ2nvOvea0/8umOLJTXClkf1zDecFV+b+CpNXEuX+9vLu5QjN6
         2HROFE8W7z95bqQpSLA5hpMsbl3iSUSudKC59sa3K1oV7JdOKmQi2EopI2OggxNLStih
         YNoQ==
X-Gm-Message-State: AOJu0YxpW6iroGu4ExwuvV5r/yQxfgTSGGiprpO/5ABGzbpFzE4Ej6Px
        ugzIV2Tyt/UxQqn/xcw6IKFdEbY/Ps2/SYsYsRpWYTyjPRK1sgQ/xFzYFA2wUFHThp5vDreftpc
        S7d//sQ1FRmqSrV4SizRSoszKfZcT3BZrzAV8dX0b7jZdcdmRIGdcX/E=
X-Google-Smtp-Source: AGHT+IGOx5Erhy1wRIwx5L7rtxHBMSlAh/JqzdqfjKdPAkoNU1tOzjNlzhV+Hj3DIBzQB4P5BZGwPeAB/Q==
X-Received: from keirf-cvd.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:23a8])
 (user=keirf job=sendgmr) by 2002:a5b:685:0:b0:d47:5cc3:9917 with SMTP id
 j5-20020a5b0685000000b00d475cc39917mr313536ybq.9.1694531788076; Tue, 12 Sep
 2023 08:16:28 -0700 (PDT)
Date:   Tue, 12 Sep 2023 15:16:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912151623.2558794-1-keirf@google.com>
Subject: [PATCH 0/3] Fixes for virtio PCI interrupt handling
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please consider these simple fixes and cleanups to legacy interrupt
handling for virtio PCI devices.

Keir Fraser (3):
  virtio/pci: Level-trigger the legacy IRQ line in all cases
  virtio/pci: Treat PCI ISR as a set of bit flags
  virtio/pci: Use consistent naming for the PCI ISR bit flags

 virtio/pci-legacy.c | 2 +-
 virtio/pci.c        | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.42.0.283.g2d96d420d3-goog

