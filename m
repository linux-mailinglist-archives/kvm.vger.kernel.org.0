Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214CB6D7631
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbjDEIEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbjDEIDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857F24C22
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680681741;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRLMleKr92gPF/OPLJspv7HTkQcd5+Jcm7+F2NR7Y4I=;
        b=aA2T0tQlFUe3VDyjoEELtijlU5tybICJoOIznaOlEkQVg5BuzSbzJfbWnTdXfWbOzJwvfr
        xSYq2iOLBRDjqQ9mkWU35fo338L24OsxNeet5vwQEVKwOGXkL4DKhnO8jQL/9quVESQ9/Z
        kjqZQjrOd68M+IBzrDpMIpWnOrYrk+E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-ywz_8IOpOsmFUyEOuV2PYQ-1; Wed, 05 Apr 2023 04:02:20 -0400
X-MC-Unique: ywz_8IOpOsmFUyEOuV2PYQ-1
Received: by mail-qt1-f197.google.com with SMTP id a19-20020a05622a02d300b003e4ecb5f613so18364869qtx.21
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 01:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680681740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRLMleKr92gPF/OPLJspv7HTkQcd5+Jcm7+F2NR7Y4I=;
        b=REHFKkJk+CAi/a8vvcf4c8OTz0TIuFkJhcPlXPZFnP207/xDaWZ7SsBapGt914XyNY
         +grIokrURjABQB/sLbMbp1wcb/S0SQird9ijAlUJwg0WIj3i/oML2FfzbCjk53la+PdJ
         zARBjzqpIsA4of0HDoYTavGoMP19JVwZUdqAmLCE6EM3fplPa2jT0VcBDrcUXfGS/176
         vnCGmFfQYtUxY207e1SoOa0ZOqkh/UDXjInw+kTzoN4WxWZdfxQTH/BNxWcbKueR2MH3
         5kGyqCsyRRsLLDzhYjezqdLx6wqeU8LBW7HI/gl8OEqwlt43iCyMUZJ4S7WB/U2qxHDs
         L/Jg==
X-Gm-Message-State: AAQBX9cnlwreXo3VNd2aHLtofyWFY3ae0YAobn+eYMDWGSPKS9uxwVFE
        mJAM4H8jNbpAHKrqBjCbkL8n070xdToaCW3YaNB0muGDQwOwzcGuidrwkYEY07KxuubZnw7RPJd
        ZhsK2sLkmlqrb
X-Received: by 2002:a05:6214:1306:b0:5e0:5ea6:69d4 with SMTP id pn6-20020a056214130600b005e05ea669d4mr9959272qvb.0.1680681739889;
        Wed, 05 Apr 2023 01:02:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZwLQoaiQae9ynKnc/QIgep6uH7H7TZvVmPWfF0Cgi43N5Q5z40m8ET3V2OgNBJYgZ18KYSSw==
X-Received: by 2002:a05:6214:1306:b0:5e0:5ea6:69d4 with SMTP id pn6-20020a056214130600b005e05ea669d4mr9959227qvb.0.1680681739573;
        Wed, 05 Apr 2023 01:02:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s4-20020a372c04000000b007456c75edbbsm4223342qkh.129.2023.04.05.01.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 01:02:18 -0700 (PDT)
Message-ID: <ee82cf0c-d208-ddac-5e00-ab34ca840c49@redhat.com>
Date:   Wed, 5 Apr 2023 10:02:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-6-yi.l.liu@intel.com>
 <20230404141838.6a4efdd4.alex.williamson@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230404141838.6a4efdd4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/23 22:18, Alex Williamson wrote:
