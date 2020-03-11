Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2689D181CD1
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgCKPtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 11:49:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729991AbgCKPtC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 11:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583941740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j1LixmxPtKTJrxt7yqg6mbkJVKCbe9sLCbTif/n10Rc=;
        b=KvYC1FLIKmGV2LuBRDfyS9CcVbqU0IEULk2o1Q7MTYS1UNpKz6qWt8bgaM0FBZwSOy92qt
        SVnhkmMWap+HPvGbUHpWU6pxxm6ecUUJeL3K+Plqn89Jg7jSCgMQnunrBQrk1s0CYNhEZI
        SLIi+bQJonsRs3+kxpnAMXFYwv4Cr+w=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-d7fklL1LN7KcKsNeF-iZUg-1; Wed, 11 Mar 2020 11:48:54 -0400
X-MC-Unique: d7fklL1LN7KcKsNeF-iZUg-1
Received: by mail-qk1-f200.google.com with SMTP id k194so1728349qke.10
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 08:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j1LixmxPtKTJrxt7yqg6mbkJVKCbe9sLCbTif/n10Rc=;
        b=tAAqYpNpLoQ0mjaM7W17Mog4idQAp7SPxbbdH78AxhQR1aoXADJPWuiMcqb29/kOYY
         llsLtxN8sZUJ/AdYaUvOtMk0YqYLuCN03oPtnwZ1OpvJTd3ncEIJ/PT8ctEB8Zwak0ig
         9Xh3NntYcKbdCKmSOaEqXEU6OhiIOI2X2QcPzYYjMHwdNb/UIaYiS556gbXdHxQ/0q3a
         0kTuaacf3jDdj2YCFL7UidHfThV/f2/BBPQrmvVRltNMUvsHrXq/xINxIxhg15hTMUP8
         Al3o2pdw0BD2tWshGfblVXDjSdu5eeavb0byVybcioeYrZ7hMb7YjAJO1UDqAT7NEweT
         oedA==
X-Gm-Message-State: ANhLgQ1MrqqPrZFil3vuEFUVZ6IUHJHAiAc44gmWdeo1dP8oJM+gEsQP
        RLerfA7p9ycoUK/Eg4XPIxlgVPTAaZ+Di1PQ9p52d4hHoPpSNIQHAeYKRs52fyoFzXTOHR0sdc6
        V5C+kzElSt6dg
X-Received: by 2002:ac8:1198:: with SMTP id d24mr3260711qtj.105.1583941733626;
        Wed, 11 Mar 2020 08:48:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu17YWnXraFMugU1/N60Qh16BZEC/Vhr08xV3RiKZHFH2wSRQ8tlpsAaLtnFIlX35hJn61DPg==
X-Received: by 2002:ac8:1198:: with SMTP id d24mr3260680qtj.105.1583941733318;
        Wed, 11 Mar 2020 08:48:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n73sm389135qka.81.2020.03.11.08.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 08:48:52 -0700 (PDT)
Date:   Wed, 11 Mar 2020 11:48:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200311154850.GE479302@xz-x1>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309214424.330363-3-peterx@redhat.com>
 <20200310144858.GA7600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310144858.GA7600@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 07:48:59AM -0700, Sean Christopherson wrote:
> On Mon, Mar 09, 2020 at 05:44:12PM -0400, Peter Xu wrote:
> > Cache the address space ID just like the slot ID.  It will be used in
> > order to fill in the dirty ring entries.
> > 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  include/linux/kvm_host.h | 1 +
> >  virt/kvm/kvm_main.c      | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index bcb9b2ac0791..afa0e9034881 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -346,6 +346,7 @@ struct kvm_memory_slot {
> >  	unsigned long userspace_addr;
> >  	u32 flags;
> >  	short id;
> > +	u8 as_id;
> 
> My vote is to store this as a u16 and remove the BUILD_BUG_ON.  Using a u8
> doesn't save any memory since the compiler will pad out the struct.

Sure. Indeed that BUILD_BUG_ON does not help much in this case.  Thanks,

> 
> >  };
> >  
> >  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70f03ce0e5c1..e6484dabfc59 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1036,6 +1036,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  
> >  	new = old = *slot;
> >  
> > +	BUILD_BUG_ON(U8_MAX < KVM_ADDRESS_SPACE_NUM);
> > +	new.as_id = as_id;
> >  	new.id = id;
> >  	new.base_gfn = base_gfn;
> >  	new.npages = npages;
> > -- 
> > 2.24.1
> > 
> 

-- 
Peter Xu

