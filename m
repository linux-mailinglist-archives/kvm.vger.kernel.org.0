Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D772152684
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 07:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgBEG75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 01:59:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39862 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725875AbgBEG75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 01:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580885996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hYxn+TZ+GWZTapSVdci7dCjR0/5CAIfwE1rclB+espE=;
        b=UFpVjxOx7T6OcBUi10imiuWe672Re24dkG8PAa48Cvcp/wxX4QmpFsKj7FN1LNtc6Lq32S
        IS3A96z6TLY25FZA5Da79IMcg/oShzCOQSt2MuIoKzIgulCVCfq5py56kEDbugTyKYW9OD
        UxNlJ8VK+TeG7WWsXgsRf3VZSBF424o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-ZWF_7CHqO9SbX23RjyjmEg-1; Wed, 05 Feb 2020 01:59:52 -0500
X-MC-Unique: ZWF_7CHqO9SbX23RjyjmEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B60E1081FA2;
        Wed,  5 Feb 2020 06:59:51 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F2587B0B;
        Wed,  5 Feb 2020 06:59:46 +0000 (UTC)
Subject: Re: [RFCv2 14/37] KVM: s390: protvirt: Add interruption injection
 controls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-15-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aa5c40bf-2fa9-f52a-716a-518756caf02a@redhat.com>
Date:   Wed, 5 Feb 2020 07:59:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-15-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> Define the interruption injection codes and the related fields in the
> sie control block for PVM interruption injection.

You seem to only add the details for external interrupts and I/O
interrupts here? Maybe mention this in the description ... otherwise it
is confusing when you read patch 17 later ... or maybe merge this patch
here with patch 17 ?

> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 58845b315be0..a45d10d87a8a 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
>  	__u8	icptcode;		/* 0x0050 */
>  	__u8	icptstatus;		/* 0x0051 */
>  	__u16	ihcpu;			/* 0x0052 */
> -	__u8	reserved54[2];		/* 0x0054 */
> +	__u8	reserved54;		/* 0x0054 */
> +#define IICTL_CODE_NONE		 0x00
> +#define IICTL_CODE_MCHK		 0x01
> +#define IICTL_CODE_EXT		 0x02
> +#define IICTL_CODE_IO		 0x03
> +#define IICTL_CODE_RESTART	 0x04
> +#define IICTL_CODE_SPECIFICATION 0x10
> +#define IICTL_CODE_OPERAND	 0x11
> +	__u8	iictl;			/* 0x0055 */
>  	__u16	ipa;			/* 0x0056 */
>  	__u32	ipb;			/* 0x0058 */
>  	__u32	scaoh;			/* 0x005c */
> @@ -259,7 +267,8 @@ struct kvm_s390_sie_block {
>  #define HPID_KVM	0x4
>  #define HPID_VSIE	0x5
>  	__u8	hpid;			/* 0x00b8 */
> -	__u8	reservedb9[11];		/* 0x00b9 */
> +	__u8	reservedb9[7];		/* 0x00b9 */
> +	__u32	eiparams;		/* 0x00c0 */
>  	__u16	extcpuaddr;		/* 0x00c4 */
>  	__u16	eic;			/* 0x00c6 */
>  	__u32	reservedc8;		/* 0x00c8 */
> @@ -275,8 +284,16 @@ struct kvm_s390_sie_block {
>  	__u8	oai;			/* 0x00e2 */
>  	__u8	armid;			/* 0x00e3 */
>  	__u8	reservede4[4];		/* 0x00e4 */
> -	__u64	tecmc;			/* 0x00e8 */
> -	__u8	reservedf0[12];		/* 0x00f0 */
> +	union {
> +		__u64	tecmc;		/* 0x00e8 */
> +		struct {
> +			__u16	subchannel_id;	/* 0x00e8 */
> +			__u16	subchannel_nr;	/* 0x00ea */
> +			__u32	io_int_parm;	/* 0x00ec */
> +			__u32	io_int_word;	/* 0x00f0 */
> +		};
> +	} __packed;
> +	__u8	reservedf4[8];		/* 0x00f4 */

Maybe add a comment to the new struct for which injection type it is
good for ... otherwise this might get hard to understand in the future
(especially if more stuff gets added like in patch 17).

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>

