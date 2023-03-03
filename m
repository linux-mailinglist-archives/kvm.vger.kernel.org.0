Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019656A9DB7
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 18:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCCRax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 12:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCCRav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 12:30:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586E358B6D
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 09:30:49 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323GukwA018507;
        Fri, 3 Mar 2023 17:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=47F1DWFtBGizjToc2m7xKpJ1vHYfN5KHZIGAIsGBNpg=;
 b=k+15uplQZrG3U8G5vw/BZJJ2HDPms7LdqCpoZqxPM8erFSTy5YZFD5uuNZihC36iDskt
 iGkkcGp7Ectbq7YVxuYr1IYIQcv6ZufiuxfI9OUxC/loEU/i35/PK5ZCSyi89als9fJx
 HJYm7GLF+Np0hQ9QiXpw4cgmhhZVysMIcoTFqJCw70WyWcwPeJLhbY9poDzY3BhOZKJy
 faMYwYzz621FdkY0l0ZXlxcpO7XtNV1GURwkBa6Gl5e50vxxdKkbj1ZfuaenRfn6dtwJ
 0OpLJ4VP5R3GzR3P5PFVKUpwxZgs65z1MxE+TIoTHVJdM62rBIMmP67ZyRTK7SSAL3qT 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3mv2s02b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 17:30:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 323HFKIB014628;
        Fri, 3 Mar 2023 17:30:31 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3mv2s01f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 17:30:31 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 323GZaCD030160;
        Fri, 3 Mar 2023 17:30:30 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3nybcn53yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 17:30:30 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 323HUSrR58589506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Mar 2023 17:30:28 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B3958059;
        Fri,  3 Mar 2023 17:30:28 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDF3B5805D;
        Fri,  3 Mar 2023 17:30:24 +0000 (GMT)
Received: from [9.65.215.88] (unknown [9.65.215.88])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Mar 2023 17:30:24 +0000 (GMT)
Message-ID: <6e04ab8f-dc84-e9c2-deea-2b6b31678b53@linux.ibm.com>
Date:   Fri, 3 Mar 2023 12:30:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC v3 11/18] vfio/ccw: Use vfio_[attach/detach]_device
Content-Language: en-US
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, jasowang@redhat.com, kvm@vger.kernel.org,
        jgg@nvidia.com, nicolinc@nvidia.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-12-eric.auger@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230131205305.2726330-12-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1BF0UqKHEVygJKGqohoxOqHZQaQOp0v8
X-Proofpoint-ORIG-GUID: sL-Jy66EMMXs9AalEXvnAnlyUEiK4slD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_03,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030148
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/23 3:52 PM, Eric Auger wrote:
> Let the vfio-ccw device use vfio_attach_device() and
> vfio_detach_device(), hence hiding the details of the used
> IOMMU backend.
> 
> Also now all the devices have been migrated to use the new
> vfio_attach_device/vfio_detach_device API, let's turn the
> legacy functions into static functions, local to container.c.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Hi Eric,

While testing the cdev series on s390 I ran into a couple of issues with this patch, see below.

