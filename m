Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EA348DBB1
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiAMQ02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiAMQ00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 11:26:26 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9EAC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:26:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t18so10567113plg.9
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pk/7BdSIsGG0KgW2ujwUXsz/1xkMnjTcC1wzuA0ThFY=;
        b=tf39qpTYYXTMBM3CObcecGxp3FkDQyEZBRGKBPlHFsR9+29yZB+2/Qq6CYwe2gJd52
         2rBi8uQQVPuoeS+11OuU+8U0twJynTGbJ/xTpuV9EBwYfO8eFteYsr3uLSDT40umLav3
         GwVQR2PloZEF5aHo4McuaL2Zb7y/gf5FNFFIlUZnoco5lu1hN1ZyANjzKKgMsKugpGgS
         HBrWqkJ+B5NkZXfsdSDagsx58gMPGIk2LusHwU/0Z2tgZZMFjUMRzA0uExphH7ozO2nE
         iQ2zV6TpbvMxRDO6mpsUmviRl5Wq7Qheu1NEVfYeZNcaAiBgo/Ric8KuWCjm/eBAfI8Y
         aEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pk/7BdSIsGG0KgW2ujwUXsz/1xkMnjTcC1wzuA0ThFY=;
        b=e8K70FXY/AUg1iBuWe7iH1lDnjZik+8NwMt8biP5I5BO0euFV/xhMlAQL4tPRnjdtX
         gMXpSQ7my01Og1jSGmpjObVolFjxmEmc59yflU/R9f4mxStyGKruZsbCIq38XVDsswZp
         hkRH6fzgCC2eqoC5S3sMEM0U1mXjFfCF7fhbl4uFu2uOBcJQUvLQdB5HHmo/qS4KtxOR
         R3cNj2xNxyRNSLxiZqr3skoRE3DD44DpBWosNNYvpQeY2WyzVf06PQKWVMiFpeCf1S21
         uGt/0V3d6+NsJrVf1XKo7Ftzny+OdkVnU1sF7SgXPEjHxBVfGubAhtIHuUAjI2nm/V8F
         CpZw==
X-Gm-Message-State: AOAM530uN1xWU/5/t/8sqYe3rNhhTBBo5dVO+eeRWBxTZqa8ZEWqCvp8
        oFrk4zOolyip84r9K2/5p1jLmg==
X-Google-Smtp-Source: ABdhPJw8++zFFzYtVrDAm00iNYzkqBasNxy1VfOaE+YpTnR/NdbhAr7HE+YmGoL6E7yRfzGFohDzqg==
X-Received: by 2002:a17:903:228b:b0:14a:8379:bb8b with SMTP id b11-20020a170903228b00b0014a8379bb8bmr1982710plh.110.1642091185545;
        Thu, 13 Jan 2022 08:26:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t6sm1090279pfg.92.2022.01.13.08.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:26:24 -0800 (PST)
Date:   Thu, 13 Jan 2022 16:26:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Message-ID: <YeBSrcNawgzvTzQ6@google.com>
References: <877dbbq5om.fsf@redhat.com>
 <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
 <20220111090022.1125ffb5@redhat.com>
 <87fsptnjic.fsf@redhat.com>
 <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
 <87bl0gnfy5.fsf@redhat.com>
 <7e7c7e22f8b1b1695d26d9e19a767b87c679df93.camel@redhat.com>
 <87zgnzn1nr.fsf@redhat.com>
 <6ae7e64c53727f9f00537d787e9612c292c4e244.camel@redhat.com>
 <87wnj3n0k0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnj3n0k0.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> > For my nested AVIC work I would really want the APIC ID of a VCPU to be read-only
> > and be equal to vcpu_id.
> >
> 
> Doesn't APIC ID have topology encoded in it?

Yeah, APIC IDs are derived from the topology.  From the SDM (this doesn't
talk about core/SMT info, but that's included as well):

  The hardware assigned APIC ID is based on system topology and includes encoding
  for socket position and cluster information.

The SDM also says:

  Some processors permit software to modify the APIC ID. However, the ability of
  software to modify the APIC ID is processor model specific.

So I _think_ we could define KVM behavior to ignore writes from the _guest_, but
the APIC_ID == vcpu_id requirement won't fly as userspace expects to be able to
stuff virtual toplogy info into the APIC ID.
