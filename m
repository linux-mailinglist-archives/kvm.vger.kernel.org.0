Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745ED7B8E54
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 22:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbjJDUuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 16:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbjJDUuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 16:50:02 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD501B8
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 13:49:58 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b9d07a8d84so3242041fa.3
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696452597; x=1697057397; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iE/T50N1RTGEjOsShbKS0aPE1LGFh1pOgBPCSvdPSqo=;
        b=jZ2WeYwLQIzWgd+yPiFhWrv4K04W3mWz7nn+A3k4VNM9xFFimk5vtRwSmPzTMbIK6J
         IFcw+qJWHzjTUL/4Kkro9gxkfty22uynP0QI271ZNQA6q3iwzLoj3hKs4dHxUkJUGRHX
         UVGEcssl4qokTKkodvjXkz4kMbmS3nauDwrHEhrKOyX+JYgTr7UzU6FlYy79fmCc9/xB
         kUp+FI1uQngRS7xjG899OJirU9nGPOOFySDT+jntJ18uyHMv9834jVZsSZepDbw1zCC5
         ZQgy7niYjJnHYOHKcXZGOTIIJAMyUN3dME1qCpdSnP7Q69lf6Ui9fVtk9OYugIMMid9a
         0wzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696452597; x=1697057397;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iE/T50N1RTGEjOsShbKS0aPE1LGFh1pOgBPCSvdPSqo=;
        b=GIEQEw97JlwX3zub0mjEjRXweqlkmSDUIcwe3VS9B+l2DuLFZmX1NNEwWqcjrc5vJw
         zZ8WZA9vjLVc4/l8+7MX2vNnzxToml75tw2XcirCJdhIFdQQ44ZFCnl9MQIgMDAmpk+A
         n57Whr0ZEd/4Pk1qiNHepjj9zcf5OhnASbnuMw0MIT4leQFpEXKJ6UYGQ5xQ1vhMthGi
         8A8Yt3m3Atu8/tCBvAf/gBt/k40xp7+6J0i/IDHzw/Df+HejU88BaVn2RtdEbqvwdQlp
         K6zT5M7rMv1wIyGBC0bCAdmZNeXgJrHCCkLBndX8ZMVKjPvCnQWQ0hSKR6qqJHXGyLJ+
         11/Q==
X-Gm-Message-State: AOJu0Ywz5qwBeUWBGPuXLsPXwkL5WUm1k2YlgJkUSJVApjvv/T9nxXRL
        6jD0SHnUIl36Xv2ttlwyIak2sg8bnoBYLXHEzHU7v7qsTdc85A==
X-Google-Smtp-Source: AGHT+IEknAno0ykvqWfUBuIiGhXxj78RXuKsZbcUpFsZgm6b2jNcC33hJS+72flAet2tTUGfUxDNvyo9heDs9LVQK5E=
X-Received: by 2002:ac2:5f08:0:b0:503:383c:996d with SMTP id
 8-20020ac25f08000000b00503383c996dmr2644039lfq.12.1696452596655; Wed, 04 Oct
 2023 13:49:56 -0700 (PDT)
MIME-Version: 1.0
From:   Eduardo Bart <edub4rt@gmail.com>
Date:   Wed, 4 Oct 2023 17:49:45 -0300
Message-ID: <CABqCASLWAZ5aq27GuQftWsXSf7yLFCKwrJxWMUF-fiV7Bc4LUA@mail.gmail.com>
Subject: [PATCH kvmtool] virtio: Cancel and join threads when exiting devices
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm experiencing a segmentation fault in lkvm where it may crash after
powering off a guest machine that uses a virtio network device.
The crash is hard to reproduce, because looks like it only happens
when the guest machine is powering off while extra virtio threads is
doing some work,
when it happens lkvm crashes in the function virtio_net_rx_thread
while attempting to read invalid guest physical memory,
because guest physical memory was unmapped.

I've isolated the problem and looks like when lkvm exits it unmaps the
guest memory while virtio device extra threads may still be executing.
I noticed most virtio devices are not executing pthread_cancel +
pthread_join to synchronize extra threads when exiting,
to make sure this happens I added explicit calls to the virtio device
exit function to all virtio devices,
which should cancel and join all threads before unmapping guest
physical memory, fixing the crash for me.

Below I'm attaching a patch to fix the issue, feel free to apply or
fix the issue some other way.

Signed-off-by: Eduardo Bart <edub4rt@gmail.com>

