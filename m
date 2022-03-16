Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACC84DACBA
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 09:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345313AbiCPIpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiCPIpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 04:45:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D78D340C3
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647420260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ZQesErDQxJhbNTlel7Pn8Vb/5JIOEBvnS29Fn8zDoI=;
        b=H2MR4lfETyZ8OOYqECrFoBi/8I00uXd53axbeAoRZByXwerQZQN6+jrRFng4q4OHe4Oltz
        xMh9w55zTP2Y0VZEd+nq9v9PSsGkPuG5BP3CoIGjup9r9CIJIOIr5f4AHvKjHUSpUVgV7R
        wrAfmc9d3D75CPkuSxHR1hITzI6/W4c=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-XNrPj6ZTP3-v4gefWM-xAA-1; Wed, 16 Mar 2022 04:44:19 -0400
X-MC-Unique: XNrPj6ZTP3-v4gefWM-xAA-1
Received: by mail-pf1-f197.google.com with SMTP id w68-20020a62dd47000000b004f6aa5e4824so1451651pff.4
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 01:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ZQesErDQxJhbNTlel7Pn8Vb/5JIOEBvnS29Fn8zDoI=;
        b=taAes+LNoaRHz9AghLrVImBvitNRHVYQffK8mlkAvHKJ7c1a1CmRqauSS36tBtJi9T
         /FmEeAGTOePVyN75EGmrLX5NKR/A4W/Sd4Iwi5dTZ07Go/STs50dn6v1kBbJgjA0MHT9
         OP765cb6oJuwuDWP0Yc0FPRFlVLwDRn/y9VXaBMHu7MYh3f2WDQ8IIoKhWDaDfFj/BQY
         X2MWcp8illTHcF4lJsMD+2Ppc3OsWErt9UgE/uqNlid0/os9fQVTV2mNUzocyrz2HRmQ
         /KO8O+Tq6rL6zjUs0rtDiLuGQgG9f9CM8T3KjeBfhuGwjHSkroTCxV9/ow4FHXy/d8YK
         LjhQ==
X-Gm-Message-State: AOAM533bek7H3Xlsaa1jufWWqTQ0UqOLNDEzumPb5BE404YFxOqJDejc
        vtaADJo20/XKvcVq7VI7ShhkfuCjVEH4WtNEYjEQrYCOBa5My2Kd4/bmqb90m+GHqVaTpf3LOXT
        BOSH8a93ZZirY
X-Received: by 2002:a05:6a00:170c:b0:4f7:658d:77a2 with SMTP id h12-20020a056a00170c00b004f7658d77a2mr33249773pfc.60.1647420258154;
        Wed, 16 Mar 2022 01:44:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf5n0IdTCbTV5mIpfQa8fPfAwUPw+X6hCobMzk5jCneFEdxWl5Yk9KwxIn4gIMUVJ5GpzGRg==
X-Received: by 2002:a05:6a00:170c:b0:4f7:658d:77a2 with SMTP id h12-20020a056a00170c00b004f7658d77a2mr33249747pfc.60.1647420257911;
        Wed, 16 Mar 2022 01:44:17 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.128])
        by smtp.gmail.com with ESMTPSA id o5-20020a056a0015c500b004f76735be68sm2185059pfu.216.2022.03.16.01.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:44:17 -0700 (PDT)
Date:   Wed, 16 Mar 2022 16:44:09 +0800
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
Subject: Re: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to
 make_huge_page_split_spte()
Message-ID: <YjGjWcmn+7sZPjNX@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-18-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-18-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:19AM +0000, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 85b7bc333302..541b145b2df2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * not been linked in yet and thus is not reachable from any other CPU.
>  	 */
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
> +		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);

Pure question: is it possible that huge_spte is RO while we passed in
ACC_ALL here (which has the write bit set)?  Would it be better if we make
it a "bool exec" to be clearer?

-- 
Peter Xu

