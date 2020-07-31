Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB75233FE4
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbgGaHSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:18:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23954 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbgGaHSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596179918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBeZiBi3rY5wwl7r2xHV4CjPc5IMTAH+aLjF+XSNGTI=;
        b=SBGvk/mV2OjIH3NbHUWThH+GQpLp2iEMtAHHnB7zQ0HY2orijgYvoVRPtOSV3w/WWPrx1s
        OvkTV/JNcdPdNTm8Uie9QFEpNMUfDFui1lkyU24j3zKNEYUA/8GYX/jKHBprC6yTKO0cBA
        h5CKd123SVMq17bIYg2y0WECIplfAWU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-bJXZ_LsIPGWB3V2NAV-u7w-1; Fri, 31 Jul 2020 03:18:36 -0400
X-MC-Unique: bJXZ_LsIPGWB3V2NAV-u7w-1
Received: by mail-wr1-f72.google.com with SMTP id t3so7770866wrr.5
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 00:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FBeZiBi3rY5wwl7r2xHV4CjPc5IMTAH+aLjF+XSNGTI=;
        b=bA8vaIqkjXUv92GfGOxoaP/R8DhqoOck/hbJX0v6mKbUADgLWyN+ckUs3koT1fy5q1
         3oeEHxAR8fnDscr/LAOZ9laia5fr9nxicqxTCxfSGcZDh7Ld/OUqGrXIzKWAq3wKLq8U
         DofvStw1KjGbUPMZ0ISW3QxigtTMPXYGZpL0HwDwrAru2K3cascj6G/27KqQvhUA4ajk
         u1A02JhIWCjQMp2Tjq0f+yow7WYJ3jgU5BAeNt12AQRMnrTznlewI6ic4rywhbcdk3jq
         24yzluX80SFaUsd73iFC/bmSncJPCC4+b5/xd0xi0BBgKMvlF2tGMMgTsZ6LQbo44abY
         w60Q==
X-Gm-Message-State: AOAM530942vIVzdAMmIo8QFLCXsVa3m9g+aPgSdz2vOZwmamrdpn3pdm
        Z9pWxoa9yDlGnMjhhzwVDBVM/cHmV4Fd5zPrh/YoIOuLHxMNJ5RxJnQM302p+x/1VDBKRAPAauH
        +waAmcPXGQHmx
X-Received: by 2002:a7b:c40a:: with SMTP id k10mr2454199wmi.127.1596179914865;
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4jKCODk7T1VsBYriZd1g/iAJIFX62aV+2CqLzzD8PaXGWqc3wXNimK5Bl5W0qr0xLjLvzyA==
X-Received: by 2002:a7b:c40a:: with SMTP id k10mr2454188wmi.127.1596179914663;
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:90a5:f767:5f9f:3445? ([2001:b07:6468:f312:90a5:f767:5f9f:3445])
        by smtp.gmail.com with ESMTPSA id s19sm14586327wrb.54.2020.07.31.00.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 00:18:34 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] KVM: LAPIC: Prevent setting the tscdeadline timer
 if the lapic is hw disabled
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f28c7ad5-ea17-382e-f61e-c48418e49363@redhat.com>
Date:   Fri, 31 Jul 2020 09:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1596165141-28874-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/20 05:12, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Prevent setting the tscdeadline timer if the lapic is hw disabled.
> 
> Fixes: bce87cce88 (KVM: x86: consolidate different ways to test for in-kernel LAPIC)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * add Fixes tag and cc stable
> 
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5bf72fc..4ce2ddd 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
> +	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
>  			apic_lvtt_period(apic))
>  		return;
>  
> 

Testcase please.

Paolo

