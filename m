Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8339D2860D0
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgJGOCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 10:02:15 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:10885 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbgJGOCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 10:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602079335; x=1633615335;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dFl7xuD4GDwohFhExL3X3RMLZwtA4a2j71AUtiyNSK0=;
  b=tz5Yt8rI3KHvC5fIBN8ihwWjXWSQFHNHlkc9pcGyh9S+Uo+zHUtaxh9P
   tXcjRPm4PkIikBhjc42Mn7GtBaFilH/wbC4ZasVM6TehEgbYVUjUP349U
   RIRdlt0gTD50gSzq9gqkij+0TWOI1DP7Ioyry/WlFMuXuaFYZwpskGx93
   A=;
X-IronPort-AV: E=Sophos;i="5.77,347,1596499200"; 
   d="scan'208";a="58561326"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Oct 2020 14:02:06 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 771E3A2056;
        Wed,  7 Oct 2020 14:02:04 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 14:02:04 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.64) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 14:02:01 +0000
Subject: Re: [PATCH 2/2] KVM: VMX: Ignore userspace MSR filters for x2APIC
 when APICV is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>
References: <20201005195532.8674-1-sean.j.christopherson@intel.com>
 <20201005195532.8674-3-sean.j.christopherson@intel.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <bcb15eb1-8d3e-ff6d-d11f-667884584f1f@amazon.com>
Date:   Wed, 7 Oct 2020 16:01:59 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005195532.8674-3-sean.j.christopherson@intel.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.64]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.10.20 21:55, Sean Christopherson wrote:
> =

> Rework the resetting of the MSR bitmap for x2APIC MSRs to ignore
> userspace filtering when APICV is enabled.  Allowing userspace to
> intercept reads to x2APIC MSRs when APICV is fully enabled for the guest
> simply can't work.   The LAPIC and thus virtual APIC is in-kernel and
> cannot be directly accessed by userspace.  If userspace wants to
> intercept x2APIC MSRs, then it should first disable APICV.
> =

> Opportunistically change the behavior to reset the full range of MSRs if
> and only if APICV is enabled for KVM.  The MSR bitmaps are initialized
> to intercept all reads and writes by default, and enable_apicv cannot be
> toggled after KVM is loaded.  I.e. if APICV is disabled, simply toggle
> the TPR MSR accordingly.
> =

> Note, this still allows userspace to intercept reads and writes to TPR,
> and writes to EOI and SELF_IPI.  It is at least plausible userspace
> interception could work for those registers, though it is still silly.
> =

> Cc: Alexander Graf <graf@amazon.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I'm not opposed in general to leaving APICV handled registers out of the =

filtering logic. However, this really needs a note in the documentation =

then, no?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



