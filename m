Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8412F59F4D8
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 10:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbiHXIP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 04:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiHXIPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 04:15:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2C27E019
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 01:15:48 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O86h6r011755
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:15:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R8Y9aRcwmpuUTQSoCU3Ttz+cbbJDMZMgSR+aBNZJ/7I=;
 b=KibKAOvH3t5WINQ/VnBjR36HKheNlg7VJIZepnWTbhin3zlfwbavgZMO4Zy9rPpBZSXn
 LyLvk1zAqGJrhlcB12cllghoBSIxiiHIEoTHJxtWw1lPzuoBqx65aDA+y3bbFMCeK8Hx
 n1fsxUFVrLviyMN+nkcmBvFmmaiZIzWIlZksFgpKWlaAEIP4nVbZEMj/frTbLmqvvMxX
 2LuSTq29jF86zl1yTtZdIuNwwfoibAdu17gJSsuziq5vsAMPbos5Jwm0vn1iALT8yBNA
 pvrXPMgJIjfhgPXpjPcQMYYWir1r2WGEQpJywj91A8yE4jUh5fEnJuVe0DE6J2JyQOGj jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5fxpgn3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:15:47 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27O87cbm016164
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:15:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5fxpgn23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 08:15:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27O84vWt020237;
        Wed, 24 Aug 2022 08:15:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3j2q88uj9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 08:15:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27O8FfVE28836350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 08:15:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA502AE051;
        Wed, 24 Aug 2022 08:15:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83211AE056;
        Wed, 24 Aug 2022 08:15:41 +0000 (GMT)
Received: from [9.145.53.141] (unknown [9.145.53.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Aug 2022 08:15:41 +0000 (GMT)
Message-ID: <f57717ee-f178-7592-418d-e05e05ebe333@linux.ibm.com>
Date:   Wed, 24 Aug 2022 10:15:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220721132647.552298-1-nrb@linux.ibm.com>
 <20220721132647.552298-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: create persistent comm-key
In-Reply-To: <20220721132647.552298-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5ezYB16B_h22ghiT7XBp7e4zv-HxVRuf
X-Proofpoint-ORIG-GUID: SAqtw8ZIo9cHP-_ToXOe5L1d1eNokEC7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/21/22 15:26, Nico Boehr wrote:
> To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
> now, no comm-key was provided to genprotimg, therefore decrypting the
> dump of a kvm-unit-test under PV was not possible.
> 
> This patch makes sure that we create a random CCK if there's no
> $(TEST_DIR)/comm.key file.
> 
> Also allow dumping of PV tests by passing the appropriate PCF to
> genprotimg (bit 34). --x-pcf is used to be compatible with older
> genprotimg versions, which don't support --enable-dump. 0xe0 is the
> default PCF value and only bit 34 is added.
> 
> Unfortunately, recent versions of genprotimg removed the --x-comm-key
> argument which was used by older versions to specify the CCK. To support
> these versions, we need to parse the genprotimg help output and decide
> which argument to use.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile | 21 +++++++++++++++++----
>   1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 34de233d09b8..5e3cb5a47bc2 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -162,14 +162,27 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>   	$(RM) $(@:.elf=.aux.o)
>   	@chmod a-x $@
>   

Add comment along the lines of:
Secure Execution Customer Communication Key file
32 bytes of key material, uses existing one if available

> +comm-key = $(TEST_DIR)/comm.key
> +$(comm-key):
> +	dd if=/dev/urandom of=$@ bs=32 count=1 status=none
> +
>   %.bin: %.elf
>   	$(OBJCOPY) -O binary  $< $@
>   
> -genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
> -%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
> +GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
> +ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> +	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
> +else
> +	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
> +endif
> +# use x-pcf to be compatible with old genprotimg versions
> +# allow dumping + PCKMO
> +genprotimg_pcf = 0x200000e0
> +genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)

\n
We might need to fix that in patch #1.

> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
>   	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
>   
> -%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>   	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
>   
>   $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
> @@ -177,7 +190,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>   
>   
>   arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
>   
>   generated-files = $(asm-offsets)
>   $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)

