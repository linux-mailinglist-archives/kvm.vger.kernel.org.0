Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508BF3E5586
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237821AbhHJIeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:34:21 -0400
Received: from verein.lst.de ([213.95.11.211]:35196 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234937AbhHJIeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:34:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AD61C67373; Tue, 10 Aug 2021 10:33:55 +0200 (CEST)
Date:   Tue, 10 Aug 2021 10:33:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/ap_ops: Convert to use
 vfio_register_group_dev()
Message-ID: <20210810083355.GB21036@lst.de>
References: <0-v3-9f48485c5e22+3cb9-vfio_ap_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-9f48485c5e22+3cb9-vfio_ap_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021 at 04:51:15PM -0300, Jason Gunthorpe wrote:
> This is straightforward conversion, the ap_matrix_mdev is actually serving as
> the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> simple container_of() or a dev_get_drvdata() for sysfs paths.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
>  drivers/s390/crypto/vfio_ap_private.h |   2 +
>  2 files changed, 91 insertions(+), 66 deletions(-)
> 
> Alex,
> 
> This is after the reflck series and should thus go to the vfio tree. Thanks
> 
> v3:
>  - Rebase ontop of the reflk patch series
>  - Remove module get/put
>  - Update commit message
> v2: https://lore.kernel.org/linux-s390/6-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com/
> v1: https://lore.kernel.org/linux-s390/6-v1-d88406ed308e+418-vfio3_jgg@nvidia.com/
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index cee5626fe0a4ef..0828c188babedf 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -24,8 +24,9 @@
>  #define VFIO_AP_MDEV_TYPE_HWVIRT "passthrough"
>  #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>  
> -static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> +static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
> +static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>  
>  static int match_apqn(struct device *dev, const void *data)
>  {
> @@ -335,45 +336,59 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> -static int vfio_ap_mdev_create(struct mdev_device *mdev)
> +static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> +	int ret;
>  
>  	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
>  		return -EPERM;
>  
>  	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
>  	if (!matrix_mdev) {
> -		atomic_inc(&matrix_dev->available_instances);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_atomic;

Nit: the label naming here is very strange.  Somethig like
err_dec_avaiable would be much more descriptive.

> +static struct mdev_driver vfio_ap_matrix_driver = {
> +	.driver = {
> +		.name = "vfio_ap_mdev",
> +		.owner = THIS_MODULE,
> +		.mod_name = KBUILD_MODNAME,

No need to set mod_name.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
