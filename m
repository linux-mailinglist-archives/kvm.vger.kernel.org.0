Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908B84D95F6
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345776AbiCOIQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345754AbiCOIQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:16:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 576694AE11
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647332129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a0cNYdPs691U7NzI+aLZjWfo6CR3sI4nXipmf6Gsq0k=;
        b=dSadjhCpU/YrEll3TxKNtm7HR6YZFY6vFC3+kxnfvvE5nGo9Pwxga0qGRDETtL7WDSNqRr
        Ir/HpRgZBc/38vTPl+9+zB6pfyanQootwpe+FfFBqiM0lhFk2XykgOFXOruoUXJx0938gI
        aPsDoN/5zWVW4iG/3sR/pNXXRDtYFy8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-AzNuvBJgPsqCTSRtsZp1mA-1; Tue, 15 Mar 2022 04:15:28 -0400
X-MC-Unique: AzNuvBJgPsqCTSRtsZp1mA-1
Received: by mail-pl1-f197.google.com with SMTP id z10-20020a170902708a00b0014fc3888923so7913520plk.22
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0cNYdPs691U7NzI+aLZjWfo6CR3sI4nXipmf6Gsq0k=;
        b=Bcy9xdxs4Pzm8pTQbEpqRzqdJAMSdyPuJbgxQBxXGBYjiuWWCpepQfliVtyMrWrCGm
         H9Y9pRXP4SsNDer0Tnt7m0JRISIx6FwBikG3Lwkqv7oyddHuyKddU0XrFlrSfr21WYZs
         vWfOvMkTJD3wKDFFiTLrWejvyp+Lu11DEx+0paTrJ0lmK9dBFuU1RTL/+jf9bnZ+p29X
         Gu+9qY/HtV0fOObqYrgbs8uxd9Ns1Hcpc+bVeMPRznx/JnyXbOiOxTBAJGfxFa8LPYAE
         1Usbg5mSpNhucm3Ul/0ZiUPvGfNIbiKdIIphiZcdUVDLXjB1ytib2NOa0GdqIoQopQhv
         b8zg==
X-Gm-Message-State: AOAM530pXieVK2jTW2lCP4na+EN2YhNS15fImnyErlH/gAMdwLzGer/F
        NI/uVahMi1JF2kiqvXSkbIqRfexo0IYGvrT/laa08PjSDGxkBY3u1ja85m0qSK/S/Yo9jK4iyDg
        iaEPu1eJsAmPm
X-Received: by 2002:a17:902:db0b:b0:151:fa8c:d6cd with SMTP id m11-20020a170902db0b00b00151fa8cd6cdmr27148071plx.147.1647332126986;
        Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq0uq77YNHp6fuhCYE/x4KhDRlcGw0u3EOCCh2qj9qDt6uuauAuzikZPkm8QDqCFMb2dJYNA==
X-Received: by 2002:a17:902:db0b:b0:151:fa8c:d6cd with SMTP id m11-20020a170902db0b00b00151fa8cd6cdmr27148041plx.147.1647332126587;
        Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43])
        by smtp.gmail.com with ESMTPSA id o7-20020a056a00214700b004c169d45699sm22890891pfk.184.2022.03.15.01.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:15:26 -0700 (PDT)
Date:   Tue, 15 Mar 2022 16:15:17 +0800
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
Subject: Re: [PATCH v2 03/26] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YjBLFZWtdfwhNosG@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220311002528.2230172-4-dmatlack@google.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:25:05AM +0000, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, we can derive most of the information from the parent shadow page.
> This avoids redundant calculations and reduces the number of parameters
> to kvm_mmu_get_page().
> 
> Preemptively split out the role calculation to a separate function for
> use in a following commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks right..

Reviewed-by: Peter Xu <peterx@redhat.com>

Two more comments/questions below.

> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> +{
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> +	union kvm_mmu_page_role role;
> +
> +	role = parent_sp->role;
> +	role.level--;
> +	role.access = access;
> +	role.direct = direct;
> +
> +	/*
> +	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
> +	 * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> +	 * directories, each mapping 1/4 of the guest's linear address space
> +	 * (1GiB). The shadow pages for those 4 page directories are
> +	 * pre-allocated and assigned a separate quadrant in their role.
> +	 *
> +	 * Since we are allocating a child shadow page and there are only 2
> +	 * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
> +	 * will either be 0 or 1 because it maps 1/2 of the address space mapped
> +	 * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
> +	 * is shadowing. In this case, the quadrant can be derived by the index
> +	 * of the SPTE that points to the new child shadow page in the page
> +	 * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
> +	 * shadow one half of a guest's page table (or 4MiB huge page) so the
> +	 * quadrant is just the parity of the index of the SPTE.
> +	 */
> +	if (role.has_4_byte_gpte) {
> +		BUG_ON(role.level != PG_LEVEL_4K);
> +		role.quadrant = (sptep - parent_sp->spt) % 2;
> +	}

This made me wonder whether role.quadrant can be dropped, because it seems
it can be calculated out of the box with has_4_byte_gpte, level and spte
offset.  I could have missed something, though..

> +
> +	return role;
> +}
> +
> +static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
> +						 u64 *sptep, gfn_t gfn,
> +						 bool direct, u32 access)
> +{
> +	union kvm_mmu_page_role role;
> +
> +	role = kvm_mmu_child_role(sptep, direct, access);
> +	return kvm_mmu_get_page(vcpu, gfn, role);

Nit: it looks nicer to just drop the temp var?

        return kvm_mmu_get_page(vcpu, gfn,
                                kvm_mmu_child_role(sptep, direct, access));

Thanks,

-- 
Peter Xu

