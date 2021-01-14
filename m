Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACAB2F5EBE
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 11:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbhANKaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 05:30:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728453AbhANKaA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 05:30:00 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EA3Vuf009076;
        Thu, 14 Jan 2021 05:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Fj+nGjM+WjCcyhC32C4Ci23lIvh2ST7+wdQXw4QvTWw=;
 b=JkpxZOThnUpkFLJbk4n6GSy3gx5JOhjps2qq4AdLRJpF5GbL+EN5y2slgs+Edww53jNe
 dp5zesOGjDwlWIC1l1c1LoC6N8TCQGzPCt2qaomCNw2iPHBsUCHCLgX7TCMdhpdQdLLD
 gVMzZh/CBUcCmPuNf3dyewAcW7ERcjjNjgMMYm2cHGrYi0NasbCk0Em+9CDF/BRkFoe8
 OWvsej/+eDl298OfN5MItBDP1HUDUyfD5LywmtKVM11rwBOP/le8SzWrVtUHUvCs029g
 Y/govtGA5FVRjD5cW6a0RTrDeI9BQqz0gvW/BR8squFopT9YysXlk3V8xcGbQoP94U0n Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362k92ss3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 05:28:59 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10EA4kZU016471;
        Thu, 14 Jan 2021 05:28:56 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362k92ss0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 05:28:54 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EASp4U031669;
        Thu, 14 Jan 2021 10:28:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35y448b854-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 10:28:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EASm5h38797720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 10:28:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FB9C4C05A;
        Thu, 14 Jan 2021 10:28:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CF704C046;
        Thu, 14 Jan 2021 10:28:47 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.19.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 10:28:47 +0000 (GMT)
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Ram Pai <linuxram@us.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>, pair@us.ibm.com,
        brijesh.singh@amd.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        frankja@linux.ibm.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>, thuth@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, rth@twiddle.net, berrange@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        pbonzini@redhat.com
References: <20201217054736.GH310465@yekko.fritz.box>
 <20201217123842.51063918.cohuck@redhat.com>
 <20201217151530.54431f0e@bahia.lan>
 <20201218124111.4957eb50.cohuck@redhat.com>
 <20210104071550.GA22585@ram-ibm-com.ibm.com>
 <20210104134629.49997b53.pasic@linux.ibm.com>
 <20210104184026.GD4102@ram-ibm-com.ibm.com>
 <20210105115614.7daaadd6.pasic@linux.ibm.com>
 <20210105204125.GE4102@ram-ibm-com.ibm.com>
 <20210111175914.13adfa2e.cohuck@redhat.com> <20210113124226.GH2938@work-vm>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <6e02e8d5-af4b-624b-1a12-d03b9d554a41@de.ibm.com>
Date:   Thu, 14 Jan 2021 11:28:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113124226.GH2938@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_03:2021-01-13,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101140054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.01.21 13:42, Dr. David Alan Gilbert wrote:
> * Cornelia Huck (cohuck@redhat.com) wrote:
>> On Tue, 5 Jan 2021 12:41:25 -0800
>> Ram Pai <linuxram@us.ibm.com> wrote:
>>
>>> On Tue, Jan 05, 2021 at 11:56:14AM +0100, Halil Pasic wrote:
>>>> On Mon, 4 Jan 2021 10:40:26 -0800
>>>> Ram Pai <linuxram@us.ibm.com> wrote:
>>
>>>>> The main difference between my proposal and the other proposal is...
>>>>>
>>>>>   In my proposal the guest makes the compatibility decision and acts
>>>>>   accordingly.  In the other proposal QEMU makes the compatibility
>>>>>   decision and acts accordingly. I argue that QEMU cannot make a good
>>>>>   compatibility decision, because it wont know in advance, if the guest
>>>>>   will or will-not switch-to-secure.
>>>>>   
>>>>
>>>> You have a point there when you say that QEMU does not know in advance,
>>>> if the guest will or will-not switch-to-secure. I made that argument
>>>> regarding VIRTIO_F_ACCESS_PLATFORM (iommu_platform) myself. My idea
>>>> was to flip that property on demand when the conversion occurs. David
>>>> explained to me that this is not possible for ppc, and that having the
>>>> "securable-guest-memory" property (or whatever the name will be)
>>>> specified is a strong indication, that the VM is intended to be used as
>>>> a secure VM (thus it is OK to hurt the case where the guest does not
>>>> try to transition). That argument applies here as well.  
>>>
>>> As suggested by Cornelia Huck, what if QEMU disabled the
>>> "securable-guest-memory" property if 'must-support-migrate' is enabled?
>>> Offcourse; this has to be done with a big fat warning stating
>>> "secure-guest-memory" feature is disabled on the machine.
>>> Doing so, will continue to support guest that do not try to transition.
>>> Guest that try to transition will fail and terminate themselves.
>>
>> Just to recap the s390x situation:
>>
>> - We currently offer a cpu feature that indicates secure execution to
>>   be available to the guest if the host supports it.
>> - When we introduce the secure object, we still need to support
>>   previous configurations and continue to offer the cpu feature, even
>>   if the secure object is not specified.
>> - As migration is currently not supported for secured guests, we add a
>>   blocker once the guest actually transitions. That means that
>>   transition fails if --only-migratable was specified on the command
>>   line. (Guests not transitioning will obviously not notice anything.)
>> - With the secure object, we will already fail starting QEMU if
>>   --only-migratable was specified.
>>
>> My suggestion is now that we don't even offer the cpu feature if
>> --only-migratable has been specified. For a guest that does not want to
>> transition to secure mode, nothing changes; a guest that wants to
>> transition to secure mode will notice that the feature is not available
>> and fail appropriately (or ultimately, when the ultravisor call fails).
>> We'd still fail starting QEMU for the secure object + --only-migratable
>> combination.
>>
>> Does that make sense?
> 
> It's a little unusual; I don't think we have any other cases where
> --only-migratable changes the behaviour; I think it normally only stops
> you doing something that would have made it unmigratable or causes
> an operation that would make it unmigratable to fail.

I would like to NOT block this feature with --only-migrateable. A guest
can startup unprotected (and then is is migrateable). the migration blocker
is really a dynamic aspect during runtime. 
