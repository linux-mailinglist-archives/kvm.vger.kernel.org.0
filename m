Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301C364857
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfGJO2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 10:28:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41603 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfGJO2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 10:28:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so2699596wrm.8
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 07:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=47AQ/04JGpZ4UxJNsAslxJusgrGHeQlSRyRgc4tRjMU=;
        b=l089d4E6eaZKEagwPpyz5RCACGM95J2gQzcArCMGuQu9haM9ES5XM9PPwvyJ7sYUfB
         CokyI69Oj0qMZPrzx00VCIHhEINBg7h4SkXeG9aEf73MZ4+upCO2/43q/A4YUWRgO1l2
         ZUlQcHWfceroQcgUYoRrMO2Z359Q14g+26GhaQYfusX+EDPHBJdVKgs3QqvjmbhoTrrq
         aWGRZZbXJr2tpF9Ncmn/aRncAIXUxB1t/dkz1qMS+nxbf5zkrEqoE1ifcyGtcbH4JqI1
         QdP01ssZFOI5dEChbUZZ4FMmPhpwGRkArZsHuF7Bei1jZylalpDvrCimeaMd9LO0NXX+
         jHUw==
X-Gm-Message-State: APjAAAV9uf+Ynyj+EFKXMvXiH3L2mXnMWQ7QrXeumVkOgRPD9KbwJmLD
        HJ3jHlPPLaiCAvF/JBp4Kznfuw==
X-Google-Smtp-Source: APXvYqyeBBQXEyrmWKaB/cT79PCnJlZn4bb0P6U5GKyEsYOJk928IpK5/TRjh7Zov2tzbcpEm0FkaQ==
X-Received: by 2002:adf:f050:: with SMTP id t16mr15862378wro.99.1562768915508;
        Wed, 10 Jul 2019 07:28:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id n3sm2431577wrt.31.2019.07.10.07.28.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 07:28:34 -0700 (PDT)
Subject: Re: [PATCH 2/5] KVM: nVMX: Skip VM-Exit Control vmentry checks that
 are necessary only if VMCS12 is dirty
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-3-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f42d3eac-8353-3d90-a621-ca82460b66e7@redhat.com>
Date:   Wed, 10 Jul 2019 16:28:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190707071147.11651-3-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/19 09:11, Krish Sadhukhan wrote:
>  
>  	if (!vmx_control_verify(vmcs12->vm_exit_controls,
>  				vmx->nested.msrs.exit_ctls_low,
> -				vmx->nested.msrs.exit_ctls_high) ||
> -	    nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
> +				vmx->nested.msrs.exit_ctls_high))
> +		return -EINVAL;
> +

Exit controls are not shadowed, are they?

Paolo
