Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F072655C1A6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiF1K73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345125AbiF1K71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:59:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2725593
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 03:59:26 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAhrnq007602;
        Tue, 28 Jun 2022 10:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mQQRMRN7haOEkE3iOHqBBfmUNmw/CG99nkzUiDKe8dM=;
 b=IkwsXfnJSJpOdN/S6A8t3AZbN5KHfTZD/Via3LBp8QN+PudR2vRz9wuxMOoAYaO8+hxK
 UvP41nu2kA/UPmpKDjdcpIYHvFTGlWAGcRvl/kX41BcgEfLAGcPmM1IeE9W9qBJD18Mp
 paFbADR20wjSFEzptUrZr6IcwHXufNgvJ48gcPo019zkNmWzi4vpT18t1yohxjcZOb6s
 oqPWzrnk0ZnMbR+aphq0ZvfIj4tAMGX0OXD540w6fdHet88BobZmpY7Z7w32cD8AF6DW
 0t3qOdSvgwGJ2aUGPmqH5Oia+c3HcDP8Lc13JidnJJUdl07aYdVEPzg+OnDw1Tb9UVL5 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0055089j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:59:20 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SAsZ4p010388;
        Tue, 28 Jun 2022 10:59:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0055088p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:59:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SAqtQk027675;
        Tue, 28 Jun 2022 10:59:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3gwt08vpr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:59:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SAxDYu22217042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 10:59:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2BBFAE051;
        Tue, 28 Jun 2022 10:59:13 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6C4AE04D;
        Tue, 28 Jun 2022 10:59:12 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 10:59:12 +0000 (GMT)
Message-ID: <5a6a8daf-6bac-9c97-4faa-488aa4a27b26@linux.ibm.com>
Date:   Tue, 28 Jun 2022 13:03:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v8 03/12] s390x/cpu_topology: implementating Store
 Topology System Information
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
 <20220620140352.39398-4-pmorel@linux.ibm.com>
 <17ed3c2d-b2ef-0716-039e-527db996da73@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <17ed3c2d-b2ef-0716-039e-527db996da73@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w88itZMiDBDso8OVTtNKtuiqYf5gEO6S
X-Proofpoint-ORIG-GUID: uo9ESHSMINWSfwyvIWwReJW1TfQr8tJx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_05,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=924 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/27/22 16:26, Janosch Frank wrote:
> On 6/20/22 16:03, Pierre Morel wrote:
> 
> s390x/cpu_topology: Add STSI function code 15 handling

OK

> 
>> The handling of STSI is enhanced with the interception of the
>> function code 15 for storing CPU topology.
> 
> s/interception/handling/

OK

> 
>>
>> Using the objects built during the plugging of CPU, we build the
>> SYSIB 15_1_x structures.
>>
>> With this patch the maximum MNEST level is 2, this is also
>> the only level allowed and only SYSIB 15_1_2 will be built.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
>> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
>> +{
>> +    const MachineState *machine = MACHINE(qdev_get_machine());
>> +    void *p;
>> +    int ret;
>> +
>> +    /*
>> +     * Until the SCLP STSI Facility reporting the MNEST value is used,
>> +     * a sel2 value of 2 is the only value allowed in STSI 15.1.x.
>> +     */
>> +    if (sel2 != 2) {
>> +        setcc(cpu, 3);
>> +        return;
>> +    }
>> +
>> +    p = g_malloc0(TARGET_PAGE_SIZE);
>> +
>> +    setup_stsi(machine, p, 2);
>> +
>> +    if (s390_is_pv()) {
>> +        ret = s390_cpu_pv_mem_write(cpu, 0, p, TARGET_PAGE_SIZE);
>> +    } else {
>> +        ret = s390_cpu_virt_mem_write(cpu, addr, ar, p, 
>> TARGET_PAGE_SIZE);
>> +    }
> 
> For later reference:
> FCs over 3 are rejected by SIE for PV guests via cc 3.
> 
> I currently don't know if and when that will be changed but I'll ask 
> around.

Yes, thanks, I forgot to change that, will do.


-- 
Pierre Morel
IBM Lab Boeblingen
