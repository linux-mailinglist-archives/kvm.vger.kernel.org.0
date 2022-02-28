Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239294C7198
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 17:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiB1QT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 11:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbiB1QT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 11:19:56 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E3177A80;
        Mon, 28 Feb 2022 08:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646065158; x=1677601158;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=nuDeOFaJNlRBV4P1ndkgyZepMmO9NQKWTosR7KVws24=;
  b=Tci81zigA/k4vnoTxzqzSlIh2pYCBG5y0LEFRmSCrpg2UwH0yrjOv1Zf
   gFwUmnD+LRnSg7jIgcbkBTPJ3OnqLPNXqw0fzWJXb3yEn16hynVnwcDMo
   SKLd2XZOn3cNJld08YchOm7CtVVlx2N4L2q4gak01VFWmD9Ajxgm87Le/
   A=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="66731059"
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-d14a57da.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 28 Feb 2022 16:18:58 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-d14a57da.us-west-2.amazon.com (Postfix) with ESMTPS id BEBA0839AB;
        Mon, 28 Feb 2022 16:18:56 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.162.207) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 16:18:52 +0000
Date:   Mon, 28 Feb 2022 17:18:48 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <Yhz16F+62fZfQkBN@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
 <871qzrdr6x.fsf@redhat.com>
 <f398b5de-c867-98a4-a716-b18939cfd0ef@redhat.com>
 <YhypT9pGu600wRLf@147dda3edfb6.ant.amazon.com>
 <87sfs3cko5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87sfs3cko5.fsf@redhat.com>
X-Originating-IP: [10.43.162.207]
X-ClientProxiedBy: EX13D47UWC004.ant.amazon.com (10.43.162.74) To
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

On Mon, Feb 28, 2022 at 12:09:14PM +0100, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > On Fri, Feb 25, 2022 at 02:17:04PM +0100, Paolo Bonzini wrote:
> >> On 2/25/22 14:13, Vitaly Kuznetsov wrote:
> >> > Let's say we have 1 half of XMM0 consumed. Now:
> >> >
> >> >   i = 0;
> >> >   j = 1;
> >> >   if (1)
> >> >       sparse_banks[0] = sse128_lo(hc->xmm[0]);
> >> >
> >> >   This doesn't look right as we need to get the upper half of XMM0.
> >> >
> >> >   I guess it should be reversed,
> >> >
> >> >       if (j % 2)
> >> >           sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
> >> >       else
> >> >           sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
> >
> > Maybe I am missing parts of this series.. I dont see this change in any
> > of the 4 patches Vitaly sent. Yes, they look swapped to me too.
> >
> 
> There was a conflict with a patch series from Sean:
> https://lore.kernel.org/kvm/20211207220926.718794-1-seanjc@google.com/
> 
> and this is a part of the resolution:
> 
> commit c0f1eaeb9e628bf86bf50f11cb4a2b671528391e
> Merge: 4dfc4ec2b7f5 47d3e5cdfe60
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Fri Feb 25 06:28:10 2022 -0500
> 
>     Merge branch 'kvm-hv-xmm-hypercall-fixes' into HEAD

Got it, thank you!

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



