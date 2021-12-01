Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA34652DA
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 17:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351040AbhLAQj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 11:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350966AbhLAQjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 11:39:55 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB532C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 08:36:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so157960pjb.5
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 08:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EiMDtLNrGzJyovNSfRSKzNjZUh/JBd0OTj1NBbeJOIA=;
        b=gQ+sHNwyXuk+ngRvoZWSHSv+XoLd1iFnyuM2zig9WPgwh5g/b5z7bjBlPGpWkpbiHX
         ZttyQZH5FjnAvIAd6VmLGWH4RJ7TrMdzUOcsLRz8gKlSzgwy9JjEKF34hKuYtXDq0FEI
         m79wMJeehwC9hIYqEeDjGe93aQaYSlGFqM/+Q/agRWHRnnRraCpleNNKQemqArpWQkwt
         VjOuHgP55gDHO+l56yNuoy1MWp/BGISJ1ikIGAutjhv5vMwFYIgOTMTlEC/epClr7ZPa
         T2Ns7SVYDAJ+dLWLOyFqfK4bkSl3ZcvRXW2kqqz1T95b3nr+rb3Y/Ws2PaUW2qGDIYfA
         M/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EiMDtLNrGzJyovNSfRSKzNjZUh/JBd0OTj1NBbeJOIA=;
        b=PkFwpZX0TARJ7noxsm32E+r/Y4ucRY/ScMKljDj7CbFCUEjAEFmV0d90GB70JKUrDo
         JtLfw3jEL8d2OAfr4KlU5lBbCSs7v8hP549+huEBehK1DNFcWq5/s+dhVw352t+g0DV0
         jVpOXrl3qc2YDjTGnGbtWNvOkrtPeOUqgvOWC3Aj9Uq/67IlE5D1gIJealUtUK7fY38Z
         jxjOO1l5UrxJcU1q2xDU4xlvN3LDctBJbD4Nm6uJfuCjliVwA4kl/35V7/7MPzMUyz6z
         h1q3CBJGPzHwhwUbG6kLzBc9nDugB6PeSJrChdZgMbibc/fcrhihjdKC0+0q0TNwNAq/
         ImPQ==
X-Gm-Message-State: AOAM532UgpdLraGQm9XVBFIK7xCgIk3x9H0IilVMUdiY/JRYu2iYw8ee
        XH863aYP20Z3GLhvgo195B1gFg==
X-Google-Smtp-Source: ABdhPJyXahGJrKzfZIR9Y1jdJrFNOuLMrxo1SOVUWSixC1tSgjjgeI2P0Bp76BO4Dm7yII3lTv2YlA==
X-Received: by 2002:a17:90a:9bc1:: with SMTP id b1mr8785996pjw.49.1638376594129;
        Wed, 01 Dec 2021 08:36:34 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z10sm334283pfh.106.2021.12.01.08.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 08:36:33 -0800 (PST)
Date:   Wed, 1 Dec 2021 16:36:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 26/29] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <Yaekjrr1OVrgwUic@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a39db04edcacfe955c660e2f139f948cf29362f5.1638304316.git.maciej.szmigiero@oracle.com>
 <YabvBW90COsfdoYx@google.com>
 <7119b08c-e82a-8b81-7f9e-2e79f8276d51@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7119b08c-e82a-8b81-7f9e-2e79f8276d51@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, Maciej S. Szmigiero wrote:
> On 01.12.2021 04:41, Sean Christopherson wrote:
> > On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 41efe53cf150..6fce6eb797a7 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -848,6 +848,105 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
> > >   	return NULL;
> > >   }
> > > +/* Iterator used for walking memslots that overlap a gfn range. */
> > > +struct kvm_memslot_iter {
> > > +	struct kvm_memslots *slots;
> > > +	gfn_t end;
> > > +	struct rb_node *node;
> > > +};
> > 
> > ...
> > 
> > > +static inline struct kvm_memory_slot *kvm_memslot_iter_slot(struct kvm_memslot_iter *iter)
> > > +{
> > > +	return container_of(iter->node, struct kvm_memory_slot, gfn_node[iter->slots->node_idx]);
> > 
> > Having to use a helper in callers of kvm_for_each_memslot_in_gfn_range() is a bit
> > ugly, any reason not to grab @slot as well?  Then the callers just do iter.slot,
> > which IMO is much more readable.
> 
> "slot" can be easily calculated from "node" together with either "slots" or
> "node_idx" (the code above just adjusts a pointer) so storing it in the
> iterator makes little sense if the later are already stored there.

I don't want the callers to have to calculate the slot.  It's mostly syntatic
sugar, but I really do think it improves readability.  And since the first thing
every caller will do is retrieve the slot, I see no benefit in forcing the caller
to do the work.

E.g. in the simple kvm_check_memslot_overlap() usage, iter.slot->id is intuitive
and easy to parse, whereas kvm_memslot_iter_slot(&iter)->id is slightly more
difficult to parse and raises questions about why a function call is necessary
and what the function might be doing.

static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
				      gfn_t start, gfn_t end)
{
	struct kvm_memslot_iter iter;

	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
		if (iter.slot->id != id)
			return true;
	}

	return false;
}

vs.

static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
				      gfn_t start, gfn_t end)
{
	struct kvm_memslot_iter iter;

	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
		if (kvm_memslot_iter_slot(&iter)->id != id)
			return true;
	}

	return false;
}

