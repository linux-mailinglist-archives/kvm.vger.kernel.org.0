Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6F305E2B
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 15:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhA0OYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 09:24:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbhA0OXx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 09:23:53 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RE4oFp116168;
        Wed, 27 Jan 2021 09:23:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=abCIndYBDut4VI/X/3RWnOiv7VwnIApJOCQn/ytES68=;
 b=mN6Z6H53VlFemyoG1k5sJEs3OjLG2wd8se8YXp/6p6o40Aia6ZSlXAbdX071CjIA/cnW
 z3r8t40ZWsGPeGUjMwccjCBJL9+egTx2QauGnKhosIbPM9oS1l13sVeQ/fMyur9J+zjH
 TwwTdfZ7pE3OPg+ObeRbcqXXHsgWeWnvdhRAklb6owzbArd7e4W7on4X3FoAqISHqPRe
 BBD8zJfEnBKxWlU60NSY7WUkfdtBX/PHdYEqEBanBLmVXiWyGjIbFlhqwKfWyHf1+tEr
 7QlDXCjtK7nztlqbPRCOVfCyevIqlOcmnNHwOkQzESfT2hC7WDJlG7gAhoOWMn0xdxSz kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b4cqt817-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 09:23:12 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RE57JV118332;
        Wed, 27 Jan 2021 09:23:11 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b4cqt80v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 09:23:11 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10REH57s000752;
        Wed, 27 Jan 2021 14:23:10 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 36adttvc52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 14:23:10 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10REN8fx37486878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 14:23:08 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 978BB28058;
        Wed, 27 Jan 2021 14:23:08 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFA272805A;
        Wed, 27 Jan 2021 14:23:05 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.138.51])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jan 2021 14:23:05 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
 <20210122164843.269f806c@omen.home.shazbot.org>
 <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
 <20210126161817.683485e0@omen.home.shazbot.org>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <b2d4e3bf-1c73-79fa-9f31-76286d394116@linux.ibm.com>
Date:   Wed, 27 Jan 2021 09:23:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126161817.683485e0@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 6:18 PM, Alex Williamson wrote:
> On Mon, 25 Jan 2021 09:40:38 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 1/22/21 6:48 PM, Alex Williamson wrote:
>>> On Tue, 19 Jan 2021 15:02:30 -0500
>>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>    
>>>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
>>>> specific requirements in terms of alignment as well as the patterns in
>>>> which the data is read/written. Allowing these to proceed through the
>>>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
>>>> way that these requirements can't be guaranteed. In addition, ISM devices
>>>> do not support the MIO codepaths that might be triggered on vfio I/O coming
>>>> from userspace; we must be able to ensure that these devices use the
>>>> non-MIO instructions.  To facilitate this, provide a new vfio region by
>>>> which non-MIO instructions can be passed directly to the host kernel s390
>>>> PCI layer, to be reliably issued as non-MIO instructions.
>>>>
>>>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
>>>> and implements the ability to pass PCISTB and PCILG instructions over it,
>>>> as these are what is required for ISM devices.
>>>
>>> There have been various discussions about splitting vfio-pci to allow
>>> more device specific drivers rather adding duct tape and bailing wire
>>> for various device specific features to extend vfio-pci.  The latest
>>> iteration is here[1].  Is it possible that such a solution could simply
>>> provide the standard BAR region indexes, but with an implementation that
>>> works on s390, rather than creating new device specific regions to
>>> perform the same task?  Thanks,
>>>
>>> Alex
>>>
>>> [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
>>>    
>>
>> Thanks for the pointer, I'll have to keep an eye on this.  An approach
>> like this could solve some issues, but I think a main issue that still
>> remains with relying on the standard BAR region indexes (whether using
>> the current vfio-pci driver or a device-specific driver) is that QEMU
>> writes to said BAR memory region are happening in, at most, 8B chunks
>> (which then, in the current general-purpose vfio-pci code get further
>> split up into 4B iowrite operations).  The alternate approach I'm
>> proposing here is allowing for the whole payload (4K) in a single
>> operation, which is significantly faster.  So, I suspect even with a
>> device specific driver we'd want this sort of a region anyhow..
> 
> Why is this device specific behavior?  It would be a fair argument that
> acceptable device access widths for MMIO are always device specific, so
> we should never break them down.  Looking at the PCI spec, a TLP
> requires a dword (4-byte) aligned address with a 10-bit length field > indicating the number of dwords, so up to 4K data as you suggest is the

Well, as I mentioned in a different thread, it's not really device 
specific behavior but rather architecture/s390x specific behavior; 
PCISTB is an interface available to all PCI devices on s390x, it just so 
happens that ISM is the first device type that is running into the 
nuance.  The architecture is designed in such a way that other devices 
can use the same interface in the same manner.

To drill down a bit, the PCISTB payload can either be 'strict' or 
'relaxed', which via the s390x architecture 'relaxed' means it's not 
dword-aligned but rather byte-aligned up to 4K.  We find out at init 
time which interface a device supports --  So, for a device that 
supports 'relaxed' PCISTB like ISM, an example would be a PCISTB of 11 
bytes coming from a non-dword-aligned address is permissible, which 
doesn't match the TLP from the spec as you described...  I believe this 
'relaxed' operation that steps outside of the spec is unique to s390x. 
(Conversely, devices that use 'strict' PCISTB conform to the typical TLP 
definition)

This deviation from spec is to my mind is another argument to treat 
these particular PCISTB separately.

> whole payload.  It's quite possible that the reason we don't have more
> access width problems is that MMIO is typically mmap'd on other
> platforms.  We get away with using the x-no-mmap=on flag for debugging,
> but it's not unheard of that the device also doesn't work quite
> correctly with that flag, which could be due to access width or timing
> difference.
> 
> So really, I don't see why we wouldn't want to maintain the guest
> access width through QEMU and the kernel interface for all devices.  It
> seems like that should be our default vfio-pci implementation.  I think
> we chose the current width based on the QEMU implementation that was
> already splitting accesses, and it (mostly) worked.  Thanks,
> 

But unless you think that allowing more flexibility than the PCI spec 
dictates (byte-aligned up to 4K rather than dword-aligned up to 4K, see 
above) this still wouldn't allow me to solve the issue I'm trying to 
with this patch set.

If you DO think allowing byte-aligned access up to 4K is OK, then I'm 
still left with a further issue (@Niklas):  I'm also using this 
region-based approach to ensure that the host uses a matching interface 
when talking to the host device (basically, s390x has two different 
versions of access to PCI devices, and for ISM at least we need to 
ensure that the same operation intercepted from the guest is being used 
on the host vs attempting to 'upgrade', which always happens via the 
standard s390s kernel PCI interfaces).
