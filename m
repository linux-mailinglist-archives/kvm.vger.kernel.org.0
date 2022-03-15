Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5524D98B9
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347092AbiCOK2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 06:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347091AbiCOK2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 06:28:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9289249933
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647340051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DiRHDgSxXyEgzQ/1H6WEmoIcoAybwpIARKWXa7C6zmE=;
        b=BCIhlaGLQMk7pzMloxVp00B8L+cIf+z+6tM2zW9K0pBQn+YykvNrj0NcAxtuLbu7qmCldN
        wXDBc0IFi1tcf22hAjbl6eNu9o394k6bSfO8zHYdbgeaO2RnRusk6G7vEO5VcVN8ypSLWB
        hXbUL2kypndj1ND47PqaBJFa6chTBbg=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-Lx0h9nfEOvGuS_Sc34Q02w-1; Tue, 15 Mar 2022 06:27:30 -0400
X-MC-Unique: Lx0h9nfEOvGuS_Sc34Q02w-1
Received: by mail-pj1-f70.google.com with SMTP id mg8-20020a17090b370800b001c632128a5bso1792259pjb.1
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 03:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DiRHDgSxXyEgzQ/1H6WEmoIcoAybwpIARKWXa7C6zmE=;
        b=EVDEPNl7cz1MXSVDDTTfQR7H0BBa/MrMN1glxKGwU8Fd60/4vtEfehygoIb75La8ZP
         SZidsjJfzcCzdCjqyvjKXOGmD+dM+Zqowx1/+WKU126nYPIL+qzrIQRdmY6cRxqwf6k/
         djq2vRWY9ByhIkl/7hZ9a75lWTOP0xu49W1KHijD5G2+i+/f63QvqfmKWLTzaSUjMkXd
         w+UuZRYFh6f98YRJZXJsX4QQNJPzt8JZtizo6HgQqTgPYzOPsdeNwsB2EBBondDYMnSt
         F/gHYf8TccCfIipu8Vw9YUAFzgNUk9KmcWWe1j7o59eoI/HgBashi8rn52DtU3fYjG79
         vWdA==
X-Gm-Message-State: AOAM530AxKXzV4pTchDmTDa5TpNa+p6PO6uKgRgkqy7GKAaBP8vWPHrS
        F96zd++E4D2XQ/xGX+Ig/FbQyYjHIJc78I0+ZpZKwHU9FQtxDKwBZFeGc5p2cFOTqvcC+hwvZH1
        tjXUMVWkEHkXq
X-Received: by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id u5-20020a17090add4500b001bc94669b64mr3777694pjv.23.1647340041341;
        Tue, 15 Mar 2022 03:27:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzh2WwWxCZLGIqwAfZcs1dEgUiakwT/1eroDl5Gkt3WkAGN7vYYYLwox9cKA4UNqkAcC0R1w==
X-Received: by 2002:a17:90a:dd45:b0:1bc:9466:9b64 with SMTP id u5-20020a17090add4500b001bc94669b64mr3777656pjv.23.1647340041068;
        Tue, 15 Mar 2022 03:27:21 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm25697622pfu.202.2022.03.15.03.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 03:27:20 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:27:12 +0800
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
Subject: Re: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
Message-ID: <YjBqAL+bPmcQpTgM@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-12-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:13AM +0000, David Matlack wrote:
>  static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_mmu_page *sp;
> -
> -	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> -
> -	return sp;
> +	return kvm_mmu_alloc_shadow_page(vcpu, true);
>  }

Similarly I had a feeling we could drop tdp_mmu_alloc_sp() too.. anyway:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

