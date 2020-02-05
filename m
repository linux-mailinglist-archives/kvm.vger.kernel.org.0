Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21ED1526A1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 08:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgBEHG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 02:06:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50923 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725875AbgBEHG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 02:06:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580886384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=5afOL9u9C+ZF0zoh2gFGa8M/BmEu50lS+WX6Xd2co1Q=;
        b=JW+Sfqsv/8ks5K6xVvpYk5ToXKf00eXe/LXjxpeBsc8/7pHdzqBviqhR8pkbzXL61XhaeK
        n+NCmVghvskcq+FE+dALKqG22l5EVQ+bNyWT2QWbdqryKHYYyMrOhX36hmuoiJ6qZnAH/z
        WyqdkV9X02zXkaU9ujXHAj8Ph7KW4dc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-h_fsDUy4PQSzj5CoXrbleA-1; Wed, 05 Feb 2020 02:06:22 -0500
X-MC-Unique: h_fsDUy4PQSzj5CoXrbleA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 633AC8010F6;
        Wed,  5 Feb 2020 07:06:21 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-132.ams2.redhat.com [10.36.116.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E597319756;
        Wed,  5 Feb 2020 07:06:16 +0000 (UTC)
Subject: Re: [RFCv2 17/37] KVM: s390: protvirt: Add machine-check interruption
 injection controls
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-18-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3f7b7252-9e84-f835-cde7-e8c263483b2b@redhat.com>
Date:   Wed, 5 Feb 2020 08:06:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-18-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> The following fields are added to the sie control block type 4:
>      - Machine Check Interruption Code (mcic)
>      - External Damage Code (edc)
>      - Failing Storage Address (faddr)
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 33 +++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 5e85358d9090..f5ca53574406 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -268,16 +268,31 @@ struct kvm_s390_sie_block {
>  #define HPID_VSIE	0x5
>  	__u8	hpid;			/* 0x00b8 */
>  	__u8	reservedb9[7];		/* 0x00b9 */
> -	__u32	eiparams;		/* 0x00c0 */
> -	__u16	extcpuaddr;		/* 0x00c4 */
> -	__u16	eic;			/* 0x00c6 */
> +	union {
> +		struct {
> +			__u32	eiparams;	/* 0x00c0 */
> +			__u16	extcpuaddr;	/* 0x00c4 */
> +			__u16	eic;		/* 0x00c6 */
> +		};
> +		__u64	mcic;			/* 0x00c0 */
> +	} __packed;
>  	__u32	reservedc8;		/* 0x00c8 */
> -	__u16	pgmilc;			/* 0x00cc */
> -	__u16	iprcc;			/* 0x00ce */
> -	__u32	dxc;			/* 0x00d0 */
> -	__u16	mcn;			/* 0x00d4 */
> -	__u8	perc;			/* 0x00d6 */
> -	__u8	peratmid;		/* 0x00d7 */
> +	union {
> +		struct {
> +			__u16	pgmilc;		/* 0x00cc */
> +			__u16	iprcc;		/* 0x00ce */
> +		};
> +		__u32	edc;			/* 0x00cc */
> +	} __packed;
> +	union {
> +		struct {
> +			__u32	dxc;		/* 0x00d0 */
> +			__u16	mcn;		/* 0x00d4 */
> +			__u8	perc;		/* 0x00d6 */
> +			__u8	peratmid;	/* 0x00d7 */
> +		};
> +		__u64	faddr;			/* 0x00d0 */
> +	} __packed;
>  	__u64	peraddr;		/* 0x00d8 */
>  	__u8	eai;			/* 0x00e0 */
>  	__u8	peraid;			/* 0x00e1 */
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

