Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F8A58FE74
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiHKOk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 10:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKOk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 10:40:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63AD6E2F8;
        Thu, 11 Aug 2022 07:40:54 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BEOjcg006116;
        Thu, 11 Aug 2022 14:40:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9FzSjyEoGrOmRBks2z+hGA60GLcXrogRTMtysyUHqWk=;
 b=dHMHVQS00ndfY9QhYFGPBEB7/CMymb2oPKHn55oQ7gidgnTspoZ/vT/YxaMTi6geMwPl
 mWsIhpxGcEA7SxIvO5kpzL8/l+ATvj4G3Z/TQHrgSjw2eFaub9AlRQcsm6nqs7P+lyKK
 fh/UwgV4PBiRqt1i9Twki2NYaacFYR0ybl+MtuLc/MOlo4ZgCJaXMHrTHR2L8riTzxrE
 t/DGr02NneFdpUE/kkSon7UEYZd1zA0m1w+HAUiXk+9H5pWXu8PojywLzLIzeBTiQli9
 FK2dTagwzBNhF2aJiCw12lUuW06YkAEk8az5uJKRpkE/eWGjUp7cRSEtfgfq6i/x9Fh6 eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw3gmrku9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 14:40:46 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BEeNnl021850;
        Thu, 11 Aug 2022 14:40:23 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw3gmrjew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 14:40:22 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BEZMgE007155;
        Thu, 11 Aug 2022 14:39:52 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3huwvkp8r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 14:39:52 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BEdpbo4457164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 14:39:51 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85A03112061;
        Thu, 11 Aug 2022 14:39:51 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBFC6112064;
        Thu, 11 Aug 2022 14:39:50 +0000 (GMT)
Received: from [9.160.108.112] (unknown [9.160.108.112])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 14:39:50 +0000 (GMT)
Message-ID: <62595a25-61a9-cc83-3941-6001fee512af@linux.ibm.com>
Date:   Thu, 11 Aug 2022 10:39:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] kvm: reverse call order of kvm_arch_destroy_vm() and
 kvm_destroy_devices()
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pbonzini@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        "scottwood@freescale.com agraf"@suse.de
References: <20220705185430.499688-1-akrowiak@linux.ibm.com>
 <647bfead-5d7c-1cb1-3bf2-235ae0205310@linux.ibm.com>
 <20220801135310.62c34c63.pasic@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220801135310.62c34c63.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kni8ivYhNxuLk5Y5VQDt5TRsxTcT-RBR
