Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E79D3B2050
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 20:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFWSbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFWSbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 14:31:38 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E41C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:29:20 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id s23so4346368oiw.9
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYHrGTC3a+TqzndzZD+u5HI/qQGjEDtBrwf4IIOjVpc=;
        b=BiVfxgiCIq2RxLoQpd7S7dkCTcu1xTw2fQeBWRTjRkQDSBhKdKImTub0Y5Oh8klQCJ
         ehfKpoeDIlEI4fhyf4mN6c9YLPkvnK653/qhRKRojgbq4Hjam0QAZsxfpFjuzr1AmzoB
         zxrj4x9XvcZefmyJU29MteOHarcyCXGxCi5DthOrNf9g+te2X2YjME6buhuAf5lvmmMt
         gETBRmWaKW5r6UKjV+E9s8BkAUKZgInkD6CPhDU2dSfcn5fE9qcwrnbbd7t+MpJJ1WCz
         5e3xnd0rlx/8McyRa/2Rgh2y1zmqyi1MW0xZmpjXxDqunJ8hnMtirU7phYOHeginJFgp
         hhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYHrGTC3a+TqzndzZD+u5HI/qQGjEDtBrwf4IIOjVpc=;
        b=rkl3uUZkWmLrMhbHZ4C5niLy0Mk63fTgmCB6KAtu60345oUiEBm7dd95rxJ4Fi3QW0
         CNivWVSZD9uS4zl8nQ2gCxxVLSP0jaYe7oACEJ5IemD4hRXnvzqAVrSpWsVWeu/G18H4
         RTZCGQfid0enLzW6kIgx0G/MYUI3M+YmLre7l2s/y0HB2X1N9hlKnU3BtreAiMvIJfxJ
         8RTVb0Ysi0UlUao96m16/qJDFCUNRsV09eyvCw+oTXvZHuKhmMbxGWOg7nr2k+ooKPcq
         JveezrSHR1PUolFKuIC+NnKyiFUksMoa1KdiQwb9riqtGoFvjQm7iltrRf+a+jIe3I1i
         eIpw==
X-Gm-Message-State: AOAM5329o06qeAzdXo4QIshAQkEVHaDzHKV/EVc8Jb2n6amimBJse/4F
        djKORp1f4CQ7FQEzIXMd0+hvG11SPP5QWg+hQRmr8g==
X-Google-Smtp-Source: ABdhPJzqtXmD0CSzJKDp3W4V6JjmPyfhXL981msUvh7ZJeQym8HBwaKcceP2WqToojtofT4BPj2woTWb2WMzpsr4ZNI=
X-Received: by 2002:a54:4586:: with SMTP id z6mr4270825oib.6.1624472959242;
 Wed, 23 Jun 2021 11:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210510081535.94184-1-like.xu@linux.intel.com> <20210510081535.94184-5-like.xu@linux.intel.com>
In-Reply-To: <20210510081535.94184-5-like.xu@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Jun 2021 11:29:08 -0700
Message-ID: <CALMp9eQG+JLnHe4zRKg0sHtxynSiGGKPw--5J+cY2-f3QWRW2A@mail.gmail.com>
Subject: Re: [RESEND PATCH v4 04/10] KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL
 emulation for Arch LBR
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 1:16 AM Like Xu <like.xu@linux.intel.com> wrote:
>
> Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
> When guest Arch LBR is enabled, a guest LBR event will be created like the
> model-specific LBR does.
>
> On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> meaning. It can be written to 0 or 1, but reads will always return 0.
> Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/lbr.c      |  2 --
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/include/asm/vmx.h       |  2 ++
>  arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c           |  9 +++++++++
>  5 files changed, 38 insertions(+), 7 deletions(-)
>
Same comments as on the previous patch. Your guard for ensuring that
the new VMCS fields exist can be spoofed by a malicious userspace, and
the new MSR has to be enumerated by KVM_GET_MSR_INDEX_LIST.
