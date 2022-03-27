Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C774E8A17
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiC0Uq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 16:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiC0Uq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 16:46:57 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B9CDFA9
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:45:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 17so16706251ljw.8
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 13:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5XKcpDt42pPmVULPnPhri29KpAj221ehx5fke5pkb+A=;
        b=XNZKs0VAy9sVjoxJka9M5FPUmGowV1abwhtjuiDDmDoT6X2vVX3iFvIUkWB5Qzkjbz
         MOqKV2Ic/UOqG14qPf8BTeM/1FpcQ5PaG75Zy9JT70mSzPp74YIrHpeOoUFdg/VOUQQJ
         1pyesjyamikKIKdDVKIHfRbYIfjLTdntzHl2CgYbVIOTbf8h6z+OZvZbgis+/UJYOak6
         ioP6vdbgyvaUE0xOZWOCNtRWxpSe13ufBu7LXftiYwmWijrwcqOIfgA5XKQ9GLjwEAP7
         OlBBBy7g/Pf0/dKPCFf23l1badseDzz7Q7OxjiFsiI59BRvMD2thO2BWdJbEPPyy71LS
         zj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5XKcpDt42pPmVULPnPhri29KpAj221ehx5fke5pkb+A=;
        b=beBtT4Npcj6XD0yItQipoe0+cqJK29WJ4e77JCRtU/R8NUnYOOkWxUD0CCzHxTmvoj
         oQ833hCYC+2y4J4ks0IYUPqEmvgMCW0oRC5WxCAv5U8haGtd32Pwyw7sPdeH0PYP6IHC
         wmon3TjjYKVKP7BuELei+0fGzOv+1YnkawcEssUme99WsXX9E/wCM58SdbvZI2VwSCFt
         N4Ky9Ul2eVznphzjcNh1XTOzcCGwefPDvY04zVW2FDQYHYMMhT0pA8BcmQrD/nfJ1+9B
         x8ODVQHx20mD74cHORK8N+xOeH6RmIjsVVbkWP/RVvelRTNaFHhX6shPqXgLT223NM1w
         yurQ==
X-Gm-Message-State: AOAM532TyqJVTLkkQk6U6GaQU9/Varo7Cbs3ahj9lsqforvxj5l60T0B
        siPugxPOCezBLCAr8ZtCHDQ=
X-Google-Smtp-Source: ABdhPJyJaIRU6XN7zrYCp+CorxxVgA3GLebEoPbX7hKk1LE0jktdNaainofMypjnOvnuypKrFgi+Bw==
X-Received: by 2002:a2e:834f:0:b0:249:357c:bf28 with SMTP id l15-20020a2e834f000000b00249357cbf28mr17237433ljh.102.1648413915701;
        Sun, 27 Mar 2022 13:45:15 -0700 (PDT)
Received: from sisu-ThinkPad-E14-Gen-2 (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id z21-20020a195055000000b0044a2d880194sm1445440lfj.223.2022.03.27.13.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 13:45:15 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:45:13 +0300
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 3/5] virtio: Check for overflows in QUEUE_NOTIFY
 and QUEUE_SEL
Message-ID: <YkDM2UsS8rRhf3jd@sisu-ThinkPad-E14-Gen-2>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-4-martin.b.radev@gmail.com>
 <YjIEa+t4zJYMJmvB@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjIEa+t4zJYMJmvB@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thanks for the review.
Comments are inline.
Here is the patch:


From dc2b54f3368bd012eaa2f55bb8b98278f6278df1 Mon Sep 17 00:00:00 2001
From: Martin Radev <martin.b.radev@gmail.com>
Date: Sun, 16 Jan 2022 18:50:44 +0200
Subject: [PATCH kvmtool 5/6] virtio: Check for overflows in QUEUE_NOTIFY and
 QUEUE_SEL

This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
the PCI and MMIO operation handling paths. Further, the return
value type of get_vq_count is changed from int to uint since negative
doesn't carry any semantic meaning.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio.h |  2 +-
 virtio/9p.c          |  2 +-
 virtio/balloon.c     |  2 +-
 virtio/blk.c         |  2 +-
 virtio/console.c     |  2 +-
 virtio/mmio.c        | 16 +++++++++++++++-
 virtio/net.c         |  2 +-
 virtio/pci.c         | 17 +++++++++++++++--
 virtio/rng.c         |  2 +-
 virtio/scsi.c        |  2 +-
 virtio/vsock.c       |  2 +-
 11 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3880e74..ad274ac 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -187,7 +187,7 @@ struct virtio_ops {
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
-	int (*get_vq_count)(struct kvm *kvm, void *dev);
+	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index 57cd6d0..7c9d792 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1469,7 +1469,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 5bcd6ab..450b36a 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -251,7 +251,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index af71c0c..46ee028 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -291,7 +291,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/console.c b/virtio/console.c
index dae6034..8315808 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -216,7 +216,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VIRTIO_CONSOLE_NUM_QUEUES;
 }
