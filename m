Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE84C6753
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 11:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiB1KsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 05:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiB1KsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 05:48:23 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A3E110E;
        Mon, 28 Feb 2022 02:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1646045264; x=1677581264;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=Ya3FJTF6XwIuL/RdbakwomCqOiapV+1l4GTq2bNEB8g=;
  b=lQvng5v9PmIpXPeQZorgVHPcv/IV4w4NJwwc00Zez5jXhbJk6xs5BlL0
   4aytnGDqA+s3bxFKnibdxbfBuhsB5XSf606l4YBSHQpr/cu9abl15oFJX
   +n5Uf5LYaJs7wLQPu42kiekXDfRF2hEzcA5XO4tiUbrBS8A/FLvTeskvV
   k=;
X-IronPort-AV: E=Sophos;i="5.90,142,1643673600"; 
   d="scan'208";a="198181420"
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Fix the maximum number of sparse banks
 for XMM fast TLB flush hypercalls
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-98c1c57e.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 28 Feb 2022 10:47:31 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-98c1c57e.us-west-2.amazon.com (Postfix) with ESMTPS id 6F1B3A1A0F;
        Mon, 28 Feb 2022 10:47:29 +0000 (UTC)
Received: from 147dda3edfb6.ant.amazon.com (10.43.160.103) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Mon, 28 Feb 2022 10:47:25 +0000
Date:   Mon, 28 Feb 2022 11:47:21 +0100
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <YhyoOcz2uAvE9jDN@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <20220222154642.684285-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220222154642.684285-4-vkuznets@redhat.com>
X-Originating-IP: [10.43.160.103]
X-ClientProxiedBy: EX13D20UWA001.ant.amazon.com (10.43.160.34) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 04:46:41PM +0100, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> When TLB flush hypercalls (HVCALL_FLUSH_VIRTUAL_ADDRESS_{LIST,SPACE}_EX are
> issued in 'XMM fast' mode, the maximum number of allowed sparse_banks is
> not 'HV_HYPERCALL_MAX_XMM_REGISTERS - 1' (5) but twice as many (10) as each
> XMM register is 128 bit long and can hold two 64 bit long banks.
> 
> Fixes: 5974565bc26d ("KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Indeed :)

Reviewed-by: Siddharth Chandrasekaran <sidcha@amazon.de>



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