> ---
>  include/hw/vfio/vfio-common.h |   4 --
>  hw/vfio/ccw.c                 | 118 ++++++++--------------------------
>  hw/vfio/container.c           |   8 +--
>  3 files changed, 32 insertions(+), 98 deletions(-)
> 
> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
> index 9465c4b021..1580f9617c 100644
> --- a/include/hw/vfio/vfio-common.h
> +++ b/include/hw/vfio/vfio-common.h
> @@ -176,10 +176,6 @@ void vfio_region_unmap(VFIORegion *region);
>  void vfio_region_exit(VFIORegion *region);
>  void vfio_region_finalize(VFIORegion *region);
>  void vfio_reset_handler(void *opaque);
> -VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp);
> -void vfio_put_group(VFIOGroup *group);
> -int vfio_get_device(VFIOGroup *group, const char *name,
> -                    VFIODevice *vbasedev, Error **errp);
>  int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp);
>  void vfio_detach_device(VFIODevice *vbasedev);
>  
> diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
> index 0354737666..6fde7849cc 100644
> --- a/hw/vfio/ccw.c
> +++ b/hw/vfio/ccw.c
> @@ -579,27 +579,32 @@ static void vfio_ccw_put_region(VFIOCCWDevice *vcdev)
>      g_free(vcdev->io_region);
>  }
>  
> -static void vfio_ccw_put_device(VFIOCCWDevice *vcdev)
> -{
> -    g_free(vcdev->vdev.name);
> -    vfio_put_base_device(&vcdev->vdev);
> -}
> -
> -static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
> -                                Error **errp)
> +static void vfio_ccw_realize(DeviceState *dev, Error **errp)
>  {
> +    CcwDevice *ccw_dev = DO_UPCAST(CcwDevice, parent_obj, dev);
> +    S390CCWDevice *cdev = DO_UPCAST(S390CCWDevice, parent_obj, ccw_dev);
> +    VFIOCCWDevice *vcdev = DO_UPCAST(VFIOCCWDevice, cdev, cdev);
> +    S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
> +    VFIODevice *vbasedev = &vcdev->vdev;
> +    Error *err = NULL;
>      char *name = g_strdup_printf("%x.%x.%04x", vcdev->cdev.hostid.cssid,
>                                   vcdev->cdev.hostid.ssid,
>                                   vcdev->cdev.hostid.devid);


We can't get these cssid, ssid, devid values quite yet, they are currently 0s.  That has to happen after cdc->realize()


> -    VFIODevice *vbasedev;
> +    int ret;
>  
> -    QLIST_FOREACH(vbasedev, &group->device_list, next) {
> -        if (strcmp(vbasedev->name, name) == 0) {
> -            error_setg(errp, "vfio: subchannel %s has already been attached",
> -                       name);
> -            goto out_err;
> +    /* Call the class init function for subchannel. */
> +    if (cdc->realize) {
> +        cdc->realize(cdev, vcdev->vdev.sysfsdev, &err);
> +        if (err) {
> +            goto out_err_propagate;
>          }
>      }
> +    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%s/%s",
> +                                         name, cdev->mdevid);
> +    vbasedev->ops = &vfio_ccw_ops;
> +    vbasedev->type = VFIO_DEVICE_TYPE_CCW;
> +    vbasedev->name = name;

vbasedev->name is being set to the wrong value here, it needs to be the uuid.

See below for a suggested diff on top of this patch that solves the issue for me.

Thanks,
Matt

diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index 6fde7849cc..394b73358f 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -587,9 +587,6 @@ static void vfio_ccw_realize(DeviceState *dev, Error **errp)
     S390CCWDeviceClass *cdc = S390_CCW_DEVICE_GET_CLASS(cdev);
     VFIODevice *vbasedev = &vcdev->vdev;
     Error *err = NULL;
-    char *name = g_strdup_printf("%x.%x.%04x", vcdev->cdev.hostid.cssid,
-                                 vcdev->cdev.hostid.ssid,
-                                 vcdev->cdev.hostid.devid);
     int ret;
 
     /* Call the class init function for subchannel. */
@@ -599,11 +596,14 @@ static void vfio_ccw_realize(DeviceState *dev, Error **errp)
             goto out_err_propagate;
         }
     }
-    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%s/%s",
-                                         name, cdev->mdevid);
+    vbasedev->sysfsdev = g_strdup_printf("/sys/bus/css/devices/%x.%x.%04x/%s",
+                                         vcdev->cdev.hostid.cssid,
+                                         vcdev->cdev.hostid.ssid,
+                                         vcdev->cdev.hostid.devid,
+                                         cdev->mdevid);
     vbasedev->ops = &vfio_ccw_ops;
     vbasedev->type = VFIO_DEVICE_TYPE_CCW;
-    vbasedev->name = name;
+    vbasedev->name = g_strdup(cdev->mdevid);
     vbasedev->dev = &vcdev->cdev.parent_obj.parent_obj;
 
     /*


