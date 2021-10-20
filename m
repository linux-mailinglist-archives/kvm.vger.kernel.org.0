Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E728343493D
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJTKrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:47:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhJTKrf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634726721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TU4HaAmyQ/Ik/9e81qaM8nooJ9cLvr8+ZGrMq2gdVQ=;
        b=I4RmLdHbDDrg5Dk6hdnSkZ9WxZ03akG3VCR2xK5X4y5h9zYj2CbbCLcepd7nn2VJb9y9nb
        0iQ2Y30Tg6ni+zQIy071w0rGGe2q4FPqExeVFkHi/Oz87AU3LRSEbepXRiszqDOb63xGZc
        kYcSCK4p/a123Jadgt9Hl6cgMQjlGeY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-_-guPv_FOCm9UL5sgSGcVw-1; Wed, 20 Oct 2021 06:45:20 -0400
X-MC-Unique: _-guPv_FOCm9UL5sgSGcVw-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so20567511edi.12
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 03:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8TU4HaAmyQ/Ik/9e81qaM8nooJ9cLvr8+ZGrMq2gdVQ=;
        b=FG2KDFns5rPtVVz8efJH7wXbPDloVeS11geYMoYlapJ3Wauo0xPm/ynDrruYeGc5uW
         +bpB5Cc0IjoexAkiX9UzwyVHOG9qN6g0FtuCf4FfJue9atuz4NmLhlyaYFTMM5/RE1yc
         Gwwap/9MGVVnkpR7AogS45Np/sHN5UY1Xtg8TWRf9spae0PSLkMA/FYVXKoil8Qhr8Ue
         HogmhTboSZQquHyBGvs3RqkaS7bghPr25nh2UqjKLQnH48/AOxjr1ntr/B4eTbbw4Yg9
         AeK8tNvqL2HhzWO8i31vzw6LOIw1uOmtnMIZnSe27CfsEFiGpXy5nWmjDZ2o5v6TDz/T
         fDTQ==
X-Gm-Message-State: AOAM530Mvg2+mCUIuVX8x6SMAgh8iXF87BalhXi2q/B58Ir9+K/8Pjzi
        pqKQzMOprFmDg7aPak1i2mvqoIe2UNFNd4ieASxrMSeDDdb9k0psuUHZzg1083ppGmWAXSnqsYt
        MO6sUwa5DFwF5
X-Received: by 2002:a17:907:961e:: with SMTP id gb30mr5554990ejc.484.1634726717690;
        Wed, 20 Oct 2021 03:45:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJHOcVyawEdwH5VDpLjOZaVqrj0rofKVGiRhw/MoVTAD7k0YlN4HzsPQss6+DpGt3FYpUgWw==
X-Received: by 2002:a17:907:961e:: with SMTP id gb30mr5554850ejc.484.1634726716376;
        Wed, 20 Oct 2021 03:45:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b17sm954051edy.47.2021.10.20.03.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:45:15 -0700 (PDT)
Message-ID: <18aed000-47f7-1fb7-d898-55a94bb1ec74@redhat.com>
Date:   Wed, 20 Oct 2021 12:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5] KVM: emulate: Don't inject #GP when emulating RDMPC if
 CR0.PE=0
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634724836-73721-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1634724836-73721-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 12:13, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> SDM mentioned that, RDPMC:
> 
>    IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter))
>        THEN
>            EAX := counter[31:0];
>            EDX := ZeroExtend(counter[MSCB:32]);
>        ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
>            #GP(0);
>    FI;
> 
> Let's add a comment why CR0.PE isn't tested since it's impossible for CPL to be >0 if
> CR0.PE=0.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v4 -> v5:
>   * just comments
> v3 -> v4:
>   * add comments instead of pseudocode
> v2 -> v3:
>   * add the missing 'S'
> v1 -> v2:
>   * update patch description
> 
>   arch/x86/kvm/emulate.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9a144ca8e146..c289809beea3 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4222,6 +4222,9 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
>   	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
>   		return X86EMUL_CONTINUE;
>   
> +	/*
> +	 * It's impossible for CPL to be >0 if CR0.PE=0.
> +	 */
>   	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
>   	    ctxt->ops->check_pmc(ctxt, rcx))
>   		return emulate_gp(ctxt, 0);
> 

Queued, thanks (with a slightly more verbose comment).

Paolo

