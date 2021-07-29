Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345093DA61A
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbhG2OM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236285AbhG2OKc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627567823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXqr1RIeDrYLMQjGMMe1o9e1l7+4mEOJ5AZ7x/n10fE=;
        b=iuKOedX+Vq0W/CJe/tvlFM55oZ6/KROoCG12zwdnrc3B7UNLLX8gPmUIBGUCd0ML/B+ba1
        FlMzLXl6v6dIlIPTJAjtgvkLNMROJ+dZMnpjUnHuiB5Bq5iFHGLawPkaMqzlFZkeGCbqv8
        qijxgRs3T1vlH/isn63Q9uVjd/TCK3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-cSdKY77gOHiuZPtxXGx8vg-1; Thu, 29 Jul 2021 10:10:21 -0400
X-MC-Unique: cSdKY77gOHiuZPtxXGx8vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1FBC801B3C;
        Thu, 29 Jul 2021 14:10:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C4F25F705;
        Thu, 29 Jul 2021 14:10:08 +0000 (UTC)
Message-ID: <7fd945b4845fb436c284d5741057a10dd919a8f6.camel@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Thu, 29 Jul 2021 17:10:07 +0300
In-Reply-To: <YQBNvLg8WZiKVLBx@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <YPXJQxLaJuoF6aXl@google.com>
         <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
         <YPnBxHwMJkTSBHfC@google.com>
         <714b56eb83e94aca19e35a8c258e6f28edc0a60d.camel@redhat.com>
         <CANgfPd_o5==utejx6iG9xfWrbKtsvGWNbB4yrmuA-NVj_r_a9A@mail.gmail.com>
         <YQBNvLg8WZiKVLBx@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-07-27 at 18:17 +0000, Sean Christopherson wrote:
> On Tue, Jul 27, 2021, Ben Gardon wrote:
> > On Tue, Jul 27, 2021 at 6:06 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > On Thu, 2021-07-22 at 19:06 +0000, Sean Christopherson wrote:
> > > > The elevated mmu_notifier_count and/or changed mmu_notifier_seq will cause vCPU1
> > > > to bail and resume the guest without fixing the #NPF.  After acquiring mmu_lock,
> > > > vCPU1 will see the elevated mmu_notifier_count (if kvm_zap_gfn_range() is about
> > > > to be called, or just finised) and/or a modified mmu_notifier_seq (after the
> > > > count was decremented).
> > > > 
> > > > This is why kvm_zap_gfn_range() needs to take mmu_lock for write.  If it's allowed
> > > > to run in parallel with the page fault handler, there's no guarantee that the
> > > > correct apic_access_memslot_enabled will be observed.
> > > 
> > > I understand now.
> > > 
> > > So, Paolo, Ben Gardon, what do you think. Do you think this approach is feasable?
> > > Do you agree to revert the usage of the read lock?
> > > 
> > > I will post a new series using this approach very soon, since I already have
> > > msot of the code done.
> > > 
> > > Best regards,
> > >         Maxim Levitsky
> > 
> > From reading through this thread, it seems like switching from read
> > lock to write lock is only necessary for a small range of GFNs, (i.e.
> > the APIC access page) is that correct?
> 
> For the APICv case, yes, literally a single GFN (the default APIC base).
> 
> > My initial reaction was that switching kvm_zap_gfn_range back to the
> > write lock would be terrible for performance, but given its only two
> > callers, I think it would actually be fine.
> 
> And more importantly, the two callers are gated by kvm_arch_has_noncoherent_dma()
> and are very rare flows for the guest (updating MTRRs, toggling CR0.CD).
> 
> > If you do that though, you should pass shared=false to
> > kvm_tdp_mmu_zap_gfn_range in that function, so that it knows it's
> > operating with exclusive access to the MMU lock.
> 
> Ya, my suggested revert was to drop @shared entirely since kvm_zap_gfn_range() is
> the only caller that passes @shared=true.
> 


Just one question:
Should I submit the patches for MMU changes that you described,
and on top of them my AVIC patches?

Should I worry about the new TDP mmu?

Best regards,
	Maxim Levitsky

