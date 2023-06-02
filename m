Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B671F9C6
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 07:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjFBFwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 01:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbjFBFwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 01:52:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0651A1
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 22:52:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b0424c5137so14866915ad.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 22:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1685685139; x=1688277139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AE2xzqHFPvJyLtJ4dI+SdGtkCRUUUqd29Nrdavs8L6c=;
        b=ftfHeXNRAMYhQcolNfzeiI9JdhXWRWSgYhPaIr9WxLqd3yBpt0mr4nOoav09Gm8CW+
         cMa+fP6gJmjvjtJpLWBAS+j97NoaNa8uoNzg3fTEylxNElIUhWTwKBroyAk1SKUqW3jE
         IYecWesShL1NepJw6BYuWqk42/FrDtDowamdBxXFDmoz/kupL5dwT/qFn3ZstEqT6nvV
         tv4BTF/ol/x8nrnqZ5+jfEokGq13SpGDjX38N64yZbDEHm6BriF3H87RapLwcGqyyXyo
         QCrRUFeRbVxI5athO6QlqTk55KAGvWe3l8VwtEPtoC7FGDLqUe0yps0TXggyR2xEKG3+
         AjWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685685139; x=1688277139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AE2xzqHFPvJyLtJ4dI+SdGtkCRUUUqd29Nrdavs8L6c=;
        b=OzfhDhJe5OwaKUSn5p/GlPS1O4Sb+Dm+VSpn64/8oJysLRIfLKcBduXIQc/rZQO4wG
         oKF8wGRN9p2CBOnuntddtciobdrO1B6eMKieyupQxrUVp5TB95nq87Q7+b5J3HdNjYbc
         5MWS+biQFQxI0DBepMSbqt0W7zWFso7gK888UzvQB8+hgqs9FA17v/LG+1xnPAi6FhW1
         FVXJeCuyX9h4iMDQOWWBblcp5AIpSl/tzM5+fD96RTa4miNtnheNpNwInTEqJH0E5T8D
         W655R6XoOXl+2e4c0SIi+oc00R8MPSxJwhuxkGgk1s08rRF1mHRAX0Z7Z3Izo0haJcM/
         JnHA==
X-Gm-Message-State: AC+VfDxc+1mIn/coi+w41tWChyKKc1jLruLqyhxzEICo1bu49kTmq8MJ
        8QbNN0RtDZQNgmunNGd9gfYgSPl9SGsbtnpEavI=
X-Google-Smtp-Source: ACHHUZ5hYoSyNP1eBDO5vLkT94KN924ewF5hYgSdmxaV6A36IdMl7n1rKeC9tzdFIwyz0Gag9pSUOQ==
X-Received: by 2002:a17:902:ec8e:b0:1b0:4b65:79db with SMTP id x14-20020a170902ec8e00b001b04b6579dbmr1669736plg.63.1685685138776;
        Thu, 01 Jun 2023 22:52:18 -0700 (PDT)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b0019e60c645b1sm358789plg.305.2023.06.01.22.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 22:52:18 -0700 (PDT)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [PATCH v4 0/1] Introduce a vringh accessor for IO memory
Date:   Fri,  2 Jun 2023 14:52:10 +0900
Message-Id: <20230602055211.309960-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vringh is a host-side implementation of virtio rings, and supports the vring
located on three kinds of memories, userspace, kernel space and a space
translated iotlb.

This patch introduces a new accessor for the vring on IO memory regions. The
accessor is used by the proposed PCIe endpoint virtio-{net[1], console[2]}
function drivers, which emulate a virtio device and access the virtio ring on
PCIe host memory mapped to the local IO memory region.

- [1] PCIe endpoint virtio-net function driver
link: https://lore.kernel.org/linux-pci/20230203100418.2981144-1-mie@igel.co.jp/
- [2] PCIe endpoint virtio-console function driver
link: https://lore.kernel.org/linux-pci/20230427104428.862643-4-mie@igel.co.jp/

Changes from:

v3: https://lore.kernel.org/virtualization/20230425102250.3847395-1-mie@igel.co.jp/
- Remove a kconfig option that is for this support
- Add comments to exported functions
- Remove duplicated newlines

rfc v2: https://lore.kernel.org/virtualization/20230202090934.549556-8-mie@igel.co.jp/
- Focus on a adding io memory APIs
- Rebase on next-20230414

rfc v1: https://lore.kernel.org/virtualization/20221227022528.609839-1-mie@igel.co.jp/
- Initial patchset

Shunsuke Mie (1):
  vringh: IOMEM support

 drivers/vhost/vringh.c | 201 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  32 +++++++
 2 files changed, 233 insertions(+)

-- 
2.25.1

