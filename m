Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A2165C63E
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjACS2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjACS2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:28:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E30B231
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:28:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso36655340pjp.4
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3vuD0DHp3ujARqxE79A3UhQCl53rEt5wiE39RHOIgP8=;
        b=HmziRKWCeAdDWyHtnU4iWJdZ2Tr3WHhU6clSuuCyYSXzaAA9jMUm5IydgQCiQUZWQA
         8alhBpvuZOY/EPcp6eWJmgk22Qvn+3xlaQrinMY5E0F7mOk4EzUeyfHWt3tAm2jeDOUZ
         SQoJOSEwOOSKr+et0cVfz+hQ9AZrypnyjLkv/hVAiDEMGyxdu5G+HjPE/aS+zi61zKM4
         44lPATkKCsudk8YEVwOYo8Z/gbFiGtlhS1/Qz0LEirz+mTpiHwcyb2HPfOwDmp1F407O
         Zpx9DSMZBiIKvGl3rkQbgrOT4+YlgrBkjRekKBV2g7dF8cs7rwhNA+uRIk2GnpMryLax
         S6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vuD0DHp3ujARqxE79A3UhQCl53rEt5wiE39RHOIgP8=;
        b=qsmtc+mRZXZT26arK3gbYsjAo9mtU+TQcj6Ec0sVfp7hGHW+olUhK7D/GsU7Bkbudn
         jXGnN+vohtwZvZL7XoNjFvVWcg/obrhAcAQMU6L3u/jFE4M2xY1NZDMLXv6d5zaLpsyO
         AY5/H7daNdBj9iKbDn4hA1fxuykxefFT8ah+OvhSyg7f+eS+1WBHesx/mdMTgA8uef7v
         pGpBNgZS/95gUTwC0cyvg5vl59LJL+qjjlX4d8CTHzTMPfaxniMDzYaa8cHlLuVBqgdD
         rQCSdAefCGQ1ulQXA2+LcqKBTqA0aU3KgeeFvwRjHQjIjOCOTSBi/DwJTyWCxVIIAqZg
         y3Ng==
X-Gm-Message-State: AFqh2koJpfchDF9wUTF8hzIrl/w4UtVJyWn7VDMSLqjasYYs+dFQBBth
        AjgMbl7e8ODYiNXY6tChTPqyCg==
X-Google-Smtp-Source: AMrXdXsokWzuFevRYKwe95r43p25SwwPSyIZneGkhCUk6k3ySBH5WeLrrmT/OGXM3+7XaIR66faE6g==
X-Received: by 2002:a17:902:eb0a:b0:192:6bff:734 with SMTP id l10-20020a170902eb0a00b001926bff0734mr2484135plb.2.1672770484583;
        Tue, 03 Jan 2023 10:28:04 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l3-20020a170902e2c300b00192bf7eaf28sm6430903plc.286.2023.01.03.10.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:28:04 -0800 (PST)
Date:   Tue, 3 Jan 2023 18:28:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, pbonzini@redhat.com,
        jmattson@google.com, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v8 1/7] kvm: x86/pmu: Correct the mask used in a pmu
 event filter lookup
Message-ID: <Y7RzsEbNqKPUiCWr@google.com>
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-2-aaronlewis@google.com>
 <37064a64-47cb-aaad-4b8e-6ce2bdf68e56@gmail.com>
 <CAAAPnDE2HjrDbgzJgj7G6=5NQ11BJ=x4wmEStJkoPPCyWQmK_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDE2HjrDbgzJgj7G6=5NQ11BJ=x4wmEStJkoPPCyWQmK_w@mail.gmail.com>
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

On Wed, Dec 28, 2022, Aaron Lewis wrote:
> > > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > > index 85ff3c0588ba..5b070c563a97 100644
> > > --- a/arch/x86/kvm/pmu.h
> > > +++ b/arch/x86/kvm/pmu.h
> > > @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
> > >       void (*reset)(struct kvm_vcpu *vcpu);
> > >       void (*deliver_pmi)(struct kvm_vcpu *vcpu);
> > >       void (*cleanup)(struct kvm_vcpu *vcpu);
> > > +
> > > +     const u64 EVENTSEL_EVENT;
> >
> > Isn't it weird when the new thing added here is
> > not of the same type as the existing members ?
> >
> > Doesn't "pmu->raw_event_mask" help here ?
> >
> 
> In earlier revisions I had this as a callback, but it was a little
> awkward being that I really just wanted it to be a const that differed
> depending on platform.  Making it a const fit more naturally when
> using it than the callback approach, so despite it being different
> from the others here I think it works better overall.

And KVM already does similar things in kvm_x86_ops.
