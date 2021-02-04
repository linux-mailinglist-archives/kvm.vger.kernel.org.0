Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A322E30EE5A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhBDIaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhBDIaK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 03:30:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612427324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P2oFYh6GVLYKdkPoje25sIawi2slxCLU7zLus+5oLCk=;
        b=h/pYbo9iOuvSXS19SC+X1Zle9Ei9rhi2l4rmmoqzlggMhlhPqY/Lin7sgMX/xrabT7UZhz
        NJuJIaPzqmoELA1DDRnHA+QsZkiYE1Zllm9+SR6V0Nyi3ovS667gIpnwjdUldZ6jMTUJVH
        5JpTFLpo596Aa5eLGT/T1kyCm4HuL6Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-xD-NKaPLPy-5fNq9lr7znA-1; Thu, 04 Feb 2021 03:28:42 -0500
X-MC-Unique: xD-NKaPLPy-5fNq9lr7znA-1
Received: by mail-ed1-f69.google.com with SMTP id bd22so2268065edb.4
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 00:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P2oFYh6GVLYKdkPoje25sIawi2slxCLU7zLus+5oLCk=;
        b=sK+FlKDjnXKVPlDlyoRXTLRocX4nYPspsWp0ypSP30ohNhqTtvBYu7ghWNJ9bSOJow
         KGoVQQr7ZXqYk+CMXbO1phnCYGkVKjQe/oRRxpk60U1ezi+oZ81wBRfPatUEnTAk6ujq
         J6dbF5Mn6DWr2FesiDaGlUv++BJvErUqkAkgUFXtD3Ji4yJnONyfAdWFBLfyEEP3nGGt
         YYBvIZ4I2SSAa4JRBiF1Zdo4OAGyW9nqLFridnmqa4hfXTbrYzb+2qo+MWgoy/7uB20L
         zOcHaeqW2q/ofUd4gtPGU6aFdv5lZppNcWqaS3DXSHNjtwvVDSfUCvp4BhNdqnFX33l4
         vwhQ==
X-Gm-Message-State: AOAM530syV+BS/KjQ2KVfmJUgPopNQQJ8cE6TaxCFvYR/QONN07Q0Dw5
        QG8KgBjzE/3JUYM2CEJmtYvXZak0FvcL0S20BC9NrIQW978KM0JTc8LbwJaK77U5s4B5ou1ULDy
        kl/bRSslxORTF
X-Received: by 2002:a17:906:36cc:: with SMTP id b12mr4960398ejc.323.1612427321478;
        Thu, 04 Feb 2021 00:28:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhUozLKCqWBce20CvYC68TLIJHGPCCMCYWvHS3x3dpV/ZT5Q1tLgy0cJnAg7GfHz3Ml5fH/g==
X-Received: by 2002:a17:906:36cc:: with SMTP id b12mr4960379ejc.323.1612427321081;
        Thu, 04 Feb 2021 00:28:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y20sm1999655edc.84.2021.02.04.00.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 00:28:40 -0800 (PST)
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com> <YBsZwvwhshw+s7yQ@google.com>
 <20210204072200.GA10094@local-michael-cet-test>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d41eaeaa-4470-33a5-0d18-cdcb4b180197@redhat.com>
Date:   Thu, 4 Feb 2021 09:28:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210204072200.GA10094@local-michael-cet-test>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 08:22, Yang Weijiang wrote:
> Thanks Sean for catching this!
> 
> Hi, Paolo,
> Do I need to send another version to include Sean's change?

No, it's okay.

Paolo

