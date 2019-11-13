Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB10FACBE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 10:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfKMJUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 04:20:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726138AbfKMJUX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 04:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573636822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGXER1UjhVXuSY8VWobSaIItzt+ADu1QjsvqwOrHP1s=;
        b=XcNU8wmdfwQUSO0pWUyrTiBy6q/Dw9zMoIACDO2rIDU+CY1CxKkx/9FLfGOS2MxstYPwtG
        qQvloz1eRrR29Om0iva0HPYqXo4+t/Hz8eFCKyL9EQyrrHnCeapkntb5afUPodFERE2AjE
        2YlMBdUR44m3tZ8FrnIVpSJUra0QSZc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-UMacf3GDODCkCuq7_QBQ1A-1; Wed, 13 Nov 2019 04:20:21 -0500
Received: by mail-wr1-f70.google.com with SMTP id q12so1240001wrr.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 01:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mnNNwnBUcnS7UmMioOjfLEOpDsEJoW+9XpFJb4a+vHQ=;
        b=qGTuQ9JAWEDKSVajNh6JGJA+FreIudVBEj/x3CkjNpmAEVNHNl1h9BJxMjKa0tC3f+
         PCN9rhqvFD9nU91OJFpBiEKv2zawnsmDIIWVW804T2TBu2PwuyemdXdkckuGbvDM7Zkf
         dc8G4bomI91fN3dAq0/Ao9+YzrccqUo1fCSG8yktsMhFrMwOImiTM7dyAYYowBdRYkpV
         dI0g9QEONGw5PuZPS6pPNb0VwJTgkik2qvZyZgBlJw0mRzcUswYl6CdsyMv/UmzJLYgH
         suiIoqSpttC2IXi1hSb+31+5WVtn9ptAdSPquZMkCUB10dRR+wP4BZLNkz6alkIgjFmK
         C7KQ==
X-Gm-Message-State: APjAAAWASJYidsDLgPOybp4MQnPosZ8HoqX7GZzpWZO1udGVEBhVgECe
        rNMFvgFOR00G2heKkdcXJn62u/jsWrMlZn6VtHESX39P9vPs5qU1ogQtiQ4naoBFlW4jzoG1x2/
        RnBWK+TDe1OX+
X-Received: by 2002:adf:fe0c:: with SMTP id n12mr1761419wrr.174.1573636819671;
        Wed, 13 Nov 2019 01:20:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwj7US7VRQmfzJkEkr/eu9Tt8DqOjk1+3sUzd0i/qYYb7JPmVKy0mBHCQ29WrDqWQEP8mJADg==
X-Received: by 2002:adf:fe0c:: with SMTP id n12mr1761396wrr.174.1573636819317;
        Wed, 13 Nov 2019 01:20:19 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j10sm2133105wrx.30.2019.11.13.01.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 01:20:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        Liran Alon <liran.alon@oracle.com>,
        Bhavesh Davda <bhavesh.davda@oracle.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Optimization: Requst TLB flush in fast_cr3_switch() instead of do it directly
In-Reply-To: <20191112183300.6959-1-liran.alon@oracle.com>
References: <20191112183300.6959-1-liran.alon@oracle.com>
Date:   Wed, 13 Nov 2019 10:20:18 +0100
Message-ID: <87h838ku99.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: UMacf3GDODCkCuq7_QBQ1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> When KVM emulates a nested VMEntry (L1->L2 VMEntry), it switches mmu root
> page. If nEPT is used, this will happen from
> kvm_init_shadow_ept_mmu()->__kvm_mmu_new_cr3() and otherwise it will
> happpen from nested_vmx_load_cr3()->kvm_mmu_new_cr3(). Either case,
> __kvm_mmu_new_cr3() will use fast_cr3_switch() in attempt to switch to a
> previously cached root page.
>
> In case fast_cr3_switch() finds a matching cached root page, it will
> set it in mmu->root_hpa and request KVM_REQ_LOAD_CR3 such that on
> next entry to guest, KVM will set root HPA in appropriate hardware
> fields (e.g. vmcs->eptp). In addition, fast_cr3_switch() calls
> kvm_x86_ops->tlb_flush() in order to flush TLB as MMU root page
> was replaced.
>
> This works as mmu->root_hpa, which vmx_flush_tlb() use, was
> already replaced in cached_root_available(). However, this may
> result in unnecessary INVEPT execution because a KVM_REQ_TLB_FLUSH
> may have already been requested. For example, by prepare_vmcs02()
> in case L1 don't use VPID.
>
> Therefore, change fast_cr3_switch() to just request TLB flush on
> next entry to guest.
>
> Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

--=20
Vitaly

