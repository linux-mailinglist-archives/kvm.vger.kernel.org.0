Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541022C8E32
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgK3TiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:38:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728846AbgK3TiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 14:38:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606765015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lvo38NeUmX3WfK50GcoDPfrgYcrXFeCoA1QNBxqIdDk=;
        b=dOArAOssyzFMKNjZI6aAZTqxA9UBFy/hfrXjTlZ/d0Mp164f8nhj/KD+D79amrLT3Z71Dt
        X2usRVHw389PhhOgguYup/lLGx8ij5vh9mylMIRlslOToo1/oL3xD1kp0PJRu8uA7E1dds
        kqyBm3Onmg6aC12Xhxp9jl9G3BL/Xvk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-vdcwi835PnaEg2KSPzeNzQ-1; Mon, 30 Nov 2020 14:36:53 -0500
X-MC-Unique: vdcwi835PnaEg2KSPzeNzQ-1
Received: by mail-ed1-f72.google.com with SMTP id w24so3700559edt.11
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:36:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lvo38NeUmX3WfK50GcoDPfrgYcrXFeCoA1QNBxqIdDk=;
        b=e5hai1+n8dUjN6/XTniBrA7bGBy0y5bWbadbfO9s72W+auhq0txriDcc4UpCu738Md
         OK399hpVAKbrm9QMABYSi97Q0DyK9QJ7u53U+WAUKCZ7pb+rUGMo0rx8CxaX8VRFPZ6v
         ipsvBIDaK3tfPwBe8R9KV1gcWxAL24O6g5ZgHrfXf6IYvPlzP0z1pdKjaGIjnlKydsk1
         2+0QuXgwP3hbIujEG/sV7w/GdTECZ0TEOx8WQ4lWdNSWYX1UgxgxkjN3skdb8oHZCpYI
         GnlkYtfLCTjJX/BiZH45BD/2xcIZiE9YCY/gVFFuCAVmah9fVU42uikTu+2+/BhEj/Zk
         vARg==
X-Gm-Message-State: AOAM533r+9IsOyW1yA5QarugR2VnBokozjWQWipevw/UVIOQMdfr5E+z
        OgpEFoblDsQCfOsjkJD/RjtWV9lKuyQgrLiIrTz3igucFgwdd4MBJY0vWPvs68ToZLc45xbHFp/
        wN8KOhBdnz5Tb
X-Received: by 2002:aa7:d456:: with SMTP id q22mr22982808edr.206.1606765011999;
        Mon, 30 Nov 2020 11:36:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwy9Tytw6MEry1xR4ddeMaHYj4fhtuj67ET7jm5fkpxq55qzNbeLPZjV+H3bxgnGaZnUuCsow==
X-Received: by 2002:aa7:d456:: with SMTP id q22mr22982798edr.206.1606765011848;
        Mon, 30 Nov 2020 11:36:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i7sm3715805edr.61.2020.11.30.11.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 11:36:51 -0800 (PST)
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
References: <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
 <20201125011416.GA282994@google.com>
 <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
 <20201125183236.GB400789@google.com>
 <89fe1772-36c7-7338-69aa-25d84a9febe8@redhat.com>
 <X8VEsw4ENJ3MH+3o@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <165de965-4716-7d9e-df94-bde3fead232a@redhat.com>
Date:   Mon, 30 Nov 2020 20:36:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8VEsw4ENJ3MH+3o@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 20:14, Sean Christopherson wrote:
>> +	WARN_ON(!irqs_disabled());
>> +	max_irr = vmx_sync_pir_to_irr(vcpu);
>>          if (!is_guest_mode(vcpu))
>>                  vmx_set_rvi(max_irr);
>> +	else if (max_irr == vmx->nested.posted_intr_nv) {
>> +		...
>> +	}
>>   }
>>
>> and in vmx_vcpu_run:
>>
>> +	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
>> +		vmx_hwapic_irr_update(vcpu);
> And also drop the direct call to vmx_sync_pir_to_irr() in the fastpath exit.
> 
>> If you agree, feel free to send this (without the else of course) as a
>> separate cleanup patch immediately.
> Without what "else"?

This one:

+	else if (max_irr == vmx->nested.posted_intr_nv) {
+		...

Paolo

