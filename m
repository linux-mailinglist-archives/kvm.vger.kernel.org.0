Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A182CB00EE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 18:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfIKQHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 12:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50851 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfIKQHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 12:07:10 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8F526B
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 16:07:09 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id f11so10633467wrt.18
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 09:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B/S0TKkh///EsNRFEKwugE3C+En+WB89iDH3SdhNlRE=;
        b=ZafJznRfEHDgeGl3m3/G/6JZ+DT4IKk4WIoGX7B+2h4I65I0r4nZhJZAQ6Xdg05fbL
         sFdDCxqM2qDqW48qPvs21yniWjNpx00rPTwHXmDncxOjYqh8w8cSz2atKWbiEnKtjLLV
         C/k1I1A/BmdH4w38feU9l4N4+DBx3LnnMYNiKrBoHRxvZanzNn41QUcOjCuFcwmXcZXt
         Znxk6dxcq2zX+wIbOUuFdpRhpVwo3BC4pFrVuPxKHgZUWPQnW9AZhs1MXw2eHjECyBD9
         YmtJ6JYkVc2LPNIt5FkgkJdP2Nn1gylju3eidTI7iz8hQId3fUXPW9l9Onzg0oXlgnIr
         BGEQ==
X-Gm-Message-State: APjAAAX0xJdqhK2V+RrT5/AfpBjfNzm3eASqI69weE9FmLl9Vn0YkW+S
        jV3bHZ0xw+SqQGJXOOZ1zGPpPfzy+YuiyByOCJtPcdetxbVnbijTU9USjPdSa2DiYlsMWyL7dgm
        3dlv8LL80aGr2
X-Received: by 2002:a1c:a6ca:: with SMTP id p193mr4509427wme.103.1568218028198;
        Wed, 11 Sep 2019 09:07:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz40/LD2YjoatJ8x8wP88TO4G3SZTOx+s9gIrPeXLOKq6V3pp00n5o0Rw4IO6/4fws059Z+TA==
X-Received: by 2002:a1c:a6ca:: with SMTP id p193mr4509410wme.103.1568218027958;
        Wed, 11 Sep 2019 09:07:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id c8sm9314872wrr.49.2019.09.11.09.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:07:07 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: VMX: Stop the preemption timer during vCPU reset
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1567664788-10249-1-git-send-email-wanpengli@tencent.com>
 <1567664788-10249-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d7b46861-2787-f8c0-fa84-5368235db830@redhat.com>
Date:   Wed, 11 Sep 2019 18:06:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567664788-10249-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/19 08:26, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The hrtimer which is used to emulate lapic timer is stopped during 
> vcpu reset, preemption timer should do the same.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233..f794929 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4162,6 +4162,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.microcode_version = 0x100000000ULL;
>  	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> +	vmx->hv_deadline_tsc = -1;
>  	kvm_set_cr8(vcpu, 0);
>  
>  	if (!init_event) {
> 

Queued both, thanks.

Paolo
