Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474876343BB
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 19:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiKVSjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 13:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiKVSjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 13:39:21 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1033F7615A
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:39:21 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id q71so14772626pgq.8
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 10:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZkNvvq5ISoqG0V9MFm9hogQNgY4LywspZ5Z6E8/+B8=;
        b=D03MhpOzvyfVTdBcPI0zeHyd5+bWmnI6mWMuo1MfpjaMZJ81VgGc6DmPDln8/Ijwgc
         Dr0KkxHfy7w8zfFGGfWqqdjY4CsfIQfefboESJP/Qh71WTXfBfOYJF3d6ozwa/BG6dCF
         Cd2YEHRJVOJw9eCJVAKABZ0wbArN9PMYAds/dckzMRRLR9Lwn6QGSvHN30uP87x3rHYs
         bzEAjXtDCIyupOCsKLvGbjt3BXkJAz2prKxWJnctOYDFWKvN5TqHm1hiIkwDt04CCVf8
         uALJdtAdpRHOqd6Fjs2uSiVsnlCL17HYTzB/DTMjAcXCTEcYEv5ZBb+JXPe5dr9Z6Z4Y
         OT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZkNvvq5ISoqG0V9MFm9hogQNgY4LywspZ5Z6E8/+B8=;
        b=CP6qHHa+oqyMmLn9nVrWSj4sCm/v1ogtm/AMBjWMHrUuBSp+mz8CLrygw7KDVJUx2u
         lyKcRevNH3XJO0Qr7qNdBTA/faWl6wtkcjmv9DVGmxEKJd6RlXE+duAn16gnTDUo8CK6
         vx94dY1C8JiuC61dNHdFH5UxPOvix0oT0m3nBdJ2OeotGqqh1Uf/MOfjxv6RYRYWDACj
         CQ3nIr5x1a+iKoZOe7SEltalz/I9bzqA2N17a7gmgoiGf9+4V+JhL+rWR+AGuZqJwGLo
         AfW9Yw2mCVk2zNHIZRya5HmJqCqYmuv0EaAzzDdcHBrgnBOB5spB9Wwc1oryddWbdY/a
         yFuw==
X-Gm-Message-State: ANoB5pk23ZqlD9FwOESe17QEFLegMZwJWU2nioJKkw2FWu1TYL/5DLdn
        Yl9s2kspUt564QI08Q/7SLrRCg==
X-Google-Smtp-Source: AA0mqf7QfDT4SH6T9CIlnN9tpaaE9LkfWTM8SThMdKph+hNkkr168cCk/mopXh91a5x15V04LlIgbQ==
X-Received: by 2002:a63:ff5f:0:b0:46f:b6df:3107 with SMTP id s31-20020a63ff5f000000b0046fb6df3107mr4610272pgk.454.1669142360418;
        Tue, 22 Nov 2022 10:39:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b12-20020a170903228c00b001811a197797sm12349020plh.194.2022.11.22.10.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:39:20 -0800 (PST)
Date:   Tue, 22 Nov 2022 18:39:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y30XVDXmkAIlRX4N@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119094659.11868-2-dwmw2@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 19, 2022, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The guest runstate area can be arbitrarily byte-aligned. In fact, even
> when a sane 32-bit guest aligns the overall structure nicely, the 64-bit
> fields in the structure end up being unaligned due to the fact that the
> 32-bit ABI only aligns them to 32 bits.
> 
> So setting the ->state_entry_time field to something|XEN_RUNSTATE_UPDATE
> is buggy, because if it's unaligned then we can't update the whole field
> atomically; the low bytes might be observable before the _UPDATE bit is.
> Xen actually updates the *byte* containing that top bit, on its own. KVM
> should do the same.

I think we're using the wrong APIs to update the runstate.  The VMCS/VMCB pages
_need_ the host pfn, i.e. need to use a gpc (eventually).  The Xen PV stuff on the
other hand most definitely doesn't need to know the pfn.

The event channel code would be difficult to convert due to lack of uaccess
primitives, but I don't see anything in the runstate code that prevents KVM from
using a gfn_to_hva_cache.  That will naturally handle page splits by sending them
down a slow path and would yield far simpler code.

If taking the slow path is an issue, then the guest really should be fixed to not
split pages.  And if that's not an acceptable answer, the gfn_to_hva_cache code
could be updated to use the fast path if the region is contiguous in the host
virtual address space.

> +static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>  {
>  	struct kvm_vcpu_xen *vx = &v->arch.xen;
> -	u64 now = get_kvmclock_ns(v->kvm);
> -	u64 delta_ns = now - vx->runstate_entry_time;
> -	u64 run_delay = current->sched_info.run_delay;
> +	struct gfn_to_pfn_cache *gpc1 = &vx->runstate_cache;
> +	struct gfn_to_pfn_cache *gpc2 = &vx->runstate2_cache;
> +	size_t user_len, user_len1, user_len2;
> +	struct vcpu_runstate_info rs;
> +	int *rs_state = &rs.state;
> +	unsigned long flags;
> +	size_t times_ofs;
> +	u8 *update_bit;
>  
> -	if (unlikely(!vx->runstate_entry_time))
> -		vx->current_runstate = RUNSTATE_offline;
> +	/*
> +	 * The only difference between 32-bit and 64-bit versions of the
> +	 * runstate struct us the alignment of uint64_t in 32-bit, which

s/us/is

> +	 * means that the 64-bit version has an additional 4 bytes of
> +	 * padding after the first field 'state'.
> +	 */
> +	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
> +	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
> +	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
> +#ifdef CONFIG_X86_64
> +	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
> +		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
> +	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
> +		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
> +#endif
> +
> +	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
> +		user_len = sizeof(struct vcpu_runstate_info);
> +		times_ofs = offsetof(struct vcpu_runstate_info,
> +				     state_entry_time);
> +	} else {
> +		user_len = sizeof(struct compat_vcpu_runstate_info);
> +		times_ofs = offsetof(struct compat_vcpu_runstate_info,
> +				     state_entry_time);
> +		rs_state++;

...

> +	*rs_state = vx->current_runstate;
> +#ifdef CONFIG_X86_64
> +	/* Don't leak kernel memory through the padding in the 64-bit struct */
> +	if (rs_state == &rs.state)
> +		rs_state[1] = 0;

Oof, that's difficult to follow.  Rather than pointer magic, what about zeroing
the first word unconditionally?  Likely faster than a CMP+CMOV or whatever gets
generated.  Or just zero the entire struct.

	/* Blah blah blah */
	*(unsigned long *)&rs.state = 0;

> +#endif
