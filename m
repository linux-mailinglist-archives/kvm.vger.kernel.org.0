Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91E51820D3
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 19:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbgCKScH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 14:32:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42357 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730468AbgCKScH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 14:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583951526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=spM5agWGar+ORsG2ukJRJ/Acpiv+8pritJ4Z+l+AEgc=;
        b=b3Tbr8JCk8/2pf+ncLNk258cnF1RhOSQ6E2GqzYGzYMHdvKY7/A0JfjUlRTBkoHeeq2OCk
        AdFx3wktKT8xVgWUp+n1fvyhsqmZzfrxaNChBpgg++cvbze7tScNWavp+I5so0NfjPC2hh
        HxCK50Y1ald9Gm0UMZBdtVnhooDPceM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-J9qCn4XrPb6bLmQhABQqUA-1; Wed, 11 Mar 2020 14:32:04 -0400
X-MC-Unique: J9qCn4XrPb6bLmQhABQqUA-1
Received: by mail-qv1-f69.google.com with SMTP id u5so1896166qvj.10
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 11:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=spM5agWGar+ORsG2ukJRJ/Acpiv+8pritJ4Z+l+AEgc=;
        b=G0uMkEVg2JpYBRTu6WeiW52eQ6FYvjHPw2eHDRfnkvnTa4koY1xw0hPv/zUkYf9/FG
         C7tIDxWAnB86ac4FU8kNGl5N/qSXbyNHb+LVd7RALllS5SL0p/Xrr44xVWhGgt1uD+DE
         SGKxXgaXnmJXheAf6JA6v9odQ41Qm3Ukq6WcwwdOA6nwmsGkL7JqOd0XCSVRnZHQ1Nck
         ha7xJkfqiivYRgJ/fAubk6L01HU0S38VJXznbWyHUCS7Q16MX8um+19CQiV0gRDkmZus
         mABibscExAlnL2mb3NXIeQgBbkpweKnwMKgiXxev6cJusU3ux39M6h4UnEpE9iQlRvGr
         001g==
X-Gm-Message-State: ANhLgQ3EgAPKyNQMtpSOfnWawpOGaay4Rb28P83e0FZiZQykDJeSI1Un
        vLPEQ4o8CDukfls6tNVosgeQb/+cUMLwrNOdP+sjUzDj/qDV0cVyy1uxKW1Tw//U0rVskYA6VQl
        9gbi9BYnenvYQ
X-Received: by 2002:a0c:bf0b:: with SMTP id m11mr4107325qvi.63.1583951524038;
        Wed, 11 Mar 2020 11:32:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvDO0+2HivD9CsnZqlnawBVE/5XfG4sJ4JQNxOeTz1KiYixvBmarAvMLC1hUJiRKxZ4PT/7NA==
X-Received: by 2002:a0c:bf0b:: with SMTP id m11mr4107299qvi.63.1583951523712;
        Wed, 11 Mar 2020 11:32:03 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w132sm3565718qkb.96.2020.03.11.11.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 11:32:02 -0700 (PDT)
Date:   Wed, 11 Mar 2020 14:32:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific
 kvm_flush_remote_tlbs()
Message-ID: <20200311183201.GK479302@xz-x1>
References: <20200207223520.735523-1-peterx@redhat.com>
 <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 01:25:30PM +0100, Paolo Bonzini wrote:
> On 07/02/20 23:35, Peter Xu wrote:
> > [This series is RFC because I don't have MIPS to compile and test]
> > 
> > kvm_flush_remote_tlbs() can be arch-specific, by either:
> > 
> > - Completely replace kvm_flush_remote_tlbs(), like ARM, who is the
> >   only user of CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL so far
> > 
> > - Doing something extra before kvm_flush_remote_tlbs(), like MIPS VZ
> >   support, however still wants to have the common tlb flush to be part
> >   of the process.  Could refer to kvm_vz_flush_shadow_all().  Then in
> >   MIPS it's awkward to flush remote TLBs: we'll need to call the mips
> >   hooks.
> > 
> > It's awkward to have different ways to specialize this procedure,
> > especially MIPS cannot use the genenal interface which is quite a
> > pity.  It's good to make it a common interface.
> > 
> > This patch series removes the 2nd MIPS usage above, and let it also
> > use the common kvm_flush_remote_tlbs() interface.  It should be
> > suggested that we always keep kvm_flush_remote_tlbs() be a common
> > entrance for tlb flushing on all archs.
> > 
> > This idea comes from the reading of Sean's patchset on dynamic memslot
> > allocation, where a new dirty log specific hook is added for flushing
> > TLBs only for the MIPS code [1].  With this patchset, logically the
> > new hook in that patch can be dropped so we can directly use
> > kvm_flush_remote_tlbs().
> > 
> > TODO: We can even extend another common interface for ranged TLB, but
> > let's see how we think about this series first.
> > 
> > Any comment is welcomed, thanks.
> > 
> > Peter Xu (4):
> >   KVM: Provide kvm_flush_remote_tlbs_common()
> >   KVM: MIPS: Drop flush_shadow_memslot() callback
> >   KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
> >   KVM: MIPS: Define arch-specific kvm_flush_remote_tlbs()
> > 
> >  arch/mips/include/asm/kvm_host.h |  7 -------
> >  arch/mips/kvm/Kconfig            |  1 +
> >  arch/mips/kvm/mips.c             | 22 ++++++++++------------
> >  arch/mips/kvm/trap_emul.c        | 15 +--------------
> >  arch/mips/kvm/vz.c               | 14 ++------------
> >  include/linux/kvm_host.h         |  1 +
> >  virt/kvm/kvm_main.c              | 10 ++++++++--
> >  7 files changed, 23 insertions(+), 47 deletions(-)
> > 
> 
> Compile-tested and queued.

Just in case it fells through the crach - Paolo, do you still have
plan to queue this again?

Thanks,

-- 
Peter Xu

