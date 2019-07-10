Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F78464AB9
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfGJQ0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:26:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35278 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfGJQ0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:26:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so2933242wmg.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vFfC4JjZGladIROVFGI0rVeUQKxhKnvRerRX/g8TQmw=;
        b=Lo5/QE72JQP/KFQGo+pI31kuUOXk50PguQJta+C55Ioz7MZ5dZ+9Pm3hTIA7qAObdw
         TKpEiE3pj1cmQkB2t9ddDcUfPqPsFY9MKBcYfvJqf0X4uddUNM4gg+nO6jAw8ZRlPcJz
         ZvJkWrBvDkhAeCwMn4i0PTt87BVGqCp1vyT6keU1S2IJ73XEGh1ft0KuIRIXsfLNkUX0
         /UczwXk8iqaPq3QBkCxl3IEGpJpq6bzlU4ddlj1KWEDD1DaHVV7rgbzbcB0bGzrlKg/l
         s+XqesKMO3Rl5eA7vy39u7qjU0mbYIaNe4kvZ73AFPUOtzdxpyJF63+odxiP+qEOAR18
         ID5w==
X-Gm-Message-State: APjAAAVw0YGyK318/3wKvu7cqapVL2AIGrDDIl6GQyFTUxUbwISxdP9r
        m0wTBgd+wvojzwbSh+fTK6KGUA==
X-Google-Smtp-Source: APXvYqxiPvRw1bOuCm+919IQOISHrH7WKwBZ+QnZ/uGLoi4ttjN6b6zMG67dxon8XfFXOdZIpjzebg==
X-Received: by 2002:a1c:5f09:: with SMTP id t9mr6445112wmb.112.1562775989109;
        Wed, 10 Jul 2019 09:26:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id t1sm3583709wra.74.2019.07.10.09.26.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 09:26:28 -0700 (PDT)
Subject: Re: [PATCH 4/5] KVM: nVMX: Skip Host State Area vmentry checks that
 are necessary only if VMCS12 is dirty
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-5-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <06102ba3-1953-d746-1935-a1042a4df6e4@redhat.com>
Date:   Wed, 10 Jul 2019 18:26:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190707071147.11651-5-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/19 09:11, Krish Sadhukhan wrote:
> +				       struct vmcs12 *vmcs12)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	if ((vmx->nested.dirty_vmcs12) &&
> +	    nested_vmx_check_host_state_full(vcpu, vmcs12))
> +		return -EINVAL;
> +
> +	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0))
> +		return -EINVAL;
> +
> +	if (is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu))
> +		return -EINVAL;

These two are not part of the shadowed state, so they can be done only
in the "rare" case.

> +	if (vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
> +	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK))
> +		return -EINVAL;
> +
> +#ifdef CONFIG_X86_64
> +	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
> +	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
> +		return -EINVAL;
> +#endif

Same for host GDTR and TR base.

Paolo
