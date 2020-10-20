Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A932940FE
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 19:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395096AbgJTRBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 13:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395094AbgJTRBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 13:01:09 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB5EC0613CE
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a17so1207882pju.1
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eaYqmjcMx802IYh8As8yQQI4HZLzXd0/F879o5VXjTg=;
        b=tXJEuhUh/jBCkoIm18hk/J+QQErGA6dM6aodvpm5zAjpd0SMaC9cj5NzSsVeomWwdb
         uMISMjUWoDPDuNAFVKlYOEfjlphlNV77EnuuF/VObOBaIsCnq0kxkm1iqywQmpNaxH7s
         RakE6JuJh9Yeru7KCeiEDvMZlJ1ZHkPPdjt2auaANrVz8k8PotKbJibCkHe+VM/CQG/t
         YyalaEC9NvE8uiwSmit9I57v0mAWMyknlHFF5bNd9XGOeEJ/whGazNu0uiM/t4PgAyvK
         i+LjYHhxFKarkk6JTNrJKpMFGFJotDXrai7JIvgo6GXWnYfoAmY+DfG4gmom9gteZ5Xu
         uuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eaYqmjcMx802IYh8As8yQQI4HZLzXd0/F879o5VXjTg=;
        b=Q/VUMq3D67vb+64j3zh46UUvRQtCq9Diqhs9S+tW+PK3KwXVVLr6iFpdtKzg0oqHuo
         19DITorkmpjs+5W4jUdG04UNrn7RKgYwDdgBnlmD47w0qRi1YK1dPSkay8lpbbpTHQ4f
         xgQhOoxVx44APowa/hoqELqDO7T//aKhu68cCKxPMym2BJVsgRkSGHSRKrZXWZf9euYn
         ii6Qo00yfNK2W/KeqwNCQpkzgwHFDiYZ26HtTxOS8f2czgfdklFrmyC8gNSDaNrYhS+R
         J+oX7SdXG6NuKrBGTUzwrHD9VjP1WXy12WnI9hMAgfgpD0mU9dy7GTRl6hhdlf+xs6CF
         kaMw==
X-Gm-Message-State: AOAM530CIHC2FhebHVsxwHBUm1Yv04uoNUW7ytrRjDmWGF7AJS/u1mtR
        QAa3MuknRMyvGbIG+VZHhmk=
X-Google-Smtp-Source: ABdhPJyrIZ0jrQpUiVQiMr6asT4wMDG/t4eFF26d8JnKNK5AR8/YFD8r+JrSG6otU6RLsyXjrWbfiQ==
X-Received: by 2002:a17:902:c24b:b029:d5:f14a:318d with SMTP id 11-20020a170902c24bb02900d5f14a318dmr932875plg.4.1603213267195;
        Tue, 20 Oct 2020 10:01:07 -0700 (PDT)
Received: from localhost.localdomain ([103.248.31.132])
        by smtp.googlemail.com with ESMTPSA id x29sm2766161pfp.152.2020.10.20.10.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 10:01:06 -0700 (PDT)
From:   Amey Narkhede <ameynarkhede03@gmail.com>
To:     qemu-devel@nongnu.org, ameynarkhede03@gmail.com
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] linux-headers: Add support for reads in ioeventfd
Date:   Tue, 20 Oct 2020 22:30:55 +0530
Message-Id: <20201020170056.433528-2-ameynarkhede03@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020170056.433528-1-ameynarkhede03@gmail.com>
References: <20201020170056.433528-1-ameynarkhede03@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces a new flag KVM_IOEVENTFD_FLAG_DATAREAD
in ioeventfd to enable receiving a notification when a
guest reads from registered PIO/MMIO address.

Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
---
 linux-headers/linux/kvm.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 43580c767c..3e71d15a53 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -695,6 +695,7 @@ struct kvm_guest_debug {
 
 enum {
 	kvm_ioeventfd_flag_nr_datamatch,
+	kvm_ioeventfd_flag_nr_dataread,
 	kvm_ioeventfd_flag_nr_pio,
 	kvm_ioeventfd_flag_nr_deassign,
 	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
@@ -703,6 +704,7 @@ enum {
 };
 
 #define KVM_IOEVENTFD_FLAG_DATAMATCH (1 << kvm_ioeventfd_flag_nr_datamatch)
+#define KVM_IOEVENTFD_FLAG_DATAREAD (1 << kvm_ioeventfd_flag_nr_dataread)
 #define KVM_IOEVENTFD_FLAG_PIO       (1 << kvm_ioeventfd_flag_nr_pio)
 #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
 #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
@@ -712,11 +714,12 @@ enum {
 
 struct kvm_ioeventfd {
 	__u64 datamatch;
+	__u64 dataread;
 	__u64 addr;        /* legal pio/mmio address */
 	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
 	__s32 fd;
 	__u32 flags;
-	__u8  pad[36];
+	__u8  pad[28];
 };
 
 #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
-- 
2.28.0

