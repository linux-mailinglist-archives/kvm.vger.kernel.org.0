Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8214CCAB0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 01:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiCDAXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 19:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiCDAXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 19:23:08 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA7347386
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 16:22:21 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y11so6165379pfa.6
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 16:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fWdYHu/uQ+3/IsRl+Qb5Q42VZLcmjEkYM8EgSLZQbL8=;
        b=gIWiMRxYV8lZiYJ6z+wqazWJnZTxD683PzP8r2nrtry8qaKhKkjdloq0R2EO/Hn5wx
         dZqtoWh513U7dm9IwUep8VgR1l37lmw70h6wE6Cl8W28jGs7tTAZ3dP/jJmG4xV2zzVg
         yqgFIAjTQSPZ4a/lvxpklw0mK8bLmeyJJgXve0AvO+dTVyhJOkST8sHOwVN0taDZGGVK
         xKrUaIVOfSS36ya2EyE/pfyGobn22KGqADzrLs8yxTQ8iPIg1EvRlQboYvjQ1g+Z/vge
         R9lnB01QRSB/dZgkgu9BQmEn9xg6aRbhcISRa+zXxMgC8Jz6oeet5arsGhHfy+8QYokP
         Wvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fWdYHu/uQ+3/IsRl+Qb5Q42VZLcmjEkYM8EgSLZQbL8=;
        b=yLzE7Es368bc6IbNym4V4OeZcLotJ+V5ZP2XscBvUHPUESRzOLo/Hiqg1g2nLyr5xm
         B9bzOwzqI8ts8xu5mM9agdpn4ljSI6msdaaG9Fg9GD8wIogPFRCJgLa/dFlsOHQAz7fc
         Ofb7Xcws4FRu9y2EzxMNYKbAgt7ZdDCI+jbBS6kpeqrB6UDWDZxnHtVgl9zvn7BNhThb
         6Z6gugknTarHihNVUGXJKOxYJGOO/H946OlgwJwXJB0FunfDcfYNiyaA8kiXZ52BHkll
         eCt91SzmWC08XnSssssACPQWZt/3KDsIVUJYuXMvYF7zFgkN0SlQ4u4FdVWMaS+82vgH
         ZPrw==
X-Gm-Message-State: AOAM533RHUIXHltoCLcmT7jGcVU6QG7JEC8pTg1WXSeH2BojB9gaPaCb
        FcGMsyuG4ruQj6lA0+Az0unmUw==
X-Google-Smtp-Source: ABdhPJxCDEg9KbGCCf2d1ZLlQRKcgQ8PwWJB+zqg1nwiYeqRoI0/lTs85vB7zh5UwHBDqABz1sRRYA==
X-Received: by 2002:a63:6883:0:b0:378:3582:c94f with SMTP id d125-20020a636883000000b003783582c94fmr27210595pgc.60.1646353340897;
        Thu, 03 Mar 2022 16:22:20 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090adb4e00b001bee5dd39basm7973779pjx.1.2022.03.03.16.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 16:22:19 -0800 (PST)
Date:   Fri, 4 Mar 2022 00:22:16 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 02/23] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Message-ID: <YiFbuDaMfNItGwLw@google.com>
References: <20220203010051.2813563-1-dmatlack@google.com>
 <20220203010051.2813563-3-dmatlack@google.com>
 <YhBEaPWDoBiTpNV3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YhBEaPWDoBiTpNV3@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 19, 2022 at 01:14:16AM +0000, Sean Christopherson wrote:
> On Thu, Feb 03, 2022, David Matlack wrote:
> > Instead of computing the shadow page role from scratch for every new
> > page, we can derive most of the information from the parent shadow page.
> > This avoids redundant calculations such as the quadrant, and reduces the
> 
> Uh, calculating quadrant isn't redundant.  The quadrant forces KVM to use different
> (multiple) shadow pages to shadow a single guest PTE when the guest is using 32-bit
> paging (1024 PTEs per page table vs. 512 PTEs per page table).  The reason quadrant
> is "quad" and not more or less is because 32-bit paging has two levels.  First-level
> PTEs can have quadrant=0/1, and that gets doubled for second-level PTEs because we
> need to use four PTEs (two to handle 2x guest PTEs, and each of those needs to be
> unique for the first-level PTEs they point at).

One solution is to keep the quadrant calculation in kvm_mmu_get_page().
The obvious problem for eager page splitting is we need the faulting
address to use the existing calculation to get the quadrant, and there
is no faulting address when doing eager page splitting. This doesn't
really matter though because we really don't care about eagerly
splitting huge pages that are shadowing a 32-bit non-PAE guest, so we
can just skip huge pages mapped on shadow pages with has_4_byte_gpte and
hard-code the quadrant to 0.

