Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432174C68A5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiB1Ky7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiB1Kyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:54:40 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24D46E79C;
        Mon, 28 Feb 2022 02:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646045529; x=1677581529;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=GYZ36Tn4ZR/Fb48Zxcj7jLlzc/ynK1FlIUH6hyDN1O0=;
  b=DfHzcu1cS7XzLWzhivBznGNo6hS/okLs7cI5N57EgBhGxex5Zw9nMjf3
   tHoteIHy6Jy7fvfE2mAdwaW+WQj6ng1Ad5vi18qpe47w7GaT8sAsmiDLV
   A3GeMIiSV9C1x00ngWCTzrIFx0CMxcCsGjHTura+U4qCUI/jqIu4g5LOf
   M=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="66672745"
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 28 Feb 2022 10:52:08 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id 8C9B38728E;
        Mon, 28 Feb 2022 10:52:07 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.160.6) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 10:52:04 +0000
Date:   Mon, 28 Feb 2022 11:52:00 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>, <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <YhypT9pGu600wRLf@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
 <871qzrdr6x.fsf@redhat.com>
 <f398b5de-c867-98a4-a716-b18939cfd0ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f398b5de-c867-98a4-a716-b18939cfd0ef@redhat.com>
X-Originating-IP: [10.43.160.6]
X-ClientProxiedBy: EX13D46UWC004.ant.amazon.com (10.43.162.173) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 02:17:04PM +0100, Paolo Bonzini wrote:
> On 2/25/22 14:13, Vitaly Kuznetsov wrote:
> > Let's say we have 1 half of XMM0 consumed. Now:
> > 
> >   i = 0;
> >   j = 1;
> >   if (1)
> >       sparse_banks[0] = sse128_lo(hc->xmm[0]);
> > 
> >   This doesn't look right as we need to get the upper half of XMM0.
> > 
> >   I guess it should be reversed,
> > 
> >       if (j % 2)
> >           sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
> >       else
> >           sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);

Maybe I am missing parts of this series.. I dont see this change in any
of the 4 patches Vitaly sent. Yes, they look swapped to me too.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



