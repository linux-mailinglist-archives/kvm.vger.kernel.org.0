Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376E5687860
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 10:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjBBJJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 04:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjBBJJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 04:09:47 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3D17C73C
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 01:09:46 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jh15so1188760plb.8
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 01:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wj1wi+vfvB54wfWKyUZTobNpEfDR2hWH6JizNjshTls=;
        b=1Q/JH/sUAULTsLNVNGl+nJTH5Ax+tvJ+1r2DKsuwDfuOKK7Ec5J5bJnGtXbC45rfRC
         VynUJt6ACswjfIqa8MV8+aq8oj2HUPBfP0teYR/JHiz+uQcFDcvG0/t/1tUEWyWzCg4C
         EimV0skFo5WvorB8MwJjeN8RIM/0KZVjSL/U4Sq0/P3w8M+bciIDr8PXRPnNxwMYuhYp
         1uiIuZ1jZjWhqoykheNnB5QXWK6a0cb6X28sqYlLwQCnLc5tCl4KDqOueYTg1dZN8kaY
         gmXpt3eUAfDfZVXRPQ+OpYdbRcV6fVlEfZT1k2vMJ14BWtV2uVBge9Y8HoZ7t7JtqZDK
         i3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wj1wi+vfvB54wfWKyUZTobNpEfDR2hWH6JizNjshTls=;
        b=Z0iPraTYC+lrAylC/560urRRsN6QwyJNg4CsnjHhGubjh6QdWrkK+qJ3RDfHq+WVWH
         6Dbn/pIl0v9LGYx4rrTT8futqEmLF1zTRQrlbqIeU4LFjAi6xwdkthab+UFrxqY3NFaN
         tZWzhE17kM8AOtQ8z4OyZdymw0moMKAGwo9/IHqR0n9T41PcTFHRucKxzY5gvhK8bmxw
         CIQDw6TI1hDwYcci7DU5j+fVhVG53Q1JXvLRazskwD+qCywRHFl1okUx5hvqyr6adv0y
         k+t/VtUsUh9h1KGQoUijSun9BiXZOtuU81YE2pjgzoPhvL6+e747pl87xVLbKjChEjc3
         NEbA==
X-Gm-Message-State: AO0yUKXmXQQLgEtzv8V56ReSBmcO7WsFHCTKSlFurfWIceAGgVPFv5X9
        praxZhHShcUz8yvVXiZ2pVLs//y8WQe/DpvL
X-Google-Smtp-Source: AK7set8Mjt/sTl97PMKSnJmxqA5B1xuZBtgxd19g5SZqOTcdXWGQrZOHsyfNQ13X71sz0ldcLMsDJg==
X-Received: by 2002:a17:902:e810:b0:194:81c9:b8da with SMTP id u16-20020a170902e81000b0019481c9b8damr7411648plg.3.1675328986637;
        Thu, 02 Feb 2023 01:09:46 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b001929827731esm13145968plb.201.2023.02.02.01.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:09:46 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH v2 2/7] tools/virtio: enable to build with retpoline
Date:   Thu,  2 Feb 2023 18:09:29 +0900
Message-Id: <20230202090934.549556-3-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202090934.549556-1-mie@igel.co.jp>
References: <20230202090934.549556-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add build options to bring it close to a linux kernel. It allows for
testing that is close to reality.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 tools/virtio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 1b25cc7c64bb..7b7139d97d74 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,7 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h -mfunction-return=thunk -fcf-protection=none -mindirect-branch-register
 CFLAGS += -pthread
 LDFLAGS += -pthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
-- 
2.25.1

