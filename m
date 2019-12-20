Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB5128039
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 17:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfLTQBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 11:01:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727406AbfLTQBA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 11:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576857659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l025u6fxXKxK3eWge8nzvLZFfpRbb+ibWiXZ7ykWyCA=;
        b=NJ82iblBVbqA1JcHPMCGQhP+QvT8aFrQjddIIzkjfKKhQAKjN6+KZaYahs6b/+ioGFA1pS
        eESPvwJsXoAA4CyyEt2nWR2+1LlLhOYACA8+a2xsj5x7LoodgyG4LjtF8mNt8CppTUpCgq
        0Mf9rCHt85YP91bIZHhvPbbFddv9qKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-uTYIN32MOW6V0xu7MdKMDA-1; Fri, 20 Dec 2019 11:00:58 -0500
X-MC-Unique: uTYIN32MOW6V0xu7MdKMDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 019A6800D48;
        Fri, 20 Dec 2019 16:00:54 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F3DF6046B;
        Fri, 20 Dec 2019 16:00:47 +0000 (UTC)
Date:   Fri, 20 Dec 2019 17:00:45 +0100
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
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20191220170045.725fb05c.cohuck@redhat.com>
In-Reply-To: <20191220155330.GA21021@linux.intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-31-sean.j.christopherson@intel.com>
        <20191220103325.34fc2bf0.cohuck@redhat.com>
        <20191220155330.GA21021@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 07:53:30 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Fri, Dec 20, 2019 at 10:33:25AM +0100, Cornelia Huck wrote:
> > On Wed, 18 Dec 2019 13:55:15 -0800
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:  
> > > +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >  {
> > > -	struct kvm_vcpu *vcpu;
> > >  	struct sie_page *sie_page;
> > >  	int rc;
> > >  
> > > -	rc = -ENOMEM;
> > > -
> > > -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> > > -	if (!vcpu)
> > > -		goto out;
> > > -
> > > -	rc = kvm_vcpu_init(vcpu, kvm, id);
> > > -	if (rc)
> > > -		goto out_free_cpu;
> > > -
> > > -	rc = -ENOMEM;
> > > -
> > >  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
> > >  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
> > >  	if (!sie_page)
> > > -		goto out_uninit_vcpu;
> > > +		return -ENOMEM;
> > >  
> > >  	vcpu->arch.sie_block = &sie_page->sie_block;
> > >  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> > > @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> > >  		 vcpu->arch.sie_block);
> > >  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> > >  
> > > -	return vcpu;
> > > +	return 0;
> > > +
> > >  out_free_sie_block:
> > >  	free_page((unsigned long)(vcpu->arch.sie_block));
> > > -out_uninit_vcpu:
> > > -	kvm_vcpu_uninit(vcpu);
> > > -out_free_cpu:
> > > -	kmem_cache_free(kvm_vcpu_cache, vcpu);
> > > -out:
> > > -	return ERR_PTR(rc);
> > > +	return rc;  
> > 
> > This is getting a bit hard to follow across the patches, but I think rc
> > is now only set for ucontrol guests. So this looks correct right now,
> > but feels a bit brittle... should we maybe init rc to 0 and always
> > return rc instead?  
> 
> Yes, but only for a few patches until kvm_s390_vcpu_setup() is introduced,
> at which point @rc is unconditionally set at the end.

Indeed; so feel free to leave this as-is.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

