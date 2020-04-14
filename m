Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4081A840E
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgDNQCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:02:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728549AbgDNQCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 12:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586880153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j6BJ1qotsxhY3gyNhGOJe572vp8LawDKLqnu8rUjZGA=;
        b=Ysd107pv92BzlcAaaE+ffM2fFEuNWE83+vrVNGwdDqfXwj+x93SPo2nERdSVPXt+niVpbJ
        L22XuO2u6ilujSYvIjGvhwUXmLHc8WJ5A4cWf3f3zlENv9Zt+93qCsQpp8JiHqy4YVE13K
        FH9fLOgqkaWGa0m0dzSupwLEdO4Hk/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-1urs6SybNlGftFkurQxpBQ-1; Tue, 14 Apr 2020 12:02:31 -0400
X-MC-Unique: 1urs6SybNlGftFkurQxpBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 663788017F3;
        Tue, 14 Apr 2020 16:02:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B50D5D9E2;
        Tue, 14 Apr 2020 16:02:22 +0000 (UTC)
Date:   Tue, 14 Apr 2020 18:02:19 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: Re: [PATCH 04/10] KVM: selftests: Add GUEST_ASSERT variants to pass
 values to host
Message-ID: <20200414160219.wvp5o2rkdrkjxvs2@kamzik.brq.redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410231707.7128-5-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 04:17:01PM -0700, Sean Christopherson wrote:
> Add variants of GUEST_ASSERT to pass values back to the host, e.g. to
> help debug/understand a failure when the the cause of the assert isn't
> necessarily binary.
> 
> It'd probably be possible to auto-calculate the number of arguments and
> just have a single GUEST_ASSERT, but there are a limited number of
> variants and silently eating arguments could lead to subtle code bugs.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 25 +++++++++++++++----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d4c3e4d9cd92..e38d91bd8ec1 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -313,11 +313,26 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
> -#define GUEST_ASSERT(_condition) do {			\
> -	if (!(_condition))				\
> -		ucall(UCALL_ABORT, 2,			\
> -			"Failed guest assert: "		\
> -			#_condition, __LINE__);		\
> +#define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
> +	if (!(_condition))					\
> +		ucall(UCALL_ABORT, 2 + _nargs,			\

Need () around _nargs

> +			"Failed guest assert: "			\
> +			#_condition, __LINE__, _args);		\
>  } while (0)

We can free up another arg and add __FILE__. Something like the following
(untested):

 #include "linux/stringify.h"

 #define __GUEST_ASSERT(_condition, _nargs, _args...) do {                            \
       if (!(_condition))                                                             \
               ucall(UCALL_ABORT, (_nargs) + 1,                                       \
                     "Failed guest assert: "                                          \
                     #_condition " at " __FILE__ ":" __stringify(__LINE__), _args);   \
 } while (0)

>  
> +#define GUEST_ASSERT(_condition) \
> +	__GUEST_ASSERT((_condition), 0, 0)
> +
> +#define GUEST_ASSERT_1(_condition, arg1) \
> +	__GUEST_ASSERT((_condition), 1, (arg1))
> +
> +#define GUEST_ASSERT_2(_condition, arg1, arg2) \
> +	__GUEST_ASSERT((_condition), 2, (arg1), (arg2))
> +
> +#define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
> +	__GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
> +
> +#define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
> +	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
> +

nit: don't need the () around any of the macro params above

>  #endif /* SELFTEST_KVM_UTIL_H */
> -- 
> 2.26.0
> 

We could instead add test specific ucalls. To do so, we should first add
UCALL_TEST_SPECIFIC = 32 to the ucall enum, and then tests could extend it

 enum {
  MY_UCALL_1 = UCALL_TEST_SPECIFIC,
  MY_UCALL_2,
 };

With appropriately named test specific ucalls it may allow for clearer
code. At least GUEST_ASSERT_<N> wouldn't take on new meanings for each
test.

Thanks,
drew

