Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E67220F0D
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGOOTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 10:19:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44610 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726834AbgGOOTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 10:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=IoRYDDgopduszstIUWCiFbgwiNr782enAdbfYCKE/6M=;
        b=BLriqbdQxMqLhwzGfkY7sfPyQUzBleQOFyEM+cwEOxL1Li37K8bx9eZbDF2Lxur6hbZ/rn
        LRpGnBY7G17P9Qw+0Ga0+CY36sBv3zJhD7LpMa3ObQDbty7Xuef5lQN6x6RxijFv39QTl5
        To9azxR1UtxdFX6qfV409fqabS32ydw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-BiT8pDunPteqAKszS9FMSQ-1; Wed, 15 Jul 2020 10:19:29 -0400
X-MC-Unique: BiT8pDunPteqAKszS9FMSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9876680183C;
        Wed, 15 Jul 2020 14:19:27 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-26.ams2.redhat.com [10.36.112.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04D3679CE4;
        Wed, 15 Jul 2020 14:19:22 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/2] lib/alloc_page: Fix compilation
 issue on 32bit archs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, drjones@redhat.com,
        jmattson@google.com, sean.j.christopherson@intel.com
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
 <20200714130030.56037-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bd98144d-f465-542c-4c6d-35050458e10a@redhat.com>
Date:   Wed, 15 Jul 2020 16:19:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200714130030.56037-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2020 15.00, Claudio Imbrenda wrote:
> The assert in lib/alloc_page is hardcoded to long.
> 
> Use the z modifier instead, which is meant to be used for size_t.
> 
> Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/alloc_page.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index fa3c527..74fe726 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -29,11 +29,11 @@ void free_pages(void *mem, size_t size)
>  	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
>  		   "mem not page aligned: %p", mem);
>  
> -	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#lx", size);
> +	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#zx", size);
>  
>  	assert_msg(size == 0 || (uintptr_t)mem == -size ||
>  		   (uintptr_t)mem + size > (uintptr_t)mem,
> -		   "mem + size overflow: %p + %#lx", mem, size);
> +		   "mem + size overflow: %p + %#zx", mem, size);
>  
>  	if (size == 0) {
>  		freelist = NULL;

Reviewed-by: Thomas Huth <thuth@redhat.com>

