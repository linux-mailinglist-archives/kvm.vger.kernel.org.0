Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4EF46E9F6
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbhLIOdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 09:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhLIOdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 09:33:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4294C061746;
        Thu,  9 Dec 2021 06:29:45 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l25so20139845eda.11;
        Thu, 09 Dec 2021 06:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9cj0mtHbG/1EogjrV8DWvYZ3qqdf7FqjqdU9JmwNaoE=;
        b=UcjRt/F48WQ+88oivvHq5btKWLWP98eLCuaAlcCMhQmJOHkA8iVK9jz5B2qRE5NwCZ
         xJbBkugOnK4i0lsdQ0PYZCFRHxkvrDWGXBMOEKBuo1tUPiooxvmBZQQt7b/AidPodQnl
         KMJd7dPa4iT1mLB4w+foCa46H75L1T7IAFP4rA8yrywQe16swFcr48j7yvWRc3H5iBJe
         R4GcyW+tFfQQ6EPh8J33hjtZadnQMVEyaVpcPV6XrjH8XPALaMuxDvWvvpn8VggY64re
         WbkqgFM15dMZwubrJ+OjksRtaOIT7boFyJs7JZ7aHNAfKefBO2XvLVjUXbxzK9vLiIaY
         5G6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9cj0mtHbG/1EogjrV8DWvYZ3qqdf7FqjqdU9JmwNaoE=;
        b=x++dZZ52v1o/3p+12KQ062wsA+WmtBGsnNeoeocD1AiuJZIpX02VS7xTL5PxsplTpY
         XWsPnmitioawtTnrj0KF0LAWKl3Bfonf8FK1eI/YBB5sHyjzOp82kTaAYgP3QNcwBgqG
         YqKaq51/29YYg5R3EdgJut4PBDkb5HVQXKFBaz4cZPM9w6JpCUZ77MSu0nKoBzPZWNdG
         ApcmFnwXMJAc6hGKYi1EZavwNz2F0JTOeRD1BwqGCcqaU89C3Aa44fOfYEUiKVSVbgwA
         vMVJoLTq4Fr6pK6OtYYYjdOcj29xiaqIo5LYzYKp1XldtIixtgT1jGiKGa7rLRXu77AH
         OXLw==
X-Gm-Message-State: AOAM530NsB5G3T07bc+kBmo1j0D5tsq7ePfxdgnZKRzJYt0fL/uyrcCp
        xOaz0Y5ZvkISjZzBfaNAJZc=
X-Google-Smtp-Source: ABdhPJyzoHgfT0wNRHcffHzxW74cOpNqsmfXP7tjIl0bScfQZlJAg3gtAty+IICEdLo/TNpIUpAPwQ==
X-Received: by 2002:aa7:cd5c:: with SMTP id v28mr29282160edw.6.1639060147619;
        Thu, 09 Dec 2021 06:29:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j17sm1979edj.0.2021.12.09.06.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 06:29:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3bf8d500-0c1e-92dd-20c8-c3c231d2cbed@redhat.com>
Date:   Thu, 9 Dec 2021 15:29:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20211208015236.1616697-1-seanjc@google.com>
 <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
 <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
 <YbFHsYJ5ua3J286o@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbFHsYJ5ua3J286o@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 01:02, Sean Christopherson wrote:
> RDX, a.k.a. ir_data is NULL.  This check in svm_ir_list_add()
> 
> 	if (pi->ir_data && (pi->prev_ga_tag != 0)) {
> 
> implies pi->ir_data can be NULL, but neither avic_update_iommu_vcpu_affinity()
> nor amd_iommu_update_ga() check ir->data for NULL.
> 
> amd_ir_set_vcpu_affinity() returns "success" without clearing pi.is_guest_mode
> 
> 	/* Note:
> 	 * This device has never been set up for guest mode.
> 	 * we should not modify the IRTE
> 	 */
> 	if (!dev_data || !dev_data->use_vapic)
> 		return 0;
> 
> so it's plausible svm_ir_list_add() could add to the list with a NULL pi->ir_data.
> 
> But none of the relevant code has seen any meaningful changes since 5.15, so odds
> are good I broke something :-/
> 

Ok, I'll take this.

Paolo
