Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF93D68A493
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjBCVTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 16:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjBCVTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 16:19:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47E3A58E1;
        Fri,  3 Feb 2023 13:19:20 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313L89TM012822;
        Fri, 3 Feb 2023 21:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RKMqWN6sfB8uyXlrKFMYYZHUDbwGdqcE8LpB+OfKKhI=;
 b=U0coy6FiN2prdKfx2BO6QKiXXehqJFJ3Jo9n+EbRnz7ktCZk7IUSpeHhdhb8GCvLIuPC
 n3gxghD+AFd77Lv2nvEXj+RjYEqVGJ4VML+8WYTaISpeDlwnsjW9gtElqqutHwL+g+bA
 Y4GrIgGSIK4SJl8Eotq7cQN9/QEcRUmKquu34xGZzo3BiwvbdzSrA0boG4oGZG1yFz7X
 luN8ipZVUfO5yck9rVW8KT07z363G/T4ichRsjXesjdbQoN8PWXdFPdDyhQIaJADc5O9
 M1x1Q6oNCsLj+d4y6GW/LAyQYc1ywC9QwdmmxxgTKgtTVejNTxjStEvvcdGKtk7CcyEP vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh7b33xqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:19:17 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313KpGU0003044;
        Fri, 3 Feb 2023 21:19:17 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh7b33xq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:19:17 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 313J3Xlc005428;
        Fri, 3 Feb 2023 21:19:15 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3ncvv2at8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:19:15 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313LJE1n38208018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 21:19:14 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E045858061;
        Fri,  3 Feb 2023 21:19:13 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7731358053;
        Fri,  3 Feb 2023 21:19:11 +0000 (GMT)
Received: from [9.65.253.123] (unknown [9.65.253.123])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 21:19:11 +0000 (GMT)
Message-ID: <b5e64413-0374-edd8-9bfd-8bb613ab04f9@linux.ibm.com>
Date:   Fri, 3 Feb 2023 16:19:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
 <20230202124210.476adaf8.alex.williamson@redhat.com>
 <BN9PR11MB527618E281BEB8E479ABB0418CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230202161307.0c6aa23e.alex.williamson@redhat.com>
 <BN9PR11MB5276017F9CEBB4BAE58C40E88CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529050661FCE4A5AC4B17C3C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230203064940.435e4d65.alex.williamson@redhat.com>
 <DS0PR11MB75297154376388A3698C5CCAC3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230203081942.64fbf9f1.alex.williamson@redhat.com>
 <ed030aa5-b3af-638e-6e26-4e3a20b98ef4@linux.ibm.com>
 <20230203133503.4d8fb3e8.alex.williamson@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230203133503.4d8fb3e8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kpVL93kXaEsKUyZxgcdoZTg9cCemxDaB
X-Proofpoint-GUID: fQnEBAYZlFk6undfbII54nfBWF6zFXhl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_19,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302030189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/23 3:35 PM, Alex Williamson wrote:
> On Fri, 3 Feb 2023 12:29:01 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:

...

> I'd probably go back to making this:
> 
> void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
> 
> so the vfio_main function would handle setting and clearing
> device->kvm.  That way we could also move the lockdep into the
> vfio_main functions.  Once we do that, there's no reason to have a
> group vs cdev put function and we end up with only a wrapper on the get
> function, which should really never be used directly, so we prefix it
> with an underscore.
> 
> At that point (see incremental diff below), it's about a wash.  Current v3:
> 
>  drivers/vfio/group.c     |   32 +++++++++++++----
>  drivers/vfio/vfio.h      |   14 +++++++
>  drivers/vfio/vfio_main.c |   70 +++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h     |    2 -
>  4 files changed, 103 insertions(+), 15 deletions(-)
> 
> Folding in below:
> 
>  drivers/vfio/group.c     |   44 ++++++++++++++++++++++-----
>  drivers/vfio/vfio.h      |   15 +++++++++
>  drivers/vfio/vfio_main.c |   63 ++++++++++++++++++++++++++++++++++-----
>  include/linux/vfio.h     |    2 -
>  4 files changed, 109 insertions(+), 15 deletions(-)
> 
> Unfortunately it seems I've talked myself into the answer that we
> should maybe just pre-enable cdev by not adding a group reference in
> vfio_main.  Thanks,
> 
> Alex
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 7fed4233ca23..98621ac082f0 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -154,6 +154,18 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  	return ret;
>  }
>  
> +static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
> +{
> +	spin_lock(&device->group->kvm_ref_lock);
> +	if (!device->group->kvm)
> +		goto unlock;
> +
> +	_vfio_device_get_kvm_safe(device, device->group->kvm);
> +
> +unlock:
> +	spin_unlock(&device->group->kvm_ref_lock);
> +}
> +
>  static int vfio_device_group_open(struct vfio_device *device)
>  {
>  	int ret;
> @@ -173,7 +185,7 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	 * the pointer in the device for use by drivers.
>  	 */
>  	if (device->open_count == 0)
> -		vfio_device_get_kvm_safe(device);
> +		vfio_device_group_get_kvm_safe(device);
>  
>  	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
>  
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 20d715b0a3a8..24d6cd285945 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -253,10 +253,11 @@ enum { vfio_noiommu = false };
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM
> -void vfio_device_get_kvm_safe(struct vfio_device *device);
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm);
>  void vfio_device_put_kvm(struct vfio_device *device);
>  #else
> -static inline void vfio_device_get_kvm_safe(struct vfio_device *device)
> +static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
> +					     struct kvm *kvm)
>  {
>  }
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 4762550e9f42..00d4d5167d6c 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -342,7 +342,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>  
>  #ifdef CONFIG_HAVE_KVM
> -void vfio_device_get_kvm_safe(struct vfio_device *device)
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
>  {
>  	void (*pfn)(struct kvm *kvm);
>  	bool (*fn)(struct kvm *kvm);
> @@ -350,32 +350,25 @@ void vfio_device_get_kvm_safe(struct vfio_device *device)
>  
>  	lockdep_assert_held(&device->dev_set->lock);
>  
> -	spin_lock(&device->group->kvm_ref_lock);
> -	if (!device->group->kvm)
> -		goto unlock;
> -
>  	pfn = symbol_get(kvm_put_kvm);
>  	if (WARN_ON(!pfn))
> -		goto unlock;
> +		return;
>  
>  	fn = symbol_get(kvm_get_kvm_safe);
>  	if (WARN_ON(!fn)) {
>  		symbol_put(kvm_put_kvm);
> -		goto unlock;
> +		return;
>  	}
>  >  	ret = fn(device->group->kvm);

s/device->group->kvm/kvm/

With that small change, this looks good to me too (and testing looks good too).  Do you want me to send a v4 for one last round of review?

Thanks,
Matt
