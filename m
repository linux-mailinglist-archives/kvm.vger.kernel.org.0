Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B963D5AB9
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGZNKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:10:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbhGZNKe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 09:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627307462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDxOzigTUv9r7tnNN2mP+iBp5vRuhcPhvKU6DPNX0fQ=;
        b=U/Motr5uuoUj7y8jYR2owdZAqTFVMtRMP/z5QmK+RGRZttz8cJpZ2v0LeJNhVu7LKgVppW
        eHVX40tEhHy0B25jhKwe9ILHhm1cJkDFFRB69zb8VzaTN2AKEQHkLnZ9qZkgXpavN5YqOD
        2lK5SucNYXCRASSEQdJfUQ+/RfgwJBQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-hlZGGa7RN3W8XZeNXlHG0A-1; Mon, 26 Jul 2021 09:51:01 -0400
X-MC-Unique: hlZGGa7RN3W8XZeNXlHG0A-1
Received: by mail-ed1-f72.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso1415252edb.8
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 06:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XDxOzigTUv9r7tnNN2mP+iBp5vRuhcPhvKU6DPNX0fQ=;
        b=YSrNOEDoaeFbJ2/sPczsLPwtAIxNiUpSBueYwcBWPHpeSvr3uR0Rx7xrfQqGHrSR7C
         KQaR5Tsz7nJaoWDCY4ZFe76A6Ac+ekP37TV5i0tTWerfYSemONEADDiNlI7TEJ2G2oxb
         E+x+dwUR+ZCXVAA62V+A9lVMrknCB9P0Zyy4Ggnzb2wQGpzpHM6IchZ3eUR9BpSxEjPG
         YrpE/2qXBCKIJIxgkBEwVw1oW0raFbZFV8QXsiKZM6RNK+mNxMB95mz4Si49omXfPdlD
         jSwFcN9Ou5WbOb5zaHkei13DCfsddxZck3EuNwXJ8s+iMaH8vxhoe28FU2ANoJH4WQSg
         +shw==
X-Gm-Message-State: AOAM532prjd+U+N+OgEcNtLL3aksHRi5jrq27hX5Gx1ee9DmCFd4eNSQ
        ET67WihFb63T8ICZHWXNOwMF+RKD6WqEWslBMcdo/kkRvDL7DYYayJxxIcowXxh08L/JYMB5qVD
        guLHnsXcL7pC7
X-Received: by 2002:aa7:db95:: with SMTP id u21mr21273182edt.152.1627307460333;
        Mon, 26 Jul 2021 06:51:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQcHOssFE/+YAatkAVqYQKA0MI7HHWVA/dWkRx4b7+t9QrdutlguhjbaKEtqMC2F+odLneGQ==
X-Received: by 2002:aa7:db95:: with SMTP id u21mr21273170edt.152.1627307460191;
        Mon, 26 Jul 2021 06:51:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w10sm14212172ejb.85.2021.07.26.06.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:50:59 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] KVM: x86/mmu: Fast page fault support for the TDP
 MMU
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210713220957.3493520-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d30ba4b6-2415-4386-6036-9ee2be8a97c0@redhat.com>
Date:   Mon, 26 Jul 2021 15:50:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713220957.3493520-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/07/21 00:09, David Matlack wrote:
> This patch series adds support for the TDP MMU in the fast_page_fault
> path, which enables certain write-protection and access tracking faults
> to be handled without taking the KVM MMU lock. This series brings the
> performance of these faults up to par with the legacy MMU.

Queued, thanks.

Paolo

