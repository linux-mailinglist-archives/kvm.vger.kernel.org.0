Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9345026F
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 11:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhKOK1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 05:27:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230504AbhKOK1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 05:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636971881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwtcFyd6ql0hO6iKR4LS73eBi5ZzVBYQw3fdQh2W27I=;
        b=J+t9Aw9Rc9Rc1aDJZOW0oVnvNqhT5h/Zu7J1IRIKyZcrn0IoHFyo7LQrQFAhE46/cySp12
        V3TI9YrWXDvTMo8lL1R8uo1WckSat6PyxSNO4BLSSxVXoSo+HsgJSisQeblXr5JKlXNPnZ
        zkyDRW1ytLZXYHLzv1ewqu+Pa0N0tnE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-TQqDBugwOoaRt-UuVITbRw-1; Mon, 15 Nov 2021 05:24:39 -0500
X-MC-Unique: TQqDBugwOoaRt-UuVITbRw-1
Received: by mail-wr1-f72.google.com with SMTP id h13-20020adfa4cd000000b001883fd029e8so3385556wrb.11
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 02:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TwtcFyd6ql0hO6iKR4LS73eBi5ZzVBYQw3fdQh2W27I=;
        b=dEkblV0jwSFc5BJA8xmAGM39wZK1ImhRAvE2Xq0TozrU9sBasiaYjy85iEdkFIpzRJ
         c+XF99rwGIFnApdZMK0GbO/I8i27orvNtYnAZADWNU1QzXmbNNqC/TgDOM97t10ezXIC
         24bWkBAGAQqQZuiAY8SuFLmnfZpvKy8BIEUctM3Wx+e+gFH+VPp914lHJu5XtH2p8haB
         qaBFfZ9HfVyW7Ev6Q4GuY+PQJtlN4vHrRmdednC7DSZ5eDt48lonsypPQnLTUuj6TUOn
         XPTxbpMGRBqI5M3dum7pN6UPS4focfKwEM4LNwCjXJAvyJaKkqbhfr1bLqJIS4ZwctwA
         0tEQ==
X-Gm-Message-State: AOAM530Ap2Ge/WXMGdCHsI0w1+uBS/CB5VXQyBbgGhplwLvR27+jmYMa
        5qF1lz41qGR8ZTTE+m8cG6CWLw0hpljP1ABZhO5fJBrSGxl2b5FgAnxrDy5tfvhH+VSAKX6hkrk
        D+f1WGp6HJCcr
X-Received: by 2002:a05:600c:511c:: with SMTP id o28mr42507462wms.96.1636971878034;
        Mon, 15 Nov 2021 02:24:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6y5d3IjWmOUY33xtRIVMgM+WTD8xBjZJMote7hd3vnw7p5znSYbhvK8ZKa/PniTo7KqWhEw==
X-Received: by 2002:a05:600c:511c:: with SMTP id o28mr42507437wms.96.1636971877859;
        Mon, 15 Nov 2021 02:24:37 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b14sm17366185wrd.24.2021.11.15.02.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:24:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     =?utf-8?B?6buE5LmQ?= <huangle1@jd.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Fix uninitialized eoi_exit_bitmap usage in
 vcpu_load_eoi_exitmap()
In-Reply-To: <1300eda19bce40d5a539bc431446da5e@jd.com>
References: <1300eda19bce40d5a539bc431446da5e@jd.com>
Date:   Mon, 15 Nov 2021 11:24:36 +0100
Message-ID: <87fsrxemxn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=E9=BB=84=E4=B9=90 <huangle1@jd.com> writes:

> In vcpu_load_eoi_exitmap(), currently the eoi_exit_bitmap[4] array is
> initialized only when Hyper-V context is available, in other path it is
> just passed to kvm_x86_ops.load_eoi_exitmap() directly from on the stack,
> which would cause unexpected interrupt delivery/handling issues, e.g. an
> *old* linux kernel that relies on PIT to do clock calibration on KVM might
> randomly fail to boot.
>
> Fix it by passing ioapic_handled_vectors to load_eoi_exitmap() when Hyper=
-V
> context is not available.
>
> Signed-off-by: Huang Le <huangle1@jd.com>

Fixes: f2bc14b69c38 ("KVM: x86: hyper-v: Prepare to meet unallocated Hyper-=
V context")
Cc: stable@vger.kernel.org

> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dc7eb5fddfd3..0699832504c9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9547,11 +9547,14 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu=
 *vcpu)
>  	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
>  		return;
>=20=20
> -	if (to_hv_vcpu(vcpu))
> -		bitmap_or((ulong *)eoi_exit_bitmap,
> -			  vcpu->arch.ioapic_handled_vectors,
> -			  to_hv_synic(vcpu)->vec_bitmap, 256);
> +	if (!to_hv_vcpu(vcpu)) {
> +		static_call(kvm_x86_load_eoi_exitmap)(
> +			vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
> +		return;
> +	}
>=20=20
> +	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
> +		  to_hv_synic(vcpu)->vec_bitmap, 256);
>  	static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
>  }
>=20=20

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

My personal preference, however, would be to keep 'if
(to_hv_vcpu(vcpu))' check and not invert it, i.e.:

	if (to_hv_vcpu(vcpu)) {
		bitmap_or((ulong *)eoi_exit_bitmap,
                	vcpu->arch.ioapic_handled_vectors,
                	to_hv_synic(vcpu)->vec_bitmap, 256);
                static_call(...)(vcpu, eoi_exit_bitmap)
                return;
        }

	static_call(...)(vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);

to slightly reduce the code churn but it doesn't matter much.

Thanks!

--=20
Vitaly

