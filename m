Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB8264ABF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 18:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfGJQ2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 12:28:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38977 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfGJQ2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 12:28:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so3144734wrt.6
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 09:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWcJrXfv3P8CQycwoliQ+kXFFYHeff7L8HK2kQ7DPk4=;
        b=Nh2mhvKStGlIDGlcSWGVY3/WAlRPxLKTGknWBbNpYGOiJBLKRMyeW8PTUHEm/dbLPt
         1j1QTZUem/wj9DYGkimY4COYi0KoJlgotY9TwB8rdWCmE8U0mnvBGMYW6YjXoOqwy/Fo
         /4k6vBz9FTxe51ffx9DkKs8qgkESkgbWdcQ5uNZwi9eyrQ7c+xXDQJBcKjJq9FzeoWeC
         +ljNFgdVYDMKqsqwFeaWQvueZAyqr7XlqfS2Xyl+lYfI65daQmy9ShJS8LVQWI8QTlbM
         nH+bPSNRBF0CeWfFoYe/IAd7jR3AINm4iHSGcSzSmO3ND38t1D7ra+v2qKF0eghtFGeK
         NIjQ==
X-Gm-Message-State: APjAAAUF41RGRCCvJyHsHTG3hNhiVl1vsOvrF58ARL3kklmQOir4uWA/
        KCSHvz5T+ByD0hrhLHbXNZorIA==
X-Google-Smtp-Source: APXvYqxJ5mNlwuskW1VSwDgpNta3VqzWb4SKIgCjY1Fa1lt7AH3AXj/7QVFb98ftfmVu1bKtBjlsCQ==
X-Received: by 2002:a5d:66c5:: with SMTP id k5mr33360075wrw.304.1562776129758;
        Wed, 10 Jul 2019 09:28:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id x18sm2894021wmi.12.2019.07.10.09.28.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 09:28:49 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: nVMX: Skip VM-Entry Control checks that are
 necessary only if VMCS12 is dirty
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-4-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f26f9b0f-be5d-1e2d-9bc2-42ac2f6e4e41@redhat.com>
Date:   Wed, 10 Jul 2019 18:28:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190707071147.11651-4-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/19 09:11, Krish Sadhukhan wrote:
> @@ -2603,7 +2612,8 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>  		}
>  	}
>  
> -	if (nested_vmx_check_entry_msr_switch_controls(vcpu, vmcs12))
> +	if ((vmx->nested.dirty_vmcs12) &&
> +	    nested_check_vm_entry_controls_full(vcpu, vmcs12))
>  		return -EINVAL;
>  
>  	return 0;
> -- 

The vmx_control_verify above can be moved to the "rare" case.

Paolo
