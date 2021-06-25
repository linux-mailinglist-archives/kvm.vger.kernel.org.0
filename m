Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834F23B419F
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhFYK2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231446AbhFYK2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 06:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624616776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vMw5C8dl564umFyPWG1xHixg+zwgl7dZDUVZw4IaqoY=;
        b=i2/I1G+YqcQqtT4jFfTJpv0z4vzbj8lXK7sB4E8bEXESZtdS97gJAhKGOziUS5h35kke2c
        T5TLBpQrE6Xp9xXHLJJq3l12qqo2ax7Etcv0Ixs3qvVP3WcPvf/ZaIFoLBKibtHc6f515U
        ASt1vO5gmnYqW1YNGQ3MPlbrjawaRTo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-mvaZTOo5PQqB_Bq1gS1FkA-1; Fri, 25 Jun 2021 06:26:13 -0400
X-MC-Unique: mvaZTOo5PQqB_Bq1gS1FkA-1
Received: by mail-ej1-f69.google.com with SMTP id f8-20020a1709064dc8b02904996ccd94c0so2951442ejw.9
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 03:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vMw5C8dl564umFyPWG1xHixg+zwgl7dZDUVZw4IaqoY=;
        b=GVrBeaUCMJHka4aOdT5yGLNE1CP2HUEWUaho+9ON8/oNv3o7cUyrosATp5iGCPvdkS
         E3W1ioqCK15KnGBRsHN8v1KirQEqdSgEQpbaT2iD272UUI5U5ZLnr1Nryse0JY3VEyXX
         l2ex8KYOKDtj4boKv8mE6dz4AOYQ+6HzYenc3pYuyh7uhvUypj0EQ1bo8lDO9dEkPMPh
         ojd4KO59kJPiHkd/kGdesgG9rFzCdQrFR7zj5swXIqRW2VYePQtpeanKIWfUesXECfhO
         RyW9vPMQDFeeoqWmiSO2J/J4E5CxIi4SxUw5Hrz5tg43GBDQHBDON3FCvCDgzJHenM5M
         jOnA==
X-Gm-Message-State: AOAM5305ltN7X0ypEQdM+zMRuQnX5L6d1fi34KYi6eCoS9sbAgSTW+aW
        nwjWxNi5dRD9faEhUVC+6xS/ChmHuw7RUK2ktcQHmW2bYZGaFzbp2x8s950MfoLpFVYrEfYXTVf
        V1lzdwH8d4Atu
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr9965436ejj.16.1624616772008;
        Fri, 25 Jun 2021 03:26:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybqrlmR2ywwW6ezLVClI1uPt0HAzsewHMFFo7eLTt/eRECW+NExFJWG7ffDg16fJX4AkYLVA==
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr9965413ejj.16.1624616771784;
        Fri, 25 Jun 2021 03:26:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e8sm2504896ejl.74.2021.06.25.03.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 03:26:11 -0700 (PDT)
Subject: Re: [PATCH 09/54] KVM: x86/mmu: Unconditionally zap unsync SPs when
 creating >4k SP at GFN
To:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-10-seanjc@google.com>
 <20210625095106.mvex6n23lsnnsowe@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb6885fa-4ad3-8da4-8d8e-ebfee30ad159@redhat.com>
Date:   Fri, 25 Jun 2021 12:26:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625095106.mvex6n23lsnnsowe@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 11:51, Yu Zhang wrote:
> While reading the sync pages code, I just realized that patch
> https://lkml.org/lkml/2021/2/9/212 has not be merged in upstream(
> though it is irrelevant to this one). May I ask the reason? Thanks!

I hadn't noticed it, thanks for reminding me.

Paolo

