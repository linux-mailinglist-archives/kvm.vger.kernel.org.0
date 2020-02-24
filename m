Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3516A6C0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgBXNEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:04:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21704 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727357AbgBXNEx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 08:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mIKqdTyz5+ImR2nkZFVBhUc+4BM9OsRtqGi03fmbSvE=;
        b=F4Kt7xKMknpqeU/18LerJFMa9u6ijDQWAi4SxbPLBcE3aBTlbqQorvIi5exofod1jQ6+nK
        ymxdMtSk3cYN72SUyQ05lQqHXQX/qTOLqWs/oKmn8UIS7eBQ1Jcs9Uoh9EUlU4RabnIs9G
        nP99Dgu4+Z2nLpbExF6chU7VVE4jhRc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-E28yLxMZNz2GUsASEK5hzg-1; Mon, 24 Feb 2020 08:04:50 -0500
X-MC-Unique: E28yLxMZNz2GUsASEK5hzg-1
Received: by mail-wr1-f72.google.com with SMTP id z15so5595722wrw.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:04:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mIKqdTyz5+ImR2nkZFVBhUc+4BM9OsRtqGi03fmbSvE=;
        b=K7/pk57kdRyVObZj7PFc4xUO0TpBxqrXwse2E7x/pbflqgLYNVgM/b5H98alg5yyPy
         rhmFhD+IcbO0JsoZyG7gslqeC/eywz3H1bkTtgg0R3tVl0eZ0K4iUVysTKv+LLfZCNyG
         +/aiHOR+Az40PyNELKbMviJn1ZBcFyilIU2llXDp/KzDvzlKOj+AZFmmh8BP+wyL+5yX
         1Z9MSrs6ycmYbpkQMMmolJJcezXQdJ244tqEWKjkhExjyCsnzYgzkmnEnZnZ4otSt4Y0
         oOOHXRsxHD4o57TN0XGeBHN8OsCLBhtr9RBtxoJPgPVEEGPI9czUWbTb2XQ/KrAF1Cea
         6E7Q==
X-Gm-Message-State: APjAAAUZFYaAgH3aEh6dU9xym/ZGyuHuqQ5NRr57Mme+rn9dEmFmLPEj
        8T1R0elVhDm8Zd0EO5HQzvlGp/FoncrdLemi/AIWOjUsYsZb3SRHMhXjWUjjWax7I+N6nutTNfk
        cVyMUbzcwrR5G
X-Received: by 2002:adf:e401:: with SMTP id g1mr11153795wrm.165.1582549488561;
        Mon, 24 Feb 2020 05:04:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxG1YTc0sc80OFrDGBo0TAMpvdqkU5rb8GaSOHzb9RQKL5aY4N4+m+dNRLG71F1VA35nN64NA==
X-Received: by 2002:adf:e401:: with SMTP id g1mr11153777wrm.165.1582549488312;
        Mon, 24 Feb 2020 05:04:48 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c9sm18385475wme.41.2020.02.24.05.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:04:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the specific VM EXIT
In-Reply-To: <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
References: <20200224020751.1469-1-xiaoyao.li@intel.com> <20200224020751.1469-2-xiaoyao.li@intel.com> <87lfosp9xs.fsf@vitty.brq.redhat.com> <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
Date:   Mon, 24 Feb 2020 14:04:46 +0100
Message-ID: <87imjwp24x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 2/24/2020 6:16 PM, Vitaly Kuznetsov wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> 

...

>>>   		rip = kvm_rip_read(vcpu);
>>>   		rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
>>>   		kvm_rip_write(vcpu, rip);
>>> @@ -5797,6 +5797,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
>>>   {
>>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>>   	u32 exit_reason = vmx->exit_reason;
>>> +	u16 basic_exit_reason = basic(exit_reason);
>> 
>> I don't think renaming local variable is needed, let's just do
>> 
>> 'u16 exit_reason = basic_exit_reason(vmx->exit_reason)' and keep the
>> rest of the code as-is.
>
> No, we can't do this.
>
> It's not just renaming local variable, the full 32-bit exit reason is 
> used elsewhere in this function that needs the upper 16-bit.
>
> Here variable basic_exit_reason is added for the cases where only basic 
> exit reason number is needed.
>

Can we do the other way around, i.e. introduce 'extended_exit_reason'
and use it where all 32 bits are needed? I'm fine with the change, just
trying to minimize the (unneeded) code churn.

-- 
Vitaly

