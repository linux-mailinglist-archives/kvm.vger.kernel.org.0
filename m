Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9AD30634C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbhA0S2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 13:28:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236211AbhA0S2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 13:28:09 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RIHqrV044068;
        Wed, 27 Jan 2021 13:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BbmZR61CKo4yLqiicV/mYSmkeE1mwbWRQ93Crj797Lk=;
 b=icy4NwcWaUZt4XsgTHlXWcJjrAZa+zoTI/8vLFlyhUvUQgrv4NqkNCkmN03xNZ9l0V62
 xpNupcHyayTVSD6JeyVKfersl3dE+FzfzJUPQE0hfp/GetjJjSi8lN9XEE7oBX88dTgE
 LB68NrRH982j7nc2GNYmkCAG3QO3b0Th1tZWzJTJWYGWRabSSfM0fGAmokJzVRWV+JpW
 r4O4off1ZueIE0/3OSSmukNci5DOd1h+hsNyfGVyVOiEHCj61D26+zHVdMTL0Ijz3AI7
 3hc7R/KuCug3HX8yk5BJViTAhDiIGfdplnAHvmaJ+Xy4rTg3i9Zx1L8Z+leR5434jLi5 dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36b4w31gq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 13:27:27 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RIHugQ044612;
        Wed, 27 Jan 2021 13:27:27 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36b4w31gpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 13:27:27 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10RIH4mG031114;
        Wed, 27 Jan 2021 18:27:26 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 36adttx84t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 18:27:26 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10RIROWj29884672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 18:27:24 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B339F28058;
        Wed, 27 Jan 2021 18:27:24 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99A4A28059;
        Wed, 27 Jan 2021 18:27:22 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.138.51])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jan 2021 18:27:22 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
 <20210122164843.269f806c@omen.home.shazbot.org>
 <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
 <20210126161817.683485e0@omen.home.shazbot.org>
 <b2d4e3bf-1c73-79fa-9f31-76286d394116@linux.ibm.com>
 <20210127085305.153e01e4@omen.home.shazbot.org>
 <20210127184550.01c3fcdd.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <60a3b432-9b03-1b0f-c04c-25de57e533f9@linux.ibm.com>
Date:   Wed, 27 Jan 2021 13:27:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127184550.01c3fcdd.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_06:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/21 12:45 PM, Cornelia Huck wrote:
> On Wed, 27 Jan 2021 08:53:05 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Wed, 27 Jan 2021 09:23:04 -0500
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> On 1/26/21 6:18 PM, Alex Williamson wrote:
>>>> On Mon, 25 Jan 2021 09:40:38 -0500
>>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>      
>>>>> On 1/22/21 6:48 PM, Alex Williamson wrote:
>>>>>> On Tue, 19 Jan 2021 15:02:30 -0500
>>>>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>>>>         
>>>>>>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
>>>>>>> specific requirements in terms of alignment as well as the patterns in
>>>>>>> which the data is read/written. Allowing these to proceed through the
>>>>>>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
>>>>>>> way that these requirements can't be guaranteed. In addition, ISM devices
>>>>>>> do not support the MIO codepaths that might be triggered on vfio I/O coming
>>>>>>> from userspace; we must be able to ensure that these devices use the
>>>>>>> non-MIO instructions.  To facilitate this, provide a new vfio region by
>>>>>>> which non-MIO instructions can be passed directly to the host kernel s390
>>>>>>> PCI layer, to be reliably issued as non-MIO instructions.
>>>>>>>
>>>>>>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
>>>>>>> and implements the ability to pass PCISTB and PCILG instructions over it,
>>>>>>> as these are what is required for ISM devices.
>>>>>>
>>>>>> There have been various discussions about splitting vfio-pci to allow
>>>>>> more device specific drivers rather adding duct tape and bailing wire
>>>>>> for various device specific features to extend vfio-pci.  The latest
>>>>>> iteration is here[1].  Is it possible that such a solution could simply
>>>>>> provide the standard BAR region indexes, but with an implementation that
>>>>>> works on s390, rather than creating new device specific regions to
>>>>>> perform the same task?  Thanks,
>>>>>>
>>>>>> Alex
>>>>>>
>>>>>> [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
>>>>>>         
>>>>>
>>>>> Thanks for the pointer, I'll have to keep an eye on this.  An approach
>>>>> like this could solve some issues, but I think a main issue that still
>>>>> remains with relying on the standard BAR region indexes (whether using
>>>>> the current vfio-pci driver or a device-specific driver) is that QEMU
>>>>> writes to said BAR memory region are happening in, at most, 8B chunks
>>>>> (which then, in the current general-purpose vfio-pci code get further
>>>>> split up into 4B iowrite operations).  The alternate approach I'm
>>>>> proposing here is allowing for the whole payload (4K) in a single
>>>>> operation, which is significantly faster.  So, I suspect even with a
>>>>> device specific driver we'd want this sort of a region anyhow..
>>>>
>>>> Why is this device specific behavior?  It would be a fair argument that
>>>> acceptable device access widths for MMIO are always device specific, so
>>>> we should never break them down.  Looking at the PCI spec, a TLP
>>>> requires a dword (4-byte) aligned address with a 10-bit length field > indicating the number of dwords, so up to 4K data as you suggest is the
>>>
>>> Well, as I mentioned in a different thread, it's not really device
>>
>> Sorry, I tried to follow the thread, not sure it's possible w/o lots of
>> preexisting s390 knowledge.
>>
>>> specific behavior but rather architecture/s390x specific behavior;
>>> PCISTB is an interface available to all PCI devices on s390x, it just so
>>> happens that ISM is the first device type that is running into the
>>> nuance.  The architecture is designed in such a way that other devices
>>> can use the same interface in the same manner.
>>
>> As a platform access mechanism, this leans towards a platform specific
>> implementation of the PCI BAR regions.
>>   
>>> To drill down a bit, the PCISTB payload can either be 'strict' or
>>> 'relaxed', which via the s390x architecture 'relaxed' means it's not
>>> dword-aligned but rather byte-aligned up to 4K.  We find out at init
>>> time which interface a device supports --  So, for a device that
>>> supports 'relaxed' PCISTB like ISM, an example would be a PCISTB of 11
>>> bytes coming from a non-dword-aligned address is permissible, which
>>> doesn't match the TLP from the spec as you described...  I believe this
>>> 'relaxed' operation that steps outside of the spec is unique to s390x.
>>> (Conversely, devices that use 'strict' PCISTB conform to the typical TLP
>>> definition)
>>>
>>> This deviation from spec is to my mind is another argument to treat
>>> these particular PCISTB separately.
>>
>> I think that's just an accessor abstraction, we're not asking users to
>> generate TLPs.  If we expose a byte granularity interface, some
>> platforms might pass that directly to the PCISTB command, otherwise
>> might align the address, perform a dword access, and return the
>> requested byte.  AFAICT, both conventional and express PCI use dword
>> alignement on the bus, so this should be valid and at best questions
>> whether ISM is really PCI or not.
> 
> The vibes I'm getting from ISM is that it is mostly a construct using
> (one set of) the s390 pci instructions, which ends up being something
> not entirely unlike a pci device... the question is how much things

Yep, that's a fair assessment.

> like the 'relaxed' payload may also be supported by 'real' pci devices
> plugged into an s390.

The architecture allows for it, but in practicality PCI devices being 
used on s390x whose drivers are meant to run on additional platforms 
besides s390x (ex: mlx) aren't going to use something like that unless 
1) an s390x-specific exploitation is tacked on to the driver for some 
reason and 2) I think support for such behavior would need to be 
implemented in the kernel -- As really, our s390 kernel PCI logic today 
makes no special accommodations for relaxed-alignment I/O coming from 
drivers -- this is one of the reasons the host ISM driver makes s390 PCI 
calls directly rather than going through the standard kernel PCI 
interface (and subsequently why using an alternate delivery vehicle for 
pass through ISM that connects directly with the s390 PCI interface made 
sense to me)

