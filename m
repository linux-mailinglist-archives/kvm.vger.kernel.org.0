Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686143899AB
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhESXLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhESXLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:11:47 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8ECC061574
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:10:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t4so7924133plc.6
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oLNKZ8BT/+g25UXYUPWcARZoCeNOnhBsPdzQOaLwiCk=;
        b=UxgEQy9cozLEBwXBB9C1OsO717JUEHwYIOjLdEHyJyqa3ELI3WBrgj7TA/N/vn2u49
         8NryrbLHgZiqEJSkHWagnVdhg/l7e3xAO3rA9qGBk6KYIHwV1YzzuN5M73/g/vsl6eLU
         UuX8tGaMdM3DeSgnF4E3v5gMSzlJXHiXT3Zxa98b3h4+3nd0exPD83Maovd8fI3w7u3I
         j4M7RIlLK+hz/S6Pqxg3pziDSKoQnpOAzrUKh7mRpkU40B6cvlWbkIppSkODvnpqwFfi
         EZiSF/oAA+U8y+6QVWsuxYTYdqDqUiYiT0qr2N8AeIQ0yBloeV8hBdp29WB2FnAHCe1+
         bp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oLNKZ8BT/+g25UXYUPWcARZoCeNOnhBsPdzQOaLwiCk=;
        b=EmrbDVOsoxOlxXgAsQoCObW/Zof+lRbKzPzKmeZtTW7iNH5/SXRTd1BOn5SpbRPsj/
         0k4a0R36/NrBmeZItUTdnLBDr6dLETGoXs/ekWzdKX98dr7L9Gv3hx89o9VD7R3gLswS
         axmN5tDP+iiCM1vjYqomvkkyzp2urnHnfwlL1zYvXtxB7YQeM8cgyddm0j5wVkjt+ELH
         kgPLMK4/Re1lqnztXl7A+HflmBzK07xQ26B+PqxEPwYvoiauI7E0hkj4m7GB1zq7ZsCf
         rD6Kd99fZO7UbQDHX9MdBjZYgWLwO6mbFsrAuVzXICQZUeAvXcaF52Wdj6ByV+CwB1PE
         3DtQ==
X-Gm-Message-State: AOAM531FegAL2Sfzh0ca6h89RCA+6GCPYv7WTPmoueVC9Ky1ttGaX6qh
        U2M9AwU+HNRuqyDW2IOLrC1kuQ==
X-Google-Smtp-Source: ABdhPJxUgfVmGrLQKksmduJnpAI0uypVZRDWAD8eR46AZprtxqQxCBnWEj75HEfhZIqjNEmzqJChkg==
X-Received: by 2002:a17:902:c112:b029:f0:d571:8fb0 with SMTP id 18-20020a170902c112b02900f0d5718fb0mr2243218pli.11.1621465826064;
        Wed, 19 May 2021 16:10:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n23sm357456pff.93.2021.05.19.16.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:10:25 -0700 (PDT)
Date:   Wed, 19 May 2021 23:10:22 +0000
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
Subject: Re: [PATCH v3 6/8] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YKWa3nsKPgoM5yIJ@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

...

>  arch/arm64/kvm/mmu.c                |   8 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
>  arch/powerpc/kvm/book3s_hv.c        |   3 +-
>  arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>  arch/s390/kvm/kvm-s390.c            |  27 +-
>  arch/s390/kvm/kvm-s390.h            |   7 +-
>  arch/x86/kvm/mmu/mmu.c              |   4 +-
>  include/linux/kvm_host.h            | 100 ++---
>  virt/kvm/kvm_main.c                 | 580 ++++++++++++++--------------
>  10 files changed, 379 insertions(+), 372 deletions(-)

I got through the easy ones, I'll circle back to this one a different day when
my brain is fresh :-)
