Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAAE4010F8
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 19:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhIEREy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 13:04:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238199AbhIEREo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 13:04:44 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 185GdqTm118436;
        Sun, 5 Sep 2021 13:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SyOmsZOQuVEYepmGvakJZek96LAjGvjZQFtfenL/cDE=;
 b=iRbyi9DR/FtEuYmPY/0whO0xC7/G3sDrkvgWyKo/uMYDtGhG8do+wM85w9XkS8XnfDe8
 /ben3BK6/56eOIQNuBdqLs6dR9sS3B3rftTPLFR3fOl1EuMFLRsKXqNenpTTNVkVrJA9
 pq/U+HxEa22kAQbObSEJrB/a4mVdBcVVomZBbzJVezE7hlj5PDcvv6N0hXGRBE6pu+UE
 t4lHWmBB1sDCGVVmEOyNY9E+u3wsUi1PpzWR/qUg3lbOuMVdRqRRGJp0OQY0q9e+VfWS
 +bqMqecafkVCjLHg6wsNoB2bjpeRX3uk5lAgWskUq7ei0ZmYwnGUYBHx9rLZi82dOGQH EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aw0k59022-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 13:03:30 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 185H1EFG182980;
        Sun, 5 Sep 2021 13:03:30 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aw0k5901w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 13:03:30 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 185GvtZj011000;
        Sun, 5 Sep 2021 17:03:29 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3av0e92709-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 17:03:29 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 185H3R1O17105156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Sep 2021 17:03:27 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B48D5C6065;
        Sun,  5 Sep 2021 17:03:27 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D220FC6063;
        Sun,  5 Sep 2021 17:03:23 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  5 Sep 2021 17:03:23 +0000 (GMT)
Subject: Re: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-5-michael.roth@amd.com>
 <7a35c637-eecc-7897-048d-994aeb128549@linux.ibm.com>
 <7590b96e-49ec-849e-93cc-fc0346a3bada@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <f85107a8-ca12-7e93-da74-9a7a67ebc1a7@linux.ibm.com>
Date:   Sun, 5 Sep 2021 20:03:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <7590b96e-49ec-849e-93cc-fc0346a3bada@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aPKSAbq0lCPFa262086QdD6GI1HKGWFX
X-Proofpoint-ORIG-GUID: PSrzOv1gAAWX-XeW6qklxkY5qxQ8CMFO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-05_01:2021-09-03,2021-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109050117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/09/2021 17:05, Brijesh Singh wrote:
> 
> On 9/5/21 4:19 AM, Dov Murik wrote:
>>
>> On 27/08/2021 1:26, Michael Roth wrote:
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
>>> the platform. The command checks whether SNP is enabled in the KVM, if
>>> enabled then it allocates a new ASID from the SNP pool and calls the
>>> firmware to initialize the all the resources.
>>>
>>
>> From the KVM code ("[PATCH Part2 v5 24/45] KVM: SVM: Add
>> KVM_SEV_SNP_LAUNCH_START command") it seems that KVM_SNP_INIT does *not*
>> allocate the ASID; actually this is done in KVM_SEV_SNP_LAUNCH_START.
> 
> Actually, the KVM_SNP_INIT does allocate the ASID. If you look at the
> driver code then in switch state, the SNP_INIT fallthrough to SEV_INIT
> which will call sev_guest_init(). The sev_guest_init() allocates a new
> ASID.
> https://github.com/AMDESE/linux/blob/bb9ba49cd9b749d5551aae295c091d8757153dd7/arch/x86/kvm/svm/sev.c#L255
> 
> The LAUNCH_START simply binds the ASID to a guest.

OK thank you for clearing this up.  So the kernel is choosing the new
ASID during the KVM_SNP_INIT ioctl, but doesn't "tell" the firmware
about it.  Then later in SNP_LAUNCH_START that integer (saved in the
kernel sev structure) is given to the firmware as an argument of the
SNP_LAUNCH_START (binding?).  Is this description correct?


-Dov