---
 include/kvm/virtio-9p.h |  1 +
 virtio/9p.c             | 14 ++++++++++++++
 virtio/balloon.c        | 11 +++++++++++
 virtio/blk.c            |  1 +
 virtio/console.c        |  3 +++
 virtio/net.c            |  4 ++++
 virtio/rng.c            |  8 ++++++++
 7 files changed, 42 insertions(+)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 1dffc95..09f7e46 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -70,6 +70,7 @@ int virtio_9p_rootdir_parser(const struct option
*opt, const char *arg, int unse
 int virtio_9p_img_name_parser(const struct option *opt, const char
*arg, int unset);
 int virtio_9p__register(struct kvm *kvm, const char *root, const char
*tag_name);
 int virtio_9p__init(struct kvm *kvm);
+int virtio_9p__exit(struct kvm *kvm);
 int virtio_p9_pdu_readf(struct p9_pdu *pdu, const char *fmt, ...);
 int virtio_p9_pdu_writef(struct p9_pdu *pdu, const char *fmt, ...);

diff --git a/virtio/9p.c b/virtio/9p.c
index 513164e..f536d9e 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1562,6 +1562,20 @@ int virtio_9p__init(struct kvm *kvm)
 }
 virtio_dev_init(virtio_9p__init);

+int virtio_9p__exit(struct kvm *kvm)
+{
+ struct p9_dev *p9dev, *tmp;
+
+ list_for_each_entry_safe(p9dev, tmp, &devs, list) {
+ list_del(&p9dev->list);
+ p9dev->vdev.ops->exit(kvm, &p9dev->vdev);
+ free(p9dev);
+ }
+
+ return 0;
+}
+virtio_dev_exit(virtio_9p__exit);
+
 int virtio_9p__register(struct kvm *kvm, const char *root, const char
*tag_name)
 {
  struct p9_dev *p9dev;
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 01d1982..a36e50e 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -221,6 +221,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
  return 0;
 }

+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+ struct bln_dev *bdev = dev;
+
+ thread_pool__cancel_job(&bdev->jobs[vq]);
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
  struct bln_dev *bdev = dev;
@@ -258,6 +265,7 @@ struct virtio_ops bln_dev_virtio_ops = {
  .get_config_size = get_config_size,
  .get_host_features = get_host_features,
  .init_vq = init_vq,
+ .exit_vq = exit_vq,
  .notify_vq = notify_vq,
  .get_vq = get_vq,
  .get_size_vq = get_size_vq,
@@ -293,6 +301,9 @@ virtio_dev_init(virtio_bln__init);

 int virtio_bln__exit(struct kvm *kvm)
 {
+ if (bdev.vdev.ops)
+ bdev.vdev.ops->exit(kvm, &bdev.vdev);
+
  return 0;
 }
 virtio_dev_exit(virtio_bln__exit);
diff --git a/virtio/blk.c b/virtio/blk.c
index a58c745..e34723a 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -345,6 +345,7 @@ static int virtio_blk__init_one(struct kvm *kvm,
struct disk_image *disk)
 static int virtio_blk__exit_one(struct kvm *kvm, struct blk_dev *bdev)
 {
  list_del(&bdev->list);
+ bdev->vdev.ops->exit(kvm, &bdev->vdev);
  free(bdev);

  return 0;
diff --git a/virtio/console.c b/virtio/console.c
index ebfbaf0..5a71bbc 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -243,6 +243,9 @@ virtio_dev_init(virtio_console__init);

 int virtio_console__exit(struct kvm *kvm)
 {
+ if (cdev.vdev.ops)
+ cdev.vdev.ops->exit(kvm, &cdev.vdev);
+
  return 0;
 }
 virtio_dev_exit(virtio_console__exit);
diff --git a/virtio/net.c b/virtio/net.c
index f09dd0a..dc6d89d 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -969,10 +969,14 @@ int virtio_net__exit(struct kvm *kvm)
  if (ndev->mode == NET_MODE_TAP &&
      strcmp(params->downscript, "none"))
  virtio_net_exec_script(params->downscript, ndev->tap_name);
+ if (ndev->mode != NET_MODE_TAP)
+ uip_exit(&ndev->info);

  list_del(&ndev->list);
+ ndev->vdev.ops->exit(kvm, &ndev->vdev);
  free(ndev);
  }
+
  return 0;
 }
 virtio_dev_exit(virtio_net__exit);
diff --git a/virtio/rng.c b/virtio/rng.c
index 6b36655..ebdb455 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -122,6 +122,13 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
  return 0;
 }

+static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+ struct rng_dev *rdev = dev;
+
+ thread_pool__cancel_job(&rdev->jobs[vq].job_id);
+}
+
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
 {
  struct rng_dev *rdev = dev;
@@ -159,6 +166,7 @@ static struct virtio_ops rng_dev_virtio_ops = {
  .get_config_size = get_config_size,
  .get_host_features = get_host_features,
  .init_vq = init_vq,
+ .exit_vq = exit_vq,
  .notify_vq = notify_vq,
  .get_vq = get_vq,
  .get_size_vq = get_size_vq,
-- 
2.42.0
