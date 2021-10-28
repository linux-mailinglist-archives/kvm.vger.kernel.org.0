Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A044C43E5E8
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 18:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJ1QSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 12:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhJ1QSC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 12:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635437735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2L3/3HZIpBhFux5s0Uv8RI5A8Zb4rL17hTwT8Tbd50=;
        b=PpD9emM+nGaaXDs6RWp+C/53DlCRZXXpcvW/ozVyMbWIyi2iCfVX26inOYcx6R0oYXxY55
        ngUMemVnAR575XNavitFZoDknkOq9j52pb9ITTqR4ubHPYysRkrqOz77dTl7m5VIYB8t/K
        xri38Hlq1CFYvpkhfXJVZG7xSEv3bxA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-eqTjLRcFNdedaBf8IyPfZA-1; Thu, 28 Oct 2021 12:15:31 -0400
X-MC-Unique: eqTjLRcFNdedaBf8IyPfZA-1
Received: by mail-ed1-f69.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so6076970edj.21
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 09:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n2L3/3HZIpBhFux5s0Uv8RI5A8Zb4rL17hTwT8Tbd50=;
        b=E0V72TA+Y893ZFxFj24XY6AclrwHRPPhpzpcgMJnWCt/sIWVDu3UOR7Ko9sWxE3VrW
         sdJNTVV4vJVysAQlVmX1ADW6qtN6XmnHStC6w0qhrDGSR/rKZB2bPWyMI0uJDF+/uDIQ
         jlo/bDdNm1+X847BamAfROooGaVIJIMRuunSCF2IJvQDPIsGkbNfjsyuG7v7xVbDn9Qj
         +v2da5r55qq1Sp2wbvSAUgzUmdSctyvcMG9b11x6bVAUzA8eVwDQnhfQOgaFdiVU8g8H
         UbdWLcRFigvMJosi8LKS3cy8nUq0pY+NkYDthEmy9fB97GBG3HIVcSUWa5px7IC2O/J4
         U90Q==
X-Gm-Message-State: AOAM533sZwrx0pDmNCo7WtCiyL3albpzK/gBbuaE07/THVZu9rsd4ePY
        qwsMpOeV4SligY/cKlVDARJMf98n5aPXbRCaqclhj/KoH4x4BP5m4XYuM3BU0zaMA3CiRNL7iRc
        VnF9zoH70OWDj
X-Received: by 2002:a05:6402:35c5:: with SMTP id z5mr7328658edc.388.1635437730089;
        Thu, 28 Oct 2021 09:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTig4NGlW7eErKTBiB+8Xb8YA3r5TvTp2lGuST3FsQnTOsQC6VZ0YNXIbz7BJt7PmkdpNmeg==
X-Received: by 2002:a05:6402:35c5:: with SMTP id z5mr7328626edc.388.1635437729926;
        Thu, 28 Oct 2021 09:15:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qb15sm1621155ejc.108.2021.10.28.09.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 09:15:28 -0700 (PDT)
Message-ID: <460f5c27-4f5c-902e-ae6f-9f127b4637aa@redhat.com>
Date:   Thu, 28 Oct 2021 18:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Take srcu lock in post_kvm_run_save()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, mtosatti <mtosatti@redhat.com>
References: <606aaaf29fca3850a63aa4499826104e77a72346.camel@infradead.org>
 <15750c83-5698-02dd-58f9-784aadde36b9@redhat.com>
 <442c9279d0f4d86f01729757f55d0504c614386f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <442c9279d0f4d86f01729757f55d0504c614386f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/10/21 16:23, David Woodhouse wrote:
>> Queued for 5.15, thanks.
> Thanks.
> 
> Sean, since you actually went ahead and implemented the alternative
> approach along the lines I describe above, I'll let you submit that as
> a subsequent cleanup while keeping the simple version for stable as
> discussed?

Yes, I can also take care of sending it out for review.

Paolo

