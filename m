Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3577B7CC5C8
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344092AbjJQOTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344066AbjJQOTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67613F0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697552290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6xQN1+lV9TdZ1Amapx2vOyAsjr34oDkO3HUZzOghYks=;
        b=MAeT+poSvr4ZAv/dLPhVnThNi71aiKUHjY9Je5dcWSAF0Er4lCAhbKYpHqMJwuNKSY0Dpf
        vrujendXtE0KLEr9szpNH0HNdtvq+L06rpytLLLBf6qvfW+8TtLn3NQ6lVHNzL+UJfkuDG
        Zn11ry7HKVgrQRZ20j6E3YVtAg7XOhk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-N2wd79ZYPye5A51DZyNgYA-1; Tue, 17 Oct 2023 10:17:53 -0400
X-MC-Unique: N2wd79ZYPye5A51DZyNgYA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-41bef8f8d94so7484151cf.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:17:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697552271; x=1698157071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6xQN1+lV9TdZ1Amapx2vOyAsjr34oDkO3HUZzOghYks=;
        b=J4pQVRtQAwOXQgvOq8TludZydK5bIrz4BSPq7vMlJSXSzZuzx2EBZCrSm36oIaqTxF
         MaaiTw6d4Ah94tH8UThFO8ojcf5AOOSQwnJOBKmUHqLNGedF9JPo3qzLJPPETVq6e3Y4
         1dHCl18ck/rcgiDOv9dfVxZgrFsmVIh6hJQn6ajZvFJ9EheZCJ8rUmfT2TLmVjI0N6nT
         walZO4oR2W45gJ0LwjA+c98qDH+RdFDEatdwl0te0X88n1U3iNd91wr3HdLHZq9NFbkR
         +xe2eiWnaQo/dLJjzond7Qwdo4UsqL/L8qDoUMe7vVAZtMSA/JKbHbWu2X0f4aXg05Lp
         DI9g==
X-Gm-Message-State: AOJu0YywqiIWfVX82fadbEeGqKqr/3vSTbLfjKQ07Vl2HtQQYZpX7BZc
        jl4CiL9SAYtIQxrdcuzsSQQpRbWfJ5TUAAoEdfw2szL1ok4LhKTSw5CFFC4vvv/Q4JwrH0+merX
        SXk94748mHJ8T
X-Received: by 2002:a05:622a:349:b0:403:2877:bc52 with SMTP id r9-20020a05622a034900b004032877bc52mr2797203qtw.0.1697552271262;
        Tue, 17 Oct 2023 07:17:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbzYivDeqer1+nKI2pGLQy64eIAoUWF2WsPu/EXdWDPV/oh9ie0fPVzzdY9jkZ0lMR9Gk8fQ==
X-Received: by 2002:a05:622a:349:b0:403:2877:bc52 with SMTP id r9-20020a05622a034900b004032877bc52mr2797174qtw.0.1697552270884;
        Tue, 17 Oct 2023 07:17:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id w15-20020ac86b0f000000b0041817637873sm655111qts.9.2023.10.17.07.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 07:17:50 -0700 (PDT)
Message-ID: <f0e493a7-f7bf-4da5-be4f-b41f2a5821dc@redhat.com>
Date:   Tue, 17 Oct 2023 16:17:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] vfio/mtty: Overhaul mtty interrupt handling
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231016224736.2575718-1-alex.williamson@redhat.com>
 <20231016224736.2575718-2-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20231016224736.2575718-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/23 00:47, Alex Williamson wrote:
> The mtty driver does not currently conform to the vfio SET_IRQS uAPI.
> For example, it claims to support mask and unmask of INTx, but actually
> does nothing.  It claims to support AUTOMASK for INTx, but doesn't.  It
> fails to teardown eventfds under the full semantics specified by the
> SET_IRQS ioctl.  It also fails to teardown eventfds when the device is
> closed, leading to memory leaks.  It claims to support the request IRQ,
> but doesn't.
> 
> Fix all these.
> 
> A side effect of this is that QEMU will now report a warning:
> 
> vfio <uuid>: Failed to set up UNMASK eventfd signaling for interrupt \
> INTX-0: VFIO_DEVICE_SET_IRQS failure: Inappropriate ioctl for device
> 
> The fact is that the unmask eventfd was never supported but quietly
> failed.  mtty never honored the AUTOMASK behavior, therefore there
> was nothing to unmask.  QEMU is verbose about the failure, but
> properly falls back to userspace unmasking.

