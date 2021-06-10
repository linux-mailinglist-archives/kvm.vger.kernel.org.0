Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C92D3A24CD
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 08:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFJGzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 02:55:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229725AbhFJGzr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 02:55:47 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A6XFRe179803;
        Thu, 10 Jun 2021 02:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Zpyy7GdEdJB+ws0/NSpA6v98MDlU7R6ucXpSF+9fNkE=;
 b=HYRriYwRoKCguEqNgUZ14OUrgnXBJEpiJ/5jkbnzi7KmIMbm4pWDi4cj7H8++0ZwL9HQ
 1zqNWCKFz6faxWv2F1paNDVfsyhbVS2ifa0jPGdmQNS8QalpZcn4J9iqoQJftxz2V1Bk
 XJb9jHG+jYh4ctUKGxdQu+sTj9rJ0LZyz6cRq2rv7hYe4v1YtDISMaGXW2Cl3EJCyqJu
 JMp95V/GhjeOh7o/X1gqv2GdIU7BHnzqW9VxkCjpJlJU9yNoAC2m6x7fBfth47GauTeJ
 9rnGBd1AFnUtsr2PRDQQ34UjYqpiBWROdeRCRiFDUFGqK1bOiPwBM8JR+lJUgVdNtnVt mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 393c29tm06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 02:53:49 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15A6XVfu180452;
        Thu, 10 Jun 2021 02:53:48 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 393c29tkyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 02:53:48 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15A6prLS003304;
        Thu, 10 Jun 2021 06:53:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3936ns02xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 06:53:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15A6rieP31130102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 06:53:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66BB5AE051;
        Thu, 10 Jun 2021 06:53:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BED54AE053;
        Thu, 10 Jun 2021 06:53:43 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.13.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 06:53:43 +0000 (GMT)
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
 <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
 <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
 <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a3754185-ad03-c20d-d3df-9ddfd0187c99@de.ibm.com>
Date:   Thu, 10 Jun 2021 08:53:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7b57ce79-6a17-70ac-4639-47a0df463e49@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d2yPKyqtH_-uvpCfYSewkVKVe2Ifw3Od
X-Proofpoint-ORIG-GUID: 1uBaAxvYHv7HwtGU5kMIO2iNMoRh2MET
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_03:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100041
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.06.21 08:22, Paolo Bonzini wrote:
> On 10/06/21 00:04, Oliver Upton wrote:
>>> Your approach still needs to use the "quirky" approach to host-initiated
>>> MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the
>>> VMCS offset.  This is just a documentation issue.
>>
>> My suggested ioctl for the vCPU will still exist, and it will still
>> affect the VMCS tsc offset, right? However, we need to do one of the
>> following:
>>
>> - Stash the guest's MSR_IA32_TSC_ADJUST value in the
>> kvm_system_counter_state structure. During
>> KVM_SET_SYSTEM_COUNTER_STATE, check to see if the field is valid. If
>> so, treat it as a dumb value (i.e. show it to the guest but don't fold
>> it into the offset).
> 
> Yes, it's already folded into the guestTSC-hostTSC offset that the caller provides.
> 
>> - Inform userspace that it must still migrate MSR_IA32_TSC_ADJUST, and
>> continue to our quirky behavior around host-initiated writes of the
>> MSR.
>>
>> This is why Maxim's spin migrated a value for IA32_TSC_ADJUST, right?
> 
> Yes, so that he could then remove (optionally) the quirk for host-initiated writes to the TSC and TSC_ADJUST MSRs.
> 
>> Doing so ensures we don't have any guest-observable consequences due
>> to our migration of TSC state. To me, adding the guest IA32_TSC_ADJUST
>> MSR into the new counter state structure is probably best. No strong
>> opinions in either direction on this point, though:)
> 
> Either is good for me, since documentation will be very important either way.  This is a complex API to use due to the possibility of skewed TSCs.
> 
> Just one thing, please don't introduce a new ioctl and use KVM_GET_DEVICE_ATTR/KVM_SET_DEVICE_ATTR/KVM_HAS_DEVICE_ATTR.
> 
> Christian, based on what Oliver mentions here, it's probably useful for s390 to have functionality to get/set kvm->arch.epoch and kvm->arch.epdx in addition to the absolute TOD values that you are migrating now.

Yes, a scheme where we migrate the offsets (assuming that the hosts are synced) would be often better.
If the hosts are not synced, things will be harder. I will have a look at this series, Thanks for the pointer.
