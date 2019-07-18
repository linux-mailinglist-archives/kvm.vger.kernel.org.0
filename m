Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB16CA7F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 09:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfGRH7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 03:59:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38607 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRH7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 03:59:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so27571416wrr.5
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 00:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YU7xn75zhWNLYZOYfhl/a8jSpCY374NewaLRikXTmDo=;
        b=PCqOXr88BmPgWgrqgDxcbrBD7giEeBNkXxf3pKczk1IVjMhJALVHJObOaJ/gY8YCYp
         AQynlKZY9KjrgoN2hwH7o/zB4X4xsf+J1mcSLWChHhvvEOXj6ERvBGKfaiOika2sIqD3
         Zp98gKMos2KcPlpCpcRsR5s2U3qpoHjb4tEQ/sBfYMLWII0y6rdnnK6MBmATFz3xOoVL
         +MNe48+E8MbBaJmBdpWZzMiqKZ2lphnvz0ulevqzmcuWwKF471XFxrgAOjp25yNDgc0e
         RPj70cwtWfo04kxr/JTSsR9rd8xRjqPA3ADeIUpu0Gx77KHVNouZTVx9119K3joJXgs/
         hZhw==
X-Gm-Message-State: APjAAAXWrUdoyhW0JoUVG2N07aka+2W/d0UoA7FJsUo+kOH0sIi2zsl+
        BRu2HbT2kZaEIxN7rlvimieXfw==
X-Google-Smtp-Source: APXvYqzWOySTek5F18g1Rk+88tPU7Ltg9YyBhOWSMynJ49lXZcAstzow7qtQj3uQua/BgR9A1MHXIA==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr46108607wrs.225.1563436761296;
        Thu, 18 Jul 2019 00:59:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id q18sm27264015wrw.36.2019.07.18.00.59.19
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:59:20 -0700 (PDT)
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com>
Date:   Thu, 18 Jul 2019 09:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/19 09:15, Wanpeng Li wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b4ab59d..2c46705 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  	int me;
>  	int cpu = vcpu->cpu;
>  
> -	if (kvm_vcpu_wake_up(vcpu))
> +	if (kvm_vcpu_wake_up(vcpu)) {
> +		vcpu->preempted = true;
>  		return;
> +	}
>  
>  	me = get_cpu();
>  	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> 

Who is resetting vcpu->preempted to false in this case?  This also
applies to s390 in fact.

Paolo
