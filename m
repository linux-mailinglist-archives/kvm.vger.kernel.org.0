Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBA56430C3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiLESvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiLESvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:51:36 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADC31C41A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:51:34 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id i12so8838335qvs.2
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XB10lz0QsRjxLo2pbbY9hjkEwtxi6QdcCS8KNqwdFjM=;
        b=srFFNGm0Vqfsjysj03v3upOR/SxH0q3SyRMSCSv5leOyvmjpHcGdYZpBucA2Yg8NSU
         /M74vYI6eIubRN3KThGKGsxjamCtXZgFrs8sMNC5BEsS0dHC97uIhJpQLafrt4zixZEz
         FT1YT+pFHm2q7Q0ddFjI6gp32DLIUtbckL8+qF1ST2xUJfmXOpBkQFjj2aK+r2W5NjjB
         78E8vIFyjmvB1d970w3rtv0wGhbbB7S83YEx9NpzF+gDFn5C2hOn9+Plm0HIaWQAjenQ
         Y+UV6XkEt8xjzMciiN4a+g7D7amdD2+lLG9+WWiJyhebbroVc6vHlThTRZE/O9WCuS5U
         rfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XB10lz0QsRjxLo2pbbY9hjkEwtxi6QdcCS8KNqwdFjM=;
        b=hRdvQvBKEVeQ0804oX+KJl/Zwu15JbW8Iu3wpvRlOp/9fXXO9FPPGaIWS3UNxLZQuh
         pW6OwfoQ1+w12KBbeecKrl0vI4n3vw2Zs5LQPR/dg6xBrFI53+nFdnjzlHNfUOVShwWb
         aLQD6NwNcSWOnA0HPUmCA80DG6EBVdZjKEptizUxeO/EVvsnaeCdaXVDKrle3OqIpVo5
         1XMtUERmYgX2VeT8NNZcheuJ/eCviXRLcfFhyJMev4LYeGP/d81MEuQNWmADm4pcbhcz
         gNBttTQNBfX2XlNZWO0b6Zn1r6CbNOePec3opBEJLAUigCZMPhSKUI6u+nqeNamxUjJA
         pXOA==
X-Gm-Message-State: ANoB5pnvrTdTWtmb1u3wzMMvjXPWQer14rdWwbraaZlAdYKzVLPNEluZ
        tupKizbvUlQPb5kC+CmjBtPTcDAP2E1ntC716rtJxw==
X-Google-Smtp-Source: AA0mqf5L3yZ9yRFFO9MUhWxAJgXtvIEyXL+pf6sijvhqvES8UEBskCyc0CKlqmLc+H30OAG3zLlpVJWs2+vU+TzW3r4=
X-Received: by 2002:a0c:e6a9:0:b0:4bb:892a:fc11 with SMTP id
 j9-20020a0ce6a9000000b004bb892afc11mr58693006qvn.28.1670266293960; Mon, 05
 Dec 2022 10:51:33 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-2-vipinsh@google.com>
 <CANgfPd_sZoW6gRNgs44BbBu4RhwqNPjUO-=biJ++L5d8LpU3zg@mail.gmail.com> <Y4481WPLstNidb9X@google.com>
In-Reply-To: <Y4481WPLstNidb9X@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 5 Dec 2022 10:51:23 -0800
Message-ID: <CANgfPd_Ya0TeSBp5ipseA3fT1C0L3NPGSaZ=0ACjyKa_PvrZxA@mail.gmail.com>
Subject: Re: [Patch v2 1/2] KVM: x86/mmu: Allocate page table pages on TDP
 splits during dirty log enable on the underlying page's numa node
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, dmatlack@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 5, 2022 at 10:47 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Side topic, the shortlog is way, way too long.  The purpose of the shortlog is
> to provide a synopsis of the change, not to describe the change in detail.
>
> I also think this patch should be 2/2, with the more generic support added along
> with the module param (or capability) in 1/2.  E.g. to yield something like
>
>   KVM: x86/mmu: Add a module param to make per-vCPU SPTs NUMA aware
>   KVM: x86/mmu: Honor NUMA awareness for per-VM page table allocations
>
> On Mon, Dec 05, 2022, Ben Gardon wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 4736d7849c60..0554dfc55553 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -90,6 +90,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
> > >  static bool __read_mostly force_flush_and_sync_on_reuse;
> > >  module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> > >
> > > +static bool __read_mostly numa_aware_pagetable = true;
> > > +module_param_named(numa_aware_pagetable, numa_aware_pagetable, bool, 0644);
> > > +
> >
> > I'm usually all for having module params to control things, but in
> > this case I don't think it provides much value because whether this
> > NUMA optimization is useful or not is going to depend more on VM size
> > and workload than anything else. If we wanted to make this
> > configurable, a VM capability would probably be a better mechanism so
> > that userspace could leave it off when running small,
> > non-performance-sensitive VMs
>
> Would we actually want to turn it off in this case?  IIUC, @nid is just the
> preferred node, i.e. failure to allocate for the preferred @nid will result in
> falling back to other nodes, not outright failure.  So the pathological worst
> case scenario would be that for a system with VMs that don't care about performance,
> all of a nodes memory is allocated due to all VMs starting on that node.
>
> On the flip side, if a system had a mix of VM shapes, I think we'd want even the
> performance insensitive VMs to be NUMA aware so that they can be sequestered on
> their own node(s), i.e. don't "steal" memory from the VMs that are performance
> sensitive and have been affined to a single node.

Yeah, the only reason to turn it off would be to save memory. As a
strawman, if you had 100 1-vCPU VMs on a 2 node system, you'd have
4000 pages allocated in caches, doing nothing.

>
> > and turn it on when running large, multi-node VMs. A whole-host module
> > parameter seems overly restrictive.
