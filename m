Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9FE6D4E25
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjDCQkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDCQkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:40:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85118A8
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680539954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axN+WuChqJQ0D9KOMQkZDo7Ku9R1EMjprryR17AkXtc=;
        b=b5qPbRerP3C04rsUO+QgO8+P/jyHJNG+D0BzzRcRisxgW3a+m5aDnCR69erar43J2ngW/8
        sJgrzVvVba0BmlbGNuepIWM24I1ieiw7y9Fjtw5wRl+BGRtsiDztY4bIaPxC2ME0gFqIIX
        UOvz70XuSAWpstxmZZmhxNsYBCl1p3s=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-ybnj184uMWud4S1Ktsh-oA-1; Mon, 03 Apr 2023 12:39:13 -0400
X-MC-Unique: ybnj184uMWud4S1Ktsh-oA-1
Received: by mail-qv1-f69.google.com with SMTP id oo15-20020a056214450f00b005a228adfcefso13436803qvb.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=axN+WuChqJQ0D9KOMQkZDo7Ku9R1EMjprryR17AkXtc=;
        b=J8cKGs2MJCYEZtJeWRz5u7mdTQUhuihIlCTabZS2nN4vrhH0Qv072Y1u5CH24A7ARq
         wc8sZeJdzgvlvnF2xaRu2WBJFTGS6Hs0LzMzjBJecq7poZd0Cf7IHGkI5Y6W/8BfMAko
         kcLcjLpZcIRm6B4mVHMhu6+6ab/0HyjAx5zjLY4/t36QabGLiiPOuiFR88M+vCBIkekR
         GzSXzntAPX9/oBIPd2b7MLxPg4KpguDm5fE/JvpgChF2qQffnj6HgjG7SjG/uZDpHmCi
         3iJwiInjUAn8cs1yBwvmOwI//+LF7+KgaHVozSuLQb6t7eS6LSdVfFI61tzpZwHlz0mf
         WCig==
X-Gm-Message-State: AAQBX9ej2AdXfg4yKGzggTD/XN5sPFu4ALQHBPE6VR1RRnWgGH8E3TFW
        bkIcI6FxdOiC43LX6RYzEp2nrPxvz0oZBVzer8eehK04lUcKPO9rwGspNFVRcA40CM660CPByaR
        uxw8glX+EcBaA
X-Received: by 2002:a05:6214:230d:b0:56e:afe2:ebca with SMTP id gc13-20020a056214230d00b0056eafe2ebcamr62893942qvb.30.1680539952849;
        Mon, 03 Apr 2023 09:39:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z0QsAf7W14xSwwC21sMFB87DKDTHlOc1fPf3bz3++kcl2Xoz2NnaM1FQV4kLhJGU7FkXNmcQ==
X-Received: by 2002:a05:6214:230d:b0:56e:afe2:ebca with SMTP id gc13-20020a056214230d00b0056eafe2ebcamr62893926qvb.30.1680539952613;
        Mon, 03 Apr 2023 09:39:12 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-12.web.vodafone.de. [109.43.177.12])
        by smtp.gmail.com with ESMTPSA id cv2-20020ad44d82000000b005dd8b9345f3sm2725377qvb.139.2023.04.03.09.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 09:39:12 -0700 (PDT)
