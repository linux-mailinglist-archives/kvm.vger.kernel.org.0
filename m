Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B393BD8BD
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhGFOqX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232620AbhGFOqI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:46:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EficMBrK3RjxJdnJuXm2v4N67pBSOaJZzsEPYjWWVIY=;
        b=VmkLjMIKFyjwiKApk7L8B7I3X0OmSkZMSROWirQLeaz6bNH5tD5EVZlOu7ilQp23LeApxh
        AV0CC3+a8nmjFQubocXt8rTEZ+uvDvqCijda1Jg5ARx2pdVo5e4Wz93KuD6nv3QZ5JfqMd
        RfnNca/972JPXlC2Nw4ajG7hXREy00o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-nL9nA2U4N-GxcIpwVjSrUQ-1; Tue, 06 Jul 2021 10:43:27 -0400
X-MC-Unique: nL9nA2U4N-GxcIpwVjSrUQ-1
Received: by mail-ej1-f69.google.com with SMTP id u4-20020a1709061244b02904648b302151so5919975eja.17
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EficMBrK3RjxJdnJuXm2v4N67pBSOaJZzsEPYjWWVIY=;
        b=iOTu5rO2WrkuwhMNaaMpAQCbSdMjWyKLEC8xgnG6ozn6sAFHd1/ALc1Hs3nuPw/IFc
         LBOBAK5sUyNQh9e01w+KLR4NtD6KiSfYVoKR1xcKjpztJ2lEocNOmPB9ONu2FVGipJ/k
         8QThOzwQ75Qjg6XYUxif8UxQr1X0DJbAl/TA8ytZAjfvFWNFv0eJK9Nze/NCUsOUXC3M
         gIf0H/VckUyb9CvvWln7q0mHbLQ+MocxaBt24oEAuhcM+aiMf1IFCBoIWPxo0emFJhAr
         0wpuveTDWLuZUj3nkhzWZW+GaE3WzK/CqyPA8QpORH02i61jsUOS/SvjhpWU47mvwBXh
         UrmQ==
X-Gm-Message-State: AOAM53071FGhMVOvdEIAd8nLXp3GZ3qsmsvOvDivnTus2piFWyvFip/j
        TOjbRSF4YRarqsA9MjFrIVbU6o9HrGvVz6aV/t4Y0R9tGeeLDR++gSU+QUzL0z4jim9WaTVLkWY
        3zMp8JNzDLA/V
X-Received: by 2002:aa7:c38d:: with SMTP id k13mr1191947edq.178.1625582606513;
        Tue, 06 Jul 2021 07:43:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+uS6Tyn+IHvNxVFSFYvW5fgVnHf3+DF7oR5Td6gdpU6WnmzhBr3jYTHljIwwm1QPlRSm2lw==
X-Received: by 2002:aa7:c38d:: with SMTP id k13mr1191926edq.178.1625582606359;
        Tue, 06 Jul 2021 07:43:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i11sm7264840edu.97.2021.07.06.07.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:43:25 -0700 (PDT)
Subject: Re: [RFC PATCH v2 55/69] KVM: VMX: Add 'main.c' to wrap VMX and TDX
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kernel test robot <lkp@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <52e7bb9f6bd27dc56880d81e232270679ffee601.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b1edf62-fce8-f628-b482-021f99004f38@redhat.com>
Date:   Tue, 6 Jul 2021 16:43:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <52e7bb9f6bd27dc56880d81e232270679ffee601.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> +#include "vmx.c"

What makes it particularly hard to have this as a separate .o file 
rather than an #include?

Paolo

