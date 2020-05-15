Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9240C1D4C39
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 13:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgEOLPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 07:15:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50724 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgEOLPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 07:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589541346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wj1hRCTkHQCZJH+c9WShqi9qUC8IADHSYNNh6gBVfN4=;
        b=F9FFTzLlCQoXjlvZITiaMr6KQs3IMX74B7rD9khW8vJwvvxhGbFp93p7w6PoGeIK1VvcXG
        XwU3Gv/wxwy82Tk/kJqDCWRMMKnpcoOL2dNVGGVTakKlVZr5MnVqYCTas3g+eBU8uDVJir
        eLrlDNtmPfTDL+YUjq+RzuKfal683BE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-KD0W5C2POUuGle0Ht-uzNQ-1; Fri, 15 May 2020 07:15:42 -0400
X-MC-Unique: KD0W5C2POUuGle0Ht-uzNQ-1
Received: by mail-qk1-f200.google.com with SMTP id i10so1791577qkm.23
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 04:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wj1hRCTkHQCZJH+c9WShqi9qUC8IADHSYNNh6gBVfN4=;
        b=O4zSsdq65keID63AnBFwDamFKhexFUTIe6O9jVUWTlZ22qnLPN9Qfyiz84UNoY0JLa
         Q88RrNX/8aMPoxWiMkK+sjOn/6xrhex3PwMDvjzYMCeWlA9hmMfMOMjUWjHBHfXPOvmA
         t0ZyF6admxqeEXldJpFs6qQKrm/N+/ZD8o+pCB4ixw2W9BNL5/c/gTlduLYbScE4hajY
         92koMQ5U+dnvDOTzH4uP1x/0IOxV2CG1KuQzahl/shOgLgNZZ5rNhW55EFGnoulCdITj
         tGK5VBkLlBzUPdXy3AoRitFIxzNBp10CCfixLceLwV3EaoHH/wMpDDkIDWWX5SwFluHQ
         V6ww==
X-Gm-Message-State: AOAM532cYtVgxT4Fxp3s1cbvvG0M5nucoPkthSOPHIYCYTSTCRYHFfJw
        2kFOTf0kV6DIKXITkjhiDk3EyXoTH5urH9hZUr6gvcuFi24fwXITwj9z0GsszSMlImkOqObHC1m
        x5KWM1CIbVjPz
X-Received: by 2002:a37:9bcf:: with SMTP id d198mr2701591qke.423.1589541342364;
        Fri, 15 May 2020 04:15:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6k0Wxp/fggTGTEhGVsnY3c8zWZpwXaG8sjFGKb5wDstAflNu6HHHSCA7aDXYrrL/lD2v3kw==
X-Received: by 2002:a37:9bcf:: with SMTP id d198mr2701562qke.423.1589541342093;
        Fri, 15 May 2020 04:15:42 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t12sm1303890qkt.77.2020.05.15.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 04:15:41 -0700 (PDT)
Date:   Fri, 15 May 2020 07:15:39 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES memory
Message-ID: <20200515111539.GA497380@xz-x1>
References: <20200514180540.52407-1-vkuznets@redhat.com>
 <20200514220516.GC449815@xz-x1>
 <20200514225623.GF15847@linux.intel.com>
 <CALCETrUf3qMgpYGfF=b6dt2gneodTv5eYGGwKZ=xDSYDa9aTVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUf3qMgpYGfF=b6dt2gneodTv5eYGGwKZ=xDSYDa9aTVg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 06:03:20PM -0700, Andy Lutomirski wrote:
> On Thu, May 14, 2020 at 3:56 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, May 14, 2020 at 06:05:16PM -0400, Peter Xu wrote:
> > > On Thu, May 14, 2020 at 08:05:35PM +0200, Vitaly Kuznetsov wrote:
> > > > The idea of the patchset was suggested by Michael S. Tsirkin.
> > > >
> > > > PCIe config space can (depending on the configuration) be quite big but
> > > > usually is sparsely populated. Guest may scan it by accessing individual
> > > > device's page which, when device is missing, is supposed to have 'pci
> > > > holes' semantics: reads return '0xff' and writes get discarded. Currently,
> > > > userspace has to allocate real memory for these holes and fill them with
> > > > '0xff'. Moreover, different VMs usually require different memory.
> > > >
> > > > The idea behind the feature introduced by this patch is: let's have a
> > > > single read-only page filled with '0xff' in KVM and map it to all such
> > > > PCI holes in all VMs. This will free userspace of obligation to allocate
> > > > real memory and also allow us to speed up access to these holes as we
> > > > can aggressively map the whole slot upon first fault.
> > > >
> > > > RFC. I've only tested the feature with the selftest (PATCH5) on Intel/AMD
> > > > with and wiuthout EPT/NPT. I haven't tested memslot modifications yet.
> > > >
> > > > Patches are against kvm/next.
> > >
> > > Hi, Vitaly,
> > >
> > > Could this be done in userspace with existing techniques?
> > >
> > > E.g., shm_open() with a handle and fill one 0xff page, then remap it to
> > > anywhere needed in QEMU?
> >
> > Mapping that 4k page over and over is going to get expensive, e.g. each
> > duplicate will need a VMA and a memslot, plus any PTE overhead.  If the
> > total sum of the holes is >2mb it'll even overflow the mumber of allowed
> > memslots.
> 
> How about a tiny character device driver /dev/ones?

Yeah, this looks very clean.

Or I also like Sean's idea about using the slow path - I think the answer could
depend on a better knowledge on the problem to solve (PCI scan for small VM
boots) to firstly justify that the fast path is required.  E.g., could we even
workaround that inefficient reading of 0xff's for our use case?  After all what
the BIOS really needs is not those 0xff's, but some other facts.

Thanks!

-- 
Peter Xu

