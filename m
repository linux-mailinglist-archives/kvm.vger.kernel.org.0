Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A097EFB38A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfKMPRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:17:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38379 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728001AbfKMPRh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 10:17:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573658255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=DHAqX8RcvAIHAuVSZ69+q1sWNGsxB3GIwUNUQ8KFKI8=;
        b=BwznO0XNMURZHth1ZeEjJ9iN0sLxmECAmyiGvyg5NKKH96k0JRzeAvY67g5z84dMlSF0X1
        Lvs4rPjnZq7aVv+//HJrC/8JTRnc/cx/Z9K1+IQexMTW9Az9NDw9QyqSFwBCkYsV8FA6aY
        syrzh0GKLakpu9QW7FOB2pobe/cVP8U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-ltqKthYPOVexBAdLiTboqQ-1; Wed, 13 Nov 2019 10:17:34 -0500
Received: by mail-wm1-f71.google.com with SMTP id f14so1327953wmc.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:17:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iU7f79RSImejsy4p/dMRUFyBBeqZr/ltN41Lsmwim/Q=;
        b=cGZg/kOrtmNN0eCjfDPRxzHO9XB90/shTWMEJ7MeubTvmg8//oy8Ofq2B0zLL1T5Ii
         3UKoZ1E3xN9sJdZscBXXRvK6++v9w9zTBCc1TarNj4KmfdLUsmaMaojSsEOK24GLE0Nx
         2vyAG5QRyh17dfDp1HqqIMaIq5LHyvg+R5efeTG5dDPui0Z3TY5j9VKkh1mXkrIZPpQ1
         08TyA0IKav/LvU9RwVbK/pVm/z6W5DcpuRxRMZSc9KeCf+KJGntGR2GHhBouwN5VTm87
         WCwPMW+2kKM2h/yCoxEYfIqtokdQGguBo/SBRw76a/k9Enu0qQTDTB6HwLcs26sjW9Ak
         zHGg==
X-Gm-Message-State: APjAAAWkrRgyaeMJXdSOAOhBVc2hV42vYmRQNyoI6moP7+AiFhoz070e
        3ZXgIaK1+DrSdz3EwXmAr2vWtaZGiDNrGO94tzGvt1kE8jJc++2UYyWFHFSQi0kKQCc6WyX2je4
        4HcKejtoHLJBw
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr3185313wrj.172.1573658252847;
        Wed, 13 Nov 2019 07:17:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKUbDaRpRzyuPAHHMDpzVB8umqljAbcBQ2RMcZPovqlnqW+six3vY2Xp6NR0hrNp0abae27A==
X-Received: by 2002:adf:cc8e:: with SMTP id p14mr3185288wrj.172.1573658252519;
        Wed, 13 Nov 2019 07:17:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:64a1:540d:6391:74a9? ([2001:b07:6468:f312:64a1:540d:6391:74a9])
        by smtp.gmail.com with ESMTPSA id x11sm3154081wro.84.2019.11.13.07.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 07:17:31 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Optimization: Requst TLB flush in
 fast_cr3_switch() instead of do it directly
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Bhavesh Davda <bhavesh.davda@oracle.com>
References: <20191112183300.6959-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6292b4ef-64df-5e37-dcf7-a359f3268a6f@redhat.com>
Date:   Wed, 13 Nov 2019 16:17:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191112183300.6959-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: ltqKthYPOVexBAdLiTboqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 19:33, Liran Alon wrote:
> When KVM emulates a nested VMEntry (L1->L2 VMEntry), it switches mmu root
> page. If nEPT is used, this will happen from
> kvm_init_shadow_ept_mmu()->__kvm_mmu_new_cr3() and otherwise it will
> happpen from nested_vmx_load_cr3()->kvm_mmu_new_cr3(). Either case,
> __kvm_mmu_new_cr3() will use fast_cr3_switch() in attempt to switch to a
> previously cached root page.
>=20
> In case fast_cr3_switch() finds a matching cached root page, it will
> set it in mmu->root_hpa and request KVM_REQ_LOAD_CR3 such that on
> next entry to guest, KVM will set root HPA in appropriate hardware
> fields (e.g. vmcs->eptp). In addition, fast_cr3_switch() calls
> kvm_x86_ops->tlb_flush() in order to flush TLB as MMU root page
> was replaced.
>=20
> This works as mmu->root_hpa, which vmx_flush_tlb() use, was
> already replaced in cached_root_available(). However, this may
> result in unnecessary INVEPT execution because a KVM_REQ_TLB_FLUSH
> may have already been requested. For example, by prepare_vmcs02()
> in case L1 don't use VPID.
>=20
> Therefore, change fast_cr3_switch() to just request TLB flush on
> next entry to guest.
>=20
> Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24c23c66b226..150d982ec1d2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4295,7 +4295,7 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, =
gpa_t new_cr3,
>  =09=09=09kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
>  =09=09=09if (!skip_tlb_flush) {
>  =09=09=09=09kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> -=09=09=09=09kvm_x86_ops->tlb_flush(vcpu, true);
> +=09=09=09=09kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>  =09=09=09}
> =20
>  =09=09=09/*
>=20

Queued, thanks.

(I should get kvm/queue properly tested and pushed by the end of this week)=
.

Paolo

