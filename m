Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4256826AE0A
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgIOTtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:49:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727840AbgIORLK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 13:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600189816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yPmPv3nS4j+ToD69H4u95r5JbLwmp3gKNTOHEJVtB3U=;
        b=PCpPOkqcyphNsp5bCIefPfvgAaskIZWKeoUNvpHkPMKWQrd9pBHB9dD8nPxbhYJXSc1DFD
        Wl63+ymAhRB8e9Qt4lRTNQsfiONDzRA7X9ZvxGmBc/5d/FhkEq2/h6ErqPhj9UCiH72mPe
        IbDlzpFHBHE/wJ1R7u5JXslorL43Jjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-I4E89CNxMemVJZk38H5rlQ-1; Tue, 15 Sep 2020 12:51:54 -0400
X-MC-Unique: I4E89CNxMemVJZk38H5rlQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48AEA18C9F57;
        Tue, 15 Sep 2020 16:51:36 +0000 (UTC)
Received: from work-vm (ovpn-115-25.ams2.redhat.com [10.36.115.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 758F719D61;
        Tue, 15 Sep 2020 16:51:34 +0000 (UTC)
Date:   Tue, 15 Sep 2020 17:51:31 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, Wei Huang <whuang2@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
Message-ID: <20200915165131.GC2922@work-vm>
References: <20200915154306.724953-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915154306.724953-1-vkuznets@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for
> KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
> from '40' in 2010. We can, of course, just bump it a little bit to fix
> the immediate issue but the report made me wonder why we need to pre-
> allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
> This RFC is intended to feed my curiosity.
> 
> Very mildly tested with selftests/kvm-unit-tests and nothing seems to
> break. I also don't have access to the system where the original issue
> was reported but chances we're fixing it are very good IMO as just the
> second patch alone was reported to be sufficient.
> 
> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Oh nice, I was just going to bump the magic number :-)

Anyway, this seems to work for me, so:

Tested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> Vitaly Kuznetsov (2):
>   KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
>   KVM: x86: bump KVM_MAX_CPUID_ENTRIES
> 
>  arch/x86/include/asm/kvm_host.h |  4 +--
>  arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
>  arch/x86/kvm/x86.c              |  1 +
>  3 files changed, 43 insertions(+), 17 deletions(-)
> 
> -- 
> 2.25.4
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

