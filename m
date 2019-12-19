Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB5126E3B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLSTvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:51:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727144AbfLSTvr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Dec 2019 14:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576785106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdgAOpOdKbBtqr3OQnzNVIAPVkSgqeU/JucweY0YpHE=;
        b=TNm6MsJfxRJb5oiyQhjUgCPKbD603ugqcrTrQXtSgFOi/aQlKBvZ2KqhM+Md5c6a0Tr9lV
        hTldD4fIvYEAYMM0uuvst3QzYRMMcncoYkJixXNVKcCYmTOhMgvZeNBGEnaymcQoFn8523
        0nxYFwAJAX5swiddgtchCQIQNDbvJcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-UITzEVvuN-WPr6RurqVhDA-1; Thu, 19 Dec 2019 14:51:45 -0500
X-MC-Unique: UITzEVvuN-WPr6RurqVhDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD524800053;
        Thu, 19 Dec 2019 19:51:42 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D3D226E73;
        Thu, 19 Dec 2019 19:51:35 +0000 (UTC)
Date:   Thu, 19 Dec 2019 20:51:32 +0100
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
Subject: Re: [PATCH v2 29/45] KVM: Introduce kvm_vcpu_destroy()
Message-ID: <20191219205132.32d401f6.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-30-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-30-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:14 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Add kvm_vcpu_destroy() and wire up all architectures to call the common
> function instead of their arch specific implementation.  The common
> destruction function will be used by future patches to move allocation
> and initialization of vCPUs to common KVM code, i.e. to free resources
> that are allocated by arch agnostic code.
> 
> No functional change intended.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       | 2 +-
>  arch/powerpc/kvm/powerpc.c | 2 +-
>  arch/s390/kvm/kvm-s390.c   | 2 +-
>  arch/x86/kvm/x86.c         | 2 +-
>  include/linux/kvm_host.h   | 1 +
>  virt/kvm/arm/arm.c         | 2 +-
>  virt/kvm/kvm_main.c        | 6 ++++++
>  7 files changed, 12 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

