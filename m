Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C114E46E0
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 20:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiCVTqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 15:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiCVTqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 15:46:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647ED6250
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:44:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MJiBkV016532
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 19:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wLcERDmnRwrJu8aS9mjTFLFysAmMTkTiBCN1CTP1poY=;
 b=RABOPMBpx5Zui/UxSYiiKcku9AEuyOoKizCCBvYTGHlha/WPXPQhHkiGoY6YyM+IcBpd
 wnoRfzMILmWdGXEhx6mG8WMZFWvP7x8MLCknnWIc7m5qa6TAlvIxxVQ9303qhwLFBwD1
 +YonfEGLq9Jjwg+tdeCY+rteSL4EZBQijVx/1u2XZn5/5wFAQ8IFQZM0RIXcolLMA8HK
 mA9a3HVrn38CTMMvWwuRVbNNFDQDUEgLOjfKIBaM5pV8RyGvDeo2YEi/BPZOfF3D5pB/
 SFeZx69SZ6EJyGxGQtReB2lEd/KbUFCG/tkqTLofJMpjAJ/PwSyuFL3CP6ZbdO7a41is cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eymvhg06c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 19:44:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MJie4I020556
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 19:44:40 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eymvhg065-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 19:44:39 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MJhlnv025481;
        Tue, 22 Mar 2022 19:44:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8nxkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 19:44:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MJiZ9h50921878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 19:44:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB86D52050;
        Tue, 22 Mar 2022 19:44:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 551AC5204F;
        Tue, 22 Mar 2022 19:44:35 +0000 (GMT)
Date:   Tue, 22 Mar 2022 20:44:32 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] Allow to compile without -Werror
Message-ID: <20220322204432.524aaa4c@p-imbrenda>
In-Reply-To: <20220322171504.941686-1-thuth@redhat.com>
References: <20220322171504.941686-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rzLtX__h4p_N-mJAdR9gEPMCuJsIgaOS
X-Proofpoint-GUID: N-f_v_VfL3bQH2n4lS1f7aCLLau9TS_n
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_07,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=774 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Mar 2022 18:15:04 +0100
Thomas Huth <thuth@redhat.com> wrote:

> Newer compiler versions sometimes introduce new warnings - and compiling
> with -Werror will fail there, of course. Thus users of the kvm-unit-tests
> like the buildroot project have to disable the "-Werror" in the Makefile
> with an additional patch, which is cumbersome.
> Thus let's add a switch to the configure script that allows to explicitly
> turn the -Werror switch on or off. And enable it only by default for
> developer builds (i.e. in checked-out git repositories) ... and for
> tarball releases, it's nicer if it is disabled by default, so that the
> end users do not have to worry about this.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

makes sense

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  See also the patch from the buildroot project:
>  https://git.busybox.net/buildroot/tree/package/kvm-unit-tests/0001-Makefile-remove-Werror-to-avoid-build-failures.patch
> 
>  Makefile  |  2 +-
>  configure | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 24686dd..6ed5dea 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -62,7 +62,7 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>  
>  COMMON_CFLAGS += -g $(autodepend-flags) -fno-strict-aliasing -fno-common
>  COMMON_CFLAGS += -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> -COMMON_CFLAGS += -Wignored-qualifiers -Werror -Wno-missing-braces
> +COMMON_CFLAGS += -Wignored-qualifiers -Wno-missing-braces $(CONFIG_WERROR)
>  
>  frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>  fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> diff --git a/configure b/configure
> index c4fb4a2..86c3095 100755
> --- a/configure
> +++ b/configure
> @@ -31,6 +31,13 @@ page_size=
>  earlycon=
>  efi=
>  
> +# Enable -Werror by default for git repositories only (i.e. developer builds)
> +if [ -e "$srcdir"/.git ]; then
> +    werror=-Werror
> +else
> +    werror=
> +fi
> +
>  usage() {
>      cat <<-EOF
>  	Usage: $0 [options]
> @@ -75,6 +82,8 @@ usage() {
>  	                           Specify a PL011 compatible UART at address ADDR. Supported
>  	                           register stride is 32 bit only.
>  	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
> +	    --[enable|disable]-werror
> +	                           Select whether to compile with the -Werror compiler flag
>  EOF
>      exit 1
>  }
> @@ -148,6 +157,12 @@ while [[ "$1" = -* ]]; do
>  	--disable-efi)
>  	    efi=n
>  	    ;;
> +	--enable-werror)
> +	    werror=-Werror
> +	    ;;
> +	--disable-werror)
> +	    werror=
> +	    ;;
>  	--help)
>  	    usage
>  	    ;;
> @@ -371,6 +386,7 @@ WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
>  CONFIG_EFI=$efi
> +CONFIG_WERROR=$werror
>  GEN_SE_HEADER=$gen_se_header
>  EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then

