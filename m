Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AFE3F8B0C
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 17:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbhHZPcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 11:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhHZPcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 11:32:00 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B22C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:31:12 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r2so3360345pgl.10
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 08:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H2FXjSr4XXZh/wrLB/l+lB0NdiO6v1AP72JJN2CDrFc=;
        b=K5kyw3BUILvXPVdRt3dr3nc9HSYp/apyOTqcN2RrYbVU2PzWjaXEF+57Z1hyNLPFFz
         X4KrH/UmDIjk2d+/akTlAIxJuRyZPX5Xt0tSKj/gw3U6Fu3wTSVexANRNKqilFM6V7Z+
         96n4SVw6ZXcPnXQMl3OGbW1OOo9pSLQx9KE+VtUITmR25OlinjSTNJ24V+UDAqTAa14k
         i9DsCYhjsc5LYGAZXoKU8ihDOEzh4mbSV89QdfKYSAnHog1oyn9jzpxSaRGY3ayiHHAY
         hQ69HnVsIhEvuSOmBhU+SOtWW8e96541G2o0Ej7ujRU6pRVIajZBLY4WVSJLJTSJkaRD
         3Niw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2FXjSr4XXZh/wrLB/l+lB0NdiO6v1AP72JJN2CDrFc=;
        b=YVpgskp8Tp2fECK9r14aJHTDE4nuQ3/Ymoq3uikE4M+K0MC6XKFXUuVXJf9uiFh+mA
         KsKfxQEk4WJOhOSVkiubXkajq7pKrGQ9xb+Ty6J3PMhJRoA7UnzEXLTuDzYvxXlVdJ8m
         R7F6YtdbXjYXVXZe/T/0CFqTgehqe63cnXyx2vd7Vp5DvTA5UJnBK/I+KAggNVO1eZ2f
         RpjlYQYg+ZLPpjuZBEMmAJaoeVQKAtyysBGSqGNX5hStw+ywV3wb2cibEbj2hKUacCWr
         DRrBPBFGp7nt02gWfhLgTflzXB/40U08wRy47wctN+W0Po85HResrsmC6eXFwE5Z+VIS
         Tw8g==
X-Gm-Message-State: AOAM530jnvUZlLsx+YUPJe/Tu7HzF/EvNeZOjtn89LAaWx8eNk7H4V7P
        mCicuWTPoyilfiSOT36OH7h4Y16HlquKuw==
X-Google-Smtp-Source: ABdhPJy2WGiWszoKveZseSY+6UMrzoYkhSAgEVXsEKXHspBTVcgEcbC9H6j2IthD2WINLjjpKMyEQA==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr4362260pfh.17.1629991871950;
        Thu, 26 Aug 2021 08:31:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g10sm3326023pfh.120.2021.08.26.08.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:31:10 -0700 (PDT)
Date:   Thu, 26 Aug 2021 15:31:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
Message-ID: <YSezuycq/PwF5arc@google.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
 <20210826122442.966977-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826122442.966977-5-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Vitaly Kuznetsov wrote:
> KASAN reports the following issue:
> 
>  BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>  Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798
> 
>  CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
>  Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
>  Call Trace:
>   dump_stack+0xa5/0xe6
>   print_address_description.constprop.0+0x18/0x130
>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>   __kasan_report.cold+0x7f/0x114
>   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>   kasan_report+0x38/0x50
>   kasan_check_range+0xf5/0x1d0
>   kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
>   kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
>   ? kvm_arch_exit+0x110/0x110 [kvm]
>   ? sched_clock+0x5/0x10
>   ioapic_write_indirect+0x59f/0x9e0 [kvm]
>   ? static_obj+0xc0/0xc0
>   ? __lock_acquired+0x1d2/0x8c0
>   ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]
> 
> The problem appears to be that 'vcpu_bitmap' is allocated as a single long
> on stack and it should really be KVM_MAX_VCPUS long. We also seem to clear
> the lower 16 bits of it with bitmap_zero() for no particular reason (my
> guess would be that 'bitmap' and 'vcpu_bitmap' variables in
> kvm_bitmap_or_dest_vcpus() caused the confusion: while the later is indeed
> 16-bit long, the later should accommodate all possible vCPUs).
> 
> Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target vCPUs")
> Fixes: 9a2ae9f6b6bb ("KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap")
> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
