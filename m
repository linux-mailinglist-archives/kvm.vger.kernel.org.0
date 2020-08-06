Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B27C23DD6A
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgHFRJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729998AbgHFRGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:06:04 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45574C0617A9
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 10:04:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so35060079iow.11
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 10:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nC6PJfNXVU4vFSBxvbjKSl0ryoqOjAjd9RWGvuVHbDM=;
        b=oLZpvRf1kTJ4eibRUBcjxdeDvtdZOPtNEomtrXn5C94Hbs8Rj8dHrZnApxdRFEwjCl
         WBc8yQHq3KYajW40zb9qdXGQih4IRSt9uGsN29kdUUfkeijhhBhk6xJqY18RwkHQExnz
         En5loq1sNJvdr9jvuHobjEotIrsWjcIKsW/9iQLsjtEx4p2gHXPoyKfw1uUZjlnoMgEr
         cwfI76oogIyUiUU8qlY+Ugbn9lc35uMPWzQr+rfeC0c6wD3GxBi6pVfoIgQbJ8oLdNTa
         F4WcNsXK48XhtTQShEm/52gGR2owP8y3C7Uh7G0GJAgUeyMsrEVGHSwuLDZzOSVQ3qXj
         YEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nC6PJfNXVU4vFSBxvbjKSl0ryoqOjAjd9RWGvuVHbDM=;
        b=Po660+xtB+Xg8K12iIWcwOacf2T6ywjuYZNbQPMKFsy8UMRsMFuLcfA1XMtpmaWMLJ
         S6ZL33gLJBmFZZ6wTJ94vX0+Ll0GbNe4uLuTDHyJ/jK9AcsM69TFBeMovbgi7iqu8KQJ
         DTGrKIGpkwQFAI/q9OUIEtpRjHy0nn/3vtSUBh3gtzlMi44XNkZ1ktANoJLIt5hnFwIQ
         IyBD68NquEVMAWycfn3L5stzvboKDDDVvmn+n5us7eKnDQTR0qqomw7I23vbchi7n2CR
         tAkXzAx+nUBAuFHlXEnPTRUvZHfPh7DJggiDVJ3hIVLJBAq/EQ3T7+N7H+CRRQZdM9bA
         0FJA==
X-Gm-Message-State: AOAM532yaB5I4IkFz2QqZoQ9i2ZssHUkamRG6x+XA8jDWPGEDaGCD4qn
        OwEUUVjRthYuMoPuDUsXFEmQtHp2QuKCWX6dNoAI1LI1LlFzkg==
X-Google-Smtp-Source: ABdhPJzzfGB7YzJrZpItnSdv7H0n5425elbodoOWx8Z/hmcoLH46KhADWrSuaoJDJxAtjYKU+SpwKZ8kaLVmNy3x9qo=
X-Received: by 2002:a5d:80cb:: with SMTP id h11mr10901351ior.189.1596733449095;
 Thu, 06 Aug 2020 10:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200805141202.8641-1-yulei.kernel@gmail.com>
In-Reply-To: <20200805141202.8641-1-yulei.kernel@gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 6 Aug 2020 10:03:57 -0700
Message-ID: <CANgfPd_P_bjduGgS7miCp4BLUaDXBTYb9swC1gzxwYG2baWRVw@mail.gmail.com>
Subject: Re: [RFC 0/9] KVM:x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Yulei Zhang <yulei.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yuleixzhang@tencent.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 5, 2020 at 9:53 AM Yulei Zhang <yulei.kernel@gmail.com> wrote:
>
> From: Yulei Zhang <yuleixzhang@tencent.com>
>
> Currently in KVM memory virtulization we relay on mmu_lock to synchronize
> the memory mapping update, which make vCPUs work in serialize mode and
> slow down the execution, especially after migration to do substantial
> memory mapping setup, and performance get worse if increase vCPU numbers
> and guest memories.
>
> The idea we present in this patch set is to mitigate the issue with
> pre-constructed memory mapping table. We will fast pin the guest memory
> to build up a global memory mapping table according to the guest memslots
> changes and apply it to cr3, so that after guest starts up all the vCPUs
> would be able to update the memory concurrently, thus the performance
> improvement is expected.

Is a re-implementation of the various MMU functions in this series
necessary to pre-populate the EPT/NPT? I realize the approach you took
is probably the fastest way to pre-populate an EPT, but it seems like
similar pre-population could be achieved with some changes to the PF
handler's prefault scheme or, from user space by adding a dummy vCPU
to touch memory before loading the actual guest image.

I think this series is taking a similar approach to the direct MMU RFC
I sent out a little less than a year ago. (I will send another version
of that series in the next month.) I'm not sure this level of
complexity is worth it if you're only interested in EPT pre-population.
Is pre-population your goal? You mention "parallel memory
virtualization," does that refer to parallel page fault handling you
intend to implement in a future series?

There are a number of features I see you've chosen to leave behind in
this series which might work for your use case, but I think they're
necessary. These include handling vCPUs with different roles (SMM, VMX
non root mode, etc.), MMU notifiers (which I realize matter less for
pinned memory), demand paging through UFFD, fast EPT
invalidation/teardown and others.

>
> And after test the initial patch with memory dirty pattern workload, we
> have seen positive results even with huge page enabled. For example,
> guest with 32 vCPUs and 64G memories, in 2M/1G huge page mode we would get
> more than 50% improvement.
>
>
> Yulei Zhang (9):
>   Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
>     support
>   Introduce page table population function for direct build EPT feature
>   Introduce page table remove function for direct build EPT feature
>   Add release function for direct build ept when guest VM exit
>   Modify the page fault path to meet the direct build EPT requirement
>   Apply the direct build EPT according to the memory slots change
>   Add migration support when using direct build EPT
>   Introduce kvm module parameter global_tdp to turn on the direct build
>     EPT mode
>   Handle certain mmu exposed functions properly while turn on direct
>     build EPT mode
>
>  arch/mips/kvm/mips.c            |  13 +
>  arch/powerpc/kvm/powerpc.c      |  13 +
>  arch/s390/kvm/kvm-s390.c        |  13 +
>  arch/x86/include/asm/kvm_host.h |  13 +-
>  arch/x86/kvm/mmu/mmu.c          | 537 ++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.c          |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |  17 +-
>  arch/x86/kvm/x86.c              |  55 ++--
>  include/linux/kvm_host.h        |   7 +-
>  virt/kvm/kvm_main.c             |  43 ++-
>  10 files changed, 648 insertions(+), 65 deletions(-)
>
> --
> 2.17.1
>