Plumbing all that shouldn't be too hard. But it occurs to me it might
not be necessary. The quadrant cannot be literally copied from the
parent SP like this commit does, but I think it can still be derived
from the parent. The upside is we don't need any special casing of
has_4_byte_gpte or hard-coding the quadrant in the eager page splitting
code, and we can still get rid of passing in the faulting address to
kvm_mmu_get_page().

Here's what it would (roughly) look like, applied on top of this commit:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6941b9b99a90..4184662b42bf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2110,9 +2110,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
        return sp;
 }

-static union kvm_mmu_page_role kvm_mmu_child_role(struct kvm_mmu_page *parent_sp,
-                                                 bool direct, u32 access)
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
 {
+       struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
        union kvm_mmu_page_role role;

        role = parent_sp->role;
@@ -2120,6 +2120,28 @@ static union kvm_mmu_page_role kvm_mmu_child_role(struct kvm_mmu_page *parent_sp
        role.access = access;
        role.direct = direct;

+       /*
+        * If the guest has 4-byte PTEs then that means it's using 32-bit,
+        * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
+        * directories, each mapping 1/4 of the guest's linear address space
+        * (1GiB). The shadow pages for those 4 page directories are
+        * pre-allocated and assigned a separate quadrant in their role.
+        *
+        * Since we are allocating a child shadow page and there are only 2
+        * levels, this must be a PG_LEVEL_4K shadow page. Here the quadrant
+        * will either be 0 or 1 because it maps 1/2 of the address space mapped
+        * by the guest's PG_LEVEL_4K page table (or 4MiB huge page) that it
+        * is shadowing. In this case, the quadrant can be derived by the index
+        * of the SPTE that points to the new child shadow page in the page
+        * directory (parent_sp). Specifically, every 2 SPTEs in parent_sp
+        * shadow one half of a guest's page table (or 4MiB huge page) so the
+        * quadrant is just the parity of the index of the SPTE.
+        */
+       if (role.has_4_byte_gpte) {
+               BUG_ON(role.level != PG_LEVEL_4K);
+               role.quadrant = (sptep - parent_sp->spt) % 2;
+       }
+
        return role;
 }

@@ -2127,11 +2149,9 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
                                                 u64 *sptep, gfn_t gfn,
                                                 bool direct, u32 access)
 {
-       struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
        union kvm_mmu_page_role role;

-       role = kvm_mmu_child_role(parent_sp, direct, access);
-
+       role = kvm_mmu_child_role(sptep, direct, access);
        return kvm_mmu_get_page(vcpu, gfn, role);
 }

> 
> Indeed, this fails spectacularly when attempting to boot a 32-bit non-PAE kernel
> with shadow paging enabled.
> 
>  \���	���\���	��\���
>  	P��\��`
>  BUG: unable to handle page fault for address: ff9fa81c
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  *pde = 00000000
>  ����
>  Oops: 0000 [#1]��<���� SMP��<������<������<����
>  ��<����CPU: 0 PID: 0 Comm: swapper ��<����G        W         5.12.0 #10
>  ��<����EIP: memblock_add_range.isra.18.constprop.23d�r
>  ��<����Code: <83> 79 04 00 75 2c 83 38 01 75 06 83 78 08 00 74 02 0f 0b 89 11 8b
>  ��<����EAX: c2af24bc EBX: fdffffff ECX: ff9fa818 EDX: 02000000
>  ��<����ESI: 02000000 EDI: 00000000 EBP: c2909f30 ESP: c2909f0c
>  ��<����DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210006
>  ��<����CR0: 80050033 CR2: ff9fa81c CR3: 02b76000 CR4: 00040600
>  ��<����Call Trace:
>  ��<���� ? printkd�r
>  ��<���� ��<����memblock_reserved�r
>  ��<���� ? 0xc2000000
>  ��<���� ��<����setup_archd�r
>  ��<���� ? vprintk_defaultd�r
>  ��<���� ? vprintkd�r
>  ��<���� ��<����start_kerneld�r
>  ��<���� ��<����i386_start_kerneld�r
>  ��<���� ��<����startup_32_smpd�r
> 
>  ����
>  CR2: 00000000ff9fa81c
> 
>  ��<����EIP: memblock_add_range.isra.18.constprop.23d�r
>  ��<����Code: <83> 79 04 00 75 2c 83 38 01 75 06 83 78 08 00 74 02 0f 0b 89 11 8b
>  ��<����EAX: c2af24bc EBX: fdffffff ECX: ff9fa818 EDX: 02000000
>  ��<����ESI: 02000000 EDI: 00000000 EBP: c2909f30 ESP: c2909f0c
>  ��<����DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210006
>  ��<����CR0: 80050033 CR2: ff9fa81c CR3: 02b76000 CR4: 00040600
> 
> > number of parameters to kvm_mmu_get_page().
> > 
> > Preemptivel split out the role calculation to a separate function for
> 
> Preemptively.
> 
> > use in a following commit.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
