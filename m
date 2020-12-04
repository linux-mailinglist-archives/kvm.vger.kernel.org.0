Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC912CF426
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388050AbgLDSf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:35:27 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50928 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387808AbgLDSf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:35:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607106926; x=1638642926;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=n8HrbMuTop4yd0g61dGGYwLhe8+jyucwsocHC3BNURk=;
  b=tD+3RLztaLhcGsTuwuO3kEsv5wSNQ90KAE3C9R0nrI7Nm7YnTIAMzzw+
   RYo21r38vxlU03E5/vYjQ6sTqjJ2fw7EWm3tRuN7pxCqNEpRdttwL6Sdm
   nAtWaYhnYUkqPYJW4kkh8G+gp+cfdXrjC5GRnqokRbLNRwtx0aRAV74lI
   I=;
X-IronPort-AV: E=Sophos;i="5.78,393,1599523200"; 
   d="scan'208";a="93588276"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Dec 2020 18:34:46 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 5796C2219D5;
        Fri,  4 Dec 2020 18:34:45 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:34:44 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.214) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 18:34:42 +0000
Subject: Re: [PATCH 04/15] KVM: x86/xen: Fix coexistence of Xen and Hyper-V
 hypercalls
To:     David Woodhouse <dwmw2@infradead.org>, <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
 <20201204011848.2967588-5-dwmw2@infradead.org>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <b49acc58-70e0-a684-9457-555b059b4761@amazon.com>
Date:   Fri, 4 Dec 2020 19:34:40 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204011848.2967588-5-dwmw2@infradead.org>
Content-Language: en-US
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D19UWC004.ant.amazon.com (10.43.162.56) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.12.20 02:18, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> =

> Disambiguate Xen vs. Hyper-V calls by adding 'orl $0x80000000, %eax'
> at the start of the Hyper-V hypercall page when Xen hypercalls are
> also enabled.
> =

> That bit is reserved in the Hyper-V ABI, and those hypercall numbers
> will never be used by Xen (because it does precisely the same trick).
> =

> Switch to using kvm_vcpu_write_guest() while we're at it, instead of
> open-coding it.
> =

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

I'm not a big fan of the implicit assumption that "xen hypercall =

enabled" means "this will be the offset". Can we make that something =

more explicit, say through an ENABLE_CAP?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



