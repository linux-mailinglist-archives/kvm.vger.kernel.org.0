Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE221804BF
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 18:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCJR1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 13:27:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726271AbgCJR1y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 13:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583861273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ghBSnBwFc/MfOO87KoM+ks7WKUvlCd5SZkqJx+HigQY=;
        b=YlcHPuNUqG1tCLAZRCBMbVUUArZhHrV6Yc8Bun8UicTZ8b3oUWeI/im2NY02GgPytuJV85
        IKNg7o21jjYO9otCwexoZ0Pe8zvKR8eDUkt3qZUGj4qO3W6of2DXuWnwHKAhChHbbNQipe
        edrkF+srTigY/uZkLSzVcZDal4NH+mU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-XobozGP5PfiE95iuBLBNyw-1; Tue, 10 Mar 2020 13:27:51 -0400
X-MC-Unique: XobozGP5PfiE95iuBLBNyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B39E8017CC;
        Tue, 10 Mar 2020 17:27:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63EFB10013A1;
        Tue, 10 Mar 2020 17:27:46 +0000 (UTC)
Date:   Tue, 10 Mar 2020 18:27:44 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Ben Gardon <bgardon@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: kvm/queue demand paging test and s390
Message-ID: <20200310172744.36lawcszzjbebz6d@kamzik.brq.redhat.com>
References: <c845637e-d662-993e-2184-fa34bae79495@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c845637e-d662-993e-2184-fa34bae79495@de.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 05:54:59PM +0100, Christian Borntraeger wrote:
> For s390 the guest memory size must be 1M aligned. I need something like the following to make this work:
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index c1e326d3ed7f..f85ec3f01a35 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -164,6 +164,10 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
>         pages += ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
>                  PTES_PER_4K_PT;
>         pages = vm_adjust_num_guest_pages(mode, pages);
> +#ifdef __s390x__
> +       /* s390 requires 1M aligned guest sizes */
> +       pages = (pages + 255) & ~0xff;
> +#endif
>  
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>  
> 
> any better idea how to do that?
>

For this one we could patch[*] vm_adjust_num_guest_pages(). That would
also allow the one on line 382, and another one at dirty_log_test.c:300
to be hidden.

I'd also like to add a

 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size)
 {
      unsigned int n;
      n = DIV_ROUND_UP(size, vm_guest_mode_params[mode].page_size);
      return vm_adjust_num_guest_pages(mode, n);
 }

to the num-pages API we've recently put in kvm/queue. If we do, then we
could add a #ifdef-390x to that as well.

Thanks,
drew


[*]

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fc84da4b72d4..9569b21eed26 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -261,7 +261,13 @@ unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_p
 static inline unsigned int
 vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 {
-       return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
+       unsigned int n;
+       n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
+#ifdef __s390x__
+       /* s390 requires 1M aligned guest sizes */
+       n = (n + 255) & ~0xff;
+#endif
+       return n;
 }
 
 struct kvm_userspace_memory_region *

