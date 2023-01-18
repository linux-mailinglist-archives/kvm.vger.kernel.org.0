Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB88A6716BE
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 09:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjARI7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 03:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjARI63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 03:58:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27DE46156
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 00:14:29 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I7JRDH013019
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3UotOH9w/CBAif72CzQ3Yp+4szjvzVoEIwUbgvx0fis=;
 b=P1NDUhmOCTdl2j3VJ8XHyjqW1/ODfANA6Dcr77amOAdrWxyO0HxBsQbSrz6QZKK6WjU+
 obtQM2bXy3nbL3FhaCg4POiJcCO2Y2q7s++ItZMowYG8m3R2ZB0MOXx/Kib83vOJIbmM
 eG/NTs99S+CuOiq6V2mWuVYSMMzl0TPZKJvBYe5LktLgQeLRqII3Jr4D1vk1Rz+DczJw
 RQu2z5noSu/2xdIeu8IZV0mfvdPI/cMCTehFY36XYfCwPWPvMxWEVCdlJ6n649Hr8F+c
 Nd8T+lZP8ewq1A8jcJnUZHQaAzxXpqRHTHkLpgXC+zAtGAeKMXBa1FoGsaCFpEwz465/ Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6c9ds2qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:14:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I7eTtd020668
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:14:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6c9ds2pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:14:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30HMZ3kI009485;
        Wed, 18 Jan 2023 08:14:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfmxx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 08:14:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30I8EN2021955088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 08:14:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 327A02004E;
        Wed, 18 Jan 2023 08:14:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF07320040;
        Wed, 18 Jan 2023 08:14:22 +0000 (GMT)
Received: from [9.171.68.162] (unknown [9.171.68.162])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 08:14:22 +0000 (GMT)
Message-ID: <f6a8c256-7fe9-f2a4-f495-6ae7c1456eaf@linux.ibm.com>
Date:   Wed, 18 Jan 2023 09:14:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [kvm-unit-tests PATCH 2/9] s390x/Makefile: simplify `%.hdr`
 target rules
Content-Language: en-US
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-3-mhartmay@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230116175757.71059-3-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZCLnmlGrUFIDyKuWN2_RVmaZJuBqsvKh
X-Proofpoint-ORIG-GUID: u6Fu6vNEfJthUZIeLNCgnhOO36ObdCcU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_03,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/23 18:57, Marc Hartmayer wrote:
> Merge the two Makefile target rules `$(SNIPPET_DIR)/asm/%.hdr` and
> `$(SNIPPET_DIR)/c/%.hdr` into one target rule.

Should have thought of that myself after adding the linker script for 
assembly snippets...


Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>   s390x/Makefile | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a616111680..660ff06f1e7c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -145,10 +145,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>   	truncate -s '%4096' $@
>   
> -$(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> -
> -$(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
> +%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
>   	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>   
>   .SECONDARY:

