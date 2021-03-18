Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B55340C71
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhCRSGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:06:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232465AbhCRSFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 14:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616090754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ll1bQe/UBT3VroUgF4BnknfLZ8l/4NCV9c8uHrwM20E=;
        b=RryRHP/EIMvWXwce0uixse+3hGjzoqDZxry5gOT0QyaS2mSRtLAUfcZFTHMv/MSmzYg76H
        cw2YRVV5LIrJ8ET34EsAz79SNYf3rtn4KhVKYBzYdOPYGLXH+NbCM8/oSd9Y7+/NOAl38h
        0mHwIye4pa8rdL43YYvgYM3svSnuM8k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-77VoZfaPOyCD72D0yIILjA-1; Thu, 18 Mar 2021 14:05:53 -0400
X-MC-Unique: 77VoZfaPOyCD72D0yIILjA-1
Received: by mail-ed1-f72.google.com with SMTP id q25so6892042eds.16
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 11:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ll1bQe/UBT3VroUgF4BnknfLZ8l/4NCV9c8uHrwM20E=;
        b=anMinDbGh9aYDW/2qnfSMIFvDI5xuzUzLXkaWs9ACkwy7eda28G+bHYBbgmGstucrV
         vQRfUgZmwDFBef9KelbkGw1oDDkBHeHIymX8Qg1UfZiOnChRDMDpsHM1SPL+fXjuzYGv
         M0njvUA/OLG8tu42JUmPCCloWgkuNURGVktkg2Ue1HvA9l3xEDTyhd6V8WGaDFnTmHem
         /rlmWGTgh8nla5fcS3zTbeWz3pROUv/k5oesQz2ZsZ0g8q0jz2N6qvI3X2bsb1UThZnM
         xBLbLqnoZGh6/1QIetqAD3N8+IlfzPAm8iY8rstrS2M5aCntQNL/zIZMyelFuOV0oDF6
         7p1w==
X-Gm-Message-State: AOAM531mXHcyKMSw7mU4xFLEDQEnYNIlta04q/PWqm96PQWagKr7o+k9
        SKN3lNQ6On7mCnc4DuO7sdCngFAT9n5ZvbTj/VMuNUAZiYUMSCrf6rUC1WVA4JfmL/Qjcu6e5le
        7wqmfZINXtjvs
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr5178746edx.76.1616090751811;
        Thu, 18 Mar 2021 11:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqqSjbYGjJWtUB2B2KJKUh//doS8F2HuRxswNQ5R59+pULlSEFiMiIKjm8fFkQY7ir6bK24g==
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr5178729edx.76.1616090751630;
        Thu, 18 Mar 2021 11:05:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k9sm2788266edn.68.2021.03.18.11.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:05:51 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-3-vkuznets@redhat.com>
 <20210318170208.GB36190@fuller.cnet> <20210318180446.GA41953@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5634f6c9-bee9-ae07-c8ce-8e79bd2bd1a7@redhat.com>
Date:   Thu, 18 Mar 2021 19:05:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318180446.GA41953@fuller.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 19:04, Marcelo Tosatti wrote:
>>
>> Not clear why this is necessary, if the choice was to not touch TSC page
>> at all, when invariant TSC is supported on the host...
> 	
> 	s/invariant TSC/TSC scaling/
> 
>> Ah, OK, this is not for the migration with iTSC on destination case,
>> but any call to kvm_gen_update_masterclock, correct?

Yes, any update can be racy.

Paolo

