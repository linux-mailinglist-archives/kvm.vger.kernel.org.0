Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA92DC3BE
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgLPQIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:08:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgLPQIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 11:08:47 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGG2gji019291;
        Wed, 16 Dec 2020 11:08:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1RiaaU+lVrVe1PHRL4Cd/QJW3N+3D/itnxFlckjehK8=;
 b=lfRxpc7x+I1Sdq4pukKrDILiozO5ZAm+Yi06bXOI+UrnuA2KMfE6uzSmHAv+gW2Ki/qV
 oF461Wx/5xdZPIyshlE7VtAkR910/3xIeImUQhOA/wmYg1gr+uT0jCeRR0qdp1oIpxt5
 Zv5d9qdPVGI8fbiW1k+/lEi5yR+6eelmirJ8UMGUFOmRt5tBzbjdxQwdQDWbkhx97Ulc
 EmIEvK9UydaZ51EGYJKepDLVKC+QiK3k+SbeOvesl5Bb59xzUvKE+Q7/845TB/4m7rdf
 +3A8Pllphrs4HKkuSyJP5JZw7C8x7I5B1Yz6Y4vfwxn0h3vD1Lc6l+YwMdM6xTI06Lf2 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fgqrhrw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 11:08:03 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGG3Zau025190;
        Wed, 16 Dec 2020 11:08:02 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fgqrhrug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 11:08:02 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGG7HgA006404;
        Wed, 16 Dec 2020 16:07:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8emh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 16:07:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGG5PI935586378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 16:05:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C18995204E;
        Wed, 16 Dec 2020 16:05:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.82.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9EAFD52052;
        Wed, 16 Dec 2020 16:05:24 +0000 (GMT)
Subject: Re: [PATCH v3] s390/vfio-ap: clean up vfio_ap resources when KVM
 pointer invalidated
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com, kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com
References: <20201214165617.28685-1-akrowiak@linux.ibm.com>
 <20201215115746.3552e873.pasic@linux.ibm.com>
 <44ffb312-964a-95c3-d691-38221cee2c0a@de.ibm.com>
 <20201216022140.02741788.pasic@linux.ibm.com>
 <ae6e5c7a-0159-035e-2bd3-0a749f81a7c0@de.ibm.com>
Message-ID: <1039a56a-f8d7-15f7-d6a6-cb126468bdff@de.ibm.com>
Date:   Wed, 16 Dec 2020 17:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <ae6e5c7a-0159-035e-2bd3-0a749f81a7c0@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_06:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.12.20 10:58, Christian Borntraeger wrote:
> On 16.12.20 02:21, Halil Pasic wrote:
>> On Tue, 15 Dec 2020 19:10:20 +0100
>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>
>>>
>>>
>>> On 15.12.20 11:57, Halil Pasic wrote:
>>>> On Mon, 14 Dec 2020 11:56:17 -0500
>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>
>>>>> The vfio_ap device driver registers a group notifier with VFIO when the
>>>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>>>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>>>>> event). When the KVM pointer is set, the vfio_ap driver takes the
>>>>> following actions:
>>>>> 1. Stashes the KVM pointer in the vfio_ap_mdev struct that holds the state
>>>>>    of the mediated device.
>>>>> 2. Calls the kvm_get_kvm() function to increment its reference counter.
>>>>> 3. Sets the function pointer to the function that handles interception of
>>>>>    the instruction that enables/disables interrupt processing.
>>>>> 4. Sets the masks in the KVM guest's CRYCB to pass AP resources through to
>>>>>    the guest.
>>>>>
>>>>> In order to avoid memory leaks, when the notifier is called to receive
>>>>> notification that the KVM pointer has been set to NULL, the vfio_ap device
>>>>> driver should reverse the actions taken when the KVM pointer was set.
>>>>>
>>>>> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
>>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>>> ---
>>>>>  drivers/s390/crypto/vfio_ap_ops.c | 29 ++++++++++++++++++++---------
>>>>>  1 file changed, 20 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>>>>> index e0bde8518745..cd22e85588e1 100644
>>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>>> @@ -1037,8 +1037,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>>>>  {
>>>>>  	struct ap_matrix_mdev *m;
>>>>>
>>>>> -	mutex_lock(&matrix_dev->lock);
>>>>> -
>>>>>  	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>>>>>  		if ((m != matrix_mdev) && (m->kvm == kvm)) {
>>>>>  			mutex_unlock(&matrix_dev->lock);
>>>>> @@ -1049,7 +1047,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>>>>>  	matrix_mdev->kvm = kvm;
>>>>>  	kvm_get_kvm(kvm);
>>>>>  	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>>>>> -	mutex_unlock(&matrix_dev->lock);
>>>>>
>>>>>  	return 0;
>>>>>  }
>>>>> @@ -1083,35 +1080,49 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>>>>>  	return NOTIFY_DONE;
>>>>>  }
>>>>>
>>>>> +static void "(struct ap_matrix_mdev *matrix_mdev)
>>>>> +{
>>>>> +	kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>>>
>>>>
>>>> This patch LGTM. The only concern I have with it is whether a
>>>> different cpu is guaranteed to observe the above assignment as
>>>> an atomic operation. I think we didn't finish this discussion
>>>> at v1, or did we?
>>>
>>> You mean just this assigment:
>>>>> +	matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
>>> should either have the old or the new value, but not halve zero halve old?
>>>
>>
>> Yes that is the assignment I was referring to. Old value will work as well because
>> kvm holds a reference to this module while in the pqap_hook.
>>  
>>> Normally this should be ok (and I would consider this a compiler bug if
>>> this is split into 2 32 bit zeroes) But if you really want to be sure then we
>>> can use WRITE_ONCE.
>>
>> Just my curiosity: what would make this a bug? Is it the s390 elf ABI,
>> or some gcc feature, or even the C standard? Also how exactly would
>> WRITE_ONCE, also access via volatile help in this particular situation?
> 
> I think its a tricky things and not strictly guaranteed, but there is a lot
> of code that relies on the atomicity of word sizes. see for example the discussion
> here
> https://lore.kernel.org/lkml/CAHk-=wgC4+kV9AiLokw7cPP429rKCU+vjA8cWAfyOjC3MtqC4A@mail.gmail.com/
> 
> WRITE_ONCE will not change the guarantees a lot, but it is mostly a documentation
> that we assume atomic access here.

After looking again at the code, I think I have to correct myself.
WRITE_ONCE does not look necessary.


Another thing, though:
Shouldnt we also replace this code

[...]
static void vfio_ap_mdev_release(struct mdev_device *mdev)
{
        struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);

        mutex_lock(&matrix_dev->lock);
        if (matrix_mdev->kvm) {
--->          kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
--->          matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
--->          vfio_ap_mdev_reset_queues(mdev);
--->          kvm_put_kvm(matrix_mdev->kvm);
--->          matrix_mdev->kvm = NULL;
[...]

with vfio_ap_mdev_unset_kvm ?
