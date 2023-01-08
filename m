Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE896615CF
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjAHOZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 09:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHOZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 09:25:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342C6FAC1
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 06:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673187905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksiCTFiq5acBPWOANtiLHvB+WxH84jzu0HNhRmaLORc=;
        b=LdQj2i78B3aMDuv7490Bs232YR7seWopaPYFlGWI7rWquxoH9SA/dSCFR95WzBi5Rt9Qy6
        7BCr74ezk1QZRYwXNsIGoqxFPUlWnWac3tKEc7ivPmz59KFCiqp4QwhVZ3C4/Ra5VO2yew
        4medSYgupIAu5JfiBuAyzl+SvFjz4Pg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-_OaE27f3PLetRxuEsFS3ig-1; Sun, 08 Jan 2023 09:25:04 -0500
X-MC-Unique: _OaE27f3PLetRxuEsFS3ig-1
Received: by mail-ej1-f71.google.com with SMTP id sc9-20020a1709078a0900b0084c4e8dc14eso3872414ejc.4
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 06:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ksiCTFiq5acBPWOANtiLHvB+WxH84jzu0HNhRmaLORc=;
        b=nvBRSPqRalBFerZpw0TLoZYMi/ZQfIIC3x2CaVFD2qqWhi/I3GpbDL4WB1/+hLD6BN
         tio2vAePG434rD7IOqIVdms+n2pF/9uooVDV50agA88XEbgyRnjzwQM3qJyqgQ5Hz2+d
         n1j6OpWImUnZU04AT1szdfEzjm2//t6qUO27YCYmltBVVgcvxxNBusfTWTwJ3tiH3rAz
         YtAJTMAlxpX0vpSogBLy9pQB/cote/+u1bcoUXuQCMMHLvThmV4a01K6zmpTFCGfuSGE
         V3vM33gGc8xq9HmrYFIvBAcEYH4gx5Dce1iEkY+ZENISiGSrcgz3ufef+ksSvv3C8emg
         6Onw==
X-Gm-Message-State: AFqh2koP1uyhBNlKMdzTlOz/rS/yksf/K4/Q/+Kw0sbjYuXoeisG9olJ
        gM9hL7wMNZXxJgTgafPv3I31R9LSE49yGsL78dYgnuKKyXZt7+0KugoxoS1TZdMfgl+4asGxp3K
        q1ksmaeo9E0N+
X-Received: by 2002:a17:907:c71b:b0:7c1:67ca:56f5 with SMTP id ty27-20020a170907c71b00b007c167ca56f5mr58723213ejc.15.1673187903070;
        Sun, 08 Jan 2023 06:25:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuSOtqdC4idlnrW13cj2BA8d1/Io1UUTNfkqZjvpPpxfSYnUWJWJLNJVX1E+OmlahEQx9AuMw==
X-Received: by 2002:a17:907:c71b:b0:7c1:67ca:56f5 with SMTP id ty27-20020a170907c71b00b007c167ca56f5mr58723202ejc.15.1673187902915;
        Sun, 08 Jan 2023 06:25:02 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709062bcc00b007ae38d837c5sm2563068ejg.174.2023.01.08.06.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 06:25:02 -0800 (PST)
Message-ID: <85f6ece15147bac18468662c411f266374365ed3.camel@redhat.com>
Subject: Re: [PATCH v5 03/33] KVM: SVM: Flush the "current" TLB when
 activating AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Date:   Sun, 08 Jan 2023 16:25:00 +0200
In-Reply-To: <20230106011306.85230-4-seanjc@google.com>
References: <20230106011306.85230-1-seanjc@google.com>
         <20230106011306.85230-4-seanjc@google.com>
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

On Fri, 2023-01-06 at 01:12 +0000, Sean Christopherson wrote:
> Flush the TLB when activating AVIC as the CPU can insert into the TLB
> while AVIC is "locally" disabled.  KVM doesn't treat "APIC hardware
> disabled" as VM-wide AVIC inhibition, and so when a vCPU has its APIC
> hardware disabled, AVIC is not guaranteed to be inhibited.  As a result,
> KVM may create a valid NPT mapping for the APIC base, which the CPU can
> cache as a non-AVIC translation.
> 
> Note, Intel handles this in vmx_set_virtual_apic_mode().
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee69f18..712330b80891 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -86,6 +86,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  		/* Disabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, false);
>  	} else {
> +		/*
> +		 * Flush the TLB, the guest may have inserted a non-APIC
> +		 * mapping into the TLB while AVIC was disabled.
> +		 */
> +		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
> +
>  		/* For xAVIC and hybrid-xAVIC modes */
>  		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
>  		/* Enabling MSR intercept for x2APIC registers */


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

