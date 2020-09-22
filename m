Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1890D27470D
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVQ5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:57:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgIVQ5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 12:57:51 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MGal9w170201;
        Tue, 22 Sep 2020 12:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IynCvLd1jIJZLfDQaEKMgt3CmHMxuUcagJiB0ZYpszE=;
 b=YmggHKmC3kCocOv6ugHJjMTUtybR4c5NqxrRilvmqivLT0BeplKnX/JpV72ZKkouuv0o
 jP/dErX6fNUAYuLklZb/q7NOUYpq7pF0rwLi987Aslud/Jrdb6YxLGkEakGEFz5R7wi+
 j/VU00fXitRHjBbdIlcnHX0gfRrwx0liwcnrmfiPJ4kaxecH7NnwK0Q4Q4p2xU7kWvPp
 gti2yIGx3QsSmmY2VgmjSsbn/HOXcWnVv9XV+FLqOTrxyJ5ZsnNFTzOlop9MitH/NC1s
 MhjvpVe111j0LiskKZ5eG5Vx/X1aWPIqhIeoqp2Xa9Bm2aYY8woe/iurDqWj3WSSIx+4 tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33qkyp2frf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 12:57:42 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08MGbFgQ171655;
        Tue, 22 Sep 2020 12:57:41 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33qkyp2fqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 12:57:41 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08MGs1xp014856;
        Tue, 22 Sep 2020 16:57:40 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 33n9m90e36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 16:57:40 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08MGvdR328377404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:57:39 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34903C6057;
        Tue, 22 Sep 2020 16:57:39 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D21B4C6055;
        Tue, 22 Sep 2020 16:57:37 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.16.144])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Sep 2020 16:57:37 +0000 (GMT)
Subject: Re: [PATCH v5 3/3] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks
 from is_virtfn
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, cohuck@redhat.com,
        kevin.tian@intel.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
 <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
 <08afc6b2-7549-5440-a947-af0b598288c2@linux.ibm.com>
 <20200922104030.07e0dfd9@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <852ca3a6-6521-a3c4-c70d-383be3c2dc2d@linux.ibm.com>
Date:   Tue, 22 Sep 2020 12:57:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922104030.07e0dfd9@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_16:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/20 12:40 PM, Alex Williamson wrote:
> On Mon, 21 Sep 2020 08:43:29 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 9/10/20 10:59 AM, Matthew Rosato wrote:
>>> While it is true that devices with is_virtfn=1 will have a Memory Space
>>> Enable bit that is hard-wired to 0, this is not the only case where we
>>> see this behavior -- For example some bare-metal hypervisors lack
>>> Memory Space Enable bit emulation for devices not setting is_virtfn
>>> (s390). Fix this by instead checking for the newly-added
>>> no_command_memory bit which directly denotes the need for
>>> PCI_COMMAND_MEMORY emulation in vfio.
>>>
>>> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>>
>> Polite ping on this patch as the other 2 have now received maintainer
>> ACKs or reviews.  I'm concerned about this popping up in distros as
>> abafbc551fdd was a CVE fix.  Related, see question from the cover:
>>
>> - Restored the fixes tag to patch 3 (but the other 2 patches are
>>     now pre-reqs -- cc stable 5.8?)
> 
> I've got these queued in my local branch which I'll push to next for
> v5.10.  I'm thinking that perhaps the right thing would be to add the
> fixes tag to all three patches, otherwise I could see that the PCI/VF
> change might get picked as a dependency, but not the s390 specific one.
> Does this sound correct to everyone?  Thanks,

Sounds good to me.  Thanks!
