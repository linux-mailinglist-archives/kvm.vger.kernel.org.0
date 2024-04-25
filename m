Return-Path: <kvm+bounces-15899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8D18B1E84
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C771C24A1E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 09:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1C085953;
	Thu, 25 Apr 2024 09:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ZcmB1/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5538526C
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714038843; cv=none; b=qdRWHVm4AYEXaWvYpbTF4IOo4JA7DSZBhYb8gMd75xPkI1ilNcd4Q3XhN7vD51I430QBf9wGYW6HrKUBG50YUpq9tWTZHt4K3xZEzu2LMCIcA2djR8b+U7ajX7E13YBAOptxX27obWmHx8oxHQMC0ig5iTNYGDVHKH/zmSDjy10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714038843; c=relaxed/simple;
	bh=n8vlU+XM8z3wB/fXZKSaZJArUMjegdv2NMyY9ymyFkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AGaFTQ91rvFynMzNfqekWgmx7WRZx6FgWU9zcXtASYozb2B7VbiOkTATjV5eLHS62xsjSbJWMdS0suU9u61eTe0kKow8CNEDXkPWoav0+XKFv17qBxjGYgjtwOYijovpBFlRPu69cXsUMJo0o55s3hqT9LdcapJf85WPYdxzJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ZcmB1/X; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-479c0e8b1c5so264644137.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 02:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714038839; x=1714643639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2S4ZtYAwV4UTFyGGvlfOuiO1B8y2ezWGPKFTIKxi00o=;
        b=1ZcmB1/XXfTiNS1S4siWi7XthJMkonIzHT7ZlFJe+P4oOzbUb6nngQbDAWhojLPmR1
         tlte1zqbus68Bt7M9HN5j3XRVeGLPvhuYqbu4vIcuS+jjcg4OWDpOBSMMClLlsbiIev9
         Cm7m0zCc2dwJYbhkaOMbhmI2r1nnDczzs0dsLqay/Fxr7fbvUApuFYnviCHkmBknEcBP
         7T7fDgZw2rXvEbI5sm8khOI7oLpqae7T08u5qkp0CohjPaNe0DtoKMfiGcZbm5L9aLxf
         WrNcl7AnYhaz9eu7Ob/rDFbJt0l/m7JbdqT6/0gmCXL1XT/nv8ia/CB598Tiv/svgq3H
         CJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714038839; x=1714643639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2S4ZtYAwV4UTFyGGvlfOuiO1B8y2ezWGPKFTIKxi00o=;
        b=FGpMxNqUSaAuwBqE9LHOAM/yjLtRjx8Rx3ZpeHqRHvq5U/gNFUaAh7w6PAG8cQZ5Ah
         tW5UnZ2/5wyuBpGjhyuUKDYioTTtsx5Pg8xbrdRivfVNXB2GPpEbXe6U3hlNCL5PaY5o
         VYqiTEmJfDOnpaxibJuf0NaZucRorqTttsmniINRp04qUp1js8fYP0dy2RJGTYOJTxoH
         E1T0c87YmaHoO55cYnKjRb3IEacgP9DbydYJmCsST9eni7fmkMxiVDSkibPXWf3jvH2n
         NvesBlz+0HE3fcH/vu9e1qPsW4p0A6S1ezDvV++Trmrqeb8efVybkKydY2qBvzWCuBpB
         Jgtw==
X-Gm-Message-State: AOJu0Yz09MoZIqS5XfQTThijzQVUN4Ts0c/SbB0DAlXV4JXPjecXTCAJ
	/DKykJ/mq+Kyz1mvR5ROjPcbo9HAHpg9oLQbaZ83y9vNvYCGm3jGSC9wBmsNmEX7iy8hjvdv9QF
	bgbYWq+sq/WdgU9rJRWhEf4W8lnTdt+hb5F5e
X-Google-Smtp-Source: AGHT+IFCf96b/8rN1I/j0zet+Ph8wQszLYqyZmPfsby4JB1xvMf0BWiQIrmpfRGoF/fvks0lP7Tj4Xe4rXCwOjelin0=
X-Received: by 2002:a05:6102:162a:b0:47c:1f69:f132 with SMTP id
 cu42-20020a056102162a00b0047c1f69f132mr189601vsb.34.1714038838785; Thu, 25
 Apr 2024 02:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com> <20240412084309.1733783-18-steven.price@arm.com>
