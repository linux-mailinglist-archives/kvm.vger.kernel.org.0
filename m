Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3254832B578
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356215AbhCCHRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244258AbhCBS06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:26:58 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11315C06178B
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:17:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e3so10359527pfj.6
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xjoxtDeZVJmNWTGHn0H0lCFPaR4VqFxzOXXzxPha6EE=;
        b=rhf3oxsfGGo53nh4GOrvv+Y0oL6pgnfzdfDpSwL7grZyiEvJt5I8RnPJS5gLORMQB0
         tRi7n2bU9MDbNOfjCGBZkGIxHX6BEDDZIy2lDJYe8a1Tm1roXPMLfVn0AOeWh8LZeZeU
         FqWXR1qCpf4FZiIQaY5P2nzD1yAKZaB9Uz+eDvyM/DJ8zlkRRaaQfYAopSSW/tPdEp1Q
         22RfhArWksh0wudozmgGGspI4Y5Xovj21C16DjDxn2UQSJPfFbYD0FczMShFUuKe5zzZ
         v5KMNSX/rRFjJZ80FDpwSg3GNJcrcVIGQiAqVHhe86EohH18ykIYcMmy1+kzLFGSShj7
         xTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xjoxtDeZVJmNWTGHn0H0lCFPaR4VqFxzOXXzxPha6EE=;
        b=TQ4xZ9/EXfHZt+Xgc/ZWTa8XuGdMJQ6ausSNzYA4Q+6PZE01sXcHIBRU/6o9mATaZw
         d9mMk7ntVq03tvCcdV4bynFWsYI2o5MkSsuyJTxEjtvDWbJ6wD80Q5th8+nTJHd9/954
         ZNhw7vNAKeo9pZF0A4XlNBdXCWczaa/WURDLkjrmuC2KHb0pYGAsKr0wbTxEKtgEBK4Y
         seYEfvOiS0jGdG+s8PiUWAC+UHCeJ/yKdW4SPf9A+n/cecad1lfRe2WOY/SAAXokEt64
         dGSDW+tpgfcNjZtHFMJEneuHkS0fXUqmG03KY6DvcxRhmISKczSwaqr240Q9XRPy9Orh
         2FEA==
X-Gm-Message-State: AOAM530KGtTu36agMUIPd3rIPtAKq4c2A60Esj7m40qknXoRb/G/dSAJ
        opAt/Qjvy4aEwL1p2aR+bHBuWwi3Cne8VQ==
X-Google-Smtp-Source: ABdhPJyir8Hi4ETXFhsFfHVZO9TJ7tP2YR7BNYQHcZZJV1WrhVCyOwHfDk/SeDwYG/5ICfDidf0ZYw==
X-Received: by 2002:aa7:948d:0:b029:1ed:a489:dd7a with SMTP id z13-20020aa7948d0000b02901eda489dd7amr4446965pfk.29.1614709074340;
        Tue, 02 Mar 2021 10:17:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id o127sm21816244pfg.202.2021.03.02.10.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:17:53 -0800 (PST)
Date:   Tue, 2 Mar 2021 10:17:47 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 0/2] KVM: x86: Emulate L2 triple fault without killing L1
Message-ID: <YD6BS0PR/+d6iC5Q@google.com>
References: <20210302174515.2812275-1-seanjc@google.com>
 <04aa253c-9708-d707-3ee9-7595da4029ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04aa253c-9708-d707-3ee9-7595da4029ad@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021, Paolo Bonzini wrote:
> On 02/03/21 18:45, Sean Christopherson wrote:
> > If KVM (L0) intercepts #GP, but L1 does not, then L2 can kill L1 by
> > triggering triple fault.  On both VMX and SVM, if the CPU hits a fault
> > while vectoring an injected #DF (or I supposed any #DF), any intercept
> > from the hypervisor takes priority over triple fault.  #PF is unlikely to
> > be intercepted by L0 but not L1.  The bigger problem is #GP, which is
> > intercepted on both VMX and SVM if enable_vmware_backdoor=1, and is also
> > now intercepted for the lovely VMRUN/VMLOAD/VMSAVE errata.
> > 
> > Based on kvm/queue, commit fe5f0041c026 ("KVM/SVM: Move vmenter.S exception
> > fixups out of line").  x86.c and svm/nested.c conflict with kvm/master.
> > They are minor and straighforward, but let me know if you want me to post
> > a version based on kvm/master for easier inclusion into 5.12.
> 
> I think it would be too intrusive.  Let's stick this in 5.13 only.

Hmm, agreed, especially since most of the paths are not properly tested.  In
that case, probably best to also drop stable@kernel.org?
