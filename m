Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CBD52A439
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348294AbiEQOEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346408AbiEQOEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:04:45 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB5543AC2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:04:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so2596989pjb.0
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FL8Ln+qoBhX9Z9FzXxUqdcLvxSZEspo40DkXeEXhtoc=;
        b=JaoGHjtrtmahXTjOEk2a2EB4qunemIRJYfJ5tpCsscKfgRqLqN/Z7hJ369fh3UUdOF
         ui7KgZXcB83KE7l4oo/LITOB78y7n5hsj7ayEtp5IVpIVNaW1jb0FHR92R9VZiUe5EF7
         TJHHWfycpEo/mb+f2n2c/h6x3OfmWKpLhypxDemrTm+1B3pFFjv9jdc7u5eYiu4NQoaW
         5eOd2T5hm5QdCEkC0oJNGroSW3uKegHK9ib3SBkWzdCeo6O6uyIojKc2pLC/vRZfe1Ow
         Vsgsun3kdtvd+v6HRJBBhE1Ko2ylHo0wRbA3PBE06QkaiA2AaKziUM4wvbQWKfLojZ6E
         FyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FL8Ln+qoBhX9Z9FzXxUqdcLvxSZEspo40DkXeEXhtoc=;
        b=veQaV9eOny2Jc2MEgz7nprKgfhpXR/T7dyVWeTx6Jcuujs6jSfKAc8dv3wDPV1a8A9
         liA8guhpaQf2pQzv1ZgKaMGTFKgLU8/xaH7Z/sg+7e9podgDap/1yZCtIBU3qVEI4Cby
         D6Hqj4/57l5dO+MhyKKGzX4tTLDV0eEUKrTMsHWP0N31CA79S+87jhppkUHsLhr3Ch1p
         gV6PSfwJ/bKx5wUxfAEKOkVmK+RRcWgMO+Uf0oNMXl+WhJtRu3Erik7lfWzdeZ+s017w
         Ad4/6XKHKGXFnE0iwvZlWprpN9v8Br5E5TtSzO1/BIO83EVdnSNLz2dXcVayYJLwEqq9
         EHpA==
X-Gm-Message-State: AOAM532+T72Gfe6YnykdHyRRgMei+ra8SOOjf7bY7IJTQk2tAPJQMAP/
        8QUhjpInZU0A40HxQmFOIx71HA==
X-Google-Smtp-Source: ABdhPJwmn22f1sBhUOHh7YAS6Vi2ghXPT3IC1P1JAdjnNQBZ3qawrb+j203LVSupTRggD/UU9gWRRg==
X-Received: by 2002:a17:903:2308:b0:15f:3797:a755 with SMTP id d8-20020a170903230800b0015f3797a755mr22473094plh.122.1652796281822;
        Tue, 17 May 2022 07:04:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cm17-20020a17090afa1100b001d954837197sm1684392pjb.22.2022.05.17.07.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 07:04:39 -0700 (PDT)
Date:   Tue, 17 May 2022 14:04:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/34] KVM: x86: hyper-v: Use preallocated buffer in
 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
Message-ID: <YoOrc2hPF/QpJNeo@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-12-vkuznets@redhat.com>
 <YoKunaNKDjYx7C21@google.com>
 <87k0akuv1o.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0akuv1o.fsf@redhat.com>
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

On Tue, May 17, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Apr 14, 2022, Vitaly Kuznetsov wrote:
> >> To make kvm_hv_flush_tlb() ready to handle L2 TLB flush requests, KVM needs
> >> to allow for all 64 sparse vCPU banks regardless of KVM_MAX_VCPUs as L1
> >> may use vCPU overcommit for L2. To avoid growing on-stack allocation, make
> >> 'sparse_banks' part of per-vCPU 'struct kvm_vcpu_hv' which is allocated
> >> dynamically.
> >> 
> >> Note: sparse_set_to_vcpu_mask() keeps using on-stack allocation as it
> >> won't be used to handle L2 TLB flush requests.
> >
> > I think it's worth using stronger language; handling TLB flushes for L2 _can't_
> > use sparse_set_to_vcpu_mask() because KVM has no idea how to translate an L2
> > vCPU index to an L1 vCPU.  I found the above mildly confusing because it didn't
> > call out "vp_bitmap" and so I assumed the note referred to yet another sparse_banks
> > "allocation".  And while vp_bitmap is related to sparse_banks, it tracks something
> > entirely different.
> >
> > Something like?
> >
> > Note: sparse_set_to_vcpu_mask() can never be used to handle L2 requests as
> > KVM can't translate L2 vCPU indices to L1 vCPUs, i.e. its vp_bitmap array
> > is still bounded by the number of L1 vCPUs and so can remain an on-stack
> > allocation.
> 
> My brain is probably tainted by looking at all this for some time so I
> really appreciate such improvements, thanks :)
> 
> I wouldn't, however, say "never" ('never say never' :-)): KVM could've
> kept 2-level reverse mapping up-to-date:
> 
> KVM -> L2 VM list -> L2 vCPU ids -> L1 vCPUs which run them
> 
> making it possible for KVM to quickly translate between L2 VP IDs and L1
> vCPUs. I don't do this in the series and just record L2 VM_ID/VP_ID for
> each L1 vCPU so I have to go over them all for each request. The
> optimization is, however, possible and we may get to it if really big
> Windows VMs become a reality.

Out of curiosity, is L1 "required" to provides the L2 => L1 translation/map?
