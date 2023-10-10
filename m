Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670F07BFAB6
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 14:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjJJMEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 08:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjJJMEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 08:04:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E19E3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 05:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696939396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wm6tBfka2KOJVryx3LTaJuJ1+AZaKAQthasMuZ423zk=;
        b=NVMib6VZl7DECb8cWyGnn9yHskQEzDNVB4pe6DtHFysCDFgT7b5HG4+KtpGVN2Wdk7l4w/
        wwpZM307wcKbzUpDNYpmIrjQf1z+16pIUTx0G+f7qI8O/GpUSTO3orxzJ9xV+ThwTVpszY
        8M5Qt4N+WxqP6H8R+LJbOwSUZNpqnEk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-JxjhHQizNR6W_fBFEXkX5A-1; Tue, 10 Oct 2023 08:03:15 -0400
X-MC-Unique: JxjhHQizNR6W_fBFEXkX5A-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40652e8cb57so39200755e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 05:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696939394; x=1697544194;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wm6tBfka2KOJVryx3LTaJuJ1+AZaKAQthasMuZ423zk=;
        b=QsgwfBICmteOGYbsSzTVvz9izqrfShaqHwffoGjV23rzQWn9A5v6wZTAZDe0wb5ANt
         +UW/P6d8Wqs1M+zYzX/KstcaKbjNDJ4Uo6fr3X9dma6kF7Kbk+vIw1UrMtW4TH4aV7SF
         uE618JImuWgw2NrOyFYTCm3S7t1o5spTizPJPR/s5dH1xhM6jh11iTMXQKyBwfnZf3rh
         d0kNtY9KvPSgVW9mox2Y3nZmh21nDAPf29GUUZojZSv/Kikr98oAm1/HmstE0oD/rU9C
         E9F4D93h5KXCLGaIdSBPnFw5KAyimP5Wn43zRshrwhGBtUIKEGiTYQhvodGBo0/Zxloa
         YmQA==
X-Gm-Message-State: AOJu0YxFFiXAh5ldNola0BdNu3fzL8Tcpi0qRbSpfVbyUNpaHpFmrY/a
        nHuypK/ZBvfxGbt8LiU1tqfUJIVoKXPXe5NgGYZAQqfz0G7tPpRw477jh5eZw/VuGjNgZgv7BJU
        MneJNw0C1JssqWRkap1LX
X-Received: by 2002:a7b:ca59:0:b0:406:5359:769f with SMTP id m25-20020a7bca59000000b004065359769fmr15594597wml.0.1696939393738;
        Tue, 10 Oct 2023 05:03:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKXVjL0stOS5u0o8lccGU+Zu9av1471E7Ii8gviqT0JII0RuV1vGlMLflT4+oqn2neLP/QHg==
X-Received: by 2002:a7b:ca59:0:b0:406:5359:769f with SMTP id m25-20020a7bca59000000b004065359769fmr15594575wml.0.1696939393302;
        Tue, 10 Oct 2023 05:03:13 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id e24-20020a05600c219800b004013797efb6sm16222342wme.9.2023.10.10.05.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 05:03:12 -0700 (PDT)
Message-ID: <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Date:   Tue, 10 Oct 2023 15:03:11 +0300
In-Reply-To: <20231009212919.221810-1-seanjc@google.com>
References: <20231009212919.221810-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-10-09 у 14:29 -0700, Sean Christopherson пише:
> When vNMI is enabled, rely entirely on hardware to correctly handle NMI
> blocking, i.e. don't intercept IRET to detect when NMIs are no longer
> blocked.  KVM already correctly ignores svm->nmi_masked when vNMI is
> enabled, so the effect of the bug is essentially an unnecessary VM-Exit.

I would re-phrase this like that:

KVM intercepts IRET for two reasons:
- To track NMI masking to be able to know at any point of time if NMI is masked.
- To track NMI window (to inject another NMI after IRET finishes executing).

When L1 uses vNMI, both cases are fulfilled by the vNMI hardware:
- NMI masking state resides in V_NMI_BLOCKING bit of int_ctl and can be read by KVM
  at will.
- vNMI hardware injects the NMIs autonomically every time NMI is unblocked.

Thus there is no need to intercept IRET while vNMI is active.

However, even when vNMI is active in L1, the svm_inject_nmi() can still 
be called to do a direct NMI injection to support the case when KVM is 
trying to inject two NMIs simultaneously.

In this case there is no need to enable IRET interception.

Note that the effect of this bug is essentially an unnecessary VM-Exit.

Also note that even when vNMI is supported and used, running a nested guest
disables vNMI of the L1 guest, thus IRET will still be intercepted.
In this case if the nested VM exit happens before the NMI is delivered,
an unnecessary VM exit can still happen but this is even less likely.

> 
> Note, per the APM, hardware sets the BLOCKING flag when software directly
> directly injects an NMI:
> 
>   If Event Injection is used to inject an NMI when NMI Virtualization is
>   enabled, VMRUN sets V_NMI_MASK in the guest state.

I think that this comment is not needed in the commit message. It describes
a different unrelated concern and can be put somewhere in the code but
not in the commit message.

> 
> Fixes: fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
> Link: https://lore.kernel.org/all/ZOdnuDZUd4mevCqe@google.como
> Cc: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Santosh, can you verify that I didn't break vNMI?  I don't have access to the
> right hardware.  Thanks!
> 
>  arch/x86/kvm/svm/svm.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b7472ad183b9..4f22d12b5d60 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3569,8 +3569,15 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  	if (svm->nmi_l1_to_l2)
>  		return;
>  
> -	svm->nmi_masked = true;
> -	svm_set_iret_intercept(svm);
> +	/*
> +	 * No need to manually track NMI masking when vNMI is enabled, hardware
> +	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
> +	 * case where software directly injects an NMI.
> +	 */
> +	if (!is_vnmi_enabled(svm)) {
> +		svm->nmi_masked = true;
> +		svm_set_iret_intercept(svm);
> +	}
>  	++vcpu->stat.nmi_injections;
>  }
>  
> 
> base-commit: 86701e115030e020a052216baa942e8547e0b487


Note that while nested, the 'is_vnmi_enabled()' will return false because L1's vnmi is indeed disabled
(I wonder if is_vnmi_enabled should be renamed is_l1_vnmi_enabled() to clarify this),

So when nested VM exit happens, that intercept can still continue to be true, 
which should not cause an issue but this is still something to keep in mind.

Best regards,
	Maxim Levitsky

