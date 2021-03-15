Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF59733C34A
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhCORFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:05:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233278AbhCORF0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:05:26 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FH4Ghm036913;
        Mon, 15 Mar 2021 13:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CWnQIsW5EkBHkWpMJg4WytVjClsy5FDTnDem8szIcyU=;
 b=enQGRh0ph6RsWPQVoAeT/bQvs5zALNb6j7df/RqWSfPzttr32ViHIBBjaAGDCU7cxj2f
 XXdb4FRAW/IoRUs3Jbx+u3h58AyxtqVG+wL7MzkdNqHxWKUEKSY00Z/JZIUYYNkvDiQe
 2gi/kdRTVOjRlL0iO8cypF+OhdTMFrjr9cG21EUC9Pyattj3u6coHWdlQjHbJYVollwN
 a0PF52IyeiW4Q0n1Qz11iAhfHMnvu9CUEtAgtnqqR0WUyVdAk2LeQ4v/6gTxCt2UdQFm
 CIy3so/xXQDJUmnO97YyCWW+WJt99SwzBMsrT1CFdqXss7/V3es0zO+oBnRJ4k1jvxta YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37aag5tftw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 13:05:22 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12FH4KRe037143;
        Mon, 15 Mar 2021 13:05:21 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37aag5tftd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 13:05:21 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12FH30dR006788;
        Mon, 15 Mar 2021 17:05:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 37a3gc3wp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 17:05:20 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12FH5IQI26935684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 17:05:18 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DD8DBE058;
        Mon, 15 Mar 2021 17:05:18 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A075BE053;
        Mon, 15 Mar 2021 17:05:17 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.85.181.215])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Mar 2021 17:05:16 +0000 (GMT)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Paolo Bonzini <pbonzini@redhat.com>, natet@google.com
Cc:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com, rientjes@google.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>
References: <20210224085915.28751-1-natet@google.com>
 <7829472d-741c-1057-c61f-321fcfb5bdcd@linux.ibm.com>
 <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <adb84c91-1651-94b6-0084-f86296e96530@linux.ibm.com>
Date:   Mon, 15 Mar 2021 13:05:16 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <35dde628-f1a8-c3bf-9c7d-7789166b0ee1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_08:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1015 spamscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150115
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/21 11:29 AM, Paolo Bonzini wrote:

> On 11/03/21 16:30, Tobin Feldman-Fitzthum wrote:
>> I am not sure how the mirror VM will be supported in QEMU. Usually 
>> there is one QEMU process per-vm. Now we would need to run a second 
>> VM and communicate with it during migration. Is there a way to do 
>> this without adding significant complexity?
>
> I can answer this part.  I think this will actually be simpler than 
> with auxiliary vCPUs.  There will be a separate pair of VM+vCPU file 
> descriptors within the same QEMU process, and some code to set up the 
> memory map using KVM_SET_USER_MEMORY_REGION.
>
> However, the code to run this VM will be very small as the VM does not 
> have to do MMIO, interrupts, live migration (of itself), etc.  It just 
> starts up and communicates with QEMU using a mailbox at a 
> predetermined address.

We've been starting up our Migration Handler via OVMF. I'm not sure if 
this would work with a minimal setup in QEMU.

-Tobin

>
> I also think (but I'm not 100% sure) that the auxiliary VM does not 
> have to watch changes in the primary VM's memory map (e.g. mapping and 
> unmapping of BARs).  In QEMU terms, the auxiliary VM's memory map 
> tracks RAMBlocks, not MemoryRegions, which makes things much simpler.
>
> There are already many examples of mini VMMs running special purpose 
> VMs in the kernel's tools/testing/selftests/kvm directory, and I don't 
> think the QEMU code would be any more complex than that.
>
> Paolo
>
