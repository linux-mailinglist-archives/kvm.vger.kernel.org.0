Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E731278BD
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 11:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfLTKFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 05:05:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfLTKFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 05:05:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576836300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvzvT9KTfyHDuiqD0CTUkv7t6l7JQ96ZSNVZ4d8CIR8=;
        b=JDIe9Q96TibzSJ0B5gco8g9cXQpCfAs9Inl7IzZ2jxRWc9H96nJXhhuJNut0SVFo0IxGm9
        P5ZKR0d74k7vIOUQtaFQ1aQo/3op6tlfTC4vZ/wAplIQYYIJV3rkw2Z/mVtoWuQNl+Qiya
        V1BiVxfG0w1cR3z9DCz0mpCzOugbgt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-Z1PL8IVtM1GYv6o7quyz3w-1; Fri, 20 Dec 2019 05:04:56 -0500
X-MC-Unique: Z1PL8IVtM1GYv6o7quyz3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D83A911F0;
        Fri, 20 Dec 2019 10:04:54 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB85060C18;
        Fri, 20 Dec 2019 10:04:47 +0000 (UTC)
Date:   Fri, 20 Dec 2019 11:04:45 +0100
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
Subject: Re: [PATCH v2 35/45] KVM: s390: Manually invoke vcpu setup during
 kvm_arch_vcpu_create()
Message-ID: <20191220110445.3a42041a.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-36-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-36-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:20 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Rename kvm_arch_vcpu_setup() to kvm_s390_vcpu_setup() and manually call
> the new function during kvm_arch_vcpu_create().  Define an empty
> kvm_arch_vcpu_setup() as it's still required for compilation.  This
> is effectively a nop as kvm_arch_vcpu_create() and kvm_arch_vcpu_setup()
> are called back-to-back by common KVM code.  Obsoleting
> kvm_arch_vcpu_setup() paves the way for its removal.
> 
> Note, gmap_remove() is now called if setup fails, as s390 was previously
> freeing it via kvm_arch_vcpu_destroy(), which is called by common KVM
> code if kvm_arch_vcpu_setup() fails.

Yes, this looks like the only thing that needs to be undone
(sca_add_vcpu() is done later in the process.)

Maybe mention that gmap_remove() is for ucontrol only? I was confused
for a moment :)


> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

