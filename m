Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156C1C9982
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 20:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgEGSnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 14:43:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33133 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbgEGSnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 14:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588877025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6c1pQRhCsTOGP7cSEnRY7kqeqtM7sdKQPmWYvHvM3ZE=;
        b=ivg65lpjxGSahskklxYH4xxq1KaBaojHBOyhJS2c0U5tZ2am1b/2IsIh8kgPW7rrGnWFuS
        f1ADxcvSbGXBjc+LAWJdg4jZXTrExTVpPvr5K8/YDLLyIe0yTQ611gqCOIHQYAVnyQ+IPu
        JAx4gaqZJdJrX4dmEeGvo2r1ieYWDC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-uR3aaPPjNFiF0r5nZtu9ZA-1; Thu, 07 May 2020 14:43:37 -0400
X-MC-Unique: uR3aaPPjNFiF0r5nZtu9ZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECD19BFC4;
        Thu,  7 May 2020 18:43:34 +0000 (UTC)
Received: from work-vm (ovpn-114-224.ams2.redhat.com [10.36.114.224])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DC9D60BEC;
        Thu,  7 May 2020 18:43:26 +0000 (UTC)
Date:   Thu, 7 May 2020 19:43:24 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com, kevin.tian@intel.com,
        ziye.yang@intel.com, changpeng.liu@intel.com, yi.l.liu@intel.com,
        mlevitsk@redhat.com, eskultet@redhat.com, cohuck@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/2] Sample mtty: Add migration capability to mtty
 module
Message-ID: <20200507184324.GG2699@work-vm>
References: <1588614860-16330-1-git-send-email-kwankhede@nvidia.com>
 <1588614860-16330-3-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588614860-16330-3-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Kirti Wankhede (kwankhede@nvidia.com) wrote:
