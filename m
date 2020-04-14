Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7031A8411
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388068AbgDNQDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:03:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29958 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728540AbgDNQDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586880193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0DRJu6S7NO8P/54MkunY2BJyUaaOoGwDBAo8xy+uwXA=;
        b=JVEiqEpIRffp2YZqTbkoEXm7Eo3d9CvFrhtNOVjsJRleIhB/NSbuOBG8XWhN3jeAKCZMLH
        uqh6E7hljIqLpxurmgCE6kRFDK7Z9+gtNDK4mDZHkVtGKB+AZ/KvZaYE2VDC+gERTy4EmA
        +dJvWNhajO+WuHlwd8z8q/qdYNgAQ4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-0I89OzOXOGWoHGikds0Gjw-1; Tue, 14 Apr 2020 12:03:11 -0400
X-MC-Unique: 0I89OzOXOGWoHGikds0Gjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CECC801FA1;
        Tue, 14 Apr 2020 16:03:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A365B99DFD;
        Tue, 14 Apr 2020 16:02:58 +0000 (UTC)
Date:   Tue, 14 Apr 2020 18:02:55 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: Re: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in
 vm_vcpu_rm()
Message-ID: <20200414160255.b7ftigb3mdfbcmjk@kamzik.brq.redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410231707.7128-2-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 04:16:58PM -0700, Sean Christopherson wrote:
> The sole caller of vm_vcpu_rm() already has the vcpu pointer, take it
> directly instead of doing an extra lookup.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8a3523d4434f..9a783c20dd26 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -393,7 +393,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>   *
>   * Input Args:
>   *   vm - Virtual Machine
> - *   vcpuid - VCPU ID
> + *   vcpu - VCPU to remove
>   *
>   * Output Args: None
>   *
> @@ -401,9 +401,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>   *
>   * Within the VM specified by vm, removes the VCPU given by vcpuid.
>   */
> -static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
> +static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>  {
> -	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
>  	int ret;
>  
>  	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> @@ -427,7 +426,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
>  	int ret;
>  
>  	while (vmp->vcpu_head)
> -		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
> +		vm_vcpu_rm(vmp, vmp->vcpu_head);
>  
>  	ret = close(vmp->fd);
>  	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
> -- 
> 2.26.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

