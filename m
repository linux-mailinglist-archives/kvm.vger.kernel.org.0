Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CDF0692
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 21:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfKEUCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 15:02:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfKEUCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 15:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H/dYoQ6EYSTyHEkTfrriS/8wjZi/j0OOZ1nG2O1A5Ao=; b=GVPdRQNbeOoOPn1pZhwAL0IDm
        VGgP98Xwj7U6ZTtUnRQexz0jLvD0+WGdjUCqcJWlxrUmYJRdtriu+Azz1dFTSDSPhY+xTenn4+HH7
        js2FTWvcK2W9KxLX1Ivml+4tPJ6cCxw3TRl92sXCKERaa/lfN9hvWGfzAyC3Idi68oUOi2PFxpxYN
        ykz+2T+3E7Aw7s6Oadqth7xEQfKS3w1XhCGyXH+aQ0U3+ldTfp4mS4tiVOf6G7pLjtyZpGk0/fktH
        n9GIXkfjW5eyXagHdUTto7iBGkwQr9JRMid9+ZUwAf+nVNpaLfxFp7di8AGdWh1h9rNt7HmAfv+pW
        QcSOy+zUA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iS51w-0004ZU-BI; Tue, 05 Nov 2019 20:02:20 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 53038980D26; Tue,  5 Nov 2019 21:02:18 +0100 (CET)
Date:   Tue, 5 Nov 2019 21:02:18 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
Message-ID: <20191105200218.GF3079@worktop.programming.kicks-ass.net>
References: <20191105161737.21395-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105161737.21395-1-vkuznets@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 05, 2019 at 05:17:37PM +0100, Vitaly Kuznetsov wrote:
> Virtualized guests may pick a different strategy to mitigate hardware
> vulnerabilities when it comes to hyper-threading: disable SMT completely,
> use core scheduling, or, for example, opt in for STIBP. Making the
> decision, however, requires an extra bit of information which is currently
> missing: does the topology the guest see match hardware or if it is 'fake'
> and two vCPUs which look like different cores from guest's perspective can
> actually be scheduled on the same physical core. Disabling SMT or doing
> core scheduling only makes sense when the topology is trustworthy.
> 
> Add two feature bits to KVM: KVM_FEATURE_TRUSTWORTHY_SMT with the meaning
> that KVM_HINTS_TRUSTWORTHY_SMT bit answers the question if the exposed SMT
> topology is actually trustworthy. It would, of course, be possible to get
> away with a single bit (e.g. 'KVM_FEATURE_FAKE_SMT') and not lose backwards
> compatibility but the current approach looks more straightforward.

The only way virt topology can make any sense what so ever is if the
vcpus are pinned to physical CPUs.

And I was under the impression we already had a bit for that (isn't it
used to disable paravirt spinlocks and the like?). But I cannot seem to
find it in a hurry.

So I would much rather you have a bit that indicates the 1:1 vcpu/cpu
mapping and if that is set accept the topology information and otherwise
completely ignore it.
