Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F3B413952
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhIUSAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:00:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhIUSAC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 14:00:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632247113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQSCv/3qlLsI9Nt/RrJNX5Ec9pj4MuIs81DfXtwhpmo=;
        b=YmGy1YPHXCA0kXFY1/yRLfXUT/UpBALR4NDXpS9wgygqzh+MjCxL1LhnHP+uHvb+hApjwQ
        IBMIwICtVy83tK3gPnSKDGVd/wDnV3TFylJPQPRE8bnhOPXdEjphdJ6ibX5plXWb3ZkrkO
        NX5YZEt7uN7OeauRqcNB96p8vEGHljY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-QfiKXn3uOtuCaWqWKtvMqg-1; Tue, 21 Sep 2021 13:58:32 -0400
X-MC-Unique: QfiKXn3uOtuCaWqWKtvMqg-1
Received: by mail-wr1-f72.google.com with SMTP id i4-20020a5d5224000000b0015b14db14deso9493846wra.23
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQSCv/3qlLsI9Nt/RrJNX5Ec9pj4MuIs81DfXtwhpmo=;
        b=vV0l1CpqZqIyp0kkRlk9xrazFYjGk6Hgs8C4/74tPhPLq83lS4ZG8eZ/vzV0o2KQ0s
         k8q/Xrv10wpwQGN38SBZRNu1ce7WXqskDbEChb802mTDZuW2ufj3atojuk8G3+5D4oED
         LDRd4Zpk4GJRF1nuIty5HEsii219lv5fXEVUy8k7SH82A3Qix1EEZWtUVUrXONAahDTI
         +nSvgB4bvRn/jz9XVz9NIMqpwxoe+lmk4pxTQNqrfBysO8P+Cyi2zTnyrHQlcctlPQcM
         L4I5YXm/kTpsxb1dm+4QPgvWHZFZRVmtUwnLgjC1EzPwZJWJv/PGgvj6xe6hpGuvWA+P
         I5xA==
X-Gm-Message-State: AOAM531MBzl4CXGH+5luawDTja/aYWF5wZ5D0T3zxGeLuPPl90e+fbyb
        HLfCLji6EfmP4HZ5nDlYzLnauNCuQRhBzAl3B+AsYqHDkbb/px7fYveK4w5421EIEnwin4X14qO
        MpIm38/tD3IeK
X-Received: by 2002:adf:fd03:: with SMTP id e3mr36783318wrr.46.1632247110865;
        Tue, 21 Sep 2021 10:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCy/iVs4ic4BpLOr6rEVULg59LoAQO//ya4B4K44daOpQG7Cb13ApHTkpMoXqHg+ZapdiohA==
X-Received: by 2002:adf:fd03:: with SMTP id e3mr36783298wrr.46.1632247110681;
        Tue, 21 Sep 2021 10:58:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y11sm13449644wrg.18.2021.09.21.10.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 10:58:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: fix missing sev_decommission in
 sev_receive_start
To:     Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, John Allen <john.allen@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>
References: <20210912181815.3899316-1-mizhang@google.com>
 <YUC/GzN29dWDVCda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e951cf6b-dac8-776f-1e90-b204712c9618@redhat.com>
Date:   Tue, 21 Sep 2021 19:58:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUC/GzN29dWDVCda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/21 17:26, Sean Christopherson wrote:
> With a cleaned up changelog,
> 
> Reviewed-by: Sean Christopherson<seanjc@google.com>
> 

Done and queued, thanks.

Paolo

