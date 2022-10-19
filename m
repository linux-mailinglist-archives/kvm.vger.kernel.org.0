Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7987F604B23
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJSPWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 11:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiJSPVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 11:21:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCF916EA15
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 08:15:08 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JFC3Aa007762
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=A7lZ+1vWeDfOIetqwHJ3h+FKFmxX/cMyKq+91s9zMQg=;
 b=GXO8HRPG5oUaINVeYrQNK5k8iB1cUBJJh8xUfVz+4ajA0dxwHZhh2ckmaNTHEqtTWPzV
 7iF0E71yLtc1bRNZJU4GpG9EbdwOaidyrOrcrFQYLYxSbf3SKebDm4+P/PXbapOhgoKP
 OS54L/BRH9gBTmnippnYQaT5kC/hL1vf7SDHF1YMNfpsSWhIGSbywVB100y0IDMenNM2
 u5A9s+jBuL38b6c6UXu58ZK/9xcae8HtnfXbUIoEiXyrNrLY4GiHJZRrW/6FS5c45q4m
 EXq8o//CXlkJ+r3fOA7k4IrhKMZnhh4+e+aRbPfGMWnmUPbRw6c0czPJRzVa5yPiczs3 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kaknx84t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:14:07 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JFC4KU007932
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:14:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kaknx84r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:14:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JF9O5q029677;
        Wed, 19 Oct 2022 15:14:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg97d8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 15:14:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JF917K45023512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 15:09:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EDD1AE055;
        Wed, 19 Oct 2022 15:14:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 104A1AE053;
        Wed, 19 Oct 2022 15:14:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 15:14:00 +0000 (GMT)
Date:   Wed, 19 Oct 2022 17:13:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: do not enable PV dump
 support by default
Message-ID: <20221019171359.2b1db783@p-imbrenda>
In-Reply-To: <20221019145320.1228710-2-nrb@linux.ibm.com>
References: <20221019145320.1228710-1-nrb@linux.ibm.com>
        <20221019145320.1228710-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MUqvm3AArJtMnCYH2E2SgshmghmMPn2i
X-Proofpoint-GUID: g14TKRjLE3WqgEFb40RLyT7JWb_qV0yD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_09,2022-10-19_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 16:53:20 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Currently, dump support is always enabled by setting the respective
> plaintext control flag (PCF). Unfortunately, older machines without
> support for PV dump will not start the guest when this PCF is set. This
> will result in an error message like this:
> 
> qemu-system-s390x: KVM PV command 2 (KVM_PV_SET_SEC_PARMS) failed: header rc 106 rrc 0 IOCTL rc: -22
> 
> Hence, by default, disable dump support to preserve compatibility with
> older machines. Users can enable dumping support by passing
> --enable-dump to the configure script.
> 
> Fixes: 3043685825d9 ("s390x: create persistent comm-key")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  configure      | 11 +++++++++++
>  s390x/Makefile | 26 +++++++++++++++++---------
>  2 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/configure b/configure
> index 5b7daac3c6e8..b81f20942c9c 100755
> --- a/configure
> +++ b/configure
> @@ -28,6 +28,7 @@ errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
>  gen_se_header=
> +enable_dump=no
>  page_size=
>  earlycon=
>  efi=
> @@ -67,6 +68,9 @@ usage() {
>  	    --gen-se-header=GEN_SE_HEADER
>  	                           Provide an executable to generate a PV header
>  	                           requires --host-key-document. (s390x-snippets only)
> +	    --[enable|disable]-dump
> +	                           Allow PV guests to be dumped. Requires at least z16.
> +	                           (s390x only)
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
>  	                           64k, default is 64k, arm64 only)
> @@ -146,6 +150,12 @@ while [[ "$1" = -* ]]; do
>  	--gen-se-header)
>  	    gen_se_header="$arg"
>  	    ;;
> +	--enable-dump)
> +	    enable_dump=yes
> +	    ;;
> +	--disable-dump)
> +	    enable_dump=no
> +	    ;;
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> @@ -387,6 +397,7 @@ U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
> +CONFIG_DUMP=$enable_dump
>  CONFIG_EFI=$efi
>  CONFIG_WERROR=$werror
>  GEN_SE_HEADER=$gen_se_header
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 649486f2d4a0..271b6803a1c5 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -173,18 +173,26 @@ $(comm-key):
>  %.bin: %.elf
>  	$(OBJCOPY) -O binary  $< $@
>  
> -# The genprotimg arguments for the cck changed over time so we need to
> -# figure out which argument to use in order to set the cck
> -GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
> -ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> -	GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
> -else
> -	GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
> +# Will only be filled when dump has been enabled
> +GENPROTIMG_COMM_KEY =
> +# allow PCKMO
> +genprotimg_pcf = 0x000000e0
> +
> +ifeq ($(CONFIG_DUMP),yes)
> +	# The genprotimg arguments for the cck changed over time so we need to
> +	# figure out which argument to use in order to set the cck
> +	GENPROTIMG_HAS_COMM_KEY = $(shell $(GENPROTIMG) --help | grep -q -- --comm-key && echo yes)
> +	ifeq ($(GENPROTIMG_HAS_COMM_KEY),yes)
> +		GENPROTIMG_COMM_KEY = --comm-key $(comm-key)
> +	else
> +		GENPROTIMG_COMM_KEY = --x-comm-key $(comm-key)
> +	endif
> +
> +	# allow dumping + PCKMO
> +	genprotimg_pcf = 0x200000e0
>  endif
>  
>  # use x-pcf to be compatible with old genprotimg versions
> -# allow dumping + PCKMO
> -genprotimg_pcf = 0x200000e0
>  genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify $(GENPROTIMG_COMM_KEY) --x-pcf $(genprotimg_pcf)
>  
>  %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@) $(comm-key)

