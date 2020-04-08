Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAF31A1C3F
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgDHHEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 03:04:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgDHHEs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 03:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586329486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PL5NL12CLrgF4s0JIXllKLCGUD/J5TZTVhR34cXuYOE=;
        b=WWqAWRvCJ+2+mc5i275Asd/0iOpLGzYGUcXiehptXU55UKe1dsX1yBvl8y2wINmtB228Um
        YESj1y8XMAebWxf/E8xYPu5TXdb5RbmDSsVkYLnBE1cMRKGO4l+1QdxUvLY34nKaIWjuie
        4Q/1XjSfXRqh2T1nKRelpbMvb9dOzKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-xXQiYdcaPGOk9HzBCfDvfQ-1; Wed, 08 Apr 2020 03:04:44 -0400
X-MC-Unique: xXQiYdcaPGOk9HzBCfDvfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E1E7A28B;
        Wed,  8 Apr 2020 07:04:43 +0000 (UTC)
Received: from gondolin (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4F1B5DA60;
        Wed,  8 Apr 2020 07:04:38 +0000 (UTC)
Date:   Wed, 8 Apr 2020 09:04:36 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] KVM: Check validity of resolved slot when searching
 memslots
Message-ID: <20200408090436.2bd1f303.cohuck@redhat.com>
In-Reply-To: <20200408064059.8957-2-sean.j.christopherson@intel.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
        <20200408064059.8957-2-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 23:40:58 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Check that the resolved slot (somewhat confusingly named 'start') is a
> valid/allocated slot before doing the final comparison to see if the
> specified gfn resides in the associated slot.  The resolved slot can be
> invalid if the binary search loop terminated because the search index
> was incremented beyond the number of used slots.
> 
> This bug has existed since the binary search algorithm was introduced,
> but went unnoticed because KVM statically allocated memory for the max
> number of slots, i.e. the access would only be truly out-of-bounds if
> all possible slots were allocated and the specified gfn was less than
> the base of the lowest memslot.  Commit 36947254e5f98 ("KVM: Dynamically
> size memslot array based on number of used slots") eliminated the "all
> possible slots allocated" condition and made the bug embarrasingly easy
> to hit.
> 
> Fixes: 9c1a5d38780e6 ("kvm: optimize GFN to memslot lookup with large slots amount")
> Reported-by: syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6d58beb65454..01276e3d01b9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1048,7 +1048,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
>  			start = slot + 1;
>  	}
>  
> -	if (gfn >= memslots[start].base_gfn &&
> +	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
>  	    gfn < memslots[start].base_gfn + memslots[start].npages) {
>  		atomic_set(&slots->lru_slot, start);
>  		return &memslots[start];

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

