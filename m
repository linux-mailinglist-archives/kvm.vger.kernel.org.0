Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58D9483FF5
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiADKcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbiADKcZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 05:32:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641292344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zWo3BENemYvU6QxIXpgVFfuF4IMDHBMI9OEI2D1wAjU=;
        b=d57wS/Dm/zJYRqY2bj8BNwyWriRbLEsLXtBZMv1SaO5N/3Fc9zm/id2RlnYWw82v5/783r
        7A3ekkAyGk7ETZl50VQrcGPn2sFmseWvo97SpKigaIVVGCdNqhD3/6VLRVPQk/rKYLslE9
        Qzgb3PeTJN1f1Q2S/5pY2Vh+aJqFpWI=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-L-bJpS5RPgaxnnqt3nUKbA-1; Tue, 04 Jan 2022 05:32:21 -0500
X-MC-Unique: L-bJpS5RPgaxnnqt3nUKbA-1
Received: by mail-pg1-f200.google.com with SMTP id p28-20020a63951c000000b0033f7b94305dso19590551pgd.11
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 02:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zWo3BENemYvU6QxIXpgVFfuF4IMDHBMI9OEI2D1wAjU=;
        b=okCpKIVKfnWNXeL31XDYTxLkPKEhZGSGjT4X2JUyf1JGwD1zn7/FI3XV/xqWwwGc05
         loDpGun8GDMKe7vRRzlEL3z0oTXTg76uTs7BUZIS0LPIIuoNQNIK1I6a3yw4mTXzOgvK
         ilSnhQipdGk1oDMso/62y8nNF1ZJ/2ENaZ6O/OcgRMDA2ekDE7HUgsrrt5r8gfvTWUXN
         ka5Ah28Pn9GpaCODIeWfUAVpRuxBV4NmRxAhrTfLCN+Pn+QuUOhnqAUomIjPBtreF1n0
         hbg03wunO81D3JmczSXQxQ/WXemmsftgOEONl/aBjhAMgoWmuwuz9ZntuGkr1Q4cnQEy
         8h8g==
X-Gm-Message-State: AOAM530J1r4CMN7FkfQDEA0lReWl67nJwWtZzB/BUDh8Ae1K5yac/WsV
        01GhX7DZODOXHFDQfJBBpXmFQQpZ0qzcZ/5cf3o51soWy+rYDDNTARyf3pYth5V7Gp7gvh+5SNX
        NUWV3Tj0DhyJU
X-Received: by 2002:a17:902:8a94:b0:149:218c:b0f9 with SMTP id p20-20020a1709028a9400b00149218cb0f9mr48536071plo.37.1641292340350;
        Tue, 04 Jan 2022 02:32:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZKN/cKWujA++exo+hQ4/Azh00TJoaIUFYCol86WUWXn2+EQcxOowjxKHblOunuZFyM9qiDg==
X-Received: by 2002:a17:902:8a94:b0:149:218c:b0f9 with SMTP id p20-20020a1709028a9400b00149218cb0f9mr48536059plo.37.1641292340122;
        Tue, 04 Jan 2022 02:32:20 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id j8sm43173840pfc.11.2022.01.04.02.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:32:19 -0800 (PST)
Date:   Tue, 4 Jan 2022 18:32:11 +0800
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
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
Message-ID: <YdQiK2fbOfkQ77ku@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-5-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:09PM +0000, David Matlack wrote:
> +/*
> + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> + * spte pointing to the provided page table.
> + *
> + * @kvm: kvm instance
> + * @iter: a tdp_iter instance currently on the SPTE that should be set
> + * @sp: The new TDP page table to install.
> + * @account_nx: True if this page table is being installed to split a
> + *              non-executable huge page.
> + *
> + * Returns: True if the new page table was installed. False if spte being
> + *          replaced changed, causing the atomic compare-exchange to fail.
> + *          If this function returns false the sp will be freed before

s/will/will not/?

> + *          returning.
> + */

-- 
Peter Xu

