Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B241D419F
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgENXW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 19:22:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726265AbgENXW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 19:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589498575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U8rBzNXdOzM4Rq4wtVrbgFP4P1r/jFbtiVyjQ6K0+Gs=;
        b=YNNv85gcCawjDhp3RUkJ+wv/njvaTya4PHjQj7f2C8c2yh753mGDinZqpGgJmG/Nfc5fYp
        dJAsopC+AZZexJQoCs/i97/YsCKqrCEZE15sW2T7moVV24E6LhmmlGsqMwBJmLWGx6TLxj
        /mPRDlwNDz/ZWAaJ7n75/G9G8dh2jHo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-L13NHjsQNvSRktQ6GC2k1w-1; Thu, 14 May 2020 19:22:53 -0400
X-MC-Unique: L13NHjsQNvSRktQ6GC2k1w-1
Received: by mail-qv1-f71.google.com with SMTP id o18so705528qvu.8
        for <kvm@vger.kernel.org>; Thu, 14 May 2020 16:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U8rBzNXdOzM4Rq4wtVrbgFP4P1r/jFbtiVyjQ6K0+Gs=;
        b=axBoe9DNNgQIwW3t74/+oBht/JaLKgmA8ElDDUrYpXLwgVaWVZAK+Hifyi+DL/k/0s
         drcD3xSDgnL44kRUIJGu2zv5Jy6jVBBOgXqHtMUfNv3Cb/cZdX1fCxsggRF5s0oUoHiA
         te5HfkbC7wspUgyTNwdEiH3hZ00E0wE+txe7O8yjORCRZ/fKm8qGYdr4nCMaAMfBViIJ
         RfjSTeiltc5bo4HPO9zM1itmbQ64aH6C7XCQs5WpP16X+40If4y7ChTfZtAkjp+5bI4U
         m98z4lDup/gqN3CpXNx4AS4/wemyDQRD4u6np4MEZ+oJVizcQSR1fBZtjjHhBTiChfKe
         j1zg==
X-Gm-Message-State: AOAM531TdhJsnxXpn2/bhlOXjiGyGbMJTqwFYv0ndC0m+eEgrOkopZkj
        aGZFW6i2OE+/KGatXtkLH42ycOv2jIZ9uxhAlRd41pZ2paE35oDDw4OdtuXs62WmmGAZvnoiTNA
        5nhpT1kvX34e7
X-Received: by 2002:ac8:4e88:: with SMTP id 8mr702026qtp.82.1589498573042;
        Thu, 14 May 2020 16:22:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxt1M53IY+PZfrK2ms2IkckL0ZxGObiPKv85M0b7abCJWZc6trLjqL/D3PRXRMdZb5PGRr6GA==
X-Received: by 2002:ac8:4e88:: with SMTP id 8mr702012qtp.82.1589498572740;
        Thu, 14 May 2020 16:22:52 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p22sm553284qte.2.2020.05.14.16.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 16:22:51 -0700 (PDT)
Date:   Thu, 14 May 2020 19:22:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Message-ID: <20200514232250.GA479802@xz-x1>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514220516.GC449815@xz-x1>
 <20200514225623.GF15847@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514225623.GF15847@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 03:56:24PM -0700, Sean Christopherson wrote:
> On Thu, May 14, 2020 at 06:05:16PM -0400, Peter Xu wrote:
> > On Thu, May 14, 2020 at 08:05:35PM +0200, Vitaly Kuznetsov wrote:
> > > The idea of the patchset was suggested by Michael S. Tsirkin.
> > > 
> > > PCIe config space can (depending on the configuration) be quite big but
> > > usually is sparsely populated. Guest may scan it by accessing individual
> > > device's page which, when device is missing, is supposed to have 'pci
> > > holes' semantics: reads return '0xff' and writes get discarded. Currently,
> > > userspace has to allocate real memory for these holes and fill them with
> > > '0xff'. Moreover, different VMs usually require different memory.
> > > 
> > > The idea behind the feature introduced by this patch is: let's have a
> > > single read-only page filled with '0xff' in KVM and map it to all such
> > > PCI holes in all VMs. This will free userspace of obligation to allocate
> > > real memory and also allow us to speed up access to these holes as we
> > > can aggressively map the whole slot upon first fault.
> > > 
> > > RFC. I've only tested the feature with the selftest (PATCH5) on Intel/AMD
> > > with and wiuthout EPT/NPT. I haven't tested memslot modifications yet.
> > > 
> > > Patches are against kvm/next.
> > 
> > Hi, Vitaly,
> > 
> > Could this be done in userspace with existing techniques?
> > 
> > E.g., shm_open() with a handle and fill one 0xff page, then remap it to
> > anywhere needed in QEMU?
> 
> Mapping that 4k page over and over is going to get expensive, e.g. each
> duplicate will need a VMA and a memslot, plus any PTE overhead.  If the
> total sum of the holes is >2mb it'll even overflow the mumber of allowed
> memslots.

What's the PTE overhead you mentioned?  We need to fill PTEs one by one on
fault even if the page is allocated in the kernel, am I right?

4K is only an example - we can also use more pages as the template.  However I
guess the kvm memslot count could be a limit..  Could I ask what's the normal
size of this 0xff region, and its distribution?

Thanks,

-- 
Peter Xu