We can add a -ENOTTY test in QEMU for the failures.

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.
  
> Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   samples/vfio-mdev/mtty.c | 239 +++++++++++++++++++++++++++------------
>   1 file changed, 166 insertions(+), 73 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 5af00387c519..245db52bedf2 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -127,7 +127,6 @@ struct serial_port {
>   /* State of each mdev device */
>   struct mdev_state {
>   	struct vfio_device vdev;
> -	int irq_fd;
>   	struct eventfd_ctx *intx_evtfd;
>   	struct eventfd_ctx *msi_evtfd;
>   	int irq_index;
> @@ -141,6 +140,7 @@ struct mdev_state {
>   	struct mutex rxtx_lock;
>   	struct vfio_device_info dev_info;
>   	int nr_ports;
> +	u8 intx_mask:1;
>   };
>   
>   static struct mtty_type {
> @@ -166,10 +166,6 @@ static const struct file_operations vd_fops = {
>   
>   static const struct vfio_device_ops mtty_dev_ops;
>   
> -/* function prototypes */
> -
> -static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
> -
>   /* Helper functions */
>   
>   static void dump_buffer(u8 *buf, uint32_t count)
> @@ -186,6 +182,36 @@ static void dump_buffer(u8 *buf, uint32_t count)
>   #endif
>   }
>   
> +static bool is_intx(struct mdev_state *mdev_state)
> +{
> +	return mdev_state->irq_index == VFIO_PCI_INTX_IRQ_INDEX;
> +}
> +
> +static bool is_msi(struct mdev_state *mdev_state)
> +{
> +	return mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX;
> +}
> +
> +static bool is_noirq(struct mdev_state *mdev_state)
> +{
> +	return !is_intx(mdev_state) && !is_msi(mdev_state);
> +}
> +
> +static void mtty_trigger_interrupt(struct mdev_state *mdev_state)
> +{
> +	lockdep_assert_held(&mdev_state->ops_lock);
> +
> +	if (is_msi(mdev_state)) {
> +		if (mdev_state->msi_evtfd)
> +			eventfd_signal(mdev_state->msi_evtfd, 1);
> +	} else if (is_intx(mdev_state)) {
> +		if (mdev_state->intx_evtfd && !mdev_state->intx_mask) {
> +			eventfd_signal(mdev_state->intx_evtfd, 1);
> +			mdev_state->intx_mask = true;
> +		}
> +	}
> +}
> +
>   static void mtty_create_config_space(struct mdev_state *mdev_state)
>   {
>   	/* PCI dev ID */
> @@ -921,6 +947,25 @@ static ssize_t mtty_write(struct vfio_device *vdev, const char __user *buf,
>   	return -EFAULT;
>   }
>   
> +static void mtty_disable_intx(struct mdev_state *mdev_state)
> +{
> +	if (mdev_state->intx_evtfd) {
> +		eventfd_ctx_put(mdev_state->intx_evtfd);
> +		mdev_state->intx_evtfd = NULL;
> +		mdev_state->intx_mask = false;
> +		mdev_state->irq_index = -1;
> +	}
> +}
> +
> +static void mtty_disable_msi(struct mdev_state *mdev_state)
> +{
> +	if (mdev_state->msi_evtfd) {
> +		eventfd_ctx_put(mdev_state->msi_evtfd);
> +		mdev_state->msi_evtfd = NULL;
> +		mdev_state->irq_index = -1;
> +	}
> +}
> +
>   static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   			 unsigned int index, unsigned int start,
>   			 unsigned int count, void *data)
> @@ -932,59 +977,113 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   	case VFIO_PCI_INTX_IRQ_INDEX:
>   		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>   		case VFIO_IRQ_SET_ACTION_MASK:
> +			if (!is_intx(mdev_state) || start != 0 || count != 1) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +
> +			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +				mdev_state->intx_mask = true;
> +			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +				uint8_t mask = *(uint8_t *)data;
> +
> +				if (mask)
> +					mdev_state->intx_mask = true;
> +			} else if (flags &  VFIO_IRQ_SET_DATA_EVENTFD) {
> +				ret = -ENOTTY; /* No support for mask fd */
> +			}
> +			break;
>   		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			if (!is_intx(mdev_state) || start != 0 || count != 1) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +
> +			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +				mdev_state->intx_mask = false;
> +			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +				uint8_t mask = *(uint8_t *)data;
> +
> +				if (mask)
> +					mdev_state->intx_mask = false;
> +			} else if (flags &  VFIO_IRQ_SET_DATA_EVENTFD) {
> +				ret = -ENOTTY; /* No support for unmask fd */
> +			}
>   			break;
>   		case VFIO_IRQ_SET_ACTION_TRIGGER:
> -		{
> -			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -				pr_info("%s: disable INTx\n", __func__);
> -				if (mdev_state->intx_evtfd)
> -					eventfd_ctx_put(mdev_state->intx_evtfd);
> +			if (is_intx(mdev_state) && !count &&
> +			    (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +				mtty_disable_intx(mdev_state);
> +				break;
> +			}
> +
> +			if (!(is_intx(mdev_state) || is_noirq(mdev_state)) ||
> +			    start != 0 || count != 1) {
> +				ret = -EINVAL;
>   				break;
>   			}
>   
>   			if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>   				int fd = *(int *)data;
> +				struct eventfd_ctx *evt;
> +
> +				mtty_disable_intx(mdev_state);
> +
> +				if (fd < 0)
> +					break;
>   
> -				if (fd > 0) {
> -					struct eventfd_ctx *evt;
> -
> -					evt = eventfd_ctx_fdget(fd);
> -					if (IS_ERR(evt)) {
> -						ret = PTR_ERR(evt);
> -						break;
> -					}
> -					mdev_state->intx_evtfd = evt;
> -					mdev_state->irq_fd = fd;
> -					mdev_state->irq_index = index;
> +				evt = eventfd_ctx_fdget(fd);
> +				if (IS_ERR(evt)) {
> +					ret = PTR_ERR(evt);
>   					break;
>   				}
> +				mdev_state->intx_evtfd = evt;
> +				mdev_state->irq_index = index;
> +				break;
> +			}
> +
> +			if (!is_intx(mdev_state)) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +
> +			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +				mtty_trigger_interrupt(mdev_state);
> +			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +				uint8_t trigger = *(uint8_t *)data;
> +
> +				if (trigger)
> +					mtty_trigger_interrupt(mdev_state);
>   			}
>   			break;
>   		}
> -		}
>   		break;
>   	case VFIO_PCI_MSI_IRQ_INDEX:
>   		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>   		case VFIO_IRQ_SET_ACTION_MASK:
>   		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			ret = -ENOTTY;
>   			break;
>   		case VFIO_IRQ_SET_ACTION_TRIGGER:
> -			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -				if (mdev_state->msi_evtfd)
> -					eventfd_ctx_put(mdev_state->msi_evtfd);
> -				pr_info("%s: disable MSI\n", __func__);
> -				mdev_state->irq_index = VFIO_PCI_INTX_IRQ_INDEX;
> +			if (is_msi(mdev_state) && !count &&
> +			    (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +				mtty_disable_msi(mdev_state);
>   				break;
>   			}
> +
> +			if (!(is_msi(mdev_state) || is_noirq(mdev_state)) ||
> +			    start != 0 || count != 1) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +
>   			if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>   				int fd = *(int *)data;
>   				struct eventfd_ctx *evt;
>   
> -				if (fd <= 0)
> -					break;
> +				mtty_disable_msi(mdev_state);
>   
> -				if (mdev_state->msi_evtfd)
> +				if (fd < 0)
>   					break;
>   
>   				evt = eventfd_ctx_fdget(fd);
> @@ -993,20 +1092,37 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   					break;
>   				}
>   				mdev_state->msi_evtfd = evt;
> -				mdev_state->irq_fd = fd;
>   				mdev_state->irq_index = index;
> +				break;
> +			}
> +
> +			if (!is_msi(mdev_state)) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +
> +			if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +				mtty_trigger_interrupt(mdev_state);
> +			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +				uint8_t trigger = *(uint8_t *)data;
> +
> +				if (trigger)
> +					mtty_trigger_interrupt(mdev_state);
>   			}
>   			break;
> -	}
> -	break;
> +		}
> +		break;
>   	case VFIO_PCI_MSIX_IRQ_INDEX:
> -		pr_info("%s: MSIX_IRQ\n", __func__);
> +		dev_dbg(mdev_state->vdev.dev, "%s: MSIX_IRQ\n", __func__);
> +		ret = -ENOTTY;
>   		break;
>   	case VFIO_PCI_ERR_IRQ_INDEX:
> -		pr_info("%s: ERR_IRQ\n", __func__);
> +		dev_dbg(mdev_state->vdev.dev, "%s: ERR_IRQ\n", __func__);
> +		ret = -ENOTTY;
>   		break;
>   	case VFIO_PCI_REQ_IRQ_INDEX:
> -		pr_info("%s: REQ_IRQ\n", __func__);
> +		dev_dbg(mdev_state->vdev.dev, "%s: REQ_IRQ\n", __func__);
> +		ret = -ENOTTY;
>   		break;
>   	}
>   
> @@ -1014,33 +1130,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
>   	return ret;
>   }
>   
> -static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
> -{
> -	int ret = -1;
> -
> -	if ((mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX) &&
> -	    (!mdev_state->msi_evtfd))
> -		return -EINVAL;
> -	else if ((mdev_state->irq_index == VFIO_PCI_INTX_IRQ_INDEX) &&
> -		 (!mdev_state->intx_evtfd)) {
> -		pr_info("%s: Intr eventfd not found\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX)
> -		ret = eventfd_signal(mdev_state->msi_evtfd, 1);
> -	else
> -		ret = eventfd_signal(mdev_state->intx_evtfd, 1);
> -
> -#if defined(DEBUG_INTR)
> -	pr_info("Intx triggered\n");
> -#endif
> -	if (ret != 1)
> -		pr_err("%s: eventfd signal failed (%d)\n", __func__, ret);
> -
> -	return ret;
> -}
> -
>   static int mtty_get_region_info(struct mdev_state *mdev_state,
>   			 struct vfio_region_info *region_info,
>   			 u16 *cap_type_id, void **cap_type)
> @@ -1084,22 +1173,16 @@ static int mtty_get_region_info(struct mdev_state *mdev_state,
>   
>   static int mtty_get_irq_info(struct vfio_irq_info *irq_info)
>   {
> -	switch (irq_info->index) {
> -	case VFIO_PCI_INTX_IRQ_INDEX:
> -	case VFIO_PCI_MSI_IRQ_INDEX:
> -	case VFIO_PCI_REQ_IRQ_INDEX:
> -		break;
> -
> -	default:
> +	if (irq_info->index != VFIO_PCI_INTX_IRQ_INDEX &&
> +	    irq_info->index != VFIO_PCI_MSI_IRQ_INDEX)
>   		return -EINVAL;
> -	}
>   
>   	irq_info->flags = VFIO_IRQ_INFO_EVENTFD;
>   	irq_info->count = 1;
>   
>   	if (irq_info->index == VFIO_PCI_INTX_IRQ_INDEX)
> -		irq_info->flags |= (VFIO_IRQ_INFO_MASKABLE |
> -				VFIO_IRQ_INFO_AUTOMASKED);
> +		irq_info->flags |= VFIO_IRQ_INFO_MASKABLE |
> +				   VFIO_IRQ_INFO_AUTOMASKED;
>   	else
>   		irq_info->flags |= VFIO_IRQ_INFO_NORESIZE;
>   
> @@ -1262,6 +1345,15 @@ static unsigned int mtty_get_available(struct mdev_type *mtype)
>   	return atomic_read(&mdev_avail_ports) / type->nr_ports;
>   }
>   
> +static void mtty_close(struct vfio_device *vdev)
> +{
> +	struct mdev_state *mdev_state =
> +				container_of(vdev, struct mdev_state, vdev);
> +
> +	mtty_disable_intx(mdev_state);
> +	mtty_disable_msi(mdev_state);
> +}
> +
>   static const struct vfio_device_ops mtty_dev_ops = {
>   	.name = "vfio-mtty",
>   	.init = mtty_init_dev,
> @@ -1273,6 +1365,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
>   	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
>   	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
>   	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
> +	.close_device	= mtty_close,
>   };
>   
>   static struct mdev_driver mtty_driver = {

