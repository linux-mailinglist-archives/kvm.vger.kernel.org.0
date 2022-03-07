Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE734CF461
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 10:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiCGJNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 04:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiCGJNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 04:13:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFC4B27B2E
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 01:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646644363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c+/Hjl0zyOOuFnsu7B/cwfXdvV4IHIHkTUvIXxRfjIc=;
        b=UMlYwrMhteGPnCOiHjFTSZEczzZIDz/6/gDBzG8GAKVbg6O7RmXSB+aL8x95875wXscXHz
        EYjWYvqIuDV91L0PnpoBK48C3nsLCGAR2ftgzgtYWEkuhnA02biuJqjKCgMIt5+tXDz8Bp
        K0unBOYVT1BicmpSBjWmC/TgC+uRdyU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73--pDVN4uGO-m3a3e9bw-5HQ-1; Mon, 07 Mar 2022 04:12:42 -0500
X-MC-Unique: -pDVN4uGO-m3a3e9bw-5HQ-1
Received: by mail-wm1-f70.google.com with SMTP id d8-20020a05600c34c800b0037e3cd6225eso5029614wmq.6
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 01:12:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c+/Hjl0zyOOuFnsu7B/cwfXdvV4IHIHkTUvIXxRfjIc=;
        b=j/EDCZJvkUKlF1rhKQDxxxi1gQIHIoQL/9HlGTM+cWBaUdT61TRveu1TCJAV8dEDhi
         rTDU8Cv0wOFy8x+mml1tvu/tA50lFw1mDdR1DeeFAArK5fKAWDFB4Nvj2M+nrrpLrUHf
         x3BGufR4gZUKFuz/WHfoJc3+sA8j6l/ULPGFFI+ob9ZCHyMVV9OsxIu2oQ2ov7EMIkHf
         mDA9ZtFI+aFBaOlM8dsZ1gNo7NYEuYrhsi6WzrKGLGGv1ZteXFoWSy8tDBkV+cFBHJgY
         CqQxhrDHCn6YFXXap+X3HqCauNgANrpM3E/Xpi/W3qibxLi4Ee6PaDALZm/0ZKilOokl
         ZTeA==
X-Gm-Message-State: AOAM533gOwneXgJ5E4iOmEuwzHFnaxNmGBmGDK+B4Q00CkAUVFiIeBKe
        2+ptt5ZWK+gqP01mPWLnlUtJBO4F0zZTvmcJelVjbpH1zN0oiFNoc8k0jMtZG1Jyt3Rl9TJDL+u
        NLs5b5hk7MUXg
X-Received: by 2002:adf:e3d2:0:b0:1f1:d9b1:b5a8 with SMTP id k18-20020adfe3d2000000b001f1d9b1b5a8mr7341505wrm.499.1646644361533;
        Mon, 07 Mar 2022 01:12:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzf0ro+8gzIGF2cFevC9Cgf0kiVGSiBHipMijsey+1LsFqyQ1POBUgw9AxvN+ydDPjsSZ36Gw==
X-Received: by 2002:adf:e3d2:0:b0:1f1:d9b1:b5a8 with SMTP id k18-20020adfe3d2000000b001f1d9b1b5a8mr7341490wrm.499.1646644361296;
        Mon, 07 Mar 2022 01:12:41 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c3b8200b00389a4ccd878sm3800807wms.0.2022.03.07.01.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 01:12:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        x86@kernel.org, kvm@vger.kernel.org, lirongqing@baidu.com
Subject: Re: [PATCH][resend] KVM: x86: check steal time address when enable
 steal time
In-Reply-To: <1646641011-55068-1-git-send-email-lirongqing@baidu.com>
References: <1646641011-55068-1-git-send-email-lirongqing@baidu.com>
Date:   Mon, 07 Mar 2022 10:12:39 +0100
Message-ID: <87sfru9ldk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> check steal time address when enable steal time, do not update
> arch.st.msr_val if the address is invalid,  and return in #GP
>
> this can avoid unnecessary write/read invalid memory when guest
> is running
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb402966..3ed0949 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3616,6 +3616,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data & KVM_STEAL_RESERVED_MASK)
>  			return 1;
>  
> +		if (!kvm_vcpu_gfn_to_memslot(vcpu, data >> PAGE_SHIFT))
> +			return 1;
> +

What about we use stronger kvm_is_visible_gfn() instead? I didn't put
much thought to what's going to happen if we put e.g. APIC access page
addr to the MSR, let's just cut any possibility.

>  		vcpu->arch.st.msr_val = data;
>  
>  		if (!(data & KVM_MSR_ENABLED))

-- 
Vitaly

