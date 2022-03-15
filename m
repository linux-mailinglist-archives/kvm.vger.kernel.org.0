Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79874D96C4
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiCOIxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiCOIxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:53:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D55D4D615
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647334338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6x8zrCGUIJGuBD8tXlGdkrTNIYPGin6keX7CqjOiKA=;
        b=hHH/REBz3bN3r6ZMf7fWpnDyYDm5wXx/45N97MHMGzYZazWTbNyIt+fW1dU00DzVFrQnez
        SVP7GMspU7sIa2E9u33dOD3AU5PhdK6rrtiI4LX4jWOT+tOJYSLXCNPGyAC6/D/l7Ago7q
        G5B4Cs4A/3O1Z8yYOwyGOz+ZCpn3UqM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-dFcbXHniM76VxxjtGu4I2w-1; Tue, 15 Mar 2022 04:52:17 -0400
X-MC-Unique: dFcbXHniM76VxxjtGu4I2w-1
Received: by mail-pl1-f199.google.com with SMTP id n17-20020a170902f61100b001538c882549so1668114plg.18
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b6x8zrCGUIJGuBD8tXlGdkrTNIYPGin6keX7CqjOiKA=;
        b=7Ox1KWwDk00SKol7Jmbl/eUA11f4wQZimQ/SI9rJdf+17B25T5XxjEt7PSvntQVhxj
         n2xBhEyy0/dgbQMPNp41ZuL9FZJpZqSEWvgdY86Q1urpJgmRtZ4taKifiIXzK83pfmlP
         3nM8EqPBs00615qS+10tmSknHytqvVrSePyDnt2xSHtih72lb70lYsAi98QyXVxGg68a
         tENFGUsrcNTmtZFkpkgyhpO20crshwNQRc4bjO4qlHRqvQt/c+9bWe2qep0v5GMoeRTB
         HesfPNJ8Y6ud0oeqVYxJCXdntnG4jDOMUh3BALroJ19Z8zg/VcxIZNh3uGbpeV8tIfxd
         PwTQ==
X-Gm-Message-State: AOAM531ljnh7hcJzzrGRpKRRPgkp/UgyKdxdM9zRARLdi+A89f/3rNyJ
        N2jnv82GvOQbGMFUMmMg0Ug+MhEMeuHJf06vFD+e0QOyEClWW0R0EMDRNj2ArO4DmB06TkiBgk6
        wZn+e/nnpVOPw
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id f13-20020a17090aa78d00b001bcd11cad40mr3371737pjq.246.1647334335985;
        Tue, 15 Mar 2022 01:52:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV18cFMANWpzVlWVPkfvaEbny00jVIEsyxFA/M+p96D3QfDqHts4Eg0Baq2ixkgpFIwtCYvw==
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id f13-20020a17090aa78d00b001bcd11cad40mr3371713pjq.246.1647334335782;
        Tue, 15 Mar 2022 01:52:15 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id m125-20020a628c83000000b004f7baad5c20sm9382162pfd.144.2022.03.15.01.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:52:15 -0700 (PDT)
Date:   Tue, 15 Mar 2022 16:52:07 +0800
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
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YjBTtz6wo/zQEHCv@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-6-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> Rename 3 functions:
> 
>   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
>   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
>   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> 
> This change makes it clear that these functions deal with shadow pages
> rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> since these are core routines.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

