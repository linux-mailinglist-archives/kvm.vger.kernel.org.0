Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92F432A790
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839327AbhCBQRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:17:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346519AbhCBOWV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 09:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614694816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T6cKM/MlBUnmWehEbJOwaDKiIZgZyKVdolHs1AjckNQ=;
        b=DzBcaAjvg0zWRLI6D6cIJzG+t/RyiFdUKZeZfUdwATj0U64+5ojyGtTbphEnGFnmKPWpFn
        vK60Rz8k+LfGqMDcwsquVmnRnHRoeD6KjXcj7OLhwKFzphI+1NAngl4K87EzuZEKKAS/I2
        GZy9ahp5oxUm3yWkSY1Yqt+XKW4PBV8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-YQIcMaxlOcyS1EUFeRSLrg-1; Tue, 02 Mar 2021 09:20:14 -0500
X-MC-Unique: YQIcMaxlOcyS1EUFeRSLrg-1
Received: by mail-wm1-f70.google.com with SMTP id v5so1244176wml.9
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 06:20:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T6cKM/MlBUnmWehEbJOwaDKiIZgZyKVdolHs1AjckNQ=;
        b=q98eDPTEyDFXc9eX4GcIjmIst7geja0Ezeh51sDmaa40A6wArtxiSYJ9JqemG2lMg7
         OvezAsywZINGsBCf50koovVWCuBCa4FOXxk7zZ7NlQM7r87OTDLBVHZSslAfOGCbSq2v
         1erp2AcymVvI0en8LuQTnc9kj6lum1wIdBMlENgu2OOURnYvR4ptrQ3YXRNKzqVtKdjm
         cFWOLoLha9mY/D6sUVrLy/MYPIwNNd7vZ0NvfwaxcE168kvcqZ4dIoG2fbC8btWeq03m
         ryHXUsNFej3c2i2eWxlnVoRDtGyvdj3SvoWy5B8Ss+dSHqIhZOUjVTuBuNI4/VH2kR8r
         TNEA==
X-Gm-Message-State: AOAM530srI3AAH8J9HrMAXWYmrzxaab6xerGB/QkOUjm1gc8+IBst6DP
        RLsNwGpKHmjB0P/kmI/ERonQQGajCB1te3ZQV7qGNogygL/SZwwV6XKQ4z6RrS9rCPGiXdW3McH
        fvf269/VnUEQK
X-Received: by 2002:a1c:1f94:: with SMTP id f142mr4335324wmf.180.1614694812906;
        Tue, 02 Mar 2021 06:20:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4EeI8+gO2ZeiqMHfTMS9oaplJEMF/NY0ct6Bm2rwTKqquoQc6Lv/D+f35ZjrzwiJfJLyE4w==
X-Received: by 2002:a1c:1f94:: with SMTP id f142mr4335309wmf.180.1614694812777;
        Tue, 02 Mar 2021 06:20:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j20sm2505487wmp.30.2021.03.02.06.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 06:20:12 -0800 (PST)
Subject: Re: [PATCH] KVM: nSVM: Optimize L12 to L2 vmcb.save copies
To:     Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, wei.huang2@amd.com
References: <20210301200844.2000-1-cavery@redhat.com>
 <YD2N/4sDKS4RJdlR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35b73239-56bd-8979-d9aa-1571eb73e94d@redhat.com>
Date:   Tue, 2 Mar 2021 15:20:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YD2N/4sDKS4RJdlR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/21 01:59, Sean Christopherson wrote:
>> +	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
> Same question for VMCB_CR2.

Besides the question of how much AMD processors actually use the clean 
bits (a quick test suggests "not much"), in this specific case I suspect 
that the check would be more expensive than the savings from a memory load.

Paolo

