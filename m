Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0782DC9B4
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 00:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgLPXsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 18:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgLPXsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 18:48:51 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A29C061794
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:48:10 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x18so7836691pln.6
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ie2jga1d2WifsBMDsqcpsBRer3g1HXUTEqYE5HM0ymI=;
        b=AOrjyK1VQwjuLIoBmSEl+wJZllyB710gOnQnEN72XiVQo6WwCy69SKgFR23a8rlAE3
         1Ldie1AUwO5nHm0dqrfy2OaRAwoeuKU0VehUSC1OCZ3Ptur5sIULTJMKukrODDMefQyZ
         czULcIBMjOrf0ElVPSTEZWHbf6DgUq+68qr+n6I8uW7/e2WDI1KUJedZS6m9p4SqGOVP
         DVAbsVCUWZFMRQPC250qREJSZN9M+O7NUzfDpvSItI7d4jVzo02bRmztig0e9Q09JcwO
         tk3xgomEvUdU6JtyPsHuf/V/mmVKiAo+OwAEiX6YiINz65Lbt69hzwaI6Us4kAHVCdan
         jY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ie2jga1d2WifsBMDsqcpsBRer3g1HXUTEqYE5HM0ymI=;
        b=aDZXR+gOPYN87mq33vJJdUocku/w55tPkM+WkcSEpEAleEfv/tHtiUZCD5gkookIzB
         tIRTBTX21zcxhJMEUbcTosNHnrITZqLLpBmgjDc9Uz+H83tLqrg+0djAq4Mo8Z0YyTl0
         ipdHLIZD3LbW3Ve+AIoHzkoLOg5SEkm2yRKPyqlc88SuwT7V2Q7P3YQ/yhOqf+b5VhtH
         erW529a9NrlWZoY55egoyEEdCW6EVCg3jyHNo9xpmFk7U4FI9DELzfOjAgKqzYo/3muX
         kuWAvWZVQRO0c5mhNpgPYCvyxO2RUrO80KeOlkxmNVRrwln5ZeC9UgLz7d1CwVtLHbW1
         3Cqw==
X-Gm-Message-State: AOAM530NQPyJSsJBxuk8OcEWe5NvoYKcMW0OhClMa6VgzNrE5btQvK4+
        JgvPtTRf/XJzdhkTNU6m1PjyYQ==
X-Google-Smtp-Source: ABdhPJyRFaucONdzqNJfhoqgh9ywV2juaj2rFORsh1WdiTZW7k+th9MDLmSs/14ThUjBilfkR5jqQw==
X-Received: by 2002:a17:90a:d58c:: with SMTP id v12mr5250946pju.37.1608162490296;
        Wed, 16 Dec 2020 15:48:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c14sm3545263pfd.37.2020.12.16.15.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 15:48:09 -0800 (PST)
Date:   Wed, 16 Dec 2020 15:48:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <X9qcsq2kW1kkoVWI@google.com>
References: <20201214174127.1398114-1-michael.roth@amd.com>
 <X9e/L3YTAT/N+ljh@google.com>
 <20201215185541.nxm2upy76u7z2ko6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215185541.nxm2upy76u7z2ko6@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020, Michael Roth wrote:
> Hi Sean,
> 
> Sorry to reply out-of-thread, our mail server is having issues with
> certain email addresses at the moment so I only see your message via
> the archives atm. But regarding:
> 
> >>> I think we can defer this until we're actually planning on running
> >>> the guest,
> >>> i.e. put this in svm_prepare_guest_switch().
> >>
> >> It looks like the SEV-ES patches might land before this one, and those
> >> introduce similar handling of VMSAVE in svm_vcpu_load(), so I think it
> >> might also create some churn there if we take this approach and want
> >> to keep the SEV-ES and non-SEV-ES handling similar.
> >
> >Hmm, I'll make sure to pay attention to that when I review the SEV-ES
> >patches,
> >which I was hoping to get to today, but that's looking unlikely at this
> >point.
> 
> It looks like SEV-ES patches are queued now. Those patches have
> undergone a lot of internal testing so I'm really hesitant to introduce
> any significant change to those at this stage as a prereq for my little
> patch. So for v3 I'm a little unsure how best to approach this.
> 
> The main options are:
> 
> a) go ahead and move the vmsave handling for non-sev-es case into
>    prepare_guest_switch() as you suggested, but leave the sev-es where
>    they are. then we can refactor those as a follow-up patch that can be
>    tested/reviewed as a separate series after we've had some time to
>    re-test, though that would probably just complicate the code in the
>    meantime...
> 
> b) stick with the current approach for now, and consider a follow-up series
>    to refactor both sev-es and non-sev-es as a whole that we can test
>    separately.
> 
> c) refactor SEV-ES handling as part of this series. it's only a small change
>    to the SEV-ES code but it re-orders enough things around that I'm
>    concerned it might invalidate some of the internal testing we've done.
>    whereas a follow-up refactoring such as the above options can be rolled
>    into our internal testing so we can let our test teams re-verify
> 
> Obviously I prefer b) but I'm biased on the matter and fine with whatever
> you and others think is best. I just wanted to point out my concerns with
> the various options.

Definitely (c).  This has already missed 5.11 (unless Paolo plans on shooting
from the hip), which means SEV-ES will get to enjoy a full (LTS) kernel release
before these optimizations take effect.

And, the series can be structured so that the optimization (VMSAVE during
.prepare_guest_switch()) is done in a separate patch.  That way, if it does
break SEV-ES (or legacy VMs), the optimized variant can be easily bisected and
fixed or reverted as needed.  E.g. first convert legacy VMs to use VMSAVE+VMLOAD,
possibly consolidating code along the way, then convert all VM types to do
VMSAVE during .prepare_guest_switch().
