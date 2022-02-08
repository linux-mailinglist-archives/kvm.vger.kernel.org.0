Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D904AE3B6
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 23:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387372AbiBHWXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 17:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386439AbiBHUeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 15:34:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A21C0613CB;
        Tue,  8 Feb 2022 12:34:12 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218KPn3Q027259;
        Tue, 8 Feb 2022 20:34:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=gZQNdWt2YQz7escCytMaHwR+GuvXEUv7AHIPsBTV2F4=;
 b=Uy4fu5Aoycdoggli8wjZ/NkqZ9waWXXJq/4pslA1dBHzO0baxT//3GjA5YdmisaGuJuW
 t0LNB5Qj8UjyDY06jGZVk1ojz81t1b5EQyLyNy5sqcVVfCYk0kBCPD9ydhPKkcKZut1C
 WbWo3hVxhB2zGMMw66kJbCpu1Sgw4Tz+Yklz6wBkGeXfrKS1wHYE35CLCTlZv1cvGPIL
 4dYNARdqbicXZ3IllvmGyCWf3Lnast03ahIqnBPDadsQxg8gRIX32M8ZQdNRPKMmWUW9
 roUxjFJIQUcqqnCNC9667wJZvCcrIhq5+5p0kIGTyExcLTmjmxSiA84KtmD8qOj+dvaQ yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3vvkc51m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 20:34:10 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218Js0iq004192;
        Tue, 8 Feb 2022 20:34:10 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3vvkc518-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 20:34:10 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218KIY9R010202;
        Tue, 8 Feb 2022 20:34:08 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3e3gpym6kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 20:34:08 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218KY6qJ16384420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 20:34:06 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78114AE062;
        Tue,  8 Feb 2022 20:34:06 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B721CAE05C;
        Tue,  8 Feb 2022 20:34:00 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 20:34:00 +0000 (GMT)
Message-ID: <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
Date:   Tue, 8 Feb 2022 15:33:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220208122624.43ad52ef.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0SPhL7AMZDvS0jqxDg7qRLmINojCPlUU
X-Proofpoint-ORIG-GUID: v3MGGEFP9Usr0rJdnGI125MN9VFSRGxi
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 2:26 PM, Alex Williamson wrote:
> On Tue, 8 Feb 2022 14:51:41 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Feb 08, 2022 at 10:43:19AM -0700, Alex Williamson wrote:
>>> On Fri,  4 Feb 2022 16:15:30 -0500
>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>    
>>>> KVM zPCI passthrough device logic will need a reference to the associated
>>>> kvm guest that has access to the device.  Let's register a group notifier
>>>> for VFIO_GROUP_NOTIFY_SET_KVM to catch this information in order to create
>>>> an association between a kvm guest and the host zdev.
>>>>
>>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>>   arch/s390/include/asm/kvm_pci.h  |  2 ++
>>>>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>>>>   drivers/vfio/pci/vfio_pci_zdev.c | 46 ++++++++++++++++++++++++++++++++
>>>>   include/linux/vfio_pci_core.h    | 10 +++++++
>>>>   4 files changed, 60 insertions(+)
>>>>
>>>> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
>>>> index e4696f5592e1..16290b4cf2a6 100644
>>>> +++ b/arch/s390/include/asm/kvm_pci.h
>>>> @@ -16,6 +16,7 @@
>>>>   #include <linux/kvm.h>
>>>>   #include <linux/pci.h>
>>>>   #include <linux/mutex.h>
>>>> +#include <linux/notifier.h>
>>>>   #include <asm/pci_insn.h>
>>>>   #include <asm/pci_dma.h>
>>>>   
>>>> @@ -32,6 +33,7 @@ struct kvm_zdev {
>>>>   	u64 rpcit_count;
>>>>   	struct kvm_zdev_ioat ioat;
>>>>   	struct zpci_fib fib;
>>>> +	struct notifier_block nb;
>>>>   };
>>>>   
>>>>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>> index f948e6cd2993..fc57d4d0abbe 100644
>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>> @@ -452,6 +452,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>>>>   
>>>>   	vfio_pci_vf_token_user_add(vdev, -1);
>>>>   	vfio_spapr_pci_eeh_release(vdev->pdev);
>>>> +	vfio_pci_zdev_release(vdev);
>>>>   	vfio_pci_core_disable(vdev);
>>>>   
>>>>   	mutex_lock(&vdev->igate);
>>>> @@ -470,6 +471,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
>>>>   void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
>>>>   {
>>>>   	vfio_pci_probe_mmaps(vdev);
>>>> +	vfio_pci_zdev_open(vdev);
>>>>   	vfio_spapr_pci_eeh_open(vdev->pdev);
>>>>   	vfio_pci_vf_token_user_add(vdev, 1);
>>>>   }
>>>
>>> If this handling were for a specific device, I think we'd be suggesting
>>> this is the point at which we cross over to a vendor variant making use
>>> of vfio-pci-core rather than hooking directly into the core code.
>>
>> Personally, I think it is wrong layering for VFIO to be aware of KVM
>> like this. This marks the first time that VFIO core code itself is
>> being made aware of the KVM linkage.
> 
> I agree, but I've resigned that I've lost that battle.  Both mdev vGPU
> vendors make specific assumptions about running on a VM.  VFIO was
> never intended to be tied to KVM or the specific use case of a VM.
> 
>> It copies the same kind of design the s390 specific mdev use of
>> putting VFIO in charge of KVM functionality. If we are doing this we
>> should just give up and admit that KVM is a first-class part of struct
>> vfio_device and get rid of the notifier stuff too, at least for s390.
> 
> Euw.  You're right, I really don't like vfio core code embracing this
> dependency for s390, device specific use cases are bad enough.
> 
>> Reading the patches and descriptions pretty much everything is boiling
>> down to 'use vfio to tell the kvm architecture code to do something' -
>> which I think needs to be handled through a KVM side ioctl.
> 
> AIF at least sounds a lot like the reason we invented the irq bypass
> mechanism to allow interrupt producers and consumers to register
> independently and associate to each other with a shared token.

