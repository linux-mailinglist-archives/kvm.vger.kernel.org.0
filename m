Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654914D9830
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 10:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245460AbiCOJzg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 05:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343563AbiCOJzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 05:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8742BED
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647338060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xo7vEvs61DjOwm+OclljyKsVMA7zeYl4GrMr0rJ3aPA=;
        b=FAFXlZAgGmK5NvWaqs3uMxKqjDh40qjEPm+E8EsYxtST+nGSQ/KUh6Y5qDFAPXOMN7HcjK
        I3Htf5aLBUPi3heVoeYU4zRdIPjS6HmlB0lhLR8LmPxewmICpBd9y1+F1JM1N4zTHPmmFS
        6jdk1S4HoYr8Nr5wJQjmsnYJPZ1SexE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-sczn1gJjNciDdlhkHmLwcA-1; Tue, 15 Mar 2022 05:54:19 -0400
X-MC-Unique: sczn1gJjNciDdlhkHmLwcA-1
Received: by mail-pl1-f199.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so8088556plr.8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 02:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xo7vEvs61DjOwm+OclljyKsVMA7zeYl4GrMr0rJ3aPA=;
        b=FDhdUPkMby2eCWqgg2FValndl2OEhSqcR0HdBMryAqTB4Ehxn2pk7IQcC/5nS+/35S
         60OUmsRzijL5aDFmWQrusexALI0EHzaUttNUd3WYbu3rx/fZwjhzSUyhAJtVsqgJUCKP
         aqn6Qh6BrcgzZNv+eT95FymkiWDmlAP1rgiq1z/p7BlxaoFKr8HdnWWNwjmmzoLeb05u
         NipNBtxG+9yBh+URzV5juHytTri7psQabsPZqWx/CWpI9xeVG+I8ay9AfN1SC5uz53c9
         ySd8dLMKekomytN9TFXbhZTSNKSP+/o4G68x/sKc1ECnzUneUH8CcoFUlQZ+ML6zSjEc
         gcAg==
X-Gm-Message-State: AOAM531pLHL7CMrGsohj1Lpefdb8/HgTiTaygaNayj0jkJAciD+bgALN
        Yl/+idYTXmnUdV1NkNpFFzh2Z+09vER+0JCEUTYZ/P7j1TjxIaN1kzxyrAa+xojHdSUAs0d3jzy
        n+f6xMfMU0E2o
X-Received: by 2002:a63:6a87:0:b0:37c:917a:9ce8 with SMTP id f129-20020a636a87000000b0037c917a9ce8mr23251998pgc.373.1647338058329;
        Tue, 15 Mar 2022 02:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk6toqw8g9xhAX2SCrS3+aOdMM5AnKaYY+MCoYdIf9gIGOszMtcDKZxExIC2OWuD0eFQebMA==
X-Received: by 2002:a63:6a87:0:b0:37c:917a:9ce8 with SMTP id f129-20020a636a87000000b0037c917a9ce8mr23251985pgc.373.1647338057995;
        Tue, 15 Mar 2022 02:54:17 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a000cc500b004f6ff0f51f4sm23591315pfv.5.2022.03.15.02.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 02:54:17 -0700 (PDT)
Date:   Tue, 15 Mar 2022 17:54:09 +0800
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
Subject: Re: [PATCH v2 07/26] KVM: x86/mmu: Separate shadow MMU sp allocation
 from initialization
Message-ID: <YjBiQd0rlAk7/fZW@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-8-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:09AM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 519910938478..e866e05c4ba5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>  	if (!direct)
>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);

Trivial nit:

I read Ben's comment in previous version and that sounds reasonable to keep
the two linkages together.  It's just a bit of a pity we need to set the
private manually for each allocation.

Meanwhile we have another counter example in the tdp mmu code
(tdp_mmu_init_sp()), so we may want to align the tdp/shadow cases at some
point..

-- 
Peter Xu

