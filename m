Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F0B33272E
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 14:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhCINbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 08:31:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhCINb2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 08:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615296688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpvaiT9lNridqnyvnBIVcNFfk1XSrEn77fD74rsW3bg=;
        b=GqhJTLtR7XC7p4NWBwZqyqK5m8nFQyrAcFujvruDJ2Zu9x40hCopqogVJSLPO/cDOVuXWo
        1yyqbJBPnW/+J2rkEPfNclyQbVpMFAckeqluHJ1rws7m1P0JjJhMrZdVrAhgh9bj2fSbdn
        BckPDEmpXZF2n9t0ZWR6tyLrJawy4/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-yuDpp31vNJ2ZcgeLvMHd8A-1; Tue, 09 Mar 2021 08:31:26 -0500
X-MC-Unique: yuDpp31vNJ2ZcgeLvMHd8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 218F71005D4A;
        Tue,  9 Mar 2021 13:31:25 +0000 (UTC)
Received: from starship (unknown [10.35.206.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7600319D7C;
        Tue,  9 Mar 2021 13:31:22 +0000 (UTC)
Message-ID: <b0e0aaac1b1aae31a12a416a6df2c7f2ef768734.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Exclude the MMU_PRESENT bit from MMIO
 SPTE's generation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Date:   Tue, 09 Mar 2021 15:31:21 +0200
In-Reply-To: <d72993d9-c11c-a5f4-0452-b2bed730938c@redhat.com>
References: <20210309021900.1001843-1-seanjc@google.com>
         <20210309021900.1001843-3-seanjc@google.com>
         <785c17c307e66b9d7b422cc577499d284cfb6e7b.camel@redhat.com>
         <d72993d9-c11c-a5f4-0452-b2bed730938c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 14:12 +0100, Paolo Bonzini wrote:
> On 09/03/21 11:09, Maxim Levitsky wrote:
> > What happens if mmio generation overflows (e.g if userspace keeps on updating the memslots)?
> > In theory if we have a SPTE with a stale generation, it can became valid, no?
> > 
> > I think that we should in the case of the overflow zap all mmio sptes.
> > What do you think?
> 
> Zapping all MMIO SPTEs is done by updating the generation count.  When 
> it overflows, all SPs are zapped:
> 
>          /*
>           * The very rare case: if the MMIO generation number has wrapped,
>           * zap all shadow pages.
>           */
>          if (unlikely(gen == 0)) {
>                  kvm_debug_ratelimited("kvm: zapping shadow pages for 
> mmio generation wraparound\n");
>                  kvm_mmu_zap_all_fast(kvm);
>          }
> 
> So giving it more bits make this more rare, at the same time having to 
> remove one or two bits is not the end of the world.

This is exactly what I expected to happen, I just didn't find that code.
Thanks for explanation, and it shows that I didn't study the mmio spte
code much.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