Message-ID: <64b09845-6671-d5f9-a0c0-ba60cc47a1b9@redhat.com>
Date:   Mon, 3 Apr 2023 18:39:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH kvm-unit-tests] memory: Skip tests for instructions that
 are absent
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     senajc@google.com
References: <20230403163046.387460-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230403163046.387460-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/04/2023 18.30, Paolo Bonzini wrote:
> Checking that instructions are absent is broken when running with CPU
> models other than the bare metal processor's, because neither VMX nor SVM have
> intercept controls for the instructions.
> 
> This can even happen with "-cpu max" when running under nested
> virtualization, which is the current situation in the Fedora KVM job
> on Cirrus-CI:
> 
> FAIL: clflushopt (ABSENT)
> FAIL: clwb (ABSENT)
> 
> In other words it looks like the features have been marked as disabled
> in the L0 host, while the hardware supports them.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/memory.c | 69 +++++++++++++++++++++++++++-------------------------
>   1 file changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/x86/memory.c b/x86/memory.c
> index 351e7c0..ffd4eeb 100644
> --- a/x86/memory.c
> +++ b/x86/memory.c
> @@ -25,53 +25,56 @@ static void handle_ud(struct ex_regs *regs)
>   
>   int main(int ac, char **av)
>   {
> -	int expected;
> -
>   	handle_exception(UD_VECTOR, handle_ud);
>   
>   	/* 3-byte instructions: */
>   	isize = 3;
>   
> -	expected = !this_cpu_has(X86_FEATURE_CLFLUSH); /* CLFLUSH */
> -	ud = 0;
> -	asm volatile("clflush (%0)" : : "b" (&target));
> -	report(ud == expected, "clflush (%s)", expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_CLFLUSH)) { /* CLFLUSH */
> +		ud = 0;
> +		asm volatile("clflush (%0)" : : "b" (&target));
> +		report(!ud, "clflush");
> +	}
>   
> -	expected = !this_cpu_has(X86_FEATURE_XMM); /* SSE */
> -	ud = 0;
> -	asm volatile("sfence");
> -	report(ud == expected, "sfence (%s)", expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_XMM)) { /* SSE */
> +		ud = 0;
> +		asm volatile("sfence");
> +		report(!ud, "sfence");
> +	}
>   
> -	expected = !this_cpu_has(X86_FEATURE_XMM2); /* SSE2 */
> -	ud = 0;
> -	asm volatile("lfence");
> -	report(ud == expected, "lfence (%s)", expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_XMM2)) { /* SSE2 */
> +		ud = 0;
> +		asm volatile("lfence");
> +		report(!ud, "lfence");
>   
> -	ud = 0;
> -	asm volatile("mfence");
> -	report(ud == expected, "mfence (%s)", expected ? "ABSENT" : "present");
> +		ud = 0;
> +		asm volatile("mfence");
> +		report(!ud, "mfence");
> +	}
>   
>   	/* 4-byte instructions: */
>   	isize = 4;
>   
> -	expected = !this_cpu_has(X86_FEATURE_CLFLUSHOPT); /* CLFLUSHOPT */
> -	ud = 0;
> -	/* clflushopt (%rbx): */
> -	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
> -	report(ud == expected, "clflushopt (%s)",
> -	       expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT)) { /* CLFLUSHOPT */
> +		ud = 0;
> +		/* clflushopt (%rbx): */
> +		asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
> +		report(!ud, "clflushopt");
> +	}
>   
> -	expected = !this_cpu_has(X86_FEATURE_CLWB); /* CLWB */
> -	ud = 0;
> -	/* clwb (%rbx): */
> -	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
> -	report(ud == expected, "clwb (%s)", expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_CLWB)) { /* CLWB */
> +		ud = 0;
> +		/* clwb (%rbx): */
> +		asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
> +		report(!ud, "clwb");
> +	}
>   
> -	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
> -	ud = 0;
> -	/* pcommit: */
> -	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
> -	report(ud == expected, "pcommit (%s)", expected ? "ABSENT" : "present");
> +	if (this_cpu_has(X86_FEATURE_PCOMMIT)) { /* PCOMMIT */
> +		ud = 0;
> +		/* pcommit: */
> +		asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
> +		report(!ud, "pcommit");
> +	}

Maybe add a

     } else {
        report_skip(...);
     }

after each block? ... so that it is more obvious in the output that 
something has not been executed?

Well, I don't care too much, so with or without that change:

Reviewed-by: Thomas Huth <thuth@redhat.com>