'Relaxed' is very s390-specific and as far as I understand is only 
expected from a device type that is unique to s390 (like ISM) because of 
the way it deviates from standard PCI.  And today, the only device that 
behaves in that way (relaxed) and lacks support for certain PCI 
operations / requires a special access method (e.g. no PCISTG allowed) 
is ISM - else we'd see more devices that require direct invocation of 
s390 PCI interfaces in the kernel.


> 
>>
>>>> whole payload.  It's quite possible that the reason we don't have more
>>>> access width problems is that MMIO is typically mmap'd on other
>>>> platforms.  We get away with using the x-no-mmap=on flag for debugging,
>>>> but it's not unheard of that the device also doesn't work quite
>>>> correctly with that flag, which could be due to access width or timing
>>>> difference.
>>>>
>>>> So really, I don't see why we wouldn't want to maintain the guest
>>>> access width through QEMU and the kernel interface for all devices.  It
>>>> seems like that should be our default vfio-pci implementation.  I think
>>>> we chose the current width based on the QEMU implementation that was
>>>> already splitting accesses, and it (mostly) worked.  Thanks,
>>>>      
>>>
>>> But unless you think that allowing more flexibility than the PCI spec
>>> dictates (byte-aligned up to 4K rather than dword-aligned up to 4K, see
>>> above) this still wouldn't allow me to solve the issue I'm trying to
>>> with this patch set.
>>
>> As above, it still seems like an improvement to honor user access width
>> to the ability of the platform or bus/device interface.  If ISM is
>> really that different from PCI in this respect, it only strengthens the
>> argument to make a separate bus driver derived from vfio-pci(-core) imo.
>>
>>> If you DO think allowing byte-aligned access up to 4K is OK, then I'm
>>> still left with a further issue (@Niklas):  I'm also using this
>>> region-based approach to ensure that the host uses a matching interface
>>> when talking to the host device (basically, s390x has two different
>>> versions of access to PCI devices, and for ISM at least we need to
>>> ensure that the same operation intercepted from the guest is being used
>>> on the host vs attempting to 'upgrade', which always happens via the
>>> standard s390s kernel PCI interfaces).
>>
>> In the proposed vfio-pci-core library model, devices would be attached
>> to the most appropriate vfio bus driver, an ISM device might be bound
>> to a vfio-zpci-ism (heh, "-ism") driver on the host, standard device
> 
> That would be a nice name, at least :)
> 
>> might simply be attached to vfio-pci.
> 
> I'm wondering what a good split would be there. ISTM that the devices
> the vfio-pci-core split is written in mind with are still normal pci
> devices, just with some extra needs that can be fulfilled via an aux
> driver. ISM seems to need special treatment for normal accesses, but
> does not hook into a separate framework. (If other zpci devices need
> special accesses, would that then be a zpci framework?)
> 

As of today, I don't believe we have other devices that -require- 
special access, as I mentioned above (no future guarantee I suppose). 
However the notion of an improved PCISTB payload size beyond ISM devices 
(regardless of 'strict' or 'relaxed') is desirable, but not strictly 
necessary, as it would be applicable to any PCI device whose driver 
wants to do writes >8B on s390x and would allow that operation to be 
done in "one shot."


