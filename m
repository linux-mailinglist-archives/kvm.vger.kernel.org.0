Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3C363065
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhDQNju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDQNjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618666762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHM7HKI6L6KI7GdsoopUjMZPwFe/oDUGoMfSWD/vPeE=;
        b=QnzjOS7XkhFezXeafbvgOdF8HRCM4UsXzlcZvUAwZJH0VO0a1uaK8ySlnosExuOVjgnWf6
        QMjx2J4V6g5KiZWMrGfXTsq4dtAJzK/yiE9NnW0/LE62ZzOtSmUZqNokgfqhte1qbC4dd3
        RrPfinNmVPD3pZe60FmcUbDivFCbUMs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-135kIvX3P3ifKtl_FW6j6A-1; Sat, 17 Apr 2021 09:39:20 -0400
X-MC-Unique: 135kIvX3P3ifKtl_FW6j6A-1
Received: by mail-ed1-f71.google.com with SMTP id f1-20020a0564021941b02903850806bb32so2706317edz.9
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xHM7HKI6L6KI7GdsoopUjMZPwFe/oDUGoMfSWD/vPeE=;
        b=Y+Dmhm7PtjuoQ1xADWUTgzGj7hJGHBql247pRic6NIsxXStLnfpZDrgQxrLDSj8/GN
         tc7e2oF8cBvzkkym1I0D7WFL4lU/AQHVnuqqIx4OqUwg8mFi7N3kG3f3M1+lV9EB424p
         hO8eWXT/LAIgVYzx9EMNEh0S5VnWCdIWpWdwEUFnpadKklDrp88+okgOyGX/U9fc+EgA
         B/riWjgUY3mMZElxz3Qg/BgMoeECYL+6STdbwR9B2unlti/7HcO5CXcLYOT/Iwk2ybEb
         wxLl3sToloeYhhQKsZrUX0s+sNZTHdUg6a7gLQWbfQX+6QTQ/SVRpfSaeJgJrN8MvhId
         yphg==
X-Gm-Message-State: AOAM530+gvDlwEYosLSFy6DjKqhlNR6jZD1UKA/XuaGgUXYsVt+0O8Ql
        kIusfP58TKnCwqSAD0aJ7ij1RPRUWxrxX1ajcLt/OZlN5p/VLxtQ9tgGcG8JWOjEQ6IAa1UMpjY
        JeePba6VFg3pS
X-Received: by 2002:a17:907:629e:: with SMTP id nd30mr13050802ejc.407.1618666759158;
        Sat, 17 Apr 2021 06:39:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCKJijVAFcWGcPxk6FDkmBwSIVPf1Q0S/aSWmk61bF7uyBTJTAgS4M7uMCyqAGsUk78Z8gMQ==
X-Received: by 2002:a17:907:629e:: with SMTP id nd30mr13050790ejc.407.1618666759024;
        Sat, 17 Apr 2021 06:39:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bw14sm6339207ejb.89.2021.04.17.06.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:39:18 -0700 (PDT)
Subject: Re: [PATCH v5 03/11] KVM: x86: Add support for reverse CPUID lookup
 of scattered features
To:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <16cad8d00475f67867fb36701fc7fb7c1ec86ce1.1618196135.git.kai.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0399df7d-862e-1d22-41dd-82b804c97f4c@redhat.com>
Date:   Sat, 17 Apr 2021 15:39:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <16cad8d00475f67867fb36701fc7fb7c1ec86ce1.1618196135.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/04/21 06:21, Kai Huang wrote:
> +static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)

Just a small nit, I renamed this to kvm_cpu_cap_init_scattered.

Paolo

