Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F65F17BEE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfEHOqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:46:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727367AbfEHOqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 10:46:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48Ebgr4020110
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 10:46:20 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sc0kfj511-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:46:19 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 15:46:17 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 15:46:14 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48EkDeY61341860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 14:46:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00ACC42041;
        Wed,  8 May 2019 14:46:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D32042047;
        Wed,  8 May 2019 14:46:12 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 14:46:12 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 09/10] virtio/s390: use DMA memory for ccw I/O and classic
 notifiers
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-10-pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 16:46:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426183245.37939-10-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050814-0020-0000-0000-0000033A9497
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050814-0021-0000-0000-0000218D3642
Message-Id: <a873909a-9846-d6d3-f03e-e86d53fd9c75@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/2019 20:32, Halil Pasic wrote:
> Before virtio-ccw could get away with not using DMA API for the pieces of
> memory it does ccw I/O with. With protected virtualization this has to
> change, since the hypervisor needs to read and sometimes also write these
> pieces of memory.
> 
> The hypervisor is supposed to poke the classic notifiers, if these are
> used, out of band with regards to ccw I/O. So these need to be allocated
> as DMA memory (which is shared memory for protected virtualization
> guests).
> 
> Let us factor out everything from struct virtio_ccw_device that needs to
> be DMA memory in a satellite that is allocated as such.
> 
> Note: The control blocks of I/O instructions do not need to be shared.
> These are marshalled by the ultravisor.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 177 +++++++++++++++++++++------------------
>   1 file changed, 96 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 1f3e7d56924f..613b18001a0c 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -46,9 +46,15 @@ struct vq_config_block {
>   #define VIRTIO_CCW_CONFIG_SIZE 0x100
>   /* same as PCI config space size, should be enough for all drivers */
>   
> +struct vcdev_dma_area {
> +	unsigned long indicators;
> +	unsigned long indicators2;
> +	struct vq_config_block config_block;
> +	__u8 status;
> +};
> +
>   struct virtio_ccw_device {
>   	struct virtio_device vdev;
> -	__u8 *status;
>   	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
>   	struct ccw_device *cdev;
>   	__u32 curr_io;
> @@ -58,24 +64,22 @@ struct virtio_ccw_device {
>   	spinlock_t lock;
>   	struct mutex io_lock; /* Serializes I/O requests */
>   	struct list_head virtqueues;
> -	unsigned long indicators;
> -	unsigned long indicators2;
> -	struct vq_config_block *config_block;
>   	bool is_thinint;
>   	bool going_away;
>   	bool device_lost;
>   	unsigned int config_ready;
>   	void *airq_info;
> +	struct vcdev_dma_area *dma_area;
>   };
>   
>   static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
>   {
> -	return &vcdev->indicators;
> +	return &vcdev->dma_area->indicators;
>   }
>   
>   static inline unsigned long *indicators2(struct virtio_ccw_device *vcdev)
>   {
> -	return &vcdev->indicators2;
> +	return &vcdev->dma_area->indicators2;
>   }
>   
>   struct vq_info_block_legacy {
> @@ -176,6 +180,22 @@ static struct virtio_ccw_device *to_vc_device(struct virtio_device *vdev)
>   	return container_of(vdev, struct virtio_ccw_device, vdev);
>   }
>   
> +static inline void *__vc_dma_alloc(struct virtio_device *vdev, size_t size)
> +{
> +	return ccw_device_dma_zalloc(to_vc_device(vdev)->cdev, size);
> +}
> +
> +static inline void __vc_dma_free(struct virtio_device *vdev, size_t size,
> +				 void *cpu_addr)
> +{
> +	return ccw_device_dma_free(to_vc_device(vdev)->cdev, cpu_addr, size);
> +}
> +
> +#define vc_dma_alloc_struct(vdev, ptr) \
> +	({ptr = __vc_dma_alloc(vdev, sizeof(*(ptr))); })
> +#define vc_dma_free_struct(vdev, ptr) \
> +	__vc_dma_free(vdev, sizeof(*(ptr)), (ptr))
> +
>   static void drop_airq_indicator(struct virtqueue *vq, struct airq_info *info)
>   {
>   	unsigned long i, flags;
> @@ -335,8 +355,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   	struct airq_info *airq_info = vcdev->airq_info;
>   
>   	if (vcdev->is_thinint) {
> -		thinint_area = kzalloc(sizeof(*thinint_area),
> -				       GFP_DMA | GFP_KERNEL);
> +		vc_dma_alloc_struct(&vcdev->vdev, thinint_area);
>   		if (!thinint_area)
>   			return;
>   		thinint_area->summary_indicator =
> @@ -347,8 +366,8 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   		ccw->cda = (__u32)(unsigned long) thinint_area;
>   	} else {
>   		/* payload is the address of the indicators */
> -		indicatorp = kmalloc(sizeof(indicators(vcdev)),
> -				     GFP_DMA | GFP_KERNEL);
> +		indicatorp = __vc_dma_alloc(&vcdev->vdev,
> +					   sizeof(indicators(vcdev)));

should be sizeof(long) ?

This is a recurrent error, but it is not an issue because the size of
the indicators is unsigned long as the size of the pointer.

Regards,
Pierre

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

