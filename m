Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880545231E9
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbiEKLea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiEKLe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:34:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76D9569492
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vzmKp6FemolAIrrL9HTlk0UTLaJcbzB/FCWqS422ox0=;
        b=P2I/WpKaJWW0t0Lc51aG97v00JmzSFg0OvQeWM7rQ2HkclbxWIXGrISc7sMgJQHxtxL3Js
        VDvIx1Kp+wq5JYhCadScZ5BNTE20/pLZz1O4llg70hfEdHvjTSB6WH5GC8yH7W7eUERtK/
        bWQg1tZbpWCvRwof5p1q8NBZXGr/e5I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-2-tgISkLMwWnnNTrM-Fnvg-1; Wed, 11 May 2022 07:34:23 -0400
X-MC-Unique: 2-tgISkLMwWnnNTrM-Fnvg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D70333C138CA;
        Wed, 11 May 2022 11:34:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93A411121314;
        Wed, 11 May 2022 11:34:20 +0000 (UTC)
Message-ID: <c4907689ab89cf783d000f88f0c1c123ac97b26a.camel@redhat.com>
Subject: Re: [PATCH v3 23/34] KVM: selftests: Better XMM read/write helpers
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:34:19 +0300
In-Reply-To: <20220414132013.1588929-24-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-24-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> set_xmm()/get_xmm() helpers are fairly useless as they only read 64 bits
> from 128-bit registers. Moreover, these helpers are not used. Borrow
> _kvm_read_sse_reg()/_kvm_write_sse_reg() from KVM limiting them to
> XMM0-XMM8 for now.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/processor.h  | 70 ++++++++++---------
>  1 file changed, 36 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 37db341d4cc5..9ad7602a257b 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -296,71 +296,73 @@ static inline void cpuid(uint32_t *eax, uint32_t *ebx,
>  	    : "memory");
>  }
>  
> -#define SET_XMM(__var, __xmm) \
> -	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
> +typedef u32		__attribute__((vector_size(16))) sse128_t;
> +#define __sse128_u	union { sse128_t vec; u64 as_u64[2]; u32 as_u32[4]; }
> +#define sse128_lo(x)	({ __sse128_u t; t.vec = x; t.as_u64[0]; })
> +#define sse128_hi(x)	({ __sse128_u t; t.vec = x; t.as_u64[1]; })
>  
> -static inline void set_xmm(int n, unsigned long val)
> +static inline void read_sse_reg(int reg, sse128_t *data)
>  {
> -	switch (n) {
> +	switch (reg) {
>  	case 0:
> -		SET_XMM(val, xmm0);
> +		asm("movdqa %%xmm0, %0" : "=m"(*data));
>  		break;
>  	case 1:
> -		SET_XMM(val, xmm1);
> +		asm("movdqa %%xmm1, %0" : "=m"(*data));
>  		break;
>  	case 2:
> -		SET_XMM(val, xmm2);
> +		asm("movdqa %%xmm2, %0" : "=m"(*data));
>  		break;
>  	case 3:
> -		SET_XMM(val, xmm3);
> +		asm("movdqa %%xmm3, %0" : "=m"(*data));
>  		break;
>  	case 4:
> -		SET_XMM(val, xmm4);
> +		asm("movdqa %%xmm4, %0" : "=m"(*data));
>  		break;
>  	case 5:
> -		SET_XMM(val, xmm5);
> +		asm("movdqa %%xmm5, %0" : "=m"(*data));
>  		break;
>  	case 6:
> -		SET_XMM(val, xmm6);
> +		asm("movdqa %%xmm6, %0" : "=m"(*data));
>  		break;
>  	case 7:
> -		SET_XMM(val, xmm7);
> +		asm("movdqa %%xmm7, %0" : "=m"(*data));
>  		break;
> +	default:
> +		BUG();
>  	}
>  }
>  
> -#define GET_XMM(__xmm)							\
> -({									\
> -	unsigned long __val;						\
> -	asm volatile("movq %%"#__xmm", %0" : "=r"(__val));		\
> -	__val;								\
> -})
> -
> -static inline unsigned long get_xmm(int n)
> +static inline void write_sse_reg(int reg, const sse128_t *data)
>  {
> -	assert(n >= 0 && n <= 7);
> -
> -	switch (n) {
> +	switch (reg) {
>  	case 0:
> -		return GET_XMM(xmm0);
> +		asm("movdqa %0, %%xmm0" : : "m"(*data));
> +		break;
>  	case 1:
> -		return GET_XMM(xmm1);
> +		asm("movdqa %0, %%xmm1" : : "m"(*data));
> +		break;
>  	case 2:
> -		return GET_XMM(xmm2);
> +		asm("movdqa %0, %%xmm2" : : "m"(*data));
> +		break;
>  	case 3:
> -		return GET_XMM(xmm3);
> +		asm("movdqa %0, %%xmm3" : : "m"(*data));
> +		break;
>  	case 4:
> -		return GET_XMM(xmm4);
> +		asm("movdqa %0, %%xmm4" : : "m"(*data));
> +		break;
>  	case 5:
> -		return GET_XMM(xmm5);
> +		asm("movdqa %0, %%xmm5" : : "m"(*data));
> +		break;
>  	case 6:
> -		return GET_XMM(xmm6);
> +		asm("movdqa %0, %%xmm6" : : "m"(*data));
> +		break;
>  	case 7:
> -		return GET_XMM(xmm7);
> +		asm("movdqa %0, %%xmm7" : : "m"(*data));
> +		break;
> +	default:
> +		BUG();
>  	}
> -
> -	/* never reached */
> -	return 0;
>  }
>  
>  static inline void cpu_relax(void)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

