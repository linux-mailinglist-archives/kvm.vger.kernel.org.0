Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32A66827BE
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjAaIzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjAaIyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:54:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1564A20A
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 00:50:13 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30V6TtjW015174
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GO+RiA6QZjlk6a9RD+3C9jrUqRVuccFRan4BV8GHVjY=;
 b=qK1ilDqHoVUjfCCdcPhNYVhssF9s9JR+2qK7O1RXLuZYimopHHNnOBdLg6AUgF3Tgd6S
 e4tYrOnRC50Ele7UFeQyo4qFD3IE2rZYJgCUxklKhkWwfbN6ny0i3rJZUyQl80UH4PLW
 e9VdBDd1YGX6tvBRalQPy8o09oY0Mo/TtOz8DZXY+Gb6LKM4hSofBdRNurfK+brxtOdB
 j9Sg1+9z9oPxTkcAibF3E7flAcWAM6+YezJQkALo92oBzUO2BAjEx3/yPPpQh+wZ42aS
 1RbKbxfrD8+n6/0vLHsX59qUvqv3YtsK5USpSM9uqsD0bHIKJH4uy0DXpCeIOThLPkYJ pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3news7u7w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:49:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30V8ToUd032439
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:49:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3news7u7vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 08:49:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30UL4BUR013445;
        Tue, 31 Jan 2023 08:49:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtyb8cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 08:49:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30V8nR0819988830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 08:49:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7476520043;
        Tue, 31 Jan 2023 08:49:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06F4320040;
        Tue, 31 Jan 2023 08:49:27 +0000 (GMT)
Received: from [9.171.57.28] (unknown [9.171.57.28])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 31 Jan 2023 08:49:26 +0000 (GMT)
Message-ID: <76cfa756-c3f5-8ab1-584f-c864be720717@linux.ibm.com>
Date:   Tue, 31 Jan 2023 09:49:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x/Makefile: fix `*.gbin` target
 dependencies
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-4-mhartmay@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230119114045.34553-4-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y5cp9gTCoEIbK4tGxwzZms485X7HLf7u
X-Proofpoint-ORIG-GUID: XhSM_tyBiIHWdOKmX42wkfN9eZR8Chyr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_02,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/23 12:40, Marc Hartmayer wrote:
> If the linker scripts change, then the .gbin binaries must be rebuilt.
> While at it, replace `$(SRCDIR)/s390x/snippets` with `$(SNIPPET_DIR)`
> for these Makefile rules.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/Makefile | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 660ff06f1e7c..71e6563bbb61 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -135,13 +135,13 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>   $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>   
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>   	truncate -s '%4096' $@
>   
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
>   	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>   	truncate -s '%4096' $@
>   

