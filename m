Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56B54F86F6
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346800AbiDGSNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiDGSNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:13:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49D41E533C
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:11:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n9so5734608plc.4
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gFTZbohyu/8p0m2uDVkoq5Xi+CtqAPyNZuEuTStjgLw=;
        b=Q0dPWbdN0nv0dKw79003/9fFAxPKvcaowcm7jlclYg/Vj4xPGoGVoQAXoHbHMXOcnQ
         hAwP0xPZdWxvRlcN/Z04XY+71Hdbcsrs6xStD07ZNa39aEA7gJ52mwKzQPiajdNjx1bx
         MqdmryCgbw07EFt37XhANvUorW1hqkvhItGvWdksWwqvtlGI24kxy8KZJDOhSk1FRbAN
         qLu/dM2/FWRFVfp2t+RrJLkdSRyfyzgclA3rNkdlsQLVgl3LA22fxEsAuXqEAfEfPF8M
         5fpPKnjanWRnqG5CpyzXoWPaA8O5dEkcFwVGNxRFWeVJE89wILIr3wOGHP+fpvn4yxMS
         yxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gFTZbohyu/8p0m2uDVkoq5Xi+CtqAPyNZuEuTStjgLw=;
        b=NzOzqZ/NDfcel27tdzkqw/jQd2zac7vLlbHljgvbimVPV4yL87fZmoZCxyWLMt7XGQ
         kw03L0EbPzZkNSWsftJPPOiWmkJ7UiWG6XBj9P6RahQV+bCSQDWelsFLPW9W34kmgS3C
         +Mqh1c4GaewKm1rDHb+7wMChYf3wXVCfz5tEM0Els/sdeAES5EKY0zLZrK0X6VUYbcaT
         QZTtPONbz9ItfBX7TjPs89e6afkFnpJbaNbvSb38kZxkZe0xSVtAllX52JnD5YBUVjTv
         Y0GAoa9RfULMcZiGNDjEi5KhZsq+Qag14zxifYOp2SXnn5vG422gOvkBqSWXlA9UTbOr
         mWSg==
X-Gm-Message-State: AOAM530S/SWuYneWZ/ZCxrfcKJ/fxc4rJAGVzzsk7q0E9ao0iQxtP4Um
        GifQ5HekmXFLj6xGPwO6sfrUpw==
X-Google-Smtp-Source: ABdhPJzKwyvDkL4Jt5SJPcSZcH57a/q231m6NrkQ5Nit7QmvSubLzm5C46IIfYmddPJNx1JfLUlqbA==
X-Received: by 2002:a17:902:d5d7:b0:156:1968:8b2f with SMTP id g23-20020a170902d5d700b0015619688b2fmr15132620plh.97.1649355107125;
        Thu, 07 Apr 2022 11:11:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s22-20020a056a00179600b004fb28a97abdsm26057745pfg.12.2022.04.07.11.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 11:11:46 -0700 (PDT)
Date:   Thu, 7 Apr 2022 18:11:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler
 of TDX hypercalls (TDG.VP.VMCALL)
Message-ID: <Yk8pX8jweGu745Uj@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
 <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
 <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
 <Yk73ta7nwuI1NnlC@google.com>
 <6f1169f1-6205-c4d3-1ab0-2e11808f9b10@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f1169f1-6205-c4d3-1ab0-2e11808f9b10@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> On 4/7/22 16:39, Sean Christopherson wrote:
> > On Thu, Apr 07, 2022, Paolo Bonzini wrote:
> > > On 4/7/22 06:15, Kai Huang wrote:
> > > > > +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > > +
> > > > > +	if (unlikely(tdx->tdvmcall.xmm_mask))
> > > > > +		goto unsupported;
> > > > Put a comment explaining this logic?
> > > > 
> > > 
> > > This only seems to be necessary for Hyper-V hypercalls, which however are
> > > not supported by this series in TDX guests (because the kvm_hv_hypercall
> > > still calls kvm_*_read, likewise for Xen).
> > > 
> > > So for now this conditional can be dropped.
> > 
> > I'd prefer to keep the sanity check, it's a cheap and easy way to detect a clear
> > cut guest bug.
> 
> I don't think it's necessarily a guest bug, just silly but valid behavior.

It's a bug from a security perspective given that letting the host unnecessarily
manipulate register state is an exploit waiting to happen.

Though for KVM to reject the TDVMCALLs, the GHCI should really be updated to state
that exposing more state than is required _may_ be considered invalid ("may" so
that KVM isn't required to check the mask on every exit, which IMO is beyond tedious).
