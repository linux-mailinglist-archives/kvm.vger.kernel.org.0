Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A38FC3BE
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 11:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKNKMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 05:12:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfKNKMG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 05:12:06 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEAARP1085378
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 05:12:05 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w92uk4xm6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 05:12:00 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 10:11:50 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 10:11:46 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEABkPJ51904612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 10:11:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A20152050;
        Thu, 14 Nov 2019 10:11:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C569852063;
        Thu, 14 Nov 2019 10:11:45 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-2-git-send-email-pmorel@linux.ibm.com>
 <7f40bf69-6e34-7613-1ab5-83e09464c0b0@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 11:11:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <7f40bf69-6e34-7613-1ab5-83e09464c0b0@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111410-0028-0000-0000-000003B6CC6F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111410-0029-0000-0000-00002479D8B8
Message-Id: <c7d6c21e-3746-b31a-aff9-d19549feb24c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=698 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-13 17:12, Janosch Frank wrote:
> On 11/13/19 1:23 PM, Pierre Morel wrote:
>> If we use multiple source of interrupts, for exemple, using SCLP console
>> to print information while using I/O interrupts or during exceptions, we
>> need to have a re-entrant register saving interruption handling.
>>
>> Instead of saving at a static place, let's save the base registers on
>> the stack.
>>
>> Note that we keep the static register saving that we need for the RESET
>> tests.
>>
>> We also care to give the handlers a pointer to the save registers in
>> case the handler needs it (fixup_pgm_int needs the old psw address).
> So you're still ignoring the FPRs...
> I disassembled a test and looked at all stds and it looks like printf
> and related functions use them. Wouldn't we overwrite test FPRs if
> printing in a handler?

If printf uses the FPRs in my opinion we should modify the compilation 
options for the library.

What is the reason for printf and related functions to use floating point?

I will have a deeper look at this.


Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen

