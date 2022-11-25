Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5E063870C
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiKYKHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKYKHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:07:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B3B27FC8;
        Fri, 25 Nov 2022 02:07:19 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP9ig2G040098;
        Fri, 25 Nov 2022 10:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FuqcNtVIVN4EHIA2Dpxhvl8jpYZh+s2DgY6HhhPrh/0=;
 b=e5s1+tlAuY4hHG7xKUBQfN39UzdTYFVJ26g9PUWDCsTSTfWLIsJblMALpOaA4oGdcsMi
 W8jrhAmw/cs8j5X04jtBG/PrZx3NVp+EDAUT3lNr6WD5ZtvWr1TEr0+jCucBYAoEGxrg
 0nTEGVf0hdG6Cv6O7Xj5/PZ610BZVPZQMVZ0HJpdXo9aaAQYwSH4W+4pXtLXrB615zgu
 D1OeEbaDCzLcANue8tm0BZMDueR8SnT1FjZQNGiTULmv6nUYUKT2/EFo9LzFQSAjgd6q
 2nbOhohmIP/ytoCwbpO5oBnnF2HH49NH0nDQ/NnrtwOW5pRxz5rf7SL4MqPVQ5Q91Krh DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ubhgfwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 10:07:18 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APA16Ho014459;
        Fri, 25 Nov 2022 10:07:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ubhgfvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 10:07:18 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APA77sQ031177;
        Fri, 25 Nov 2022 10:07:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8prr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 10:07:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APA7sMJ24183116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 10:07:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F22BE42041;
        Fri, 25 Nov 2022 10:07:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F93B4203F;
        Fri, 25 Nov 2022 10:07:12 +0000 (GMT)
Received: from [9.171.63.115] (unknown [9.171.63.115])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 10:07:12 +0000 (GMT)
Message-ID: <76c9dbfe-a570-667d-37e9-8d1bc710b58f@linux.ibm.com>
Date:   Fri, 25 Nov 2022 11:07:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add a linker script to assembly
 snippets
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20221123084656.19864-1-frankja@linux.ibm.com>
 <20221123084656.19864-2-frankja@linux.ibm.com>
 <2803564dcc325f716548ea3a8938d8c0b7814a33.camel@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <2803564dcc325f716548ea3a8938d8c0b7814a33.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WDqXyYpPlPBeT5k9cE5DMl3jqri6SSXD
X-Proofpoint-GUID: Vv9oImV2gUlE0MketFukBJYxydeT9vq6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 21:42, Janis Schoetterl-Glausch wrote:
> On Wed, 2022-11-23 at 08:46 +0000, Janosch Frank wrote:
>> A linker script has a few benefits:
>> - Random data doesn't end up in the binary breaking tests
>> - We can easily define a lowcore and load the snippet from 0x0 instead
>> of 0x4000 which makes asm snippets behave like c snippets
>> - We can easily define an invalid PGM new PSW to ensure an exit on a
>> guest PGM
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/snippet.h         |  3 +--
>>   s390x/Makefile              |  5 +++--
>>   s390x/mvpg-sie.c            |  2 +-
>>   s390x/pv-diags.c            |  6 +++---
>>   s390x/snippets/asm/flat.lds | 43 +++++++++++++++++++++++++++++++++++++
>>   5 files changed, 51 insertions(+), 8 deletions(-)
>>   create mode 100644 s390x/snippets/asm/flat.lds
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> index b17b2a4c..57045994 100644
>> --- a/lib/s390x/snippet.h
>> +++ b/lib/s390x/snippet.h
>> @@ -32,8 +32,7 @@
>>
>>   #define SNIPPET_PV_TWEAK0	0x42UL
>>   #define SNIPPET_PV_TWEAK1	0UL
>> -#define SNIPPET_OFF_C		0
>> -#define SNIPPET_OFF_ASM		0x4000
>> +#define SNIPPET_UNPACK_OFF	0
> 
> You could also get rid of the offset parameter, couldn't you?

Right

>>
>>
>>   /*
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index bf1504f9..bb0f9eb8 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -135,7 +135,8 @@ $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>
>>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
>> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
>> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $(patsubst %.gbin,%.o,$@)
>> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> 
> I assume .bss=alloc allocates the bss in the binary...

And that's fine since I don't want to handle 0x3E PGMs/faults.

If bss is in the binary then it'll be made secure on initial image 
unpack, if it isn't, then we need a handler to import pages on a 0x3E. 
And I don't really want to do that since a 0x3E could also mean that we 
have an issue with the test or HW/FW.

> 
>>   	truncate -s '%4096' $@
>>
>>   $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>> @@ -144,7 +145,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>>   	truncate -s '%4096' $@
>>
>>   $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
>> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>>
>>   $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>>   	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>>
> [...]
> 
>> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
>> new file mode 100644
>> index 00000000..366d2d78
>> --- /dev/null
>> +++ b/s390x/snippets/asm/flat.lds
>> @@ -0,0 +1,43 @@
>> +SECTIONS
>> +{
>> +	.lowcore : {
>> +		/*
>> +		 * Initial short psw for disk boot, with 31 bit addressing for
>> +		 * non z/Arch environment compatibility and the instruction
>> +		 * address 0x4000.
>> +		 */
>> +		. = 0;
>> +		 LONG(0x00080000)
>> +		 LONG(0x80004000)
>> +		 /* Restart new PSW for booting via PSW restart. */
>> +		 . = 0x1a0;
>> +		 QUAD(0x0000000180000000)
>> +		 QUAD(0x0000000000004000)
>> +		 /*
>> +		  * Invalid PGM new PSW so we hopefully get a code 8
>> +		  * intercept on a PGM
>> +		  */
>> +		 . = 0x1d0;
>> +		 QUAD(0x0008000000000000)
>> +		 QUAD(0x0000000000000001)
>> +	}
>> +	. = 0x4000;
>> +	.text : {
>> +		*(.text)
>> +		*(.text.*)
>> +	}
>> +	. = ALIGN(64K);
>> +	etext = .;
>> +	. = ALIGN(16);
>> +	.data : {
>> +		*(.data)
>> +		*(.data.rel*)
>> +	}
>> +	. = ALIGN(16);
>> +	.rodata : { *(.rodata) *(.rodata.*) }
>> +	. = ALIGN(16);
>> +	__bss_start = .;
> 
> .. so the __bss symbols are not necessary.
> But then, the c flat.lds has them too.
>> +	.bss : { *(.bss) }
>> +	__bss_end = .;
>> +	. = ALIGN(64K);
>> +}
> 

