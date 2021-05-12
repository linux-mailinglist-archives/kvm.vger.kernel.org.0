Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E6B37F053
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 02:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhEMAXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 20:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhEMAXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 20:23:03 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BDDC035431
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:58:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id j12so13527975pgh.7
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 16:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fBeZiHSroHCA0AHxTWkdEHWAZk+ZdrTZZucuCIgP8Bs=;
        b=SVYkyc1aY1BgfeSpf/utpVtPeuSNxwrEKKDYOcKZ49rgapj6USnKktoOsSHRJkAJWY
         NSwU1NsU2OmQdbw8gd728mnYLlV63nzzcx2/f9Giby3jQHDT5oQfK3idKwSxy6psVcio
         CqILIxNCQ11YkRbFSXEyxnEEbFhf0ElRx41EEmJxN2Jfrxk8pc3+f15KvmV77dJUnztT
         RSd0A8U8E/+mNT8W3Sqio+DMlt/XhVwyPduWhZ/F783pmnmtqNSRhzk+Ou2UmrO0XfRl
         6N7OAgwIhkRmNAIcaWrTAlkc2cfSEsR6E1/OpW/U22DvP38NECZq5x/FOD6k8eLmXOio
         x+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fBeZiHSroHCA0AHxTWkdEHWAZk+ZdrTZZucuCIgP8Bs=;
        b=YEerXeMchN2yvrCrxmEtanI9o4eo2JwHaZOJPbhkvCzUOz3ad71yLwREdJHMpUBQF+
         n9LJko5KQA6MIf7JBvBj/k6um8Sk07tSf/HwSg+w+Nuj60CvyKfIRCygIy72xDKrqfqi
         7IHdjb6sBPytkUJKYwP4wHVPlBDFl64pmTwPU4OokkWdHWCP1+v0oNZOWU6563GPnd5g
         6hqTVrd4Nxtp1hkiJFjqDNDrPWA9rpn7jkDANxriifZks12JrwgMqPaNXLm1sRvyzcdk
         pDNBSdR8zUfeDgeuVe8ch+oKC9WLtLIIaO42aDx+EmRHTzAiGR+V8wrDIbc5VYibQbBO
         9g3g==
X-Gm-Message-State: AOAM530BY7WcDt8stxUbMWrfLU+9ujlf/63EwjdhBhNo84xhAuaokbe1
        yyd4T00WcLrGo7Kl/ucXriI+IA==
X-Google-Smtp-Source: ABdhPJweDUbIQTmPn54zQGHe4eVzEbNXUwp/h7jdBJ6xevizYah+dXtVnzInxtGweFqnzxFTY49RxQ==
X-Received: by 2002:a17:90b:4d08:: with SMTP id mw8mr1270613pjb.202.1620863924660;
        Wed, 12 May 2021 16:58:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b2sm5273827pji.28.2021.05.12.16.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:58:43 -0700 (PDT)
Date:   Wed, 12 May 2021 23:58:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] KVM: Scalable memslots implementation
Message-ID: <YJxrsI89kdiM5Dk2@google.com>
References: <cover.1618322001.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618322001.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Grr, this entire series got autobinned into my spam folder, which I obviously
don't check very often.  I won't be able to take a look until next week at the
earliest, any chance you'd want to rebase to the latest kvm/queue and spin v3?
The rebase will probably be a bit painful, but on the plus side the majority of
the arch specific changes will disappear now that walking the memslots for the
MMU notifiers is done in common code.

>  arch/arm64/kvm/Kconfig              |   1 +
>  arch/arm64/kvm/mmu.c                |  20 +-
>  arch/mips/kvm/Kconfig               |   1 +
>  arch/mips/kvm/mmu.c                 |  12 +-
>  arch/powerpc/kvm/Kconfig            |   1 +
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |  16 +-
>  arch/powerpc/kvm/book3s_64_vio.c    |   2 +-
>  arch/powerpc/kvm/book3s_64_vio_hv.c |   2 +-
>  arch/powerpc/kvm/book3s_hv.c        |   3 +-
>  arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>  arch/powerpc/kvm/book3s_pr.c        |  12 +-
>  arch/s390/kvm/Kconfig               |   1 +
>  arch/s390/kvm/kvm-s390.c            |  66 +---
>  arch/s390/kvm/kvm-s390.h            |  15 +
>  arch/s390/kvm/pv.c                  |   4 +-
>  arch/x86/include/asm/kvm_host.h     |   2 +-
>  arch/x86/kvm/Kconfig                |   1 +
>  arch/x86/kvm/mmu/mmu.c              |  78 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c          |  15 +-
>  arch/x86/kvm/x86.c                  |  18 +-
>  include/linux/kvm_host.h            | 139 ++++---
>  virt/kvm/kvm_main.c                 | 592 ++++++++++++++++------------
>  23 files changed, 603 insertions(+), 416 deletions(-)
> 
