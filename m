Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F034F799235
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbjIHW36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbjIHW35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5C1FCA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59b50b45481so18350577b3.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212193; x=1694816993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wf8TO8PxR5yOir1Q53pTO4W/7i3l7j9F46MQ/NBc+xE=;
        b=AWtddfLlP054rvxFk4vlEGlSr0TQEOjgr8HD2IBhhizsqeo5B+AvmdmvdEqYq7XaGY
         6T9H30Jo2vpaKBEIs4ypadq6L5x5/a49zrguOy8KZR89kP83r+Yw1RdRQNie9bJpvZVE
         Z+Odeg2x/SKPpGE77lYUdvLWKwfQ2QEGXoPauDaUUdw9mQaueSSqMTwGkhg/8r4wMLXh
         2S4YCStuXRVTh3Gexdhox4/OmTmHRpaBNFw45zMldSwH+gOMDP+LSAQN7usOPgphpY29
         ajMo4vVPmS6OTmuFclneeqcppGZPFFGzUligJq4xkrZbENtvIGhKDXAlJi5qxpoylVBc
         wWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212193; x=1694816993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wf8TO8PxR5yOir1Q53pTO4W/7i3l7j9F46MQ/NBc+xE=;
        b=QVCp1JAizSsN+UpMMr+c2gC2fFoQiHGDalSdkAzSZRsK7UTOXv+jN4j2U3IuJY7vB5
         6Y1bknUPXAzvL7Snk1FKIj3918MO6CYRm2i1OsvCVapsZD88Yr9wWrl4USyaZ8Ph4+Hy
         fyUJlUPkkqnwnFIYK7Np72Td+3ezK28QlBmWJ5/xSp9V8loX3CiQP42Xels9ILVvIm93
         FL/pO2fdJpDtdZ7QiPkR9vTlrm5InH7fHLB97XUesb9OIAqZ9Fyv0oQRR2WcComzvPQ4
         UyeRIv5ol1XI8L2YKJeyncm7ulJrMVikvIhY7DZDUclG2EeRIaRhcCAhC2+R04bxw+3K
         iqTw==
X-Gm-Message-State: AOJu0YxU9RUUvIK9A75I7rBgCmsMDlm74wh7m2Y1npXuKkTKZJT4gScM
        ZSwIo92CRF1AviNXTWqXg0FliRAsbx8dag==
X-Google-Smtp-Source: AGHT+IGgTkMjv+1Zp4Trc1aoaNyokP2piKmk6xlEDnMLwdBUdnUHoIzK29yx1Osrr1Pf4OF8Tp58c7zQv62wxw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:a1ca:0:b0:d78:2c3:e633 with SMTP id
 a68-20020a25a1ca000000b00d7802c3e633mr73175ybi.2.1694212193355; Fri, 08 Sep
 2023 15:29:53 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:52 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-6-amoorthy@google.com>
Subject: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
kvm_vcpu_read/write_guest_page()

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e31435179764..13aa2ed11d0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3043,8 +3043,12 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 			     int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int r = __kvm_read_guest_page(slot, gfn, data, offset, len);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	if (r)
+		kvm_handle_guest_uaccess_fault(vcpu, gfn * PAGE_SIZE + offset,
+					       len, KVM_MEMORY_FAULT_FLAG_READ);
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3149,8 +3153,12 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      const void *data, int offset, int len)
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	int r = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 
-	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
+	if (r)
+		kvm_handle_guest_uaccess_fault(vcpu, gfn * PAGE_SIZE + offset,
+					       len, KVM_MEMORY_FAULT_FLAG_WRITE);
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
 
-- 
2.42.0.283.g2d96d420d3-goog

