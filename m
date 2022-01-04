Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBDE483FA9
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiADKNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:13:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229486AbiADKNb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 05:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641291210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O0NO646f6vb+Q81VHaesj9qilMxmyVNYrelWxrsDwj4=;
        b=CYYclUVDeViDEAks7dSMe/CFeAN87L6QhB7+27cB6be/oW6hWEe855QL744/tu+94e8XAJ
        xflFdAtpbhmB5ws5MTk5E+IFIH+VDU6ZRD4tX9xfz/5IRvqVb+Q80nOA5F6Phq22kMgusD
        zcRvYDImKULv6gGCiA9qOmhdbVyXMj0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-V75PPaZAObuuMfCK63sbTQ-1; Tue, 04 Jan 2022 05:13:29 -0500
X-MC-Unique: V75PPaZAObuuMfCK63sbTQ-1
Received: by mail-pf1-f199.google.com with SMTP id j125-20020a62c583000000b004baed10680bso18254795pfg.2
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 02:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O0NO646f6vb+Q81VHaesj9qilMxmyVNYrelWxrsDwj4=;
        b=yrb/TTY/YKRlazZ0ig1MsU7c1d7lF8eNMEntwOhBnHMaj43Ld3GYVLQF9YiYs2bLSA
         cFijCZs1aXqwW5E0qt7uJPVb+arQA3zRQ87jqeTxIfaHApTQPUTnjNzyuhPJqsAxYm5b
         xeSZGSBOXToyIii6J4Z6nG63b23aJDPOw3gmQ30bjJhJBcyiv4ldYEyCZ3dU90T5g7GF
         zOc3WB4vS87gSt6K6JlEcAKNx0AYWodTjHR6oUwSJ7qvwHnR2RtnbdvR3RdcP/mA1FUV
         0EBaWziABHcbIQkgTIJBggIPgEo79lHllxmSA+2tNknVO41T7fbhED3BvQseFYhmvGHz
         GoVA==
X-Gm-Message-State: AOAM5318jiyaY4GDYZBbffotGqLv9jxJsiuk8bl31hVnmT48fChOe1Yw
        wqxPIdvpcOwHhaBCZLr/w3jHI5qBW2XMWFa2nltDdh1wQzQY8JfcMl1xcXXXtv7l7QXbQkkd+YO
        GxQFJ2on04PVz
X-Received: by 2002:a17:90b:2249:: with SMTP id hk9mr58261253pjb.246.1641291208799;
        Tue, 04 Jan 2022 02:13:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPRZruWyUokSwVNJizpHTYEDSB1tgyajcT35vv7vqpnsOVcloxEjR7RY9oLHYNDzIshcDToQ==
X-Received: by 2002:a17:90b:2249:: with SMTP id hk9mr58261225pjb.246.1641291208595;
        Tue, 04 Jan 2022 02:13:28 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id 204sm23016824pfy.207.2022.01.04.02.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:13:28 -0800 (PST)
Date:   Tue, 4 Jan 2022 18:13:19 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 03/13] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
Message-ID: <YdQdv5lAWsJA1/EA@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:08PM +0000, David Matlack wrote:
> @@ -985,6 +992,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			 * path below.
>  			 */
>  			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +

Useless empty line?

Other than that:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

