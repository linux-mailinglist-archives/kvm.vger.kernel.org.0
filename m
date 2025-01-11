Return-Path: <kvm+bounces-35219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33351A0A44F
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 15:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31472160E2B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 14:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BE91AF0CE;
	Sat, 11 Jan 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="IbJasbds";
	dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="QfQSnP0z"
X-Original-To: kvm@vger.kernel.org
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723A1F16B;
	Sat, 11 Jan 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736607055; cv=pass; b=i7TGhbTVYYEAdhFhhZzEE5QXLaxJ0TyFae21XJUpedDIM7NAtet+ySvuEZ+doUtGeSFzdrY7LtwH68Se6gGcPImqCl9ZMPlB+lnccuulAdO9hVI+kBN8mYtlSqqS0OPJoeyGSElVzSiZfbIriirFpJ3UlvHobqrTL5sQbDQilFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736607055; c=relaxed/simple;
	bh=A5hUsZpX4kwHZ5z13ZE4CGkSD85ppexj2cymgd5/F04=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=JeMpSSlyU6KQfuKpB9KahhuBGlwY5mkjWjEznWs9S1EiNrc2FnO/FAbfuJeP0cKjif+KZvzmjXC/12lnjZWGevdEi79cMo233YWt8xmERsatk0LPZWpPhl67Zo9PNOtb8Ade3bVtMPdhdvmm2HPR95qFliDz0817fP9fck3386w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de; spf=none smtp.mailfrom=xenosoft.de; dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=IbJasbds; dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=QfQSnP0z; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=xenosoft.de
ARC-Seal: i=1; a=rsa-sha256; t=1736606868; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=om/vED0/Sahl5HNXMWabjBxkbojeojay8ryan9mYjl3xth6lgMuxqAVXy1ueh8q3/4
    pJI93WWe1FCDVkhpLsYHpmhdwQ56/11zfRZ7vQDdy+KQ/RKBn8w+FLKeZ1ILtFebT8sh
    AsCR9aDEvEwsEorZWisTuK0/5KMmHHCHLIql6C/HXAy6cdrTNkXQcvf/FP4kHYLESqt0
    OyfqljjTwvEHQCbt7SH0oU4+x7mfef5Iy+ctnz8IgzylRtARoSvusGLpj89tUeMFPIBD
    S4HmicOvshQQluDL8ywkjNAKmY07+1oPqQOL4Zt618kw+MD6TTUHnl1bdUyq8XlwWmno
    ZXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1736606868;
    s=strato-dkim-0002; d=strato.com;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=B8Z4pHbqoRqk3L39a4j21vmLxDvw20WM3wKz6CMTLd4=;
    b=rKhK3hPpV+VJsLxTdx94FdAf783/3czbCHA3s+73OZRxfz1OwZd5x8RYkrbsFsFuLI
    WA0am9KkIddV3aKuO5I1KUxwIGlBBHm+o0NwQN2B4ZAohQchXYOJzKh/mW1MyZJc3s+Y
    Vc6eapfv3krgDAEw71aEuID8oEuc33x6KACHApjiyDoJEsfmUM//6a76xI8ercnwFVNE
    qrk+nW80WYFDF6TrEWa6BVmiai3JRQuPLs0I9JpFanXh8StVx+Rhe1TO/ne9z9/hmww0
    ilfmlrkZ4Xv8H2g51DcZTYfHp1rRip4cab/KvkUFXHGqjri5vZfvXKtcvG/3oO0pCsPF
    hsPA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1736606868;
    s=strato-dkim-0002; d=xenosoft.de;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=B8Z4pHbqoRqk3L39a4j21vmLxDvw20WM3wKz6CMTLd4=;
    b=IbJasbdsd4Tk/yX5RFbEZL0rLMzn7bhqMP1hkDBhpodmz5v2mheTsWIcOttXba4eum
    gO3PfbGhni9PCA7iOEkBdJFRGRQRBkWQEgRtd1qRjZ3fuJz0UaVrkhAh9Cr86J2Yte9X
    gffFYbSd+pwRwYy+ArF1U9bVbZD2PcuSha48RE+suzcp5w90TXelWBP9r+vqjFyytpvG
    pVBlTgTc1+FcSJzpL/pR4HFRItSv2atGltawLN+JXQo+XlfP1LM664Ka+DtpcRfMj5lY
    RkMovrGcNvm7wmBo0RJI+DogAdUbizA85cq0fSuo5s2y0P6q5zrauASe3s41neGp9sKF
    tPvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1736606868;
    s=strato-dkim-0003; d=xenosoft.de;
    h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:Cc:Date:
    From:Subject:Sender;
    bh=B8Z4pHbqoRqk3L39a4j21vmLxDvw20WM3wKz6CMTLd4=;
    b=QfQSnP0z3Ok54I5Vi70PB3VZelgWffKaILeBOAdC4dKe6Up/xBk/vuClXCFrIP66Ro
    fsRJO8DlaePnsFzyAOBQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr6Kxrf+5Dj7x4QgaMrvdtcX133EipGzhGnb3rrLiUtW3TtSfq8MBVvg=="