In-Reply-To: <20240412084309.1733783-18-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Apr 2024 10:53:22 +0100
Message-ID: <CA+EHjTzHJjtp4uMXN8RN4j=J-j2VdMQUhPr607EPzxTYUhMURQ@mail.gmail.com>
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 12, 2024 at 9:43=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
>
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to represent the range requested.
>
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed. A spare, delegated page (spare_page) is used for this purpose.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_rme.h |  16 ++
>  arch/arm64/kvm/mmu.c             |   8 +-
>  arch/arm64/kvm/rme.c             | 390 +++++++++++++++++++++++++++++++
>  3 files changed, 411 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kv=
m_rme.h
> index 915e76068b00..cc8f81cfc3c0 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -96,6 +96,14 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bi=
ts);
>  int kvm_create_rec(struct kvm_vcpu *vcpu);
>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +                          unsigned long ipa,
> +                          u64 size,
> +                          bool unmap_private);
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +                       unsigned long addr, unsigned long end,
> +                       unsigned long ripas);
> +
>  #define RME_RTT_BLOCK_LEVEL    2
>  #define RME_RTT_MAX_LEVEL      3
>
> @@ -114,4 +122,12 @@ static inline unsigned long rme_rtt_level_mapsize(in=
t level)
>         return (1UL << RME_RTT_LEVEL_SHIFT(level));
>  }
>
> +static inline bool realm_is_addr_protected(struct realm *realm,
> +                                          unsigned long addr)
> +{
> +       unsigned int ia_bits =3D realm->ia_bits;
> +
> +       return !(addr & ~(BIT(ia_bits - 1) - 1));
> +}
> +
>  #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 46f0c4e80ace..8a7b5449697f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -310,6 +310,7 @@ static void invalidate_icache_guest_page(void *va, si=
ze_t size)
>   * @start: The intermediate physical base address of the range to unmap
>   * @size:  The size of the area to unmap
>   * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>   *
>   * Clear a range of stage-2 mappings, lowering the various ref-counts.  =
Must
>   * be called while holding mmu_lock (unless for freeing the stage2 pgd b=
efore
> @@ -317,7 +318,7 @@ static void invalidate_icache_guest_page(void *va, si=
ze_t size)
>   * with things behind our backs.
>   */
>  static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t sta=
rt, u64 size,
> -                                bool may_block)
> +                                bool may_block, bool only_shared)

I found the new added only_shared  parameter to be a bit confusing,
since this patch also introduces kvm_realm_unmap_range(..., bool
unmap_private), where unmap_private has a different meaning, which I
think is really unmap_all.. It might be better if the parameter meant
the same thing everywhere.  Having helpers to sort this out, similar
to what you have with realm_unmap_range_*() might be even clearer.

Thanks,
/fuad

