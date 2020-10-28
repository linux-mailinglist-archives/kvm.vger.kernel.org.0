Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44FD29D44A
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgJ1Vu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:50:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgJ1Vuz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:50:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S649ej151229
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 02:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bGv0So+3+mdXTEXZOiksmYP7BV24O+aciQLX4Qz+hRg=;
 b=KzzG3+mYL40o8u2wdxVYKsN5tNici89zbpZ5tC7WYmeVEEYOIgXXfcoRoPJaxsD85ZCJ
 KT2nVAongHAbvZdy4kRYZ/FbMu3cR8BhqGdjbe9GfkXVTX/2kicAyM+sSVjKiva4JPwc
 Uzmv8uuUL2X3A00tb9AFlicXZS44Dk1lnuDaeR4l3i82YX1RZNPMEQ5nA34zWo2lNUVF
 bTaU6VY0uvgatIXZfnDcR5aYfrzQ7CnvnBZm5cSqDJ+tH4mfCaivpe8uejFc7Izac5lk
 B3Vd2rbFDBLCgWaVAIVYa27tET/iOyeTJ/xi8EvSPVD5dgFiO0fGY9689svb3G2AG/NG NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34edp2qxx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 02:06:09 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09S656Bf156858
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 02:06:09 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34edp2qxx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 02:06:09 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S63A8H020401;
        Wed, 28 Oct 2020 06:06:08 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 34e1gnqxkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 06:06:08 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S667ul59441576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 06:06:07 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77CE2B2066;
        Wed, 28 Oct 2020 06:06:07 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59168B205F;
        Wed, 28 Oct 2020 06:06:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.162.92])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 06:06:07 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] s390/kvm: fix diag318 reset
To:     Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <20201015195913.101065-1-walling@linux.ibm.com>
 <20201015195913.101065-2-walling@linux.ibm.com>
 <eb8dc053-d8e6-7ef4-e722-101ab3135266@linux.ibm.com>
 <246ad72a-a081-d25a-33fd-843edaeb9248@de.ibm.com>
 <5cb6294a-b1ff-ba09-a47b-76f39a5e844a@linux.ibm.com>
 <68b946a8-1679-fe36-1c0a-236000975c3a@linux.ibm.com>
Message-ID: <8fd7e953-dd81-709a-8d8e-7770ac266e4f@linux.ibm.com>
Date:   Wed, 28 Oct 2020 02:06:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <68b946a8-1679-fe36-1c0a-236000975c3a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010280038
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/23/20 3:25 AM, Janosch Frank wrote:
> On 10/22/20 3:43 PM, Collin Walling wrote:
>> On 10/16/20 3:44 AM, Christian Borntraeger wrote:
>>>
>>>
>>> On 16.10.20 09:34, Janosch Frank wrote:
>>>> On 10/15/20 9:59 PM, Collin Walling wrote:
>>>>> The DIAGNOSE 0x0318 instruction must be reset on a normal and clear
>>>>> reset. However, this was missed for the clear reset case.
>>>>>
>>>>> Let's fix this by resetting the information during a normal reset. 
>>>>> Since clear reset is a superset of normal reset, the info will
>>>>> still reset on a clear reset.
>>>>
>>>> The architecture really confuses me here but I think we don't want this
>>>> in the kernel VCPU reset handlers at all.
>>>>
>>>> This needs to be reset per VM *NOT* per VCPU.
>>>> Hence the resets are bound to diag308 and not SIGP.
>>>>
>>>> I.e. we need to clear it in QEMU's VM reset handler.
>>>> It's still early and I have yet to consume my first coffee, am I missing
>>>> something?
>>>
>>> I agree with Janosch. architecture indicates that this should only be reset
>>> for VM-wide resets, e.g. sigp orders 11 and 12 are explicitly mentioned
>>> to NOT reset the value.
>>>
>>
>> A few questions regarding how resets for diag318 should work here:
>>
>> The AR states that any copies retained by the diag318 should be set to 0
>> on a clear reset and load normal -- I thought both of those resets were
>> implicitly called by diag308 as well?
>>
>> Should the register used to store diag318 info not be set to 0 *by KVM*
>> then? Should the values be set *by QEMU* and a subsequent sync_regs will
>> ensure things are sane on the KVM side?
> 
> Just a FYI for the non-IBMers reading in:
> 
> I have spoken to the author of the architecture and cleared up our way
> forward.
>
> * We need to clear on diag 308 subcodes 0,1,3,4
> * SIGP does not alter diag318 data in any way

Just to make sure I fully understand the changes required here (since
the wording in the documentation is a bit tricky) -- this means I need
to remove the kvm_arch_vcpu_ioctl_*_reset code for the diag318 data and
instead implement a way for this to be reset via 308 only?

If true, then resetting this data becomes tricky with the current
implementation...

> * We need to set the cpnc on all VCPUs of the VM
> 
> 

This begs a few questions about the current design of the diag318 code.

Since the diag318 info (CPNC and CPVC) are *attributes of the
configuration*, then is the current implementation of the diag318
handling incorrect?

Right now, the diag318 data is synced per-vcpu via a sync_regs call, and
only the CPU involved in the instruction interception will have its
diag318 register synced. However, if we shouldn't use the kvm_vcpu_ioctl
functions to reset the diag318 data, then does it make sense to use the
sync_regs interface?

There are two approaches I can think of:

1. Modify the current implementation by "dirtying all the VCPU's
   registers" -- this will ensure the CPNC is set in all SIE blocks.

2. Fallback to the old implementation of this item and use an ioctl
   (only for setting the data)

   This new ioctl can be utilized to reset the diag318 data (including
   the copy retained by QEMU for migration) during the respective 308
   resets.

Any insights before I fall down the wrong rabbit hole?

[...]

-- 
Regards,
Collin

Stay safe and stay healthy
