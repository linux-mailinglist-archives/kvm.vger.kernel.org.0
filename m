Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74448F82D5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 23:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKKWUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 17:20:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726939AbfKKWUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 17:20:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573510832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=UIFl6RmKYvRvDaC9fCanWXjZvHHx2uDomG3MEDvY3qg=;
        b=idmSHDSDHkyBbCT66Y1lnQNF36NATim8YPh41M/JRZOKIpIZCSesjosimZZ9qL76x7tlfn
        nJKeKJZqNJ21Mycv8fYDW7PhTPis3VsF+BJ5Y+uUzCBuvkpjSR4eryxDApVf8z9cJji95C
        mI1CoAi6gBfwBN37Rv8unQTtFnAySqE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-iL9Bi98JNzaYg9yanTJVqw-1; Mon, 11 Nov 2019 17:20:30 -0500
Received: by mail-wr1-f69.google.com with SMTP id p6so10778705wrs.5
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 14:20:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ElUsUIBHVYFueoajxjC1Kl74zzWp1gWpLdEqumq8Hjw=;
        b=Z+0PgSbCyObGaC9QD/Djn24Nbg3CMPFZ3a+UlFAY8gNDARGLW6USLQgxNr8XW/m3Y/
         yg/C+0R4iV2rvOq6v7YGFpFg8sRChOeYI/KUk2gr0FZRneOiTIysiw/TaosdVojQDiFD
         q/OiLj5SX6cl00nlySi8KouG4r85NxZEDlp3RUN+oum+p8NbWEiYa+gPmLIoJO/RycBC
         S3Ou7v6RNGIcSU68Uff0HXGgqJ4lPE7dDtTMt8JFMngyemA3qF22TWgLbp2yerY6NqOO
         UoTMOkSSf/GmlcTdXs63HbXKB9MsiSsoPJSiKb46zkB+reLhER3ihKSIpWaeAquNfal7
         TtRA==
X-Gm-Message-State: APjAAAUa49+iNidzkpa4Kn2XuthonSYJET9pNmiWjiOvKid2fyepTyBo
        GoOJ9h8v3w/ZHXr5MoX6qO9IA2ciAeqF5L1ES5xR9RKtySO8jtPl4yAj2Sl3prZ018G2y3kuT3i
        z+njVR2a6mRUD
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr13729958wrr.88.1573510829301;
        Mon, 11 Nov 2019 14:20:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFPwqxhXxeAs0oL0Dbs5sot6UdqdoMZ4qtgoJqKMBpzKaZcxnJ8IkS9GT/UFBY0Amj9EWzQg==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr13729930wrr.88.1573510828911;
        Mon, 11 Nov 2019 14:20:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id 4sm1494255wmd.33.2019.11.11.14.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 14:20:28 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20191111221229.24732-1-sean.j.christopherson@intel.com>
 <20191111221229.24732-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <85ab4f91-973f-f12d-5361-6125ac524bb4@redhat.com>
Date:   Mon, 11 Nov 2019 23:20:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111221229.24732-2-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: iL9Bi98JNzaYg9yanTJVqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 23:12, Sean Christopherson wrote:
> Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
> instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
> like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
> pages, e.g. put pages grabbed via gup().  But for flows such as setting
> A/D bits or shifting refcounts for transparent huge pages, KVM needs to
> to avoid processing ZONE_DEVICE pages as the flows in question lack the
> underlying machinery for proper handling of ZONE_DEVICE pages.
>=20
> This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
> when running a KVM guest backed with /dev/dax memory, as KVM straight up
> doesn't put any references to ZONE_DEVICE pages acquired by gup().
>=20
> Note, Dan Williams proposed an alternative solution of doing put_page()
> on ZONE_DEVICE pages immediately after gup() in order to simplify the
> auditing needed to ensure is_zone_device_page() is called if and only if
> the backing device is pinned (via gup()).  But that approach would break
> kvm_vcpu_{un}map() as KVM requires the page to be pinned from map() 'til
> unmap() when accessing guest memory, unlike KVM's secondary MMU, which
> coordinates with mmu_notifier invalidations to avoid creating stale
> page references, i.e. doesn't rely on pages being pinned.
>=20
> [*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl
>=20
> Reported-by: Adam Borowski <kilobyte@angband.pl>
> Debugged-by: David Hildenbrand <david@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu.c       |  8 ++++----
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 26 +++++++++++++++++++++++---
>  3 files changed, 28 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24c23c66b226..bf82b1f2e834 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_=
vcpu *vcpu,
>  =09 * here.
>  =09 */
>  =09if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> -=09    level =3D=3D PT_PAGE_TABLE_LEVEL &&
> +=09    !kvm_is_zone_device_pfn(pfn) && level =3D=3D PT_PAGE_TABLE_LEVEL =
&&
>  =09    PageTransCompoundMap(pfn_to_page(pfn)) &&
>  =09    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>  =09=09unsigned long mask;
> @@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm=
 *kvm,
>  =09=09 * the guest, and the guest page table is using 4K page size
>  =09=09 * mapping if the indirect sp has level =3D 1.
>  =09=09 */
> -=09=09if (sp->role.direct &&
> -=09=09=09!kvm_is_reserved_pfn(pfn) &&
> -=09=09=09PageTransCompoundMap(pfn_to_page(pfn))) {
> +=09=09if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> +=09=09    !kvm_is_zone_device_pfn(pfn) &&
> +=09=09    PageTransCompoundMap(pfn_to_page(pfn))) {
>  =09=09=09pte_list_remove(rmap_head, sptep);
> =20
>  =09=09=09if (kvm_available_flush_tlb_with_range())
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a817e446c9aa..4ad1cd7d2d4d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
> =20
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
> =20
>  struct kvm_irq_ack_notifier {
>  =09struct hlist_node link;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b8534c6b8cf6..bc9d10a0a334 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -149,10 +149,30 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(s=
truct kvm *kvm,
>  =09return 0;
>  }
> =20
> +bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
> +{
> +=09/*
> +=09 * The metadata used by is_zone_device_page() to determine whether or
> +=09 * not a page is ZONE_DEVICE is guaranteed to be valid if and only if
> +=09 * the device has been pinned, e.g. by get_user_pages().  WARN if the
> +=09 * page_count() is zero to help detect bad usage of this helper.
> +=09 */
> +=09if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> +=09=09return false;
> +
> +=09return is_zone_device_page(pfn_to_page(pfn));
> +}
> +
>  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  {
> +=09/*
> +=09 * ZONE_DEVICE pages currently set PG_reserved, but from a refcountin=
g
> +=09 * perspective they are "normal" pages, albeit with slightly differen=
t
> +=09 * usage rules.
> +=09 */
>  =09if (pfn_valid(pfn))
> -=09=09return PageReserved(pfn_to_page(pfn));
> +=09=09return PageReserved(pfn_to_page(pfn)) &&
> +=09=09       !kvm_is_zone_device_pfn(pfn);
> =20
>  =09return true;
>  }
> @@ -1865,7 +1885,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
> =20
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -=09if (!kvm_is_reserved_pfn(pfn)) {
> +=09if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
>  =09=09struct page *page =3D pfn_to_page(pfn);
> =20
>  =09=09SetPageDirty(page);
> @@ -1875,7 +1895,7 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
> =20
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>  {
> -=09if (!kvm_is_reserved_pfn(pfn))
> +=09if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
>  =09=09mark_page_accessed(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
>=20

Queued, thanks -- the other two will wait for after the merge window to
avoid pointless conflicts.

Paolo

