Return-Path: <kvm+bounces-35220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7138FA0A451
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 15:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63CDE1679F6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 14:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996A51AF4E9;
	Sat, 11 Jan 2025 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="RKqrya7d";
	dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b="zVLeKOdJ"
X-Original-To: kvm@vger.kernel.org
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FF31F16B;
	Sat, 11 Jan 2025 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736607370; cv=pass; b=XvKhRWrEvq6JRxBJylnpIkJIy0+SASX3R3rsXdtfvOiWp0DzLgOCGPdHLcqOjVX3RXGCSkptnfIPV1o+62ebHy87nxOiigxgUNHUvjD/7sJ06+EijQnyhS3HssZJqh3co5JB107JMGxdIXuwRYAW26nHR3Q343h9/4OlJwQZbxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736607370; c=relaxed/simple;
	bh=GmNUYXbW0stz9YpjVbxk2xCGykrIz+exrdpJcUmHzp8=;
	h=Content-Type:From:Mime-Version:Subject:Message-Id:Date:Cc:To; b=J6YXQv3xu5Oq1QdsqBQVymOCge4bvZDT0GmvtJoIRsS4uhjXvs+lnrBPVqst/aik0Lrtecc9iXL4QfWDFU2VvKBuxpk3BM33ip1HHTmwZMcR7mJJmXo3wUjzmVrI4iPw/f4jT4YpgoVUt1XP0FB0R2CpE49WCN3ctk0ggTTIpJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de; spf=none smtp.mailfrom=xenosoft.de; dkim=pass (2048-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=RKqrya7d; dkim=permerror (0-bit key) header.d=xenosoft.de header.i=@xenosoft.de header.b=zVLeKOdJ; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xenosoft.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=xenosoft.de
ARC-Seal: i=1; a=rsa-sha256; t=1736607000; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lRkvNHqyK5XlAuh6r6jERbRFWgRju6SpO5pl7k9amkYTo4xl4mdc7vmBJpGfaWcmag
    vsSn0B0tVezSp0ALVD5vRiiPAuiW/+UYT0sLETpS3upBH6T1w54gOgQuZa/BxEHM9ZiZ
    J8R54nh76kEG/N40KasJONAauicgoaoMjZalzfVI9kl918TKbiVNMDs6DaxWwThFp1Lp
    XdlFqtdLP8Nev3BygDZSKa3/tgHAUqoY9bDDk5WTQAxFoglRYjbf1Y9XbUHDFRghokZt
    sAwaQ1HcW1dXkQ2TbLLa7DiF3kD5daJwljpEGFwAM+zchYQi57ZukaRpwDFKtP5rCUe6
    niyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1736607000;
    s=strato-dkim-0002; d=strato.com;
    h=To:Cc:Date:Message-Id:Subject:From:Cc:Date:From:Subject:Sender;
    bh=/S7RsMxdj1ne5QxEiHyZk2JZuHApikcEL56Y6qd2g7o=;
    b=Ou5WaLEckLFyXU81Vzs5gC4Pkmu7+70nXMXwTeY7ItOz4OnZD+iYFn9DYkRHMqIB/y
    +seDmwmeQyqi1wC7vbDPTsWPManxhWoXzFR1UGQhD/cHGLWX7gHYf+jN7kYId/wOca2g
    pH0gFD5DQ7nWDWqpJvx7Ex052aPs93zhgdPvxQalAvlnHQkgtURe7rY7xuhGlKJ/SKrM
    tsTuEivngZmA8b6icJDbVvGQ63SplcTerxo6yoDd7tv7FYyqXzyAZe3/jhQJAysvKA+B
    tYfKj6vJZCCrOQS68GjXvnZV8pssACeyqMj0ATSDyu+x4e9xxW5S8QtArnh2vh1ZstC0
    tI3Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1736607000;
    s=strato-dkim-0002; d=xenosoft.de;
    h=To:Cc:Date:Message-Id:Subject:From:Cc:Date:From:Subject:Sender;
    bh=/S7RsMxdj1ne5QxEiHyZk2JZuHApikcEL56Y6qd2g7o=;
    b=RKqrya7dtMMHzvNn0jdXw35N2hBWMwbq9SGzB2/IBrpwxb6rOLtVwyZ5sNWaVYunY3
    A8dPjC/+X/8qiq4sIAVVjrhqvgZLB+o4dPEkJ46E4dKBBtCycysdZ6gkwlNDJzjKPGhJ
    8GAdNNsYaL00Z574rjL2MBq+k4NqHZ+3dNJj7LURFcbi8dSxZR7V2eqThQKMro3lcEFw
    hI2Vg9CXOboisxvEwS3l889HLtcruzFknlj/znABBAf5OV0/Ti7I3DCp/ZZodXp3OmdA
    4SeWpfIXc4Fs06La8CKzrloHynCri+S8G/v9qNo/inCctIZHIWR5+83M+pQKLbs9/muN
    Hdbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1736607000;
    s=strato-dkim-0003; d=xenosoft.de;
    h=To:Cc:Date:Message-Id:Subject:From:Cc:Date:From:Subject:Sender;
    bh=/S7RsMxdj1ne5QxEiHyZk2JZuHApikcEL56Y6qd2g7o=;
    b=zVLeKOdJfaID0ByuekF5FZelS+RSwf4wEMLCgD/pLvWoBUUyYpwHhhN2D+fCi9muen
    kP9wsx0DYYwCHlUQ6kBQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr6Kxrf+5Dj7x4QgaMrvdtcX133EipGzhGnb3rrLiUtW3TtSfq8MBVvg=="
Received: from smtpclient.apple
    by smtp.strato.de (RZmta 51.2.16 AUTH)
    with ESMTPSA id ebe9c910BEo0ocG
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 11 Jan 2025 15:50:00 +0100 (CET)
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
Message-Id: <B5B8A435-B985-47CB-8240-AFDAB3692B6A@xenosoft.de>
Date: Sat, 11 Jan 2025 15:49:50 +0100
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 regressions@lists.linux.dev, Trevor Dickinson <rtd2@xtra.co.nz>,
 mad skateman <madskateman@gmail.com>,
 Darren Stevens <darren@stevens-zone.net>, hypexed@yahoo.com.au,
 Christian Zigotzky <info@xenosoft.de>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: iPhone Mail (22C152)

=EF=BB=BF

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
>   if (likely(!pfnmap)) {
>       tsize_pages =3D 1UL << (tsize + 10 - PAGE_SHIFT);
> -        pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
> +        pfn =3D kvm_faultin_writable_pfn(slot, gfn, &page);
>       if (is_error_noslot_pfn(pfn)) {
>           if (printk_ratelimit())
>               pr_err("%s: real page not found for gfn %lx\n",
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 893366e53732..7012b583f2e8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6800,7 +6800,6 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
>   struct page *refcounted_page;
>   unsigned long mmu_seq;
>   kvm_pfn_t pfn;
> -    bool writable;
>=20
>   /* Defer reload until vmcs01 is the current VMCS. */
>   if (is_guest_mode(vcpu)) {
> @@ -6836,7 +6835,7 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
>    * controls the APIC-access page memslot, and only deletes the memslot
>    * if APICv is permanently inhibited, i.e. the memslot won't reappear.
>    */
> -    pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcount=
ed_page);
> +    pfn =3D kvm_faultin_writable_pfn(slot, gfn, &refcounted_page);
>   if (is_error_noslot_pfn(pfn))
>       return;
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index c788d0bd952a..b0af7c7f99da 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1287,6 +1287,14 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_=
vcpu *vcpu, gfn_t gfn,
>                write ? FOLL_WRITE : 0, writable, refcounted_page);
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
>           int len);
> int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long l=
en);
>=20
> base-commit: 2c3412e999738bfd60859c493ff47f5c268814a3
> --

This patch works. Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>

Thanks=


