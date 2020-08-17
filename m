Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FDA247596
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 21:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgHQTZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 15:25:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730583AbgHQTZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Aug 2020 15:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597692323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvUD6swS2EqpPwN1BEHv7oFTzOXyqShNBtCKnFKCQ/M=;
        b=ZzncZ4xjikNPRvzITWXq5FJuO7uRXdU+qgpSVCRs+ulc7boa9X1k+vVPrBrVNCBDmvsq/c
        DLsjcc2N5tbgBMcKFu1bUhDcW8Hj3XpyYj6tf80JQTKXQv7BTykvVJqNHbSLj4Gm0p+pCm
        gCfhNJaWve3Sz6RmQTg1UIoAfoNII3E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-gXVGffN6O-mRIYTpR86dxQ-1; Mon, 17 Aug 2020 15:25:10 -0400
X-MC-Unique: gXVGffN6O-mRIYTpR86dxQ-1
Received: by mail-wm1-f70.google.com with SMTP id z1so6366252wmf.9
        for <kvm@vger.kernel.org>; Mon, 17 Aug 2020 12:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vvUD6swS2EqpPwN1BEHv7oFTzOXyqShNBtCKnFKCQ/M=;
        b=GmkWdOx1XeYfxX6b+pAA9yuxdp1MGRA2jXQqQa0dEPzc/ZBFMC0SVq/uEZH7akiZCn
         /4p9hyN5CPcZ+Kf9w0roeERmTHo9/QSs6lNo0Z4dRpw2IU7pc6m0loW4Q/ysr3MZxDtw
         3UhAqY9q+fk9g7Kx1eneCbBfKvrC3RJV1WKTbw6pBkPngUii+8qAmNILNQsFSvbuUtJf
         3qt++OCicBUuXc15Ddruv0AkzCP9/9S9FKWB7/FaKUQaCQO6LE1ZdQjjPBSLE1DshaK1
         z6dZoYn0ZChxQJ6vwOOclB72UgNN6uWqgqY/oUzBhwIBPEStyYGnTIUa9e9ZuOfkjk7/
         aEPA==
X-Gm-Message-State: AOAM530lfceTuLptmTcTtWNUnXpdACVARRoY3tcFNwGmOJf+eky9WcGN
        ceF+y+dUXBTrxicH7O+2sYt0XV5lzCfT0dEjAFoa/0vas46WX8sOFXCpACORvw6Kn7taeyLK4Tr
        9V3cKDDEuIxd3
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr17414570wrn.345.1597692309350;
        Mon, 17 Aug 2020 12:25:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzI89+Poi3yVRhi5NjbDnlWdSjWdYPAOCkoLMMTNBCvHEHl6MwiCi1BiXPBWUCNXJYmYyL3MA==
X-Received: by 2002:adf:dfcf:: with SMTP id q15mr17414554wrn.345.1597692309116;
        Mon, 17 Aug 2020 12:25:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0d1:fc42:c610:f977? ([2001:b07:6468:f312:a0d1:fc42:c610:f977])
        by smtp.gmail.com with ESMTPSA id d14sm32963792wre.44.2020.08.17.12.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 12:25:08 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm: x86: Toggling CR4.SMAP does not load PDPTEs in
 PAE mode
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200817181655.3716509-1-jmattson@google.com>
 <20200817181655.3716509-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88c3ef1d-9c76-652b-f3a8-27ef5bc9d5ef@redhat.com>
Date:   Mon, 17 Aug 2020 21:25:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817181655.3716509-2-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 20:16, Jim Mattson wrote:
> See the SDM, volume 3, section 4.4.1:
> 
> If PAE paging would be in use following an execution of MOV to CR0 or
> MOV to CR4 (see Section 4.1.1) and the instruction is modifying any of
> CR0.CD, CR0.NW, CR0.PG, CR4.PAE, CR4.PGE, CR4.PSE, or CR4.SMEP; then
> the PDPTEs are loaded from the address in CR3.
> 
> Fixes: 0be0226f07d14 ("KVM: MMU: fix SMAP virtualization")
> Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9e427f14e77f..d8f827063c9c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -975,7 +975,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
>  	unsigned long old_cr4 = kvm_read_cr4(vcpu);
>  	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> -				   X86_CR4_SMEP | X86_CR4_SMAP;
> +				   X86_CR4_SMEP;
>  
>  	if (kvm_valid_cr4(vcpu, cr4))
>  		return 1;
> 

Queued both, thanks.

Paolo

