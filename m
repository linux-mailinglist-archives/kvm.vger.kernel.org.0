Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0548A1D5AC1
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 22:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEOUd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 16:33:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32654 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbgEOUd6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 16:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589574836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YepsSy2nLjL3UBd0hK7w9B2v+2qjHsLKYJjpSq7VWdI=;
        b=YnXpcSYSI4+F6EqxUNRf5q5tr2HNAnkYwC07qCXu1g/sY52cEaWpC40NGvlhEoT0l9j5rS
        u7j4/KscBWJTnxl7H7oYTLTlOP2yhbog5r1uaU8iN+C5gRi8FjBqFV0qJcYtzCOqvVZAF7
        uzMgCPdnMkpKIGKcuJ0ZWnUBjT8jvlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-77DuAAtVN5i8PC8RuTtcZA-1; Fri, 15 May 2020 16:33:55 -0400
X-MC-Unique: 77DuAAtVN5i8PC8RuTtcZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22339460;
        Fri, 15 May 2020 20:33:53 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-113.rdu2.redhat.com [10.10.114.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86A3A60C05;
        Fri, 15 May 2020 20:33:52 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1E9DD220206; Fri, 15 May 2020 16:33:52 -0400 (EDT)
Date:   Fri, 15 May 2020 16:33:52 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200515203352.GC235744@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
 <20200512152709.GB138129@redhat.com>
 <87o8qtmaat.fsf@vitty.brq.redhat.com>
 <20200512155339.GD138129@redhat.com>
 <20200512175017.GC12100@linux.intel.com>
 <20200513125241.GA173965@redhat.com>
 <0733213c-9514-4b04-6356-cf1087edd9cf@redhat.com>
 <20200515184646.GD17572@linux.intel.com>
 <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d84b6436-9630-1474-52e5-ffcc4d2bd70a@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 09:18:07PM +0200, Paolo Bonzini wrote:
> On 15/05/20 20:46, Sean Christopherson wrote:
> >> The new one using #VE is not coming very soon (we need to emulate it for
> >> <Broadwell and AMD processors, so it's not entirely trivial) so we are
> >> going to keep "page not ready" delivery using #PF for some time or even
> >> forever.  However, page ready notification as #PF is going away for good.
> > 
> > And isn't hardware based EPT Violation #VE going to require a completely
> > different protocol than what is implemented today?  For hardware based #VE,
> > KVM won't intercept the fault, i.e. the guest will need to make an explicit
> > hypercall to request the page.
> 
> Yes, but it's a fairly simple hypercall to implement.
> 
> >> That said, type1/type2 is quite bad. :)  Let's change that to page not
> >> present / page ready.
> > 
> > Why even bother using 'struct kvm_vcpu_pv_apf_data' for the #PF case?  VMX
> > only requires error_code[31:16]==0 and SVM doesn't vet it at all, i.e. we
> > can (ab)use the error code to indicate an async #PF by setting it to an
> > impossible value, e.g. 0xaaaa (a is for async!).  That partciular error code
> > is even enforced by the SDM, which states:
> 
> Possibly, but it's water under the bridge now.
> And the #PF mechanism also has the problem with NMIs that happen before
> the error code is read
> and page faults happening in the handler (you may connect some dots now).

I understood that following was racy.

do_async_page_fault <--- kvm injected async page fault
  NMI happens (Before kvm_read_and_reset_pf_reason() is done)
   ->do_async_page_fault() (This is regular page fault but it will read
   			    reason from shared area and will treat itself
			    as async page fault)

So this is racy.

But if we get rid of the notion of reading from shared region in page
fault handler, will we not get rid of this race.

I am assuming that error_code is not racy as it is pushed on stack.
What am I missing.

Thanks
Vivek

