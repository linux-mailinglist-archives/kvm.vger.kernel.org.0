Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3506C678D
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjCWMDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCWMD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6613403F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679572865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTGFYnjWURCLah9WgWBIHv8w4r2E6oqPT1N4romExjY=;
        b=MImzOq3gG4iYqVdyJtr7+DxKkwNyhoC94AesT3/+byIM9jRrmD356y4+nrWKWngFFnjmdm
        bB2pn8Ea7NbHwDb5UQPaaZK5tfcXha/UidW2IXv751m6tsR7O2/a0DZDLe5WTBoQUrQ6fG
        9INop8CDC8VodkRHrVxhbD+uk5LKDYY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-rUB7dUxBO0Cennpp5BXZyw-1; Thu, 23 Mar 2023 08:01:04 -0400
X-MC-Unique: rUB7dUxBO0Cennpp5BXZyw-1
Received: by mail-wm1-f71.google.com with SMTP id m5-20020a05600c4f4500b003ee8db23ef9so723948wmq.8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679572863;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KTGFYnjWURCLah9WgWBIHv8w4r2E6oqPT1N4romExjY=;
        b=7n475z7CzxFJkYTB+TL1nJwMpo+LmZxpxm5LZDZsbdN48DtGgplr8F19mLBZ7spCFG
         XkCg+6wjWUMtnja+Oza4D+rJ8I9SonHTmZq9TSbcspTO09p5cs1GyNvioYtCgRl6OGT7
         al0Plypl/Yy+11ZVxf8hYYAd7z6Y9WF2sp1kVcSiMhbqFfOFMmjuG95gZmhDA3N3/mgb
         lPZb8N4nwcFQcROaL7xV9cXXauqlIZvGtO5mEcSSO0huc9O2juAzFu3hxwST04p7ur6F
         dFIhGVXgLap3AyX7vvJkWCHTV/R7J/X3XwQzdqKbg0+pC+o+4Z2PAal/a4vCwgLRU+i5
         nCgg==
X-Gm-Message-State: AO0yUKUyhzaTID6uJ69rjTc3yR2gRga4qCoQfyha7BkGmSOuIVcLyvt1
        pSWzXmFDxnlg+jn2iXMi4TI9ahQsZL7EuEqAijK/fTyZ/Ygf2uM3JL4EKXLytZ5dXe83MCfZEwV
        dJP/WtFvYBpPNGtjAFaxfF5M=
X-Received: by 2002:a1c:4b1a:0:b0:3ed:a82d:dfe2 with SMTP id y26-20020a1c4b1a000000b003eda82ddfe2mr2025662wma.29.1679572863040;
        Thu, 23 Mar 2023 05:01:03 -0700 (PDT)
X-Google-Smtp-Source: AK7set9MyJMT/nYCBtz9tt9u0w+Cvx8tCG2gYM0Zl7gZFp2GCTxdj8RQVMZCS7m7wBDqJwRfnkzkqw==
X-Received: by 2002:a1c:4b1a:0:b0:3ed:a82d:dfe2 with SMTP id y26-20020a1c4b1a000000b003eda82ddfe2mr2025649wma.29.1679572862779;
        Thu, 23 Mar 2023 05:01:02 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-179-146.web.vodafone.de. [109.43.179.146])
        by smtp.gmail.com with ESMTPSA id f20-20020a1c6a14000000b003edcc2223c6sm1682498wmc.28.2023.03.23.05.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 05:01:02 -0700 (PDT)
Message-ID: <82e48016-90d4-0097-67b1-31f2c5668918@redhat.com>
Date:   Thu, 23 Mar 2023 13:01:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests v2 04/10] powerpc: Add ISA v3.1 (POWER10) support
 to SPR test
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Laurent Vivier <lvivier@redhat.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
 <20230320070339.915172-5-npiggin@gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230320070339.915172-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 08.03, Nicholas Piggin wrote:
> This is a very basic detection that does not include all new SPRs.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index ba4ddee..6ee6dba 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -117,6 +117,15 @@ static void set_sprs_book3s_300(uint64_t val)
>   	mtspr(823, val);	/* PSSCR */
>   }
>   
> +/* SPRs from Power ISA Version 3.1B */
> +static void set_sprs_book3s_31(uint64_t val)
> +{
> +	set_sprs_book3s_207(val);
> +	mtspr(48, val);		/* PIDR */
> +	/* 3.1 removes TIDR */
> +	mtspr(823, val);	/* PSSCR */
> +}
> +
>   static void set_sprs(uint64_t val)
>   {
>   	uint32_t pvr = mfspr(287);	/* Processor Version Register */
> @@ -137,6 +146,9 @@ static void set_sprs(uint64_t val)
>   	case 0x4e:			/* POWER9 */
>   		set_sprs_book3s_300(val);
>   		break;
> +	case 0x80:                      /* POWER10 */
> +		set_sprs_book3s_31(val);
> +		break;
>   	default:
>   		puts("Warning: Unknown processor version!\n");
>   	}
> @@ -220,6 +232,13 @@ static void get_sprs_book3s_300(uint64_t *v)
>   	v[823] = mfspr(823);	/* PSSCR */
>   }
>   
> +static void get_sprs_book3s_31(uint64_t *v)
> +{
> +	get_sprs_book3s_207(v);
> +	v[48] = mfspr(48);	/* PIDR */
> +	v[823] = mfspr(823);	/* PSSCR */
> +}
> +
>   static void get_sprs(uint64_t *v)
>   {
>   	uint32_t pvr = mfspr(287);	/* Processor Version Register */
> @@ -240,6 +259,9 @@ static void get_sprs(uint64_t *v)
>   	case 0x4e:			/* POWER9 */
>   		get_sprs_book3s_300(v);
>   		break;
> +	case 0x80:                      /* POWER10 */
> +		get_sprs_book3s_31(v);
> +		break;
>   	}
>   }

Looks like I accidentally replied to v1 a couple of minutes ago... I meant 
to reply here:

Reviewed-by: Thomas Huth <thuth@redhat.com>

