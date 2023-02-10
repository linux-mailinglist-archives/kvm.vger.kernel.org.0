Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9ED6920ED
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 15:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjBJOih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 09:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjBJOif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 09:38:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25EE6D63C;
        Fri, 10 Feb 2023 06:38:34 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AEbMaV012608;
        Fri, 10 Feb 2023 14:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XrT+KuNWmkkXvTa+9RSZSy+g52C8qMz0KYpCuF/oho8=;
 b=Dcw8AZZBAcn5cpYt2NFlhoVOpAwgXq3CmjBe4foUfrHmGH91HdQ0rhqcF2Fkqz2ojkT2
 F47LrlbFg2auNUdUSONZSZoEdQ3MW30q0+e23jUIJguuofOWhzpIBW8foQcz5fol6pjI
 jHBuVfYR4IbFXggjGy1T+WNb9RcqhAUJD8u4/OPfuLDUg2g+dZEnxgwhntiequU3Amoa
 ymxmHa5rNAn8E2kXlbVi8QSyPLzeZmEfd+yaKwn/US/Baxp+c18yDOYlEMODHUpV+yQK
 VValXthyNtbhHZ6DfxOV/IuMTsbiSZEE9iqiqM+Szxh274f/tdUqk+Iwsb7mLaWc0hP9 DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqunr1w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:38:34 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31AEbm7Y015005;
        Fri, 10 Feb 2023 14:38:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nnqunr1tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:38:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31A7V3nN001926;
        Fri, 10 Feb 2023 14:38:31 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06qm2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 14:38:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31AEcRrB39059788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:38:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D27DC20040;
        Fri, 10 Feb 2023 14:38:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AE742004D;
        Fri, 10 Feb 2023 14:38:27 +0000 (GMT)
Received: from [9.171.75.239] (unknown [9.171.75.239])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Feb 2023 14:38:27 +0000 (GMT)
Message-ID: <75fecce1-f2e8-5d11-78a3-e311a23c49cb@linux.ibm.com>
Date:   Fri, 10 Feb 2023 15:38:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
 <20230202092814.151081-2-pmorel@linux.ibm.com>
 <3a38ca69-ac0a-ce75-4add-256c5996d89c@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <3a38ca69-ac0a-ce75-4add-256c5996d89c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DLkT-EC_Wn7r5WthHkoxBS2OD-ia83x2
