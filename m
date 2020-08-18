Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1E3247E77
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 08:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHRGbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 02:31:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgHRGbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 02:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597732274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KmRLPfSWkEBQgpTHY9W7Qe7QZ1EnQbdh33fVf10hkAI=;
        b=fVJvLuBSYcc8thQPfHnYC0H0Xdh6O7LaXKOy2+X9GJKvz/wcYNRVC7Fs8wwpA680xesEXC
        ga24Zt33F7LrZUkul5QKjvQRJjyBKb3tXiadWrktU+shh9h18y9VZLlAvyFXngPPAMABh6
        FHXtqMw0dNtnbH2qjPo13GfZp4pESgo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-0o4pej-aOVmfunc8mfT5bg-1; Tue, 18 Aug 2020 02:31:11 -0400
X-MC-Unique: 0o4pej-aOVmfunc8mfT5bg-1
Received: by mail-wr1-f72.google.com with SMTP id o10so7832801wrs.21
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 23:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KmRLPfSWkEBQgpTHY9W7Qe7QZ1EnQbdh33fVf10hkAI=;
        b=DIVKG+maDGQd/9jMlUW+qDXqdJQ0KLy0eKnd011gYVYizgCFIo5xzFWnZkCT4kluN9
         2/54zk/SC95BIXhxZwKxXo/JMZms9+C9sRenUpjTAMhFTmloYawqVHrpKPAkEe+TRRe0
         lK9WbO2/TISg6R6uUrUCgU5hqu3AOsVxu4C3O8Lp/tZJsbict4kXpK6/dpu1tWiQy3SD
         9Jwsa2eBUeWu5WVZtGSE4RrZhEZJyLiRRCe4SdsQWyzj8M8ACLHe8ouytLyIRXGlsmVy
         k2dWIM8kC3aLl2qtiE8ZWuR7J3fJVpgxNmZiSeCs1r2ij1BpvtlEMK1GNYb3VutOGtlQ
         24lg==
X-Gm-Message-State: AOAM533fGaOQL5Ghoejm+iBmTIf4dH0w5+Jb7rulmFiM9S7+eetlCxZ8
        ivQCHO6tsw7LBd23HdegaTwl95SIGRSJy8Q7Ui3GW7+Lc3n9DrLnUj955b7U6R7sy9ZBiETd/9b
        cKj6GEY1utwdI
X-Received: by 2002:adf:df89:: with SMTP id z9mr18730292wrl.395.1597732270033;
        Mon, 17 Aug 2020 23:31:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPB8f/uccX694hKHkN5+J5pWk6Dx0FQTiyjeONl3Wl6YBHXs3vqZafBJ+p7LBVG4M6e7mTNA==
X-Received: by 2002:adf:df89:: with SMTP id z9mr18730262wrl.395.1597732269719;
        Mon, 17 Aug 2020 23:31:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id b203sm32630286wmc.22.2020.08.17.23.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 23:31:08 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
To:     Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200811102725.7121-1-will@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff1d4de2-f3f8-eafa-6ba5-3e5bb715ae05@redhat.com>
Date:   Tue, 18 Aug 2020 08:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200811102725.7121-1-will@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/20 12:27, Will Deacon wrote:
> Hi all,
> 
> While stress-testing my arm64 stage-2 page-table rewrite [1], I ran into
> a sleeping while atomic BUG() during OOM that I can reproduce with
> mainline.
> 
> The problem is that the arm64 page-table code periodically calls
> cond_resched_lock() when unmapping the stage-2 page-tables, but in the
> case of OOM, this occurs in atomic context.
> 
> These couple of patches (based on 5.8) propagate the flags from the MMU
> notifier range structure, which in turn indicate whether or not blocking
> is permitted.
> 
> Cheers,
> 
> Will
> 
> [1] https://android-kvm.googlesource.com/linux/+/refs/heads/topic/pgtable
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> --->8
> 
> Will Deacon (2):
>   KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
>   KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
> 
>  arch/arm64/include/asm/kvm_host.h   |  2 +-
>  arch/arm64/kvm/mmu.c                | 19 ++++++++++++++-----
>  arch/mips/include/asm/kvm_host.h    |  2 +-
>  arch/mips/kvm/mmu.c                 |  3 ++-
>  arch/powerpc/include/asm/kvm_host.h |  3 ++-
>  arch/powerpc/kvm/book3s.c           |  3 ++-
>  arch/powerpc/kvm/e500_mmu_host.c    |  3 ++-
>  arch/x86/include/asm/kvm_host.h     |  3 ++-
>  arch/x86/kvm/mmu/mmu.c              |  3 ++-
>  virt/kvm/kvm_main.c                 |  3 ++-
>  10 files changed, 30 insertions(+), 14 deletions(-)
> 

These would be okay for 5.9 too, so I plan to queue them myself before
we fork for 5.10.

Paolo

