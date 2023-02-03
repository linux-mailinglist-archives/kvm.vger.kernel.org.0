Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7A068A03C
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjBCR3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 12:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCR3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 12:29:17 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD54099D5E;
        Fri,  3 Feb 2023 09:29:15 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313HJZNh023488;
        Fri, 3 Feb 2023 17:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yIKKSqHwaeTCDX9tWi3/IuUokzYTuzsU62UymCUlxww=;
 b=irlxFJsRWSC9epA+bw9h2KPZI33mn2FvtTE08gkELKIwdmJPjCGAV+MjHYq7i7d1Ks+h
 kV8u7zOtjKIKoyRrZbRC2qp2TJ0rDo8hfSJ3olSFqqmyKlUfwALmNyH+FDPAmvCsroSw
 7P+22HSkcdG6qq1kLbvGqD1CxpnFw/csJRlEgomgFggIjzxBaniM4g2hegNcXt1WMilg
 qu95NFguEX1t3l7k1aF/XixQC1sqxLeJybklXdVoi7jPbM+hziuY+Hi9p/UINGl7Xr6r
 Rc66LQcf9x5ydlKccZ5srnqIXhaFMJsgpehcGVWJTBwZwLFU6dacMy0Ls60UcdW+dnfE 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6jrg74g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:29:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 313HLPtb027841;
        Fri, 3 Feb 2023 17:29:06 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nh6jrg749-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:29:06 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 313H83Lw019216;
        Fri, 3 Feb 2023 17:29:06 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ncvura8vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 17:29:05 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 313HT4mP12452420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Feb 2023 17:29:04 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4983C58053;
        Fri,  3 Feb 2023 17:29:04 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1E9A58043;
        Fri,  3 Feb 2023 17:29:01 +0000 (GMT)
Received: from [9.65.253.123] (unknown [9.65.253.123])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Feb 2023 17:29:01 +0000 (GMT)
Message-ID: <ed030aa5-b3af-638e-6e26-4e3a20b98ef4@linux.ibm.com>
Date:   Fri, 3 Feb 2023 12:29:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230203081942.64fbf9f1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A8_BRNmMTA3ESxaqwk6JDcLm01g2G3ik
X-Proofpoint-ORIG-GUID: ulmhCn99Bg2VRlDranrSCrmqTed_gNsH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_16,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030152
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/23 10:19 AM, Alex Williamson wrote:
> On Fri, 3 Feb 2023 14:54:44 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
>>> From: Alex Williamson <alex.williamson@redhat.com>
>>> Sent: Friday, February 3, 2023 9:50 PM
>>>
>>> On Fri, 3 Feb 2023 13:32:09 +0000
>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>>   
>>>>> From: Tian, Kevin <kevin.tian@intel.com>
>>>>> Sent: Friday, February 3, 2023 10:00 AM
>>>>>  
>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>>> Sent: Friday, February 3, 2023 7:13 AM
>>>>>>
>>>>>> On Thu, 2 Feb 2023 23:04:10 +0000
>>>>>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>>>>  
>>>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
>>>>>>>> Sent: Friday, February 3, 2023 3:42 AM
>>>>>>>>
>>>>>>>>
>>>>>>>> LGTM.  I'm not sure moving the functions to vfio_main really buys  
>>> us  
>>>>>>>> anything since we're making so much use of group fields.  The cdev
>>>>>>>> approach will necessarily be different, so the bulk of the get code  
>>> will  
>>>>>>>> likely need to move back to group.c anyway.
>>>>>>>>  
>>>>>>>
>>>>>>> well my last comment was based on Matthew's v2 where the get  
>>> code  
>>>>>>> gets a kvm passed in instead of implicitly retrieving group ref_lock
>>>>>>> internally. In that case the get/put helpers only contain device logic
>>>>>>> thus fit in vfio_main.c.
>>>>>>>
>>>>>>> with v3 then they have to be in group.c since we don't want to use
>>>>>>> group fields in vfio_main.c.
>>>>>>>
>>>>>>> but I still think v2 of the helpers is slightly better. The only difference
>>>>>>> between cdev and group when handling this race is using different
>>>>>>> ref_lock. the symbol get/put part is exactly same. So even if we
>>>>>>> merge v3 like this, very likely Yi has to change it back to v2 style
>>>>>>> to share the get/put helpers while just leaving the ref_lock part
>>>>>>> handled differently between the two path.  
>>>>>>
>>>>>> I'm not really a fan of the asymmetry of the v2 version where the get
>>>>>> helper needs to be called under the new kvm_ref_lock, but the put
>>>>>> helper does not.  Having the get helper handle that makes the caller
>>>>>> much cleaner.  Thanks,
>>>>>>  
>>>>>
>>>>> What about passing the lock pointer into the helper? it's still slightly
>>>>> asymmetry as the put helper doesn't carry the lock pointer but it
>>>>> could also be interpreted as if the pointer has been saved in the get
>>>>> then if it needs to be referenced by the put there is no need to pass
>>>>> it in again.  
>>>>
>>>> For cdev, I may modify vfio_device_get_kvm_safe() to accept
>>>> struct kvm and let its caller hold a kvm_ref_lock (field within
>>>> struct vfio_device_file). Meanwhile, the group path holds
>>>> the group->kvm_ref_lock before invoking vfio_device_get_kvm_safe().
>>>> vfio_device_get_kvm_safe() just includes the symbol get/put and
>>>> the device->kvm and put_kvm set.  
>>>
>>> Sounds a lot like v2 :-\   
>>
>> Yes, like v2. 😊
>>
>>> I'd look more towards group and cdev specific
>>> helpers that handle the locking so that the callers aren't exposed to
>>> the asymmetry of get vs put, and reduce a new
>>> _vfio_device_get_kvm_safe() in common code that only does the symbol
>>> work.  Thanks,  
>>
>> If so, looks like Matthew needs a v4. I'm waiting for the final version
>> of this patch and sending a new cdev series based on it. wish to see
>> it soon ^_^.
> 
> cdev support is a future feature, why does it become a requirement for
> a fix to the current base?  The refactoring could also happen in the
> cdev series.  Thanks,
> 
> Alex
> 