X-Proofpoint-ORIG-GUID: HmuqghCH-q0_k4v1ctGwJcPKn67oEOiA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/1/22 7:53 AM, Halil Pasic wrote:
> On Wed, 27 Jul 2022 15:00:02 -0400
> Anthony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Any Takers??????
>>
>> On 7/5/22 2:54 PM, Tony Krowiak wrote:
>>> There is a new requirement for s390 secure execution guests that the
>>> hypervisor ensures all AP queues are reset and disassociated from the
>>> KVM guest before the secure configuration is torn down. It is the
>>> responsibility of the vfio_ap device driver to handle this.
>>>
>>> Prior to commit ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM"),
>>> the driver reset all AP queues passed through to a KVM guest when notified
>>> that the KVM pointer was being set to NULL. Subsequently, the AP queues
>>> are only reset when the fd for the mediated device used to pass the queues
>>> through to the guest is closed (the vfio_ap_mdev_close_device() callback).
>>> This is not a problem when userspace is well-behaved and uses the
>>> KVM_DEV_VFIO_GROUP_DEL attribute to remove the VFIO group; however, if
>>> userspace for some reason does not close the mdev fd, a secure execution
>>> guest will tear down its configuration before the AP queues are
>>> reset because the teardown is done in the kvm_arch_destroy_vm function
>>> which is invoked prior to kvm_destroy_devices.
> As Matt has pointed out: we did not have the guarantee we need prior
> that commit. Please for the next version drop the digression about
> the old behavior.
>
>>> This patch proposes a simple solution; rather than introducing a new
>>> notifier into vfio or callback into KVM, what aoubt reversing the order
>>> in which the kvm_arch_destroy_vm and kvm_destroy_devices are called. In
>>> some very limited testing (i.e., the automated regression tests for
>>> the vfio_ap device driver) this did not seem to cause any problems.
>>>
>>> The question remains, is there a good technical reason why the VM
>>> is destroyed before the devices it is using? This is not intuitive, so
>>> this is a request for comments on this proposed patch. The assumption
>>> here is that the medev fd will get closed when the devices are destroyed.
> I did some digging! The function and the corresponding mechanism was
> introduced by  07f0a7bdec5c ("kvm: destroy emulated devices on VM
> exit"). Before that patch we used to have ref-counting, and the refcound
> got decremented in kvmppc_mpic_disconnect_vcpu() which in turn was
> called by kvm_arch_vcpu_free(). So this was basically arch specific
> stuff. For power (the patch came form power) the refcount was decremented
> before calling kvmppc_core_vcpu_free(). So I conclude the old scheme
> would have worked for us.
>
> Since the patch does not state any technical reasons, my guess is, that
> the choice was made somewhat arbitrarily under the assumption, that
> there is no requirements or dependency with regards to the destruction
> of devices or with regards towards severing the connection between
> the devices and the VM. Under these assumptions the placement of
> the invocation of kvm_destroy_devices after kvm_arch_destroy_vm()
> did made sense, because if something that is destroyed in destroy_vm()
> did hold a live reference to the device, this reference will be cleaned
> up before kvm_destroy_devices() is invoked. So basically unless the
> devices hold references to each other, things look good. If the
> positions of  kvm_arch_destroy_vm() and kvm_destroy_devices() are
> changed, then we basically need to assume that nothing that is destroyed
> in kvm_arch_destoy_vm() may logically hold a live reference (remember
> the refcount is gone, but pointers may still exist) to a kvm device.
> Does that hold? @Antony, maybe you can answer this question for us...


I do not have an answer for this without doing a deep dive into the 
code. I am not very familiar with the VM lifecycle. My hope was that 
someone who knows this area would respond to this RFC. I am copying the 
Signed-off-by email addresses for the patch (07f0a7bdec) you mentioned 
above; maybe they can provide some insight as to for their choice in 
ordering of the kvm_arch_destroy_vm() and kvm_destroy_devices() functions.



> Otherwise I will continue the digging from here, eventually.
>
> Also I have concerns about the following comments:
>
> static void kvm_destroy_devices(struct kvm *kvm)
> {
>          struct kvm_device *dev, *tmp;
>                                                                                  
>          /*
>           * We do not need to take the kvm->lock here, because nobody else
>           * has a reference to the struct kvm at this point and therefore
>           * cannot access the devices list anyhow.
> [..]
>
> Would this till hold when the order is changed?
>
> struct kvm_device_ops {
> [..]
>          /*
>           * Destroy is responsible for freeing dev.
>           *
>           * Destroy may be called before or after destructors are called
>           * on emulated I/O regions, depending on whether a reference is
>           * held by a vcpu or other kvm component that gets destroyed
>           * after the emulated I/O.
>           */
>          void (*destroy)(struct kvm_device *dev);
>
> This seems to document the order of things as is.
>
> Btw I would like to understand more about the lifecycle of these
> emulated I/O regions....
>
> @Paolo: I believe this is ultimately your truff. I'm just digging
> through the code, and the history to try to help along with this. We
> definitely need a solution for our problem. We would very much appreciate
> having your opinion!
>
> Regards,
> Halil
>
>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>> ---
>>>    virt/kvm/kvm_main.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index a49df8988cd6..edaf2918be9b 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -1248,8 +1248,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
>>>    #else
>>>    	kvm_flush_shadow_all(kvm);
>>>    #endif
>>> -	kvm_arch_destroy_vm(kvm);
>>>    	kvm_destroy_devices(kvm);
>>> +	kvm_arch_destroy_vm(kvm);
>>>    	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>>>    		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
>>>    		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
