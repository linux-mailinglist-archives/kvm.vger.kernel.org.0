Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA07B152962
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 11:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgBEKpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 05:45:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727170AbgBEKpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 05:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580899554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/3G9HhOzk6fwi3S5bsm7t2MTr9qMkc8+DcGQ9WulSU=;
        b=bKawgm/g8Yf64E8bp7xfRfWcSN3h4wFlwnN4l7TjzJ+Qxux9d1YBswcn+vvyqbXBmXD8kc
        bsa28yG+RQjk1m0BP905CHv6HZlKzJBRSkjS0FLnUljZa26MyMoRtnziM3tPDy7Mf/lHFe
        LH14D6bRsa3l9WP0hbZcKlmkm/LH9mI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-ulEX2dmPMWesNWy9ech01g-1; Wed, 05 Feb 2020 05:45:50 -0500
X-MC-Unique: ulEX2dmPMWesNWy9ech01g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B8BB8C2800;
        Wed,  5 Feb 2020 10:45:49 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F214D81213;
        Wed,  5 Feb 2020 10:45:44 +0000 (UTC)
Date:   Wed, 5 Feb 2020 11:45:42 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 14/37] KVM: s390: protvirt: Add interruption injection
 controls
Message-ID: <20200205114542.2122f711.cohuck@redhat.com>
In-Reply-To: <25649245-8e28-7121-dec5-cd085a2f9c9a@linux.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-15-borntraeger@de.ibm.com>
        <aa5c40bf-2fa9-f52a-716a-518756caf02a@redhat.com>
        <25649245-8e28-7121-dec5-cd085a2f9c9a@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 09:54:23 +0100
Michael Mueller <mimu@linux.ibm.com> wrote:

> On 05.02.20 07:59, Thomas Huth wrote:
> > On 03/02/2020 14.19, Christian Borntraeger wrote:  
> >> From: Michael Mueller <mimu@linux.ibm.com>
> >>
> >> Define the interruption injection codes and the related fields in the
> >> sie control block for PVM interruption injection.  
> > 
> > You seem to only add the details for external interrupts and I/O
> > interrupts here? Maybe mention this in the description ... otherwise it
> > is confusing when you read patch 17 later ... or maybe merge this patch
> > here with patch 17 ?  
> 
> In that case I will merge patch 17 into this one.

Merging patch 17 sounds good to me, as it gets us all of the new
interrupt controls in one go.

> 
> >   
> >> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> >> ---
> >>   arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
> >>   1 file changed, 21 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> >> index 58845b315be0..a45d10d87a8a 100644
> >> --- a/arch/s390/include/asm/kvm_host.h
> >> +++ b/arch/s390/include/asm/kvm_host.h
> >> @@ -222,7 +222,15 @@ struct kvm_s390_sie_block {
> >>   	__u8	icptcode;		/* 0x0050 */
> >>   	__u8	icptstatus;		/* 0x0051 */
> >>   	__u16	ihcpu;			/* 0x0052 */
> >> -	__u8	reserved54[2];		/* 0x0054 */
> >> +	__u8	reserved54;		/* 0x0054 */
> >> +#define IICTL_CODE_NONE		 0x00
> >> +#define IICTL_CODE_MCHK		 0x01
> >> +#define IICTL_CODE_EXT		 0x02
> >> +#define IICTL_CODE_IO		 0x03
> >> +#define IICTL_CODE_RESTART	 0x04
> >> +#define IICTL_CODE_SPECIFICATION 0x10
> >> +#define IICTL_CODE_OPERAND	 0x11
> >> +	__u8	iictl;			/* 0x0055 */
> >>   	__u16	ipa;			/* 0x0056 */
> >>   	__u32	ipb;			/* 0x0058 */
> >>   	__u32	scaoh;			/* 0x005c */
> >> @@ -259,7 +267,8 @@ struct kvm_s390_sie_block {
> >>   #define HPID_KVM	0x4
> >>   #define HPID_VSIE	0x5
> >>   	__u8	hpid;			/* 0x00b8 */
> >> -	__u8	reservedb9[11];		/* 0x00b9 */
> >> +	__u8	reservedb9[7];		/* 0x00b9 */
> >> +	__u32	eiparams;		/* 0x00c0 */
> >>   	__u16	extcpuaddr;		/* 0x00c4 */
> >>   	__u16	eic;			/* 0x00c6 */
> >>   	__u32	reservedc8;		/* 0x00c8 */
> >> @@ -275,8 +284,16 @@ struct kvm_s390_sie_block {
> >>   	__u8	oai;			/* 0x00e2 */
> >>   	__u8	armid;			/* 0x00e3 */
> >>   	__u8	reservede4[4];		/* 0x00e4 */
> >> -	__u64	tecmc;			/* 0x00e8 */
> >> -	__u8	reservedf0[12];		/* 0x00f0 */
> >> +	union {
> >> +		__u64	tecmc;		/* 0x00e8 */
> >> +		struct {
> >> +			__u16	subchannel_id;	/* 0x00e8 */
> >> +			__u16	subchannel_nr;	/* 0x00ea */
> >> +			__u32	io_int_parm;	/* 0x00ec */
> >> +			__u32	io_int_word;	/* 0x00f0 */
> >> +		};
> >> +	} __packed;
> >> +	__u8	reservedf4[8];		/* 0x00f4 */  
> > 
> > Maybe add a comment to the new struct for which injection type it is
> > good for ... otherwise this might get hard to understand in the future
> > (especially if more stuff gets added like in patch 17).  
> 
> Up to know we don't have comments in the the SIE control block struct at 
> all as this is part of the documentation, also for protected virtualization.

FWIW, I find the sie control block structure already hard to understand
right now. Some documentation would be useful, if possible.

> 
> Any other opinions on that are welcome.
> 
> > 
> > Anyway,
> > Reviewed-by: Thomas Huth <thuth@redhat.com>  
> 
> thanks
> 
> >   
> 
> Michael
> 

