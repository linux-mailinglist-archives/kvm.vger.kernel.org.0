Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9491248D83A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiAMMv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:51:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231395AbiAMMv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:51:26 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCn9Og001663;
        Thu, 13 Jan 2022 12:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OUQP2stId/EOB/wxRLm7yCb2lgiL+l6gyI1v5rvppyQ=;
 b=aStqTlwJB0dnCSbWBTU5mTnBTq2Hfou8Qq28rkamx0KpV2NyHsGL1jtb7xKzcznUvDfZ
 W+llRB4neeN4e9tPyKOJwkRGHrpA2QM1I+0X51cVIVLvNULtuckxZBNrio881976iidc
 /9bAWmLzqs6yTmUkLkgXnxfmVs9/mG6TsGU4dehB/F32oagzUfRTT5QAPeaocT/qiqRc
 gDSJsr1DjPBNAxHGocHFnT3oO3YV0sk4DwQnVqnduFZDduCLszqIxD1vFbJy/oU8OSus
 5L0ySkV+YyV8uGEHFlje9XprH7YyJ0573wlWKA9qi8RZAKZZKR1WzuRdqtBW+R7v0Sq4 Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djk81hk6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:51:23 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DComKb010708;
        Thu, 13 Jan 2022 12:51:22 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djk81hk5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:51:22 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DClwXt012308;
        Thu, 13 Jan 2022 12:51:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjnkkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:51:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCpH4b36438430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:51:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7527AAE057;
        Thu, 13 Jan 2022 12:51:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7520AE053;
        Thu, 13 Jan 2022 12:51:16 +0000 (GMT)
Received: from [9.171.57.64] (unknown [9.171.57.64])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jan 2022 12:51:16 +0000 (GMT)
Message-ID: <c685a543-a524-9c95-4b85-f53a0ff744a9@linux.ibm.com>
Date:   Thu, 13 Jan 2022 13:51:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
 <20220113120609.736701-1-borntraeger@linux.ibm.com>
 <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
 <b6d9785d769f98da0b057fac643b0f088e346a94.camel@infradead.org>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <b6d9785d769f98da0b057fac643b0f088e346a94.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LInZdk1R9qzpJwCKnTvjKe1c1g8R-FXF
X-Proofpoint-ORIG-GUID: 2hMcZ-v_hvIoORWGH8eudJACKmiq7Kvx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201130075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13.01.22 um 13:30 schrieb David Woodhouse:
> On Thu, 2022-01-13 at 13:14 +0100, Paolo Bonzini wrote:
>> On 1/13/22 13:06, Christian Borntraeger wrote:
>>> From: Christian Borntraeger<
>>> borntraeger@de.ibm.com
>>>>
>>>
>>> Quick heads-up.
>>> The new warnon triggers on s390. Here we write to the guest from an
>>> irqfd worker. Since we do not use dirty_ring yet this might be an
>>> over-indication.
>>> Still have to look into that.
>>
>> Yes, it's okay to add an #ifdef around the warning.
> 
> That would be #ifndef CONFIG_HAVE_KVM_DIRTY_RING, yes?
> 
> I already found it hard to write down the rules around how
> kvm_vcpu_write_guest() doesn't use the vCPU it's passed, and how both
> it and kvm_write_guest() need to be invoked on a pCPU which currently
> owns *a* vCPU belonging to the same KVM... if we add "unless you're on
> an architecture that doesn't support dirty ring logging", you may have
> to pass me a bucket.
> 
> Are you proposing that as an officially documented part of the already
> horrid API, or a temporary measure :)
> 
> Btw, that get_map_page() in arch/s390/kvm/interrupt.c looks like it has
> the same use-after-free problem that kvm_map_gfn() used to have. It
> probably wants converting to the new gfn_to_pfn_cache.
> 
> Take a look at how I resolve the same issue for delivering Xen event
> channel interrupts.

Do you have a commit ID for your Xen event channel fix?

> 
> Although I gave myself a free pass on the dirty marking in that case,
> by declaring that the shinfo page doesn't get marked dirty; it should
> be considered *always* dirty. You might have less fun declaring that
> retrospectively in your case.
