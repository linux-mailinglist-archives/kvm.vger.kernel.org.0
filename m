Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E384DE28B
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbiCRUbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiCRUbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:31:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766F02D7AAC
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:30:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so9299574pjl.4
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FVCHk1zWp8eim4nBsqqeQ8iwNhZBw4mfvm+aRrnbvoA=;
        b=iqJUrhPvONHqeiD0TBwXhkitap6OTovnZpAfQnfp6kB5hRpeTIelZGlr4XPv2BSaDe
         F91q+xGy7zfxGupIh8ZlD9PgT0UoPa9vStN4hS3tqGZ2PtMxXxrtD6l14WfES41GQaPs
         in7Rk0MKkvD47TDUKXc2cERmULhBGrC0kc4hXCucq6dU/qShK3dq9RPvq986fjtGFK49
         6IkwDMe6sY/xERF0y5ZTBB49FAhaXTuVzWZaDE5rqtJjQwLPsod+X6fPCiz32u1/8k2W
         DPmxigueJtLWe08qUNe9VFVuTFDpxPLTBN7r7tr4FsUwApgh+pC2vrBwFrd0/OYtNQoT
         fTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FVCHk1zWp8eim4nBsqqeQ8iwNhZBw4mfvm+aRrnbvoA=;
        b=5zg1tJg9XDwaxJ+kXCkm6K/pIWMNx/VsVBpaAsne3lz+vyxPI4gZFIAVqDZzdQvq49
         X64qgBWPRI5ME2lks+Uf1LoVPHm7HSqkljcG4nj2yZFdoq4uIUefjXco4v83HJHLR+zL
         jjjDTa4nz+8KT0MMGuqmFcH9Gh8Klt62t5Cfeza21z4wcaQRg5XovsCFyQ1Lf7fSQCf7
         94ZRZ8sJHNazdU5vPx1kWSUrd+TwHPW0mjWQ3ncOtJibyrDH7ZPTxP69o2x95DwzBdsP
         O/lxzAnIV5gw2iejR0GEas3NlDbxEpR+W+HsMM88Z0cqHAp3IswTvGEg9jDIPlsdWUFK
         Qu7A==
X-Gm-Message-State: AOAM532sRFgf8ysnRzzTqP8PJCgNfhcu4ZYUdAR0JZUk1xcGopr3h0AA
        TMGhgCBdy/9vus3ae1hPH7p6RQ==
X-Google-Smtp-Source: ABdhPJzcO6Xwud7tPt4mS4MdVcpJlHQFaYSkJVhqhN/l8RGRASuCh9nddyYC3yiPE7Ss3+zKbGuK9Q==
X-Received: by 2002:a17:90b:3b50:b0:1c6:66d3:94d9 with SMTP id ot16-20020a17090b3b5000b001c666d394d9mr13183319pjb.140.1647635411717;
        Fri, 18 Mar 2022 13:30:11 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004f6ff260c9dsm11016119pfk.154.2022.03.18.13.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:30:11 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:30:07 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <YjTrz40SD3HmebBh@google.com>
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-3-ricarkol@google.com>
 <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
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

On Wed, Mar 16, 2022 at 12:08:23PM -0600, Ben Gardon wrote:
> On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a library function to get the backing source FD of a memslot.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> This appears to be dead code as of this commit, would recommend
> merging it into the commit in which it's actually used.

I was trying to separate lib changes (which are mostly arch independent)
with the actual test. Would move the commit to be right before the one
that uses be better? and maybe add a commit comment mentioning how it's
going to be used.

> 
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
> >  2 files changed, 24 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 4ed6aa049a91..d6acec0858c0 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
> >  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> >  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
> >  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
> >  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
> >  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
> >  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index d8cf851ab119..64ef245b73de 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
> >         return &region->region;
> >  }
> >
> > +/*
> > + * KVM Userspace Memory Get Backing Source FD
> > + *
> > + * Input Args:
> > + *   vm - Virtual Machine
> > + *   memslot - KVM memory slot ID
> > + *
> > + * Output Args: None
> > + *
> > + * Return:
> > + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> > + *
> > + * Returns the backing source fd of a memslot, so tests can use it to punch
> > + * holes, or to setup permissions.
> > + */
> > +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> > +{
> > +       struct userspace_mem_region *region;
> > +
> > +       region = memslot2region(vm, memslot);
> > +       return region->fd;
> > +}
> > +
> >  /*
> >   * VCPU Find
> >   *
> > --
> > 2.35.1.723.g4982287a31-goog
> >
