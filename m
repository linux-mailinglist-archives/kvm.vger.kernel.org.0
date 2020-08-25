Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C68D2522BE
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 23:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHYVZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 17:25:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbgHYVZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 17:25:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598390733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jvt61bqhDvrw7d/FiOCmHNvRxtd4yNajkq8FrCplPOM=;
        b=aqxOOX67C0B1pEq6LyKx+/6F7e/fii+EtBy8CJ7mtDshLrqBYeaRqmQ33AoxBg9jvlmsqV
        /EYqZqHT1QJ1p0zULqAbAe6KJbsVKSZAvEivFigvwBNDCF0mQysxnbDd+TCI4K58WlLlVA
        KfzoI4aTJRBhmirEkbzHOp+FbsD22UE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-4ezowlLXMP-Pn0CsMNe2uQ-1; Tue, 25 Aug 2020 17:25:29 -0400
X-MC-Unique: 4ezowlLXMP-Pn0CsMNe2uQ-1
Received: by mail-qk1-f199.google.com with SMTP id v22so230080qkg.15
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 14:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jvt61bqhDvrw7d/FiOCmHNvRxtd4yNajkq8FrCplPOM=;
        b=Xweo9crpKAK6GdSvSe0XaElEHkuD6lE/vUaeSrehG9jP7VB+JkQX/C635XdAj8xB1u
         uwqoBvB0hdAkCOvMOmi6BXy+FXnwHhrDXVr95yRQV+/BoL6wwaBUjEicWeI5yfIb0/7u
         Eh3B0Xxbm84m3dEEEDwdxGz7amcsUUNe268mrr6J71RLBj9md+TVQm1WAMQmNsMf6Z4b
         CMtiU+3Ya7iDl41cdLOpP50+HxOiY5M77JhnpdQGEVPEtkXKYN8usu58j1sU8aE7Jnvx
         PW74tJhJqQHwVUnjJFt6kcDHKr7AOBn1OXGHO1n9M/tmmtBwEaIzJyq04ZoL1VrQw028
         MovA==
X-Gm-Message-State: AOAM531GSfiqTLpMuwFb7f6EGuPx7eDqZYwXTu5hQDbrPL/CRPbcFpaX
        pc05DE0V6gQus1NoXCOZ9t+p1Cn+r/8O0BeikqW0rB5RBBCDkqkgyaxhbmTsoKiVCEQnSCx7x37
        sRmupBUCrfRft
X-Received: by 2002:ac8:4891:: with SMTP id i17mr10119846qtq.109.1598390729152;
        Tue, 25 Aug 2020 14:25:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw9Y2fG8E7x/3LrI9A6BsgkdM7gRHYBP8FQbC6LUlD17kQrRL2QzruCf3Sfmqr2QzPgTcPVA==
X-Received: by 2002:ac8:4891:: with SMTP id i17mr10119824qtq.109.1598390728848;
        Tue, 25 Aug 2020 14:25:28 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id x124sm89046qkd.72.2020.08.25.14.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 14:25:28 -0700 (PDT)
Date:   Tue, 25 Aug 2020 17:25:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200825212526.GC8235@xz-x1>
References: <20200807141232.402895-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200807141232.402895-1-vkuznets@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 04:12:29PM +0200, Vitaly Kuznetsov wrote:
> When testing Linux kernel boot with QEMU q35 VM and direct kernel boot
> I observed 8193 accesses to PCI hole memory. When such exit is handled
> in KVM without exiting to userspace, it takes roughly 0.000001 sec.
> Handling the same exit in userspace is six times slower (0.000006 sec) so
> the overal; difference is 0.04 sec. This may be significant for 'microvm'
> ideas.

Sorry to comment so late, but just curious... have you looked at what's those
8000+ accesses to PCI holes and what they're used for?  What I can think of are
some port IO reads (e.g. upon vendor ID field) during BIOS to scan the devices
attached.  Though those should be far less than 8000+, and those should also be
pio rather than mmio.

If this is only an overhead for virt (since baremetal mmios should be fast),
I'm also thinking whether we can make it even better to skip those pci hole
reads.  Because we know we're virt, so it also gives us possibility that we may
provide those information in a better way than reading PCI holes in the guest?

Thanks,

-- 
Peter Xu