> On Sat,  1 Apr 2023 07:44:22 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>
>> as an alternative method for ownership check when iommufd is used. In
>> this case all opened devices in the affected dev_set are verified to
>> be bound to a same valid iommufd value to allow reset. It's simpler
>> and faster as user does not need to pass a set of fds and kernel no
>> need to search the device within the given fds.
>>
>> a device in noiommu mode doesn't have a valid iommufd, so this method
>> should not be used in a dev_set which contains multiple devices and one
>> of them is in noiommu. The only allowed noiommu scenario is that the
>> calling device is noiommu and it's in a singleton dev_set.
>>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++++++++-----
>>  include/uapi/linux/vfio.h        |  9 ++++++-
>>  2 files changed, 44 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 3696b8e58445..b68fcba67a4b 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>>  struct vfio_pci_group_info;
>>  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>> -				      struct vfio_pci_group_info *groups);
>> +				      struct vfio_pci_group_info *groups,
>> +				      struct iommufd_ctx *iommufd_ctx);
>>  
>>  /*
>>   * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
>> @@ -1277,7 +1278,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>>  		return ret;
>>  
>>  	/* Somewhere between 1 and count is OK */
>> -	if (!hdr->count || hdr->count > count)
>> +	if (hdr->count > count)
>>  		return -EINVAL;
>>  
>>  	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
>> @@ -1326,7 +1327,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>>  	info.count = hdr->count;
>>  	info.files = files;
>>  
>> -	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
>> +	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
>>  
>>  hot_reset_release:
>>  	for (file_idx--; file_idx >= 0; file_idx--)
>> @@ -1341,6 +1342,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>>  {
>>  	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
>>  	struct vfio_pci_hot_reset hdr;
>> +	struct iommufd_ctx *iommufd;
>>  	bool slot = false;
>>  
>>  	if (copy_from_user(&hdr, arg, minsz))
>> @@ -1355,7 +1357,12 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>>  	else if (pci_probe_reset_bus(vdev->pdev->bus))
>>  		return -ENODEV;
>>  
>> -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
>> +	if (hdr.count)
>> +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
>> +
>> +	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
>> +
>> +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
>>  }
>>  
>>  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
>> @@ -2327,6 +2334,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
>>  {
>>  	unsigned int i;
>>  
>> +	if (!groups)
>> +		return false;
>> +
>>  	for (i = 0; i < groups->count; i++)
>>  		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
>>  			return true;
>> @@ -2402,13 +2412,25 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>>  	return ret;
>>  }
>>  
>> +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
>> +				    struct iommufd_ctx *iommufd_ctx)
>> +{
>> +	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
>> +
>> +	if (!iommufd)
>> +		return false;
>> +
>> +	return iommufd == iommufd_ctx;
>> +}
>> +
>>  /*
>>   * We need to get memory_lock for each device, but devices can share mmap_lock,
>>   * therefore we need to zap and hold the vma_lock for each device, and only then
>>   * get each memory_lock.
>>   */
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>> -				      struct vfio_pci_group_info *groups)
>> +				      struct vfio_pci_group_info *groups,
>> +				      struct iommufd_ctx *iommufd_ctx)
>>  {
>>  	struct vfio_pci_core_device *cur_mem;
>>  	struct vfio_pci_core_device *cur_vma;
>> @@ -2448,9 +2470,17 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  		 *
>>  		 * Otherwise all opened devices in the dev_set must be
>>  		 * contained by the set of groups provided by the user.
>> +		 *
>> +		 * If user provides a zero-length array, then all the
>> +		 * opened devices must be bound to a same iommufd_ctx.
>> +		 *
>> +		 * If all above checks are failed, reset is allowed only if
>> +		 * the calling device is in a singleton dev_set.
>>  		 */
>>  		if (cur_vma->vdev.open_count &&
>> -		    !vfio_dev_in_groups(cur_vma, groups)) {
>> +		    !vfio_dev_in_groups(cur_vma, groups) &&
>> +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
>> +		    (dev_set->device_count > 1)) {
> This last condition looks buggy to me, we need all conditions to be
> true to generate an error here, which means that for a singleton
> dev_set, it doesn't matter what group fds are passed, if any, or whether
> the iommufd context matches.  I think in fact this means that the empty
> array path is equally available for group use cases with a singleton
> dev_set, but we don't enable it for multiple device dev_sets like we do
> iommufd.
>
> You pointed out a previous issue with hot-reset info and no-iommu where
> if other affected devices are not bound to vfio-pci the info ioctl
> returns error.  That's handled in the hot-reset ioctl by the fact that
> all affected devices must be in the dev_set and therefore bound to
> vfio-pci drivers.  So it seems to me that aside from the spurious error
> because we can't report an iommu group when none exists, and didn't
> spot it to invent an invalid group for debugging, hot-reset otherwise
> works with no-iommu just like it does for iommu backed devices.  We
> don't currently require singleton no-iommu dev_sets afaict.
>
> I'll also note that if the dev_set is singleton, this suggests that
> pci_reset_function() can make use of bus reset, so a hot-reset is
> accessible via VFIO_DEVICE_RESET if the appropriate reset method is
> selected.
>
> Therefore, I think as written, the singleton dev_set hot-reset is
> enabled for iommufd and (unintentionally?) for the group path, while
> also negating a requirement for a group fd or that a provided group fd
> actually matches the device in this latter case.  The null-array
> approach is not however extended to groups for more general use.
> Additionally, limiting no-iommu hot-reset to singleton dev_sets
> provides only a marginal functional difference vs VFIO_DEVICE_RESET.
> Thanks,
>
> Alex
What bout introducing a helper
static bool is_reset_ok(pdev, groups, ctx) {
    if (!pdev->vdev.open_count)
        return true;
    if (groups && vfio_dev_in_groups(pdev, groups))
        return true;
    if (ctx && vfio_dev_in_iommufd_ctx(pdev, ctx)
        return true;
    return false;
}

Assuming the above logic is correct I think this would make the code
more readable

Thanks

Eric
>>  			ret = -EINVAL;
>>  			goto err_undo;
>>  		}
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index f96e5689cffc..17aa5d09db41 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -679,7 +679,14 @@ struct vfio_pci_hot_reset_info {
>>   * the calling user must ensure all affected devices, if opened, are
>>   * owned by itself.
>>   *
>> - * The ownership is proved by an array of group fds.
>> + * The ownership can be proved by:
>> + *   - An array of group fds
>> + *   - A zero-length array
>> + *
>> + * In the last case all affected devices which are opened by this user
>> + * must have been bound to a same iommufd. If the calling device is in
>> + * noiommu mode (no valid iommufd) then it can be reset only if the reset
>> + * doesn't affect other devices.
>>   *
>>   * Return: 0 on success, -errno on failure.
>>   */