>  {
>         struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
>         phys_addr_t end =3D start + size;
> @@ -330,7 +331,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *m=
mu, phys_addr_t start, u64
>
>  static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start=
, u64 size)
>  {
> -       __unmap_stage2_range(mmu, start, size, true);
> +       __unmap_stage2_range(mmu, start, size, true, false);
>  }
>
>  static void stage2_flush_memslot(struct kvm *kvm,
> @@ -1771,7 +1772,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kv=
m_gfn_range *range)
>
>         __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>                              (range->end - range->start) << PAGE_SHIFT,
> -                            range->may_block);
> +                            range->may_block,
> +                            range->only_shared);
>
>         return false;
>  }
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 629a095bea61..9e5983c51393 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -79,6 +79,12 @@ static phys_addr_t __alloc_delegated_page(struct realm=
 *realm,
>         return phys;
>  }
>
> +static phys_addr_t alloc_delegated_page(struct realm *realm,
> +                                       struct kvm_mmu_memory_cache *mc)
> +{
> +       return __alloc_delegated_page(realm, mc, GFP_KERNEL);
> +}
> +
>  static void free_delegated_page(struct realm *realm, phys_addr_t phys)
>  {
>         if (realm->spare_page =3D=3D PHYS_ADDR_MAX) {
> @@ -94,6 +100,151 @@ static void free_delegated_page(struct realm *realm,=
 phys_addr_t phys)
>         free_page((unsigned long)phys_to_virt(phys));
>  }
>
> +static int realm_rtt_create(struct realm *realm,
> +                           unsigned long addr,
> +                           int level,
> +                           phys_addr_t phys)
> +{
> +       addr =3D ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +       return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level)=
;
> +}
> +
> +static int realm_rtt_fold(struct realm *realm,
> +                         unsigned long addr,
> +                         int level,
> +                         phys_addr_t *rtt_granule)
> +{
> +       unsigned long out_rtt;
> +       int ret;
> +
> +       ret =3D rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_r=
tt);
> +
> +       if (RMI_RETURN_STATUS(ret) =3D=3D RMI_SUCCESS && rtt_granule)
> +               *rtt_granule =3D out_rtt;
> +
> +       return ret;
> +}
> +
> +static int realm_destroy_protected(struct realm *realm,
> +                                  unsigned long ipa,
> +                                  unsigned long *next_addr)
> +{
> +       unsigned long rd =3D virt_to_phys(realm->rd);
> +       unsigned long addr;
> +       phys_addr_t rtt;
> +       int ret;
> +
> +loop:
> +       ret =3D rmi_data_destroy(rd, ipa, &addr, next_addr);
> +       if (RMI_RETURN_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
> +               if (*next_addr > ipa)
> +                       return 0; /* UNASSIGNED */
> +               rtt =3D alloc_delegated_page(realm, NULL);
> +               if (WARN_ON(rtt =3D=3D PHYS_ADDR_MAX))
> +                       return -1;
> +               /* ASSIGNED - ipa is mapped as a block, so split */
> +               ret =3D realm_rtt_create(realm, ipa,
> +                                      RMI_RETURN_INDEX(ret) + 1, rtt);
> +               if (WARN_ON(ret)) {
> +                       free_delegated_page(realm, rtt);
> +                       return -1;
> +               }
> +               /* retry */
> +               goto loop;
> +       } else if (WARN_ON(ret)) {
> +               return -1;
> +       }
> +       ret =3D rmi_granule_undelegate(addr);
> +
> +       /*
> +        * If the undelegate fails then something has gone seriously
> +        * wrong: take an extra reference to just leak the page
> +        */
> +       if (WARN_ON(ret))
> +               get_page(phys_to_page(addr));
> +
> +       return 0;
> +}
> +
> +static void realm_unmap_range_shared(struct kvm *kvm,
> +                                    int level,
> +                                    unsigned long start,
> +                                    unsigned long end)
> +{
> +       struct realm *realm =3D &kvm->arch.realm;
> +       unsigned long rd =3D virt_to_phys(realm->rd);
> +       ssize_t map_size =3D rme_rtt_level_mapsize(level);
> +       unsigned long next_addr, addr;
> +       unsigned long shared_bit =3D BIT(realm->ia_bits - 1);
> +
> +       if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +               return;
> +
> +       start |=3D shared_bit;
> +       end |=3D shared_bit;
> +
> +       for (addr =3D start; addr < end; addr =3D next_addr) {
> +               unsigned long align_addr =3D ALIGN(addr, map_size);
> +               int ret;
> +
> +               next_addr =3D ALIGN(addr + 1, map_size);
> +
> +               if (align_addr !=3D addr || next_addr > end) {
> +                       /* Need to recurse deeper */
> +                       if (addr < align_addr)
> +                               next_addr =3D align_addr;
> +                       realm_unmap_range_shared(kvm, level + 1, addr,
> +                                                min(next_addr, end));
> +                       continue;
> +               }
> +
> +               ret =3D rmi_rtt_unmap_unprotected(rd, addr, level, &next_=
addr);
> +               switch (RMI_RETURN_STATUS(ret)) {
> +               case RMI_SUCCESS:
> +                       break;
> +               case RMI_ERROR_RTT:
> +                       if (next_addr =3D=3D addr) {
> +                               next_addr =3D ALIGN(addr + 1, map_size);
> +                               realm_unmap_range_shared(kvm, level + 1, =
addr,
> +                                                        next_addr);
> +                       }
> +                       break;
> +               default:
> +                       WARN_ON(1);
> +               }
> +       }
> +}
> +
> +static void realm_unmap_range_private(struct kvm *kvm,
> +                                     unsigned long start,
> +                                     unsigned long end)
> +{
> +       struct realm *realm =3D &kvm->arch.realm;
> +       ssize_t map_size =3D RME_PAGE_SIZE;
> +       unsigned long next_addr, addr;
> +
> +       for (addr =3D start; addr < end; addr =3D next_addr) {
> +               int ret;
> +
> +               next_addr =3D ALIGN(addr + 1, map_size);
> +
> +               ret =3D realm_destroy_protected(realm, addr, &next_addr);
> +
> +               if (WARN_ON(ret))
> +                       break;
> +       }
> +}
> +
> +static void realm_unmap_range(struct kvm *kvm,
> +                             unsigned long start,
> +                             unsigned long end,
> +                             bool unmap_private)
> +{
> +       realm_unmap_range_shared(kvm, RME_RTT_MAX_LEVEL - 1, start, end);
> +       if (unmap_private)
> +               realm_unmap_range_private(kvm, start, end);
> +}
> +
>  u32 kvm_realm_ipa_limit(void)
>  {
>         return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> @@ -190,6 +341,30 @@ static int realm_rtt_destroy(struct realm *realm, un=
signed long addr,
>         return ret;
>  }
>
> +static int realm_create_rtt_levels(struct realm *realm,
> +                                  unsigned long ipa,
> +                                  int level,
> +                                  int max_level,
> +                                  struct kvm_mmu_memory_cache *mc)
> +{
> +       if (WARN_ON(level =3D=3D max_level))
> +               return 0;
> +
> +       while (level++ < max_level) {
> +               phys_addr_t rtt =3D alloc_delegated_page(realm, mc);
> +
> +               if (rtt =3D=3D PHYS_ADDR_MAX)
> +                       return -ENOMEM;
> +
> +               if (realm_rtt_create(realm, ipa, level, rtt)) {
> +                       free_delegated_page(realm, rtt);
> +                       return -ENXIO;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
>  static int realm_tear_down_rtt_level(struct realm *realm, int level,
>                                      unsigned long start, unsigned long e=
nd)
>  {
> @@ -265,6 +440,68 @@ static int realm_tear_down_rtt_range(struct realm *r=
ealm,
>                                          start, end);
>  }
>
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive v=
alue if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +                               unsigned long start, unsigned long end)
> +{
> +       int not_folded =3D 0;
> +       ssize_t map_size;
> +       unsigned long addr, next_addr;
> +
> +       if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +               return -EINVAL;
> +
> +       map_size =3D rme_rtt_level_mapsize(level - 1);
> +
> +       for (addr =3D start; addr < end; addr =3D next_addr) {
> +               phys_addr_t rtt_granule;
> +               int ret;
> +               unsigned long align_addr =3D ALIGN(addr, map_size);
> +
> +               next_addr =3D ALIGN(addr + 1, map_size);
> +
> +               ret =3D realm_rtt_fold(realm, align_addr, level, &rtt_gra=
nule);
> +
> +               switch (RMI_RETURN_STATUS(ret)) {
> +               case RMI_SUCCESS:
> +                       if (!WARN_ON(rmi_granule_undelegate(rtt_granule))=
)
> +                               free_page((unsigned long)phys_to_virt(rtt=
_granule));
> +                       break;
> +               case RMI_ERROR_RTT:
> +                       if (level =3D=3D RME_RTT_MAX_LEVEL ||
> +                           RMI_RETURN_INDEX(ret) < level) {
> +                               not_folded++;
> +                               break;
> +                       }
> +                       /* Recurse a level deeper */
> +                       ret =3D realm_fold_rtt_level(realm,
> +                                                  level + 1,
> +                                                  addr,
> +                                                  next_addr);
> +                       if (ret < 0)
> +                               return ret;
> +                       else if (ret =3D=3D 0)
> +                               /* Try again at this level */
> +                               next_addr =3D addr;
> +                       break;
> +               default:
> +                       return -ENXIO;
> +               }
> +       }
> +
> +       return not_folded;
> +}
> +
> +static int realm_fold_rtt_range(struct realm *realm,
> +                               unsigned long start, unsigned long end)
> +{
> +       return realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +                                   start, end);
> +}
> +
>  static void ensure_spare_page(struct realm *realm)
>  {
>         phys_addr_t tmp_rtt;
> @@ -295,6 +532,147 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia=
_bits)
>         WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>  }
>
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size,
> +                          bool unmap_private)
> +{
> +       unsigned long end =3D ipa + size;
> +       struct realm *realm =3D &kvm->arch.realm;
> +
> +       end =3D min(BIT(realm->ia_bits - 1), end);
> +
> +       ensure_spare_page(realm);
> +
> +       realm_unmap_range(kvm, ipa, end, unmap_private);
> +
> +       realm_fold_rtt_range(realm, ipa, end);
> +}
> +
> +static int find_map_level(struct realm *realm,
> +                         unsigned long start,
> +                         unsigned long end)
> +{
> +       int level =3D RME_RTT_MAX_LEVEL;
> +
> +       while (level > get_start_level(realm)) {
> +               unsigned long map_size =3D rme_rtt_level_mapsize(level - =
1);
> +
> +               if (!IS_ALIGNED(start, map_size) ||
> +                   (start + map_size) > end)
> +                       break;
> +
> +               level--;
> +       }
> +
> +       return level;
> +}
> +
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +                       unsigned long start,
> +                       unsigned long end,
> +                       unsigned long ripas)
> +{
> +       struct kvm *kvm =3D vcpu->kvm;
> +       struct realm *realm =3D &kvm->arch.realm;
> +       struct realm_rec *rec =3D &vcpu->arch.rec;
> +       phys_addr_t rd_phys =3D virt_to_phys(realm->rd);
> +       phys_addr_t rec_phys =3D virt_to_phys(rec->rec_page);
> +       struct kvm_mmu_memory_cache *memcache =3D &vcpu->arch.mmu_page_ca=
che;
> +       unsigned long ipa =3D start;
> +       int ret =3D 0;
> +
> +       while (ipa < end) {
> +               unsigned long next;
> +
> +               ret =3D rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &n=
ext);
> +
> +               if (RMI_RETURN_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
> +                       int walk_level =3D RMI_RETURN_INDEX(ret);
> +                       int level =3D find_map_level(realm, ipa, end);
> +
> +                       if (walk_level < level) {
> +                               ret =3D realm_create_rtt_levels(realm, ip=
a,
> +                                                             walk_level,
> +                                                             level,
> +                                                             memcache);
> +                               if (!ret)
> +                                       continue;
> +                       } else {
> +                               ret =3D -EINVAL;
> +                       }
> +
> +                       break;
> +               } else if (RMI_RETURN_STATUS(ret) !=3D RMI_SUCCESS) {
> +                       WARN(1, "Unexpected error in %s: %#x\n", __func__=
,
> +                            ret);
> +                       ret =3D -EINVAL;
> +                       break;
> +               }
> +               ipa =3D next;
> +       }
> +
> +       if (ripas =3D=3D RMI_EMPTY && ipa !=3D start)
> +               kvm_realm_unmap_range(kvm, start, ipa - start, true);
> +
> +       return ret;
> +}
> +
> +static int realm_init_ipa_state(struct realm *realm,
> +                               unsigned long ipa,
> +                               unsigned long end)
> +{
> +       phys_addr_t rd_phys =3D virt_to_phys(realm->rd);
> +       int ret;
> +
> +       while (ipa < end) {
> +               unsigned long next;
> +
> +               ret =3D rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +
> +               if (RMI_RETURN_STATUS(ret) =3D=3D RMI_ERROR_RTT) {
> +                       int err_level =3D RMI_RETURN_INDEX(ret);
> +                       int level =3D find_map_level(realm, ipa, end);
> +
> +                       if (WARN_ON(err_level >=3D level))
> +                               return -ENXIO;
> +
> +                       ret =3D realm_create_rtt_levels(realm, ipa,
> +                                                     err_level,
> +                                                     level, NULL);
> +                       if (ret)
> +                               return ret;
> +                       /* Retry with the RTT levels in place */
> +                       continue;
> +               } else if (WARN_ON(ret)) {
> +                       return -ENXIO;
> +               }
> +
> +               ipa =3D next;
> +       }
> +
> +       return 0;
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +                                   struct kvm_cap_arm_rme_init_ipa_args =
*args)
> +{
> +       int ret =3D 0;
> +       gpa_t addr, end;
> +       struct realm *realm =3D &kvm->arch.realm;
> +
> +       addr =3D args->init_ipa_base;
> +       end =3D addr + args->init_ipa_size;
> +
> +       if (end < addr)
> +               return -EINVAL;
> +
> +       if (kvm_realm_state(kvm) !=3D REALM_STATE_NEW)
> +               return -EINVAL;
> +
> +       ret =3D realm_init_ipa_state(realm, addr, end);
> +
> +       return ret;
> +}
> +
>  /* Protects access to rme_vmid_bitmap */
>  static DEFINE_SPINLOCK(rme_vmid_lock);
>  static unsigned long *rme_vmid_bitmap;
> @@ -418,6 +796,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm=
_enable_cap *cap)
>         case KVM_CAP_ARM_RME_CREATE_RD:
>                 r =3D kvm_create_realm(kvm);
>                 break;
> +       case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
> +               struct kvm_cap_arm_rme_init_ipa_args args;
> +               void __user *argp =3D u64_to_user_ptr(cap->args[1]);
> +
> +               if (copy_from_user(&args, argp, sizeof(args))) {
> +                       r =3D -EFAULT;
> +                       break;
> +               }
> +
> +               r =3D kvm_init_ipa_range_realm(kvm, &args);
> +               break;
> +       }
>         default:
>                 r =3D -EINVAL;
>                 break;
> --
> 2.34.1
>

