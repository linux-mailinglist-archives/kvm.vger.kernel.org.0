Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8291A1C5B
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 09:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgDHHKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 03:10:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725763AbgDHHKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 03:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586329835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OJEdDfDhxqWIuQHGi6+YXk/eEkMKJUcybOhiZu3aaes=;
        b=DzdDKZ2TicmmI7ttkkOUSMfI8J+DZfNt4uUQ0YVx+DDbrv3bhW/UKFZyZXFV6iMg+Icyc+
        5AG1XXt2aQDOa+y6mByYpxX1FsO3NMMw21zwX5HzT/v0pdF2eFaZPta3wgHnZmHHpElOlH
        By2dCBt4bdYLftjkdQE0dLAjVLmf2Ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-OCdvW6INMP6v5AQCkPEiRA-1; Wed, 08 Apr 2020 03:10:33 -0400
X-MC-Unique: OCdvW6INMP6v5AQCkPEiRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82FF98024D0;
        Wed,  8 Apr 2020 07:10:32 +0000 (UTC)
Received: from gondolin (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0F931001DD8;
        Wed,  8 Apr 2020 07:10:27 +0000 (UTC)
Date:   Wed, 8 Apr 2020 09:10:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] KVM: s390: Return last valid slot if approx index
 is out-of-bounds
Message-ID: <20200408091024.14a0d096.cohuck@redhat.com>
In-Reply-To: <20200408064059.8957-3-sean.j.christopherson@intel.com>
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
        <20200408064059.8957-3-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 23:40:59 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Return the index of the last valid slot from gfn_to_memslot_approx() if
> its binary search loop yielded an out-of-bounds index.  The index can
> be out-of-bounds if the specified gfn is less than the base of the
> lowest memslot (which is also the last valid memslot).
> 
> Note, the sole caller, kvm_s390_get_cmma(), ensures used_slots is
> non-zero.
> 

This also should be cc:stable, with the dependency expressed as
mentioned by Christian.

> Fixes: afdad61615cc3 ("KVM: s390: Fix storage attributes migration with memory slots")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 19a81024fe16..5dcf9ff12828 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1939,6 +1939,9 @@ static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
>  			start = slot + 1;
>  	}
>  
> +	if (start >= slots->used_slots)
> +		return slots->used_slots - 1;
> +
>  	if (gfn >= memslots[start].base_gfn &&
>  	    gfn < memslots[start].base_gfn + memslots[start].npages) {
>  		atomic_set(&slots->lru_slot, start);

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

