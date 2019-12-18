Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992261251FF
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 20:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfLRTi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 14:38:56 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42037 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfLRTi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 14:38:56 -0500
Received: by mail-io1-f66.google.com with SMTP id n11so1693614iom.9
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 11:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQW9QdLYlN06sOdAVJaom6yjE9EzAuBpW13d3wxDdbs=;
        b=vh54jrbXr+r+lI4hsqpZhEbUrs02QVjOMq943tuCNLPDFd04S24SvHCh56TQZlbk/c
         A33hRJ7yBlL8/lIQdqY6CS6VMSfizjJ5IRzmJmAePBqnRn/LP8qXy8weSy3VsqFr8PEI
         CFxfpzvpbINZEgw6gK2Fvodm7w183RLO5Pj0UKZBB9RMgkMJ3FG5Vvc5nPwYQGtcnHN/
         W7+t64Iodxrwk++bf/tPCGyVhyqu1i3BTehegsKOdQ+DOFbM4Q0ggoQC88mSOGxxjmgM
         SWEha7dgHzJHFw3oJfVrmY9HzqhxWP0Z715vO1JmT1WFoQTB9rbsyLv4ttuiq1+jRjbw
         x/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQW9QdLYlN06sOdAVJaom6yjE9EzAuBpW13d3wxDdbs=;
        b=YsbaivVzRFOgPagq4IVJDbCnDVJElHskz5/iqDwyzK2Nq5vJz4LdX/9V7H5dlBXiBB
         Cggi7B1xmpEtTO7GLlTT8uiUCkgCesU0NKI+qIPImwhN4Muk8Sif86NdNEPCD5hI7vus
         3+q2UuWA1qL+4rVIREzUJTOQ/hRsqinTDPHTdz+msyuq5TJl4TRDoNNhlwl8Gm9Z3cbV
         ZxFUaF3LVIYZDc3jPmoKqzm/lDUHInjbWLwB27AwUrzivMCOWbotHBBJQcRHF05PmFHH
         6+fynq7WliN4F3JEScIQjyW40+UzYyBBrPwY6Rzed37uwGEZSebdRjeUSxQfqGGlu3zl
         8Bzw==
X-Gm-Message-State: APjAAAUyuveErmTo7Q7vX/GuroSyerFO8wkJ0a11nQjavM+3rp7ECTJZ
        7h7+OEfcCd/qYjS2gdzZQW5+9Belv4RDRzIszBNUSw==
X-Google-Smtp-Source: APXvYqzfsE8wwYFLUgK5vmDSI7g6h8kRB88v7iIIqSttpf6NImvY1/yY2CvGltz4bp3OTqvM74VZauQJIwvSiMEwfnw=
X-Received: by 2002:a5e:924c:: with SMTP id z12mr3017670iop.296.1576697935001;
 Wed, 18 Dec 2019 11:38:55 -0800 (PST)
MIME-Version: 1.0
References: <20191218174255.30773-1-sean.j.christopherson@intel.com>
In-Reply-To: <20191218174255.30773-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Dec 2019 11:38:43 -0800
Message-ID: <CALMp9eR-ssCUT_6oZntZ=-5SEN7Y8q-HnraKW=WDHuAn9gYZfQ@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: Disallow KVM_SET_CPUID{2} if the vCPU is in
 guest mode
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 9:42 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Reject KVM_SET_CPUID{2} with -EBUSY if the vCPU is in guest mode (L2) to
> avoid complications and potentially undesirable KVM behavior.  Allowing
> userspace to change a guest's capabilities while L2 is active would at
> best result in unexpected behavior in the guest (L1 or L2), and at worst
> induce bad KVM behavior by breaking fundamental assumptions regarding
> transitions between L0, L1 and L2.

This seems a bit contrived. As long as we're breaking the ABI, can we
disallow changes to CPUID once the vCPU has been powered on?
