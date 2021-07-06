Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED73B3BC628
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 07:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhGFFp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 01:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230004AbhGFFp3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 01:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625550171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kR/4RD2c6G7vfOI3cAArYTywlbZ39ro+LD6XzRbKsSs=;
        b=TDR6ZtCBD9NitmTh6bdTybfy4XDJht6ItyVVW+kKBEuKor2wWgQa+aXyrAWjTSkRC6md/S
        fVh4zkCyIuGnCV5vR+8v+shg/21TJDfYNsdrxr0VTs3NbJq91nSPn6QmwCf4KesRnpJdJH
        ae+T/Z68g7bylHFhUb+i1CckFl0yx3s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-_SAeTeXlPliJgBwt89E46g-1; Tue, 06 Jul 2021 01:42:49 -0400
X-MC-Unique: _SAeTeXlPliJgBwt89E46g-1
Received: by mail-wm1-f72.google.com with SMTP id f9-20020a7bcd090000b02901eca9a0d67cso250942wmj.0
        for <kvm@vger.kernel.org>; Mon, 05 Jul 2021 22:42:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kR/4RD2c6G7vfOI3cAArYTywlbZ39ro+LD6XzRbKsSs=;
        b=EqlJuzS1t5RwpSgRXTKWWcrN0GndRItLAzvELUY+OP30HAhUnjaMdlZiksWAMvqD4E
         jRLinvyVy42XoOw5L1RwbJ7uTH8rqmsxkmealVu2WZQOGqCPfCOtHO3xm1HPgfOkOH/d
         SaP1efDqRURQ/NoMWeNuXdRnMBK9duTAtXcCcTTU/EG3DoMu/SeVQbrFj2XglyNT+7ZK
         biVthrCEQ8Cs0ryRi3hEAI+pCtmPRg3Xzfw3FMISUXGG94YfV8j2bhEt7z9bJigSr8U5
         b4VjzzDdrPktKiEs1CJhLoG2o3RVjHHAsazUMDRuYrXZV/EbpW5pZehCLLBcqQDZS1ep
         O+xA==
X-Gm-Message-State: AOAM5318aXnv2uh+UAbMjSjHKYdonQFXrJ6vnmlvc3SfRS9fwdeSDH/M
        S6if+O/ehHbI7niNW89R9duIKYoN5buSnfrRMuS8t2TyrIRycuvBThQosbuAiCp3UDS+Dv8eaf4
        vFaVZNYTGmWDy
X-Received: by 2002:adf:a74a:: with SMTP id e10mr19186470wrd.185.1625550168797;
        Mon, 05 Jul 2021 22:42:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnq74tdPgX6MASLfGfeoSIgIe1/v6vzMrGXHjwD3JFyBqyiBH7F/q8wLbVgbgHfLJJqjJT5g==
X-Received: by 2002:adf:a74a:: with SMTP id e10mr19186458wrd.185.1625550168591;
        Mon, 05 Jul 2021 22:42:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w8sm16481761wrt.83.2021.07.05.22.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 22:42:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
To:     "Hu, Robert" <robert.hu@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210618214658.2700765-1-seanjc@google.com>
 <c847e00a-e422-cdc9-3317-fbbd82b6e418@redhat.com>
 <YNDHfX0cntj72sk6@google.com> <da6c715345954a7b91c044ad685eb0f2@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d98092db-b277-44f5-df5e-f367ecb5a0fc@redhat.com>
Date:   Tue, 6 Jul 2021 07:42:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <da6c715345954a7b91c044ad685eb0f2@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/21 05:05, Hu, Robert wrote:
>> As noted in the code comments, KVM allows VMREAD/VMWRITE to all defined
>> fields, whether or not the field should actually exist for the vCPU model doesn't
>> enter into the equation.  That's technically wrong as there are a number of
>> fields that the SDM explicitly states exist iff a certain feature is supported.  To
>> fix that we'd need to add a "feature flag" to vmcs_field_to_offset_table that is
>> checked against the vCPU model, though updating the MSR would probably fall
>> onto userspace's shoulders?
> 
> [Hu, Robert]
> Perhaps more easier and proper to do this in KVM side.
> QEMU sets actual feature set down to KVM, and KVM updates IA32_VMX_VMCS_ENUM
> MSR accordingly. We don't see a channel that QEMU constructs a VMCS and sets a whole
> to KVM.

Yes, it's possible to do that too.  If that is included in Linux 5.14, 
we can remove it from QEMU.

Paolo

