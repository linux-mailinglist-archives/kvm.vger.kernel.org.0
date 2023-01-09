Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9166662763
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjAINlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 08:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237345AbjAINk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 08:40:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F133E85F
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 05:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673271475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqoFfnN7wATgBw0qMGQygDb47LQ654PlNrpm0twTqlM=;
        b=TqPDhQy2pSrRPoNhMYTR/vk36NarQ7smbcgWb3iLKrx5uFVOQaSSObD6HpZcgcnFUKKay6
        0Q5lLRzZgs1ZfB0T57LvU/h4l+JPAzoVu1EZYlwCWMMNM5KM9SSDcHncj+PgM4CeBUg5C4
        woTc3jz652mykn044iQ91+fAmdkEWdw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-HCKeZ9EjPiKS0BnLhbCF-A-1; Mon, 09 Jan 2023 08:37:54 -0500
X-MC-Unique: HCKeZ9EjPiKS0BnLhbCF-A-1
Received: by mail-ed1-f71.google.com with SMTP id r14-20020a05640251ce00b0047d67ab2019so5259699edd.12
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 05:37:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uqoFfnN7wATgBw0qMGQygDb47LQ654PlNrpm0twTqlM=;
        b=53Lo16biAQJoyHfgrvLG1ZuiRehKmM+41Fckf2L+vLARIJ4RlUa1tbiaqKqnGHe5y4
         gygojzk+9hXkZxfMTFK9HT1i/t9eLfZ+NIg2B7+R+rLgJuVXr80bSg8u2BnJXy/IjAAN
         zJUVJvcaXmSxBa/wYrXz06F4w/lK9sOlT2j1b9HiEprghdOldBSGQqfIVpWopuA/jXhk
         JhJGpUZ7XHYHb7YYDlFj7NchHB13VZAVxBPMUTThG3pF8X3nA5l6V4URs72Vm4lHIueR
         MtJq8uIFFCQpqnSF1zFXG2uMyxTZqimy5wvygqvkQku1AQIew1iF/LVlhWxUqQvUFX43
         JMpg==
X-Gm-Message-State: AFqh2kq+8CSCkrIEhcieDCeoMuPuamHwS8HqZu5HZWA/mrucRBh36vrS
        HULqrvBzoPMlUkfRtUWw3GCq/aJkWXlIDcgO9cJWPmRhfn4rr9NjEOoABC+gn5MhoGuUqMxDofH
        CijHb7MR2Ttn0
X-Received: by 2002:a17:906:6a0f:b0:812:d53e:1222 with SMTP id qw15-20020a1709066a0f00b00812d53e1222mr68637658ejc.31.1673271473405;
        Mon, 09 Jan 2023 05:37:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsbJWe9HJvigdXPEK9sLJ6fuQRT1vVoo2WkZWJ/gxcal/T/TUFsyoYO0b+IT0hnkS0UlS1QQg==
X-Received: by 2002:a17:906:6a0f:b0:812:d53e:1222 with SMTP id qw15-20020a1709066a0f00b00812d53e1222mr68637635ejc.31.1673271473172;
        Mon, 09 Jan 2023 05:37:53 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id kv24-20020a17090778d800b0078d9cd0d2d6sm3743487ejc.11.2023.01.09.05.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 05:37:52 -0800 (PST)
Message-ID: <c61ce1a6393a108c76e53cb99249aba5ab318e07.camel@redhat.com>
Subject: Re: [RFC PATCH 1/2] KVM: x86: update APIC_ID also when disabling
 x2APIC in kvm_lapic_set_base
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Date:   Mon, 09 Jan 2023 15:37:50 +0200
In-Reply-To: <20230109130605.2013555-2-eesposit@redhat.com>
References: <20230109130605.2013555-1-eesposit@redhat.com>
         <20230109130605.2013555-2-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-01-09 at 08:06 -0500, Emanuele Giuseppe Esposito wrote:
> If KVM_SET_MSR firstly enables and then disables x2APIC, make sure
> APIC_ID is actually updated correctly, since bits and offset differ from
> xAPIC and x2APIC.
> 
> Currently this is not handled correctly, as kvm_set_apic_base() will
> have msr_info->host_initiated, so switching from x2APIC to xAPIC won't
> fail, but kvm_lapic_set_base() does not handle the case.
> 
> Fixes: 8d860bbeedef ("kvm: vmx: Basic APIC virtualization controls have three settings")
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4efdb4a4d72c..df0a50099aa2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2394,8 +2394,12 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  		}
>  	}
>  
> -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> -		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +	if ((old_value ^ value) & X2APIC_ENABLE) {
> +		if (value & X2APIC_ENABLE)
> +			kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +		else
> +			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +	}
>  
>  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
>  		kvm_vcpu_update_apicv(vcpu);


I don't think that this patch is 100% needed in a strict sense, but I don't object to it either.
 
The switch between x2apic and xapic mode is not allowed by X86 spec, while vise versa 
is allowed and I think that the spec says that in this case APIC ID is restored to its
default value.
 
When QEMU does x2apic->xapic switch anyway to reset the vCPU, it should both upload the IA32_APIC_BASE
and all of the apic registers via KVM_SET_LAPIC, and it looks like that is what Qemu does:
 
 
static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
{
    ...
 
 
    // this calls KVM_SET_MSRS with  MSR_IA32_APICBASE, and APIC might be with wrong apic id after this
    kvm_put_apicbase(s->cpu, s->apicbase);
 
    // this just initializes the kapic with apic state to upload
    kvm_put_apic_state(s, &kapic);
 
    // and this uploads the apic state, including the APIC ID register
 
    ret = kvm_vcpu_ioctl(CPU(s->cpu), KVM_SET_LAPIC, &kapic);
    if (ret < 0) {
        fprintf(stderr, "KVM_SET_LAPIC failed: %s\n", strerror(-ret));
        abort();
    }
}
 
SO between KVM_SET_MSRS and  KVM_SET_LAPIC, apic id is indeed != vcpu_id,
which might inhibit APICv/AVIC but after recent Sean's patch series,
the inhibition is now reversible.
 
 
In fact I think it won't hurt to make the APICV_INHIBIT_REASON_APIC_BASE_MODIFIED inhibition
reversible as well.
 
Best regards,
	Maxim Levitsky
 
 

