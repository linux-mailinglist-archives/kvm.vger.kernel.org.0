Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B332609EB
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfGEQEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 12:04:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55103 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbfGEQEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 12:04:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so6626188wme.4
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 09:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zX3JFU4C4X6TbrWU+xmAp1v42W9OuqRHru3tfkmuHO4=;
        b=tF0Bo+BBsuYLPzMA8PPdMEG9C8qnb5Leiwhc8epVSgomuveXo+ZioGPN+1v467lbvk
         XhSHmbkFzDuUlT/yoaVDtdCQfSBFYW31YDP8zvGctGlnDzLB9hGrSjDgpQM33n8QrTPQ
         JIIVd62+rUKTIRP5YaJ8p3shBJZ0qJHgKMDhDHLLzGHDLlePEfuj9CAXiFid1tbm9FTo
         VdvHBvujQNrpkXQfsQDKeVur2nyCKFFY6VE4dpEiJcriV5YVcMhhHiFghzb/SnFecLp6
         JWU7ovajL+Mlu6L5C+VBZJjiC+bp+hn/s7Q6Nihoa+mhf81lFnk+1/L74TRhEhw12c33
         /AvQ==
X-Gm-Message-State: APjAAAW111ll9G0oMuNILjngBYhFPXA/67vuGGxLi7aHTAPCPagK12zw
        kp7qhTLB1uiEgro85blhazY1wQ==
X-Google-Smtp-Source: APXvYqzpeZB/Dms95mzKcgtYIew6oxvxSF6chcgCwF22mkoEcA6spsxv47yESTptllbdgbw4mk2xXg==
X-Received: by 2002:a1c:7ec7:: with SMTP id z190mr3928105wmc.17.1562342651116;
        Fri, 05 Jul 2019 09:04:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id a2sm11592119wmj.9.2019.07.05.09.04.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 09:04:10 -0700 (PDT)
Subject: Re: [PATCH v6 2/2] KVM: LAPIC: Inject timer interrupt via posted
 interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
 <1562338365-22789-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da981f5f-fa62-f0a2-a530-5aa59ab1a38e@redhat.com>
Date:   Fri, 5 Jul 2019 18:04:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562338365-22789-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 16:52, Wanpeng Li wrote:
>  
> -void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u64 guest_tsc, tsc_deadline;
> @@ -1539,7 +1570,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	if (apic->lapic_timer.expired_tscdeadline == 0)
>  		return;
>  
> -	if (!lapic_timer_int_injected(vcpu))
> +	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
>  		return;
>  

What is the reason for this other bool argument?  (Yes, I hate bool
arguments...).

Paolo
