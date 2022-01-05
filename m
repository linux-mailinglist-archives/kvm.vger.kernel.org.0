Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87A2484EE2
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 08:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiAEHwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 02:52:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbiAEHv7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 02:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641369118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=31c6KNlElhO9X0pIFn3xGT8Al5x6oG7XEsYUb6vuH9g=;
        b=IZR5uL1H0xkVXFeeprGNsF6T4xQSIFRqjQxOZGkR00z1lgBwToG/BFtAmY377OJLIaCOqA
        w8x2JxzT/O73G7Bii9oCezwhE67hmvtCtKIl2AM36Y24qv5X/EbKR4oKn0lPpvjv0G1p+q
        VuMvrBFdik8a0l9otbh+LaWPv7IBxW0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-7shaRR9BMN2phHFR9Emr3g-1; Wed, 05 Jan 2022 02:51:57 -0500
X-MC-Unique: 7shaRR9BMN2phHFR9Emr3g-1
Received: by mail-pl1-f200.google.com with SMTP id i6-20020a170902c28600b00149b3c82d16so1453247pld.12
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 23:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=31c6KNlElhO9X0pIFn3xGT8Al5x6oG7XEsYUb6vuH9g=;
        b=xMVPvEslQj+w72lwjuT2COn2bOc9qEXGIg73cV2nbrwZcPsFuBb0bwzp6D8SKrrQ5o
         6jOo8Yj1akVnK3cL+WxlOXa2Eflt9RFRoIyCtpAxN9qoBqXKKwZz4gAtWIa5fLyE6f1e
         eFRidkr+5YgybqdfeHLe4L+Q/4TrTe2/2WRYCj5GsfUZLFpy/uMeVklaumnSS3J57kvr
         YW8pZEwczZROaArGO2lw+c7ef0GKZXsidLRwUjRdsFeFCsk5aLk3sBwoVI8joBqn7aB3
         C87dY1mnXs0wJ7ePwMEpdi3b+yCzFPv7LtI2fNdriDBXFavWZZAY2Ye/iw8xeiGnfzay
         k1VQ==
X-Gm-Message-State: AOAM530fAWX6G5QE/SCirP3CuzEChtXrq0HYAIM0g+HcPxFBcDIeWPj2
        aiXcsk0JoCAxFtlima7RBZmYz0iYzR9F3T6fOT9pnckKSjbZzjyX1aKhwmozhBmXp1MWQ90072+
        35CEynhxEIwLP
X-Received: by 2002:a17:902:f68b:b0:148:a923:6d3 with SMTP id l11-20020a170902f68b00b00148a92306d3mr51936948plg.97.1641369116135;
        Tue, 04 Jan 2022 23:51:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzyvEH7jntUubZ8vJgpQPA52I3MS7VLIcKgQWBaxgFPVwEq4CGNvSEdfUdKek7pCXoDN6Ltyg==
X-Received: by 2002:a17:902:f68b:b0:148:a923:6d3 with SMTP id l11-20020a170902f68b00b00148a92306d3mr51936934plg.97.1641369115925;
        Tue, 04 Jan 2022 23:51:55 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id lw5sm1741828pjb.13.2022.01.04.23.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 23:51:55 -0800 (PST)
Date:   Wed, 5 Jan 2022 15:51:48 +0800
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
Subject: Re: [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page
 initialization
Message-ID: <YdVOFJhEjM3Q8q2B@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-9-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:13PM +0000, David Matlack wrote:
> Separate the allocation of child pages from the initialization. This is
> in preparation for doing page splitting outside of the vCPU fault
> context which requires a different allocation mechanism.
> 
> No functional changed intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