Received: from smtpclient.apple
    by smtp.strato.de (RZmta 51.2.16 AUTH)
    with ESMTPSA id ebe9c910BElmocD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 11 Jan 2025 15:47:48 +0100 (CET)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Christian Zigotzky <chzigotzky@xenosoft.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: [PATCH] KVM: allow NULL writable argument to __kvm_faultin_pfn
Date: Sat, 11 Jan 2025 15:47:37 +0100
Message-Id: <4C777C7B-4DC0-4428-BB70-34BECAC4828F@xenosoft.de>
References: <Z3wnsQQ67GBf1Vsb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 regressions@lists.linux.dev, Trevor Dickinson <rtd2@xtra.co.nz>,
 mad skateman <madskateman@gmail.com>,
 Darren Stevens <darren@stevens-zone.net>, hypexed@yahoo.com.au,
 Christian Zigotzky <info@xenosoft.de>
In-Reply-To: <Z3wnsQQ67GBf1Vsb@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: iPhone Mail (22C152)



> On 06 January 2025 at 07:57 pm, Sean Christopherson <seanjc@google.com> wr=
ote:
>=20
> =EF=BB=BFOn Wed, Jan 01, 2025, Paolo Bonzini wrote:
>> kvm_follow_pfn() is able to work with NULL in the .map_writable field
>> of the homonymous struct.  But __kvm_faultin_pfn() rejects the combo
>> despite KVM for e500 trying to use it.  Indeed .map_writable is not
>> particularly useful if the flags include FOLL_WRITE and readonly
>> guest memory is not supported, so add support to __kvm_faultin_pfn()
>> for this case.
>=20
> I would prefer to keep the sanity check to minimize the risk of a page fau=
lt
> handler not supporting opportunistic write mappings.  e500 is definitely t=
he
> odd one out here.
>=20
> What about adding a dedicated wrapper for getting a writable PFN?  E.g. (u=
ntested)
>=20
> ---
> arch/powerpc/kvm/e500_mmu_host.c | 2 +-
> arch/x86/kvm/vmx/vmx.c           | 3 +--
> include/linux/kvm_host.h         | 8 ++++++++
> 3 files changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_=
host.c
> index e5a145b578a4..2251bb30b8ec 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -444,7 +444,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc=
_vcpu_e500 *vcpu_e500,
>=20
>    if (likely(!pfnmap)) {
>        tsize_pages =3D 1UL << (tsize + 10 - PAGE_SHIFT);
> -        pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
> +        pfn =3D kvm_faultin_writable_pfn(slot, gfn, &page);
>        if (is_error_noslot_pfn(pfn)) {
>            if (printk_ratelimit())
>                pr_err("%s: real page not found for gfn %lx\n",
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 893366e53732..7012b583f2e8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6800,7 +6800,6 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
>    struct page *refcounted_page;
>    unsigned long mmu_seq;
>    kvm_pfn_t pfn;
> -    bool writable;
>=20
>    /* Defer reload until vmcs01 is the current VMCS. */
>    if (is_guest_mode(vcpu)) {
> @@ -6836,7 +6835,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
>     * controls the APIC-access page memslot, and only deletes the memslot
>     * if APICv is permanently inhibited, i.e. the memslot won't reappear.
>     */
> -    pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcount=
ed_page);
> +    pfn =3D kvm_faultin_writable_pfn(slot, gfn, &refcounted_page);
>    if (is_error_noslot_pfn(pfn))
>        return;
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c788d0bd952a..b0af7c7f99da 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1287,6 +1287,14 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_=
vcpu *vcpu, gfn_t gfn,
>                 write ? FOLL_WRITE : 0, writable, refcounted_page);
> }
>=20
> +static inline kvm_pfn_t kvm_faultin_writable_pfn(const struct kvm_memory_=
slot *slot,
> +                         gfn_t gfn, struct page **refcounted_page)
> +{
> +    bool writable;
> +
> +    return __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, refcounted=
_page);
> +}
> +
> int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset=
,
>            int len);
> int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long l=
en);
>=20
> base-commit: 2c3412e999738bfd60859c493ff47f5c268814a3
> --

This patch works. Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>

Thanks=


