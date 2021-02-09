Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D93031538F
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhBIQPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:15:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231491AbhBIQPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 11:15:02 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119FXVJv095955;
        Tue, 9 Feb 2021 11:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4QLnUsL1S/Pq1PHmA7NAn6OqkDqt1IxQm/UznxZQl0Y=;
 b=N0sodiIEFBLNnefo4H5TKsyANfTiuN3EiwbtxRBZbTgwMluTU13w8+H6itx4OH1orWz6
 bdDHIZ3KnRFxKm2M+qBx0J3n6pj4gZfzBzIpTxQ5SHngW2XscgD3WiImFs/yAPrHA+aQ
 t2xXN4PDwakE5551h1JA2sl7uVWRO+AuiLmZCJx/K9WwNQVeqZuC2pICY5ikaoy8PLjP
 G1aprGrfEWwrxFnXOWMJLbUH/a4WGZCThl30NzrfcB/X0pOZQBkjkRw+55NPDDrbKjvh
 xoh8mdUnGmBv2GUN4hun7K4TOSl6Jl2Te6Xtx2LEj4UpxcPQLasn2MnGkSsg9K2QFK/C 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kw4t9tsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:14:21 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119FXr2o097440;
        Tue, 9 Feb 2021 11:14:21 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kw4t9tqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 11:14:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119FamUt004943;
        Tue, 9 Feb 2021 16:14:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wjsnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 16:14:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119GEGpU45416706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 16:14:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E3B34C046;
        Tue,  9 Feb 2021 16:14:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F0A34C040;
        Tue,  9 Feb 2021 16:14:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.63.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 16:14:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com
References: <20210209141554.22554-1-frankja@linux.ibm.com>
 <20210209170804.75d1fc9d@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <a361e674-fa78-8c06-0583-29f8989d5493@linux.ibm.com>
Date:   Tue, 9 Feb 2021 17:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209170804.75d1fc9d@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 5:08 PM, Claudio Imbrenda wrote:
> On Tue,  9 Feb 2021 09:15:54 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> KVM and QEMU handle a SIGP stop and store status in two steps:
>> 1) Stop the CPU by injecting a stop request
>> 2) Store when the CPU has left SIE because of the stop request
>>
>> The problem is that the SIGP order is already considered completed by
>> KVM/QEMU when step 1 has been performed and not once both have
>> completed. In addition we currently don't implement the busy CC so a
>> kernel has no way of knowing that the store has finished other than
>> checking the location for the store.
>>
>> This workaround is based on the fact that for a new SIE entry (via the
>> added smp restart) a stop with the store status has to be finished
>> first.
>>
>> Correct handling of this in KVM/QEMU will need some thought and time.
> 
> do I understand correctly that you are here "fixing" the test by not
> triggering the KVM bug? Shouldn't we try to trigger as many bugs as
> possible instead?

This is not a bug, it's missing code :-)

We trigger a higher number of bugs by running tests and this workaround
does exactly that by letting Thomas use the smp test in the CI again.

> 
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/smp.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index b0ece491..32f284a2 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -102,12 +102,15 @@ static void test_stop_store_status(void)
>>  	lc->grs_sa[15] = 0;
>>  	smp_cpu_stop_store_status(1);
>>  	mb();
>> +	report(smp_cpu_stopped(1), "cpu stopped");
>> +	/* For the cpu to be started it should have finished storing
>> */
>> +	smp_cpu_restart(1);
>>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore,
>> "prefix"); report(lc->grs_sa[15], "stack");
>> -	report(smp_cpu_stopped(1), "cpu stopped");
>>  	report_prefix_pop();
>>  
>>  	report_prefix_push("stopped");
>> +	smp_cpu_stop(1);
>>  	lc->prefix_sa = 0;
>>  	lc->grs_sa[15] = 0;
>>  	smp_cpu_stop_store_status(1);
> 

