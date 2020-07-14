Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1721E9BB
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 09:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGNHNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 03:13:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgGNHM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 03:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594710778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=0I1exq5fUv2DolWCQRV14bmH5NSujtohALF9ojcYl+I=;
        b=VYzApNEm65QGQdlolVLCY5c+R2qcNbjGJB24rfl9w9v4Cnsst+vQMCkBOotw/izyVe+DDG
        +FM+YUcbNLlBQ1QTrffNiiJd2Xa0LTtlKtiUpmPpuTEzWVvC7gAgZk96MoemP6XeXAfE5L
        DRH4UPRWfeJwysUVpY0WLbGkU2myKSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-oCwLfHFtO5eJamJlWU_Ntg-1; Tue, 14 Jul 2020 03:12:56 -0400
X-MC-Unique: oCwLfHFtO5eJamJlWU_Ntg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD5081800D42;
        Tue, 14 Jul 2020 07:12:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AA3F5D9DC;
        Tue, 14 Jul 2020 07:12:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] lib/alloc_page: Revert to 'unsigned long'
 for @size params
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200714042046.13419-1-sean.j.christopherson@intel.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <db6d8b2d-147b-d732-b638-b78a3fd980d2@redhat.com>
Date:   Tue, 14 Jul 2020 09:12:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200714042046.13419-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/2020 06.20, Sean Christopherson wrote:
> Revert to using 'unsigned long' instead of 'size_t' for free_pages() and
> get_order().  The recent change to size_t for free_pages() breaks i386
> with -Werror as the assert_msg() formats expect unsigned longs, whereas
> size_t is an 'unsigned int' on i386 (though both longs and ints are 4
> bytes).
> 
> Message formatting aside, unsigned long is the correct choice given the
> current code base as alloc_pages() and free_pages_by_order() explicitly
> expect, work on, and/or assert on the size being an unsigned long.
> 
> Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
[...]
> diff --git a/lib/bitops.h b/lib/bitops.h
> index 308aa86..dd015e8 100644
> --- a/lib/bitops.h
> +++ b/lib/bitops.h
> @@ -79,7 +79,7 @@ static inline bool is_power_of_2(unsigned long n)
>  	return n && !(n & (n - 1));
>  }
>  
> -static inline unsigned int get_order(size_t size)
> +static inline unsigned int get_order(unsigned long size)
>  {
>  	return size ? fls(size) + !is_power_of_2(size) : 0;
>  }
> 

get_order() already used size_t when it was introduced in commit
f22e527df02ffaba ... is it necessary to switch it to unsigned long now?

Apart from that, this patch fixes the compilation problems, indeed, I
just checked it in the travis-CI.

Tested-by: Thomas Huth <thuth@redhat.com>

