Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1B4F81FB
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 16:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344178AbiDGOmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 10:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344170AbiDGOl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 10:41:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD11B48CD
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 07:39:53 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c2so5096937pga.10
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 07:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cdWHaY0HfTWkdJvVRP0q7ev5obKbIDvxCh0+0jaubQ8=;
        b=TYTWE6bZQ6Aut3wR3FmNbNA5BAnkpBzE8zzKRiY9Luk6S95BiKiR51Goo7JVDmOP2w
         apJnvtsfGOQgnWDjOobKVv0rzmz8Ir5u55juvHaEEzS4ZuonH4FCO5P3wkX3VAW6Y7mz
         K9vAl+LlQgqqJo9YpBnLzljo9Ez25RvasVMYqAnVt2SAqzOI+qqOXu4npSZVxENeyyRI
         EQSqFEwtohlnO8Lkz6J+00g8B7LX39V4632+Tk+mdfvbeCNcoQO2nn0Gqr1xcZNkWKlq
         ZUycB5aCaoY5WXkckTg8kBQcnX41SlQSBoekEYHh7SwHYtSyiCul3/ca+uWJttgVZzk7
         MrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cdWHaY0HfTWkdJvVRP0q7ev5obKbIDvxCh0+0jaubQ8=;
        b=x93wArhPBNSiL4QQeWjZnP1We5wRl7aQ/zZfjsQE7Vb/fHuqi5bLSYdp9BMjiz3pdk
         phjO2x3lqnRAoct2YRwwGyOJMF6wXOih5rcuBLjYXGumvWE9lJ9WLYzJ96d9agQ/I/kr
         tZWuR9OSlbisMDq5a8TvbA78YRTlFbk0bcxRqe0yKv8YH+r2aN+RKVPbvnsy9+fynVoH
         eg7kOLDmVZ2+6iKYvl0NEyXMY23VHtveowMD0sWfJHRKg8M+m2aH8YgOYI0CE8lARy/0
         +Sqg6R01Spshs4+usR6IwQIcOBZSSIFEhy3k2+t1P/4AsMrUz7c/+hB9nnwYnLgkfS82
         xq8A==
X-Gm-Message-State: AOAM531X8M7kxMXzi59kAIJ8v2/Xrjix/PbL6XFdumoYJo8P3CjVSL1A
        e1TA+vbNX91bqLK11la881w0Ew==
X-Google-Smtp-Source: ABdhPJzddpnKtgIEsEKP3sJDCzAj8LMSusDXvLaI5AqGYGgTcK+gSSdyd0LsCXgDLVnHzab5tJEmMw==
X-Received: by 2002:a65:48c6:0:b0:398:b858:e332 with SMTP id o6-20020a6548c6000000b00398b858e332mr11388035pgs.291.1649342393030;
        Thu, 07 Apr 2022 07:39:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u204-20020a6279d5000000b004fa58625a80sm23182829pfc.53.2022.04.07.07.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 07:39:52 -0700 (PDT)
Date:   Thu, 7 Apr 2022 14:39:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 089/104] KVM: TDX: Add a placeholder for handler
 of TDX hypercalls (TDG.VP.VMCALL)
Message-ID: <Yk73ta7nwuI1NnlC@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b84fcd9927e49716de913b0fe910018788aaba46.1646422845.git.isaku.yamahata@intel.com>
 <3042130fce467c30f07e58581da966fc405a4c6c.camel@intel.com>
 <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23189be4-4410-d47e-820c-a3645d5b9e6d@redhat.com>
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
> On 4/7/22 06:15, Kai Huang wrote:
> > > +static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +
> > > +	if (unlikely(tdx->tdvmcall.xmm_mask))
> > > +		goto unsupported;
> > Put a comment explaining this logic?
> > 
> 
> This only seems to be necessary for Hyper-V hypercalls, which however are
> not supported by this series in TDX guests (because the kvm_hv_hypercall
> still calls kvm_*_read, likewise for Xen).
> 
> So for now this conditional can be dropped.

I'd prefer to keep the sanity check, it's a cheap and easy way to detect a clear
cut guest bug.  E.g. KVM would be within its rights to write garbage the XMM
registers in this case.  Even though KVM isn't to be trusted, KVM can still be
nice to the guest.
