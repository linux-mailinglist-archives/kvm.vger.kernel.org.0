Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E42A82B4
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 16:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbgKEPx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 10:53:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731089AbgKEPx5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 10:53:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604591636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wFZ72PyJ1+m02rDkCuwgqjkgKRGx+Ew/wct32EXCLk4=;
        b=btgpi8nkCZCWXbagbhi457bpAdifcTxaL2Rx7M+ElXG6Ia6dl0KJqkBwMEJdKf41WV6O3z
        Zx3rmVggkClxw3cAWO10q8bmL9KvwNgn+CSURtWIor4UClse6IqcBWOJWWkUuVn8UBNnhp
        W5Rt/V27q12yK1kSkh+Yn6tk/Zy631I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-070Z90WfOgygJE21JbwfsQ-1; Thu, 05 Nov 2020 10:53:54 -0500
X-MC-Unique: 070Z90WfOgygJE21JbwfsQ-1
Received: by mail-wm1-f70.google.com with SMTP id h2so789649wmm.0
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 07:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wFZ72PyJ1+m02rDkCuwgqjkgKRGx+Ew/wct32EXCLk4=;
        b=qxcF3Rgf/33Ss9VRmbDrTmopycNJNmuA1cQB35fYIAv40ewnkJomI64i1kwarBvrPW
         vEwkYy5qUv+cDsRGaZCOkAXoD8Wdf5fnecd70lupaF7XkGOt24W+6Rj4+yhPvIrn6yqy
         CbSreA+C4wuXk2JSR6XS0gqS0JNMQ01MDun3SwxipGw3wtwoOpsqgQ78BF4MOb37gvLM
         7Dgpnpnf2rId7ym+KpvwfIxm5DuUiL89rdmuyzHZErI7MuffrZiCB2LvX9wuXbmjoJvj
         lhaloKnn0GSNHwqFZYQjxl93m/1CGXHIjKkcIc3GE4U+KwY/JLXGdXku5SjGKjsFcUUY
         X37w==
X-Gm-Message-State: AOAM5328R/c2nwWTI0AmU+iP4EQCTgjBcN0SRE8dVCcu0B2mUyClhVkT
        vq5prms+I5c0mAtthxku7ONJ5tXIRKU8YjbwENB+mfUhYZbTuIzvA81rZHidcNoFMCcK0VXjbNB
        DL/f4nLis7hm2
X-Received: by 2002:adf:9b95:: with SMTP id d21mr3594035wrc.335.1604591632988;
        Thu, 05 Nov 2020 07:53:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPzlw5xOuCcXPux/37qJ+WF2tNLIFhA9EOtowntdsU5KJAlwcwqaz4qAXGEpsft7HFexG3Wg==
X-Received: by 2002:adf:9b95:: with SMTP id d21mr3594018wrc.335.1604591632822;
        Thu, 05 Nov 2020 07:53:52 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j71sm3133580wmj.10.2020.11.05.07.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 07:53:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     junjiehua0xff@gmail.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrey Smetanin <asmetanin@virtuozzo.com>,
        Junjie Hua <junjiehua@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/kvm/hyper-v: Don't deactivate APICv unconditionally
 when Hyper-V SynIC enabled
In-Reply-To: <1604567537-909-1-git-send-email-junjiehua@tencent.com>
References: <1604567537-909-1-git-send-email-junjiehua@tencent.com>
Date:   Thu, 05 Nov 2020 16:53:50 +0100
Message-ID: <87sg9n3ilt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

junjiehua0xff@gmail.com writes:

> From: Junjie Hua <junjiehua@tencent.com>
>
> The current implementation of Hyper-V SynIC[1] request to deactivate 
> APICv when SynIC is enabled, since the AutoEOI feature of SynIC is not 
> compatible with APICv[2].
>
> Actually, windows doesn't use AutoEOI if deprecating AutoEOI bit is set 
> (CPUID.40000004H:EAX[bit 9], HyperV-TLFS v6.0b section 2.4.5), we don't 
> need to disable APICv in this case.
>

Thank you for the patch, the fact that we disable APICv every time we
enable SynIC is nothing to be proud of. I'm, however, not sure we can
treat 'Recommend deprecating AutoEOI' as 'AutoEOI must not be
used.'. Could you please clarify which Windows versions you've tested
with with?

> [1] commit 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
> [2] https://patchwork.kernel.org/patch/7486761/
>
> Signed-off-by: Junjie Hua <junjiehua@tencent.com>
> ---
>  arch/x86/kvm/hyperv.c | 18 +++++++++++++++++-
>  arch/x86/kvm/lapic.c  |  3 +++
>  2 files changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 5c7c406..9eee2da 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -899,6 +899,19 @@ void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
>  }
>  
> +static bool kvm_hv_is_synic_autoeoi_deprecated(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +
> +	entry = kvm_find_cpuid_entry(vcpu,
> +				HYPERV_CPUID_ENLIGHTMENT_INFO,
> +				0);
> +	if (!entry)
> +		return false;
> +
> +	return entry->eax & HV_DEPRECATING_AEOI_RECOMMENDED;
> +}

I think we should complement (replace?) this with checking that no SINTx
was configured with AutoEOI (and immeditely inhibit APICv if the
situation changes).

> +
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>  {
>  	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
> @@ -908,7 +921,10 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
>  	 * not compatible with APICV, so request
>  	 * to deactivate APICV permanently.
>  	 */
> -	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
> +	if (!kvm_hv_is_synic_autoeoi_deprecated(vcpu))
> +		kvm_request_apicv_update(vcpu->kvm,
> +					false, APICV_INHIBIT_REASON_HYPERV);
> +
>  	synic->active = true;
>  	synic->dont_zero_synic_pages = dont_zero_synic_pages;
>  	synic->control = HV_SYNIC_CONTROL_ENABLE;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 105e785..0bb431f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1263,6 +1263,9 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
>  
>  	trace_kvm_eoi(apic, vector);
>  
> +	if (test_bit(vector, vcpu_to_synic(apic->vcpu)->vec_bitmap))
> +		kvm_hv_synic_send_eoi(apic->vcpu, vector);
> +
>  	kvm_ioapic_send_eoi(apic, vector);
>  	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
>  }

-- 
Vitaly

