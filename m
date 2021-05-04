Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A33C3726DE
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhEDIDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:03:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhEDIDP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 04:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620115341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RazSrOHQRIEZi4NpTNvRDMTS0CNW0QsK+1YnSeSLHGA=;
        b=XzXrKsHgR8hvGLMnwwuyMXTOH0vlUSw1/uofUgvG1zNI2CCzok4T6HwSlz8UdDvlNntA1H
        vNSIe72iEWbXVLqUoDxOVeI4fCqiSrbx7tRVFN5gji4KH3+iUPuqu4lmskrAqRlNX03gQR
        A197BdXfuBoZyd0OuY0qQ5uzHklQ14c=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-zFwsupwJPnWn8-7CdGsdOg-1; Tue, 04 May 2021 04:02:16 -0400
X-MC-Unique: zFwsupwJPnWn8-7CdGsdOg-1
Received: by mail-ej1-f69.google.com with SMTP id bi3-20020a170906a243b02903933c4d9132so2825567ejb.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 01:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RazSrOHQRIEZi4NpTNvRDMTS0CNW0QsK+1YnSeSLHGA=;
        b=CyEHeDsk7GAqZXedsknAPASUVw7jp8XQc+gotG/12C09RxKU/KKEYmLQJ/sxCQrP3l
         RStw2sU6LdtRXDjLpUmS4ly8vet59rgWCvfCeZDwcHH0u3hA7TN8vC6WnyA6FyIgBDVc
         VHG2BpEFoJwdgPui4Durh2fNQva5/WNk1Bt7fNQF5/pOrQIKD3Jaeeo4DCuHe54jmmV3
         XfoqghwxsZYkAF/1ODhoYQj2+wquO5dSMss1DrEDgp7Qquq3A3BtjGZCVoUrOrsIZ0pl
         BVrtBgoNyAwrGnwkY3lnhOs7lnMSLMUrXCxx76eHOcD8QXYSbSkGVe/oC1AMRmlF6CgK
         2rvQ==
X-Gm-Message-State: AOAM5308mn1XAWIJwx6iDH2qiTX0lqkUcxX8GhWXlDtfgJTtqzNyu/rM
        D4WHRy7fRu1YHyE04oHn/yM9mIkOTX14dYAoIAkws4mXo8xN34GZOM8BQQLeZ8Ozyh8MuBMP27E
        mPRua/4LzmAuV
X-Received: by 2002:a17:906:a2d1:: with SMTP id by17mr21419097ejb.426.1620115335493;
        Tue, 04 May 2021 01:02:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweCmFPwqcdiMBHVArj6oWwQABJweFkYeuR6CqR2SYSBGFK8M7OAXR4kpyt3tKr6KHslmCVZg==
X-Received: by 2002:a17:906:a2d1:: with SMTP id by17mr21419082ejb.426.1620115335335;
        Tue, 04 May 2021 01:02:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x18sm983963eju.45.2021.05.04.01.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 01:02:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: nVMX: Map enlightened VMCS upon restore when
 possible
In-Reply-To: <87de6570-750c-5ce1-17a2-36abe99813ac@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
 <20210503150854.1144255-5-vkuznets@redhat.com>
 <87de6570-750c-5ce1-17a2-36abe99813ac@redhat.com>
Date:   Tue, 04 May 2021 10:02:14 +0200
Message-ID: <87h7jjx6yh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 03/05/21 17:08, Vitaly Kuznetsov wrote:
>> It now looks like a bad idea to not restore eVMCS mapping directly from
>> vmx_set_nested_state(). The restoration path now depends on whether KVM
>> will continue executing L2 (vmx_get_nested_state_pages()) or will have to
>> exit to L1 (nested_vmx_vmexit()), this complicates error propagation and
>> diverges too much from the 'native' path when 'nested.current_vmptr' is
>> set directly from vmx_get_nested_state_pages().
>> 
>> The existing solution postponing eVMCS mapping also seems to be fragile.
>> In multiple places the code checks whether 'vmx->nested.hv_evmcs' is not
>> NULL to distinguish between eVMCS and non-eVMCS cases. All these checks
>> are 'incomplete' as we have a weird 'eVMCS is in use but not yet mapped'
>> state.
>> 
>> Also, in case vmx_get_nested_state() is called right after
>> vmx_set_nested_state() without executing the guest first, the resulting
>> state is going to be incorrect as 'KVM_STATE_NESTED_EVMCS' flag will be
>> missing.
>> 
>> Fix all these issues by making eVMCS restoration path closer to its
>> 'native' sibling by putting eVMCS GPA to 'struct kvm_vmx_nested_state_hdr'.
>> To avoid ABI incompatibility, do not introduce a new flag and keep the
>
> I'm not sure what is the disadvantage of not having a new flag.
>

Adding a new flag would make us backwards-incompatible both ways:

1) Migrating 'new' state to an older KVM will fail the

	if (kvm_state->hdr.vmx.flags & ~KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE)
	        return -EINVAL;

check.

2) Migrating 'old' state to 'new' KVM would make us support the old path
('KVM_REQ_GET_NESTED_STATE_PAGES') so the flag will still be 'optional'.

> Having two different paths with subtly different side effects however 
> seems really worse for maintenance.  We are already discussing in 
> another thread how to get rid of the check_nested_events side effects; 
> that might possibly even remove the need for patch 1, so it's at least 
> worth pursuing more than adding this second path.

I have to admit I don't fully like this solution either :-( In case we
make sure KVM_REQ_GET_NESTED_STATE_PAGES always gets handled the fix can
be omitted indeed, however, I still dislike the divergence and the fact
that 'if (vmx->nested.hv_evmcs)' checks scattered across the code are
not fully valid. E.g. how do we fix immediate KVM_GET_NESTED_STATE after
KVM_SET_NESTED_STATE without executing the vCPU problem?

>
> I have queued patch 1, but I'd rather have a kvm selftest for it.  It 
> doesn't seem impossible to have one...

Thank you, the band-aid solves a real problem. Let me try to come up
with a selftest for it.

>
> Paolo
>
>> original eVMCS mapping path through KVM_REQ_GET_NESTED_STATE_PAGES in
>> place. To distinguish between 'new' and 'old' formats consider eVMCS
>> GPA == 0 as an unset GPA (thus forcing KVM_REQ_GET_NESTED_STATE_PAGES
>> path). While technically possible, it seems to be an extremely unlikely
>> case.
>
>
>> Signed-off-by: Vitaly Kuznetsov<vkuznets@redhat.com>
>

-- 
Vitaly

