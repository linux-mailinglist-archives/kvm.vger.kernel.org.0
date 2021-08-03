Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D323DE8C1
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhHCIro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:47:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234579AbhHCIrk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627980449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xl6rvqXkmbnAF6T6P/0zNyDHP6RPIaj9Wql4qdg9RG8=;
        b=Q4+KIbqw1zJocWzJE9QHxsdXzaFvqINSsFj4up5is3Pvz/sinYc3WcEq7B7sct4rO/AnSg
        usBNyHUIzXkOukA6tWc5ZSk3gZWUbxh+svF+M9C7nHX/zJWtbLRauMzeUpOcBvWcvHzE4M
        R5E8ndwU5Ab27sWYeObVqzB+5c2hB+w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-51Mx0vT0PbqIQvsR2bhAMA-1; Tue, 03 Aug 2021 04:47:28 -0400
X-MC-Unique: 51Mx0vT0PbqIQvsR2bhAMA-1
Received: by mail-ej1-f71.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so4649489eje.3
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 01:47:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xl6rvqXkmbnAF6T6P/0zNyDHP6RPIaj9Wql4qdg9RG8=;
        b=KXDriFWlHmb5C32zYRorkoE854USAMQMBlbz4RVkSKAyhB7moNJEld211YesMsf0+J
         9sOdLLRJfcWw2Asx11Fupqw6GwJ+cEV/1KzMDc/lc9cx65YuzV//K4ioipYjuapxJxDe
         b84wQ2GB2bQHu4FneUijqXvPMug20RwN8/4wIy0llOiOSas6xLObNz8Ui+7V9W7txWwE
         cAdKqrRoZL9Wpr37vw7p6flTcr16N5L3pTZT+wGLWM978rNjMMlVdlg5aFHtH9TIfKbW
         TtzjS7dQT6V4F7jcwOnNqG5LiAW+4TkT0qvK275umP0rSyArL8VI1fDGqImXyf31l117
         cmKA==
X-Gm-Message-State: AOAM532ITTiIT/WjNt/bcZKYBsLrFrtIJhe/Q01Vlc6LedUgDXEXBEQ7
        Ejet7G2f/8T5v3wUJ66D1tMT0oHhWP6da0FRnfzPL6RGg8Mra3eOsgyXf9YbFgSoER/rg+MavOd
        QAWUzk0VAhTXi
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr24561048edt.194.1627980447179;
        Tue, 03 Aug 2021 01:47:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu/a0NsuOruUYw+Qh/7giQPJS3e27Uwbx5YV+ZBHGXU82ConO7DZlOMQzEhjHHp5AIyWs0Ow==
X-Received: by 2002:aa7:cb19:: with SMTP id s25mr24561034edt.194.1627980447025;
        Tue, 03 Aug 2021 01:47:27 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id j23sm7636816eds.21.2021.08.03.01.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 01:47:26 -0700 (PDT)
Subject: Re: [PATCH v3 09/12] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
 <20210802183329.2309921-10-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <01449e47-8c9c-7582-d8e9-783c0933f298@redhat.com>
Date:   Tue, 3 Aug 2021 10:47:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802183329.2309921-10-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 20:33, Maxim Levitsky wrote:
> Maxim:
>     - always set HV_DEPRECATING_AEOI_RECOMMENDED in kvm_get_hv_cpuid,
>       since this feature can be used regardless of AVIC

I tend to agree here.  While AutoEOI does have a minor performance 
improvement, I suspect that APICv will be available in most cases where 
Windows guest performance matters to that point.

Paolo

