Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4429356A86F
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiGGQkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 12:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiGGQkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 12:40:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A535B6323
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 09:40:12 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w185so16775807pfb.4
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 09:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yD9JOmzp/dFDreTYsU04JyTwToOKdMohWmxTbaY6njU=;
        b=DKgr4DUtPFkc2YDiqeIjerue3AdI7QvRfGK/IvbHd5WNTyaO9jlMo3t7VDNIsgycBd
         t6lQ87zUS2Pl9GJwRhjoGWGceAce6eVnnyxitqo+Eu/Xz6OmKcSmrDovq2/kK3RmsXdV
         4Zfim6Y0ZksMG/veV2zgbBBog0DqiGhbWO+r9Zf1/uquXY+OPCTFiD69FwWkhS4iQPWc
         isKhI1Ls+LByweIbakofzyOp7saougvp7qWNGpDu/aFrNFfG2Q7M4lH04daUChzK80Hu
         Nb4IOaA1dNWe/SQrp94mkgbyfb8qGJO4J5uEYBdK49Z06hXbDSRWKRiMd89ea36xMfa6
         FH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yD9JOmzp/dFDreTYsU04JyTwToOKdMohWmxTbaY6njU=;
        b=YM+QpPCEdVJ56C2tFj5Em+SYrDIXw180AoMPgtvQYsRIqnZeLtjjeXhGj7DMslfWD3
         qH/h42tJXcbYIlskKMQqSP+1MTd4aiqhxxytEcX9Kq1288Fo6UaO1PFxZXDw1kVvGFHK
         rboKCdi1BwGZn9ymAEQLbA8hi8Dn7ituxbbL7d4HKcCYV976ONaBGipIabZyj3d1JEKT
         VlP8j+SY440F2MEuPmbr6G7X2DIzjBlSA7ncPtdYfNobgY7k/fL0CdLzsvRqCWCR+FWh
         NDMWV7J8d5GX2NprorHqBJPRW/p1ZQ8m7wEh9hDB0cwVB3RKQ8ukhCrRTTdHxRDtaEpk
         UxDg==
X-Gm-Message-State: AJIora97XBgtaszPRpqukzaiHtxU09hHQFjVLHibPS1AQbMIc7p+nye8
        892Dy6AgWEYzS4wL2X4HMS04Zw==
X-Google-Smtp-Source: AGRyM1uRun8/gyQJJismerB54U/dXNI8KUubj/l+07lYiNiUSieBPfgfo3nCJCkX+KWvZ5rnxkhc/Q==
X-Received: by 2002:a17:90b:4f4e:b0:1ef:ab40:b345 with SMTP id pj14-20020a17090b4f4e00b001efab40b345mr6235651pjb.226.1657212012079;
        Thu, 07 Jul 2022 09:40:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id oa1-20020a17090b1bc100b001ec84b0f199sm3505764pjb.1.2022.07.07.09.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 09:40:11 -0700 (PDT)
Date:   Thu, 7 Jul 2022 16:40:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/28] KVM: nVMX: Introduce
 KVM_CAP_HYPERV_ENLIGHTENED_VMCS2
Message-ID: <YscMZ2eU92fkDowB@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-7-vkuznets@redhat.com>
 <YsYAPL1UUKJB3/MJ@google.com>
 <87o7y1qm5t.fsf@redhat.com>
 <YscHNur0OsViyyDJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YscHNur0OsViyyDJ@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022, Sean Christopherson wrote:
> On Thu, Jul 07, 2022, Vitaly Kuznetsov wrote:
> > luckily, Microsoft added a new PV CPUID feature bit inidicating the support
> > for the new features in eVMCSv1 so KVM can just observe whether the bit was
> > set by VMM or not and filter accordingly.
> 
> If there's a CPUID feature bit, why does KVM need to invent its own revision scheme?

Doh, just saw your other mail.
