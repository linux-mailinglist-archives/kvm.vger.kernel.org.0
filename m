Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889054D9851
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 11:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346905AbiCOKFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 06:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346904AbiCOKFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 06:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 772816250
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647338665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e3sYeRog9xVBlURoyGNfLxZdt5XjPC0pgpdORBabjrk=;
        b=HPVATYtLnpYqWCOtnQ0xJascXtl/HXdnK5YN8i0ZPzZaeX59LpzL/YViItsHvDQTnn/yhq
        fQvbrLCFzA0k51uOT72kz2v+idjfYDv2yM4zt0tGmSdQnMGS/2A7Hx6B1ByFqalXtHdrwg
        5TV4qbPorVWl50hHPiOT+bpW9DH4rOY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-2Sc65sbEOC6hFRVVmWSbHg-1; Tue, 15 Mar 2022 06:04:22 -0400
X-MC-Unique: 2Sc65sbEOC6hFRVVmWSbHg-1
Received: by mail-pj1-f71.google.com with SMTP id cp14-20020a17090afb8e00b001c6018fe017so1700030pjb.4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e3sYeRog9xVBlURoyGNfLxZdt5XjPC0pgpdORBabjrk=;
        b=aMRqBAirueqTQWmXCa21hxEyCSEcOXxLRCSxZYfZkwOCqlseBlRZmjlr0TX4w93Wyg
         8sK4wP9kXK7ttNIIwAdCiTieU2Hj+g5PZ1ZSaZcioItklAiqfQnmFLRM6nAJMwLzEFNN
         v0x0xXyeQ+YQKUcMJmK1a7ey9NY1t7RkZoFAsmBmPZkK1hVyTFQLavo3bfwS6PFQeaeF
         KqCCO60TOdQKz4YrgBeYoOa2bXnXjp+G38ovruQCiqHxrfpo1lOUFw7GhkDMFpwZxEqg
         3KZnwbyc5bed/Kfyb/A1Qw7kCcBdb+9/RNtDE3ZUl+kf8qgHcIzKCghOwA/jO7RVAzgu
         obng==
X-Gm-Message-State: AOAM531mzu8ISV13nlNpb8GfwHusKGtcvt8J1fQvJWigZvrYSveESi9W
        tZjYIm29ItwzyvfXLuo97rscxPob/lKzbD4SvNyX63NoxlDXZ1+k+V7cuZpe7LocN9XM850sh2u
        cJX1zqFFTgW5H
X-Received: by 2002:a17:902:bf07:b0:14f:a3a7:97a0 with SMTP id bi7-20020a170902bf0700b0014fa3a797a0mr27411304plb.105.1647338661023;
        Tue, 15 Mar 2022 03:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/mxd/EICNmoMZpJXHgMSaHmG8FbtpYeONh4CGs4wC9FfIAYpFlKVQt5+VFKco/YMnRgFgaA==
X-Received: by 2002:a17:902:bf07:b0:14f:a3a7:97a0 with SMTP id bi7-20020a170902bf0700b0014fa3a797a0mr27411274plb.105.1647338660772;
        Tue, 15 Mar 2022 03:04:20 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b001c54dc9061esm2475481pjl.51.2022.03.15.03.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 03:04:20 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:04:11 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v2 08/26] KVM: x86/mmu: Link spt to sp during allocation
Message-ID: <YjBkm8mYKNc5sdpU@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-9-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:10AM +0000, David Matlack wrote:
> Link the shadow page table to the sp (via set_page_private()) during
> allocation rather than initialization. This is a more logical place to
> do it because allocation time is also where we do the reverse link
> (setting sp->spt).
> 
> This creates one extra call to set_page_private(), but having multiple
> calls to set_page_private() is unavoidable anyway. We either do
> set_page_private() during allocation, which requires 1 per allocation
> function, or we do it during initialization, which requires 1 per
> initialization function.
> 
> No functional change intended.
> 
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Ah I should have read one more patch before commenting in previous one..

Personally I (a little bit) like the other way around, since if with this
in mind ideally we should also keep the use_mmu_page accounting in
allocation helper:

  kvm_mod_used_mmu_pages(vcpu->kvm, 1);

But then we dup yet another line to all elsewheres as long as sp allocated.

IOW, in my opinion the helpers should service 1st on code deduplications
rather than else.  No strong opinion though..

Thanks,

-- 
Peter Xu

