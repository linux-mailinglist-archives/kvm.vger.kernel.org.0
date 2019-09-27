Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95808C0839
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfI0PCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:02:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:61826 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbfI0PCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:02:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 08:02:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="196740404"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 08:02:19 -0700
Date:   Fri, 27 Sep 2019 08:02:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always write vmcs02.GUEST_CR3 during
 nested VM-Enter
Message-ID: <20190927150219.GB25513@linux.intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com>
 <20190926214302.21990-2-sean.j.christopherson@intel.com>
 <68340081-0094-4A74-9B33-3431F39659AA@oracle.com>
 <20190927142725.GC24889@linux.intel.com>
 <EF5C03E7-E3C2-4372-955C-06FB416EB164@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EF5C03E7-E3C2-4372-955C-06FB416EB164@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 05:44:53PM +0300, Liran Alon wrote:
> 
> > On 27 Sep 2019, at 17:27, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > On Fri, Sep 27, 2019 at 03:06:02AM +0300, Liran Alon wrote:
> >> 
> >>> On 27 Sep 2019, at 0:43, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >>> 
> >>> +	/*
> >>> +	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
> >>> +	 * on nested VM-Exit, which can occur without actually running L2, e.g.
> >>> +	 * if L2 is entering HLT state, and thus without hitting vmx_set_cr3().
> >>> +	 */
> >> 
> >> If I understand correctly, it’s not exactly if L2 is entering HLT state in
> >> general.  (E.g. issue doesn’t occur if L2 runs HLT directly which is not
> >> configured to be intercepted by vmcs12).  It’s specifically when L1 enters L2
> >> with a HLT guest-activity-state. I suggest rephrasing comment.
> > 
> > I deliberately worded the comment so that it remains valid if there are
> > more conditions in the future that cause KVM to skip running L2.  What if
> > I split the difference and make the changelog more explicit, but leave the
> > comment as is?
> 
> I think what is confusing in comment is that it seems to also refer to the case
> where L2 directly enters HLT state without L1 intercept. Which isn’t related.
> So I would explicitly mention it’s when L1 enters L2 but don’t physically enter guest
> with vmcs02 because L2 is in HLT state.

Ah, gotcha, I'll tweak the wording.
