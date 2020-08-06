Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF523D8F2
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 11:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgHFJyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 05:54:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729128AbgHFJxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Aug 2020 05:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596707605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFQZ0mX53TPSFs7e42z02Iv0vBjIKEpvfFKAKifFm84=;
        b=OdQhs77y+/xp+GSTQX+QW5cg2VvJV3fBBmrtv2wTcuZXzMq/IPHgSn8sxQ0Ko2AcuhWgHr
        rhHrLHEsdYu4hMFbuOYle4f0O0ZDdnYScwoatS9hE0D2TctHeFADz9l0xsmaZTcc8hIyaw
        bvKW1ZhDkkA6PxGO4M3x9jskuGUhSfQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-KiOdB-5bM2K-1w3nnKOLrQ-1; Thu, 06 Aug 2020 05:53:23 -0400
X-MC-Unique: KiOdB-5bM2K-1w3nnKOLrQ-1
Received: by mail-wm1-f71.google.com with SMTP id u14so2811955wml.0
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 02:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KFQZ0mX53TPSFs7e42z02Iv0vBjIKEpvfFKAKifFm84=;
        b=HmpVbWJtAhV4lEsfhCpG5AzOJQH/v09JsCzxQ/WhRcwr8TwUILCitmXvzsqUhNVtjH
         lLJF2pbqR1wx77cr+8fuZkdrm3ApC+QQe8Mn4H9/1o3586hrh714nr2WKFzR+SHx0Sno
         9Rezt+rM7PQPSFCjFc6FZkUxsWquy5qnESui42OfRWREN8guupRPi0j9LWb2WHmcJ+1T
         ko5+kIhqudsnQ1TRZ208VpGsBQPT6ggWbIcBaneHoDqeZmNRbPF6kXxSjcHDMg0jyoB5
         9rzt64MU+V9ZEvCKmqqBuwANk3zF6rmnwEk7g1S35c7pT9/WKSc4QrDooo4uOutsqfkE
         TFnw==
X-Gm-Message-State: AOAM531iKPRvMMK9GOvOXJ8gqLx+0r/dTZ9qtqvrxeUfstP0J4AGsl51
        kUKhWKhFVpPiGl9xFQtsffksS59TAqgYGJDaa9HR9bI1/1FBFMLmSyKaMgeRfS0xnWBrZqcyDp6
        wH39FrcpK2Qp8
X-Received: by 2002:adf:a35e:: with SMTP id d30mr7103530wrb.53.1596707602574;
        Thu, 06 Aug 2020 02:53:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH/h9qDvGp6nYOJg6CynBAkWPpcdo5K5kwjUb/kSWQKLCWEkI6SJe/Yh1L7V0XGzkLsCqZXw==
X-Received: by 2002:adf:a35e:: with SMTP id d30mr7103515wrb.53.1596707602334;
        Thu, 06 Aug 2020 02:53:22 -0700 (PDT)
Received: from redhat.com (bzq-79-178-123-8.red.bezeqint.net. [79.178.123.8])
        by smtp.gmail.com with ESMTPSA id m126sm5943543wmf.3.2020.08.06.02.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 02:53:21 -0700 (PDT)
Date:   Thu, 6 Aug 2020 05:53:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200806055008-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
 <20200805201851-mutt-send-email-mst@kernel.org>
 <873650p1vo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873650p1vo.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 06, 2020 at 11:19:55AM +0200, Vitaly Kuznetsov wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > On Tue, Jul 28, 2020 at 04:37:38PM +0200, Vitaly Kuznetsov wrote:
> >> This is a continuation of "[PATCH RFC 0/5] KVM: x86: KVM_MEM_ALLONES
> >> memory" work: 
> >> https://lore.kernel.org/kvm/20200514180540.52407-1-vkuznets@redhat.com/
> >> and pairs with Julia's "x86/PCI: Use MMCONFIG by default for KVM guests":
> >> https://lore.kernel.org/linux-pci/20200722001513.298315-1-jusual@redhat.com/
> >> 
> >> PCIe config space can (depending on the configuration) be quite big but
> >> usually is sparsely populated. Guest may scan it by accessing individual
> >> device's page which, when device is missing, is supposed to have 'pci
> >> hole' semantics: reads return '0xff' and writes get discarded.
> >> 
> >> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
> >> I observed 8193 accesses to PCI hole memory. When such exit is handled
> >> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
> >> Handling the same exit in userspace is six times slower (0.000006 sec) so
> >> the overal; difference is 0.04 sec. This may be significant for 'microvm'
> >> ideas.
> >> 
> >> Note, the same speed can already be achieved by using KVM_MEM_READONLY
> >> but doing this would require allocating real memory for all missing
> >> devices and e.g. 8192 pages gives us 32mb. This will have to be allocated
> >> for each guest separately and for 'microvm' use-cases this is likely
> >> a no-go.
> >> 
> >> Introduce special KVM_MEM_PCI_HOLE memory: userspace doesn't need to
> >> back it with real memory, all reads from it are handled inside KVM and
> >> return '0xff'. Writes still go to userspace but these should be extremely
> >> rare.
> >> 
> >> The original 'KVM_MEM_ALLONES' idea had additional optimizations: KVM
> >> was mapping all 'PCI hole' pages to a single read-only page stuffed with
> >> 0xff. This is omitted in this submission as the benefits are unclear:
> >> KVM will have to allocate SPTEs (either on demand or aggressively) and
> >> this also consumes time/memory.
> >
> > Curious about this: if we do it aggressively on the 1st fault,
> > how long does it take to allocate 256 huge page SPTEs?
> > And the amount of memory seems pretty small then, right?
> 
> Right, this could work but we'll need a 2M region (one per KVM host of
> course) filled with 0xff-s instead of a single 4k page.

Given it's global doesn't sound too bad.

> 
> Generally, I'd like to reach an agreement on whether this feature (and
> the corresponding Julia's patch addding PV feature bit) is worthy. In
> case it is (meaning it gets merged in this simplest form), we can
> suggest further improvements. It would also help if firmware (SeaBIOS,
> OVMF) would start recognizing the PV feature bit too, this way we'll be
> seeing even bigger improvement and this may or may not be a deal-breaker
> when it comes to the 'aggressive PTE mapping' idea.

About the feature bit, I am not sure why it's really needed. A single
mmio access is cheaper than two io accesses anyway, right? So it makes
sense for a kvm guest whether host has this feature or not.
We need to be careful and limit to a specific QEMU implementation
to avoid tripping up bugs, but it seems more appropriate to
check it using pci host IDs.

> -- 
> Vitaly

