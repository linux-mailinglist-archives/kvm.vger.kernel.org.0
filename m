Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07264642BC3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiLEPaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbiLEP3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:29:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A117ABF
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670254031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9UO7S0SWM1jnP4HZHZJz8sfF1M27ck2q1zdXWGwkxA4=;
        b=SAwO+d6fft3WMVsWvwgkgGptSeo0cM/vArnGq7jp7HuXNv81l9pCQyT6pIYnQhi6TyJk/j
        73W/u4nMKy4EKhDsOtpzVm0gQI/pCmQhlKy1TVLL+pbby8BMg3kyr60eaQgr4OSz0a1uy/
        19hFDxuNM2efc+CySiwpwkqDEpk/a6g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-R5O-JYeUN5SR_eXmuODKgQ-1; Mon, 05 Dec 2022 10:27:09 -0500
X-MC-Unique: R5O-JYeUN5SR_eXmuODKgQ-1
Received: by mail-qv1-f72.google.com with SMTP id og17-20020a056214429100b004c6ae186493so30592187qvb.3
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 07:27:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UO7S0SWM1jnP4HZHZJz8sfF1M27ck2q1zdXWGwkxA4=;
        b=Q2xQTWeOqK61L6kITuiMhNPkAYRp5C+UVhbrgtLbStAd4MyPJVY2VjNaMDdpIUy3ET
         S2YpNxlfo+9Bl5Zx+Pm3/6gcw9NnZqn0iVT/7lGUMGjuJkIYJM7cZOvrP6aL8NdfqEG1
         /SGU9ch8HA0oO8xD+rWN/viwa3kE4mHcvB0oWRI8B18Scl0DsNa5EQiIAPc8P0Ec7X/j
         BQZNFDcXNZEDtLWFfsBVQQsMaatRaHcugL4glUOuuOwsaCPA+MmQIg2sxrTK/RmYcdVk
         ZOuUxYy1n9GJa4ITT+WrAb+WTUQstqL1Qaf8W5e5EPctbBImKkcAvQxb0q8VUl5sjGLK
         L5Og==
X-Gm-Message-State: ANoB5plFpzxA2dPGLcZEf6CqOyrZ9bZpJRXzkhqJnG9CM8TVTGN2kqwY
        pu8FT1gP3X5brS731L3dxotM9OXe5OqvZfJ9UouDLBg7F8Ihkl4d0SY0reJ+foT2n0a9uXJafT4
        fLXyijuCWCr2a
X-Received: by 2002:ae9:e901:0:b0:6fa:165:131c with SMTP id x1-20020ae9e901000000b006fa0165131cmr57975073qkf.389.1670254028833;
        Mon, 05 Dec 2022 07:27:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UQwJaurj93pRN1ykjnmCPLyB4AIFdfikJt1EvgSHc1df5f39Dyz+8QoXsXQQcz1rC36pt8w==
X-Received: by 2002:ae9:e901:0:b0:6fa:165:131c with SMTP id x1-20020ae9e901000000b006fa0165131cmr57975044qkf.389.1670254028534;
        Mon, 05 Dec 2022 07:27:08 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bn36-20020a05620a2ae400b006fafaac72a6sm2213158qkb.84.2022.12.05.07.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:27:07 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:27:06 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y44NylxprhPn6AoN@x1n>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4qgampvx4lrHDXt@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 03, 2022 at 01:03:38AM +0000, Sean Christopherson wrote:
> On Thu, Dec 01, 2022, James Houghton wrote:
> > #1, however, is quite doable. The main codepath for post-copy, the
> > path that is taken when a vCPU attempts to access unmapped memory, is
> > (for x86, but similar for other architectures): handle_ept_violation
> > -> hva_to_pfn -> GUP -> handle_userfault. I'll call this the "EPT
> > violation path" or "mem fault path." Other post-copy paths include at
> > least: (i) KVM attempts to access guest memory via.
> > copy_{to,from}_user -> #pf -> handle_mm_fault -> handle_userfault, and
> > (ii) other callers of gfn_to_pfn* or hva_to_pfn* outside of the EPT
> > violation path (e.g., instruction emulation).
> > 
> > We want the EPT violation path to be fast, as it is taken the vast
> > majority of the time.
> 
> ...
> 
> > == Getting the faulting GPA to userspace ==
> > KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> > and it provides the main functionality we need. We can extend it
> > easily to support our use case here, and I think we have at least two
> > options:
> > - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> > KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> > otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> > -EFAULT).
> > - We're already introducing a new CAP, so just tie the above behavior
> > to whether or not one of the CAPs (below) is being used.
> 
> We might even be able to get away with a third option: unconditionally return
> KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
> guest memory.
> 
> > == Problems ==
> > The major problem here is that this only solves the scalability
> > problem for the KVM demand paging case. Other userfaultfd users, if
> > they have scalability problems, will need to find another approach.
> 
> It may not fully solve KVM's problem either.  E.g. if the VM is running nested
> VMs, many (most?) of the user faults could be triggered by FNAME(walk_addr_generic)
> via __get_user() when walking L1's EPT tables.
> 
> Disclaimer: I know _very_ little about UFFD.
> 
> Rather than add yet another flag to gup(), what about flag to say the task doesn't
> want to wait for UFFD faults?  If desired/necessary, KVM could even toggle the flag
> in KVM_RUN so that faults that occur outside of KVM ultimately don't send an actual
> SIGBUGS.
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 07c81ab3fd4d..7f66b56dd6e7 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>          * shmem_vm_ops->fault method is invoked even during
>          * coredumping without mmap_lock and it ends up here.
>          */
> -       if (current->flags & (PF_EXITING|PF_DUMPCORE))
> +       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
>                 goto out;

I'll have a closer read on the nested part, but note that this path already
has the mmap lock then it invalidates the goal if we want to avoid taking
it from the first place, or maybe we don't care?

If we want to avoid taking the mmap lock at all (hence the fast-gup
approach), I'd also suggest we don't make it related to uffd at all but
instead an interface to say "let's check whether the page tables are there
(walk pgtable by fast-gup only), if not return to userspace".

Because IIUC fast-gup has nothing to do with uffd, so it can also be a more
generic interface.  It's just that if the userspace knows what it's doing
(postcopy-ing), it knows then the faults can potentially be resolved by
userfaultfd at this stage.

>  
>         /*
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ffb6eb55cd13..4c6c53ac6531 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1729,7 +1729,7 @@ extern struct pid *cad_pid;
>  #define PF_MEMALLOC            0x00000800      /* Allocating memory */
>  #define PF_NPROC_EXCEEDED      0x00001000      /* set_user() noticed that RLIMIT_NPROC was exceeded */
>  #define PF_USED_MATH           0x00002000      /* If unset the fpu must be initialized before use */
> -#define PF__HOLE__00004000     0x00004000
> +#define PF_NO_UFFD_WAIT                0x00004000
>  #define PF_NOFREEZE            0x00008000      /* This thread should not be frozen */
>  #define PF__HOLE__00010000     0x00010000
>  #define PF_KSWAPD              0x00020000      /* I am kswapd */
> 

-- 
Peter Xu

