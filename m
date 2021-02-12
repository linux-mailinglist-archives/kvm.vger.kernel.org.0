Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96E931A757
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLWN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 17:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhBLWNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 17:13:53 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEB2C061756
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 14:13:13 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z68so572877pgz.0
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 14:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Nl/Py1ndXbVVLIJoXB37vggu0Nr5Z73MPLWWsd0ksk=;
        b=LNj5xQOhiN4K16MHtHzkxeccQuu2Qit93z9VMBmBYOgnQiJsgWLurNXcJahfG4mrv+
         UWJiUZXGCUqfsTViMGDxIQsFYIwT2Wp1zm/irTU6xljq1pNOHbTag9SU8ue8WMskk1Ic
         Mli7kW5ERJMDweWbspATca484WYTv55mK99IyOkoewhAR0LBp1u1bHFrzUvvXaDA6rrf
         qkUkmxtJnZEcUpAgyaaf0K2vDg8iYcyigUXtZUCA1yARKEkO+ZXotzVQBAwWtxH7X3ly
         EKnBuFgdCCKy1wthKq2WJnyYLMtqCD4g9RXr5ypiw1JLO/yHK8FeT9vc3W4oBlFfSfAN
         SOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Nl/Py1ndXbVVLIJoXB37vggu0Nr5Z73MPLWWsd0ksk=;
        b=t3t3f28elE9/IJsBVrW32dFPAnLnIFsTC1xHSChOFzkadSViSEtRzWSn0esWj4KTVC
         NTnoOrEPuNEoObNoFSCw8FZgz4FtERXGGzPXOYX7X5SoK7LCLsQmSXISqfCV45pngMwh
         pb7Zcx4jdvy1cuqm6ARNIbvel7FgfUAiXYm+hf1b9P3gifmtb5xQqziY1fh8ahbaZPKg
         UsRxblCbV95vqAnulz2cX5IkU0nT78oL6zbojoGXgrPmBrusixFLTEe2owg5z4YvOWVb
         5hGcNlx5OazgBIg5DshEJW6CvGb4oxzkzhChUDprVt1EI4HW6Lqv/w/WyYAy76xxAOFG
         7LtQ==
X-Gm-Message-State: AOAM5333/LHSk72Ha8bNcrOoL6AfN+Dj7rmLlzP3l1gsAbZPWI+ApYDZ
        y/aZpYoTPFlaDiwaWJc3t+HkJw==
X-Google-Smtp-Source: ABdhPJx8zmHswAB8D7dKDkihjeP2fNqUJtcTmr5AxQn7e4IaaN6EIWGfKQUAi2FSRy4aow09Q1slWQ==
X-Received: by 2002:a63:cd08:: with SMTP id i8mr5107370pgg.425.1613167992574;
        Fri, 12 Feb 2021 14:13:12 -0800 (PST)
Received: from google.com ([2620:15c:f:10:b407:1780:13d2:b27])
        by smtp.gmail.com with ESMTPSA id o189sm9710742pfd.73.2021.02.12.14.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 14:13:11 -0800 (PST)
Date:   Fri, 12 Feb 2021 14:13:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
Message-ID: <YCb9cUwu+7SrM2sq@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com>
 <YCbE+hJC8xeWnKRg@google.com>
 <CA+qz5sqFYrFj=0+kq9m4huwkpC6V8MV_vy5c05VNqMgCPw+fDg@mail.gmail.com>
 <YCbws4v7Up2daHyQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCbws4v7Up2daHyQ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021, Sean Christopherson wrote:
> On Fri, Feb 12, 2021, Makarand Sonare wrote:
> > >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > >> index 777177ea9a35e..eb6639f0ee7eb 100644
> > >> --- a/arch/x86/kvm/vmx/vmx.c
> > >> +++ b/arch/x86/kvm/vmx/vmx.c
> > >> @@ -4276,7 +4276,7 @@ static void
> > >> vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> > >>  	*/
> > >>  	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
> > >>
> > >> -	if (!enable_pml)
> > >> +	if (!enable_pml || !vcpu->kvm->arch.pml_enabled)
> > >>  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
> > >
> > > The checks are unnecessary if PML is dynamically toggled, i.e. this
> > > snippet can unconditionally clear PML.  When setting SECONDARY_EXEC
> > > (below snippet), PML will be preserved in the current controls, which is
> > > what we want.
> > 
> > Assuming a new VCPU can be added at a later time after PML is already
> > enabled, should we clear
> > PML in VMCS for the new VCPU. If yes what will be the trigger for
> > setting PML for the new VCPU?
> 
> Ah, didn't consider that.  Phooey.

I remember why I thought this could be unconditional.  Adding PML to the list of
dynamic bits in vmcs_set_secondary_exec_control() effectively makes this code
unconditional, because it means that current bit will be preserved, including
the case where PML=0 when a vCPU is created.

I believe the fix is simply to not mark PML as fully dynamic.
