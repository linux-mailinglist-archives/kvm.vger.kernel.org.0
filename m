Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AFF128043
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfLTQDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 11:03:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727381AbfLTQC7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 11:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576857779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Limel4VO1ZO8KIpqt7RZ5ENsq2TZL0E/VYpHsSOkzgY=;
        b=eF++EM3PKBb+GS+33uHkDobPJsw/nO5fOLSXQJbwJOd+sARaj0CYHbvN5AoXDWbDDsAtWX
        /JvkrcM8KtHXDX8RwZAxtNKhlmWdr7gbOainPe1nLuelkoRZKyAycuoc6FYwXdVVMYDAfm
        klRc9ja6g8Ul+IRTes21pB5sWTPs2ws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-b1Oxt-77Nh-zF7_6vmGaow-1; Fri, 20 Dec 2019 11:02:57 -0500
X-MC-Unique: b1Oxt-77Nh-zF7_6vmGaow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92EE2107ACCC;
        Fri, 20 Dec 2019 16:02:54 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC82560BF3;
        Fri, 20 Dec 2019 16:02:48 +0000 (UTC)
Date:   Fri, 20 Dec 2019 17:02:46 +0100
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
Message-ID: <20191220170246.76ba681a.cohuck@redhat.com>
In-Reply-To: <20191220155607.GB20453@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-36-sean.j.christopherson@intel.com>
        <20191220110445.3a42041a.cohuck@redhat.com>
        <20191220155607.GB20453@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 07:56:07 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Fri, Dec 20, 2019 at 11:04:45AM +0100, Cornelia Huck wrote:
> > On Wed, 18 Dec 2019 13:55:20 -0800
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >   
> > > Rename kvm_arch_vcpu_setup() to kvm_s390_vcpu_setup() and manually call
> > > the new function during kvm_arch_vcpu_create().  Define an empty
> > > kvm_arch_vcpu_setup() as it's still required for compilation.  This
> > > is effectively a nop as kvm_arch_vcpu_create() and kvm_arch_vcpu_setup()
> > > are called back-to-back by common KVM code.  Obsoleting
> > > kvm_arch_vcpu_setup() paves the way for its removal.
> > > 
> > > Note, gmap_remove() is now called if setup fails, as s390 was previously
> > > freeing it via kvm_arch_vcpu_destroy(), which is called by common KVM
> > > code if kvm_arch_vcpu_setup() fails.  
> > 
> > Yes, this looks like the only thing that needs to be undone
> > (sca_add_vcpu() is done later in the process.)
> > 
> > Maybe mention that gmap_remove() is for ucontrol only? I was confused
> > for a moment :)  
> 
> Will do.
> 
> Would it also make sense to open code __kvm_ucontrol_vcpu_init() in a
> separate patch immediately preceding this change?  That'd make it a little
> more obvious why gmap_remove() is called, and it would eliminate the
> "uninit" verbiage in the label, e.g.:

I'm a bit undecided here; especially as I'm not sure if there are any
future plans with ucontrol. I'll leave that for Christian and Janosch
to decide.

