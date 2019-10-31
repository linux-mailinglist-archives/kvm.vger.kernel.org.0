Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEAEEB8A0
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 21:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfJaU5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 16:57:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727511AbfJaU5K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 16:57:10 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VKusHl074300
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 16:57:09 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w06kj0w5u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 16:57:08 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 31 Oct 2019 20:57:07 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 20:57:05 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VKv3Qo40436022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 20:57:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC3CA4055;
        Thu, 31 Oct 2019 20:57:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3C8EA405E;
        Thu, 31 Oct 2019 20:57:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.145.205])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 20:57:02 +0000 (GMT)
Subject: Re: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-10-frankja@linux.ibm.com>
 <b76ae1ca-d211-d1c7-63d9-9b45c789f261@redhat.com>
 <7465141c-27b7-a89e-f02d-ab05cdd8505d@de.ibm.com>
 <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Date:   Thu, 31 Oct 2019 21:57:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <4abdc1dc-884e-a819-2e9d-2b8b15030394@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19103120-0028-0000-0000-000003B1949C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103120-0029-0000-0000-00002473E050
Message-Id: <2a7c4644-d718-420a-9bd7-723baccfb302@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310202
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/31/19 6:30 PM, David Hildenbrand wrote:
> On 31.10.19 16:41, Christian Borntraeger wrote:
>>
>>
>> On 25.10.19 10:49, David Hildenbrand wrote:
>>> On 24.10.19 13:40, Janosch Frank wrote:
>>>> From: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>>
>>>> Pin the guest pages when they are first accessed, instead of all at
>>>> the same time when starting the guest.
>>>
>>> Please explain why you do stuff. Why do we have to pin the hole guest memory? Why can't we mlock() the hole memory to avoid swapping in user space?
>>
>> Basically we pin the guest for the same reason as AMD did it for their SEV. It is hard
> 
> Pinning all guest memory is very ugly. What you want is "don't page", 
> what you get is unmovable pages all over the place. I was hoping that 
> you could get around this by having an automatic back-and-forth 
> conversion in place (due to the special new exceptions).

Yes, that's one of the ideas that have been circulating.

> 
>> to synchronize page import/export with the I/O for paging. For example you can actually
>> fault in a page that is currently under paging I/O. What do you do? import (so that the
>> guest can run) or export (so that the I/O will work). As this turned out to be harder then
>> we though we decided to defer paging to a later point in time.
> 
> I don't quite see the issue yet. If you page out, the page will 
> automatically (on access) be converted to !secure/encrypted memory. If 
> the UV/guest wants to access it, it will be automatically converted to 
> secure/unencrypted memory. If you have concurrent access, it will be 
> converted back and forth until one party is done.

IO does not trigger an export on an imported page, but an error
condition in the IO subsystem. The page code does not read pages through
the cpu, but often just asks the device to read directly and that's
where everything goes wrong. We could bounce swapping, but chose to pin
for now until we find a proper solution to that problem which nicely
integrates into linux.

> 
> A proper automatic conversion should make this work. What am I missing?
> 
>>
>> As we do not want to rely on the userspace to do the mlock this is now done in the kernel.
> 
> I wonder if we could come up with an alternative (similar to how we 
> override VM_MERGEABLE in the kernel) that can be called and ensured in 
> the kernel. E.g., marking whole VMAs as "don't page" (I remember 
> something like "special VMAs" like used for VDSOs that achieve exactly 
> that, but I am absolutely no expert on that). That would be much nicer 
> than pinning all pages and remembering what you pinned in huge page 
> arrays ...

It might be more worthwhile to just accept one or two releases with
pinning and fix the root of the problem than design a nice stopgap.

Btw. s390 is not alone with the problem and we'll try to have another
discussion tomorrow with AMD to find a solution which works for more
than one architecture.


