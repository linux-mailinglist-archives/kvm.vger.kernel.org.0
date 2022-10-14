Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9EF5FEBBB
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 11:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJNJfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 05:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJNJfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 05:35:36 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590B109D67
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 02:35:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so7410226pjg.1
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W72qU+VIW5XhUX7uAnZIVpuOffuQisEiiwK4cvRG0vU=;
        b=B9ME/S36KxBRTW5prTouAg9AKCdUX8Tw8YNjYsziP8yB91x6yiA47toBWLLiWtsGLI
         34pOrn+YJiLNY7QpKuTEJ664bbLnq5WqD5/3e0RnXhuwA5RYV1CxeuZJ+rnkUSCTvCJc
         CeFgzSy2B8UJsIcTBxKfHg93Kzh65ocunBLGM3Vju03U27NSJuNJ2SKqnNQOEOZvdYcK
         pdxL0oy3ZnESEAu3bkI1uokIv/bYhm4RNjgAJ8AbTfTXyLnbnYi8g7O5k/t1BCD2K0zi
         KZuetDlu4F4XzoYbqEh8A4Z81TH6leaug5RBlniKwls3xyYyYu4WwGGSepX6TabCzzMJ
         nXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W72qU+VIW5XhUX7uAnZIVpuOffuQisEiiwK4cvRG0vU=;
        b=Bo3Vhiq9fdFaUp3Ob2CuBVI2FUEMr44VXxTKISvXFnYSDoF/2CZqTfz2+1XgvcEBP2
         xYSETa6Hw+9/PfbJYB52Y9+bCwNPycHrOLaEk7cV6Ef0SUXieYJG9/Bdp0ZDT7CAQAEC
         MZkSE/CVDMb1CE41muXWmdG0qmMzoDY/aNfnjYehMB/oFNyBi7Ilb3qFmwzuuLUfB01m
         9kncG+QSV9JRH6g3nqtZ4mPdPAmNobNcfHthsCJsNWBfrQBdtye6sj8H5Zq3PjhXtlkK
         efZtmz7bnqi4WqcrnAYPTP6O5h0W559/9tvk4JcYqAS8SDVK9buKN5RF001ZxCwRqdT4
         Badg==
X-Gm-Message-State: ACrzQf2CZMkAFSgr/3QyWwDEKNXbI8mfSkrpoU9W8hsTMT1iL7atXo6R
        hh/4swIheelvt9rIIwsC7K8RvBZpWyGSPu60fVoi1w==
X-Google-Smtp-Source: AMsMyM5JTkM1AeJ9RQt3kUkKbZLzqh69dodlb7V1REpt+lPteLG7O67szgwid5ocSo1qHiAmpQ/sKjFR23AaBwSdvMk=
X-Received: by 2002:a17:902:e74f:b0:178:3af4:fb13 with SMTP id
 p15-20020a170902e74f00b001783af4fb13mr4214727plf.19.1665740133649; Fri, 14
 Oct 2022 02:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220819174659.2427983-1-vannapurve@google.com>
 <20220819174659.2427983-6-vannapurve@google.com> <Yz834mGQDtkdwn7q@google.com>
In-Reply-To: <Yz834mGQDtkdwn7q@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 14 Oct 2022 15:05:22 +0530
Message-ID: <CAGtprH_c+vhr8iBYYd7+BZtwzs_r6uFzxPyW1D3bHGhmHugcnA@mail.gmail.com>
Subject: Re: [RFC V3 PATCH 5/6] selftests: kvm: x86: Execute VMs with private memory
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        shuah@kernel.org, yang.zhong@intel.com, drjones@redhat.com,
        ricarkol@google.com, aaronlewis@google.com, wei.w.wang@intel.com,
        kirill.shutemov@linux.intel.com, corbet@lwn.net, hughd@google.com,
        jlayton@kernel.org, bfields@fieldses.org,
        akpm@linux-foundation.org, chao.p.peng@linux.intel.com,
        yu.c.zhang@linux.intel.com, jun.nakajima@intel.com,
        dave.hansen@intel.com, michael.roth@amd.com, qperret@google.com,
        steven.price@arm.com, ak@linux.intel.com, david@redhat.com,
        luto@kernel.org, vbabka@suse.cz, marcorr@google.com,
        erdemaktas@google.com, pgonda@google.com, nikunj@amd.com,
        diviness@google.com, maz@kernel.org, dmatlack@google.com,
        axelrasmussen@google.com, maciej.szmigiero@oracle.com,
        mizhang@google.com, bgardon@google.com
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

