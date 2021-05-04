Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F348137271A
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhEDIWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhEDIWr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 04:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620116512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhadwQE+exPzSFPPwlRcTnkbJ2oOmGADkphoNgd5n4k=;
        b=EYdBkQKrVdyS8Klmzyk3PmkuXjFAddeaBW8HKFAhCztXkunLtUQMI0DzukbaRj4O1dco73
        6AU5hrIGWn1NMo7ixLC2lD/FWy3pgYiNlLrNFVX2y781DwQ9c/Li/riadW+oqmpUDSjKFd
        y/eXSj/y0nZfuKOX/trR78oEeYUcBHQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-tKZnj3kqOFKpNgoO8tiJlQ-1; Tue, 04 May 2021 04:21:50 -0400
X-MC-Unique: tKZnj3kqOFKpNgoO8tiJlQ-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a0564023591b02903886c26ada4so6044724edc.5
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 01:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GhadwQE+exPzSFPPwlRcTnkbJ2oOmGADkphoNgd5n4k=;
        b=Pza2JVVL04xq8C270PFEYKjwKZ56xkSC3djiL7xiz9mrkB0b7df939Y3J6ThlCr6Tf
         pu3akDwjVLykbgENkAq0+3yJeoAcpO4zvVGjObCg+4oPcv+Z/f7s8x1nPK2MTVkYRjs8
         xS4DwzG+Kb0VlJEUp1uLCs4jjlKI3hLGHfYKFCFJ1/wK3NPLhbeYNIB9uwK5cBJNymzj
         ZtE1zdRzI4l4GtGUoJ4FqOlKKvV3Jp6nPqRqOPdfLUFgKDnHXD81q8jRPWqIBZRKZ5gB
         a/KPjWUSqVgunGDyPob55tbzUBKtywKq1hWdkJXfqihL2qVYEZ/bIQG2ome1Kfv0feQ/
         RRbQ==
X-Gm-Message-State: AOAM531exM4jUdM+Z0sK0hALyjsV87CIgEMlAGSHwrmnhshz8mb3t/cE
        XzL1Flk9zDSAZBFsfLaIbk+CXA9Xhuz+eCL0FyrEZpCXnQMhgvL5MeBeUyq2vRH8EARqnape7hv
        qCQS6peh3W5cC
X-Received: by 2002:aa7:c30c:: with SMTP id l12mr24469550edq.217.1620116509418;
        Tue, 04 May 2021 01:21:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaVeUuxtPavqNx+CwxlQ0X1+K+Hn5qr9xpndSgFIyEPL3es3Is06zysstjxyTbN1yZ/OOt8A==
X-Received: by 2002:aa7:c30c:: with SMTP id l12mr24469533edq.217.1620116509277;
        Tue, 04 May 2021 01:21:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ch30sm13593625edb.92.2021.05.04.01.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 01:21:48 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
To:     "Denis V. Lunev" <den@openvz.org>,
        Sean Christopherson <seanjc@google.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210428172729.3551-1-valeriy.vdovin@virtuozzo.com>
 <YIoFFl72VSeuhCRt@google.com>
 <0d68dbc3-8462-7763-fbad-f3b895fcf6e6@redhat.com>
 <be7eedf7-03a2-f998-079d-b18101b8b187@openvz.org>
 <63e54361-0018-ad3b-fb2b-e5dba6a0f221@redhat.com>
 <048b3f3a-379d-cff3-20b6-fc74dd12a98f@openvz.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <514b5373-c07b-ad34-5fba-f8850faf6d68@redhat.com>
Date:   Tue, 4 May 2021 10:21:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <048b3f3a-379d-cff3-20b6-fc74dd12a98f@openvz.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 10:15, Denis V. Lunev wrote:
> As far as I understand only some testing within kernel now.
> Though we have plans to expose it for QAPI as the series
> in QEMU
>    [PATCH 1/2] qapi: fix error handling for x-vz-query-cpu-model-cpuid
>    [PATCH 2/2] qapi: blacklisted x-vz-query-cpu-model-cpuid in tests
> is not coming in a good way.
> The idea was to avoid manual code rework in QEMU and
> expose collected model at least for debug.

KVM_GET_CPUID2 as a VM ioctl cannot expose the whole truth about CPUID 
either, since it doesn't handle the TSX_CTRL_CPUID_CLEAR bit.  Given 
that QEMU doesn't need KVM_GET_CPUID2; it only needs to save whatever it 
passed to KVM_SET_CPUID2.

Paolo

