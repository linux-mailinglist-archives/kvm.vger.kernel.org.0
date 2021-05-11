Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033E337AB94
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhEKQOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhEKQOv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620749624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Fa7kIJWRD3azEdpNbATUB9y51ZnGhLF+IOuwvRHmIY=;
        b=J/96WT1fvlrzJXfJp8ekhQUkQp3rJ/a+BsiQ9tTzy5akme6k6ENbHdSYNNBsFTJcDJwiap
        ao8gXqq4FaCsTfH8NnzE/K32lrE2YjhKqNOXO1t3oAHvY/fege71bnl24yzS6oQ/2tM86c
        j2FtuuKF27N+1L24NtOXJABcWdeArBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-E3-9zp2tN6q3nSLTVwSizA-1; Tue, 11 May 2021 12:13:41 -0400
X-MC-Unique: E3-9zp2tN6q3nSLTVwSizA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 541B21008060;
        Tue, 11 May 2021 16:13:40 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A442B100164C;
        Tue, 11 May 2021 16:13:35 +0000 (UTC)
Date:   Tue, 11 May 2021 18:13:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/6] s390x: uv: Add UV lib
Message-ID: <20210511181333.56e25c31.cohuck@redhat.com>
In-Reply-To: <20210510135148.1904-4-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:45 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's add a UV library to make checking the UV feature bit easier.
> In the future this library file can take care of handling UV
> initialization and UV guest creation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h |  4 ++--
>  lib/s390x/io.c     |  2 ++
>  lib/s390x/uv.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/uv.h     | 10 ++++++++++
>  s390x/Makefile     |  1 +
>  5 files changed, 60 insertions(+), 2 deletions(-)
>  create mode 100644 lib/s390x/uv.c
>  create mode 100644 lib/s390x/uv.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 11f70a9f..b22cbaa8 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -9,8 +9,8 @@
>   * This code is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License version 2.
>   */
> -#ifndef UV_H
> -#define UV_H
> +#ifndef ASM_S390X_UV_H
> +#define ASM_S390X_UV_H

Completely unrelated, but this made me look at the various header
guards, and they seem to be a bit all over the place.

E.g. in lib/s390x/asm/, I see no prefix, ASM_S390X, _ASMS390X,
__ASMS390X, ...

Would consolidating this be worthwhile, or just busywork?

