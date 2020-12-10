Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E522D584E
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 11:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbgLJKfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 05:35:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729066AbgLJKfF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 05:35:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607596416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1jXSCoC1ms56gAaFCVtVI4M8b5wsl5JWLo/bBLEQpIE=;
        b=L/SxyvEQOL6ng94xqjQ86pm6YiivTrwzH/XGXAZYCunR9iYfoBdHrBo9bbyktIUdwOMfcD
        H5Jy2dsxa3FDfS5NZs5dwcTxuAgPfiIU66q4CP9uMV5H3ET7NKpyog0o2vmYe0IqGFDint
        lrbB/sE6w+9Tp7jj8aDii5RT0o5+Je4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-Ge1oi4s0Oh6yPlm7eNIhFw-1; Thu, 10 Dec 2020 05:33:28 -0500
X-MC-Unique: Ge1oi4s0Oh6yPlm7eNIhFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3315801817;
        Thu, 10 Dec 2020 10:33:26 +0000 (UTC)
Received: from gondolin (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65ADF10023AC;
        Thu, 10 Dec 2020 10:33:21 +0000 (UTC)
Date:   Thu, 10 Dec 2020 11:33:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/4] s390/pci: track alignment/length strictness for
 zpci_dev
Message-ID: <20201210113318.136636e2.cohuck@redhat.com>
In-Reply-To: <1607545670-1557-2-git-send-email-mjrosato@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
        <1607545670-1557-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  9 Dec 2020 15:27:47 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Some zpci device types (e.g., ISM) follow different rules for length
> and alignment of pci instructions.  Recognize this and keep track of
> it in the zpci_dev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h     | 3 ++-
>  arch/s390/include/asm/pci_clp.h | 4 +++-
>  arch/s390/pci/pci_clp.c         | 1 +
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 2126289..f16ffba 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -133,7 +133,8 @@ struct zpci_dev {
>  	u8		has_hp_slot	: 1;
>  	u8		is_physfn	: 1;
>  	u8		util_str_avail	: 1;
> -	u8		reserved	: 4;
> +	u8		relaxed_align	: 1;
> +	u8		reserved	: 3;
>  	unsigned int	devfn;		/* DEVFN part of the RID*/
>  
>  	struct mutex lock;
> diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
> index 1f4b666..9fb7cbf 100644
> --- a/arch/s390/include/asm/pci_clp.h
> +++ b/arch/s390/include/asm/pci_clp.h
> @@ -150,7 +150,9 @@ struct clp_rsp_query_pci_grp {
>  	u16			:  4;
>  	u16 noi			: 12;	/* number of interrupts */
>  	u8 version;
> -	u8			:  6;
> +	u8			:  4;
> +	u8 relaxed_align	:  1;	/* Relax length and alignment rules */
> +	u8			:  1;
>  	u8 frame		:  1;
>  	u8 refresh		:  1;	/* TLB refresh mode */
>  	u16 reserved2;
> diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
> index 153720d..630f8fc 100644
> --- a/arch/s390/pci/pci_clp.c
> +++ b/arch/s390/pci/pci_clp.c
> @@ -103,6 +103,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
>  	zdev->max_msi = response->noi;
>  	zdev->fmb_update = response->mui;
>  	zdev->version = response->version;
> +	zdev->relaxed_align = response->relaxed_align;
>  
>  	switch (response->version) {
>  	case 1:

Hm, what does that 'relaxed alignment' imply? Is that something that
can apply to emulated devices as well?

