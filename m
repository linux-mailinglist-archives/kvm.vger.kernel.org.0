Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97973B2F83
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhFXNAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhFXNAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 09:00:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C425AC061574;
        Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t32so5109756pfg.2;
        Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=uZuciq1P1LLIv86omk3p15CWzxu9H3VjtHemSC+vWOI=;
        b=rznw7O6D2Zt35p7Og+3iCwDgw2dkNPfwzD7rlUMP0y2Ej6O0tM+y3kSEcf8SWyT54d
         ublbOGuxe9Umj5fFSx3kLcve+5qwIiX31Bd1k9qJoijVaEMTrXxDg0VCRopT0Otp624H
         vQfbCt9QT5NQGNwfAmJ+KqkgxcPuOAOPjB6i02zSgoYEerKJgc/pbPT1wHARr0++dvZS
         Cel9tp2O0yGrWOTbrGUMXfBkZ8Eb/NzV2+WsHAOwG6gVAXQkKI9dWxURNSfgfHu0j01+
         sMqgBmAGdH9hfo97BHqdnz3MvquYkt7SnDT6LlXF4LTAyCM7dcMF+YevSRJYr4EeGBsv
         ThKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=uZuciq1P1LLIv86omk3p15CWzxu9H3VjtHemSC+vWOI=;
        b=Rjh9Om0dq8H/D0FO1lZ43yL+7aCSVS/X9jpOD5wNaflreBubimlvLvH1Xo35Cpjq+9
         2OHhmtNHJwqVm2uBcl5sWbwjDZp6nbdjuvhmR1QOKnjOKnHOK2X4k4eM9gO9tgZnpZSg
         2ACA6zeKf6pJjkXZdeuL5/WDSvtzDLSk8vIF1He/xWKTSqoLVu16Q96mjspw/gxyhP9+
         Hypw9vCkAHbXByxnc3fDIKOytvJFdqTIgC2EyvyFN0jXX2/yJqU/TP+Zt1xUbFierH7H
         KaiNAR7dSh02gAYpibe7gdXUTtocCfGLiLtVw9KjnaCX7qnneyUhDTopI4bnFZYw6Ata
         nG8Q==
X-Gm-Message-State: AOAM5334kxLKFAYNT7r1MSLXzP99EsOab3UVDbDcB/oUpHd9HFYEscz9
        qrqL7xqODolIdZPFJPHp4ws=
X-Google-Smtp-Source: ABdhPJyRyvJn5C7VYeX4UgUoQTwK2Wl40+EfEX+5KjgwzBTc5sLi33BY4sgc5lVA8ilsgegR5j26Eg==
X-Received: by 2002:a63:530a:: with SMTP id h10mr4685438pgb.98.1624539480323;
        Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id h22sm2909006pfc.21.2021.06.24.05.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 05:58:00 -0700 (PDT)
Date:   Thu, 24 Jun 2021 22:57:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
        <1624530624.8jff1f4u11.astroid@bobo.none>
        <1624534759.nj0ylor2eh.astroid@bobo.none>
        <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
In-Reply-To: <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
MIME-Version: 1.0
Message-Id: <1624539354.6zggpdrdbw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Excerpts from Paolo Bonzini's message of June 24, 2021 10:41 pm:
> On 24/06/21 13:42, Nicholas Piggin wrote:
>> Excerpts from Nicholas Piggin's message of June 24, 2021 8:34 pm:
>>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>>>> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by usin=
g
>>>> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
>>>> assoicated struct pages, so they should not be passed to pfn_to_page.
>>>> This series removes such calls from the x86 and arm64 secondary MMU. T=
o
>>>> do this, this series modifies gfn_to_pfn to return a struct page in
>>>> addition to a pfn, if the hva was resolved by gup. This allows the
>>>> caller to call put_page only when necessated by gup.
>>>>
>>>> This series provides a helper function that unwraps the new return typ=
e
>>>> of gfn_to_pfn to provide behavior identical to the old behavior. As I
>>>> have no hardware to test powerpc/mips changes, the function is used
>>>> there for minimally invasive changes. Additionally, as gfn_to_page and
>>>> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
>>>> easily changed over to only use pfns.
>>>>
>>>> This addresses CVE-2021-22543 on x86 and arm64.
>>>
>>> Does this fix the problem? (untested I don't have a POC setup at hand,
>>> but at least in concept)
>>=20
>> This one actually compiles at least. Unfortunately I don't have much
>> time in the near future to test, and I only just found out about this
>> CVE a few hours ago.
>=20
> And it also works (the reproducer gets an infinite stream of userspace=20
> exits and especially does not crash).  We can still go for David's=20
> solution later since MMU notifiers are able to deal with this pages, but=20
> it's a very nice patch for stable kernels.

Oh nice, thanks for testing. How's this?

Thanks,
Nick

---

KVM: Fix page ref underflow for regions with valid but non-refcounted pages

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on the page if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a6bc7af0e28..46fb042837d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2055,6 +2055,13 @@ static bool vma_is_valid(struct vm_area_struct *vma,=
 bool write_fault)
 	return true;
 }
=20
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -2104,13 +2111,21 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */=20
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r =3D -EFAULT;
=20
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn =3D pfn;
-	return 0;
+
+	return r;
 }
=20
 /*
--=20
2.23.0
