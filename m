Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2D21278FD
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 11:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfLTKNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 05:13:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20164 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727129AbfLTKNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 05:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576836831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ZBQ5qBfF/8KamOQgNLAI32dbiC3Uea19/Os0WpLjyk=;
        b=HKGMY/dtlrzmVUJyfQ+wdcbcXLmF2nYE4gl2QScbrGIAVKfNgDPzZbEcOdjkzshHyha0gn
        ArSVSoT/ToSU00KnO8mUelG1/kqTpIBeV84vhcoH0kX8da7roe8vKuFk2qPVuCY+KMdyJv
        TgwvRFyV4EOGvt/MlGjXPaesVqy3Woc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-o9p1hEkKN3a2EfGixxaSPw-1; Fri, 20 Dec 2019 05:13:49 -0500
X-MC-Unique: o9p1hEkKN3a2EfGixxaSPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB342800D4C;
        Fri, 20 Dec 2019 10:13:45 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A4706E3F7;
        Fri, 20 Dec 2019 10:13:39 +0000 (UTC)
Date:   Fri, 20 Dec 2019 11:13:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 43/45] KVM: Drop kvm_arch_vcpu_init() and
 kvm_arch_vcpu_uninit()
Message-ID: <20191220111337.6bb2ea3a.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-44-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-44-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:28 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Remove kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit() now that all
> arch specific implementations are nops.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  1 -
>  arch/arm64/include/asm/kvm_host.h |  1 -
>  arch/arm64/kvm/reset.c            |  5 -----
>  arch/mips/kvm/mips.c              | 10 ----------
>  arch/powerpc/kvm/powerpc.c        | 10 ----------
>  arch/s390/include/asm/kvm_host.h  |  1 -
>  arch/s390/kvm/kvm-s390.c          |  5 -----
>  arch/x86/kvm/x86.c                | 10 ----------
>  include/linux/kvm_host.h          |  3 ---
>  virt/kvm/arm/arm.c                |  5 -----
>  virt/kvm/kvm_main.c               | 16 ++--------------
>  11 files changed, 2 insertions(+), 65 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

