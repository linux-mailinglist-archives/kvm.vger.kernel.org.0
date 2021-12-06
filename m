Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ECE46A4CF
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 19:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347138AbhLFSoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 13:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbhLFSoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 13:44:07 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8665C061746;
        Mon,  6 Dec 2021 10:40:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso11100461wmr.4;
        Mon, 06 Dec 2021 10:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BqkOTEkjuLFYAppHViWXz/o8vXAYwICTgtZ7iVn+nH0=;
        b=qpltkcpyciUMcZakWWww7WjCDqeKWkCIOOjGk1gr3Y/5GbVNWJyUGXH7pnnleROxW1
         4GZj0HuhspRhAp8j6u1H2BpMCNjcmDQahivqcY9VtP5avpFnoWWIN6MZ99nV0+UDOUHB
         2kuA2iQPjxNWdTjrlnzNsV0vJ+8050hFvIVUXcApZFmNCsP41RCk4RSYzxLNC/Q2AHBc
         E51MipeyVZPiLV4E7nQYAaizRYYib2PGWN8qLlg9jmcPo0uL0m1F48hDmszz7GXyHfTn
         VCC3DYif1fTnsWC29aeaMjeu7sk8ScGuMLyDnxdTa9QHk/tNNwJMFjwbgLL8JfxXAKF4
         hwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BqkOTEkjuLFYAppHViWXz/o8vXAYwICTgtZ7iVn+nH0=;
        b=IJ89w8N6EQ5SLavAe/GGKdJdfcrBHEXaigVHLcPXPJzm75dIfi1nr9rZFx+qckE122
         6HruWH0nS1XNdhLGoJ+fjQh3bp30Db8cbICcFZurLSt8Cms/2ZXJLSAiJXeFWeOhZ4lG
         nKDcsax4XT4gK3TnTAlTnXYuLu7FqzOi8yvtbd5xE0u5nOl1qzzEnJYHTXx9g5JVosKS
         B63ijsEJ0wobmojCQWEWtmKMnneDVrwL4/EJ3xceqDcRbHuY9KmZv491ji/xAgQng2Xp
         dVoONeZZhiNpdOxPZsjm45a8T75TOJiKJ82iRshMxF44Y8FW8odT1WssfrxiGzvOFO55
         wmoA==
X-Gm-Message-State: AOAM533bP8YynBWixKYQ1EbJEqKyUUbe0sW5XPsmuZ0ZA2qGJekERdUs
        uPHG/ZUeW29eHvx1VehWbC0=
X-Google-Smtp-Source: ABdhPJwq4QrxASTcHYBhf7y19iNvXhpdj5qFkgsQ/1eGvwG5BgtE/YX3rCCJgS6EWRVh06/HZCFbXA==
X-Received: by 2002:a05:600c:6006:: with SMTP id az6mr355485wmb.5.1638816037234;
        Mon, 06 Dec 2021 10:40:37 -0800 (PST)
Received: from hamza-OptiPlex-7040 ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id i15sm192131wmq.18.2021.12.06.10.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:40:36 -0800 (PST)
Date:   Mon, 6 Dec 2021 23:40:31 +0500
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3] KVM: x86: fix for missing initialization of return
 status variable
Message-ID: <20211206184031.GA143655@hamza-OptiPlex-7040>
References: <20211206160813.GA37599@hamza-OptiPlex-7040>
 <20211206164503.135917-1-amhamza.mgc@gmail.com>
 <Ya5CCU0zf+MzMwcX@google.com>
 <20211206172746.GA141396@hamza-OptiPlex-7040>
 <Ya5P4WWsgCyQZvBH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5P4WWsgCyQZvBH@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 06:01:05PM +0000, Sean Christopherson wrote:
> On Mon, Dec 06, 2021, Ameer Hamza wrote:
> > On Mon, Dec 06, 2021 at 05:02:01PM +0000, Sean Christopherson wrote:
> > > On Mon, Dec 06, 2021, Ameer Hamza wrote:
> > > > If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> > > > ioctl, we should trigger KVM_BUG_ON() and return with EIO to silent
> > > > coverity warning.
> > > > 
> > > > Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
> > > > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > > > ---
> > > > Changes in v3:
> > > > Added KVM_BUG_ON() as default case and returned -EIO
> > > > ---
> > > >  arch/x86/kvm/x86.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index e0aa4dd53c7f..b37068f847ff 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -5019,6 +5019,9 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
> > > >  	case KVM_SET_DEVICE_ATTR:
> > > >  		r = kvm_arch_tsc_set_attr(vcpu, &attr);
> > > >  		break;
> > > > +	default:
> > > > +		KVM_BUG_ON(1, vcpu->kvm);
> > > > +		r = -EIO;
> > > 
> > > At least have a
> > > 
> > > 		break;
> > > 
> > > if we're going to be pedantic about things.
> > I just started as a contributer in this community and trying
> > to fix issues found by static analyzer tools. If you think that's
> > not necessary, its totally fine :)
> 
> (Most) Static analyzers are great, they definitely find real bugs.  But they also
> have a fair number of false positives, e.g. this is a firmly a false positive, so
> the results of any static analyzer needs to thought about critically, not blindly
> followed.  It's completely understandable that Coverity got tripped up in this
> case, but that's exactly why having a human vet the bug report is necessary.
> 
> There is arguably value in having a default statement to ensure future KVM code
> doesn't end up adding a bad call, which is why I'm not completely opposed to the
> above addition.
> 
> Where folks, myself included, get a bit grumpy is when patches are sent to "fix"
> bug reports from static analyzers without evidence that the submitter has done
> their due dilegence to understand the code they are changing, e.g. even without
> any understanding of KVM, a search of kvm_vcpu_ioctl_device_attr() in the code
> base and reading of the function would have shown that the report was a false
> positive, albeit a somewhat odd one, and that returning -EINVAL was likely the
> wrong thing to do.  If you're unsure if something is a real bug, please ask a
> question.
> 
> Rapid firing patches at the list also makes reviewers grumpy as it again suggests
> a lack of due dilegence, especially when the patches have typos ("EINV" in v2)
> and/or have obvious shortcomings (missing "break" in v3).
> 
> TL;DR: I have no objection whatsover to fixing (potential) bugs found by static
> analyzers, but please slow down and (a) make sure that it's actually a bug, (b)
> ask if you're unsure, and (c) do your best to ensure that what you're sending is
> an overall improvement.
Totally agreed with you. Thank you so much for your insights on this. I will keep
this into consideration moving forward.

Best Regards,
Hamza.
