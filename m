Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796E34C17A8
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242451AbiBWPsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242444AbiBWPsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:48:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2D7B2D6A
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:48:20 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g1so15704486pfv.1
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vpPW1JmffRLomQX318Bew2lope677hXxFjbioA+p6h0=;
        b=TmuThBOWUcdi8v6oiscGDhyOi248jzblxf/snhYW3ySNS2xauck0j9YrgwMwKOPAyT
         eUQM7pLk/vnZjXVyh1NWGlic51CSIHNdvUClibPF3/CzNzkF7gzwNNs+ofhE5necDm/h
         5QwJzwwikQvOBy2TBUZW0mtqAu5YTNTgWzP0IHOyiJqWUFKtBMLEaiSpjwc1+9w7cVZ4
         KZlzdvAEF8fZPp184qRkv++zfvwMV2iG7RPX7AmuMBS1eiY+IjgM2CLh16vkpQ4Cv9aZ
         w0tC5wn4N7alqkaLAYqDZvYIDfS/uAXyldbMcrIZUL+yz6BN1J786I/oaChLzJN6IDOM
         kMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vpPW1JmffRLomQX318Bew2lope677hXxFjbioA+p6h0=;
        b=36VBlSGVRGEbhqZcRcY9GKZGeykc8Uq3ZAty9JPSg3tHRfQQizR+MinUTupXEWHYFI
         uL3oNcJF4R3xnYjYrjkDbzjocqFD4nMHmiQYmDnut1BOKXWcyX3sOAHfNVz5U3lXIjxF
         Qvje2h1ajfmtfCTVPvI+BhsSesi6tz25j+pmqTeLztRoTNGSxljKvlcFcPlgqskjO3Iq
         xXGtLngvL1A49g9ehhgTmpFzwOVchzhuV3/sLAOt3+iE4zeW8SR+vt5tRKoYn+fTFuNV
         zG+Etp9SB6P9HJfc3F8Bet0//MyA+7r5O2/uxqcmHZRJEYUZcGVkduCZMNT+o7iE0FZp
         s2BQ==
X-Gm-Message-State: AOAM531tPFVvj7VOsGg7DYiVNx3rVyOG3Tlr3MxKUFEV9y+8ZDRc3f0p
        MsJv2VRqnLt1sGqznInz55HRTw==
X-Google-Smtp-Source: ABdhPJwfQEUfpatD1n4L4hWU6zoucEJJPgx1A0pPObEMj1Zs8HxzDqMRZQxhC7v1WTOG8yqyo7UtQw==
X-Received: by 2002:a63:2d05:0:b0:34b:3f1d:2fa8 with SMTP id t5-20020a632d05000000b0034b3f1d2fa8mr105395pgt.447.1645631300245;
        Wed, 23 Feb 2022 07:48:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f8sm18654844pfv.100.2022.02.23.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 07:48:19 -0800 (PST)
Date:   Wed, 23 Feb 2022 15:48:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 08/18] KVM: x86/mmu: do not pass vcpu to root freeing
 functions
Message-ID: <YhZXQOg+5/we5/1g@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-9-pbonzini@redhat.com>
 <cda148b77e3615a4f1ac81de8be233204fb8f981.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cda148b77e3615a4f1ac81de8be233204fb8f981.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022, Maxim Levitsky wrote:
> On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> > @@ -1156,7 +1156,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
> >  		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
> >  			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> >  
> > -	kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
> > +	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
> >  }
> >  
> >  int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 
> IMHO anything that is related to guest memory should work on
> VM level (that is struct kvm).

No, because there are plently of per-CPU/vCPU properties that affect physical
memory accesseses.  Some of them KVM mostly punts on, e.g. MTRRs and APIC base,
but others are relevant, e.g. SMM.

> It is just ironically sad that writing to a guest page requires
> these days a vCPU due to dirty ring tracking.

I dislike (understatement) that the dirty ring code uses the currently running
vCPU instead of passing it down the stack, but fundamentally all memory accesses
that originate from the "CPU", as opposed to a device or whatever, should be tied
to a vCPU.
