Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF1125A19D
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIAWoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 18:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgIAWoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 18:44:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64452C061244;
        Tue,  1 Sep 2020 15:44:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so1307561pjb.5;
        Tue, 01 Sep 2020 15:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9XmGKtqMZMLQ9hQMtBa1Ufz6OppJVlM58zqrzvNIau0=;
        b=Wm8zLJKGjq2YSmCaQlLYUDu3HOBpmpCT1asfOaseBMwE/Ktc3moPDs/NSBC7+IELNm
         2QSJmWzNZfZMNxNq0/RPh85EdtMNwG1FdmzsqTYbvjJdZ1ze13Q+Yb3NXwdtikkUS40R
         bPhJ25Hx1vUh50fT70hMUY/CN3kL86mprjWOu+FymUqoW60+aYy5bTOG5G7P3v4BHskW
         jVFBmYb+YOW0S61t/mDVHFQR1dyJI1ssHdRMQ0Sau9uQ+BZbYiPyJ6Wm197SbW3wgr5g
         LjOn0YMepl8Tp4e048eF96Buz//n4bGNLmHS3ts6cohrxlyKAL+AEuHnJ9m4t1014XwR
         qY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9XmGKtqMZMLQ9hQMtBa1Ufz6OppJVlM58zqrzvNIau0=;
        b=ZHmR0kHDq3eFKMNO7Amn5UtZ3Ng1nc0sk6v5hZGjVTBjc4FVARJ4kIHvOeGGQZ+px+
         jiYpy1U19Sa+K0LHLDh7NtWCABddkcfK5JSVu1EfL3iiDAHinXkxAH+q6l2IrQa2FrXC
         kFB4sXJL7ZhhXFMidv1ywIQWsZ24F7Ceva2IbonD4513J789bL55tv/7R9CUzSAJAVmc
         xGR2THhfXEXdtBTPpbZjlAOfr71KmqxRIUECCy+vPrUpkUx+uGinvPYqQmJ7jjIxFoNa
         HzkI6DTANp6r8O1TXxo0DkZaGn6R1C1L0EIVfHBm/wPtTKfGxBYMFXrNiC3DxQR+mMPg
         4v4g==
X-Gm-Message-State: AOAM533kvOL1JNLOyBru8QnfiLB4Nvp38rQl+j5JB8pQm/1q9KcoqWcf
        +66xFBSEzL7X41Wjd5zBpiwe6bmK+4b6Mw==
X-Google-Smtp-Source: ABdhPJx+oFgQ6EEF5O/px1m0RBc5ZLs2Auj5dxq8hqCEVwiGmFMqLpDDRbKd7LRck1ECti7ORwfUCw==
X-Received: by 2002:a17:902:7d86:b029:cf:85a7:8372 with SMTP id a6-20020a1709027d86b02900cf85a78372mr3806005plm.1.1599000271763;
        Tue, 01 Sep 2020 15:44:31 -0700 (PDT)
Received: from thinkpad (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id l21sm3164337pgb.35.2020.09.01.15.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:44:31 -0700 (PDT)
Date:   Tue, 1 Sep 2020 15:45:14 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Message-ID: <20200901224514.GA239544@thinkpad>
References: <20200830043405.268044-1-rkovhaev@gmail.com>
 <877dtdwjjt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dtdwjjt.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 06:25:42PM +0200, Vitaly Kuznetsov wrote:
> Rustam Kovhaev <rkovhaev@gmail.com> writes:
> 
> > when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> > the bus, we should iterate over all other devices linked to it and call
> > kvm_iodevice_destructor() for them
> >
> > Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> > Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> > ---
> >  virt/kvm/kvm_main.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 67cd0b88a6b6..646aa7b82548 100644
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
> > @@ -4351,6 +4351,11 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >  			  GFP_KERNEL_ACCOUNT);
> >  	if (!new_bus)  {
>                      ^^^ redundant space 
> 
> >  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> > +		for (j = 0; j < bus->dev_count; j++) {
> > +			if (j == i)
> > +				continue;
> > +			kvm_iodevice_destructor(bus->range[j].dev);
> > +		}
> >  		goto broken;
> 
> The name of the label is really misleading (as it is not actually a
> failure path), I'd even suggest we get rid of this goto completely,
> something like
> 
> 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
> 			  GFP_KERNEL_ACCOUNT);
> 	if (new_bus)  {
> 	       memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> 	       new_bus->dev_count--;
> 	       memcpy(new_bus->range + i, bus->range + i + 1,
> 	              (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
>         } else {
> 		pr_err("kvm: failed to shrink bus, removing it completely\n");
> 		for (j = 0; j < bus->dev_count; j++) {
> 			if (j == i)
> 				continue;
> 			kvm_iodevice_destructor(bus->range[j].dev);
> 	}
> 
> 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> 	synchronize_srcu_expedited(&kvm->srcu);
> 	kfree(bus);
> 	return;
> 
> 
> >  	}
> 
> None of the above should block the fix IMO, so:
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
hi Vitaly, thank you for the review! i'll send the new patch
