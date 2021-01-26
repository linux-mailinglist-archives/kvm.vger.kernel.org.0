Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF36305C08
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313970AbhAZWvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbhAZWDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 17:03:15 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925F4C061756
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 14:02:33 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t25so156705pga.2
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 14:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UzduVLBBElKbTcoUoRflYaEyC3jDeNAhreVZX/oQ2Lc=;
        b=FhhXocR5KweOc95t++Zl5olzUN+G47IHVFEWzm4C7EkKGtW7o1i/ZHRPeQjmiasVDj
         YbtUV3I+4+OGtM+JwHtpyraZEjWwQK/fNn4Kh+EC5/DA9xOhlmxV7eo6aogSgEOXt+hH
         TAYvlmRvZ7GMQ06Mr7+wa56VTt+xMnPd0YrieZQr9nIOE0CHkN7VBsJW915OULutqQQH
         jEp4l9VfjRv9kVENl0LGJxQF2Cq7ayvvlJeVKYOkAOo7dh7Wk/AFFXkmDfe3z8fzThNV
         Lj5gpflICD/9EtEcODJg9bfoDoNBvU67oumA0GsSom0fHJf4dBVXLyLgbE7kJgG/6YQx
         LyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UzduVLBBElKbTcoUoRflYaEyC3jDeNAhreVZX/oQ2Lc=;
        b=eQ+/ToTD6IiJILBF3O/I2p2RZYtbuCf0pOkP4/4dqliAz1m38F4IMvUAVrPQWlftMF
         I9+oS3Djumi91/AGNb9uJIe6sthkKafQ+LLWQixQtpBm8kYE+NtZLJsYp8W7t/pDsBje
         JnzUN353CgEswC2iksHDZtvc6GrcYnzKGhsNGypBiim0NA1COct34bb8fIPVDkcgO4TO
         Tk/1c8j0y44xdzP0dlxllUQGjuGY5CSNeVMMtPUK2+e318kRPNIU7UOgUr6xaZ2wzZ8e
         mdCCYrEbEH7OFLWNd6uv6Q8Jptb1bDME782afdrPsqAEsmZRzq4eiHdDcpPuwFRyLo4I
         JdaA==
X-Gm-Message-State: AOAM5305buKJDLMswrPJVQsLOEMq22VYsVhkddd3k+wyfp7dGKl+Puu9
        Ayy7osEtNruL5OC53thsRZoM+A==
X-Google-Smtp-Source: ABdhPJwdor7mQYTUQpr+b82bSQBoX0yLTUtnCl+PojrmfhwgoQ69GY0/EpEmcl38HISZd1BP+H//DQ==
X-Received: by 2002:a62:f202:0:b029:1bc:a634:8e9c with SMTP id m2-20020a62f2020000b02901bca6348e9cmr7170582pfh.49.1611698552886;
        Tue, 26 Jan 2021 14:02:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id p22sm14594pgk.21.2021.01.26.14.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:02:32 -0800 (PST)
Date:   Tue, 26 Jan 2021 14:02:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
Message-ID: <YBCRcalZJwAlkO9F@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com>
 <YAnUhCocizx97FWL@google.com>
 <YAnzB3Uwn3AVTXGN@google.com>
 <335d27f7-0849-de37-f380-a5018c5c5535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335d27f7-0849-de37-f380-a5018c5c5535@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021, Paolo Bonzini wrote:
> On 21/01/21 22:32, Sean Christopherson wrote:
> > Coming back to this series, I wonder if the RCU approach is truly necessary to
> > get the desired scalability.  If both zap_collapsible_sptes() and NX huge page
> > recovery zap_only_  leaf SPTEs, then the only path that can actually unlink a
> > shadow page while holding the lock for read is the page fault path that installs
> > a huge page over an existing shadow page.
> > 
> > Assuming the above analysis is correct, I think it's worth exploring alternatives
> > to using RCU to defer freeing the SP memory, e.g. promoting to a write lock in
> > the specific case of overwriting a SP (though that may not exist for rwlocks),
> > or maybe something entirely different?
> 
> You can do the deferred freeing with a short write-side critical section to
> ensure all readers have terminated.

Hmm, the most obvious downside I see is that the zap_collapsible_sptes() case
will not scale as well as the RCU approach.  E.g. the lock may be heavily
contested when refaulting all of guest memory to (re)install huge pages after a
failed migration.

Though I wonder, could we do something even more clever for that particular
case?  And I suppose it would apply to NX huge pages as well.  Instead of
zapping the leaf PTEs and letting the fault handler install the huge page, do an
in-place promotion when dirty logging is disabled.  That could all be done under
the read lock, and with Paolo's method for deferred free on the back end.  That
way only the thread doing the memslot update would take mmu_lock for write, and
only once per memslot update.

> If the bool argument to handle_disconnected_tdp_mmu_page is true(*), the
> pages would be added to an llist, instead of being freed immediately. At the
> end of a shared critical section you would do
> 
> 	if (!llist_empty(&kvm->arch.tdp_mmu_disconnected_pages)) {
> 		struct llist_node *first;
> 		kvm_mmu_lock(kvm);
> 		first = __list_del_all(&kvm->arch.tdp_mmu_disconnected_pages);
> 		kvm_mmu_unlock(kvm);
> 
> 		/*
> 		 * All vCPUs have already stopped using the pages when
> 		 * their TLBs were flushed.  The exclusive critical
> 		 * section above means that there can be no readers
> 		 * either.
> 		 */
> 		tdp_mmu_free_disconnected_pages(first);
> 	}
> 
> So this is still deferred reclamation, but it's done by one of the vCPUs
> rather than a worker RCU thread.  This would replace patches 11/12/13 and
> probably would be implemented after patch 18.
> 
> Paolo
> 
> (*) this idea is what prompted the comment about s/atomic/shared/
> 
