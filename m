Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA566982F
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbjAMNPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbjAMNPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:15:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AB65B48F;
        Fri, 13 Jan 2023 05:04:34 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DCYkaS016890;
        Fri, 13 Jan 2023 13:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ww6zMmjTcnOLd/peXe5T2gKR2lL/++unddACNTL4kJ8=;
 b=H3dv/E+QZqHv4LgfcKoViCe4Mpgl+CB6l0LT6YAW+rMiqwLLkvIzrxOLa5UzkCRK0dwQ
 vYkD0yIDHcrnfcara6SvzkESH9Rbmm73hasJZWM8tTRuog4Dn2qfFgkRzGBSchbs2gOv
 p2XeFK1aJGa8gzL09TbFDqSlQsws++g56qDY4/zbqJQM82ydXAs9bhoFhiaNAkAqeTad
 MizVRbC14FqvWaL7GllIcbMSseQLYm39YRHvHSjIuhh3Ga5iYGWIsjnSfKo8iI71dlDe
 Wr9jufOssSeMHZ9Y+eHglIB94E/tIC0Q6cXOIC9xb3O3UojGhUKWbAvsf6hys/tQl5o7 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3745h1b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 13:04:26 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30DCaYZO025455;
        Fri, 13 Jan 2023 13:04:25 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3745h1au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 13:04:25 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30D9nr6A018953;
        Fri, 13 Jan 2023 13:04:24 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3n1knv7mmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 13:04:24 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30DD4Nmd61931944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 13:04:23 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C66358056;
        Fri, 13 Jan 2023 13:04:23 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9151A5804E;
        Fri, 13 Jan 2023 13:04:20 +0000 (GMT)
Received: from [9.160.94.233] (unknown [9.160.94.233])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 13 Jan 2023 13:04:20 +0000 (GMT)
Message-ID: <1b45ee50-4b5d-8baf-a7ac-213d93810bee@linux.ibm.com>
Date:   Fri, 13 Jan 2023 08:04:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] vfio: fix potential deadlock on vfio group lock
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20230112203844.41179-1-mjrosato@linux.ibm.com>
In-Reply-To: <20230112203844.41179-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FK2FA6y0FMkvmXlctVD_onLmjziCsCtV
X-Proofpoint-GUID: fpYPBVu0flP9NM919a5cnTgN6lCDkcUT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_05,2023-01-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/23 3:38 PM, Matthew Rosato wrote:
> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list,
> then the following call chain could result in a deadlock:
> 
> kvm_put_kvm
>  -> kvm_destroy_vm
>   -> kvm_destroy_devices
>    -> kvm_vfio_destroy
>     -> kvm_vfio_file_set_kvm
>      -> vfio_file_set_kvm
>       -> group->group_lock/group_rwsem
> 
> Avoid this scenario by having vfio core code acquire a KVM reference
> the first time a device is opened and hold that reference until the
> device fd is closed, at a point after the group lock has been released.
> 
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
> Changes from v1:
> * Re-write using symbol get logic to get kvm ref during first device
>   open, release the ref during device fd close after group lock is
>   released
> * Drop kvm get/put changes to drivers; now that vfio core holds a
>   kvm ref until sometime after the device_close op is called, it
>   should be fine for drivers to get and put their own references to it.
> ---
>  drivers/vfio/group.c     |  6 ++---
>  drivers/vfio/vfio_main.c | 48 +++++++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h     |  1 -
>  3 files changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..2b0da82f82f4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -165,9 +165,9 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	}
>  
>  	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> +	 * Here we pass the KVM pointer with the group under the lock.  A
> +	 * reference will be obtained the first time the device is opened and
> +	 * will be held until the device fd is closed.
>  	 */
>  	ret = vfio_device_open(device, device->group->iommufd,
>  			       device->group->kvm);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..c969e2a0ecd3 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,7 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#include <linux/kvm_host.h>

Ugh, looks like including linux/kvm_host.h here breaks architectures that don't have an arch/*/include/uapi/asm/kvm.h

AFAICT this should be implicit with the CONFIG_HAVE_KVM bool, so unless someone has a better idea, to avoid I think we can key off of CONFIG_HAVE_KVM like so...

#ifdef CONFIG_HAVE_KVM
#include <linux/kvm_host.h>
#endif

[...]

#ifdef CONFIG_HAVE_KVM
[...symbol_get implementation here...]
#else
static bool vfio_kvm_get_kvm_safe(struct kvm *kvm)
{
	return false;
}
static void vfio_kvm_put_kvm(struct kvm *kvm)
{

}
#endif


