Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA55F2767
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 06:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfKGFsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 00:48:37 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44801 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 00:48:34 -0500
Received: by mail-ot1-f68.google.com with SMTP id c19so963721otr.11
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 21:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9V9eCC2JFYZu6zcXuTG4iQ/tdAIoeCQmoJoRiw+IxE=;
        b=Tx4YrmcOWPH5AicofeOv7Le3DlL9zYuU0UKIwMuye/2CPvfN5GM4EmvomiOie1wIBq
         p2W3xFlKwFy2OzTXOhYQW3gSqmJ3rSbLgPADMgK9thsUeJPytqDk2oKyqN+Z3InW0irF
         aaltFXkRhspkt8vC8Udj8X4vD3RAI0i2O32G8/eNMf44mmBkuzW1DP6rRZuXKLW6BsDd
         xM3a0elRqXj9HSOR7T61uv3QIlaeIZL7tI/IFOZemssG51XLDjs/XgudvreF+4TQEaZw
         fnAt2ONklfMECepk47YuJaXOsjFBdBKOW9BqwPZjfepvtsac7vBUBWKkaib+slU5zv/e
         Cq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9V9eCC2JFYZu6zcXuTG4iQ/tdAIoeCQmoJoRiw+IxE=;
        b=cdAj/IMrgfSV0VZZuqPYYpM+V48k9Jvv4lyFqxmHv6rk2D8TSzgw8Sr9uKCyFx1rB7
         bON3bdMHMoAWWD520Iwxv/i6WEGOWOPe6YsuZkHiUKu8Esg0PPK2EO4xIoIQ6IVvOUR2
         zTWOaVujJe+jIPVe9jAI3EGSwmOQ0ElkZ+OtYePFoD53egb/tT7nKKhpP9WXXK86HXtu
         P+EWOSPv+wYx7mQ3GQeNV1jQ5vWDtyuQiBYkO8Ait/mK05UCgMKw36gKI95PmB/s7Cl8
         MEmwhE7Q5s0FabFolCBq8OZn1X93oBlmv7lFXOayvQAcThGethsey8m2j/Ij/MLUXWyc
         2nGg==
X-Gm-Message-State: APjAAAXXOBp3sMhqy7ZedNhkzKetF6em+9//pM9uxRRQHKYi6Vjb6U3m
        LFxjy5eV1mnoJ2lI+77D1TquFTdRm36DovrIUQq2RA==
X-Google-Smtp-Source: APXvYqxCtFJ60+i6L+LWoVPKEGEVVzo8KggyXl2bJ4VynJUHRAgVawxx0p9R0diCmP4x53Kd2WQ5gBL0AoriIUmKUpA=
X-Received: by 2002:a9d:5f11:: with SMTP id f17mr1358105oti.207.1573105713763;
 Wed, 06 Nov 2019 21:48:33 -0800 (PST)
MIME-Version: 1.0
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com> <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com> <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
 <20191106233913.GC21617@linux.intel.com> <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
In-Reply-To: <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 6 Nov 2019 21:48:22 -0800
Message-ID: <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 6, 2019 at 4:01 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Nov 6, 2019 at 3:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Nov 06, 2019 at 03:20:11PM -0800, Dan Williams wrote:
> > > After some more thought I'd feel more comfortable just collapsing the
> > > ZONE_DEVICE case into the VM_IO/VM_PFNMAP case. I.e. with something
> > > like this (untested) that just drops the reference immediately and let
> > > kvm_is_reserved_pfn() do the right thing going forward.
> >
> > This will break the page fault flow, as it will allow the page to be
> > whacked before KVM can ensure it will get proper notification from the
> > mmu_notifier.  E.g. KVM would install the PFN in its secondary MMU after
> > getting the invalidate notification for the PFN.
>
> How do mmu notifiers get held off by page references and does that
> machinery work with ZONE_DEVICE? Why is this not a concern for the
> VM_IO and VM_PFNMAP case?

Put another way, I see no protection against truncate/invalidate
afforded by a page pin. If you need guarantees that the page remains
valid in the VMA until KVM can install a mmu notifier that needs to
happen under the mmap_sem as far as I can see. Otherwise gup just
weakly asserts "this pinned page was valid in this vma at one point in
time".
