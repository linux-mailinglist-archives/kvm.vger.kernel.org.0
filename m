Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896D63AC860
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 12:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFRKHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 06:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232335AbhFRKGx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 06:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624010671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+6Ax3LentWYghpfcXmHx6GVq/FWipz1+qsS7V10Qvs=;
        b=cLSiErteJdH0iYOhBJdxG3IsJ5EvgAlyk5fiUP1piPqXgQPWfrMx/R5npD+QPwnZsqrww3
        GqifvpEGxClKFM3tVmelYnPXHS8dC9nLt0aBsZNpOtIgMC3qloJzxtKK3uaYKYJCFTVnyw
        lzyLHU0Zfiae0Pd4NfS3fxG06ggyXOc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369--20MvvNTMhuirJdKXTUDyA-1; Fri, 18 Jun 2021 06:04:30 -0400
X-MC-Unique: -20MvvNTMhuirJdKXTUDyA-1
Received: by mail-ed1-f72.google.com with SMTP id u26-20020a05640207dab02903935beb5c71so3282959edy.3
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 03:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C+6Ax3LentWYghpfcXmHx6GVq/FWipz1+qsS7V10Qvs=;
        b=kr5YcrvkzC/ehm+gExeKk+gCtoSsCgxT8+VTQwTfXztYLK0jGIhetGID84V0iN/nxD
         1Ps6oRg6cRfjDLzBHmaASk76VqHBFmZSYZP4vLsi7rh2DIWgt8MF6bm+z2Dtwm/ACkyI
         JTYILm+OrOEhxfLuJzbW0JC5o4xffkysKZmaqtWmisUa3/XGRjpeGfx28KVujKpW/OwF
         h6SHFRzBC+An/ZY0L/YBNtSjaxlCZSFYr1Wvz6x1BNMC0JlDWRKHk1OHEBak97cvuvt2
         Jh08Zqy3ELnlZjLuNAtnBpTmVp6CCmHTSH7HhC+w8UmKH43tWPlC1/yF119HipbnyrMJ
         vXEA==
X-Gm-Message-State: AOAM5338P7Sqyf2kHSAl2bMz7aaEttrgzbB1Q3fEQHCUpGJsXoRsMRAf
        qk0yDIZv89rF+9gd3jOxqvDOw3QMns9tQiA5M+DlaQml96ohNplx7gyiR6yaWAJ+8eiHBbS8leh
        Fzxg1cLVM7JIn
X-Received: by 2002:a05:6402:5cc:: with SMTP id n12mr2338901edx.354.1624010669214;
        Fri, 18 Jun 2021 03:04:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXnhV9u3UPtDPZ5wiT7NcGjAUcA+9ONBjHs3vBezHXdfaY/16q9aXbQXwio5ukcq0ncVkkew==
X-Received: by 2002:a05:6402:5cc:: with SMTP id n12mr2338862edx.354.1624010669049;
        Fri, 18 Jun 2021 03:04:29 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id df20sm5585787edb.76.2021.06.18.03.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 03:04:28 -0700 (PDT)
Date:   Fri, 18 Jun 2021 12:04:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 6/6] virtio/vsock: add sysfs for rx buf len for dgram
Message-ID: <20210618100424.wfljrnycxxguwt3d@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-7-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210609232501.171257-7-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:58PM +0000, Jiang Wang wrote:
>Make rx buf len configurable via sysfs
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>---
> net/vmw_vsock/virtio_transport.c | 37 +++++++++++++++++++++++++++++++++++--
> 1 file changed, 35 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index cf47aadb0c34..2e4dd9c48472 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -29,6 +29,14 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
> static struct virtio_vsock *the_virtio_vsock_dgram;
> static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>
>+static int rx_buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
>+static struct kobject *kobj_ref;
>+static ssize_t  sysfs_show(struct kobject *kobj,
>+			struct kobj_attribute *attr, char *buf);
>+static ssize_t  sysfs_store(struct kobject *kobj,
>+			struct kobj_attribute *attr, const char *buf, size_t count);
>+static struct kobj_attribute rxbuf_attr = __ATTR(rx_buf_value, 0660, sysfs_show, sysfs_store);

Maybe better to use a 'dgram' prefix.

>+
> struct virtio_vsock {
> 	struct virtio_device *vdev;
> 	struct virtqueue **vqs;
>@@ -360,7 +368,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>
> static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
> {
>-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
>+	int buf_len = rx_buf_len;
> 	struct virtio_vsock_pkt *pkt;
> 	struct scatterlist hdr, buf, *sgs[2];
> 	struct virtqueue *vq;
>@@ -1003,6 +1011,22 @@ static struct virtio_driver virtio_vsock_driver = {
> 	.remove = virtio_vsock_remove,
> };
>
>+static ssize_t sysfs_show(struct kobject *kobj,
>+		struct kobj_attribute *attr, char *buf)
>+{
>+	return sprintf(buf, "%d", rx_buf_len);
>+}
>+
>+static ssize_t sysfs_store(struct kobject *kobj,
>+		struct kobj_attribute *attr, const char *buf, size_t count)
>+{
>+	if (kstrtou32(buf, 0, &rx_buf_len) < 0)
>+		return -EINVAL;
>+	if (rx_buf_len < 1024)
>+		rx_buf_len = 1024;
>+	return count;
>+}
>+
> static int __init virtio_vsock_init(void)
> {
> 	int ret;
>@@ -1020,8 +1044,17 @@ static int __init virtio_vsock_init(void)
> 	if (ret)
> 		goto out_vci;
>
>-	return 0;
>+	kobj_ref = kobject_create_and_add("vsock", kernel_kobj);

So, IIUC, the path will be /sys/vsock/rx_buf_value?

I'm not sure if we need to add a `virtio` subdir (e.g.
/sys/vsock/virtio/dgram_rx_buf_size)

Thanks,
Stefano

>
>+	/*Creating sysfs file for etx_value*/
>+	ret = sysfs_create_file(kobj_ref, &rxbuf_attr.attr);
>+	if (ret)
>+		goto out_sysfs;
>+
>+	return 0;
>+out_sysfs:
>+	kobject_put(kobj_ref);
>+	sysfs_remove_file(kernel_kobj, &rxbuf_attr.attr);
> out_vci:
> 	vsock_core_unregister(&virtio_transport.transport);
> out_wq:
>-- 
>2.11.0
>

