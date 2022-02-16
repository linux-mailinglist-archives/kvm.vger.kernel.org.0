Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ABB4B7F8C
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 05:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbiBPEjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 23:39:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiBPEjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 23:39:00 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EC0F1EBB
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 20:38:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q132so1088753pgq.7
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 20:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42gb/Pacce5pVrRpUMhRyEAX/Pkf6R9/qxHTc+LWHsg=;
        b=zeBU+pWKUUW8WUcvEvZAP3xj+Sbc9C/n+HN8aqrmTeGfVM4Ydx41pb/ISmkCiaCABi
         r1FKKd/dPcMm0aLXGmqyUq75PZoOrYjWLbCB138Ee1C2Cj1a0dm48d2IRiUknxPZzxzF
         YJS9Jod7zIJOqaQPAHKziiqbIxLfZJzLzwpnyPiUZKY82V8pkINCTazlTNayCPwqI++8
         U7zOdvcY3C2vQX6UYF0RVtNwWwG6+TcGrrU1iN+13fPWC8Ygj5jCE3ZnPjI1vCZ8s7rr
         vIfF7i+B4+19rG3CNq2CNIIg14iKdZgchv+Xv62PWldtf5++fE6NCq8Edq44NLBPoaj5
         XZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42gb/Pacce5pVrRpUMhRyEAX/Pkf6R9/qxHTc+LWHsg=;
        b=kfBVzSKflLR/Z04lSMFQolkTWZW/idmION+uBJ+43yxg4zIhJlk3QntEY6WAMaKMUf
         2KrorSnBAyTt5xInwwGDy00XrtLTZVfizwI4CppHzpackSge/MXq3B8c346iCj1Gw4c/
         J65Hit/pvIHo1ryUqR7RO3l+zk0mDV8w0tx+c39j0vAwtbGlmP5MLKK+g+X7lRgCuQHU
         1zVBGmGJ28DtEk0m6efx15P8z2yLwYzZ197JMyjKFsN3p3HuUtPkiDE1dQXk9oRENvMv
         jT1Ch8Io5TcCqKPFHA7HvwqnKNiBwO1V7U5u5NmjUpEpRh+XhBwrj8S4esr2Je5YNgEK
         MIBg==
X-Gm-Message-State: AOAM531z1vbzbhw4xrfPfRyR/ciVg+rKbw+YY8vhy2FzQGNdKfiEWGKH
        YjLdhGQFaavkGOYXhyQKkhClWg==
X-Google-Smtp-Source: ABdhPJxoLZ4tLLPsmBxZh3bz+6KHXmcFoNQq6UyYdcyGhyb6KGH2uOqoKyZ1DeVZa0fFZg2h5CtwbA==
X-Received: by 2002:a62:5347:0:b0:4e0:2ea8:9f6c with SMTP id h68-20020a625347000000b004e02ea89f6cmr1382032pfb.61.1644986328297;
        Tue, 15 Feb 2022 20:38:48 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id lk8sm9115190pjb.47.2022.02.15.20.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 20:38:48 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     kvm@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH kvmtool 1/2] kvm tools: fix initialization of irq mptable
Date:   Wed, 16 Feb 2022 12:38:33 +0800
Message-Id: <20220216043834.39938-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dev_hdr->dev_num is greater one, the initialization of last_addr
is wrong.  Fix it.

Fixes: f83cd16 ("kvm tools: irq: replace the x86 irq rbtree with the PCI device tree")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 x86/mptable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index a984de9..f13cf0f 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -184,7 +184,7 @@ int mptable__init(struct kvm *kvm)
 		mpc_intsrc = last_addr;
 		mptable_add_irq_src(mpc_intsrc, pcibusid, srcbusirq, ioapicid, pci_hdr->irq_line);
 
-		last_addr = (void *)&mpc_intsrc[dev_hdr->dev_num];
+		last_addr = (void *)&mpc_intsrc[1];
 		nentries++;
 		dev_hdr = device__next_dev(dev_hdr);
 	}
-- 
2.11.0

