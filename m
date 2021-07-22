Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1CA3D265F
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhGVOXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 10:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbhGVOXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 10:23:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE1DC061757
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 08:04:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j8-20020a17090aeb08b0290173bac8b9c9so4721033pjz.3
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 08:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2bgmx6aikWNECjNInrD83c4X9mWyCilMDwv4/EHVX7s=;
        b=lNs30KEUEwb/M6gib0m08PWK/K753+CPfftNySVkFtyarDhNou9D61OKqCqKJjYxFy
         HbJhhktBEGmikY0iJUP3ZvbNJdFURlDxfwey2orTPA511o7q5TaVc4LWD8/X1r/HUI04
         Lt/ANNI3QNtz6aV5DqAxeyrwLeytqirbFB94JU/N6oBla4uzJdjnz8iLZiqwFQKPd8HP
         hLobZ7Fhkzo3TXxxNhHNk3zd5/UT+/oLyR7vKDCe/QuqZKblPjNVOM5kgY0FmOzHzjNr
         t4uyhb5rx7Fjs8RrZXDuuqhjowRkKJRDIx4Mi88kNbG8iv64Fk1kUbyGIGlaBrBa0h5k
         Y/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2bgmx6aikWNECjNInrD83c4X9mWyCilMDwv4/EHVX7s=;
        b=PWhDU9Jag+AUG0VN811dkzLWRrjuXk70haYlz1DJJLOl3ZPcTNZUFc2O58RleBkJcl
         bi/EiGrnDv4dKZBu8O0z5O1je7kZhtLnuNOhebZaQjSRE9I2wSlQk0nZ/qBo6kiWpXvp
         aqHCFdIrGQ/i1U4oT7eqxdiorIXJ/MeBa5zuS7yWbT8L9dr6J2YnsGui6xogJeR9KSiT
         rrqgw3XchyvixAdNv5TBxe3/TOSYamGqlZtYBFtyKHXzIH9h6U5bQ1jmmZZq2xoVe7vq
         w7AHQMqZ0VI35Rho6JnT4RcfvnoVisWZDpPDrgnsesCgAo3Xk5rKsjoDyQIs1h+yHun8
         wm/Q==
X-Gm-Message-State: AOAM533PBHM00+6+3cZBq46jJTENRujAd4Tyd5IhQBV5oVdzWqpzGUvt
        5HtgnZlhl2JQUikJ8WoNp2Rilw==
X-Google-Smtp-Source: ABdhPJwbde1UDibb5IEr+miphhvXefqE/Dhh3KfUkSGExHO98zZN3vcgQbr6eAvcOHJdczN8D0aqcQ==
X-Received: by 2002:a62:1c14:0:b029:34a:70f5:40da with SMTP id c20-20020a621c140000b029034a70f540damr293638pfc.37.1626966263551;
        Thu, 22 Jul 2021 08:04:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j15sm30510959pfh.194.2021.07.22.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 08:04:22 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:04:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Dynamically compute max VMCS index for vmcs12
Message-ID: <YPmI8x2Qu3ZSS5Bc@google.com>
References: <20210618214658.2700765-1-seanjc@google.com>
 <f5b512e85f2010ddf3ef621b75e3fb389e463a2c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b512e85f2010ddf3ef621b75e3fb389e463a2c.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021, Maxim Levitsky wrote:
> On Fri, 2021-06-18 at 14:46 -0700, Sean Christopherson wrote:
> > Calculate the max VMCS index for vmcs12 by walking the array to find the
> > actual max index.  Hardcoding the index is prone to bitrot, and the
> > calculation is only done on KVM bringup (albeit on every CPU, but there
> > aren't _that_ many null entries in the array).
> > 
> > Fixes: 3c0f99366e34 ("KVM: nVMX: Add a TSC multiplier field in VMCS12")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Could you give me an example on how this fails in the KVM unit tests?
> I have a bug report here and it might be related so I want to save some
> time triaging it.

FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17

FWIW, unless a kernel/hypervisor is sanity checking VMREAD/VMWRITE or doing something
clever with the MAX_INDEX, I wouldn't expect this to cause any real world failures.
