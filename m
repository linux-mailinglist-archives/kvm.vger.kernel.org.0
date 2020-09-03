Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8824525C7FB
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgICRVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 13:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICRVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 13:21:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E1C061244;
        Thu,  3 Sep 2020 10:21:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so2866988pfi.4;
        Thu, 03 Sep 2020 10:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WashrslN8ZwCXy2QjOJBW4ZEBVnlFGgH8kdTqqVqsKU=;
        b=Q+OHpDNczlIeDseieuM5+66rQlgCH+Kn5aoq2pyWKSRq/jsvf4wYVv5KXl5eRtYund
         JZl5WDBcJ0dEFGAqLKtjWEQjMwWHobhbhirlJ4WtWDrUaVMEscMlOMLfXG+JyNpmjzLY
         oxFSbjOOweW8JzcG9cIzgdnuw+hZPdguo0goAINeDspq+Hd585n+igQho5kjHNKMnFZs
         d/mhy+7aWYNhesXOkEhE49hGkccq3nb5j4n/I0AdXXF2vt4g1RiB52gu5KSrMws3Qc7k
         /uYmO9C9UrVb9wYqhcqsE6TsQgnQ7JmOivOcJy8/ZRep26U1/95AKWQ6rEBBingyaXnA
         bKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WashrslN8ZwCXy2QjOJBW4ZEBVnlFGgH8kdTqqVqsKU=;
        b=EneCLvDWfyXI9HSRj/AeuuURaOfFckvN7ggREpZudvB8M9zMUWT2gNfhCVTFjkWO+D
         ah+74SRFr/lcLKNkHRNDvWm1OY27N1pq3c6tUJ1J3LB81LbvFuUzbwYgo3eqlH3wbmG8
         IFHfOdbdwtMijWmMXbUaBkSxJ/aPevEE0eLX+CboG04dgrkTK2a1ITp2UZtGXjNHKP4Y
         oLpYNeTHHUw4qoq5v4OYaq0P5rOsLLe+odRaWGkKU3+KXWcAi06RXp0spQonzpN+zevk
         2ToR7r3hFHpF9zi/kOphe70EdYpWz6OtCvO32aZx55EmJKp5S7dWAAy0B8jrJBoV1rSU
         qTuQ==
X-Gm-Message-State: AOAM533FppvqWe83ZrZWAWlJwTflRxgPUXd7grOf+IMns5xJOJWnfpnx
        x27F9mXODBIfK66PQfE1pgM=
X-Google-Smtp-Source: ABdhPJxr2WeIZr+RTpBi78RWdVAu+wpXA957uq/QJRrasdDFcpqcc/b8n30BnDD45Q8xs6p/dArHuQ==
X-Received: by 2002:a62:26c2:: with SMTP id m185mr4764708pfm.115.1599153695177;
        Thu, 03 Sep 2020 10:21:35 -0700 (PDT)
Received: from thinkpad ([2605:8d80:4c0:b73f:202a:aafe:118f:5e94])
        by smtp.gmail.com with ESMTPSA id mp3sm3002804pjb.33.2020.09.03.10.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 10:21:34 -0700 (PDT)
Date:   Thu, 3 Sep 2020 10:22:15 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Message-ID: <20200903172215.GA870347@thinkpad>
References: <20200902225718.675314-1-rkovhaev@gmail.com>
 <c5990c86-ab01-d748-5505-375f50a4ed7d@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5990c86-ab01-d748-5505-375f50a4ed7d@embeddedor.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 02, 2020 at 06:34:11PM -0500, Gustavo A. R. Silva wrote:
> Hi,
> 
> On 9/2/20 17:57, Rustam Kovhaev wrote:
> > when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> > the bus, we should iterate over all other devices linked to it and call
> > kvm_iodevice_destructor() for them
> > 
> > Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> > Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I think it's worthwhile to add a Fixes tag for this, too.
> 
> Please, see more comments below...
> 
> > ---
> > v2:
> > - remove redundant whitespace
> > - remove goto statement and use if/else
> > ---
> >  virt/kvm/kvm_main.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 67cd0b88a6b6..cf88233b819a 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> >  void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >  			       struct kvm_io_device *dev)
> >  {
> > -	int i;
> > +	int i, j;
> >  	struct kvm_io_bus *new_bus, *bus;
> >  
> >  	bus = kvm_get_bus(kvm, bus_idx);
> > @@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >  
> >  	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
> >  			  GFP_KERNEL_ACCOUNT);
> > -	if (!new_bus)  {
> > +	if (new_bus) {
> > +		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> 
> 				    ^^^
> It seems that you can use struct_size() here (see the allocation code above)...
> 
> > +		new_bus->dev_count--;
> > +		memcpy(new_bus->range + i, bus->range + i + 1,
> > +		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> 
> 					   ^^^
> ...and, if possible, you can also use flex_array_size() here.
> 
> Thanks
> --
> Gustavo
> 
> > +	} else {
> >  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> > -		goto broken;
> > +		for (j = 0; j < bus->dev_count; j++) {
> > +			if (j == i)
> > +				continue;
> > +			kvm_iodevice_destructor(bus->range[j].dev);
> > +		}
> >  	}
> >  
> > -	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> > -	new_bus->dev_count--;
> > -	memcpy(new_bus->range + i, bus->range + i + 1,
> > -	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> > -
> > -broken:
> >  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> >  	synchronize_srcu_expedited(&kvm->srcu);
> >  	kfree(bus);
> > 

hi Gustavo, thank you for the review, i'll send the new patch.
Vitaly, i think i will need to drop your "Reviewed-by", because there is
going to be a bit more changes
