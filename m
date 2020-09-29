Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2927C117
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgI2J2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727841AbgI2J2F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 05:28:05 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601371683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYuc3/1S5yymvfflLAL9MMp/Ok6n0ZAyFbN3sbJRaT0=;
        b=Jj/USoMBCSfieJHQR6JlxE4ZFYyfJEkT7W+lnGLf9g4i6cpQj3E+HyuIbaW9/EvlTgKFHt
        CmK98WCW9XLnk4AxKIYN/b6IGN8lPpmOR3GJvS8pHkoo86z7MdLU8q7KCAaR0Taf3TGeyy
        86MYWsKr3Jz3VXqyCi4M/JOhRUYKU64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-qegXtShCOwWT77D3KJtmZg-1; Tue, 29 Sep 2020 05:27:23 -0400
X-MC-Unique: qegXtShCOwWT77D3KJtmZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D80C801ADD;
        Tue, 29 Sep 2020 09:27:21 +0000 (UTC)
Received: from gondolin (ovpn-113-63.ams2.redhat.com [10.36.113.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A67356198B;
        Tue, 29 Sep 2020 09:27:13 +0000 (UTC)
Date:   Tue, 29 Sep 2020 11:27:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 0/3] KVM: Introduce "VM bugged" concept
Message-ID: <20200929112710.3ce1365f.cohuck@redhat.com>
In-Reply-To: <20200923224530.17735-1-sean.j.christopherson@intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Sep 2020 15:45:27 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> This series introduces a concept we've discussed a few times in x86 land.
> The crux of the problem is that x86 has a few cases where KVM could
> theoretically encounter a software or hardware bug deep in a call stack
> without any sane way to propagate the error out to userspace.
> 
> Another use case would be for scenarios where letting the VM live will
> do more harm than good, e.g. we've been using KVM_BUG_ON for early TDX
> enabling as botching anything related to secure paging all but guarantees
> there will be a flood of WARNs and error messages because lower level PTE
> operations will fail if an upper level operation failed.
> 
> The basic idea is to WARN_ONCE if a bug is encountered, kick all vCPUs out
> to userspace, and mark the VM as bugged so that no ioctls() can be issued
> on the VM or its devices/vCPUs.

I think this makes a lot of sense.

Are there other user space interactions where we want to generate an
error for a bugged VM, e.g. via eventfd?

And can we make the 'bugged' information available to user space in a
structured way?

> 
> RFC as I've done nowhere near enough testing to verify that rejecting the
> ioctls(), evicting running vCPUs, etc... works as intended.
> 
> Sean Christopherson (3):
>   KVM: Export kvm_make_all_cpus_request() for use in marking VMs as
>     bugged
>   KVM: Add infrastructure and macro to mark VM as bugged
>   KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the
>     VM
> 
>  arch/x86/kvm/svm/svm.c   |  2 +-
>  arch/x86/kvm/vmx/vmx.c   | 23 ++++++++++++--------
>  arch/x86/kvm/x86.c       |  4 ++++
>  include/linux/kvm_host.h | 45 ++++++++++++++++++++++++++++++++--------
>  virt/kvm/kvm_main.c      | 11 +++++-----
>  5 files changed, 61 insertions(+), 24 deletions(-)
> 

