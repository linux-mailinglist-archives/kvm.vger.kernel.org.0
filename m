Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48E92D57C2
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 10:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgLJJ6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 04:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbgLJJ6D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 04:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607594197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=70Lrl1RjS1Hmn4UydEzmB89WmvpNkXwSTLBgiOvoibQ=;
        b=N+aQCypYzdsqkCiw9rQUEIb8PJTGCA//rCSqCYZtyWdboo5/sZTZ7eu5nZ1vE6M3AqBPOD
        wTB2i769AVwU61khMN9YMS3oIUoX7A2I7srlS3Xdmfjtik72TW0hm5yPYLSNB0gKnMxyoB
        9oAWd0X0AF0sJow8RDpwFzpZT7kQZK4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-3uzaPWh6MRq-uz-Ns3osow-1; Thu, 10 Dec 2020 04:56:35 -0500
X-MC-Unique: 3uzaPWh6MRq-uz-Ns3osow-1
Received: by mail-wr1-f71.google.com with SMTP id v1so1730901wri.16
        for <kvm@vger.kernel.org>; Thu, 10 Dec 2020 01:56:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=70Lrl1RjS1Hmn4UydEzmB89WmvpNkXwSTLBgiOvoibQ=;
        b=JQpfxYMX3QbwasJBUcW7HbEbwowPOzFYnJqTa2ufAZp6cjzoF02JVlk6+QRWBHwULq
         ugsknIHDrE9GTGpr9+t/3/T9a1ZwcAaqaIWlJ6WynUQnl4Ljyqn/F4u7buOTsxpH7Qon
         qMPrfZkv8rCOm+CmRZDsktR6dPNX+5CchioKiLgFyxoub7hp8zSmnnLCGNOq/Xn89UTQ
         C5BUBxNNCHX4pwhcqsDdAct4xUlgTIy7pVE3iHfbe/TmMxiaV2pAR3eX6TykoGkUZltG
         dJz8dN1PlltTHkiD2xx3mcWcrM2Ax+DtktNcDm22YkYj8VjOyRn5whp/wkUtIwFLoeza
         NRKg==
X-Gm-Message-State: AOAM532QMuA9khBEUnd5m11A5h/8kaRy483vJkwfSqjWP09pdH9V8vkZ
        nduCmH6lusYCFoacXVjJ/togDof8p+GjCjf4jDLiGgvkuFHtwLqlp9pV7AX870aerpz3fHTKIBc
        JyrgE3p8cU95O
X-Received: by 2002:adf:ed49:: with SMTP id u9mr6745059wro.292.1607594194640;
        Thu, 10 Dec 2020 01:56:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypZtKqgL5oRbXKt5JBbnaYbJqArnJ4P3wDAFDuUN5aXCkL5X/+F/jtl5tiS4txlxc/ohqoWQ==
X-Received: by 2002:adf:ed49:: with SMTP id u9mr6745044wro.292.1607594194475;
        Thu, 10 Dec 2020 01:56:34 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y6sm8806357wmg.39.2020.12.10.01.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 01:56:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Zhang <starzhangzsd@gmail.com>, pbonzini@redhat.com,
        seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] kvm:vmx:code changes in handle_io() to save some CPU
 cycles.
In-Reply-To: <1607588115-29971-1-git-send-email-starzhangzsd@gmail.com>
References: <1607588115-29971-1-git-send-email-starzhangzsd@gmail.com>
Date:   Thu, 10 Dec 2020 10:56:32 +0100
Message-ID: <87mtymj86n.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stephen Zhang <starzhangzsd@gmail.com> writes:

> code changes in handle_io() to save some CPU cycles.
>
> Signed-off-by: Stephen Zhang <starzhangzsd@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 47b8357..109bcf64 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4899,15 +4899,14 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu)
>  static int handle_io(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long exit_qualification;
> -	int size, in, string;
> +	int size, in;
>  	unsigned port;
>  
>  	exit_qualification = vmx_get_exit_qual(vcpu);
> -	string = (exit_qualification & 16) != 0;
>  
>  	++vcpu->stat.io_exits;
>  
> -	if (string)
> +	if (exit_qualification & 16)
>  		return kvm_emulate_instruction(vcpu, 0);
>  
>  	port = exit_qualification >> 16;

I seriously doubt this can save any CPU cycles as compiler will likely
re-order and optimize this check anyway, I don't expect to see any
push/pop operations here. I agree that having local 'string' variable is
likely an overkill, however, the 'exit_qualification & 16' check we have
is hard to read so 'string' here works as a comment :-)

I would've liked the patch in the following shape more:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e35552055c07..65b6062ad7bc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4898,15 +4898,15 @@ static int handle_triple_fault(struct kvm_vcpu *vcpu)
 static int handle_io(struct kvm_vcpu *vcpu)
 {
        unsigned long exit_qualification;
-       int size, in, string;
+       int size, in;
        unsigned port;
 
        exit_qualification = vmx_get_exit_qual(vcpu);
-       string = (exit_qualification & 16) != 0;
 
        ++vcpu->stat.io_exits;
 
-       if (string)
+       /* String instruction */
+       if (exit_qualification & BIT(4))
                return kvm_emulate_instruction(vcpu, 0);
 
        port = exit_qualification >> 16;

Also, the changelog needs to be re-phrased to state code cleanup and not
CPU cycles optimization.

-- 
Vitaly

