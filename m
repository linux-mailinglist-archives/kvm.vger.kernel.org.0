Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FDF1548DA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgBFQL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:11:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55149 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727305AbgBFQL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581005516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18+o6TfGXpLztzsh5x4Te5uYEvWgLyhtqiu+swIUrG4=;
        b=CCpCpNUpOKJ+a64R1rDxrjKLmf2yzeFs6c0VVLQMlG/hEGmjqF7RDI0Z83W2vuTG6vAwl3
        1Tu8z8GUDkFNGP2widFU4AEGi25XCp4jcb7ouctDgDJgMh/L+yaTidhASbVVCrHV4mn2qH
        zv3Si3JdLmHtBwmUZQrTSb7BS0BOCyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-wcezRl1PMrSFEwtfhcfOyw-1; Thu, 06 Feb 2020 11:11:52 -0500
X-MC-Unique: wcezRl1PMrSFEwtfhcfOyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B6268C1EE1;
        Thu,  6 Feb 2020 16:11:50 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E45A226FBA;
        Thu,  6 Feb 2020 16:11:48 +0000 (UTC)
Date:   Thu, 6 Feb 2020 17:11:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Message-ID: <20200206171132.4f51f17a.cohuck@redhat.com>
In-Reply-To: <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 15:50:18 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Use document title and chapter markups;
> - Add markups for literal blocks;
> - use :field: for field descriptions;
> - Add blank lines and adjust indentation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/index.rst              |   1 +
>  .../virt/kvm/{locking.txt => locking.rst}     | 111 ++++++++++--------
>  2 files changed, 63 insertions(+), 49 deletions(-)
>  rename Documentation/virt/kvm/{locking.txt => locking.rst} (78%)

(...)

> @@ -48,19 +52,23 @@ restore the saved R/X bits if VMX_EPT_TRACK_ACCESS mask is set, or both. This
>  is safe because whenever changing these bits can be detected by cmpxchg.
>  
>  But we need carefully check these cases:
> -1): The mapping from gfn to pfn
> +
> +1) The mapping from gfn to pfn
> +
>  The mapping from gfn to pfn may be changed since we can only ensure the pfn
>  is not changed during cmpxchg. This is a ABA problem, for example, below case
>  will happen:
>  
> -At the beginning:
> -gpte = gfn1
> -gfn1 is mapped to pfn1 on host
> -spte is the shadow page table entry corresponding with gpte and
> -spte = pfn1
> +At the beginning::
>  
> -   VCPU 0                           VCPU0
> -on fast page fault path:
> +	gpte = gfn1
> +	gfn1 is mapped to pfn1 on host
> +	spte is the shadow page table entry corresponding with gpte and
> +	spte = pfn1
> +
> +	   VCPU 0                           VCPU0
> +
> +on fast page fault path::
>  
>     old_spte = *spte;
>                                   pfn1 is swapped out:

I'm wondering if that should rather be converted to a proper table.

(...)

> @@ -99,12 +109,14 @@ Accessed bit and Dirty bit can not be lost.
>  But it is not true after fast page fault since the spte can be marked
>  writable between reading spte and updating spte. Like below case:
>  
> -At the beginning:
> -spte.W = 0
> -spte.Accessed = 1
> +At the beginning::
>  
> -   VCPU 0                                       VCPU0
> -In mmu_spte_clear_track_bits():
> +	spte.W = 0
> +	spte.Accessed = 1
> +
> +	   VCPU 0                                       VCPU0
> +
> +In mmu_spte_clear_track_bits()::
>  
>     old_spte = *spte;
>  

This one as well.

