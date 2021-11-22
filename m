Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C3459391
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhKVRFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 12:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbhKVRFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 12:05:10 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54932C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 09:02:04 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p18so14609539plf.13
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 09:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MMxdg/i4Tpz0Ny0YKb9MupTTV7gYPwcXTsq8GtgzJuM=;
        b=DgZvD0GvFzjj73SoxWOTrAHZamGw2+U8sYNs3o49VVo7sfv9huDqh/8GqI0aBC+3em
         aN7WO1s5yp2tqrb41phNL5UtZArhcUYk4U1CgJzKK/OM2P/YF0qb/Obsy5ElVLQXbYaZ
         WoyvkgOZV/9xySMvcRDmFKs6Fk9Wo1T2vlciBvNXOMviYXrS+5tnVrwtbwAPUBKVngB0
         JMbUUX0ENnuVXjiR+H7dJQzLaI08CAhvM5PFzGNte+H61/D9wlDdOeqrcKcDpjKvkxxD
         NbKZ4ZpPUCpxckkRSf9cH9aj/2HT9fargjlxaDp1GRUUBvaigw1InCuDevQ/PJLUsz9a
         YNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MMxdg/i4Tpz0Ny0YKb9MupTTV7gYPwcXTsq8GtgzJuM=;
        b=W6mO0qFqkAilbg08bla/98ZdRbZ/2SIsZcdQkxnoJHeRO4mcRHNeXrnRXY7I5H9Emj
         TZGDmd90YbCZ1xTRb616Q603Uz0LTta57z7AcK9kECsvwGTG/LbRBVQjRexHfUqXfPBd
         3In8XSAow7kQL6zxFhHDmluZGmTHH4bn74WRNpA8FPndZN2v0MXN1Tjdr+YZ/3omLOQt
         mUosWuSSPXKl5bcyduv4XLIDRnXMTCIIpBNa9a091XVWWgiBOJ+ps6DgsRP4sRiY6hux
         lVUmw8QydWBLYbyNUp8hMJIECAoyetrGZMO1xGdNKYu8SuU1uX4Ic0NI83nG5+38Egke
         pn4A==
X-Gm-Message-State: AOAM531L72m4BUrjH0uxn2T/msS64uHs2AfKw2vEfEUkbKYKcH9+h6UI
        7jfEglMnxWwzy30/4QvbB/pp7Q==
X-Google-Smtp-Source: ABdhPJwsBA16xCRHpsoGuZDsd5cSfRiEfUXusyWpAfQEfVu8E/Lqs/AD7msOa3WreFEUhY9W5jrmtQ==
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr33377297pjb.207.1637600523578;
        Mon, 22 Nov 2021 09:02:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id me7sm21954801pjb.9.2021.11.22.09.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 09:02:02 -0800 (PST)
Date:   Mon, 22 Nov 2021 17:01:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM: Warn if mark_page_dirty() is called without an active vCPU
Message-ID: <YZvNB0ByFmdEkUVX@google.com>
References: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
 <9eb83cdd-9314-0d1f-0d4b-0cf4432e1e84@redhat.com>
 <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f40b8765f2feefb653d8a67e487818f66581aa.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021, David Woodhouse wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c5083f2eb50..72c6453bcef4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3020,12 +3020,17 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  			     struct kvm_memory_slot *memslot,
>  		 	     gfn_t gfn)
>  {
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
> +	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))

Maybe use KVM_BUG_ON?  And two separate WARNs are probably overkill.

	if (KVM_BUG_ON(!vcpu || vcpu->kvm != kvm, kvm))


I'd also prefer to not retrieve the vCPU in the dirty_bitmap path, at least not
until it's necessary (for the proposed dirty quota throttling), though that's not
a strong preference.

> +		return;
> +
>  	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
>  
>  		if (kvm->dirty_ring_size)
> -			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
> +			kvm_dirty_ring_push(&vcpu->dirty_ring,
>  					    slot, rel_gfn);

This can now squeeze on a single line.

			kvm_dirty_ring_push(&vcpu->dirty_ring, slot, rel_gfn);

>  		else
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> -- 
> 2.31.1
> 


