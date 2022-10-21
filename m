Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885316072A2
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 10:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiJUIlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 04:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJUIls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 04:41:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632A724F179
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 01:41:44 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L87GUc029036
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B0z9eEsq+PqglQXdE2dtYL5eRHca1A0hEYzTTrpFeq0=;
 b=EmRCetnf5oddqrTSNAkODjw7H+UGvyU6TDAiB/F+tnB9dqNOLXah546xR5uUWIeCQkV+
 1bkc4OZq/CzLRvRpC+X6+zfNRh3+inzb1Dx/h+SQ6e5rCrX43jqM/ZGfZhdncBEHyHTA
 pSP5qBSM+tHpA/gtq/lsxUX7/dgLXTMOG6ftKT3XY0GA7z6++mE+xq1PpXrl0Xkpp2Cy
 uaE06FNgAHcEmCNc1bHgm3TP12HXkc2lYQGtXY+riY29cRrSvAjjnHKTmjtX6Bt97g8L
 HkYql8sBNz8eP1jFZh99nbckpKZb7jRZT45oEsUrp6K1xYv+VjtJStWaJOwC25ul706F aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbq6tsy94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:41:42 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L87Heb029097
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:41:42 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbq6tsy8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 08:41:42 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L8a5RZ032339;
        Fri, 21 Oct 2022 08:41:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg97nwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 08:41:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L8faE466912614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 08:41:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79E3042045;
        Fri, 21 Oct 2022 08:41:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F67242042;
        Fri, 21 Oct 2022 08:41:36 +0000 (GMT)
Received: from [9.171.11.206] (unknown [9.171.11.206])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 08:41:36 +0000 (GMT)
Message-ID: <999c3833-d10c-18da-4319-ed150e9c71fa@linux.ibm.com>
Date:   Fri, 21 Oct 2022 10:41:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v3 0/6] s390x: PV fixups
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
References: <20221021063902.10878-1-frankja@linux.ibm.com>
 <20221021094628.79239c86@p-imbrenda>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221021094628.79239c86@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UECy7yQbHUHu4g8PEOETfVBWjGgcm8ZW
X-Proofpoint-ORIG-GUID: uf3a4AFxyA2dogdEUt7gXIb730XELUuV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/22 09:46, Claudio Imbrenda wrote:
> On Fri, 21 Oct 2022 06:38:56 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> A small set of patches that clean up the PV snippet handling.
>>
>> v3:
>> 	* Dropped asm snippet linker script patch for now
> 
> shame, I really liked that patch (modulo the nits)

You'll see it again soonish with another fix series.
There are still a lot of patches that I need to upstream. :)

> 
>> 	* Replaced memalign_pages_flags() with memalign_pages()
>> 	* PV ASCEs will now recieve DT and TL fields from the main test ASCE
>>
>> v2:
>> 	* Macro uses 64bit PSW mask
>> 	* SBLK reset on PV destroy and uv_init() early return have been split off
>>
>>
>> Janosch Frank (6):
>>    s390x: snippets: asm: Add a macro to write an exception PSW
>>    s390x: MAKEFILE: Use $< instead of pathsubst
>>    lib: s390x: sie: Improve validity handling and make it vm specific
>>    lib: s390x: Use a new asce for each PV guest
>>    lib: s390x: Enable reusability of VMs that were in PV mode
>>    lib: s390x: sie: Properly populate SCA
>>
>>   lib/s390x/asm-offsets.c                  |  2 ++
>>   lib/s390x/sie.c                          | 37 +++++++++++++-------
>>   lib/s390x/sie.h                          | 43 ++++++++++++++++++++++--
>>   lib/s390x/uv.c                           | 35 +++++++++++++++++--
>>   lib/s390x/uv.h                           |  5 ++-
>>   s390x/Makefile                           |  2 +-
>>   s390x/cpu.S                              |  6 ++++
>>   s390x/snippets/asm/macros.S              | 28 +++++++++++++++
>>   s390x/snippets/asm/snippet-pv-diag-288.S |  4 +--
>>   s390x/snippets/asm/snippet-pv-diag-500.S |  6 ++--
>>   10 files changed, 140 insertions(+), 28 deletions(-)
>>   create mode 100644 s390x/snippets/asm/macros.S
>>
> 

