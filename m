Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EDB2D1507
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 16:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgLGPpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 10:45:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51982 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgLGPpY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 10:45:24 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7FWtq0063050;
        Mon, 7 Dec 2020 10:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5ITXXusdyZJmpGUEP0ZlJR4HupY0+UiO2aCdp7brxcs=;
 b=O4tac+/EBWGllSE+ye5b7U/sHeXauf90+dGBfeyRamVGqFoPKq/2j2L2XTVItsm+2YPn
 ikbBr+7EYzGf76i4Kga0MqnUntGSPXG+15opUoiV0A7fW3bOBozbw8eVXrPNfohXSl/N
 /Qu8+qUg7ClIgOmvV43l3V+st55x2D4pL5tWivtDIpU2H5L/vfkBxPdP4R2sdlskOcXr
 tnViCafXJWmQ8nprr5+LPuNQw97kVkV/IyM4Xbqlyv0J8ZdkwVnO1E45kgAM/GL2qzV3
 38CPaOXwVyFDKgBKBsgsbiTqxK7tP09wPw6lN6hkAKNcxwPM5j0vf2N9/YKKOOlbVgMo Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359pygguve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 10:44:41 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7FXDHZ064742;
        Mon, 7 Dec 2020 10:44:40 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359pygguuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 10:44:40 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7FXXIm012562;
        Mon, 7 Dec 2020 15:44:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8kvax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 15:44:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7Fg6ng2425590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 15:42:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E72DD52052;
        Mon,  7 Dec 2020 15:42:05 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.4.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6874A52050;
        Mon,  7 Dec 2020 15:42:05 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM pointer
 invalidated
To:     Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, cohuck@redhat.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, david@redhat.com
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
 <20201203185514.54060568.pasic@linux.ibm.com>
 <a5a613ef-4c74-ad68-46bd-7159fbafef47@linux.ibm.com>
 <20201207162411.050c6cea.pasic@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d0c2aaee-3367-a15d-514d-88211251ca06@de.ibm.com>
Date:   Mon, 7 Dec 2020 16:42:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207162411.050c6cea.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=2
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07.12.20 16:24, Halil Pasic wrote:
> On Fri, 4 Dec 2020 11:48:24 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 12/3/20 12:55 PM, Halil Pasic wrote:
>>> On Wed,  2 Dec 2020 18:41:01 -0500
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>  
>>>> The vfio_ap device driver registers a group notifier with VFIO when the
>>>> file descriptor for a VFIO mediated device for a KVM guest is opened to
>>>> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
>>>> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
>>>> and calls the kvm_get_kvm() function to increment its reference counter.
>>>> When the notifier is called to make notification that the KVM pointer has
>>>> been set to NULL, the driver should clean up any resources associated with
>>>> the KVM pointer and decrement its reference counter. The current
>>>> implementation does not take care of this clean up.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>  
>>> Do we need a Fixes tag? Do we need this backported? In my opinion
>>> this is necessary since the interrupt patches.  
>>
>> I'll put in a fixes tag:
>> Fixes: 258287c994de (s390: vfio-ap: implement mediated device open callback)
>>
>> Yes, this should probably be backported.
> 
> I changed my mind regarding the severity of this issue. I was paranoid
> about post-mortem interrupts, and resulting notifier byte updates by the
> machine. What I overlooked is that the pin is going to prevent the memory
> form getting repurposed. I.e. if we have something like vmalloc(),
> vfio_pin(notifier_page), vfree(), I believe the notifier_page is not free
> (available for allocation). So the worst case scenario is IMHO a resource
> leak and not corruption. So I'm not sure this must be backported.
> Opinions?

Resource leaks qualify for backport and cc stable, but it is not a security
issue so this has no urgency and CVE and these kind of things.

So lets finish this without hurry, add cc stable and then look for necessary
distro backports.
