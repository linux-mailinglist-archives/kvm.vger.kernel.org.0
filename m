Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB4D34EBE
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFDR1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:27:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42951 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDR1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:27:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id o12so9581737wrj.9
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cr8BrjNtYOFxwy5Oy3Ej0/Q0CeyJqGrrVrumTp5GPGk=;
        b=RnMSClEVt87EKETSEF8chqBnJaNKpS+1SZGNOJ2b9LeeeY7jwIiwyucXmUQVAm70EX
         U9CL7uVgbXHN9qSdI+D5ACP8GmzqZ6jQ519e/2pTfdua94YrYLyLbYmxC5+EH5q7aQEn
         ecmXCDqd+L8H3SV/Vo4KFpKTZ2keEICiMzMgMCmKYtETrVRQvVw7rH7fSJx5GWljhIpq
         UhNaKhzu9lhoHBjswxPuZ88E5qH4ffBzHnRJx9zUPFBSw0TzcJ9ivE+HjYjKemzuW6Pt
         plG3UQACWJVvmQ9sivrO/yUqUDitURLHSqlvnrardPvVbJ7IuOu5q0A0HY7sycDW8p9T
         2aVA==
X-Gm-Message-State: APjAAAWOTRxXLGSjWF/phx7y3h5X0btQk0hOkb5iiTvZ0vyK7UCymm5b
        o6dPiwwYJkp0ddtjeZZ73R9ISw==
X-Google-Smtp-Source: APXvYqx4G9q7ov7opkOXQO89pAuJTMeIfDaTqoZ9C8zOKa6K/iDhYHQv9TF4FSA5nJLp//i1V//moQ==
X-Received: by 2002:adf:e7c9:: with SMTP id e9mr7538350wrn.321.1559669224002;
        Tue, 04 Jun 2019 10:27:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id o21sm18023538wmc.46.2019.06.04.10.27.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:27:03 -0700 (PDT)
Subject: Re: [PATCH] KVM/nSVM: properly map nested VMCB
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Ahmed <karahmed@amazon.de>
References: <20190604160939.17031-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b46872ce-5305-aa25-9593-d882da3c0872@redhat.com>
Date:   Tue, 4 Jun 2019 19:27:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190604160939.17031-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/19 18:09, Vitaly Kuznetsov wrote:
> Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest
> memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter is
> GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other way
> around.
> 
> Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 735b8c01895e..5beca1030c9a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3293,7 +3293,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
>  				       vmcb->control.exit_int_info_err,
>  				       KVM_ISA_SVM);
>  
> -	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(svm->nested.vmcb), &map);
> +	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
>  	if (rc) {
>  		if (rc == -EINVAL)
>  			kvm_inject_gp(&svm->vcpu, 0);
> @@ -3583,7 +3583,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
>  
>  	vmcb_gpa = svm->vmcb->save.rax;
>  
> -	rc = kvm_vcpu_map(&svm->vcpu, gfn_to_gpa(vmcb_gpa), &map);
> +	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
>  	if (rc) {
>  		if (rc == -EINVAL)
>  			kvm_inject_gp(&svm->vcpu, 0);
> 

Oops.  Queued, thanks.

Paolo
