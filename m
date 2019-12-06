Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23220115557
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 17:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLFQ3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 11:29:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49394 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726284AbfLFQ3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 11:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575649788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=nIc3QmX5OsicCoX5Sghs82Aa7hli4Q3q0hp16ZiCmqo=;
        b=WiAdFSZzZCRmOf9x2muoOcJb9HqSR+8OhXzM5awewGrO15lnBGmovNTz9co7v9YMssrjMM
        JWvknq4Zo98fGHrpGexfSv7W0qgzt6e36AU2V68tQzwVLCOH5Mrfasbv37XJ8udXNZHQIh
        X2YPVqFsPW4RwA590F2Artkpff6Hrg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-Pg5luO2KOFmotTd0Ri3bmQ-1; Fri, 06 Dec 2019 11:29:45 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDACE107ACC4;
        Fri,  6 Dec 2019 16:29:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 911B360BF4;
        Fri,  6 Dec 2019 16:29:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 2/9] s390x: Define the PSW bits
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
 <1575649588-6127-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4d034f27-0449-08ea-5b45-be91a788bd6d@redhat.com>
Date:   Fri, 6 Dec 2019 17:29:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1575649588-6127-3-git-send-email-pmorel@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: Pg5luO2KOFmotTd0Ri3bmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/2019 17.26, Pierre Morel wrote:
> Let's define the PSW bits explicitly, it will clarify their
> usage.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 127 +++++++++++++++++++++------------------
>  s390x/cstart64.S         |  13 ++--
>  2 files changed, 74 insertions(+), 66 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index cf6e1ca..1293640 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -10,20 +10,81 @@
>  #ifndef _ASM_S390X_ARCH_DEF_H_
>  #define _ASM_S390X_ARCH_DEF_H_
>  
> -struct psw {
> -	uint64_t	mask;
> -	uint64_t	addr;
> -};
> -
>  #define PSW_MASK_EXT			0x0100000000000000UL
>  #define PSW_MASK_DAT			0x0400000000000000UL
>  #define PSW_MASK_PSTATE			0x0001000000000000UL
> +#define PSW_MASK_IO			0x0200000000000000
> +#define PSW_MASK_EA			0x0000000100000000
> +#define PSW_MASK_BA			0x0000000080000000
> +
> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
>  
>  #define CR0_EXTM_SCLP			0X0000000000000200UL
>  #define CR0_EXTM_EXTC			0X0000000000002000UL
>  #define CR0_EXTM_EMGC			0X0000000000004000UL
>  #define CR0_EXTM_MASK			0X0000000000006200UL
>  
> +#define PGM_INT_CODE_OPERATION			0x01
> +#define PGM_INT_CODE_PRIVILEGED_OPERATION	0x02
> +#define PGM_INT_CODE_EXECUTE			0x03
> +#define PGM_INT_CODE_PROTECTION			0x04
> +#define PGM_INT_CODE_ADDRESSING			0x05
> +#define PGM_INT_CODE_SPECIFICATION		0x06
> +#define PGM_INT_CODE_DATA			0x07
> +#define PGM_INT_CODE_FIXED_POINT_OVERFLOW	0x08
> +#define PGM_INT_CODE_FIXED_POINT_DIVIDE		0x09
> +#define PGM_INT_CODE_DECIMAL_OVERFLOW		0x0a
> +#define PGM_INT_CODE_DECIMAL_DIVIDE		0x0b
> +#define PGM_INT_CODE_HFP_EXPONENT_OVERFLOW	0x0c
> +#define PGM_INT_CODE_HFP_EXPONENT_UNDERFLOW	0x0d
> +#define PGM_INT_CODE_HFP_SIGNIFICANCE		0x0e
> +#define PGM_INT_CODE_HFP_DIVIDE			0x0f
> +#define PGM_INT_CODE_SEGMENT_TRANSLATION	0x10
> +#define PGM_INT_CODE_PAGE_TRANSLATION		0x11
> +#define PGM_INT_CODE_TRANSLATION_SPEC		0x12
> +#define PGM_INT_CODE_SPECIAL_OPERATION		0x13
> +#define PGM_INT_CODE_OPERAND			0x15
> +#define PGM_INT_CODE_TRACE_TABLE		0x16
> +#define PGM_INT_CODE_VECTOR_PROCESSING		0x1b
> +#define PGM_INT_CODE_SPACE_SWITCH_EVENT		0x1c
> +#define PGM_INT_CODE_HFP_SQUARE_ROOT		0x1d
> +#define PGM_INT_CODE_PC_TRANSLATION_SPEC	0x1f
> +#define PGM_INT_CODE_AFX_TRANSLATION		0x20
> +#define PGM_INT_CODE_ASX_TRANSLATION		0x21
> +#define PGM_INT_CODE_LX_TRANSLATION		0x22
> +#define PGM_INT_CODE_EX_TRANSLATION		0x23
> +#define PGM_INT_CODE_PRIMARY_AUTHORITY		0x24
> +#define PGM_INT_CODE_SECONDARY_AUTHORITY	0x25
> +#define PGM_INT_CODE_LFX_TRANSLATION		0x26
> +#define PGM_INT_CODE_LSX_TRANSLATION		0x27
> +#define PGM_INT_CODE_ALET_SPECIFICATION		0x28
> +#define PGM_INT_CODE_ALEN_TRANSLATION		0x29
> +#define PGM_INT_CODE_ALE_SEQUENCE		0x2a
> +#define PGM_INT_CODE_ASTE_VALIDITY		0x2b
> +#define PGM_INT_CODE_ASTE_SEQUENCE		0x2c
> +#define PGM_INT_CODE_EXTENDED_AUTHORITY		0x2d
> +#define PGM_INT_CODE_LSTE_SEQUENCE		0x2e
> +#define PGM_INT_CODE_ASTE_INSTANCE		0x2f
> +#define PGM_INT_CODE_STACK_FULL			0x30
> +#define PGM_INT_CODE_STACK_EMPTY		0x31
> +#define PGM_INT_CODE_STACK_SPECIFICATION	0x32
> +#define PGM_INT_CODE_STACK_TYPE			0x33
> +#define PGM_INT_CODE_STACK_OPERATION		0x34
> +#define PGM_INT_CODE_ASCE_TYPE			0x38
> +#define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
> +#define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
> +#define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
> +#define PGM_INT_CODE_MONITOR_EVENT		0x40
> +#define PGM_INT_CODE_PER			0x80
> +#define PGM_INT_CODE_CRYPTO_OPERATION		0x119
> +#define PGM_INT_CODE_TX_ABORTED_EVENT		0x200
> +
> +#ifndef __ASSEMBLER__
> +struct psw {
> +	uint64_t	mask;
> +	uint64_t	addr;
> +};
> +
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
>  	uint32_t	ext_int_param;			/* 0x0080 */
> @@ -101,61 +162,6 @@ struct lowcore {
>  } __attribute__ ((__packed__));
>  _Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
>  
> -#define PGM_INT_CODE_OPERATION			0x01
> -#define PGM_INT_CODE_PRIVILEGED_OPERATION	0x02
> -#define PGM_INT_CODE_EXECUTE			0x03
> -#define PGM_INT_CODE_PROTECTION			0x04
> -#define PGM_INT_CODE_ADDRESSING			0x05
> -#define PGM_INT_CODE_SPECIFICATION		0x06
> -#define PGM_INT_CODE_DATA			0x07
> -#define PGM_INT_CODE_FIXED_POINT_OVERFLOW	0x08
> -#define PGM_INT_CODE_FIXED_POINT_DIVIDE		0x09
> -#define PGM_INT_CODE_DECIMAL_OVERFLOW		0x0a
> -#define PGM_INT_CODE_DECIMAL_DIVIDE		0x0b
> -#define PGM_INT_CODE_HFP_EXPONENT_OVERFLOW	0x0c
> -#define PGM_INT_CODE_HFP_EXPONENT_UNDERFLOW	0x0d
> -#define PGM_INT_CODE_HFP_SIGNIFICANCE		0x0e
> -#define PGM_INT_CODE_HFP_DIVIDE			0x0f
> -#define PGM_INT_CODE_SEGMENT_TRANSLATION	0x10
> -#define PGM_INT_CODE_PAGE_TRANSLATION		0x11
> -#define PGM_INT_CODE_TRANSLATION_SPEC		0x12
> -#define PGM_INT_CODE_SPECIAL_OPERATION		0x13
> -#define PGM_INT_CODE_OPERAND			0x15
> -#define PGM_INT_CODE_TRACE_TABLE		0x16
> -#define PGM_INT_CODE_VECTOR_PROCESSING		0x1b
> -#define PGM_INT_CODE_SPACE_SWITCH_EVENT		0x1c
> -#define PGM_INT_CODE_HFP_SQUARE_ROOT		0x1d
> -#define PGM_INT_CODE_PC_TRANSLATION_SPEC	0x1f
> -#define PGM_INT_CODE_AFX_TRANSLATION		0x20
> -#define PGM_INT_CODE_ASX_TRANSLATION		0x21
> -#define PGM_INT_CODE_LX_TRANSLATION		0x22
> -#define PGM_INT_CODE_EX_TRANSLATION		0x23
> -#define PGM_INT_CODE_PRIMARY_AUTHORITY		0x24
> -#define PGM_INT_CODE_SECONDARY_AUTHORITY	0x25
> -#define PGM_INT_CODE_LFX_TRANSLATION		0x26
> -#define PGM_INT_CODE_LSX_TRANSLATION		0x27
> -#define PGM_INT_CODE_ALET_SPECIFICATION		0x28
> -#define PGM_INT_CODE_ALEN_TRANSLATION		0x29
> -#define PGM_INT_CODE_ALE_SEQUENCE		0x2a
> -#define PGM_INT_CODE_ASTE_VALIDITY		0x2b
> -#define PGM_INT_CODE_ASTE_SEQUENCE		0x2c
> -#define PGM_INT_CODE_EXTENDED_AUTHORITY		0x2d
> -#define PGM_INT_CODE_LSTE_SEQUENCE		0x2e
> -#define PGM_INT_CODE_ASTE_INSTANCE		0x2f
> -#define PGM_INT_CODE_STACK_FULL			0x30
> -#define PGM_INT_CODE_STACK_EMPTY		0x31
> -#define PGM_INT_CODE_STACK_SPECIFICATION	0x32
> -#define PGM_INT_CODE_STACK_TYPE			0x33
> -#define PGM_INT_CODE_STACK_OPERATION		0x34
> -#define PGM_INT_CODE_ASCE_TYPE			0x38
> -#define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
> -#define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
> -#define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
> -#define PGM_INT_CODE_MONITOR_EVENT		0x40
> -#define PGM_INT_CODE_PER			0x80
> -#define PGM_INT_CODE_CRYPTO_OPERATION		0x119
> -#define PGM_INT_CODE_TX_ABORTED_EVENT		0x200

This patch definitely does more than you've mentioned in the patch
description. Please avoid the movement of the PGM definitions here and
move that into a separate patch (if it is really necessary).

 Thomas

