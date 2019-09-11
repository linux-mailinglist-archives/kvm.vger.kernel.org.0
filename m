Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2929B0003
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfIKP2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:28:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbfIKP2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:28:25 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D30F4E8AC
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:28:25 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id j3so10617556wrn.7
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OctprHGLTPyVEXJRw7BOFUi6QgEYCMX3fg2xDR1qkMo=;
        b=smoZyosFzhJ2EmtuRaSypj1yRzGzXLErf0XK2uByNqkVWEKKqLrSoPaLurv7ifZ88X
         qtHR9OiisKOyXGLOhnlc2We9Lbo6nrr02YOFc5YajsppgVJu9rKFB2i7bfVGUNL/KeIc
         vQl2fnAl4UPLKKD3dRGz9/Wg3yYg+dRqiHcNcjIfceIamofkeMlEkOjwraAQKXsP1XL0
         Tlh7p8qsXdVOGXsHxOxCQkdDTNfwpFAFCvFBG8yQM0fZVbykZXGEm7STAkAPqGz27COH
         A+Fgu5+Bv18vOEQXATzFpEPt7mq0UuPhlGZCWm9eCfcMsyOSyOuezXgQ5xFdoExEvhnA
         ewtQ==
X-Gm-Message-State: APjAAAVhaCpCpM2a0kgqOY4rBKvsNJyHzOZAJr6wsDTkjfIE0jlUVUS/
        AQhoVpX+ih3hvENVjYKtmy/d5Usf8gsT4nK6EgR45lcNNllXT4Bmlwx7RfoQdBveayHIa2j9iNI
        TYxizYgcZzGug
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr4680505wmd.104.1568215703852;
        Wed, 11 Sep 2019 08:28:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyxvNyaSSrltFTPvuyFJKxHR+MG2cvYC+KEazadrho4ounKnxwv+141+NO6OcbRu/HAujcVRg==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr4680494wmd.104.1568215703596;
        Wed, 11 Sep 2019 08:28:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id n14sm53551125wra.75.2019.09.11.08.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:28:22 -0700 (PDT)
Subject: Re: [PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190827093852.GA8443@mwanda>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5d683b17-5eee-78cc-8a92-401f0ff27e17@redhat.com>
Date:   Wed, 11 Sep 2019 17:28:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827093852.GA8443@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/19 11:38, Dan Carpenter wrote:
> We refactored this code a bit and accidentally deleted the "-" character
> from "-EINVAL".  The kvm_vcpu_map() function never returns positive
> EINVAL.
> 
> Fixes: c8e16b78c614 ("x86: KVM: svm: eliminate hardcoded RIP advancement from vmrun_interception()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> From static analysis.  I don't really know the impact.
> 
> 
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..ef646e22d1ab 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3598,7 +3598,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm)
>  	vmcb_gpa = svm->vmcb->save.rax;
>  
>  	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
> -	if (ret == EINVAL) {
> +	if (ret == -EINVAL) {
>  		kvm_inject_gp(&svm->vcpu, 0);
>  		return 1;
>  	} else if (ret) {
> 

Queued, thanks.

Paolo
