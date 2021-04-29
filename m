Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8073736E304
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 03:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhD2BnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 21:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbhD2Bm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 21:42:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F60C06138B
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 18:42:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a11so3001063plh.3
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 18:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pqe5LqRtvTYyV0r4qXJ5L1nWkXOOFv/DcW74NX1Nm7o=;
        b=P1MISArx3GBR0Hn/wgR+NADeIpzNE70ZFdYgFrF7zwW7L0jcGP4PWUkJ6+Zq/+baio
         qM/GnirBN4KEWBDnviWQHeJpgeQuLkLDWQS99JvrrrtBnLp2XtWSX2aoy4kNvUe6Feet
         WRCmKHyDUrhKogOjmatsJFl5OL65GDK6IA2DAtEdwBxKdWu2boYJKQRYqPGqI/ogVGR/
         vQcZqcXWt800mcOvKLkiKTjprSRseqb14GPstWvYEP1uSJQuTc0bGxHDBg8hck0fypKP
         fTk+E7iIIWCbYJKcbu5Ofkf0E/d+AoNLvyRttaY/Zp4tU7XRwK3LO/CEL0zWgBbxQAxU
         OYSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pqe5LqRtvTYyV0r4qXJ5L1nWkXOOFv/DcW74NX1Nm7o=;
        b=t4urKzDJT+z5wm19KFd73Iy8uILC59iPU2w1LaBsJnV1rY0e143UrzLj1duXhpB+0P
         0IsxwiDGt8lqJsC9Bs2U46gSGmFSGeXEaM1DQAY+o8u2ry0sKOCR0iMQdv+jL7CP9Ysd
         JwwG9do/iqUnVhZM6yPXJj6zDE6UQIxSN/1EbJdZw3J9S+P64GYqjsTDlbuW9n+WjGcw
         o8e8R387vA/s3kgw+PhsOkIgy9ikZrxFgGvf6fFEN2zoWOwvxmdZvyBOaeqxx9tGA1T3
         3TJK4+WxjMV6O2Vubo05uM2f/Jm9uoivTGIPAaoO24B2NRT3XXPHS49eTpa1xFDJJeI9
         +mog==
X-Gm-Message-State: AOAM533M1Hs/1jf26dR61gpIBKdehLdkw7vdPZURMxVIgZWAsAOw4Qg1
        Q23EEcIkZfDGtTvC147sKISJww==
X-Google-Smtp-Source: ABdhPJy564zdoUrrTrfjzwKCNIbc0PpRqb8Milb032sa82osMyBcuJHjx/6p0DRLekgZeMGpYu26rw==
X-Received: by 2002:a17:90b:4017:: with SMTP id ie23mr6824580pjb.155.1619660531818;
        Wed, 28 Apr 2021 18:42:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d4sm6001617pjz.49.2021.04.28.18.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 18:42:11 -0700 (PDT)
Date:   Thu, 29 Apr 2021 01:42:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
Message-ID: <YIoO77eIjcA/kiRF@google.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com>
 <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
 <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
 <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
 <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
 <16b2f0f3-c9a8-c455-fff0-231c2fe04a8e@redhat.com>
 <YIoAixSoRsM/APgx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIoAixSoRsM/APgx@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Sean Christopherson wrote:
> On Thu, Apr 29, 2021, Paolo Bonzini wrote:
> > it's not ugly and it's still relatively easy to explain.
> 
> LOL, that's debatable.
> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2799c6660cce..48929dd5fb29 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1377,16 +1374,17 @@ static int kvm_set_memslot(struct kvm *kvm,
> >  		goto out_slots;
> >  	update_memslots(slots, new, change);
> > -	slots = install_new_memslots(kvm, as_id, slots);
> > +	install_new_memslots(kvm, as_id, slots);
> >  	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> > -
> > -	kvfree(slots);
> >  	return 0;
> >  out_slots:
> > -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> > +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> > +		slot = id_to_memslot(slots, old->id);
> > +		slot->flags &= ~KVM_MEMSLOT_INVALID;
> 
> Modifying flags on an SRCU-protect field outside of said protection is sketchy.
> It's probably ok to do this prior to the generation update, emphasis on
> "probably".  Of course, the VM is also likely about to be killed in this case...
> 
> >  		slots = install_new_memslots(kvm, as_id, slots);
> 
> This will explode if memory allocation for KVM_MR_MOVE fails.  In that case,
> the rmaps for "slots" will have been cleared by kvm_alloc_memslot_metadata().

Gah, that's all wrong, slots are the second duplicate and the clear happens on
the new slot, not the old slot with the same id.

Though I still think temporarily dropping the SRCU lock would be simpler.  If
performance is a concern, it could be mitigated by adding a capability to
preallocate the rmaps.

> > +	}
> >  	kvfree(slots);
> >  	return r;
> >  }
> 
> The SRCU index is already tracked in vcpu->srcu_idx, why not temporarily drop
> the SRCU lock if activate_shadow_mmu() needs to do work so that it can take
> slots_lock?  That seems simpler and I think would avoid modifying the common
> memslot code.
> 
> kvm_arch_async_page_ready() is the only path for reaching kvm_mmu_reload() that
> looks scary, but that should be impossible to reach with the correct MMU context.
> We could always and an explicit sanity check on the rmaps being avaiable.