diff --git a/virtio/mmio.c b/virtio/mmio.c
index c14f08a..4c16359 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -175,13 +175,22 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct kvm *kvm = vmmio->kvm;
+	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
 	u32 val = 0;
 
 	switch (addr) {
 	case VIRTIO_MMIO_HOST_FEATURES_SEL:
 	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
+		val = ioport__read32(data);
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
 	case VIRTIO_MMIO_QUEUE_SEL:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
 		break;
 	case VIRTIO_MMIO_STATUS:
@@ -227,6 +236,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
 		break;
 	case VIRTIO_MMIO_INTERRUPT_ACK:
@@ -346,7 +360,7 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
 	struct virtio_mmio *vmmio = vdev->virtio;
 
 	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
diff --git a/virtio/net.c b/virtio/net.c
index ec5dc1f..67070d6 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -755,7 +755,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	struct net_dev *ndev = dev;
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 13f2b76..eb7af32 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -320,9 +320,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
+	unsigned int vq_count;
 
 	kvm = vcpu->kvm;
 	vpci = vdev->virtio;
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
 
 	switch (offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
@@ -342,10 +344,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
-		vpci->queue_selector = ioport__read16(data);
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vpci->queue_selector = val;
 		break;
 	case VIRTIO_PCI_QUEUE_NOTIFY:
 		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
 		vdev->ops->notify_vq(kvm, vpci->dev, val);
 		break;
 	case VIRTIO_PCI_STATUS:
@@ -638,7 +651,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
 	struct virtio_pci *vpci = vdev->virtio;
 
 	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
diff --git a/virtio/rng.c b/virtio/rng.c
index c7835a0..75b682e 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 8f1c348..60432cc 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -176,7 +176,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 34397b6..64b4e95 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -204,7 +204,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 		die_perror("VHOST_SET_VRING_CALL failed");
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VSOCK_VQ_MAX;
 }
-- 
2.25.1


On Wed, Mar 16, 2022 at 03:38:19PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Mar 04, 2022 at 01:10:48AM +0200, Martin Radev wrote:
> > This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
> > the PCI and MMIO operation handling paths. Further, the return
> > value type of get_vq_count is changed from int to uint since negative
> > doesn't carry any semantic meaning.
> > 
> > Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
> > ---
> >  include/kvm/virtio.h |  2 +-
> >  virtio/9p.c          |  2 +-
> >  virtio/balloon.c     |  2 +-
> >  virtio/blk.c         |  2 +-
> >  virtio/console.c     |  2 +-
> >  virtio/mmio.c        | 20 ++++++++++++++++++--
> >  virtio/net.c         |  4 ++--
> >  virtio/pci.c         | 21 ++++++++++++++++++---
> >  virtio/rng.c         |  2 +-
> >  virtio/scsi.c        |  2 +-
> >  virtio/vsock.c       |  2 +-
> >  11 files changed, 46 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
> > index 3880e74..ad274ac 100644
> > --- a/include/kvm/virtio.h
> > +++ b/include/kvm/virtio.h
> > @@ -187,7 +187,7 @@ struct virtio_ops {
> >  	size_t (*get_config_size)(struct kvm *kvm, void *dev);
> >  	u32 (*get_host_features)(struct kvm *kvm, void *dev);
> >  	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
> > -	int (*get_vq_count)(struct kvm *kvm, void *dev);
> > +	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
> >  	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
> >  		       u32 align, u32 pfn);
> >  	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
> > diff --git a/virtio/9p.c b/virtio/9p.c
> > index 6074f3a..7374f1e 100644
> > --- a/virtio/9p.c
> > +++ b/virtio/9p.c
> > @@ -1469,7 +1469,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return NUM_VIRT_QUEUES;
> >  }
> > diff --git a/virtio/balloon.c b/virtio/balloon.c
> > index 5bcd6ab..450b36a 100644
> > --- a/virtio/balloon.c
> > +++ b/virtio/balloon.c
> > @@ -251,7 +251,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return NUM_VIRT_QUEUES;
> >  }
> > diff --git a/virtio/blk.c b/virtio/blk.c
> > index af71c0c..46ee028 100644
> > --- a/virtio/blk.c
> > +++ b/virtio/blk.c
> > @@ -291,7 +291,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return NUM_VIRT_QUEUES;
> >  }
> > diff --git a/virtio/console.c b/virtio/console.c
> > index dae6034..8315808 100644
> > --- a/virtio/console.c
> > +++ b/virtio/console.c
> > @@ -216,7 +216,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return VIRTIO_CONSOLE_NUM_QUEUES;
> >  }
> > diff --git a/virtio/mmio.c b/virtio/mmio.c
> > index 0094856..d3555b4 100644
> > --- a/virtio/mmio.c
> > +++ b/virtio/mmio.c
> > @@ -175,13 +175,22 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
> >  {
> >  	struct virtio_mmio *vmmio = vdev->virtio;
> >  	struct kvm *kvm = vmmio->kvm;
> > +	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
> >  	u32 val = 0;
> >  
> >  	switch (addr) {
> >  	case VIRTIO_MMIO_HOST_FEATURES_SEL:
> >  	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
> > +		val = ioport__read32(data);
> > +		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
> > +		break;
> >  	case VIRTIO_MMIO_QUEUE_SEL:
> >  		val = ioport__read32(data);
> > +		if (val >= vq_count) {
> > +			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> > +				val, vq_count);
> > +			break;
> > +		}
> >  		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
> >  		break;
> >  	case VIRTIO_MMIO_STATUS:
> > @@ -227,6 +236,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
> >  		break;
> >  	case VIRTIO_MMIO_QUEUE_NOTIFY:
> >  		val = ioport__read32(data);
> > +		if (val >= vq_count) {
> > +			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
> > +				val, vq_count);
> > +			break;
> > +		}
> >  		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
> >  		break;
> >  	case VIRTIO_MMIO_INTERRUPT_ACK:
> > @@ -346,10 +360,12 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> >  
> >  int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
> >  {
> > -	int vq;
> > +	unsigned int vq;
> >  	struct virtio_mmio *vmmio = vdev->virtio;
> > +	unsigned int vq_count;
> >  
> > -	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
> > +	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
> > +	for (vq = 0; vq < vq_count; vq++)
> 
> Nitpick: this change is unnecessary and pollutes the git history for this
> file. Same for virtio_pci_reset() below.
> 

I thought it would be nicer to not call this function on every loop iterations.
Still, I removed it as you suggested.

> >  		virtio_mmio_exit_vq(kvm, vdev, vq);
> >  
> >  	return 0;
> > diff --git a/virtio/net.c b/virtio/net.c
> > index ec5dc1f..8dd523f 100644
> > --- a/virtio/net.c
> > +++ b/virtio/net.c
> > @@ -755,11 +755,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	struct net_dev *ndev = dev;
> >  
> > -	return ndev->queue_pairs * 2 + 1;
> > +	return ndev->queue_pairs * 2U + 1U;
> 
> I don't think the cast is needed, as far as I know signed integers are
> converted to unsigned integers as far back as C89 (and probably even
> before that).

Done.

> 
> Other than the nitpicks above, the patch looks good.
> 
> Thanks,
> Alex
> 
> >  }
> >  
> >  static struct virtio_ops net_dev_virtio_ops = {
> > diff --git a/virtio/pci.c b/virtio/pci.c
> > index 0b5cccd..9a6cbf3 100644
> > --- a/virtio/pci.c
> > +++ b/virtio/pci.c
> > @@ -329,9 +329,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
> >  	struct virtio_pci *vpci;
> >  	struct kvm *kvm;
> >  	u32 val;
> > +	unsigned int vq_count;
> >  
> >  	kvm = vcpu->kvm;
> >  	vpci = vdev->virtio;
> > +	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
> >  
> >  	switch (offset) {
> >  	case VIRTIO_PCI_GUEST_FEATURES:
> > @@ -351,10 +353,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
> >  		}
> >  		break;
> >  	case VIRTIO_PCI_QUEUE_SEL:
> > -		vpci->queue_selector = ioport__read16(data);
> > +		val = ioport__read16(data);
> > +		if (val >= vq_count) {
> > +			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> > +				val, vq_count);
> > +			return false;
> > +		}
> > +		vpci->queue_selector = val;
> >  		break;
> >  	case VIRTIO_PCI_QUEUE_NOTIFY:
> >  		val = ioport__read16(data);
> > +		if (val >= vq_count) {
> > +			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
> > +				val, vq_count);
> > +			return false;
> > +		}
> >  		vdev->ops->notify_vq(kvm, vpci->dev, val);
> >  		break;
> >  	case VIRTIO_PCI_STATUS:
> > @@ -647,10 +660,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
> >  
> >  int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
> >  {
> > -	int vq;
> > +	unsigned int vq;
> > +	unsigned int vq_count;
> >  	struct virtio_pci *vpci = vdev->virtio;
> >  
> > -	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
> > +	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
> > +	for (vq = 0; vq < vq_count; vq++)
> >  		virtio_pci_exit_vq(kvm, vdev, vq);
> >  
> >  	return 0;
> > diff --git a/virtio/rng.c b/virtio/rng.c
> > index c7835a0..75b682e 100644
> > --- a/virtio/rng.c
> > +++ b/virtio/rng.c
> > @@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return NUM_VIRT_QUEUES;
> >  }
> > diff --git a/virtio/scsi.c b/virtio/scsi.c
> > index 8f1c348..60432cc 100644
> > --- a/virtio/scsi.c
> > +++ b/virtio/scsi.c
> > @@ -176,7 +176,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
> >  	return size;
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return NUM_VIRT_QUEUES;
> >  }
> > diff --git a/virtio/vsock.c b/virtio/vsock.c
> > index 34397b6..64b4e95 100644
> > --- a/virtio/vsock.c
> > +++ b/virtio/vsock.c
> > @@ -204,7 +204,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
> >  		die_perror("VHOST_SET_VRING_CALL failed");
> >  }
> >  
> > -static int get_vq_count(struct kvm *kvm, void *dev)
> > +static unsigned int get_vq_count(struct kvm *kvm, void *dev)
> >  {
> >  	return VSOCK_VQ_MAX;
> >  }
> > -- 
> > 2.25.1
> > 
