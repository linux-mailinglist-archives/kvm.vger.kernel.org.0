Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB8525D85C
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 14:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgIDMEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 08:04:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730135AbgIDMEh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 08:04:37 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-mrE62mI3PN-zQk6qwZhW7Q-1; Fri, 04 Sep 2020 08:04:29 -0400
X-MC-Unique: mrE62mI3PN-zQk6qwZhW7Q-1
Received: by mail-wr1-f72.google.com with SMTP id b7so2253930wrn.6
        for <kvm@vger.kernel.org>; Fri, 04 Sep 2020 05:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bQF8TpzTrCZC/4WmcQgFOGP42L/HwxRy8XdEsjYv2Fc=;
        b=LBx1h8CFE7NSCcbBVjJCnjGgrtwTRsXxIhT6Jxrha0agKkkp/LX8Zb5bJAumFcZQiM
         jwVzORoyri66mt7oXYEzgTgx8K98cYT/B0Hbf7C/rrO4lWeM6D+U4o+woVBYAxBDv9TG
         gCMqEZTdPhntfcu726YmRKP/pwHWLdE3YLuq7oacRKEqDN0GIE7phkrSgTkkHfIRP2E+
         ZXUrvxpkLzqOQv9mYO+V2v+QrZitA9a6IwXLJ6VmnAPtqkaa/tnKF9x3TNYC9qr0hd97
         0JFxDCdv1eoo4sQpFmoHE40JePJxoxQwsoM6ggw+FoRGANHpnYCrjclGQ3QVdii1Q5C2
         5GLw==
X-Gm-Message-State: AOAM533Z4x6UtRd3rSH84S8eTNWiyGHFrtAqQME2f+mx6shnnEjkWSmm
        5O8iDA++B49qQZ7uuNdKYaceKYIkobE8n6Y8STZkSutnAve4VNGvadDntaSyR3XRbhBufmMkgR/
        l2p/kgA03P/LV
X-Received: by 2002:a5d:4d82:: with SMTP id b2mr6979448wru.232.1599221065157;
        Fri, 04 Sep 2020 05:04:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6OmnqNpUehNDaSAUtieUjPCVL0IZ0+JGfXCMfKMxtkU9JZrgh+p5tgHXEK/+WuQHYKUUK6g==
X-Received: by 2002:a5d:4d82:: with SMTP id b2mr6979430wru.232.1599221064895;
        Fri, 04 Sep 2020 05:04:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l19sm10783595wmi.8.2020.09.04.05.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 05:04:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Rustam Kovhaev <rkovhaev@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
In-Reply-To: <20200903172215.GA870347@thinkpad>
References: <20200902225718.675314-1-rkovhaev@gmail.com> <c5990c86-ab01-d748-5505-375f50a4ed7d@embeddedor.com> <20200903172215.GA870347@thinkpad>
Date:   Fri, 04 Sep 2020 14:04:23 +0200
Message-ID: <87ft7xoiig.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rustam Kovhaev <rkovhaev@gmail.com> writes:

> On Wed, Sep 02, 2020 at 06:34:11PM -0500, Gustavo A. R. Silva wrote:
>> Hi,
>> 
>> On 9/2/20 17:57, Rustam Kovhaev wrote:
>> > when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
>> > the bus, we should iterate over all other devices linked to it and call
>> > kvm_iodevice_destructor() for them
>> > 
>> > Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
>> > Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
>> > Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
>> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> I think it's worthwhile to add a Fixes tag for this, too.
>> 
>> Please, see more comments below...
>> 
>> > ---
>> > v2:
>> > - remove redundant whitespace
>> > - remove goto statement and use if/else
>> > ---
>> >  virt/kvm/kvm_main.c | 21 ++++++++++++---------
>> >  1 file changed, 12 insertions(+), 9 deletions(-)
>> > 
>> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> > index 67cd0b88a6b6..cf88233b819a 100644
>> > --- a/virt/kvm/kvm_main.c
>> > +++ b/virt/kvm/kvm_main.c
>> > @@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>> >  void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>> >  			       struct kvm_io_device *dev)
>> >  {
>> > -	int i;
>> > +	int i, j;
>> >  	struct kvm_io_bus *new_bus, *bus;
>> >  
>> >  	bus = kvm_get_bus(kvm, bus_idx);
>> > @@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>> >  
>> >  	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
>> >  			  GFP_KERNEL_ACCOUNT);
>> > -	if (!new_bus)  {
>> > +	if (new_bus) {
>> > +		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
>> 
>> 				    ^^^
>> It seems that you can use struct_size() here (see the allocation code above)...
>> 
>> > +		new_bus->dev_count--;
>> > +		memcpy(new_bus->range + i, bus->range + i + 1,
>> > +		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
>> 
>> 					   ^^^
>> ...and, if possible, you can also use flex_array_size() here.
>> 
>> Thanks
>> --
>> Gustavo
>> 
>> > +	} else {
>> >  		pr_err("kvm: failed to shrink bus, removing it completely\n");
>> > -		goto broken;
>> > +		for (j = 0; j < bus->dev_count; j++) {
>> > +			if (j == i)
>> > +				continue;
>> > +			kvm_iodevice_destructor(bus->range[j].dev);
>> > +		}
>> >  	}
>> >  
>> > -	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
>> > -	new_bus->dev_count--;
>> > -	memcpy(new_bus->range + i, bus->range + i + 1,
>> > -	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
>> > -
>> > -broken:
>> >  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>> >  	synchronize_srcu_expedited(&kvm->srcu);
>> >  	kfree(bus);
>> > 
>
> hi Gustavo, thank you for the review, i'll send the new patch.
> Vitaly, i think i will need to drop your "Reviewed-by", because there is
> going to be a bit more changes
>

Personally, I'd prefer to make struct_size()/flex_array_size() a
separate preparatory patch so the real fix is small but I don't have a
strong opinion. I'll take look at v3 so feel free to drop R-b if you
decide to make a combined patch and feel free to keep it if you make the
preparatory changes separate :-)

-- 
Vitaly

