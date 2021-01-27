Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09CC30621F
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbhA0Ree (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:34:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235779AbhA0RcU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611768652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XkzfQ7JLhuJiuzMMsy2O4iFme8poGbCus8N/6ZyaesA=;
        b=WM3MrgNQLktt/2bGfQ+XmcqtFMcKb6KPr+N+1cVhy/ZxdjWpBmVlAMN7UXJ53fsJ1zipuM
        kbXOpha5E2WURNWoMaEK52y8nQDOdYjrw1V56GRauNM7AVZV0GGnpnOHZKBLnI+S865VNM
        niAukIcOq6+lG3O76lvYyyj/nmUWuFo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-0E75UQaNP7qv1yq4DWJwcA-1; Wed, 27 Jan 2021 12:30:50 -0500
X-MC-Unique: 0E75UQaNP7qv1yq4DWJwcA-1
Received: by mail-ej1-f71.google.com with SMTP id f26so978528ejy.9
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 09:30:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkzfQ7JLhuJiuzMMsy2O4iFme8poGbCus8N/6ZyaesA=;
        b=CnGzOkoKaK5P6FuMg95OinahvXQi6KdPXHN/vxEj0f5tUAeMPB/PM7edVN19VXa3CW
         XkhCyhPqWjMWPKLDL+MKrwt5FyxShR+AAfbZSmCSHDECFJSjmMak5NobrsXrJT+0EooU
         ZU4RgaawZuTL+1PRoSQpcWGTurtwov0oxelaiSeHImZp/6WmRygEhz98JkTgrAaZYdig
         P5Qrks0knhHHiXBU3VcnymqsVM0Oy9MzuisUivKLqnRPgo+yZtRuzfmy3tnimDaeSy+n
         u3zxLqYJGV4nOQcQds03TGAMuWkdqDhOBMGIy+k4pGe2KD/yGpK/pHbN5ugfo6n9pmR6
         YsRg==
X-Gm-Message-State: AOAM530cXa6k0EOFlzoIaVRvP5wo0LEkZrc8xrCJs8OlD7+6ynrsODTa
        ao/5PJwD1vJhb9Pw1ZDEEbbhYVJ3Z2WkJq8tTCV09XNNUO7IH58DHXkkMUV1hMzWUJmodHJ98zS
        6V5bm6S+4YfGH
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr7688491ejr.177.1611768649473;
        Wed, 27 Jan 2021 09:30:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMmG2yA1LAIObXA6TKj+pk8FnGymREzDd1DtQq6L/KnoQ2xvOyjL1grH7QVqQIMxLWVgnaPQ==
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr7688476ejr.177.1611768649261;
        Wed, 27 Jan 2021 09:30:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f20sm1687594edd.47.2021.01.27.09.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 09:30:48 -0800 (PST)
Subject: Re: [PATCH v3 01/11] KVM: x86: Get active PCID only when writing a
 CR3 value
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e56d38bf-bc07-ebfb-5bec-60c60d664447@redhat.com>
Date:   Wed, 27 Jan 2021 18:30:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201027212346.23409-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/20 22:23, Sean Christopherson wrote:
> 
> +static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long cr3;
>  
> -	cr3 = __sme_set(root);
> +	cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
>  	if (npt_enabled) {
>  		svm->vmcb->control.nested_cr3 = cr3;

SVM uses the name "nested CR3" so this variable actually could represent 
an NPT value that does not need the PCID.

Therefore, this change must be done in an else branch, which I've done 
on applying the patch.

Paolo

