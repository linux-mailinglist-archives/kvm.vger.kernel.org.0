Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB1373223
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhEDV6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232984AbhEDV6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 17:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620165454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAmBiJFvPA+As7Gl+azsy2uCjLljzEnBHmbNc9z7r40=;
        b=JbEXfuSS/WQd3N0pq+be7bs9mweuATlLoG0L6LQEg5ahGmLNMhWCZfcfzWlAxlMYU/Mt31
        nhlmvTSt/PEvfbQVwzeqNJZqj0stkTYbZ37Swyreb16Gqys1TKC3Z9+s81Vy2htb4qHwFB
        P/iiHmVKfY5d2MAiETJa4FWEGo9DFQc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-IkErIXhXO32MJujMGnMIvA-1; Tue, 04 May 2021 17:57:30 -0400
X-MC-Unique: IkErIXhXO32MJujMGnMIvA-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso7065941edb.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 14:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wAmBiJFvPA+As7Gl+azsy2uCjLljzEnBHmbNc9z7r40=;
        b=OO26M42uNICuMLXm9bsWqml52Kyy2wk8WzxutGwcKdfpwoZ5u4W07aHQG6qlZ5KhUk
         vTldppP2QplVclLyTAEj2SWUVqaBFsJmyQ/+77dcEmnlWpscTOxlsoG9cVXvpYP/X+Ol
         z+8/tcmMVzDAsZRcFnIRqjf5SDHEoIp+28mpdqO5qwGf3Hkbb/NnDfpDhagKKlY/Mxs1
         MpjRwpOkXLBY5i7IWunZPgvLTMPaJbJtlxz26fnp+lqORXcf9N7kGLcxqs1z+SkBiNbB
         bBnU5ZeQMptgjbkYPLRoSuRavr2U0D9P/6Mg9ZzoOISz5Q2uPFrz2CI6l9oIAAT8DDw+
         vj8Q==
X-Gm-Message-State: AOAM532H6zh4wglOyNBlgpwHebj17jmypI+ZNfx6g6rlCWMmcUuM28Ow
        /DH0zesBZ9uzb9L0Ern0TyJekR4qxRNh6gGlE+LpeUcVONwfBfl773SxoH6S2/vC+m+zKep7bnM
        0tLZl6RMtGm96
X-Received: by 2002:aa7:d996:: with SMTP id u22mr28550213eds.342.1620165449233;
        Tue, 04 May 2021 14:57:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvbNuFIfXZyEjH+O41yqnrvofU1K0RElRQQjLDG628sLCwRQW4kMqQwRj1+fwZgsjtwikdiA==
X-Received: by 2002:aa7:d996:: with SMTP id u22mr28550195eds.342.1620165449012;
        Tue, 04 May 2021 14:57:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id e5sm2051519ejq.85.2021.05.04.14.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 14:57:28 -0700 (PDT)
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
Date:   Tue, 4 May 2021 23:57:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJHCadSIQ/cK/RAw@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 23:53, Sean Christopherson wrote:
>> Does the right thing happen here if the vCPU is in guest mode when
>> userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
>> off?
> I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
> you specifically mean running in L2?
> 

Guest mode should mean L2.

(I wonder if we should have a capability that says "KVM_SET_CPUID2 can 
only be called prior to KVM_RUN").

Paolo

