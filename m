Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1734F1BBA
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381084AbiDDVWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379542AbiDDR1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:27:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABD924BF9
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:25:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g15-20020a17090adb0f00b001caa9a230c7so2343197pjv.5
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mgnV7xI4qUCKfrqlWFwfqK4AIab4DaYNplYu5ZnU12A=;
        b=h6IOoYbeGqsTOT85hNSp30Z6S3z/0oyrH77ylDcQCzYqAx2ZHRLm2YfmqSFB6NClJu
         kJcZx7FPEq1+GT1+BVhpf6hwXjOBLbp1YTYM8YeAerFOwniYHATjFWcncbG6zs4uc6lH
         D88N/qv4s8ZVGSl86KP8gRLyF0TEI/eJIvNpSlCtRlVqEnCJ37G+eGGqZ6VKZiksrR7/
         f975k9mhAdFYWZ6szHTXhJ8FN8tFh7MppB6ZV6jJSdiwgzfuf9i/XV/f4wxmXlEauKwx
         Jdu6TE4dO0MoCr/z3O/HM6LiRiNFGaXRzJlLG1c4sNEbtr1FVbATJkiOaKRHQaYmNWJG
         QSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mgnV7xI4qUCKfrqlWFwfqK4AIab4DaYNplYu5ZnU12A=;
        b=zqrR6eAhzB4pWfIAvbOSd8PCEWls3K+OQmC8TMC/kQwdPPZyoIFxpAENW9vf27r93d
         FepZc8/Y4A5H1+U9dt7Yf/fF17GDhN1As3dynxK8b924ZQ+YziUN9z91L5YjfeJmxA4D
         cisHBasA+bJNc1hZ2Ou8mfZK8LFacjQ12wWVIPGSndokRCM6EA3Y+r4B6anT8tq+rsjZ
         zV1Vkqex8atthqjGYMqnlS5KZqQVvIFdNDLKwrnj6vAu+EFK2tfVAQRWdQtW1Poj2Fc3
         mMMy+DdlMMYnqCZU0aXTV9OM4PSZ7VwNXYd5g5iQhSeiZhf+hBKa+j1q6KJrZ3FWpGGN
         2UrQ==
X-Gm-Message-State: AOAM532nw9CuRWam5037Z1MJba0wKL2GJKFqsoE1zB2cU5WyJ8ncWqOa
        rG1uHrHbg/rjQQNnjQOxopURiQ==
X-Google-Smtp-Source: ABdhPJyLI0a6Ip/thHpTPRIhpEWNh1fk6lFS2o3mWz/SM4TxmeP+4fejjowg5XpABQqXkGYoEg44EQ==
X-Received: by 2002:a17:90b:38cd:b0:1ca:64dd:4747 with SMTP id nn13-20020a17090b38cd00b001ca64dd4747mr232081pjb.55.1649093121770;
        Mon, 04 Apr 2022 10:25:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bx22-20020a056a00429600b004fa936a64b0sm12144176pfb.196.2022.04.04.10.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:25:20 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:25:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 7/8] KVM: x86: Allow userspace set maximum VCPU id for
 VM
Message-ID: <Yksp/Q1a24r85wAY@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-8-guang.zeng@intel.com>
 <YkZc7cMsDaR5S2hM@google.com>
 <60879468-c54f-e7f1-2123-ba4cf4128ac3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60879468-c54f-e7f1-2123-ba4cf4128ac3@intel.com>
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

On Sun, Apr 03, 2022, Zeng Guang wrote:
> 
> On 4/1/2022 10:01 AM, Sean Christopherson wrote:
> > Amusingly, I think we also need a capability to enumerate that KVM_CAP_MAX_VCPU_ID
> > is writable.
> 
> IIUC, KVM_CAP_*  has intrinsic writable attribute. KVM will return invalid
> If not implemented.

Yes, but forcing userspace to do a dummy write to detect support is rather ugly.
I'm not totally opposed to it.  Probably a Paolo question.

Paolo?

> > > +		if (cap->args[0] <= KVM_MAX_VCPU_IDS) {
> > > +			kvm->arch.max_vcpu_id = cap->args[0];
> > This needs to be rejected if kvm->created_vcpus > 0, and that check needs to be
> > done under kvm_lock, otherwise userspace can bump the max ID after KVM allocates
> > per-VM structures and trigger buffer overflow.
> 
> Is it necessary to use kvm_lock ? Seems no use case to call it from multi-threads.

There's no sane use case, but userspace is untrusted, i.e. KVM can't assume that
userspace will do the right/desired thing.
