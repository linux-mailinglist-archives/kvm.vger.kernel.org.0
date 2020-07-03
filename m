Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2F213E69
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGCRR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 13:17:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726148AbgGCRR2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 13:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593796647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/DSLHDlC0xBmwzi7MVtunbOyv24TPlCbFazyTFY/v4=;
        b=bs8UUSDYU1KuWmXeiUxMBnURTweH+Q+qISNFWX0HH3AAHs8M+nyNa6krm4/JBk0EkjiGht
        JQ6zddAk/NtWKbEUNjxQNji72LEwRc82i1xymynzWMXc6iCBLfw1ggN46EkBaAz2ND/qSH
        zIJL9MdbuUtTUbOhSNdHK3ppqtXewkk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-ggLaKr7dOA2IoNjLZYm3Rg-1; Fri, 03 Jul 2020 13:17:26 -0400
X-MC-Unique: ggLaKr7dOA2IoNjLZYm3Rg-1
Received: by mail-wr1-f70.google.com with SMTP id o12so32212107wrj.23
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 10:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I/DSLHDlC0xBmwzi7MVtunbOyv24TPlCbFazyTFY/v4=;
        b=HMMkC6A90quriFgJfWlfhF2vgrdUs5vFH2D5s1SUtAAThtlhDv0MN3wObqNcng04Fv
         Lvs15XrcAc8PdYhnzk6XVjRQDs62etaafR3oJ7F/svop0kUDjmRz3rywh9PlX1JD0SUt
         A8L1V6TzXmD5NCNcQwcw5KEYOmQ0Z3ZI8G0tGF0bdzxmoVdgO4xcB1gp6gzQzxU9+Grl
         rJ9dlJa221yBN57sy+y6Pxxt75FDI+qe1pvAHfrOOSmB2krS7jnYKV4OqzXphV6lAsR2
         6B0YOwQB8aLLC9vQ1Mr3WqGycsGoUwXsN+KbUxEVE/H/OJY5U+B51wWG+lc3/+2mGQTL
         9GJw==
X-Gm-Message-State: AOAM533yt9EnOXNS9/qzgF4Z+GNd2EcXasJxNaAV99x8jQ02xL6UgDgx
        IAfJkIZ2nW0p2kWGJ9H9on2PoMKdK4Zc7MKsMc5+iMIHCnVKfeAbVHn6xh09Zs+qiYsjMHpTV9y
        HnnJ4tpdu5j33
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr26793166wrx.235.1593796644904;
        Fri, 03 Jul 2020 10:17:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDlvTnY9QVK/gWukbPZBkYBlSyQACwuEDTYux+eC9el9JhN/4lUqd65pH2NTh/iNNAZNsfOg==
X-Received: by 2002:a05:6000:1143:: with SMTP id d3mr26793152wrx.235.1593796644645;
        Fri, 03 Jul 2020 10:17:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id q188sm14195363wma.46.2020.07.03.10.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:17:24 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: x86/mmu: Optimizations for kvm_get_mmu_page()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        Jon Cargille <jcargill@google.com>
References: <20200623194027.23135-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a602e91-91ef-fed6-3d5f-bad46c8d7554@redhat.com>
Date:   Fri, 3 Jul 2020 19:17:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200623194027.23135-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 21:40, Sean Christopherson wrote:
> Avoid multiple hash lookups in kvm_get_mmu_page(), and tweak the cache
> loop to optimize it for TDP.
> 
> Sean Christopherson (2):
>   KVM: x86/mmu: Avoid multiple hash lookups in kvm_get_mmu_page()
>   KVM: x86/mmu: Optimize MMU page cache lookup for fully direct MMUs
> 
>  arch/x86/kvm/mmu/mmu.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 

Queued, thanks.

Paolo

