Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9749CFC5F5
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKNMN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:13:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726115AbfKNMNZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 07:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573733603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZnck4rX9SmE/n51pQrh/Xw2Zl6hoiU/UzHDNQl/qbU=;
        b=XxxPFTVKazyDu/QmCzCWWgA8HDfzTQdvIl2OiR2AMihAG6Daq+7CnoWMAKkabCf/OAndWg
        4edXz0rYSv3OTfl1dCBI04y2XuklmoXC2R5zqwVrGernbp7HjSd4yzdVSQIjyewsGv4/UZ
        uKm9HMouwBrX3Y3bte7ZXTQaLk97VdU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-YFvIrlkPNZSwBWpjDElKmQ-1; Thu, 14 Nov 2019 07:13:20 -0500
Received: by mail-wr1-f70.google.com with SMTP id w9so4324373wrn.9
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qm2WmHmzUm5vMMu5JnWcwUEqIaPgt1IyJyPsTjQ0eyE=;
        b=tiIIdTNcyBVMEyZDwJq/cdnuqs4eGJs4NeJ/jMnqmk9QQmuVIJHDOy6zglbnRplHgJ
         rwrf1dLWnFtyWraft1MR2s2P1liPVizXXpw9mGQr4dZq9MO2c88bNjsPvvbrPQe+HSDg
         8Ph0sOm0aTUhGbEr/GCkWM3hm4es0KhTn5VLhN59AQRWBrvKjfsBIte1PMxJePVKXyTP
         MMHxX3Z3Q07xz0tNcNnrs9imOJ6xv3VAUgJUCJaUisGpmlxhfs9OZTFZsb3eg+m+smDh
         MoFHpClhHL7E7QISPdnet3rEHaZqbQw8Xyy3IVlwwweYbVK49tq8F8/dSTZM6SXaeK08
         3w4g==
X-Gm-Message-State: APjAAAVayMrUW/ftWTvq9AJ2BEvChOm2tuKqJah7/tZPXL7KuK67ETDu
        XDpMx9/YaLFPre1oixYYFWJ6m/zE5MIBzhldbtW/ZE9ogZerQ0QUuj7Rm7Br1qiI1/S0Rm9fLbN
        Bm4dc+GyUbMgd
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr7652732wrn.393.1573733599253;
        Thu, 14 Nov 2019 04:13:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAQfF/ixJELPI3bg1TknQFZhcvASKK15bDOHZYTUubk4Xqo3xC5XlmX6NljWPMtAhyqiBBwA==
X-Received: by 2002:adf:e8ce:: with SMTP id k14mr7652706wrn.393.1573733598925;
        Thu, 14 Nov 2019 04:13:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id l26sm5412622wme.6.2019.11.14.04.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 04:13:18 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Take slots_lock when using
 kvm_mmu_zap_all_fast()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191113193032.12912-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8d80118-9a8c-fb98-158d-cfd741eb0033@redhat.com>
Date:   Thu, 14 Nov 2019 13:13:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191113193032.12912-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: YFvIrlkPNZSwBWpjDElKmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 20:30, Sean Christopherson wrote:
> Acquire the per-VM slots_lock when zapping all shadow pages as part of
> toggling nx_huge_pages.  The fast zap algorithm relies on exclusivity
> (via slots_lock) to identify obsolete vs. valid shadow pages, e.g. it
> uses a single bit for its generation number.  Holding slots_lock also
> obviates the need to acquire a read lock on the VM's srcu.
>=20
> Failing to take slots_lock when toggling nx_huge_pages allows multiple
> instances of kvm_mmu_zap_all_fast() to run concurrently, as the other
> user, KVM_SET_USER_MEMORY_REGION, does not take the global kvm_lock.
> Concurrent fast zap instances causes obsolete shadow pages to be
> incorrectly identified as valid due to the single bit generation number
> wrapping, which results in stale shadow pages being left in KVM's MMU
> and leads to all sorts of undesirable behavior.
>=20
> The bug is easily confirmed by running with CONFIG_PROVE_LOCKING and
> toggling nx_huge_pages via its module param.
>=20
> Note, the fast zap algorithm could use a 64-bit generation instead of
> relying on exclusivity for correctness, but all callers except the
> recently added set_nx_huge_pages() need to hold slots_lock anyways.
> Given that toggling nx_huge_pages is by no means a fast path, force it
> to conform to the current approach instead of reworking the algorithm to
> support concurrent calls.
>=20
> Fixes: b8e8c8303ff28 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/mmu.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cf718fa23dff..2ce9da58611e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -6285,14 +6285,13 @@ static int set_nx_huge_pages(const char *val, con=
st struct kernel_param *kp)
> =20
>  =09if (new_val !=3D old_val) {
>  =09=09struct kvm *kvm;
> -=09=09int idx;
> =20
>  =09=09mutex_lock(&kvm_lock);
> =20
>  =09=09list_for_each_entry(kvm, &vm_list, vm_list) {
> -=09=09=09idx =3D srcu_read_lock(&kvm->srcu);
> +=09=09=09mutex_lock(&kvm->slots_lock);
>  =09=09=09kvm_mmu_zap_all_fast(kvm);
> -=09=09=09srcu_read_unlock(&kvm->srcu, idx);
> +=09=09=09mutex_unlock(&kvm->slots_lock);
> =20
>  =09=09=09wake_up_process(kvm->arch.nx_lpage_recovery_thread);
>  =09=09}
>=20

Queued, thanks.

Paolo