On Fri, Oct 7, 2022 at 1:47 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Aug 19, 2022, Vishal Annapurve wrote:
> > +/*
> > + * Execute KVM hypercall to change memory access type for a given gpa range.
> > + *
> > + * Input Args:
> > + *   type - memory conversion type TO_SHARED/TO_PRIVATE
> > + *   gpa - starting gpa address
> > + *   size - size of the range starting from gpa for which memory access needs
> > + *     to be changed
> > + *
> > + * Output Args: None
> > + *
> > + * Return: None
> > + *
> > + * Function called by guest logic in selftests to update the memory access type
> > + * for a given gpa range. This API is useful in exercising implicit conversion
> > + * path.
> > + */
> > +void guest_update_mem_access(enum mem_conversion_type type, uint64_t gpa,
> > +     uint64_t size)
>
> Provide wrappers to self-document what's going on, then the massive block comments
> go away.  And the guts of this and guest_update_mem_map() are nearly identical.
>
> Hmm, and we probably want to make it possible to do negative testing.
>
> Then the one-off enums for TO_PRIVATE and whatnot go way too.
>
> > +{
> > +     int ret = kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> MIN_PAGE_SHIFT,
>
> Needs an assert that @size is page aligned.  And since these are x86-64 specific,
> just use PAGE_SHIFT.  Huh, IS_ALIGNED() doesn't exist in selftests.  That should
> be added, either by pulling in align.h or by adding the generic macros to
> kvm_util_base.h.
>
> And then x86-64's processor.h can defined IS_PAGE_ALIGNED().
>
> E.g.
>
> static inline void __kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
>                                                  uint64_t flags)
> {
>         return = kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
> }
>
> static inline void kvm_hypercall_map_gpa_range(uint64_t gpa, uint64_t size,
>                                                uint64_t flags)
> {
>         int ret;
>
>         GUEST_ASSERT_2(IS_PAGE_ALIGNED(gpa) && IS_PAGE_ALIGNED(size), gpa, size);
>
>         ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
>         GUEST_ASSERT_1(!ret, ret);
> }
>
> static inline kvm_hypercall_map_shared(uint64_t gpa, uint64_t size)
> {
>         kvm_hypercall_map_gpa_range(gpa, size, KVM_CLR_GPA_RANGE_ENC_ACCESS);
> }
>
> static inline kvm_hypercall_map_private(uint64_t gpa, uint64_t size)
> {
>         kvm_hypercall_map_gpa_range(gpa, size, KVM_MARK_GPA_RANGE_ENC_ACCESS);
> }
>
> > +static void handle_vm_exit_map_gpa_hypercall(struct kvm_vm *vm,
> > +                             volatile struct kvm_run *run)
>
> Pass in @vcpu, not a vm+run.
>
> > +{
> > +     uint64_t gpa, npages, attrs, size;
> > +
> > +     TEST_ASSERT(run->hypercall.nr == KVM_HC_MAP_GPA_RANGE,
> > +             "Unhandled Hypercall %lld\n", run->hypercall.nr);
> > +     gpa = run->hypercall.args[0];
> > +     npages = run->hypercall.args[1];
> > +     size = npages << MIN_PAGE_SHIFT;
> > +     attrs = run->hypercall.args[2];
> > +     pr_info("Explicit conversion off 0x%lx size 0x%lx to %s\n", gpa, size,
> > +             (attrs & KVM_MAP_GPA_RANGE_ENCRYPTED) ? "private" : "shared");
> > +
> > +     if (attrs & KVM_MAP_GPA_RANGE_ENCRYPTED)
> > +             vm_update_private_mem(vm, gpa, size, ALLOCATE_MEM);
> > +     else
> > +             vm_update_private_mem(vm, gpa, size, UNBACK_MEM);
> > +
> > +     run->hypercall.ret = 0;
> > +}
> > +
> > +static void handle_vm_exit_memory_error(struct kvm_vm *vm, volatile struct kvm_run *run)
>
> Same  here, take a @vcpu.

Ack. Will address these comments in the next series.
