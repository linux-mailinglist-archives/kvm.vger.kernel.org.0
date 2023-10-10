Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12AD7C016F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjJJQS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjJJQSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:18:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F5010D2
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696954077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GfTmCM8w+01lprKlsyHpviViCYeM18JJasiaZDCapS8=;
        b=QxWBctmr4Ms2dYls+TeGB+lzoqpMk9opEVsJUYJAc7vVGqMO5AqM/3CRYdsO9T1jLEXhJ0
        yrjuCq/kiTRYj0z4dZRO80xLLZBUDNUJYI5fGjk9p10R+iUaO5TTBffy00h7gAlXWuPYG4
        BkSuLNhzeotUubX6b/zQtXaux9WtwmU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-7p-odcgeNkeh2XiopD26Sg-1; Tue, 10 Oct 2023 12:07:51 -0400
X-MC-Unique: 7p-odcgeNkeh2XiopD26Sg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-997c891a88dso215497866b.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696954070; x=1697558870;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GfTmCM8w+01lprKlsyHpviViCYeM18JJasiaZDCapS8=;
        b=eu6voKBfkk+AuwCpmeKwIa3Ih4yq2Ztdv/TtG6LoMD6qCWWUW/3rvwnghfoX62LaLg
         r4yx1DjrO6mYSJtGm+CREro14E1R16a92Q1tCZ/iKTASIzpf0+LaHKYPLgCsjyq0Slo7
         wOUEQAyb6k7CzioLUN8oIis/u4ckMBddZgG85g9d9/RTZm1N8Z1sdlzzAmQakQ/JDEoe
         n1rEj5n9OSVkqX8+4Lk7UYpwJlUmA8sLuxwIPsIO9sBJV04Brn3+pJehDpeYiXbfl4bI
         vbvQo3pFEQzps/cZapUYt+3c4OM84CRYU3P8rMHaxConIv2m/xemCSIAYbY0UDWIQ1ul
         IL9Q==
X-Gm-Message-State: AOJu0Yy70aS2IlbA/i2I+CWFvcBxXYowHcM/m3YynRzEUD/pRew4V2gL
        J3/i+CMzGDCwyjJun1bMflFS9TcfNLdMawamPU04rbQUzzggm1T3DR7ayFDVXY208975jNlkveK
        UUU9N8AqELlcz
X-Received: by 2002:a17:907:78c7:b0:9ae:7548:742 with SMTP id kv7-20020a17090778c700b009ae75480742mr16068667ejc.3.1696954069935;
        Tue, 10 Oct 2023 09:07:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0ACah8/ufDTAOKES/qeWRfkUd9MQ+tuQ/d1ijeXf42ZhywPK4PFPibdU5MjNfYgo8IuxKsg==
X-Received: by 2002:a17:907:78c7:b0:9ae:7548:742 with SMTP id kv7-20020a17090778c700b009ae75480742mr16068643ejc.3.1696954069540;
        Tue, 10 Oct 2023 09:07:49 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id f19-20020a7bc8d3000000b00405959469afsm14601117wml.3.2023.10.10.09.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 09:06:36 -0700 (PDT)
Message-ID: <1ca607bcb4931b7f5e14e6c064264d86e58fd3ce.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Date:   Tue, 10 Oct 2023 19:06:25 +0300
In-Reply-To: <ZSVju-lerDbxwamL@google.com>
References: <20231009212919.221810-1-seanjc@google.com>
         <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
         <ZSVju-lerDbxwamL@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 07:46 -0700, Sean Christopherson пише:
> On Tue, Oct 10, 2023, Maxim Levitsky wrote:
> > У пн, 2023-10-09 у 14:29 -0700, Sean Christopherson пише:
> > > Note, per the APM, hardware sets the BLOCKING flag when software directly
> > > directly injects an NMI:
> > > 
> > >   If Event Injection is used to inject an NMI when NMI Virtualization is
> > >   enabled, VMRUN sets V_NMI_MASK in the guest state.
> > 
> > I think that this comment is not needed in the commit message. It describes
> > a different unrelated concern and can be put somewhere in the code but
> > not in the commit message.
> 
> I strongly disagree, this blurb in the APM directly affects the patch.  If hardware
> didn't set V_NMI_MASK, then the patch would need to be at least this:

I don't see how 'the blurb in the APM' relates to the removal of the 
IRET intercept, which is what this patch is about.

If the hardware was not to set the V_NMI_BLOCKING_MASK during EVENTINJ NMI injection, 
we would have had a bigger problem, a problem which would have to be addressed 
before this patch, because kvm reads back the V_NMI_BLOCKING_MASK 
(see: svm_get_nmi_mask()) to check if NMI is blocked, something that
has no relation to the IRET interception.


Best regards,
	Maxim Levtsky


> 
> --
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b7472ad183b9..d34ee3b8293e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3569,8 +3569,12 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  	if (svm->nmi_l1_to_l2)
>  		return;
>  
> -	svm->nmi_masked = true;
> -	svm_set_iret_intercept(svm);
> +	if (is_vnmi_enabled(svm)) {
> +		svm->vmcb->control.int_ctl |= V_NMI_BLOCKING_MASK;
> +	} else {
> +		svm->nmi_masked = true;
> +		svm_set_iret_intercept(svm);
> +	}
>  	++vcpu->stat.nmi_injections;
>  }
>  
> 
> base-commit: 86701e115030e020a052216baa942e8547e0b487


