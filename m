Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F159E15816C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBJRcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 12:32:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727558AbgBJRcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 12:32:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581355931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hpx+KlhpdDiRQTiwQkVSqmyOtNPlgIJvbHiLOqaRDM0=;
        b=bnkbr+3DIeRCxLCLmDnWysyo1iUYGPVDmCFd8c58SxfQVMyHqZ9wBBbO7d21y0g8KaVnqy
        Qm9g7NpUWYq2Xa2PewtPDSZKb5z+A6IsHJkCfvG4op368yxgt+QoB5IPtvCJwbxZLqiYZd
        6X1Z186QxczRKiGxFIAqdp6XSq2dlVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-YTAtFh4DOnO6N3EwfADtJQ-1; Mon, 10 Feb 2020 12:32:07 -0500
X-MC-Unique: YTAtFh4DOnO6N3EwfADtJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BFB4800D41;
        Mon, 10 Feb 2020 17:31:59 +0000 (UTC)
Received: from gondolin (ovpn-117-244.ams2.redhat.com [10.36.117.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E23289F24;
        Mon, 10 Feb 2020 17:31:55 +0000 (UTC)
Date:   Mon, 10 Feb 2020 18:31:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/uv: Fix handling of length extensions
Message-ID: <20200210183152.40bfae24.cohuck@redhat.com>
In-Reply-To: <20200210165439.3767-2-borntraeger@de.ibm.com>
References: <20200210165439.3767-1-borntraeger@de.ibm.com>
        <20200210165439.3767-2-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 11:54:39 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> The query parameter block might contain additional information and can
> be extended in the future. If the size of the block does not suffice we
> get an error code of rc=0x100.  The buffer will contain all information
> up to the specified size and the hypervisor/guest simply do not need the
> additional information as they do not know about the new data.  That
> means that we can (and must) accept rc=0x100 as success.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/boot/uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index af9e1cc93c68..c003593664cd 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -21,7 +21,7 @@ void uv_query_info(void)
>  	if (!test_facility(158))
>  		return;
>  
> -	if (uv_call(0, (uint64_t)&uvcb))
> +	if (uv_call(0, (uint64_t)&uvcb) && uvcb.header.rc != 0x100)

Add a comment like

/* rc==0x100 means that there is additional data we do not process */

to avoid headscratching in the future?

>  		return;
>  
>  	if (IS_ENABLED(CONFIG_KVM)) {

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

