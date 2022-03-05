Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4EE4CE18C
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 01:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiCEAfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 19:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiCEAfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 19:35:24 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F821A88BB
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 16:34:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p8so8945299pfh.8
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 16:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9awKCCKzwQ2dqbJt0HhmYBsF/X0J7+H0Zf6OyrcVwwk=;
        b=cIYwKZlXga7k55pJ6Hx6u3E1O0qMOeX9MtZ4QnhaaFbVj+Gwocpw7HAw2uXKckeyNg
         N62ebYTAV747rJvVn2IYd5Aa4qEuDijsdldXC6LBdXSFG1gaEwhmXj5u+V4C9Uv7i05W
         vcBM/WJyq/aqsH92E03REjyFnzq9/5xoOD2sk3jWlL74SFl7tJLknUpHVJFeHP9X8316
         PamGMns78nhhhAN3MT6u+RF631p/F6vL32h7EAst1BR/MyuvxQSz082tcW8Jnr/Lu1Q0
         vSLLAjS3b8zIRNMffiygjUSiKEZGO4qtL9X/CCbDprfU5GuKuBIq9KnMUoHzhyo5NDbv
         JCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9awKCCKzwQ2dqbJt0HhmYBsF/X0J7+H0Zf6OyrcVwwk=;
        b=0fqWeCaKOKiXsk+f1KvbZ41O2CTAmTqUXuA1gW7c0/xvX6r/QT9BavfngAbvlLE/m4
         om0lf+uvQR0/HlQY8wKxxZAIkGuVd1QrGbR+yV7dtmM2Xil+7ENmMLvNL69co3xwR4F8
         hw0xCT6MJIcOt3HiP05rLrI6pifYssJUmIwkn4ADev3nzJE9NHny5zfyxsnrbdiUndHD
         LQ53c/H9xzjh70jqH2to7EYlyzCL8erh3SexaTrQOftPpC4glNciQpCXIjhk6t77eo4U
         vMhEXXTdbxleP6zIdZOiAo6LuYb13Mxw00eJRVCUjVZPx7wOMSwQsVKIMzHy495GYhdN
         kb1w==
X-Gm-Message-State: AOAM532aAGaPRpl8ZXadknD0JbvKxXTjLSeylKJRBrBdBoorRm2bXW4r
        yLYCZMc6sNnGpK2CyxB6v1IZUw==
X-Google-Smtp-Source: ABdhPJy8buS111AF6pUAsQWsQEoRwPURB2GdQ8KHQizCtZYGIDUkTVBDQTzXcgK+8pA8eE3GlkQrbg==
X-Received: by 2002:a63:8349:0:b0:37d:5e5e:a535 with SMTP id h70-20020a638349000000b0037d5e5ea535mr799884pge.158.1646440475381;
        Fri, 04 Mar 2022 16:34:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s7-20020a056a00178700b004e1a15e7928sm7730995pfg.145.2022.03.04.16.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 16:34:34 -0800 (PST)
Date:   Sat, 5 Mar 2022 00:34:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiKwFznqqiB9VRyn@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
 <YiExLB3O2byI4Xdu@google.com>
 <YiEz3D18wEn8lcEq@google.com>
 <eeac12f0-0a18-8c63-1987-494a2032fa9d@redhat.com>
 <YiI4AmYkm2oiuiio@google.com>
 <8b8c28cf-cf54-f889-be7d-afc9f5430ecd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b8c28cf-cf54-f889-be7d-afc9f5430ecd@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> On 3/4/22 17:02, Sean Christopherson wrote:
> > On Fri, Mar 04, 2022, Paolo Bonzini wrote:
> > > On 3/3/22 22:32, Sean Christopherson wrote:
> > > I didn't remove the paragraph from the commit message, but I think it's
> > > unnecessary now.  The workqueue is flushed in kvm_mmu_zap_all_fast() and
> > > kvm_mmu_uninit_tdp_mmu(), unlike the buggy patch, so it doesn't need to take
> > > a reference to the VM.
> > > 
> > > I think I don't even need to check kvm->users_count in the defunct root
> > > case, as long as kvm_mmu_uninit_tdp_mmu() flushes and destroys the workqueue
> > > before it checks that the lists are empty.
> > 
> > Yes, that should work.  IIRC, the WARN_ONs will tell us/you quite quickly if
> > we're wrong :-)  mmu_notifier_unregister() will call the "slow" kvm_mmu_zap_all()
> > and thus ensure all non-root pages zapped, but "leaking" a worker will trigger
> > the WARN_ON that there are no roots on the list.
> 
> Good, for the record these are the commit messages I have:
> 
>     KVM: x86/mmu: Zap invalidated roots via asynchronous worker
>     Use the system worker threads to zap the roots invalidated
>     by the TDP MMU's "fast zap" mechanism, implemented by
>     kvm_tdp_mmu_invalidate_all_roots().
>     At this point, apart from allowing some parallelism in the zapping of
>     roots, the workqueue is a glorified linked list: work items are added and
>     flushed entirely within a single kvm->slots_lock critical section.  However,
>     the workqueue fixes a latent issue where kvm_mmu_zap_all_invalidated_roots()
>     assumes that it owns a reference to all invalid roots; therefore, no
>     one can set the invalid bit outside kvm_mmu_zap_all_fast().  Putting the
>     invalidated roots on a linked list... erm, on a workqueue ensures that
>     tdp_mmu_zap_root_work() only puts back those extra references that
>     kvm_mmu_zap_all_invalidated_roots() had gifted to it.
> 
> and
> 
>     KVM: x86/mmu: Zap defunct roots via asynchronous worker
>     Zap defunct roots, a.k.a. roots that have been invalidated after their
>     last reference was initially dropped, asynchronously via the existing work
>     queue instead of forcing the work upon the unfortunate task that happened
>     to drop the last reference.
>     If a vCPU task drops the last reference, the vCPU is effectively blocked
>     by the host for the entire duration of the zap.  If the root being zapped
>     happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
>     being active, the zap can take several hundred seconds.  Unsurprisingly,
>     most guests are unhappy if a vCPU disappears for hundreds of seconds.
>     E.g. running a synthetic selftest that triggers a vCPU root zap with
>     ~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
>     Offloading the zap to a worker drops the block time to <100ms.
>     There is an important nuance to this change.  If the same work item
>     was queued twice before the work function has run, it would only
>     execute once and one reference would be leaked.  Therefore, now that
>     queueing items is not anymore protected by write_lock(&kvm->mmu_lock),
>     kvm_tdp_mmu_invalidate_all_roots() has to check root->role.invalid and
>     skip already invalid roots.  On the other hand, kvm_mmu_zap_all_fast()
>     must return only after those skipped roots have been zapped as well.
>     These two requirements can be satisfied only if _all_ places that
>     change invalid to true now schedule the worker before releasing the
>     mmu_lock.  There are just two, kvm_tdp_mmu_put_root() and
>     kvm_tdp_mmu_invalidate_all_roots().

Very nice!
