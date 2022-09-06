Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35535AE4CC
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 11:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbiIFJvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 05:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbiIFJuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 05:50:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC578F05
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 02:50:53 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2868hP1H019719
        for <kvm@vger.kernel.org>; Tue, 6 Sep 2022 09:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OxdsBMSJwSi2H4wwSXVfQNWUeqcBLlSA7cfyzktudSQ=;
 b=HYgPpnwYI7R8NBKTMLwuTOk4a3m8ahVxa16hV7594F2iYEbKVcnCs044bVdH6ZpRt/2G
 JYmSjMqFS6v0xXrCmmpVsvEyKI4so86CTDp23ih/cK76BMAq8CADyuHja7UY9ceMsGvf
 iCebOjXSOC/jAnBF+dQCCXzhjVDND0mJH4rqzV0BsK5vAL7WNJrcUBZU9seJK17ULdtU
 zhrhHgYfYnYx8YdTHMQdleTIp45ut1+zzTzKIWlBFFVNfyOoi2KnpOG8gDOrQ6hBb+/o
 JTI8ixEAYcgXujJGRc4eozlIJy0Vdqr13+QkHkXKYslaML8jXiLTmCP1xvSv+o6YiMgs QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je2xn2r2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 09:50:52 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2868hnxC020414
        for <kvm@vger.kernel.org>; Tue, 6 Sep 2022 09:50:52 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je2xn2r1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 09:50:52 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2869dFIA005448;
        Tue, 6 Sep 2022 09:50:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3jbxj8tmtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 09:50:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2869olPI41943460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 09:50:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5D0642045;
        Tue,  6 Sep 2022 09:50:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAB9742041;
        Tue,  6 Sep 2022 09:50:46 +0000 (GMT)
Received: from [9.145.171.109] (unknown [9.145.171.109])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 09:50:46 +0000 (GMT)
Message-ID: <d12c0927-fa06-4f27-606e-25971d11e2aa@linux.ibm.com>
Date:   Tue, 6 Sep 2022 11:50:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220825131600.115920-1-nrb@linux.ibm.com>
 <20220825131600.115920-3-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: create persistent comm-key
In-Reply-To: <20220825131600.115920-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xx4XabvFXxuuexpQVxmD70rwag3N7oSy
X-Proofpoint-GUID: 2gG6i9VVoOzpw2U_e277PPEIJFWrt-qu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_05,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060045
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 15:16, Nico Boehr wrote:
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

There are three minor issues that keep me from picking this

> ---
>   s390x/Makefile | 23 +++++++++++++++++++----
>   1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index d17055ebe6a8..4e268f47b6ab 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -162,15 +162,30 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>   	$(RM) $(@:.elf=.aux.o)
>   	@chmod a-x $@
>   
> +# Secure Execution Customer Communication Key file
> +# 32 bytes of key material, uses existing one if available
> +comm-key = $(TEST_DIR)/comm.key
> +$(comm-key):
> +	dd if=/dev/urandom of=$@ bs=32 count=1 status=none
> +
>   %.bin: %.elf
>   	$(OBJCOPY) -O binary  $< $@
>   
> -genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify

Add comment:


# The genprotimg arguments for the cck changed over time so we need to 
figure out which argument to use in order to set the cck

> +GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
> +ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> +	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
> +else
> +	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
> +endif

I'd like to have a \n here as well

> +# use x-pcf to be compatible with old genprotimg versions
> +# allow dumping + PCKMO
> +genprotimg_pcf = 0x200000e0
> +genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
>   
> -%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
> +%selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)
>   	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
>   
> -%.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> +%.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>   	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
>   
>   $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
> @@ -178,7 +193,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>   
>   
>   arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)

Hmmmmmmm(TM)

My first thought was that I'd be pretty angry if the CCK changes on a 
distclean. But the only scenario where this would matter is when the 
tests are provided to another system.

I'm still a bit torn about deleting the CCK especially as there will 
always be a CCK in the SE header no matter if we specify one or not.

>   
>   generated-files = $(asm-offsets)
>   $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)

