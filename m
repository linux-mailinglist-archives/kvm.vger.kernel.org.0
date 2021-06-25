Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F143B41C6
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFYKif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:38:35 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:55976 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhFYKie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:38:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1624617374; x=1656153374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KzhMXHLw9k4GxAobVRtJ2eDWA6JjcGFVLfsz2oYkbJg=;
  b=dA9lEvi5G0aRomsGqAnuFGqbEMOXDAYQJK+GRGoVGgHwDgccwcPKt6jK
   Zkw2zFaDeUauMk20cWwjvONW1WyWpt9wTfd2oK/3vhlOClxygYJcpvlM3
   28iFRcLh9L9lwdym7aaNCj27yfqp47/8iC1Wp0Lkqobbu1nS51WyZML3G
   Y=;
X-IronPort-AV: E=Sophos;i="5.83,298,1616457600"; 
   d="scan'208";a="8675781"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 25 Jun 2021 10:36:07 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 3F061288D3B;
        Fri, 25 Jun 2021 10:36:05 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.229) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 25 Jun 2021 10:36:01 +0000
Date:   Fri, 25 Jun 2021 12:35:57 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Alexander Graf <graf@amazon.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/6] kvm/i386: Add support for user space MSR filtering
Message-ID: <20210625103556.GA17845@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1621885749.git.sidcha@amazon.de>
 <4c7ecaab0295e8420ee03baf37c7722e01bb81ce.1621885749.git.sidcha@amazon.de>
 <2c6375b0-e7e0-a19e-8cc9-a8b81a64dfc1@amazon.com>
 <20210608105317.GA25597@u366d62d47e3651.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210608105317.GA25597@u366d62d47e3651.ant.amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.229]
X-ClientProxiedBy: EX13D42UWB002.ant.amazon.com (10.43.161.155) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 12:53:17PM +0200, Siddharth Chandrasekaran wrote:
> On Tue, Jun 08, 2021 at 10:48:53AM +0200, Alexander Graf wrote:
> > On 24.05.21 22:01, Siddharth Chandrasekaran wrote:
> > > Check and enable user space MSR filtering capability and handle new exit
> > > reason KVM_EXIT_X86_WRMSR. This will be used in a follow up patch to
> > > implement hyper-v overlay pages.
> > > 
> > > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > 
> > This patch will break bisection, because we're no longer handling the writes
> > in kernel space after this, but we also don't have user space handling
> > available yet, right? It might be better to move all logic in this patch
> > that sets up the filter for Hyper-V MSRs into the next one.
> 
> Yes, that's correct. I'll just bounce back all reads/writes to KVM. That
> should maintain the existing behaviour.

Okay, bouncing back to KVM was a bad idea :). Moved filters to next
patch as suggested.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



