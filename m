Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B666049EE
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJSOyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 10:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiJSOx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 10:53:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B519133337
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 07:45:14 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JEgAQZ011784
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=X5dwilsk8vrd9S7kc0+j2rBOaTKEN/6exW3UFdWKVGk=;
 b=ilpQDvq5LB9UWbEQwCNBZJ2ALn7RQiqJl55EvBk2x4Nfeo/7YAFd/f9jeMeS/zvPaslO
 abqosPybr/CqsYx5IVwx4OZYDArhRZXfV35+xmhhbQfpGWm3yDaXSrpbDU4pXU2kL1SH
 vKNovwWvfUVvEcZEXf8MX56HtSW7XJpuI2iVelxKhyqEjpTwTej0uyCX9ZQlETSoCBEB
 r5SAEjdEuBLLiZgFHEIx1zHfCVbwULIwR0qWkGGVkXsynErVfootBXqWoe025J77qYqJ
 PGhfNjqM1wzprEtBVroit4/eYmGffG0dzqfnGJIl+r3fFm9ATQWKVsKI4czm1KXcckp9 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kak7w82yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:45:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JEg9VO011516
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:45:10 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kak7w82x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:45:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JEZdYl009054;
        Wed, 19 Oct 2022 14:45:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8wg0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 14:45:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JEj5D348103866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 14:45:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07B57A405C;
        Wed, 19 Oct 2022 14:45:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1974A4054;
        Wed, 19 Oct 2022 14:45:04 +0000 (GMT)
Received: from [9.171.2.98] (unknown [9.171.2.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 14:45:04 +0000 (GMT)
Message-ID: <162eaeed-0981-fbd5-1df0-2dff61abb927@linux.ibm.com>
Date:   Wed, 19 Oct 2022 16:45:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20221018111528.173989-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: do not enable PV dump support by
 default
In-Reply-To: <20221018111528.173989-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8u03v5uVtPqY2kmVqLKPENe-olqRnHFB
X-Proofpoint-ORIG-GUID: bymywnFrCD5Y_wPgqelLuG5aIYHqIMgB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_08,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 13:15, Nico Boehr wrote:
> Currently, dump support is always enabled by setting the respective
> plaintext control flag (PCF). Unfortunately, older machines without
> support for PV dump will not start the guest when this PCF is set. This
> will result in an error message like this:
> 
> qemu-system-s390x: KVM PV command 2 (KVM_PV_SET_SEC_PARMS) failed: header rc 106 rrc 30 IOCTL rc: -22
> 
> Hence, by default, disable dump support to preserve compatibility with
> older machines. Users can enable dumping support by passing
> --enable-dump to the configure script.
> 

The patch is fine, some nits below.

But I'm wondering when the core maintainers will start complaining about 
excessive argument usage. :)

> @@ -387,6 +397,7 @@ U32_LONG_FMT=$u32_long
>   WA_DIVIDE=$wa_divide
>   GENPROTIMG=${GENPROTIMG-genprotimg}
>   HOST_KEY_DOCUMENT=$host_key_document
> +CONFIG_DUMP=$enable_dump
>   CONFIG_EFI=$efi
>   CONFIG_WERROR=$werror
>   GEN_SE_HEADER=$gen_se_header
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 649486f2d4a0..5b4aff5e57ef 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -173,6 +173,11 @@ $(comm-key):
>   %.bin: %.elf
>   	$(OBJCOPY) -O binary  $< $@
>   
> +GENPROTIMG_COMM_KEY =

This should have a comment:
Will only be filled when dump has been enabled

> +# allow PCKMO
> +genprotimg_pcf = 0x000000e0
> +
> +ifeq ($(CONFIG_DUMP),yes)

I'd appreciate indents here

>   # The genprotimg arguments for the cck changed over time so we need to
>   # figure out which argument to use in order to set the cck
>   GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
> @@ -182,9 +187,11 @@ else
>   	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
>   endif
>   
> -# use x-pcf to be compatible with old genprotimg versions
>   # allow dumping + PCKMO
>   genprotimg_pcf = 0x200000e0
> +endif
> +
> +# use x-pcf to be compatible with old genprotimg versions
>   genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
>   
>   %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)

