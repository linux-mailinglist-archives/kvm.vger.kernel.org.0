Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4017F195
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 09:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgCJITJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 04:19:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbgCJITI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 04:19:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583828347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xbuHU0xN5Ght7n+PdULeJ6invpYq6mKCHrnk/0n8BPo=;
        b=gsZYTU2AS8GZm83u22CBuU0QCzG3nmNn2J3PSMs6c8o/Rbp36fi1BpdNlyqAUpODy2Hkrp
        Jk0ncKS2sm+cw4eo07yAh8tNADPVbKMeGlsqHbo3tiP8oqqW/jXxm7V9u4yyPsiq3NNMPA
        9gJWc01Oh4zf8ub2WHA7yWoThO1gl4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-XomxSUiwOpeFJNb3HQ-B_A-1; Tue, 10 Mar 2020 04:19:05 -0400
X-MC-Unique: XomxSUiwOpeFJNb3HQ-B_A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA7D1405;
        Tue, 10 Mar 2020 08:19:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7167F28980;
        Tue, 10 Mar 2020 08:18:49 +0000 (UTC)
Date:   Tue, 10 Mar 2020 09:18:47 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v6 12/14] KVM: selftests: Add dirty ring buffer test
Message-ID: <20200310081847.42sx5oc3q6m3wsdj@kamzik.brq.redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309222529.345699-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309222529.345699-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 06:25:29PM -0400, Peter Xu wrote:
> +void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
> +{
> +	struct vcpu *vcpu;
> +	uint32_t size = vm->dirty_ring_size;
> +
> +	TEST_ASSERT(size > 0, "Should enable dirty ring first");
> +
> +	vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
> +
> +	if (!vcpu->dirty_gfns) {
> +		void *addr;
> +
> +		addr = mmap(NULL, size, PROT_READ,
> +			    MAP_PRIVATE, vcpu->fd,
> +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
> +		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped private");
> +
> +		addr = mmap(NULL, size, PROT_READ | PROT_EXEC,
> +			    MAP_PRIVATE, vcpu->fd,
> +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);
> +		TEST_ASSERT(addr == MAP_FAILED, "Dirty ring mapped exec");
> +
> +		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
> +			    MAP_SHARED, vcpu->fd,
> +			    vm->page_size * KVM_DIRTY_LOG_PAGE_OFFSET);

No TEST_ASSERT for this mmap?

> +
> +		vcpu->dirty_gfns = addr;
> +		vcpu->dirty_gfns_count = size / sizeof(struct kvm_dirty_gfn);
> +	}
> +
> +	return vcpu->dirty_gfns;
> +}

