Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237DD589260
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiHCSrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiHCSrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:47:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF7564CE
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 11:47:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b4so7158781pji.4
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 11:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=CT7f21cKTWFIPTe+6Ar+VcZqs1JgfCRps1fjd6TFaLU=;
        b=tRtjWh0ynt3zbeiVioUuNIrV2XpLSpkkaWz4e+9NMPuAy6CBoOflcn+bzYFv0vTOM2
         zkiO00kPrewrc09aqJhxsMXfoTbQSzJ/P8/By5cQaZKO1VJxbH6iGPZf1plWTkdBkawW
         GsgBrcBfQPsroh0V3ImJU6kah5hDOLIUMPUlfx0x4qydcPUfdkMrLQ4mwCkBfCwiyLXC
         MVt0CwN8Juwh3s8jR/wrVgT1CzxsXtfciy8ryCKBex89rMJV6anyb1XMRRcDJpFrUR0b
         XrnY9iNycA/l50pImp32z8/NFV2JiY3Qd5vyGVpqgXXgPubpaLFyL5FfiA6SxLG+bZIM
         htBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CT7f21cKTWFIPTe+6Ar+VcZqs1JgfCRps1fjd6TFaLU=;
        b=GGoKIaf3Kotl8/Izo6Hq3LzkGzcsvfDuSV7NlSkZOr1oVwZBhYReseLEFyA++XL3Pe
         YUnw5c0vft2sIpOk17fA8rMJi0ec7cOup3QKRtTlROIiLFwfC0hLUjqhH3N8HiQ8Jp7z
         RmDjYlnJnDrieeOA3hrHaO2tHIRsSNN6iwZOUqmGXzwF1lqE4mpcviLZikScqBP0Y5HA
         mhdTUos+sq5hlI7C6oHeM+PiMetDpXJbkmv4VPdilODEWz1kpN4rWxb54/GXlzUIKolE
         7inMCN1Szg3W3hnXVGp7yDZpIcO4331YdZfpirGnkITx+LTyEzP/J89gCM+oEkp7gWEF
         MDfA==
X-Gm-Message-State: ACgBeo0BWmhxP8m5D/zvcfj/mGmR1D1y69VdvwaCi9WKmztJ6dzzpSJe
        zKX7ghlM7iFtZHHpBD1ibbX1oPF8yj4fhw==
X-Google-Smtp-Source: AA6agR74OHzDirFEVtK2IRlGkXbcnccpyj6uV1b1jZ/7bjTk4Jq8uvWXFIUdNHXdoe9QIE2M/4akTA==
X-Received: by 2002:a17:90a:b010:b0:1f3:161c:30a0 with SMTP id x16-20020a17090ab01000b001f3161c30a0mr6049597pjq.243.1659552470736;
        Wed, 03 Aug 2022 11:47:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090a94c400b001ef87123615sm1956475pjw.37.2022.08.03.11.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 11:47:50 -0700 (PDT)
Date:   Wed, 3 Aug 2022 18:47:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Message-ID: <YurC0sHdmm+cxj5e@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
 <cb631fe5-103d-30f5-d800-4748f4ea41fa@gmail.com>
 <YuqIFjlk5iDtVnRm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuqIFjlk5iDtVnRm@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Sean Christopherson wrote:
> On Wed, Aug 03, 2022, Like Xu wrote:
> > Now, all the dots have been connected. As punishment, I'd like to cook this
> > patch set more with trackable tests so that you have more time for other
> > things that are not housekeeping.
> 
> Let me post v2, I've already done all the work and testing.  If there's more to
> be done, we can figure out next steps from there.

I partially take that back, I forgot about the "disallow writes to feature MSRs
after KVM_RUN".  I haven't addressed that and don't have bandwidth to work on it
for the foreseeable future.  If you can address the issue, that'd be awesome.

I'm still going to post v2, all of the PMU fixes/cleanups are valid regardless of
the KVM_RUN issue, i.e. they can go in sooner to fix slightly less theoretical
problems (I doubt there's a userspace that actually changes PERF_CAPABILITIES
after KVM_RUN).  I'll note in the changelog that KVM should disallow changing
feature MSRs after KVM_RUN.
