Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC68D44DF82
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 02:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhKLBGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 20:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhKLBGr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 20:06:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7624CC06127A
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 17:03:57 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g18so7060065pfk.5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 17:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OqiUBkPNwVtm2ZpjSEzoYhMNAp4tNbVTba3KEv6WN8w=;
        b=pc7ejE9G9f2/DNPzPS7XIXvJtmGfBaF2LxIzkZwFvEfuQOri3Y1155wjk7xjt2PNCJ
         kE24TIPjCcGgUSYiX3UWCA1DBdTKkT1C74bahVgNb9tmSS/hJEwGE9hxKY7yJMJ5/gnk
         kd+TrPPKr0MuJqBAypaAOFEn7+cRqbZm+iMfctLBeivKDevpGMITf+s6vQitBcPNGTgw
         /amQnFMW1BnWMyjEaECoc/twxm/ddAt9qLXsEQJ21ZE/S+ANAhdIOkrMWTDwWGDr9sqH
         T2DNYEPOqsm0H4/svC1i15A5EDGrV+fHlrcxZdbN2PUtjvWHGe4Hnq190TEFtTm6CJzc
         ynvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OqiUBkPNwVtm2ZpjSEzoYhMNAp4tNbVTba3KEv6WN8w=;
        b=Zn2bHGCznabKqLSfrBEyNE9/klV4Frtz93enf1mJfY6JD5tzin0IL0paPCIu6UsI46
         wnTaYm0jRSRYNp7MkKUzE2sqEdGQTv/ZkD3iLE/qIWxKJb7qvfY7/V3/8nckVyqiby42
         xhfH91sQcbsMarTSvjYS54VivepOOToxpehcfAPsx1NSqvF6x6EBhDwXTlVpBj944q89
         mMoKVetBN1jq2GK1mZPXpQdYC1RWYN2IzjkLmyehY5b9z6IGiardV4FUQarmNY7C87tY
         eMW+p2VfulEYb05Ep1wfLF9OKYazsgBuvmEXZecFGvFMxgYoWErDCaeUKJjJP2it+Jts
         vD/A==
X-Gm-Message-State: AOAM5304F4QSrM+rvCRFbV3GFA9V+AfriSSThFuOKmU0C0EcyXKXYYmu
        DiHt7I9uYxrrzbA86ZwAFy4ywA==
X-Google-Smtp-Source: ABdhPJxMgoJUa9ek+o+tvzW6z5WeFQCDZekoSsl946lRj2FCOsMM6fcE3+3c50Ng/MtZ8Re7BsLCDg==
X-Received: by 2002:a63:1441:: with SMTP id 1mr7559189pgu.66.1636679035969;
        Thu, 11 Nov 2021 17:03:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t13sm4096818pfl.214.2021.11.11.17.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 17:03:55 -0800 (PST)
Date:   Fri, 12 Nov 2021 01:03:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5.5 23/30] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <YY29d7Vb6aiv93mu@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-24-seanjc@google.com>
 <f0b364ed-bf9e-5de9-0449-6d7ba3682405@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0b364ed-bf9e-5de9-0449-6d7ba3682405@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > Memslot ID to the corresponding memslot mappings are currently kept as
> > indices in static id_to_index array.
> > The size of this array depends on the maximum allowed memslot count
> > (regardless of the number of memslots actually in use).
> > 
> > This has become especially problematic recently, when memslot count cap was
> > removed, so the maximum count is now full 32k memslots - the maximum
> > allowed by the current KVM API.
> > 
> > Keeping these IDs in a hash table (instead of an array) avoids this
> > problem.
> > 
> > Resolving a memslot ID to the actual memslot (instead of its index) will
> > also enable transitioning away from an array-based implementation of the
> > whole memslots structure in a later commit.
> > 
> > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   include/linux/kvm_host.h | 16 +++----
> >   virt/kvm/kvm_main.c      | 96 +++++++++++++++++++++++++++++++---------
> >   2 files changed, 84 insertions(+), 28 deletions(-)
> > 
> (..)
> > @@ -1259,17 +1257,49 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> >   	return 0;
> >   }
> > +static void kvm_replace_memslot(struct kvm_memslots *slots,
> > +				struct kvm_memory_slot *old,
> > +				struct kvm_memory_slot *new)
> > +{
> > +	/*
> > +	 * Remove the old memslot from the hash list, copying the node data
> > +	 * would corrupt the list.
> > +	 */
> > +	if (old) {
> > +		hash_del(&old->id_node);
> > +
> > +		if (!new)
> > +			return;
> > +	}
> > +
> > +	/* Copy the source *data*, not the pointer, to the destination. */
> > +	if (old)
> > +		*new = *old;
> 
> This way of writing it (that, is re-checking whether "old" is not-NULL)
> suggests that it could have been set to NULL inside the previous block
> (since the last check), which isn't true.

Yeah, I think I was trying to minimize the logic delta in future patches, but
looking back at the diffs, that didn't pan out.  I've no objection to folding
the two together.