> This patch makes mtty device migration capable. Purpose od this code is
> to test migration interface. Only stop-and-copy phase is implemented.
> Postcopy migration is not supported.
> 
> Actual data for mtty device migration is very less. Appended dummy data to
> migration data stream, default 100 Mbytes. Added sysfs file
> 'dummy_data_size_MB' to get dummy data size from user which can be used
> to check performance of based of data size. During resuming dummy data is
> read and discarded.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  samples/vfio-mdev/mtty.c | 602 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 574 insertions(+), 28 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index bf666cce5bb7..f9194234fc6a 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -44,9 +44,23 @@
>  
>  #define MTTY_STRING_LEN		16
>  
> -#define MTTY_CONFIG_SPACE_SIZE  0xff
> -#define MTTY_IO_BAR_SIZE        0x8
> -#define MTTY_MMIO_BAR_SIZE      0x100000
> +#define MTTY_CONFIG_SPACE_SIZE		0xff
> +#define MTTY_IO_BAR_SIZE		0x8
> +#define MTTY_MMIO_BAR_SIZE		0x100000
> +#define MTTY_MIGRATION_REGION_SIZE	0x1000000	// 16M
> +
> +#define MTTY_MIGRATION_REGION_INDEX	VFIO_PCI_NUM_REGIONS
> +#define MTTY_REGIONS_MAX		(MTTY_MIGRATION_REGION_INDEX + 1)
> +
> +/* Data section start from page aligned offset */
> +#define MTTY_MIGRATION_REGION_DATA_OFFSET	(0x1000)
> +
> +/* First page is used for struct vfio_device_migration_info */
> +#define MTTY_MIGRATION_REGION_SIZE_MMAP     \
> +	(MTTY_MIGRATION_REGION_SIZE - MTTY_MIGRATION_REGION_DATA_OFFSET)
> +
> +#define MIGRATION_INFO_OFFSET(MEMBER)	\
> +		offsetof(struct vfio_device_migration_info, MEMBER)
>  
>  #define STORE_LE16(addr, val)   (*(u16 *)addr = val)
>  #define STORE_LE32(addr, val)   (*(u32 *)addr = val)
> @@ -129,6 +143,28 @@ struct serial_port {
>  	u8 intr_trigger_level;  /* interrupt trigger level */
>  };
>  
> +/* Migration packet */
> +#define PACKET_ID		(u16)(0xfeedbaba)
> +
> +#define PACKET_FLAGS_ACTUAL_DATA	(1 << 0)
> +#define PACKET_FLAGS_DUMMY_DATA		(1 << 1)
> +
> +#define PACKET_DATA_SIZE_MAX		(8 * 1024 * 1024)
> +
> +struct packet {
> +	u16 id;
> +	u16 flags;
> +	u32 data_size;
> +	u8 data[];
> +};
> +
> +enum {
> +	PACKET_STATE_NONE = 0,
> +	PACKET_STATE_PREPARED,
> +	PACKET_STATE_COPIED,
> +	PACKET_STATE_LAST,
> +};
> +
>  /* State of each mdev device */
>  struct mdev_state {
>  	int irq_fd;
> @@ -138,22 +174,37 @@ struct mdev_state {
>  	u8 *vconfig;
>  	struct mutex ops_lock;
>  	struct mdev_device *mdev;
> -	struct mdev_region_info region_info[VFIO_PCI_NUM_REGIONS];
> -	u32 bar_mask[VFIO_PCI_NUM_REGIONS];
> +	struct mdev_region_info region_info[MTTY_REGIONS_MAX];
> +	u32 bar_mask[MTTY_REGIONS_MAX];
>  	struct list_head next;
>  	struct serial_port s[2];
>  	struct mutex rxtx_lock;
>  	struct vfio_device_info dev_info;
> -	int nr_ports;
> +	u32 nr_ports;
>  
>  	/* List of pinned gpfns, gpfn as index and content is translated hpfn */
>  	unsigned long *gpfn_to_hpfn;
>  	struct notifier_block nb;
> +
> +	u32 device_state;
> +	u64 saved_size;
> +	void *mig_region_base;
> +	bool is_actual_data_sent;
> +	struct packet *pkt;
> +	u32 packet_state;
> +	u64 dummy_data_size;
>  };
>  
>  static struct mutex mdev_list_lock;
>  static struct list_head mdev_devices_list;
>  
> +/*
> + * Default dummy data size set to 100 MB. To change value of dummy data size at
> + * runtime but before migration write size in MB to sysfs file
> + * dummy_data_size_MB
> + */
> +static unsigned long user_dummy_data_size = (100 * 1024 * 1024);
> +
>  static const struct file_operations vd_fops = {
>  	.owner          = THIS_MODULE,
>  };
> @@ -639,6 +690,288 @@ static void mdev_read_base(struct mdev_state *mdev_state)
>  	}
>  }
>  
> +static int save_setup(struct mdev_state *mdev_state)
> +{
> +	mdev_state->is_actual_data_sent = false;
> +
> +	memset(mdev_state->pkt, 0, sizeof(struct packet) +
> +				   PACKET_DATA_SIZE_MAX);
> +
> +	return 0;
> +}
> +
> +static int set_device_state(struct mdev_state *mdev_state, u32 device_state)
> +{
> +	int ret = 0;
> +
> +	if (mdev_state->device_state == device_state)
> +		return 0;
> +
> +	if (device_state & VFIO_DEVICE_STATE_RUNNING) {
> +#if defined(DEBUG)
> +		if (device_state & VFIO_DEVICE_STATE_SAVING) {
> +			pr_info("%s: %s Pre-copy\n", __func__,
> +				dev_name(mdev_dev(mdev_state->mdev)));
> +		} else
> +			pr_info("%s: %s Running\n", __func__,
> +				dev_name(mdev_dev(mdev_state->mdev)));
> +#endif
> +	} else {
> +		if (device_state & VFIO_DEVICE_STATE_SAVING) {
> +#if defined(DEBUG)
> +			pr_info("%s: %s Stop-n-copy\n", __func__,
> +				dev_name(mdev_dev(mdev_state->mdev)));
> +#endif
> +			ret = save_setup(mdev_state);
> +
> +		} else if (device_state & VFIO_DEVICE_STATE_RESUMING) {
> +#if defined(DEBUG)
> +			pr_info("%s: %s Resuming\n", __func__,
> +				dev_name(mdev_dev(mdev_state->mdev)));
> +		} else {
> +			pr_info("%s: %s Stopped\n", __func__,
> +				dev_name(mdev_dev(mdev_state->mdev)));
> +#endif
> +		}
> +	}
> +
> +	mdev_state->device_state = device_state;
> +
> +	return ret;
> +}
> +
> +static u32 get_device_state(struct mdev_state *mdev_state)
> +{
> +	return mdev_state->device_state;
> +}
> +
> +static void write_to_packet(struct packet *pkt, u8 *data, size_t size)
> +{
> +	if ((pkt->data_size + size) > PACKET_DATA_SIZE_MAX) {
> +		pr_err("%s: packet data overflow\n", __func__);
> +		return;
> +	}
> +	memcpy((void *)&pkt->data[pkt->data_size], (void *)data, size);
> +	pkt->data_size += size;
> +}
> +
> +static void read_from_packet(struct packet *pkt, u8 *data,
> +			     int index, size_t size)
> +{
> +	if ((index + size) > PACKET_DATA_SIZE_MAX) {
> +		pr_err("%s: packet data overflow\n", __func__);
> +		return;
> +	}
> +
> +	memcpy((void *)data, (void *)&pkt->data[index], size);
> +}
> +
> +static int save_device_data(struct mdev_state *mdev_state, u64 *pending)
> +{
> +	/* Save device data only during stop-and-copy phase */
> +	if (mdev_state->device_state != VFIO_DEVICE_STATE_SAVING) {
> +		*pending = 0;
> +		return 0;
> +	}
> +
> +	if (mdev_state->packet_state == PACKET_STATE_PREPARED) {
> +		*pending = sizeof(struct packet) + mdev_state->pkt->data_size;
> +		return 0;
> +	}
> +
> +	if (!mdev_state->is_actual_data_sent) {
> +
> +		/* create actual data packet */
> +		write_to_packet(mdev_state->pkt, (u8 *)&mdev_state->nr_ports,
> +				sizeof(mdev_state->nr_ports));
> +		write_to_packet(mdev_state->pkt, (u8 *)&mdev_state->s,
> +				sizeof(struct serial_port) * 2);
> +
> +		write_to_packet(mdev_state->pkt, mdev_state->vconfig,
> +				MTTY_CONFIG_SPACE_SIZE);
> +
> +		write_to_packet(mdev_state->pkt, (u8 *)mdev_state->gpfn_to_hpfn,
> +				sizeof(unsigned long) * MAX_GPFN_COUNT);
> +
> +		mdev_state->pkt->id = PACKET_ID;
> +		mdev_state->pkt->flags = PACKET_FLAGS_ACTUAL_DATA;
> +
> +		mdev_state->is_actual_data_sent = true;
> +	} else {
> +		/* create dummy data packet */
> +		if (mdev_state->dummy_data_size > user_dummy_data_size) {
> +			*pending = 0;
> +			mdev_state->packet_state = PACKET_STATE_NONE;
> +			return 0;
> +		}
> +
> +		memset(mdev_state->pkt->data, 0xa5, PACKET_DATA_SIZE_MAX);
> +
> +		mdev_state->pkt->id = PACKET_ID;
> +		mdev_state->pkt->flags = PACKET_FLAGS_DUMMY_DATA;
> +		mdev_state->pkt->data_size = PACKET_DATA_SIZE_MAX;
> +		mdev_state->dummy_data_size += PACKET_DATA_SIZE_MAX;
> +	}
> +
> +	*pending = sizeof(struct packet) + mdev_state->pkt->data_size;
> +	mdev_state->packet_state = PACKET_STATE_PREPARED;
> +	mdev_state->saved_size = 0;
> +
> +	return 0;
> +}
> +
> +static int copy_device_data(struct mdev_state *mdev_state)
> +{
> +	u64 size;
> +
> +	if (!mdev_state->pkt || !mdev_state->mig_region_base)
> +		return -EINVAL;
> +
> +	if (mdev_state->packet_state == PACKET_STATE_COPIED)
> +		return 0;
> +
> +	if (!mdev_state->pkt->data_size)
> +		return 0;
> +
> +	size = sizeof(struct packet) + mdev_state->pkt->data_size;
> +
> +	memcpy(mdev_state->mig_region_base, mdev_state->pkt, size);
> +
> +	mdev_state->saved_size = size;
> +	mdev_state->packet_state = PACKET_STATE_COPIED;
> +	memset(mdev_state->pkt, 0, sizeof(struct packet));
> +	return 0;
> +}
> +
> +static int resume_device_data(struct mdev_state *mdev_state, u64 data_size)
> +{
> +	unsigned long i;
> +
> +	if (mdev_state->device_state != VFIO_DEVICE_STATE_RESUMING)
> +		return -EINVAL;
> +
> +	if (!mdev_state->pkt || !mdev_state->mig_region_base)
> +		return -EINVAL;
> +
> +	memcpy(mdev_state->pkt, mdev_state->mig_region_base, data_size);
> +
> +	if (mdev_state->pkt->flags & PACKET_FLAGS_ACTUAL_DATA) {
> +		int index = 0;
> +		/* restore device data */
> +		read_from_packet(mdev_state->pkt, (u8 *)&mdev_state->nr_ports,
> +				 index, sizeof(mdev_state->nr_ports));
> +		index += sizeof(mdev_state->nr_ports);
> +
> +		read_from_packet(mdev_state->pkt, (u8 *)&mdev_state->s,
> +				index, sizeof(struct serial_port) * 2);
> +		index += sizeof(struct serial_port) * 2;

Do you need to validate what you've read at this point - for example,
the max_fifo_size, or the head/tail/count values in rxtx?
e.g. if count was 0, max_fifio_size was 255, and head was 255 would
writing to the UART_TX cause an overrun?

> +
> +		read_from_packet(mdev_state->pkt, mdev_state->vconfig,
> +				 index, MTTY_CONFIG_SPACE_SIZE);

Similarly, PCI dev ID, capabilities etc ?

Dave

> +		index += MTTY_CONFIG_SPACE_SIZE;
> +
> +		read_from_packet(mdev_state->pkt,
> +				(u8 *)mdev_state->gpfn_to_hpfn,
> +				index, sizeof(unsigned long) * MAX_GPFN_COUNT);
> +		index += sizeof(unsigned long) * MAX_GPFN_COUNT;
> +
> +		for (i = 0; i < MAX_GPFN_COUNT; i++) {
> +			if (mdev_state->gpfn_to_hpfn[i] != PFN_NULL) {
> +				int ret;
> +				unsigned long hpfn;
> +
> +				ret = vfio_pin_pages(mdev_dev(mdev_state->mdev),
> +				       &i, 1, IOMMU_READ | IOMMU_WRITE, &hpfn);
> +				if (ret <= 0) {
> +					pr_err("%s: 0x%lx unpin error %d\n",
> +							__func__, i, ret);
> +					continue;
> +				}
> +				mdev_state->gpfn_to_hpfn[i] = hpfn;
> +			}
> +		}
> +	} else {
> +#if defined(DEBUG)
> +		pr_info("%s: %s discard data 0x%llx\n",
> +			 __func__, dev_name(mdev_dev(mdev_state->mdev)),
> +			data_size);
> +#endif
> +	}
> +
> +	return 0;
> +}
> +
> +static int handle_mig_read(unsigned int index, struct mdev_state *mdev_state,
> +			   loff_t offset, u8 *buf, u32 count)
> +{
> +	int ret = 0;
> +	u64 pending = 0;
> +
> +	switch (offset) {
> +	case MIGRATION_INFO_OFFSET(device_state):	// 0x00
> +		*(u32 *)buf = get_device_state(mdev_state);
> +		break;
> +
> +	case MIGRATION_INFO_OFFSET(pending_bytes):	// 0x08
> +		ret = save_device_data(mdev_state, &pending);
> +		if (ret)
> +			break;
> +		*(u64 *)buf = pending;
> +		break;
> +
> +	case MIGRATION_INFO_OFFSET(data_offset):	// 0x10
> +		if (mdev_state->device_state & VFIO_DEVICE_STATE_SAVING) {
> +			ret = copy_device_data(mdev_state);
> +			if (ret)
> +				break;
> +		}
> +		*(u64 *)buf = MTTY_MIGRATION_REGION_DATA_OFFSET;
> +		break;
> +
> +	case MIGRATION_INFO_OFFSET(data_size):		// 0x18
> +		*(u64 *)buf = mdev_state->saved_size;
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +#if defined(DEBUG)
> +	pr_info("%s: %s MIG  RD @0x%llx bytes: %d data: 0x%x\n",
> +			__func__, dev_name(mdev_dev(mdev_state->mdev)),
> +			offset, count, *(u32 *)buf);
> +#endif
> +	return ret;
> +}
> +
> +static int handle_mig_write(unsigned int index, struct mdev_state *mdev_state,
> +				loff_t offset, u8 *buf, u32 count)
> +{
> +	int ret = 0;
> +
> +#if defined(DEBUG)
> +	pr_info("%s: %s MIG  WR @0x%llx bytes: %d data: 0x%x\n",
> +			__func__, dev_name(mdev_dev(mdev_state->mdev)),
> +			offset, count, *(u32 *)buf);
> +#endif
> +	switch (offset) {
> +	case MIGRATION_INFO_OFFSET(device_state):	// 0x00
> +		ret = set_device_state(mdev_state, *(u32 *)buf);
> +		break;
> +
> +	case MIGRATION_INFO_OFFSET(data_size):		// 0x18
> +		ret = resume_device_data(mdev_state, *(u64 *)buf);
> +		break;
> +
> +	case MIGRATION_INFO_OFFSET(pending_bytes):	// 0x08
> +	case MIGRATION_INFO_OFFSET(data_offset):	// 0x10
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
>  static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
>  			   loff_t pos, bool is_write)
>  {
> @@ -702,6 +1035,18 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
>  		}
>  		break;
>  
> +	case MTTY_MIGRATION_REGION_INDEX:
> +		if (is_write) {
> +			ret = handle_mig_write(index, mdev_state, offset, buf,
> +					      count);
> +		} else {
> +			ret = handle_mig_read(index, mdev_state, offset, buf,
> +					      count);
> +		}
> +		if (ret)
> +			goto accessfailed;
> +		break;
> +
>  	default:
>  		ret = -1;
>  		goto accessfailed;
> @@ -709,7 +1054,6 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
>  
>  	ret = count;
>  
> -
>  accessfailed:
>  	mutex_unlock(&mdev_state->ops_lock);
>  
> @@ -819,13 +1163,29 @@ static int mtty_reset(struct mdev_device *mdev)
>  static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
>  			 size_t count, loff_t *ppos)
>  {
> -	unsigned int done = 0;
> +	unsigned int done = 0, index;
>  	int ret;
>  
> +	index = MTTY_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +
>  	while (count) {
>  		size_t filled;
>  
> -		if (count >= 4 && !(*ppos % 4)) {
> +		if ((index == MTTY_MIGRATION_REGION_INDEX) &&
> +		    (count >= 8 && !(*ppos % 8))) {
> +			u64 val;
> +
> +			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
> +					   *ppos, false);
> +			if (ret <= 0)
> +				goto read_err;
> +
> +			if (copy_to_user(buf, &val, sizeof(val)))
> +				goto read_err;
> +
> +			filled = 8;
> +
> +		} else if (count >= 4 && !(*ppos % 4)) {
>  			u32 val;
>  
>  			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
> @@ -878,13 +1238,27 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
>  static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
>  		   size_t count, loff_t *ppos)
>  {
> -	unsigned int done = 0;
> +	unsigned int done = 0, index;
>  	int ret;
>  
> +	index = MTTY_VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>  	while (count) {
>  		size_t filled;
>  
> -		if (count >= 4 && !(*ppos % 4)) {
> +		if ((index == MTTY_MIGRATION_REGION_INDEX) &&
> +		    (count >= 8 && !(*ppos % 8))) {
> +			u64 val;
> +
> +			if (copy_from_user(&val, buf, sizeof(val)))
> +				goto write_err;
> +
> +			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
> +					  *ppos, true);
> +			if (ret <= 0)
> +				goto write_err;
> +
> +			filled = 8;
> +		} else if (count >= 4 && !(*ppos % 4)) {
>  			u32 val;
>  
>  			if (copy_from_user(&val, buf, sizeof(val)))
> @@ -1061,12 +1435,13 @@ static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
>  }
>  
>  static int mtty_get_region_info(struct mdev_device *mdev,
> -			 struct vfio_region_info *region_info,
> -			 u16 *cap_type_id, void **cap_type)
> +				struct vfio_region_info *region_info,
> +				struct vfio_info_cap *caps)
>  {
>  	unsigned int size = 0;
>  	struct mdev_state *mdev_state;
> -	u32 bar_index;
> +	u32 index;
> +	int ret = 0;
>  
>  	if (!mdev)
>  		return -EINVAL;
> @@ -1075,13 +1450,13 @@ static int mtty_get_region_info(struct mdev_device *mdev,
>  	if (!mdev_state)
>  		return -EINVAL;
>  
> -	bar_index = region_info->index;
> -	if (bar_index >= VFIO_PCI_NUM_REGIONS)
> +	index = region_info->index;
> +	if (index >= MTTY_REGIONS_MAX)
>  		return -EINVAL;
>  
>  	mutex_lock(&mdev_state->ops_lock);
>  
> -	switch (bar_index) {
> +	switch (index) {
>  	case VFIO_PCI_CONFIG_REGION_INDEX:
>  		size = MTTY_CONFIG_SPACE_SIZE;
>  		break;
> @@ -1092,21 +1467,63 @@ static int mtty_get_region_info(struct mdev_device *mdev,
>  		if (mdev_state->nr_ports == 2)
>  			size = MTTY_IO_BAR_SIZE;
>  		break;
> +	case MTTY_MIGRATION_REGION_INDEX:
> +		size = MTTY_MIGRATION_REGION_SIZE;
> +		break;
>  	default:
>  		size = 0;
>  		break;
>  	}
>  
> -	mdev_state->region_info[bar_index].size = size;
> -	mdev_state->region_info[bar_index].vfio_offset =
> -		MTTY_VFIO_PCI_INDEX_TO_OFFSET(bar_index);
> +	mdev_state->region_info[index].size = size;
> +	mdev_state->region_info[index].vfio_offset =
> +					MTTY_VFIO_PCI_INDEX_TO_OFFSET(index);
>  
>  	region_info->size = size;
> -	region_info->offset = MTTY_VFIO_PCI_INDEX_TO_OFFSET(bar_index);
> +	region_info->offset = MTTY_VFIO_PCI_INDEX_TO_OFFSET(index);
>  	region_info->flags = VFIO_REGION_INFO_FLAG_READ |
> -		VFIO_REGION_INFO_FLAG_WRITE;
> +			     VFIO_REGION_INFO_FLAG_WRITE;
> +
> +	if (index == MTTY_MIGRATION_REGION_INDEX) {
> +		struct vfio_region_info_cap_sparse {
> +			struct vfio_region_info_cap_sparse_mmap sparse;
> +			struct vfio_region_sparse_mmap_area area;
> +		};
> +
> +		struct vfio_region_info_cap_sparse mig_region;
> +
> +		struct vfio_region_info_cap_type cap_type = {
> +			.header.id = VFIO_REGION_INFO_CAP_TYPE,
> +			.header.version = 1,
> +			.type = VFIO_REGION_TYPE_MIGRATION,
> +			.subtype = VFIO_REGION_SUBTYPE_MIGRATION
> +		};
> +
> +		/* Add REGION CAP type */
> +		ret = vfio_info_add_capability(caps, &cap_type.header,
> +						sizeof(cap_type));
> +		if (ret)
> +			goto exit;
> +
> +		/* Add sparse mmap cap type */
> +		mig_region.sparse.nr_areas = 1;
> +		mig_region.sparse.header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +		mig_region.sparse.header.version = 1;
> +
> +		mig_region.area.offset = MTTY_MIGRATION_REGION_DATA_OFFSET;
> +		mig_region.area.size = MTTY_MIGRATION_REGION_SIZE_MMAP;
> +
> +		region_info->flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +
> +		if (region_info->argsz > sizeof(*region_info))
> +			region_info->flags |= VFIO_REGION_INFO_FLAG_MMAP;
> +
> +		ret = vfio_info_add_capability(caps, &mig_region.sparse.header,
> +						sizeof(mig_region));
> +	}
> +exit:
>  	mutex_unlock(&mdev_state->ops_lock);
> -	return 0;
> +	return ret;
>  }
>  
>  static int mtty_get_irq_info(struct mdev_device *mdev,
> @@ -1138,7 +1555,7 @@ static int mtty_get_device_info(struct mdev_device *mdev,
>  			 struct vfio_device_info *dev_info)
>  {
>  	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
> -	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
> +	dev_info->num_regions = MTTY_REGIONS_MAX;
>  	dev_info->num_irqs = VFIO_PCI_NUM_IRQS;
>  
>  	return 0;
> @@ -1150,6 +1567,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  	int ret = 0;
>  	unsigned long minsz;
>  	struct mdev_state *mdev_state;
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>  
>  	if (!mdev)
>  		return -EINVAL;
> @@ -1185,8 +1603,6 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  	case VFIO_DEVICE_GET_REGION_INFO:
>  	{
>  		struct vfio_region_info info;
> -		u16 cap_type_id = 0;
> -		void *cap_type = NULL;
>  
>  		minsz = offsetofend(struct vfio_region_info, offset);
>  
> @@ -1196,11 +1612,29 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  		if (info.argsz < minsz)
>  			return -EINVAL;
>  
> -		ret = mtty_get_region_info(mdev, &info, &cap_type_id,
> -					   &cap_type);
> +		ret = mtty_get_region_info(mdev, &info, &caps);
>  		if (ret)
>  			return ret;
>  
> +		if (caps.size) {
> +			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user((void __user *)arg +
> +							sizeof(info), caps.buf,
> +							caps.size)) {
> +					kfree(caps.buf);
> +					ret = -EFAULT;
> +					break;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +			kfree(caps.buf);
> +		}
> +
>  		if (copy_to_user((void __user *)arg, &info, minsz))
>  			return -EFAULT;
>  
> @@ -1266,6 +1700,89 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
>  	return -ENOTTY;
>  }
>  
> +void mmap_close(struct vm_area_struct *vma)
> +{
> +	struct mdev_device *mdev = vma->vm_private_data;
> +	struct mdev_state *mdev_state;
> +	uint32_t index = 0;
> +
> +	if (!mdev)
> +		return;
> +
> +	mdev_state = mdev_get_drvdata(mdev);
> +	if (!mdev_state)
> +		return;
> +
> +	mutex_lock(&mdev_state->ops_lock);
> +	index = MTTY_VFIO_PCI_OFFSET_TO_INDEX(vma->vm_pgoff << PAGE_SHIFT);
> +	if (index == MTTY_MIGRATION_REGION_INDEX) {
> +		if (mdev_state->mig_region_base != NULL) {
> +			vfree(mdev_state->mig_region_base);
> +			mdev_state->mig_region_base = NULL;
> +		}
> +
> +		if (mdev_state->pkt != NULL) {
> +			vfree(mdev_state->pkt);
> +			mdev_state->pkt = NULL;
> +		}
> +	}
> +	mutex_unlock(&mdev_state->ops_lock);
> +}
> +
> +static const struct vm_operations_struct mdev_vm_ops = {
> +	.close = mmap_close,
> +};
> +
> +static int mtty_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
> +{
> +	struct mdev_state *mdev_state;
> +	unsigned int index;
> +	int ret = 0;
> +
> +	if (!mdev)
> +		return -EINVAL;
> +
> +	mdev_state = mdev_get_drvdata(mdev);
> +	if (!mdev_state)
> +		return -ENODEV;
> +
> +	mutex_lock(&mdev_state->ops_lock);
> +
> +	index = MTTY_VFIO_PCI_OFFSET_TO_INDEX(vma->vm_pgoff << PAGE_SHIFT);
> +	if (index == MTTY_MIGRATION_REGION_INDEX) {
> +		mdev_state->mig_region_base =
> +				 vmalloc_user(MTTY_MIGRATION_REGION_SIZE_MMAP);
> +		if (mdev_state->mig_region_base == NULL) {
> +			ret = -ENOMEM;
> +			goto mmap_exit;
> +		}
> +
> +		mdev_state->pkt = vzalloc(sizeof(struct packet) +
> +					  PACKET_DATA_SIZE_MAX);
> +		if (mdev_state->pkt == NULL) {
> +			vfree(mdev_state->mig_region_base);
> +			mdev_state->mig_region_base = NULL;
> +			ret = -ENOMEM;
> +			goto mmap_exit;
> +		}
> +
> +		vma->vm_ops = &mdev_vm_ops;
> +
> +		ret = remap_vmalloc_range(vma, mdev_state->mig_region_base, 0);
> +		if (ret != 0) {
> +			pr_err("remap_vmalloc_range failed, ret= %d\n", ret);
> +			vfree(mdev_state->mig_region_base);
> +			mdev_state->mig_region_base = NULL;
> +			vfree(mdev_state->pkt);
> +			mdev_state->pkt = NULL;
> +			goto mmap_exit;
> +		}
> +	}
> +mmap_exit:
> +	mutex_unlock(&mdev_state->ops_lock);
> +	return ret;
> +}
> +
>  static void unpin_pages_all(struct mdev_state *mdev_state)
>  {
>  	struct mdev_device *mdev = mdev_state->mdev;
> @@ -1339,6 +1856,8 @@ static int mtty_open(struct mdev_device *mdev)
>  
>  	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY, &events,
>  				     &mdev_state->nb);
> +	mdev_state->dummy_data_size = 0;
> +	mdev_state->mig_region_base = NULL;
>  	return ret;
>  }
>  
> @@ -1355,6 +1874,15 @@ static void mtty_close(struct mdev_device *mdev)
>  	unpin_pages_all(mdev_state);
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
>  				 &mdev_state->nb);
> +	if (mdev_state->pkt != NULL) {
> +		vfree(mdev_state->pkt);
> +		mdev_state->pkt = NULL;
> +	}
> +
> +	if (mdev_state->mig_region_base != NULL) {
> +		vfree(mdev_state->mig_region_base);
> +		mdev_state->mig_region_base = NULL;
> +	}
>  }
>  
>  static ssize_t
> @@ -1466,9 +1994,26 @@ pin_pages_store(struct device *dev, struct device_attribute *attr,
>  
>  static DEVICE_ATTR_RW(pin_pages);
>  
> +static ssize_t
> +dummy_data_size_MB_store(struct device *dev, struct device_attribute *attr,
> +			 const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	ret = kstrtoul(buf, 0, &user_dummy_data_size);
> +	if (ret)
> +		return ret;
> +
> +	user_dummy_data_size = user_dummy_data_size << 20;
> +	return count;
> +}
> +
> +static DEVICE_ATTR_WO(dummy_data_size_MB);
> +
>  static struct attribute *mdev_dev_attrs[] = {
>  	&dev_attr_sample_mdev_dev.attr,
>  	&dev_attr_pin_pages.attr,
> +	&dev_attr_dummy_data_size_MB.attr,
>  	NULL,
>  };
>  
> @@ -1573,6 +2118,7 @@ static const struct mdev_parent_ops mdev_fops = {
>  	.read                   = mtty_read,
>  	.write                  = mtty_write,
>  	.ioctl		        = mtty_ioctl,
> +	.mmap			= mtty_mmap,
>  };
>  
>  static void mtty_device_release(struct device *dev)
> -- 
> 2.7.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

