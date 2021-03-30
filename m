Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3234E72E
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 14:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhC3MKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 08:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhC3MK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 08:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617106228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UWWgSFDrD5JIo1udtVgP1e02dE30DXM7jiHpHZlGu9Q=;
        b=cieS/pC9LUJqW75rUV2gFsVneveOv2cBBi/1orTtMyTe0ESOab64bd0+UmS5hGU7En8OG4
        DQJeTUegBWapyPqYaw9EMW6ya6SKa77dk+OQ/ZC2caOmmJF8rDL4pID1+uchrWaJR91GyU
        bDXnSdnNlvgzQX3YGg5zb/0cYYT3Ewc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-GzBcXPnmP0ujnxakIdRhzQ-1; Tue, 30 Mar 2021 08:10:24 -0400
X-MC-Unique: GzBcXPnmP0ujnxakIdRhzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53CF2881D6C;
        Tue, 30 Mar 2021 12:10:23 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A679018E4A;
        Tue, 30 Mar 2021 12:10:18 +0000 (UTC)
Date:   Tue, 30 Mar 2021 14:10:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
Message-ID: <20210330141016.66dff372.cohuck@redhat.com>
In-Reply-To: <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:04 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> When checking for an I/O completion may need to check the cause of
> the interrupt depending on the test case.

"When we check for the completion of an I/O, we may need to check..." ?

> 
> Let's provide the tests the possibility to check if the last
> valid IRQ received is for the function expected after executing

"Let's make it possible for the tests to check whether the last valid
IRB received indicates the expected functions..." ?

> an instruction or sequence of instructions and if all ctrl flags
> of the SCSW are set as expected.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  4 ++--
>  lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>  s390x/css.c         |  4 ++--
>  3 files changed, 20 insertions(+), 9 deletions(-)
> 

(...)

> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 1e5c409..55e70e6 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, int count, unsigned char flags)
>  
>  /* wait_and_check_io_completion:
>   * @schid: the subchannel ID
> + * @ctrl : expected SCSW control flags
>   */
> -int wait_and_check_io_completion(int schid)
> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>  {
>  	wait_for_interrupt(PSW_MASK_IO);
> -	return check_io_completion(schid);
> +	return check_io_completion(schid, ctrl);
>  }
>  
>  /* check_io_completion:
>   * @schid: the subchannel ID
> + * @ctrl : expected SCSW control flags
>   *
> - * Makes the most common check to validate a successful I/O
> - * completion.
> + * If the ctrl parameter is not null check the IRB SCSW ctrl
> + * against the ctrl parameter.
> + * Otherwise, makes the most common check to validate a successful
> + * I/O completion.

What about:

"Perform some standard checks to validate a successful I/O completion.
If the ctrl parameter is not zero, additionally verify that the
specified bits are indicated in the IRB SCSW ctrl flags."

>   * Only report failures.
>   */
> -int check_io_completion(int schid)
> +int check_io_completion(int schid, uint32_t ctrl)
>  {
>  	int ret = 0;
>  

With Thomas' suggested change,

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

