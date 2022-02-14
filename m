Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D844B5C46
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiBNVIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:08:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiBNVIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:08:48 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC61120E90
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:08:39 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id q5-20020ac87345000000b002d99631ebe2so13372457qtp.22
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ImRH9XpLCVO1AMuO+0vNf/s5u0DDeswWDZhxgck4GTg=;
        b=ia0I32JcmImFFnzIt0dqwG5SCKqP3qmsRwXloN2N+PGLZBEGdTIaEiefH7BWNWqVDV
         XMS+2Qp8Gn8onGXQeidk1/eyV4BGFi+iJhdN5bKvPJSt2bg+7rhKiGoeYBxP9FhA8CTR
         ZWoyXjaKKmoBd+EBuh92636y9JchIAmpQ3EhRAMYKrxLuOo3E0MC5nisdofLJORwfLTW
         FCDE8f34hR/2mfBaRfsTXU9/JO6WZYM/AUOz11NiIoVBd3A8lbSxa736AgJ+yBIv6y5d
         lcdtYUtgEQeM49nnc+LcevfvZeXK1740krM6xLH5nTDNjp2PbKluWQJP+muJeHu0xTS/
         9cPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ImRH9XpLCVO1AMuO+0vNf/s5u0DDeswWDZhxgck4GTg=;
        b=ZjZ5l908reUg1svAVk4qT3GNV14lIR6+QbiMqbzjDy2nsBMb10fFZ0F/wxvqbNFdks
         kImyPrhcPZc4Zbnwfbq1D88BfiT+uGLv7K0OUdMzAwqPjidPaTfYchJ9U/HLWjJwGHn3
         5Ch9pLx41s5pzb9IKFITbYHBP9m//mTMbg+RlNYXl/XDvMfDWt5f8B12KxP6cLr1me4S
         H1ZhPOYnp/m76UhlJrHt+eOTpjRnGU+wOYzSpaJtyYy/yYU4vwSNZBa5r4liJMsXcJ3I
         DaEBgeJGJO8AGuST00L94iUJ29rWqj8L8dmqOHw2fdBQ+i7bHtSlrHmBTEa50kLYUu1t
         NDuw==
X-Gm-Message-State: AOAM530ZhCAd9LquSaFsCHZJxFnsAqsavsVLv6UqyPd/jVcW/o8yOORO
        WSHfMcDs8p8IbGDJnmwSoHSkpYpxrGrs
X-Google-Smtp-Source: ABdhPJw4BEO7Wb+8vsvCdbSI6yFU0rSYMXuBhd6tOWudkdTVun04vOC8de/M5fPlrqu4GEYS3RMYa2UPop+A
X-Received: from kalutes-cloudtop-1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f1])
 (user=kalutes job=sendgmr) by 2002:a05:6a00:a87:: with SMTP id
 b7mr470587pfl.51.1644868771650; Mon, 14 Feb 2022 11:59:31 -0800 (PST)
Date:   Mon, 14 Feb 2022 19:59:08 +0000
Message-Id: <20220214195908.4070138-1-kalutes@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH] Virtio-balloon: add user space API for sizing
From:   Kameron Lutes <kalutes@google.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        kvm@vger.kernel.org
Cc:     Suleiman Souhlal <suleiman@chromium.org>,
        Charles William Dick <cwd@google.com>,
        Kameron Lutes <kalutes@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new linux API will allow user space applications to directly
control the size of the virtio-balloon. This is useful in
situations where the guest must quickly respond to drastically
increased memory pressure and cannot wait for the host to adjust
the balloon's size.

Under the current wording of the Virtio spec, guest driven
behavior such as this is permitted:

VIRTIO Version 1.1 Section 5.5.6
"The device is driven either by the receipt of a configuration
change notification, or by changing guest memory needs, such as
performing memory compaction or responding to out of memory
conditions."

The intended use case for this API is one where the host
communicates a deflation limit to the guest. The guest may then
choose to respond to memory pressure by deflating its balloon down
to the guest's allowable limit.

Signed-off-by: Kameron Lutes <kalutes@google.com>
---
 drivers/virtio/virtio_balloon.c | 55 +++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index f4c34a2a6b8e..aa06305a3137 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -878,6 +878,54 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 	return register_shrinker(&vb->shrinker);
 }
 
+static ssize_t balloon_size_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct virtio_device *vdev = container_of(dev, struct virtio_device, dev);
+	u32 num_pages;
+
+	/*
+	 * Read the size directly from the balloon's configuration.
+	 * The caller expects the balloon size enforced by the host,
+	 * not the actual balloon size
+	 */
+	virtio_cread(vdev, struct virtio_balloon_config, num_pages,
+		     &num_pages);
+
+	return sprintf(buf, "0x%x", num_pages);
+}
+
+static ssize_t balloon_size_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct virtio_device *vdev = container_of(dev, struct virtio_device, dev);
+	u32 num_pages;
+	int err;
+
+	err = kstrtou32(buf, 0, &num_pages);
+
+	if (err < 0) {
+		dev_err(dev, "Failed to read balloon size from file\n");
+		return err;
+	}
+
+	/*
+	 * Write num_pages back to the balloon's config section
+	 */
+	virtio_cwrite_le(vdev, struct virtio_balloon_config, num_pages,
+		      &num_pages);
+
+	/*
+	 * Signal to the balloon that the configuration has changed.
+	 * This triggers any necessary resizing actions
+	 */
+	virtballoon_changed(vdev);
+
+	return count;
+}
+static DEVICE_ATTR_RW(balloon_size);
+
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
@@ -1015,12 +1063,19 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 	}
 
+	err = device_create_file(&vb->vdev->dev, &dev_attr_balloon_size);
+	if (err)
+		goto out_unregister_page_reporting;
+
 	virtio_device_ready(vdev);
 
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
 
+out_unregister_page_reporting:
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
+		page_reporting_unregister(&vb->pr_dev_info);
 out_unregister_oom:
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
 		unregister_oom_notifier(&vb->oom_nb);
-- 
2.35.1.265.g69c8d7142f-goog

