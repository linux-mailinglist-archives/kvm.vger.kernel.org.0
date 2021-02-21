Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3217320A36
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 13:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhBUMMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 07:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhBUMMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 07:12:07 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07D0C06178C
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:26 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id a17so47264940ljq.2
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BaYeStx5XlEI2H6fREV0PGgKmNTuolmOOj8Wnxngjs=;
        b=QGUUUqwYGj3Bl/lr90Oe9KVytxhiEOK0IuBBCOV9l8LowRPufr5Q1TSW1mhdPCzXYX
         7BJGIOm78YenXRt/KoPDcC3kvQH7WDjFMLGcCIkfaQTDRKdFM9Btfha5YnnDx71gtX8v
         g1a9d+N5dRoYIB8pmtf4e+Y5FokO2hil6Q67hd5syBEwQ3kAdmacR4f+p2zfRA7Ac8Bn
         y32Idt0CCDrhKZrmyMQ8OK4Bvz7bxMMogHUMafNbk2Jno46LNYx/KbLmQFPdnB9YC3+J
         Y3b7zrBEng2F4TKcSr51V1ddyeKR1sfvjaKwOmbi3JCyCZkO16/yhSF7Jb61SYpXUlVr
         v5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BaYeStx5XlEI2H6fREV0PGgKmNTuolmOOj8Wnxngjs=;
        b=cLo0WNCEOXy9QFCpBaAKqCNT/A8y5MkNW5QKJpObjOnzHxd6w06t5bMPkghHytmEQT
         Q6MUt5HuVCcXDysmyL2wq9MgGL9LsywOp7hPnq8Uo5EFPUjjIylmwAbi3V6XGk8MP2AI
         P+bTXJphpk6mQQeEtJidAHSUq73J//PzbYZ6kzZHJIuG6FOiGgl1LMAb6n75zBadXULT
         sxjWdVq5sg1FZEGjDVaA7GlJgSRcGwhsoWqcJKC8OqnW9NrHU0iVEA3ODCWEqmnt6Ox4
         MBvNKwnFh3+w2qkyPw4dmzx3treRfaE093kn39uA9zXoHKVxAX9ETX9ddYgcWf9gugoM
         DzKw==
X-Gm-Message-State: AOAM533rCz6LHoFffRyo5uhZ/nhOAVqObhY9O725W67IwZtWFlGpr6TN
        qQgLCBD0hsWG0IWnx6db4jqUXnCeMt7NRfnQ
X-Google-Smtp-Source: ABdhPJxru09ZwV8MbCjkpcHfT/qCx8SjEGcn+/3yVxYO9XyvcHoJpoqW2hvMt3h6EXnCoHwSuj0Exw==
X-Received: by 2002:a2e:9b5a:: with SMTP id o26mr3274555ljj.6.1613909484968;
        Sun, 21 Feb 2021 04:11:24 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id q6sm1547715lfn.23.2021.02.21.04.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:11:24 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v3 5/5] KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
Date:   Sun, 21 Feb 2021 15:04:41 +0300
Message-Id: <bca4faec42f779d17b7fad7890eb9d27bfea76fc.1613828727.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ioregionfd relies on kmemcg in order to limit the amount of kernel memory
that userspace can consume. Enforce NR_IOBUS_DEVS hardcoded limit in case
kmemcg is disabled.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 virt/kvm/kvm_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index df387857f51f..99a828153afd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4320,9 +4320,12 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	if (!bus)
 		return -ENOMEM;
 
-	/* exclude ioeventfd which is limited by maximum fd */
-	if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
-		return -ENOSPC;
+	/* enforce hard limit if kmemcg is disabled and
+	 * exclude ioeventfd which is limited by maximum fd
+	 */
+	if (!memcg_kmem_enabled())
+		if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
+			return -ENOSPC;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count + 1),
 			  GFP_KERNEL_ACCOUNT);
-- 
2.25.1

