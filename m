Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819C84952AC
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377136AbiATQzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347520AbiATQzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 11:55:16 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF39C061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:55:15 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d1so5639267plh.10
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 08:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1hIYcnYEMBMDNrmBdll9eU3H5M+DnVhqPKta9XLFyhk=;
        b=ervlZQ5aejovIH5MpG06zxuE9aspSYkPiN8FinUhvXrPM83DBTOtGbzJiduN7y5Kk9
         zS4erTzhB9EG+FM7kspt155IIxrHrijoakL5svSz7muHIyAimmgn540VgdUIXkGOKSym
         AXG76kzICEOE9ObTPqRZCqfYkvH4/CHI/V+gveXsUSfHHJFAL8f2OuPlaoThR++s7GbE
         xluLbk/TJ58aK2iHxQoo+V0ssJgELk7l/kWT9/Wg2Zvkvg9gC+smr7rZO6jJXtawx5QA
         ud3iY933OPnAz8jynOF8hjm+g1E5Qv8ImJNbak6h7dfF4zk1u86p+Wdz2kBaB4WKfgWK
         48/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1hIYcnYEMBMDNrmBdll9eU3H5M+DnVhqPKta9XLFyhk=;
        b=LHxeuCBLms/P1RNdz9JknZc9c/j3KQ28Jf8X2IGukyMYqQ/54lDxunTDVLPadvbsKR
         +jHVXEMO4M6MeWgU15Zf3hBZ7C1rVq0wSg0fDh12hsqjXs0HBp8FEMy4AnQNZkW6twq8
         CgjnWMMe/WQBqKHShretO65prC1zjO/s6hoP2xa1h7JTevgh2VlmPNgQ7DbX74kNiLRD
         QkZVRKKTayjbM9WBBngb4ZRvH4CGl9YStLfcZIv+KHsofVH/vWlKg7wLijM3ywTymT4G
         4PVGU1jp6VNTx5z0fZbFaeLLW9LWp4MuzsBT4Zc0svyUAFj3CcgB6mHPHJ4qqHo2beo/
         9srw==
X-Gm-Message-State: AOAM530ZVyU0IogtUuwMwCjJuNmfVZvr7WoJJbQ2ZAUHQHRTSjZNs1K8
        TsW1UNuYcVXekd/J7odcBk9MgQ==
X-Google-Smtp-Source: ABdhPJzjVzyeltjvZK6N8iLpUi6E7Y1pRDl8G+joSYMAXJ/ZWkx1YkW4yZEgmSp+OQvT4RhYP0xh1Q==
X-Received: by 2002:a17:902:a408:b0:14a:d2ea:5a2b with SMTP id p8-20020a170902a40800b0014ad2ea5a2bmr15199378plq.115.1642697714514;
        Thu, 20 Jan 2022 08:55:14 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13sm4234083pfh.40.2022.01.20.08.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 08:55:13 -0800 (PST)
Date:   Thu, 20 Jan 2022 16:55:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 3/9] KVM: SVM: Don't intercept #GP for SEV guests
Message-ID: <YemT7p826ZF4OLu7@google.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-4-seanjc@google.com>
 <61dcbb64-2f2a-175a-e207-79398e80184c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61dcbb64-2f2a-175a-e207-79398e80184c@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Liam Merwick wrote:
> On 20/01/2022 01:07, Sean Christopherson wrote:
> > Never intercept #GP for SEV guests as reading SEV guest private memory
> > will return cyphertext, i.e. emulating on #GP can't work as intended.
> > 
> 
> "ciphertext" seems to be the convention.

Huh, indeed it does seem to be way more common, and cipher is the proper root.
Stupid English, why can't we have encrypt+cypher or encript+cipher?

Thanks!  I'll get these fixed.
