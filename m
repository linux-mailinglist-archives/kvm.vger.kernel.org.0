Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB5630D9D
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 09:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiKSI5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 03:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiKSI5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 03:57:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D329DBA1
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 00:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668848203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mH+aNM2CVMwH3fEpJlA6Odig9WHLu4rdFuKDTlmn9xw=;
        b=L3QTLpmlYzgqA0rH6bQNF2uRYhGycwoEvwAVAC0vvcKi11gvATQDWdvIZsXEuq/DrK5UfM
        VTN59vVcMuRpAOd8OlzVDklaEn+e7ODTu49C1sFwDhwNzpIBMnyV3xFL8MLhgTWO+f4oo3
        ZBdvL7TOQC7AMAWg1PgdnyPFkLDvFA4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-cMFdFgJCMRaGBqOi1RN7Mw-1; Sat, 19 Nov 2022 03:56:41 -0500
X-MC-Unique: cMFdFgJCMRaGBqOi1RN7Mw-1
Received: by mail-wm1-f71.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso3540414wms.8
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 00:56:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mH+aNM2CVMwH3fEpJlA6Odig9WHLu4rdFuKDTlmn9xw=;
        b=VKsT5FOKUrXs8/jWGFrDnCXxwq32yHtCjcPchyEGInV3CVDCVEUwyc93l0mUeiw+wu
         7o8l4gHu7EA9iz6vbWCfKtmMeAh0m4yJzVnSt+ME/OjmsUbb1+JX1o3q8kmrsS3NAJMa
         RtzXseF0w9Esnx2kIuB7ak1NQBjaN576RChnoSFCgV5jB35iJ0W6c9hzTDmiQ4pz9br4
         LdXlh/UHlrryYyZM9SvrSFHEpYrvpiPyJtcsPU90UOIutsaz8OmxINV51yBsTvXxlx/l
         yjj/fY5szQjCmMs2YYv+qJoFP9CnsffnQ9lLwZ6d94PYcrbUYF4GjjKJqPd1zkzFUMGf
         s+sA==
X-Gm-Message-State: ANoB5plwuhripyEjcjEQeN8KL3I06/S+q3STlyZWJid6gMVL3rU/Ddqs
        jnSZyjlwLIhN+d1DQtOQmy7hJl3GtW6jIrKAqt+Ron1tDepQWUFXtX+Ns9neDClh2Cd9JCJ4T1Z
        z/4feadouv2Ng
X-Received: by 2002:a05:600c:688:b0:3cf:a18d:39a4 with SMTP id a8-20020a05600c068800b003cfa18d39a4mr6918245wmn.125.1668848200628;
        Sat, 19 Nov 2022 00:56:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6qupPcZoq50xJgdSZoP+qL0pA/oAKL+yADqU3RoWWkP/e/BZHdbrcFH9iAJ2xEEvIoj2TvWg==
X-Received: by 2002:a05:600c:688:b0:3cf:a18d:39a4 with SMTP id a8-20020a05600c068800b003cfa18d39a4mr6918229wmn.125.1668848200359;
        Sat, 19 Nov 2022 00:56:40 -0800 (PST)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id fc10-20020a05600c524a00b003cf9bf5208esm12708160wmb.19.2022.11.19.00.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 00:56:39 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Sergio Lopez Pascual <slp@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/2] KVM: Mark KVM_SET_MEMORY_REGION and KVM_SET_MEMORY_ALIAS as obsoleted
Date:   Sat, 19 Nov 2022 09:56:31 +0100
Message-Id: <20221119085632.1018994-1-javierm@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other ioctl such as KVM_ARM_SET_DEVICE_ADDR have a (deprecated) next to it
which makes it easier to determine that is deprecated. Do the same for the
ioctls that have been obsoleted.

Suggested-by: Sergio Lopez Pascual <slp@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

 Documentation/virt/kvm/api.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..c17bac32d25c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -272,7 +272,7 @@ the VCPU file descriptor can be mmap-ed, including:
   KVM_CAP_DIRTY_LOG_RING, see section 8.3.
 
 
-4.6 KVM_SET_MEMORY_REGION
+4.6 KVM_SET_MEMORY_REGION (obsoleted)
 -------------------------
 
 :Capability: basic
@@ -368,7 +368,7 @@ see the description of the capability.
 Note that the Xen shared info page, if configured, shall always be assumed
 to be dirty. KVM will not explicitly mark it such.
 
-4.9 KVM_SET_MEMORY_ALIAS
+4.9 KVM_SET_MEMORY_ALIAS (obsoleted)
 ------------------------
 
 :Capability: basic
-- 
2.38.1

