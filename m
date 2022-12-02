Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061DE640534
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiLBKvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiLBKv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:51:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A34EC7275
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669978233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01EVu86F03ZVkaisaIA8aOhxapK6bD5iJUUbcQRNmys=;
        b=gRBpVn4XFihIn5sMWZ7vHPj7PrTqcPk7f3MON2lpeIUdwZDH/iz1Zp1x2Rx6qagylD8apH
        jj/4jxKXIM+n0hu4onVD7EoxT0wcrykZ2IOaLze5fo44iNwf4gLwW6ziBSjZpN/MB/+yz7
        gi/YUlstB6B/dNnINKtWBpK/A9f8Bvk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-271-c-fSbOTqP-iZPQwqIgeMDA-1; Fri, 02 Dec 2022 05:50:31 -0500
X-MC-Unique: c-fSbOTqP-iZPQwqIgeMDA-1
Received: by mail-wr1-f70.google.com with SMTP id e7-20020adf9bc7000000b00242121eebe2so969476wrc.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:50:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01EVu86F03ZVkaisaIA8aOhxapK6bD5iJUUbcQRNmys=;
        b=1sHW1xd9Bg5KSvx/uqa2nuNbR4W2UDpaw3D4Hbj2YaoRiKsne0JcSS4QyH/SAh/pDl
         CRhA6leOFmaT714/zsD25WD/KwVK5AJ3bZssv1lm2RbUO229Lz4kEe7bO5/BmQlnPOfL
         Wz5m87JpCH++8RCng0jyVTqa1OnrEREEg5X9mRTM6owZNdihAxLMMpQsBlBuyabYBIB/
         U9VkeUts1J65L0iAUfka7YM2J6KxnyRCGFHjXjp9MnNgvvrZqki8GRUosmCXP+l1LL/3
         sN5O02dRRXuuHmCLaNKrPsDwSMl5klD2+3gugtms4k+MFzQwy/YkjpUpBfEsHcnqeXgZ
         xB3w==
X-Gm-Message-State: ANoB5pm6L02RvzySueBGGKQGJTaNw4WW57xMWz/R7uXv3tv+oAlfjRFj
        L5LoJGxxnY6mb93hLd9FFccDCL/Gs4MgkFg1CCLf6FihGF35YotE95axATBkBYNlqQZOeSSXYAf
        0VRPgqzxKnKLP
X-Received: by 2002:adf:e105:0:b0:236:73af:f9ad with SMTP id t5-20020adfe105000000b0023673aff9admr42046588wrz.225.1669978230867;
        Fri, 02 Dec 2022 02:50:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5gKhowvqyk/ROz6Tub/sMJPyTW0HCi4czVL2HWfKAPTpnGRqZYvsKYMG8CpBMMwJo8CzalVg==
X-Received: by 2002:adf:e105:0:b0:236:73af:f9ad with SMTP id t5-20020adfe105000000b0023673aff9admr42046575wrz.225.1669978230635;
        Fri, 02 Dec 2022 02:50:30 -0800 (PST)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id bg2-20020a05600c3c8200b003a3170a7af9sm9728818wmb.4.2022.12.02.02.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:50:29 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez Pascual <slp@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: Add missing arch for KVM_CREATE_DEVICE and KVM_{SET,GET}_DEVICE_ATTR
Date:   Fri,  2 Dec 2022 11:50:11 +0100
Message-Id: <20221202105011.185147-5-javierm@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202105011.185147-1-javierm@redhat.com>
References: <20221202105011.185147-1-javierm@redhat.com>
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

The ioctls are missing an architecture property that is present in others.

Suggested-by: Sergio Lopez Pascual <slp@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

(no changes since v1)

 Documentation/virt/kvm/api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b15ea129f9cf..1db60cd9e1ba 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3266,6 +3266,7 @@ valid entries found.
 ----------------------
 
 :Capability: KVM_CAP_DEVICE_CTRL
+:Architectures: all
 :Type: vm ioctl
 :Parameters: struct kvm_create_device (in/out)
 :Returns: 0 on success, -1 on error
@@ -3306,6 +3307,7 @@ number.
 :Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
              KVM_CAP_VCPU_ATTRIBUTES for vcpu device
              KVM_CAP_SYS_ATTRIBUTES for system (/dev/kvm) device (no set)
+:Architectures: x86, arm64, s390
 :Type: device ioctl, vm ioctl, vcpu ioctl
 :Parameters: struct kvm_device_attr
 :Returns: 0 on success, -1 on error
-- 
2.38.1

