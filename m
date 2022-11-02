Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF78616532
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 15:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiKBObV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 10:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiKBOaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 10:30:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EBC2B19C
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 07:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667399370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
        b=YNrEETWFBla1FUbtqDmVlOifwe/lglIWUutxe/1F2bTJSD7uPPur7PEESYIFYUlxuuNEve
        UbqI0MK7wOtz41Mlcany1N9mwfF7cg03co7p3+uNFy87SxXSKetIe9pOd2S3cXnnSESY+X
        KQ7NDwWh2rg2w2cPWRJEkQ4MyXkxxoA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-157-0oSf-K50MeW_i8gX-5Gd4Q-1; Wed, 02 Nov 2022 10:29:29 -0400
X-MC-Unique: 0oSf-K50MeW_i8gX-5Gd4Q-1
Received: by mail-qv1-f69.google.com with SMTP id x5-20020ad44585000000b004bb6c687f47so9937307qvu.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
        b=yTqoK+O23Cq/gvcUiIyDM8qw87IXRjgLQNM6o1GQx7pe7U6ejSjWL2sE48mRNTkGs+
         /SyhbmdcolfRdOggJWTNugmmo5zm4SYdyVI6lLvSQeyubLwLYe2qJvv2iay1uHFGEd+y
         fVv16022f88iG08JI0MCobAXOE4H0QWa0+pZGBMuF20fdRfl/03+ChvbBERr/zyFDeZx
         Srcr/3O4L6FXV1t2DufWjEsF+dSxBzrgBwyr2iUAAH5bKeADM1S9TYYgZFKmY+5ffIXu
         WpD0pniHPkF4vMCKLgPvQMQzdcPA5H+hnCaWtS1pvNyfi4G1JWbWYXI8uf/HapelsrN+
         IcPw==
X-Gm-Message-State: ACrzQf3Ls1p+XWdgUFBJIKPcuTGqUfddgS3bUvIVRXMkIkhOLfAzqZ+D
        +5/sWQsH9jkykz2DfindU6T2KzsaxwbmBU5HiQMnBwZEQixF690g8PTaF+AzjBweUCZPgpg8+GE
        GZdxcX0CrS/rG
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id b2-20020a05620a0f8200b006f9d7953f10mr17162271qkn.675.1667399369233;
        Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HQSoT03q9RYt45NNK062Snoc6XJiiqn2B5bpIZKFd3P+Iejj5f4Pza1S6pf/FRJShrYUf4w==
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id b2-20020a05620a0f8200b006f9d7953f10mr17162243qkn.675.1667399368917;
        Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id ez5-20020a05622a4c8500b0039c37a7914csm6626967qtb.23.2022.11.02.07.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:29:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com, maz@kernel.org,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, oliver.upton@linux.dev,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2J+xhBYhqBI81f7@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2F17Y7YG5Z9XnOJ@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022 at 07:39:25PM +0000, Sean Christopherson wrote:
> > @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >  
> >  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> >  
> > +	if (!kvm_dirty_ring_soft_full(ring))
> > +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> > +
> 
> Marc, Peter, and/or Paolo, can you confirm that clearing the request here won't
> cause ordering problems?  Logically, this makes perfect sense (to me, since I
> suggested it), but I'm mildly concerned I'm overlooking an edge case where KVM
> could end up with a soft-full ring but no pending request.

I don't see an ordering issue here, as long as kvm_clear_request() is using
atomic version of bit clear, afaict that's genuine RMW and should always
imply a full memory barrier (on any arch?) between the soft full check and
the bit clear.  At least for x86 the lock prefix was applied.

However I don't see anything stops a simple "race" to trigger like below:

          recycle thread                   vcpu thread
          --------------                   -----------
      if (!dirty_ring_soft_full)                                   <--- not full
                                        dirty_ring_push();
                                        if (dirty_ring_soft_full)  <--- full due to the push
                                            set_request(SOFT_FULL);
          clear_request(SOFT_FULL);                                <--- can wrongly clear the request?

But I don't think that's a huge matter, as it'll just let the vcpu to have
one more chance to do another round of KVM_RUN.  Normally I think it means
there can be one more dirty GFN (perhaps there're cases that it can push >1
gfns for one KVM_RUN cycle?  I never figured out the details here, but
still..) pushed to the ring so closer to the hard limit, but we have had a
buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
that's still fine, but maybe worth a short comment here?

I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
cycle.  It would be good if there's an answer to that from anyone.

-- 
Peter Xu

