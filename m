Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865C13B8182
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 13:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhF3L6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 07:58:51 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:1600 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3L6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 07:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1625054182; x=1656590182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ASayfU0iOY/GQix80CamBpd9iL3PrqqC262D7i55c6Y=;
  b=lNP9rbhC8M0pzf+fap3Tjo9Hqfqf9SPaUxocOYlN3MF6p5tOtmft/HxV
   P8NHRw9+vITEUsBf84APtTk6JY/fHe9/kooidldwztOAe1Nc+KZ39Recq
   CcIwTP5IN0+ZQHf+DwIVrcLAwt4nLHqLSdRVKOiEHqhHQS9SOnILOePlj
   o=;
X-IronPort-AV: E=Sophos;i="5.83,311,1616457600"; 
   d="scan'208";a="941049953"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 30 Jun 2021 11:56:14 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id 0DBACA1F4C;
        Wed, 30 Jun 2021 11:56:13 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.162.164) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 30 Jun 2021 11:56:04 +0000
Date:   Wed, 30 Jun 2021 13:56:00 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] Add support for XMM fast hypercalls
Message-ID: <20210630115559.GA32360@u366d62d47e3651.ant.amazon.com>
References: <cover.1622019133.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1622019133.git.sidcha@amazon.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.164]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 10:56:07AM +0200, Siddharth Chandrasekaran wrote:
> Hyper-V supports the use of XMM registers to perform fast hypercalls.
> This allows guests to take advantage of the improved performance of the
> fast hypercall interface even though a hypercall may require more than
> (the current maximum of) two general purpose registers.
> 
> The XMM fast hypercall interface uses an additional six XMM registers
> (XMM0 to XMM5) to allow the caller to pass an input parameter block of
> up to 112 bytes. Hyper-V can also return data back to the guest in the
> remaining XMM registers that are not used by the current hypercall.
> 
> Although the Hyper-v TLFS mentions that a guest cannot use this feature
> unless the hypervisor advertises support for it, some hypercalls which
> we plan on upstreaming in future uses them anyway. This patchset adds
> necessary infrastructure for handling input/output via XMM registers and
> patches kvm_hv_flush_tlb() to use xmm input arguments.

Hi Paolo,

Are you expecting more reviews on these patches? 

Thanks. 

~ Sid



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



