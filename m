Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED15851BD
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiG2OmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 10:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbiG2OmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 10:42:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94BE7E02E
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 07:42:18 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TET5d5005288
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wnDkoWUX47a5xvciNr7aNe7p3wgp2v+IaouOhXS8umU=;
 b=BKcaV3h/qlxdqq1LaDMAaFfmXLRY2OjJBlWLdZwlJLF5TWslbPvBArJkzWbp5r6ZXlxS
 Vi6g4PJ9WqEBQoCljxwR7kzHlaYZ5xg9ILU8HEKAbH6iyzOheYr/gX19GguwD7XEyHH9
 cy20KLla7nG0Ya1e/4x2ZGIk3vVCUCZ/w1SVfae4L6OhpRTpz0QAxrQESAR0Ff4z5sgX
 Q/Pk/5esYk58PpgD+W/SWg58cwHydeaLshJbu3WIDrbRvtfpqBSHbchZqEZQ7NQlKBmh
 1wvBXIi4synEqqOdFozU2FuLM6ejTVE3jIikT7TCneYio+ndr1RSFqvQ+xH+YFGdtA+8 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmhbmghwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:42:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26TETqAV009878
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 14:42:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmhbmghvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 14:42:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26TEZlqV010327;
        Fri, 29 Jul 2022 14:42:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3hg96wqrrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 14:42:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26TEgCTW28901722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 14:42:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C8974C046;
        Fri, 29 Jul 2022 14:42:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79C784C044;
        Fri, 29 Jul 2022 14:42:11 +0000 (GMT)
Received: from [9.145.172.194] (unknown [9.145.172.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jul 2022 14:42:11 +0000 (GMT)
Message-ID: <49f5c56c-9f02-eeba-82c9-465851f11fc4@linux.ibm.com>
Date:   Fri, 29 Jul 2022 16:42:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH 3/6] s390x: Add a linker script to assembly
 snippets
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20220729082633.277240-1-frankja@linux.ibm.com>
 <20220729082633.277240-4-frankja@linux.ibm.com>
 <d10f6eee-cfe0-5e93-79aa-f91d32b8b807@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <d10f6eee-cfe0-5e93-79aa-f91d32b8b807@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZSA5RGwFf_MjgLEx5Fim9xkiOj5kNQoE
X-Proofpoint-GUID: mF4lyjzNFtBYmZJfDonekVoUNAa_5QdR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_16,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/22 16:17, Steffen Eiden wrote:
> 
> 
> On 7/29/22 10:26, Janosch Frank wrote:
>> A linker script has a few benefits:
>> - We can easily define a lowcore and load the snippet from 0x0 instead
>> of 0x4000 which makes asm snippets behave like c snippets
>> - We can easily define an invalid PGM new PSW to ensure an exit on a
>> guest PGM
>>
>> As we gain another step and file extension by linking, a comment
>> explains which file extensions are generated and why.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    lib/s390x/snippet.h |  3 +--
>>    s390x/Makefile      | 16 +++++++++++++---
>>    s390x/mvpg-sie.c    |  2 +-
>>    s390x/pv-diags.c    |  6 +++---
>>    4 files changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
>> index b17b2a4c..57045994 100644
>> --- a/lib/s390x/snippet.h
>> +++ b/lib/s390x/snippet.h
>> @@ -32,8 +32,7 @@
>>    
>>    #define SNIPPET_PV_TWEAK0	0x42UL
>>    #define SNIPPET_PV_TWEAK1	0UL
>> -#define SNIPPET_OFF_C		0
>> -#define SNIPPET_OFF_ASM		0x4000
>> +#define SNIPPET_UNPACK_OFF	0
>>    
>>    
>>    /*
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ee34a1d7..9a0b48e2 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -122,6 +122,13 @@ else
>>    snippet-hdr-obj =
>>    endif
>>    
>> +# Each snippet will generate the following files (in order): \
>> +  *.o is a snippet that has been compiled \
>> +  *.ol is a snippet that has been linked \
>> +  *.gbin is a snippet that has been converted to binary \
>> +  *.gobj is the final format after converting the binary into a elf file again, \
>> +  it will be linked into the tests
>> +
>>    # the asm/c snippets %.o have additional generated files as dependencies
>>    $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>>    	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>> @@ -129,8 +136,11 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>>    $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>>    	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>>    
>> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
>> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
>> +$(SNIPPET_DIR)/asm/%.ol: $(SNIPPET_DIR)/asm/%.o
>> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $<
> 
> I think you forgot to include that linker script in the patch.
> Or did I miss anything?
> 
> you can also use the $(SNIPPET_DIR) variable instead of searching for
> that directory yourself.

Right on both cases, I'll fix that...

> 
>> +
>> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.ol
>> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
>>    	truncate -s '%4096' $@
>>    
>>    $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>> @@ -139,7 +149,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>>    	truncate -s '%4096' $@
>>    
>>    $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
>> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>>    
>>    $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>>    	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>> index 46a2edb6..99f4859b 100644
>> --- a/s390x/mvpg-sie.c
>> +++ b/s390x/mvpg-sie.c
>> @@ -87,7 +87,7 @@ static void setup_guest(void)
>>    
>>    	snippet_setup_guest(&vm, false);
>>    	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
>> -		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
>> +		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_UNPACK_OFF);
>>    
>>    	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>>    	vm.sblk->eca = ECA_MVPGI;
>> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
>> index 9ced68c7..5165937a 100644
>> --- a/s390x/pv-diags.c
>> +++ b/s390x/pv-diags.c
>> @@ -28,7 +28,7 @@ static void test_diag_500(void)
>>    
>>    	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
>>    			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
>> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
>> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>>    
>>    	sie(&vm);
>>    	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
>> @@ -83,7 +83,7 @@ static void test_diag_288(void)
>>    
>>    	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
>>    			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
>> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
>> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>>    
>>    	sie(&vm);
>>    	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
>> @@ -124,7 +124,7 @@ static void test_diag_yield(void)
>>    
>>    	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
>>    			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
>> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
>> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>>    
>>    	/* 0x44 */
>>    	report_prefix_push("0x44");
> 
> Steffen Eiden

