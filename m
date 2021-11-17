Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867F1454B5B
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhKQQwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:52:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239269AbhKQQwU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:52:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5r31ohO67CMQ07xbtqMClO0q3GCnOKbm6lne2ReCfu4=;
        b=LDc2fhjWTmW89Z3xlrjzOKoA9WbVHJlJ1KG7jtklFpATxNk2z1dMDLcb58G54ZZxOFaXmv
        rgERmvWj0c7fcG8bbcjrz2xBr2YpWi0jYk7Yek50UiP/TNGXVK2w/vfw5KTEU7tjaAScZU
        dYkFuRSY9+84q/e4BR3DSzTHYDeRWOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-FhPu6gN2MEi6jY6JEq2JfQ-1; Wed, 17 Nov 2021 11:49:17 -0500
X-MC-Unique: FhPu6gN2MEi6jY6JEq2JfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD1FA87D541;
        Wed, 17 Nov 2021 16:49:16 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7BF560C13;
        Wed, 17 Nov 2021 16:49:15 +0000 (UTC)
Message-ID: <20eddd70-7abb-e1a8-a003-62ed08fc1cac@redhat.com>
Date:   Wed, 17 Nov 2021 17:49:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: There is a null-ptr-deref bug in kvm_dirty_ring_get in
 virt/kvm/dirty_ring.c
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "butterflyhuangxx@gmail.com" <butterflyhuangxx@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
 <4b739ed0ce31e459eb8af9f5b0e2b1516d8e4517.camel@amazon.co.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4b739ed0ce31e459eb8af9f5b0e2b1516d8e4517.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 10:46, Woodhouse, David wrote:
>> The remaining
>> option would be just "do not mark the page as dirty if the ring buffer
>> is active".  This is feasible because userspace itself has passed the
>> shared info gfn; but again, it's ugly...
> I think I am coming to quite like that 'remaining option' as long as we
> rephrase it as follows:
> 
>   KVM does not mark the shared_info page as dirty, and userspace is
>   expected to*assume*  that it is dirty at all times. It's used for
>   delivering event channel interrupts and the overhead of marking it
>   dirty each time is just pointless.

For the case of dirty-bitmap, one solution could be to only set a bool 
and actually mark the page dirty lazily, at the time of 
KVM_GET_DIRTY_LOG.  For dirty-ring, I agree that it's easiest if 
userspace just "knows" the page is dirty.

Paolo

