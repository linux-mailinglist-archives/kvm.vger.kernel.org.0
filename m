Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA4575540
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiGNSn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240796AbiGNSn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:43:56 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D342A474
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:43:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f65so2337574pgc.12
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NM1N+SJFgizKrF/VDg0MKydtM78EiQvOFsnpZnvX3qg=;
        b=oh5g80uM7crOAblJXnNWoNPT3HtxmbTitG9x4iY+K+V+9OTCUwiY5ZA6pbiBe3g3fz
         +urKkk58m9ilC4O0qSuUYQ4V/VuFAu0ryvw/FGyGryuiVgrAYOqpJpwT/HEJ9XW+tOJG
         7qqI0fpElAq1rpZqKYG76TiJDDBebduoxY/ywpEdQD1zHvVO/lasKi9skCWOgeMCq/P4
         aOds+CB+12RlAQpqeSL28wghjugi48HENwgTX6tTNX/85ZcCu/V/dfPS5G+tlHWdVOGW
         eOiHCNxK1OecQGfJm5DGRLp89HM7oWbwT23oyfb0dlZtq6FDCaCkF9+tamb1OJ+87a+t
         CkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NM1N+SJFgizKrF/VDg0MKydtM78EiQvOFsnpZnvX3qg=;
        b=Y5gktiejWaSkTUXSt0DlYXTXlQEDr15a1zum21cKbmFoA2uuSHk/WMsl3LV3kGDULQ
         iXp4XqQrRr/1wd+ge8euK+MgN1Ir0JLemkr7zN5zJl9brFbVrGvOKqi2HOYPdnxDKt+T
         eRoVCLlbleAcNmqFFA6/PAXLPEhVN9KWrKNXpmC+3IHye1r2xz7WmvgeNQdBKHHo+nKY
         3caerdWpiFoa3KQxFoS3HGaRV0r7PtsgPl1hpJjup58TozaGiw5XkiIl2KB7eIQr5p0U
         J9tU0aRlxtKTN7MWRdGDdowaoY3i7rbVnd3fn+PurVrNNpsUPyxMP+OzdY7zO1rq4nb2
         BCrw==
X-Gm-Message-State: AJIora98edPHWPqUxDnseFJS6OumKBu20DkkilemdQd92hCJXUHuW1Tu
        bHTcdqVTRNjP7AfVn5bGvNwEBg==
X-Google-Smtp-Source: AGRyM1tJHk2vdawvBGjykM6agl14tlz78HVXz2hLMb3XQ16iJitcC29Z3972WLVMDJB2B9YK8kI/BA==
X-Received: by 2002:a63:dd43:0:b0:416:8be5:94d6 with SMTP id g3-20020a63dd43000000b004168be594d6mr8980723pgj.450.1657824234247;
        Thu, 14 Jul 2022 11:43:54 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 64-20020a620443000000b005289a50e4c2sm2049045pfe.23.2022.07.14.11.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:43:53 -0700 (PDT)
Date:   Thu, 14 Jul 2022 18:43:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Shrink pte_list_desc size when KVM is
 using TDP
Message-ID: <YtBj5noXqagqYBVs@google.com>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-4-seanjc@google.com>
 <Ys33RtxeDz0egEM0@xz-m1.local>
 <Ys37fNK6uQ+YTcBh@google.com>
 <Ys4Qx1RxmWrtQ8it@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys4Qx1RxmWrtQ8it@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022, Peter Xu wrote:
> On Tue, Jul 12, 2022 at 10:53:48PM +0000, Sean Christopherson wrote:
> > On Tue, Jul 12, 2022, Peter Xu wrote:
> > > On Fri, Jun 24, 2022 at 11:27:34PM +0000, Sean Christopherson wrote:
> > > Sorry to start with asking questions, it's just that if we know that
> > > pte_list_desc is probably not gonna be used then could we simply skip the
> > > cache layer as a whole?  IOW, we don't make the "array size of pte list
> > > desc" dynamic, instead we make the whole "pte list desc cache layer"
> > > dynamic.  Is it possible?
> > 
> > Not really?  It's theoretically possible, but it'd require pre-checking that aren't
> > aliases, and to do that race free we'd have to do it under mmu_lock, which means
> > having to support bailing from the page fault to topup the cache.  The memory
> > overhead for the cache isn't so significant that it's worth that level of complexity.
> 
> Ah, okay..
> 
> So the other question is I'm curious how fundamentally this extra
> complexity could help us to save spaces.
> 
> The thing is IIUC slub works in page sizes, so at least one slub cache eats
> one page which is 4096 anyway.  In our case if there was 40 objects
> allocated for 14 entries array, are you sure it'll still be 40 objects but
> only smaller?

Definitely not 100% positive.

> I'd thought after the change each obj is smaller but slub could have cached
> more objects since min slub size is 4k for x86.


> I don't remember the details of the eager split work on having per-vcpu

The eager split logic uses a single per-VM cache, but it's large (513 entries).

> caches, but I'm also wondering if we cannot drop the whole cache layer
> whether we can selectively use slub in this case, then we can cache much
> less assuming we will use just less too.
> 
> Currently:
> 
> 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> 
> We could have the pte list desc cache layer to be managed manually
> (e.g. using kmalloc()?) for tdp=1, then we'll at least in control of how
> many objects we cache?  Then with a limited number of objects, the wasted
> memory is much reduced too.

I suspect that, without implementing something that looks an awful lot like the
kmem caches, manually handling allocations would degrade performance for shadow
paging and nested MMUs.

> I think I'm fine with current approach too, but only if it really helps
> reduce memory footprint as we expected.

Yeah, I'll get numbers before sending v2 (which will be quite some time at this
point).
