Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF472139F73
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 03:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgANCUe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 13 Jan 2020 21:20:34 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2990 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729030AbgANCUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 21:20:34 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 3D32733A036B44FA5CD2;
        Tue, 14 Jan 2020 10:20:32 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jan 2020 10:20:32 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 14 Jan 2020 10:20:31 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Tue, 14 Jan 2020 10:20:31 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     linmiaohe <linmiaohe@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
Thread-Topic: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
Thread-Index: AdXKgQO5ibkFZKiqSOySikptaJRgWA==
Date:   Tue, 14 Jan 2020 02:20:31 +0000
Message-ID: <ab61de3a04a74f74866683b062d0bab2@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Friendly ping :)

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The var ret and out jump label is not really needed. Clean them up.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/arm64/kvm/guest.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index 2fff06114a8f..3b836c91609e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -834,14 +834,10 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg)
>  {
> -	int ret = 0;
> -
>  	trace_kvm_set_guest_debug(vcpu, dbg->control);
>  
> -	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
> +		return -EINVAL;
>  
>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>  		vcpu->guest_debug = dbg->control;
> @@ -856,8 +852,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  		vcpu->guest_debug = 0;
>  	}
>  
> -out:
> -	return ret;
> +	return 0;
>  }
>  
>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> --
> 2.19.1
>
