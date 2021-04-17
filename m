Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBA1362FF7
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhDQMnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236226AbhDQMnT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6Mb+PkPBBrnApLNLzo6vlvHUrWkry8FXhN/7p3cu+A=;
        b=IBGkRIwZphjkbI/mk+yR0kPID1XFQMLRzNBm1hQrxIoDb4CElmutR2tAiZY9EJLT0+HFkw
        N3VRG2gCuzYU0MbPcpmxko9s93wlPllIVwIenm5JsUqsQCJ/G/hCGzucNo9X7XOT+E6fi1
        D5WZreWAKukFDl+QpM3U8s/EWBvCFPk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-jGEBf_DHNDaHLwHSolv4ww-1; Sat, 17 Apr 2021 08:42:51 -0400
X-MC-Unique: jGEBf_DHNDaHLwHSolv4ww-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so8585099edd.5
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v6Mb+PkPBBrnApLNLzo6vlvHUrWkry8FXhN/7p3cu+A=;
        b=bVoQcmhyOMU4Xi9GlXKS2QnHZaYzZU6cMtS5hTg4ar/lVUU3T39W+XHkGBw2Go0Kuq
         JE5fP1+MTRGo8oG9Mdz1V5uM8xf3i54G4pbyA3keWBG6C9QAtsb+xyJwWWO+IiKODDV7
         gBm7dTsU193dl4tFSY4ZJetI3VO7o2rWOJSohEmstA54d5J69QSK0cEIHmBzuHqxcUDk
         VSCPFb+b17GD9eyevIy3BQylF8d+OGifNr7VgTRc4v6bv361bmQqO4G65HJXkPovW/Zt
         HyyhvLPGAHB9gQlpK7ZZhPrIC66Dde08FCbxzmmYU8NatrMC+dY+mpEqGtiqIBCK20aN
         zbzA==
X-Gm-Message-State: AOAM531XMqNXsnHMOm+b5s5SIxaMbsNvQorXOq/B2IdgsDh7Gt04TD7M
        JFMEPa4WkxEnUuJ/68Lfy9gf22KyJkTyNl+kjhzfcmaQoV28YtelvMp8zJ/ey328wM7Al1+4Nlq
        MtVGafloKrK9n
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr12538620ejb.195.1618663370349;
        Sat, 17 Apr 2021 05:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/rAGnhUeAhuXmI4Iows5d3uO86rHJLc+07xpKXycm1wPXBa+McxEFaQqCM2U2gMNK5/UkXg==
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr12538594ejb.195.1618663370133;
        Sat, 17 Apr 2021 05:42:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ca1sm8198395edb.76.2021.04.17.05.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:42:49 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] crypto: ccp: Use the stack and common buffer for
 INIT command
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-8-seanjc@google.com>
 <29bd7f5d-ebee-b78e-8ba6-fd8e21ec1dc8@csgroup.eu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a75c54d5-d4af-5d67-ef35-025d3e4a3f51@redhat.com>
Date:   Sat, 17 Apr 2021 14:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <29bd7f5d-ebee-b78e-8ba6-fd8e21ec1dc8@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 07:20, Christophe Leroy wrote:
>>
>> +    struct sev_data_init data;
> 
> struct sev_data_init data = {0, 0, 0, 0};

Having to count the number of items is suboptimal.  The alternative 
could be {} (which however is technically not standard C), {0} (a bit 
mysterious, but it works) and memset.  I kept the latter to avoid 
touching the submitter's patch too much.

Paolo

