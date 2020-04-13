Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389B61A6C0B
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 20:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgDMS1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 14:27:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387716AbgDMS1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 14:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586802432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LE4Q5pv4+ttMd6fa4HJ5hzCrYdDEL+fHTEMdK/F84bA=;
        b=eMkHGOpOi+jRBi687vaWtkk0VKX11yeZU3dbIYmVj+KXs5r/9hyhfE1RzQFGcu0T4d05VY
        fyz2aPgLIy/y6GqtdsxRJOe1jK/GFbTMn6J/ucnkJvOtC2KBlh3JxaIiLNyCqiEa+rgVgi
        w4OB462i7P3R9r9AA9tF6XNsMWZgQ3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-fywtPCKvPym3A9psr-clxg-1; Mon, 13 Apr 2020 14:27:09 -0400
X-MC-Unique: fywtPCKvPym3A9psr-clxg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE9EF18FE861;
        Mon, 13 Apr 2020 18:27:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD0CA5D9CD;
        Mon, 13 Apr 2020 18:26:57 +0000 (UTC)
Subject: Re: [PATCH 01/10] KVM: selftests: Take vcpu pointer instead of id in
 vm_vcpu_rm()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-2-sean.j.christopherson@intel.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <b696c5b9-2507-8849-e196-37c83806cfdf@redhat.com>
Date:   Mon, 13 Apr 2020 15:26:55 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200410231707.7128-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/10/20 8:16 PM, Sean Christopherson wrote:
> The sole caller of vm_vcpu_rm() already has the vcpu pointer, take it
> directly instead of doing an extra lookup.


Most of (if not all) vcpu related functions in kvm_util.c receives an 
id, so this change creates an inconsistency.

Disregarding the above comment, the changes look good to me. So:

Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>


>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8a3523d4434f..9a783c20dd26 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -393,7 +393,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>    *
>    * Input Args:
>    *   vm - Virtual Machine
> - *   vcpuid - VCPU ID
> + *   vcpu - VCPU to remove
>    *
>    * Output Args: None
>    *
> @@ -401,9 +401,8 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>    *
>    * Within the VM specified by vm, removes the VCPU given by vcpuid.
>    */
> -static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcpuid)
> +static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>   {
> -	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
>   	int ret;
>   
>   	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> @@ -427,7 +426,7 @@ void kvm_vm_release(struct kvm_vm *vmp)
>   	int ret;
>   
>   	while (vmp->vcpu_head)
> -		vm_vcpu_rm(vmp, vmp->vcpu_head->id);
> +		vm_vcpu_rm(vmp, vmp->vcpu_head);
>   
>   	ret = close(vmp->fd);
>   	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"

