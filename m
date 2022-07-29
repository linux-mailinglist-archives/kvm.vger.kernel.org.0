Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B2458510E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 15:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiG2Nq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 09:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiG2NqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 09:46:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BDE237C9
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 06:46:24 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TDX86r036097
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 13:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Izr/7dwJbsddu1CJJDsXBg/LeRsWurJORLdJHFfkAgU=;
 b=HKyq0EbbyeE+w5stuqElHwJpl0LCpMmx6s27eiUxUNm6cs4J0PCfIxvbj14kOZLTQauI
 n0IMZ9sUeBkuu+esKGc6vn7jEgfa6elSNxR8TDwjlBpIcncJu6UBXebVdOU1QV8BUT8I
 C48aSHg8pg1nBo3oDjmFB+hTOddaEe4IEH21GDaiVaP/VNkzh0nyeQMUQfoD6NcZoLHT
 K4vXWAuMv2gbKzujQHb3mdvX+4TBHAmCAVGyS5aBAv0bbTyACCTEiElNDRazPQ8GXjEH
 cfxmoYyyCF0fLdAvCeX6HhpxkF52eSeZnLfZ1nJYtX3fJ5LLg2u8hpvkKnjq4AQGoP8e Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmghkrk09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 13:46:23 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26TDXI8f036402
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 13:46:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmghkrjyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 13:46:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26TDZUdV026924;
        Fri, 29 Jul 2022 13:46:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3hg96wqpty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 13:46:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26TDkHn232178548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 13:46:17 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EB45A405F;
        Fri, 29 Jul 2022 13:46:17 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F98DA405B;
        Fri, 29 Jul 2022 13:46:17 +0000 (GMT)
Received: from [9.145.174.114] (unknown [9.145.174.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jul 2022 13:46:17 +0000 (GMT)
Message-ID: <feafe1bc-8703-359e-9a5b-f4693b7650e1@linux.ibm.com>
Date:   Fri, 29 Jul 2022 15:46:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: MAKEFILE: Use $< instead of
 pathsubst
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20220729082633.277240-1-frankja@linux.ibm.com>
 <20220729082633.277240-3-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220729082633.277240-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u7Iyx48UU_xqBa7BbzqKPbW-c05tCahY
X-Proofpoint-GUID: BGQEuHlAnI3fO6yGhuunxq7Z9PF4REAS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_15,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/29/22 10:26, Janosch Frank wrote:
> No need to mangle strings if we already have the value at hand.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c1..ee34a1d7 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -134,7 +134,7 @@ $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
>   	truncate -s '%4096' $@
>   
>   $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_lib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>   	truncate -s '%4096' $@
>   
