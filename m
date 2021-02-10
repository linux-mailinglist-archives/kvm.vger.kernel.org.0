Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2B316D0F
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhBJRn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:43:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhBJRnO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 12:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612978908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UAo/ruM3T3lLQNsCNItrj/1VQO1R04osi4hOdZQ+vsc=;
        b=bRZBeubm9KdvKCK5+IzgUnidoQvR3pbpORcZp0Pic1+hh5V2XFmvQ9PDr6bMQGx+K/kUqO
        ihMFfPCX/FrHmz7/6KHRcl+VoiYiuXuSrR9khXim+pv5XvXlSaXkmC08bd54TcxtmoWNeU
        ATj4cQYlZGgdCROt0mLLdK38z9tN6a8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-0LIAk_FwOyO114dpIdI72w-1; Wed, 10 Feb 2021 12:41:44 -0500
X-MC-Unique: 0LIAk_FwOyO114dpIdI72w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFD9B107ACC7;
        Wed, 10 Feb 2021 17:41:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B357D10074FC;
        Wed, 10 Feb 2021 17:41:42 +0000 (UTC)
Date:   Wed, 10 Feb 2021 18:41:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, Steve Rutherford <srutherford@google.com>
Subject: Re: [PATCH] selftests: kvm: Mmap the entire vcpu mmap area
Message-ID: <20210210174138.mgqfjvq63voksd4f@kamzik.brq.redhat.com>
References: <20210210165035.3712489-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210165035.3712489-1-aaronlewis@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 08:50:36AM -0800, Aaron Lewis wrote:
> The vcpu mmap area may consist of more than just the kvm_run struct.
> Allocate enough space for the entire vcpu mmap area. Without this, on
> x86, the PIO page, for example, will be missing.  This is problematic
> when dealing with an unhandled exception from the guest as the exception
> vector will be incorrectly reported as 0x0.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fa5a90e6c6f0..859a0b57c683 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -21,6 +21,8 @@
>  #define KVM_UTIL_PGS_PER_HUGEPG 512
>  #define KVM_UTIL_MIN_PFN	2
>  
> +static int vcpu_mmap_sz(void);
> +
>  /* Aligns x up to the next multiple of size. Size must be a power of 2. */
>  static void *align(void *x, size_t size)
>  {
> @@ -509,7 +511,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>  		vcpu->dirty_gfns = NULL;
>  	}
>  
> -	ret = munmap(vcpu->state, sizeof(*vcpu->state));
> +	ret = munmap(vcpu->state, vcpu_mmap_sz());
>  	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
>  		"errno: %i", ret, errno);
>  	close(vcpu->fd);
> @@ -978,7 +980,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>  	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
>  		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
>  		vcpu_mmap_sz(), sizeof(*vcpu->state));
> -	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
> +	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
>  		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
>  	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
>  		"vcpu id: %u errno: %i", vcpuid, errno);
> -- 
> 2.30.0.478.g8a0d178c01-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

