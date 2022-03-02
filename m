Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2634CAEC6
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbiCBTeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiCBTeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:34:44 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7184CD6B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:33:57 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o26so2479904pgb.8
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2/7TR1czOlrni5ve6cjMiYf0huddF9ZUrXfqRqxvxSU=;
        b=pNibpYwhsyhSu1HqTGYjGU8JzPqNoU7cHvFkSUbu2sCsHp/EphxSSJEocYDVhiRdM+
         sKAwbSV5PWyHRpki7EvohvnWo+tEJuU3QZG+Yz0rjwShV+zWoIb8tajePwQ3VpDJPXrb
         fD5MEZ46OSpAXyy7oxCWEzYKtEJ/4OViaC5xr7Zd5LD/OrekyQKFTJNVjdUPNfise/mh
         iyHXCgYoE58om7RG7g9nQvvwRDDF9eDk6pHoesWyu9rUPY95PlSf/k3wKea2uCz6R8Nt
         1d8fhx9zcbJkcBrcxpf0sOfLVAmBus/9UPtMl+KdSTn0bCiPuZEn5CiywtLeKb/15KrI
         l2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2/7TR1czOlrni5ve6cjMiYf0huddF9ZUrXfqRqxvxSU=;
        b=tL7bFw8TAWZxaii2lfC51/Hl7WnB8POW8OTuNqxHohVWIoPah++76RsBIrdPI9dYCm
         gFwwjH4gyXEJiSyi2/GVwqJK2s3IKo31pGWz2t61TrG9jYKecct0LSXZfCEgqH+gC3nU
         WC6yyupLvt3hkWWGJU1mPtTgbUl5oquiCoZg9wyYO2KNT6Sl18i54uupwdjwR+AJK+sc
         20KcGt+gJGWlYLKZSBHW4cRFCNhaZJOOmoJctYDqXEVfIQUPz2kSdGTTFygPqOSa0U5I
         CTClibkjyRGOYz53NR/41TzzPDfGMQdKlxs/s9I/z/nZu0DzzApZMLN/hE94oW0/L3hT
         JIrA==
X-Gm-Message-State: AOAM530TicggZFcxW83yrgeufM9DnB5g4Ek5Y7k8u976/UcEl3wBW9yN
        EQbCisU5NncrMivNGyKBooO+SA==
X-Google-Smtp-Source: ABdhPJxMm2HhuXip/+Ypn78NGQSL9LpS8YyhU3LOl2tsaeVF9uBhm+MuFsRaTN46IJajehuRwXWqhA==
X-Received: by 2002:a63:6b07:0:b0:37c:52b4:60fb with SMTP id g7-20020a636b07000000b0037c52b460fbmr276254pgc.381.1646249637296;
        Wed, 02 Mar 2022 11:33:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k7-20020a63ff07000000b00372dc67e854sm16352520pgi.14.2022.03.02.11.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:33:56 -0800 (PST)
Date:   Wed, 2 Mar 2022 19:33:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <Yh/GoUPxMRyFqFc5@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
 <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/2/22 19:01, Sean Christopherson wrote:
> > > It passes a smoke test, and also resolves the debate on the fate of patch 1.
> > +1000, I love this approach.  Do you want me to work on a v3, or shall I let you
> > have the honors?
> 
> I'm already running the usual battery of tests, so I should be able to post
> it either tomorrow (early in my evening) or Friday morning.

Gah, now I remember why I didn't use an async worker.  kvm_mmu_zap_all_fast()
must ensure all SPTEs are zapped and their dirty/accessed data written back to
the primary MMU prior to returning.  Once the memslot update completes, the old
deleted/moved memslot is no longer reachable by the mmu_notifier.  If an mmu_notifier
zaps pfns reachable via the root, KVM will do nothing because there's no relevant
memslot.

So we can use workers, but kvm_mmu_zap_all_fast() would need to flush all workers
before returning, which ends up being no different than putting the invalid roots
on a different list.

What about that idea?  Put roots invalidated by "fast zap" on _another_ list?
My very original idea of moving the roots to a separate list didn't work because
the roots needed to be reachable by the mmu_notifier.  But we could just add
another list_head (inside the unsync_child_bitmap union) and add the roots to
_that_ list.

Let me go resurrect that patch from v1 and tweak it to keep the roots on the old
list, but add them to a new list as well.  That would get rid of the invalid
root iterator stuff.