Yes, these do sound quite similar, looking at it now though I haven't 
yet fully grokked irq bypass...  But with AIF you have the case where 
either the interrupt will be delivered directly to a guest from firmware 
via an s390 construct (gisa) or under various circumstances the host 
(kvm) will be prodded to perform the delivery (still via gisa) instead.

> 
> Is the purpose of IOAT to associate the device to a set of KVM page
> tables?  That seems like a container or future iommufd operation.  I

Yes, here we are establishing a relationship with the DMA table in the 
guest so that once mappings are established guest PCI operations 
(handled via special instructions in s390) don't need to go through the 
host but can be directly handled by firmware (so, effectively guest can 
keep running on its vcpu vs breaking out).

> read DTSM as supported formats for the IOAT.
> 
>> Or, at the very least, everything needs to be described in some way
>> that makes it clear what is happening to userspace, without kvm,
>> through these ioctls.

Nothing, they don't need these ioctls.  Userspace without a KVM 
registration for the device in question gets -EINVAL.

> 
> As I understand the discussion here:
> 
> https://lore.kernel.org/all/20220204211536.321475-15-mjrosato@linux.ibm.com/
> 
> The assumption is that there is no non-KVM userspace currently.  This
> seems like a regression to me.

It's more that non-KVM userspace doesn't care about what these ioctls 
are doing...  The enabling of 'interp, aif, ioat' is only pertinent when 
there is a KVM userspace, specifically because the information being 
shared / actions being performed as a result are only relevant to 
properly enabling zPCI features when the zPCI device is being passed 
through to a VM guest.  If you're just using a userspace driver to talk 
to the device (no KVM guest involved) then the kernel zPCI layer already 
has this device set up using whatever s390 facilities are available.

> 
>> This seems especially true now that it seems s390 PCI support is
>> almost truely functional, with actual new userspace instructions to
>> issue MMIO operations that work outside of KVM.
>>
>> I'm not sure how this all fits together, but I would expect an outcome
>> where DPDK could run on these new systems and not have to know
>> anything more about s390 beyond using the proper MMIO instructions via
>> some compilation time enablement.
> 
> Yes, fully enabling zPCI with vfio, but only for KVM is not optimal.

See above.  I think there is a misunderstanding here, it's not that we 
are only enabling zPCI with vfio for KVM, but rather than when using 
vfio to pass the device to a guest there is additional work that has to 
happen in order to 'fully enable' zPCI.

> 
>> (I've been reviewing s390 patches updating rdma for a parallel set of
>> stuff)
>>
>>> this is meant to extend vfio-pci proper for the whole arch.  Is there a
>>> compromise in using #ifdefs in vfio_pci_ops to call into zpci specific
>>> code that implements these arch specific hooks and the core for
>>> everything else?  SPAPR code could probably converted similarly, it
>>> exists here for legacy reasons. [Cc Jason]
>>
>> I'm not sure I get what you are suggesting? Where would these ifdefs
>> be?
> 
> Essentially just:
> 
> static const struct vfio_device_ops vfio_pci_ops = {
>          .name           = "vfio-pci",
> #ifdef CONFIG_S390
>          .open_device    = vfio_zpci_open_device,
>          .close_device   = vfio_zpci_close_device,
>          .ioctl          = vfio_zpci_ioctl,
> #else
>          .open_device    = vfio_pci_open_device,
>          .close_device   = vfio_pci_core_close_device,
>          .ioctl          = vfio_pci_core_ioctl,
> #endif
>          .read           = vfio_pci_core_read,
>          .write          = vfio_pci_core_write,
>          .mmap           = vfio_pci_core_mmap,
>          .request        = vfio_pci_core_request,
>          .match          = vfio_pci_core_match,
> };
> 
> It would at least provide more validation/exercise of the core/vendor
> split.  Thanks,
> 
> Alex
> 

