Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4821E1F6E93
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 22:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFKUOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 16:14:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726134AbgFKUOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 16:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591906449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k91nHI462ecs2iqED4Y49B5PiymmTp4GsBIiqZXp2N0=;
        b=fWAuvYH71d5xTIwFS8QkF+reOz/Kx4O3havuoOrAkwAZuC76rR4qBqdCnv8HVd7BWTRvKh
        h9e2D3JtVhdLa4zYNWDDekG5e8ozlwQrc+TQjeImBnGHGMf0s058niRltSauxVfdRNV3vK
        kb0bT8Kt15415Db+kFNUGI5bv/koDMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-UDkR_OMKOcCG1zv_MLGpvA-1; Thu, 11 Jun 2020 16:14:05 -0400
X-MC-Unique: UDkR_OMKOcCG1zv_MLGpvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25C9A1B18BC6;
        Thu, 11 Jun 2020 20:14:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143881944D;
        Thu, 11 Jun 2020 20:14:02 +0000 (UTC)
Message-ID: <bccfe20ca818020ea982bc383f1fabe51a127268.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: do not pass poisoned hva to
 __kvm_set_memory_region
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 11 Jun 2020 23:14:01 +0300
In-Reply-To: <20200611180159.26085-1-pbonzini@redhat.com>
References: <20200611180159.26085-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-06-11 at 14:01 -0400, Paolo Bonzini wrote:
> __kvm_set_memory_region does not use the hva at all, so trying to
> catch use-after-delete is pointless and, worse, it fails access_ok
> now that we apply it to all memslots including private kernel ones.
> This fixes an AVIC regression.
> 
> Fixes: 09d952c971a5 ("KVM: check userspace_addr for all memslots", 2020-06-01)
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290784ba63e4..00c88c2f34e4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9951,13 +9951,8 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		if (!slot || !slot->npages)
>  			return 0;
>  
> -		/*
> -		 * Stuff a non-canonical value to catch use-after-delete.  This
> -		 * ends up being 0 on 32-bit KVM, but there's no better
> -		 * alternative.
> -		 */
> -		hva = (unsigned long)(0xdeadull << 48);
>  		old_npages = slot->npages;
> +		hva = 0;
>  	}
>  
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {


Under assumption that we can assume that access_ok(0,0) is safe to assume
to be always true:
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

I also tested exactly this solution when triaging this bug and it works,
but I wasn't sure that this is the correct solution.

Best regards,
	Maxim Levitsky