FWIW, that would bloat the fix by a bit and it's already a decent-sized fix...  I took a quick stab and such a v4 would end up with a total of 120 insertions(+), 15 deletions(-).  See below for a diff of what I tried on top of v3. The idea would be to move the serialization and setting/clearing of device->kvm into group/cdev and use device->kvm as the value within vfio_device_get_kvm_safe for getting the kvm ref.  Wrappers in group/cdev would then be responsible for backing that device->kvm setting out on ref failure.
Each side (group/cdev) can wrap their own serialization / load device->kvm from the appropriate location / handle the failed get / clear device->kvm when done (since get doesn't set it, put shouldn't clear it).

If Alex wants, I can wrap something like this into a v4 -- Or, if we don't want to include this kind of infrastructure in the fix, then Yi please feel free to use it as a starting point for what you need in cdev.

Thanks,
Matt

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 7fed4233ca23..261af23975ae 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -154,6 +154,31 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	return ret;
 }
 
+static void vfio_device_group_get_kvm(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+
+	spin_lock(&device->group->kvm_ref_lock);
+
+	if (!device->group->kvm)
+		goto unlock;
+
+	device->kvm = device->group->kvm;
+	if (!vfio_device_get_kvm_safe(device))
+		device->kvm = NULL;
+
+unlock:
+	spin_unlock(&device->group->kvm_ref_lock);
+}
+
+static void vfio_device_group_put_kvm(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+
+	vfio_device_put_kvm(device);
+	device->kvm = NULL;
+}
+
 static int vfio_device_group_open(struct vfio_device *device)
 {
 	int ret;
@@ -173,12 +198,12 @@ static int vfio_device_group_open(struct vfio_device *device)
 	 * the pointer in the device for use by drivers.
 	 */
 	if (device->open_count == 0)
-		vfio_device_get_kvm_safe(device);
+		vfio_device_group_get_kvm(device);
 
 	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
 
 	if (device->open_count == 0)
-		vfio_device_put_kvm(device);
+		vfio_device_group_put_kvm(device);
 
 	mutex_unlock(&device->dev_set->lock);
 
@@ -195,7 +220,7 @@ void vfio_device_group_close(struct vfio_device *device)
 	vfio_device_close(device, device->group->iommufd);
 
 	if (device->open_count == 0)
-		vfio_device_put_kvm(device);
+		vfio_device_group_put_kvm(device);
 
 	mutex_unlock(&device->dev_set->lock);
 	mutex_unlock(&device->group->group_lock);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 20d715b0a3a8..57b24931c742 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -253,11 +253,12 @@ enum { vfio_noiommu = false };
 #endif
 
 #ifdef CONFIG_HAVE_KVM
-void vfio_device_get_kvm_safe(struct vfio_device *device);
+bool vfio_device_get_kvm_safe(struct vfio_device *device);
 void vfio_device_put_kvm(struct vfio_device *device);
 #else
-static inline void vfio_device_get_kvm_safe(struct vfio_device *device)
+static inline bool vfio_device_get_kvm_safe(struct vfio_device *device)
 {
+	return false;
 }
 
 static inline void vfio_device_put_kvm(struct vfio_device *device)
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4762550e9f42..0b8fd296ae7e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -342,7 +342,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
 #ifdef CONFIG_HAVE_KVM
-void vfio_device_get_kvm_safe(struct vfio_device *device)
+bool vfio_device_get_kvm_safe(struct vfio_device *device)
 {
 	void (*pfn)(struct kvm *kvm);
 	bool (*fn)(struct kvm *kvm);
@@ -350,32 +350,26 @@ void vfio_device_get_kvm_safe(struct vfio_device *device)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
-	spin_lock(&device->group->kvm_ref_lock);
-	if (!device->group->kvm)
-		goto unlock;
-
 	pfn = symbol_get(kvm_put_kvm);
 	if (WARN_ON(!pfn))
-		goto unlock;
+		return false;
 
 	fn = symbol_get(kvm_get_kvm_safe);
 	if (WARN_ON(!fn)) {
 		symbol_put(kvm_put_kvm);
-		goto unlock;
+		return false;
 	}
 
-	ret = fn(device->group->kvm);
+	ret = fn(device->kvm);
 	symbol_put(kvm_get_kvm_safe);
 	if (!ret) {
 		symbol_put(kvm_put_kvm);
-		goto unlock;
+		return false;
 	}
 
 	device->put_kvm = pfn;
-	device->kvm = device->group->kvm;
 
-unlock:
-	spin_unlock(&device->group->kvm_ref_lock);
+	return true;
 }
 
 void vfio_device_put_kvm(struct vfio_device *device)
@@ -386,14 +380,11 @@ void vfio_device_put_kvm(struct vfio_device *device)
 		return;
 
 	if (WARN_ON(!device->put_kvm))
-		goto clear;
+		return;
 
 	device->put_kvm(device->kvm);
 	device->put_kvm = NULL;
 	symbol_put(kvm_put_kvm);
-
-clear:
-	device->kvm = NULL;
 }
 #endif
 