X-Proofpoint-ORIG-GUID: evbmV-mAgzTPhLdu8opnE5lF4-F1CT92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_09,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100120
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/23 12:06, Thomas Huth wrote:
> On 02/02/2023 10.28, Pierre Morel wrote:
>> We check that the PTF instruction is working correctly when
>> the cpu topology facility is available.
>>
>> For KVM only, we test changing of the polarity between horizontal
>> and vertical and that a reset set the horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |   1 +
>>   s390x/topology.c    | 155 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   3 +
>>   3 files changed, 159 insertions(+)
>>   create mode 100644 s390x/topology.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 52a9d82..b5fe8a3 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>>   tests += $(TEST_DIR)/migration-sck.elf
>>   tests += $(TEST_DIR)/exittime.elf
>> +tests += $(TEST_DIR)/topology.elf
>>   pv-tests += $(TEST_DIR)/pv-diags.elf
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 0000000..20f7ba2
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,155 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright IBM Corp. 2022
>> + *
>> + * Authors:
>> + *  Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <smp.h>
>> +#include <sclp.h>
>> +#include <s390x/hardware.h>
>> +
>> +#define PTF_REQ_HORIZONTAL    0
>> +#define PTF_REQ_VERTICAL    1
>> +#define PTF_REQ_CHECK        2
>> +
>> +#define PTF_ERR_NO_REASON    0
>> +#define PTF_ERR_ALRDY_POLARIZED    1
>> +#define PTF_ERR_IN_PROGRESS    2
>> +
>> +extern int diag308_load_reset(u64);
>> +
>> +static int ptf(unsigned long fc, unsigned long *rc)
>> +{
>> +    int cc;
>> +
>> +    asm volatile(
>> +        "       .insn   rre,0xb9a20000,%1,0\n"
> 
> Why are you specifying the instruction manually? I think both, GCC and 
> Clang should know the "ptf" mnemonic, shouldn't they?

:D right !

> 
>> +        "       ipm     %0\n"
>> +        "       srl     %0,28\n"
>> +        : "=d" (cc), "+d" (fc)
>> +        :
>> +        : "cc");
>> +
>> +    *rc = fc >> 8;
>> +    return cc;
>> +}
>> +
>> +static void test_ptf(void)
>> +{
>> +    unsigned long rc;
>> +    int cc;
>> +
>> +    /* PTF is a privilege instruction */
> 
> s/privilege/privileged/ ?

Yes, thanks

> 
>> +    report_prefix_push("Privilege");
>> +    enter_pstate();
>> +    expect_pgm_int();
>> +    ptf(PTF_REQ_CHECK, &rc);
>> +    check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +    report_prefix_pop();
>> +
>> +    report_prefix_push("Wrong fc");
>> +    expect_pgm_int();
>> +    ptf(0xff, &rc);
>> +    check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +    report_prefix_pop();
>> +
>> +    report_prefix_push("Reserved bits");
>> +    expect_pgm_int();
>> +    ptf(0xffffffffffffff00UL, &rc);
>> +    check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +    report_prefix_pop();
> 
> This function is quite big ... I'd maybe group the above checks for 
> error conditions into a separate function instead.

OK

> 
>> +    report_prefix_push("Topology Report pending");
>> +    /*
>> +     * At this moment the topology may already have changed
>> +     * since the VM has been started.
>> +     * However, we can test if a second PTF instruction
>> +     * reports that the topology did not change since the
>> +     * preceding PFT instruction.
>> +     */
>> +    ptf(PTF_REQ_CHECK, &rc);
>> +    cc = ptf(PTF_REQ_CHECK, &rc);
>> +    report(cc == 0, "PTF check should clear topology report");
>> +    report_prefix_pop();
>> +
>> +    report_prefix_push("Topology polarisation check");
>> +    /*
>> +     * We can not assume the state of the polarization for
> 
> s/can not/cannot/ ?

OK

> 
> Also, you sometimes write polarization with "z" and sometimes with "s". 
> I'd suggest to standardize on "z" (as in "IBM Z" ;-))

OK

> 
>> +     * any Virtual Machine but KVM.
>> +     * Let's skip the polarisation tests for other VMs.
>> +     */
>> +    if (!host_is_kvm()) {
>> +        report_skip("Topology polarisation check is done for KVM only");
>> +        goto end;
>> +    }
>> +
>> +    /*
>> +     * Set vertical polarization to verify that RESET sets
>> +     * horizontal polarization back.
>> +     */
>> +    cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +    report(cc == 0, "Set vertical polarization.");
>> +
>> +    report(diag308_load_reset(1), "load normal reset done");
>> +
>> +    cc = ptf(PTF_REQ_CHECK, &rc);
>> +    report(cc == 0, "Reset should clear topology report");
>> +
>> +    cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +    report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
>> +           "After RESET polarization is horizontal");
>> +
>> +    /* Flip between vertical and horizontal polarization */
>> +    cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +    report(cc == 0, "Change to vertical polarization.");
>> +
>> +    cc = ptf(PTF_REQ_CHECK, &rc);
>> +    report(cc == 1, "Polarization change should set topology report");
>> +
>> +    cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +    report(cc == 0, "Change to horizontal polarization.");
>> +
>> +end:
>> +    report_prefix_pop();
>> +}
> 
> Apart from the nits, the patch looks fine to me.
> 
>   Thomas
> 

Thanks,

Regards.
Pierre





-- 
Pierre Morel
IBM Lab Boeblingen
