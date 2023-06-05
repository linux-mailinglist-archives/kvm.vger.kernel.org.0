Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD4E723349
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 00:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjFEWlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 18:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjFEWlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 18:41:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BF7F3
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 15:41:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-659bb123ccfso1629296b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 15:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686004882; x=1688596882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYZ0pyGD8sQGgJeNv8i3hV96TIZDFnh++53o9m2bsLI=;
        b=TGLyJfuV9X9oyz66tSzhQEUendm3MC7j/sHQNXWedLgCqXseJjc4gv2x+mjGMR6hMh
         KbmDI3/yVhHnXySQRMonQiU8m8cEvmfy3nCOwl/1LzWiS80v+MN+bjor8R+NUCHOkA+t
         xsND+o3MsHSlbEqjb5rms6I3QmX+CHv0X3csT3DNpvKiOsg1DKkko1+eqCoZEIYaTdxm
         US+wewf7zEW5JOixMoS2vPmFftkGSOv13gEGMRPvDI3OKBRXWXLLcwkx6uiAoZL/URhe
         3Su/eI+9CuPmLUO9POa7ZobxffUHBDmyZAiyGeC6LQGTaVS4lJiZHXmJIX9Cp30PK9He
         Or+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686004882; x=1688596882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYZ0pyGD8sQGgJeNv8i3hV96TIZDFnh++53o9m2bsLI=;
        b=CXccbsWyXn+0WAEVknkQB2r0T4IZXZ9rMukPHVI4ARjF4+9H8Zeod9suU57cGDuU1V
         ODA9zer23LsBCYM5ITFgu9Q5EkdlS5HIpzfXKwKQtgzMZKYs4mVz3cuSzWiT8ubV47sT
         Q6g+xSRpb+gcEjTObwsI+ZnB/C0gyCvLyBeEoeU4GtmP/2EE9YzUEnWnS9JoKMa1twvW
         DauUMrmKVBgIGyWJBysC/Ygkl3w9rbAQjEACTTJ3G/Rgxj5b+KOj/G4EmSfLTVCY3aWK
         JL1CIitupabtFvbszDgxLbjYcim0aqyuqnthXhiXaIwoQfSbOFHfBtgW1tTNTZwlNSvp
         do4Q==
X-Gm-Message-State: AC+VfDytWMD2IVzmkpFbnN096yrmwrgXSwnP8+WJ9hGNMfifG1+yAL2s
        nOv0u4QPZrZQjSX2IYhupwUQD32bAFM=
X-Google-Smtp-Source: ACHHUZ4t5ZDDOwcDuQXexqRMIlRY3ThksD0p+p/dnsWpfMkM6af09yo1Uj8CcXWqI6hpFVgq9asHUp9zhnI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:179b:b0:64f:c0b1:6967 with SMTP id
 s27-20020a056a00179b00b0064fc0b16967mr18027pfg.1.1686004882605; Mon, 05 Jun
 2023 15:41:22 -0700 (PDT)
Date:   Mon, 5 Jun 2023 15:41:20 -0700
In-Reply-To: <20230424225854.4023978-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com> <20230424225854.4023978-6-aaronlewis@google.com>
Message-ID: <ZH5kkIWHCfDQy3EI@google.com>
Subject: Re: [PATCH v2 5/6] KVM: selftests: Add ucall_fmt2()
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Aaron Lewis wrote:
> Add a second ucall_fmt() function that takes two format strings instead
> of one.  This provides more flexibility because the string format in
> GUEST_ASSERT_FMT() is no linger limited to only using literals.

...

> -#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)		  \
> -do {										  \
> -	if (!(_condition))							  \
> -		ucall_fmt(UCALL_ABORT,						  \
> -			  "Failed guest assert: " _condstr " at %s:%ld\n  " _fmt, \
> -			  , __FILE__, __LINE__, ##_args);			  \
> +#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)	     \
> +do {									     \
> +	if (!(_condition))						     \
> +		ucall_fmt2(UCALL_ABORT,					     \
> +			   "Failed guest assert: " _condstr " at %s:%ld\n  ",\

I don't see any reason to add ucall_fmt2(), just do the string smushing in
__GUEST_ASSERT_FMT().  I doubt there will be many, if any, uses for this outside
of GUEST_ASSERT_FMT().  Even your test example is contrived, e.g. it would be
just as easy, and arguably more robusted, to #define the expected vs. actual formats
as it is to assign them to global variables.

In other words, this 

#define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)	     		\
do {										\
	char fmt_buffer[512];							\
										\
	if (!(_condition)) {							\
		kvm_snprintf(fmt_buffer, sizeof(fmt_buffer), "%s\n  %s",	\
			     "Failed guest assert: " _str " at %s:%ld", _fmt);	\
		ucall_fmt(UCALL_ABORT, fmt_buffer, __FILE__, __LINE__, ##_args);\
	}									\
} while (0)

is a preferable to copy+pasting an entirely new ucall_fmt2().  (Feel free to use
a different name for the on-stack array, e.g. just "fmt").

> +			   _fmt, __FILE__, __LINE__, ##_args);		     \
>  } while (0)
>  
>  #define GUEST_ASSERT_FMT(_condition, _fmt, _args...)	\
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index c09e57c8ef77..d0f1ad6c0c44 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -76,6 +76,30 @@ static void ucall_free(struct ucall *uc)
>  	clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
>  }
>  
> +void ucall_fmt2(uint64_t cmd, const char *fmt1, const char *fmt2, ...)
> +{
> +	const int fmt_len = 128;
> +	char fmt[fmt_len];

Just do 

	char fmt[128];

(or whatever size is chosen)

> +	struct ucall *uc;
> +	va_list va;
> +	int len;
> +
> +	len = kvm_snprintf(fmt, fmt_len, "%s%s", fmt1, fmt2);

and then here do sizeof(fmt).  It's self-documenting, and makes it really, really
hard to screw up and use the wrong format.

Regarding the size, can you look into why using 1024 for the buffer fails?  This
really should use the max allowed UCALL buffer size, but I'm seeing shutdowns when
pushing above 512 bytes (I didn't try to precisely find the threshold).  Selftests
are supposed to allocate 5 * 4KiB stacks, so the guest shouldn't be getting anywhere
near a stack overflow.

> +	if (len > fmt_len)

For KVM selftests use case, callers shouldn't need to sanity check, that should be
something kvm_snprintf() itself handles.  I'll follow-up in that patch.
