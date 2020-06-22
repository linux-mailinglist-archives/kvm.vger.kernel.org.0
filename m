Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480A2203A56
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgFVPI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:08:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728070AbgFVPI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 11:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592838534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8oYy1vMMnjlXkMb5KlFpnjM4vXTLr/ztYLaDLjnq9SQ=;
        b=WBirnmPmqU6xf1r8vS0AnU/j/OR9pOcv9wQ6SzjpOBqg3/K7EWTIZj43b1sOA6HHFHQ+da
        VMLtpMLIZLmL6ebssMNLNr4l4k8F8XpFqIieY1ScWfUSHJ8uZBm9JyKN8KuWt/ZSYuEwzd
        qJIdUW5n4F9G8X5y4G1MEhVYRlREjOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-lgkvb_vvOFO-c3s33FNbMw-1; Mon, 22 Jun 2020 11:08:50 -0400
X-MC-Unique: lgkvb_vvOFO-c3s33FNbMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0247D1006B0C;
        Mon, 22 Jun 2020 15:08:45 +0000 (UTC)
Received: from ovpn-115-200.ams2.redhat.com (ovpn-115-200.ams2.redhat.com [10.36.115.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28B015C1BD;
        Mon, 22 Jun 2020 15:08:38 +0000 (UTC)
Message-ID: <a5793938619c1c328b8283aab90166e352071317.camel@redhat.com>
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
From:   Mohammed Gamal <mgamal@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
Date:   Mon, 22 Jun 2020 17:08:36 +0200
In-Reply-To: <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
References: <20200619153925.79106-1-mgamal@redhat.com>
         <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-06-19 at 16:52 -0500, Tom Lendacky wrote:
> On 6/19/20 10:39 AM, Mohammed Gamal wrote:
> > When EPT/NPT is enabled, KVM does not really look at guest physical
> > address size. Address bits above maximum physical memory size are
> > reserved.
> > Because KVM does not look at these guest physical addresses, it
> > currently
> > effectively supports guest physical address sizes equal to the
> > host.
> > 
> > This can be problem when having a mixed setup of machines with 5-
> > level page
> > tables and machines with 4-level page tables, as live migration can
> > change
> > MAXPHYADDR while the guest runs, which can theoretically introduce
> > bugs.
> > 
> > In this patch series we add checks on guest physical addresses in
> > EPT
> > violation/misconfig and NPF vmexits and if needed inject the proper
> > page faults in the guest.
> > 
> > A more subtle issue is when the host MAXPHYADDR is larger than that
> > of the
> > guest. Page faults caused by reserved bits on the guest won't cause
> > an EPT
> > violation/NPF and hence we also check guest MAXPHYADDR and add
> > PFERR_RSVD_MASK
> > error code to the page fault if needed.
> 
> I'm probably missing something here, but I'm confused by this
> statement. 
> Is this for a case where a page has been marked not present and the
> guest 
> has also set what it believes are reserved bits? Then when the page
> is 
> accessed, the guest sees a page fault without the error code for
> reserved 
> bits? If so, my understanding is that is architecturally correct. P=0
> is 
> considered higher priority than other page faults, at least on AMD.
> So if 
> you have a P=0 and other issues exist within the PTE, AMD will report
> the 
> P=0 fault and that's it.
> 
> The priority of other page fault conditions when P=1 is not defined
> and I 
> don't think we guarantee that you would get all error codes on
> fault. 
> Software is always expected to address the page fault and retry, and
> it 
> may get another page fault when it does, with a different error
> code. 
> Assuming the other errors are addressed, eventually the reserved
> bits 
> would cause an NPF and that could be detected by the HV and handled 
> appropriately.
> 
> > The last 3 patches (i.e. SVM bits and patch 11) are not intended
> > for
> > immediate inclusion and probably need more discussion.
> > We've been noticing some unexpected behavior in handling NPF
> > vmexits
> > on AMD CPUs (see individual patches for details), and thus we are
> > proposing a workaround (see last patch) that adds a capability that
> > userspace can use to decide who to deal with hosts that might have
> > issues supprting guest MAXPHYADDR < host MAXPHYADDR.
> 
> Also, something to consider. On AMD, when memory encryption is
> enabled 
> (via the SYS_CFG MSR), a guest can actually have a larger MAXPHYADDR
> than 
> the host. How do these patches all play into that?

Well the patches definitely don't address that case. It's assumed a
guest VM's MAXPHYADDR <= host MAXPHYADDR, and hence we handle the case
where a guests's physical address space is smaller and try to trap
faults that may go unnoticed by the host.

My question is in the case of guest MAXPHYADDR > host MAXPHYADDR, do we
expect somehow that there might be guest physical addresses that
contain what the host could see as reserved bits? And how'd the host
handle that?

Thanks,
Mohammed

> 
> Thanks,
> Tom
> 
> > 
> > Mohammed Gamal (7):
> >    KVM: x86: Add helper functions for illegal GPA checking and page
> > fault
> >      injection
> >    KVM: x86: mmu: Move translate_gpa() to mmu.c
> >    KVM: x86: mmu: Add guest physical address check in
> > translate_gpa()
> >    KVM: VMX: Add guest physical address check in EPT violation and
> >      misconfig
> >    KVM: SVM: introduce svm_need_pf_intercept
> >    KVM: SVM: Add guest physical address check in NPF/PF
> > interception
> >    KVM: x86: SVM: VMX: Make GUEST_MAXPHYADDR < HOST_MAXPHYADDR
> > support
> >      configurable
> > 
> > Paolo Bonzini (4):
> >    KVM: x86: rename update_bp_intercept to update_exception_bitmap
> >    KVM: x86: update exception bitmap on CPUID changes
> >    KVM: VMX: introduce vmx_need_pf_intercept
> >    KVM: VMX: optimize #PF injection when MAXPHYADDR does not match
> > 
> >   arch/x86/include/asm/kvm_host.h | 10 ++------
> >   arch/x86/kvm/cpuid.c            |  2 ++
> >   arch/x86/kvm/mmu.h              |  6 +++++
> >   arch/x86/kvm/mmu/mmu.c          | 12 +++++++++
> >   arch/x86/kvm/svm/svm.c          | 41 +++++++++++++++++++++++++++-
> > --
> >   arch/x86/kvm/svm/svm.h          |  6 +++++
> >   arch/x86/kvm/vmx/nested.c       | 28 ++++++++++++--------
> >   arch/x86/kvm/vmx/vmx.c          | 45
> > +++++++++++++++++++++++++++++----
> >   arch/x86/kvm/vmx/vmx.h          |  6 +++++
> >   arch/x86/kvm/x86.c              | 29 ++++++++++++++++++++-
> >   arch/x86/kvm/x86.h              |  1 +
> >   include/uapi/linux/kvm.h        |  1 +
> >   12 files changed, 158 insertions(+), 29 deletions(-)
> > 

