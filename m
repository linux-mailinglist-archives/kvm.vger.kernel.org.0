Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A2849E55E
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbiA0PDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 10:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiA0PDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 10:03:32 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7192CC06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:03:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q75so2498561pgq.5
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 07:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C7e4lg+TQfiAQXzFbshw2MDjmu8fgeZdHDlpi+UGvYo=;
        b=IcQOxoah2w7acJz2e232GpOd3VrUx3E64S+sV7uDemfCljVeAuN3WzP457onmqiQDh
         u76szjjCW7GV6AipI7srdUWYmlM/68bIR2yp4xjNhM0YQo8yCq4AL225+l5VJKIa5S0/
         /0Mrhq05nFY4E9v+nHU727CI3fqDyqy4b3DxGAIyiU+bXsmER10zWCok5yDH/n7gX2SZ
         FibE55PLbZ96OrTzbmV/bmKpjnTunPNNbxIVWFHCrc7Jlo/hvORouyuNPI1cS5lww/dX
         sjVX4BJwQSzd7CDM6Iluftc4Wib/6cfgL5rRwAcjO9BJhwPoi21Zs6X3U6YXwJflTTPm
         XZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C7e4lg+TQfiAQXzFbshw2MDjmu8fgeZdHDlpi+UGvYo=;
        b=0C/fR8ASzgWcBTZvDJW+hHXstrQ7IiZoaDhG0NfbkqaLZbUIf5Qr/vkIimj52F2fo/
         dRiWgUZtiVJlzerUVfwxQsC5c9lMSQKlORuGH90M5Wa4ppjYzMf6pv25IWS3GaGelUPv
         DSW41567L21qFmAAJ55naGwmad7D/BBlmfbCffygmFdxRxTNKWOhhprl86Ludy6XELK5
         NWyKt3Ycmyv5LrcpiRTjXMVevc2WwIQbRmul629n24Np7oGVMFX9eHjTIfqUOV0k6Hum
         OEl2GxUtpCaqvXwdU5Z95439jgR8e8SBuyzfdc9tpBgZmGnEARVgkJNFsStZwHiW0nmb
         nx0A==
X-Gm-Message-State: AOAM531ccQR2775th3tP2WuIM+qs+mcqs9ogT1INURuJ6yUwZ38HieeJ
        aaRONhwZFpbwi0Zw8Yl/Tbmz3A==
X-Google-Smtp-Source: ABdhPJxeyTfytHmnbDJ+Aaj8xg4RdWFqAQNQtZWVFA0EOzrcxwnG9kZL1+ndwFC95obPUkTU31j1Sg==
X-Received: by 2002:aa7:8055:: with SMTP id y21mr3161629pfm.62.1643295811734;
        Thu, 27 Jan 2022 07:03:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k12sm6235793pfc.107.2022.01.27.07.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:03:31 -0800 (PST)
Date:   Thu, 27 Jan 2022 15:03:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 0/3] KVM: x86: XSS and XCR0 fixes
Message-ID: <YfK0P67bo5oSPXn4@google.com>
References: <20220126172226.2298529-1-seanjc@google.com>
 <3e978189-4c9a-53c3-31e7-c8ac1c51af31@redhat.com>
 <YfGJWNVuFYZ8kl2I@google.com>
 <f1389ace-6f5d-9f48-bb12-4835c29e6402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1389ace-6f5d-9f48-bb12-4835c29e6402@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022, Paolo Bonzini wrote:
> On 1/26/22 18:48, Sean Christopherson wrote:
> > On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> > > On 1/26/22 18:22, Sean Christopherson wrote:
> > > > For convenience, Like's patch split up and applied on top of Xiaoyao.
> > > > Tagged all for @stable, probably want to (retroactively?) get Xiaoyao's
> > > > patch tagged too?
> > > > Like Xu (2):
> > > >     KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
> > > >     KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time
> > > > 
> > > > Xiaoyao Li (1):
> > > >     KVM: x86: Keep MSR_IA32_XSS unchanged for INIT
> > > > 
> > > >    arch/x86/kvm/x86.c | 6 +++---
> > > >    1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
> > > 
> > > Queued, though I'll note that I kinda disagree with the stable@ marking of
> > > patch 1 (and therefore with the patch order) as it has no effect in
> > > practice.
> > 
> > Hmm, that's not a given, is it?  E.g. the guest can configure XSS early on and
> > then expect the configured value to live across INIT-SIPI-SIPI.  I agree it's
> > highly unlikely for any guest to actually do that, but I don't like assuming all
> > guests will behave a certain way.
> 
> No, I meant in the sense that supported_xss is always zero right now, and
> therefore so is MSR_IA32_XSS.

Oh, duh.
