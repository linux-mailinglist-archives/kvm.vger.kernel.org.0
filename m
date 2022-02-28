Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44DD4C6761
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiB1Kt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiB1KtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:49:24 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B894DF7B;
        Mon, 28 Feb 2022 02:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646045327; x=1677581327;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=wtlDx4jEE4jGyIxehaIcjYydOOp8V9gGqhKFY2pAxek=;
  b=lmL4Ao9d38OqN10++Ib0UXf3kdMmNoqbjsuluw2oVu3tHXIvYLaUfibB
   IN4HN4RzlUON9BAsTufdAkmAydE4rjHJ/7D3bXWQ9qqqWsJLD3XhNq/uo
   v9EweWB5T07szzF4GFFgGyveMxUMRbdb0SklTouSGDor41wh9xdsBB09X
   U=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="181712404"
Subject: Re: [PATCH 4/4] KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast
 hypercall
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 28 Feb 2022 10:48:36 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id 0220F829DD;
        Mon, 28 Feb 2022 10:48:34 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.160.103) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 10:48:30 +0000
Date:   Mon, 28 Feb 2022 11:48:26 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <YhyoevsjEhNfcwWY@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220222154642.684285-5-vkuznets@redhat.com>
X-Originating-IP: [10.43.160.103]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 04:46:42PM +0100, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> It has been proven on practice that at least Windows Server 2019 tries
> using HVCALL_SEND_IPI_EX in 'XMM fast' mode when it has more than 64 vCPUs
> and it needs to send an IPI to a vCPU > 63. Similarly to other XMM Fast
> hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}{,_EX}), this
> information is missing in TLFS as of 6.0b. Currently, KVM returns an error
> (HV_STATUS_INVALID_HYPERCALL_INPUT) and Windows crashes.
> 
> Note, HVCALL_SEND_IPI is a 'standard' fast hypercall (not 'XMM fast') as
> all its parameters fit into RDX:R8 and this is handled by KVM correctly.
> 
> Fixes: d8f5537a8816 ("KVM: hyper-v: Advertise support for fast XMM hypercalls")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Siddharth Chandrasekaran <sidcha@amazon.de>



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



