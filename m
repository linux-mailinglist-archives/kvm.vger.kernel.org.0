Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6917A5128
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjIRRn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjIRRnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F4FA
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695058985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZAqPnGfV9iJk5jJgLRQAm5eQPuTDm+M+GCSbiY5NvgQ=;
        b=QvNIVMOpPDaPbuH/YKNpLg2ZOsqy6NKv2sQI3cjFPFEHRnv5V7ihfw7j5eqL+U/Cha/jH8
        sU20TUHh4HhTF8Yv3Pq8Q85fE2usbyrEi2+/d4dccUqKl1/gSNMcXHxSzFzOzHO9gq7kqj
        BhsOtDicpjCmaGoI/1PDYQYjKkm5ji8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-FTgf7kn1MzCx6ouwSjAMdg-1; Mon, 18 Sep 2023 13:43:02 -0400
X-MC-Unique: FTgf7kn1MzCx6ouwSjAMdg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40474c03742so30104605e9.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:43:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695058981; x=1695663781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAqPnGfV9iJk5jJgLRQAm5eQPuTDm+M+GCSbiY5NvgQ=;
        b=DkQ3ZfPfN3dAF81TSV10T8buS4axWCtlbkkD54+p97C517sDrXcicL87g5t4/Uwkkl
         /B7IErTMisOjzURKpIPb+dm3k75dmv1o7jPpKiaV8g+lceDgHGF7r0qidpyMHsFW6XkO
         RWMFcRaQqEjHxbA7/bZrhA03af2VqNlXcR4r2/AAlMbYftG3QMTJ6E6jU5mMoEDeaGrf
         knNHTg4kmEsThlDtX7tK1huw7bpLT7VCDpKnYMZ+hBagUoPSaW9gxDB3zrQ41eht/OzY
         gNjVbrZp1VOm3phdOOwiwwXSsO9UzrFBCSutV21YSchVylZyIZ3zUSwqKbnS4ieLQp06
         magQ==
X-Gm-Message-State: AOJu0YzH3BAbKElp3INu0ytouk7/RlnB04foi9qTMCoz4utYbyRIDvuS
        lM+Vf/G1gj84jyoUIt5rPRSZjRS+w1/DNwQ+Y2Klf0zY2fl98Ca3pKocXptgrObvpD7ejlmel/u
        MwJlKATgCwu0/
X-Received: by 2002:a05:600c:285:b0:3fe:dcd0:2e32 with SMTP id 5-20020a05600c028500b003fedcd02e32mr7998441wmk.19.1695058981115;
        Mon, 18 Sep 2023 10:43:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVU3CbB9yuFsNorQq6rKQJq+6VGnza3p4og8tTRsgk1iv+jOCgz4ng5FETyv6ulZE33I5AkQ==
X-Received: by 2002:a05:600c:285:b0:3fe:dcd0:2e32 with SMTP id 5-20020a05600c028500b003fedcd02e32mr7998432wmk.19.1695058980829;
        Mon, 18 Sep 2023 10:43:00 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-179-28.web.vodafone.de. [109.43.179.28])
        by smtp.gmail.com with ESMTPSA id x7-20020a05600c2d0700b00404719b05b5sm12528375wmf.27.2023.09.18.10.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 10:43:00 -0700 (PDT)
Message-ID: <930311be-a555-c8e1-5552-c678b5ace665@redhat.com>
Date:   Mon, 18 Sep 2023 19:42:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [kvm-unit-tests PATCH] Makefile: Add -MP to $(autodepend-flags)
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
References: <402218a490f286c039d4072be7f7d7b3f3216c49.camel@infradead.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <402218a490f286c039d4072be7f7d7b3f3216c49.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/2023 09.29, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The -MP flag instructs the compiler to emit phony targets for each header
> file that it lists as a dependency, so that if a header file is *absent*
> from the next build (because it's been deleted and the C file no longer
> includes it), the build doesn't gratuitously fail when make thinks it's
> needed and can't work out how to create it.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index e7998a4..101c028 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -90,7 +90,7 @@ CFLAGS += $(wmissing_parameter_type)
>   CFLAGS += $(wold_style_declaration)
>   CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>   
> -autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
> +autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
>   
>   LDFLAGS += -nostdlib $(no_pie) -z noexecstack
>   

Tested-by: Thomas Huth <thuth@redhat.com>

Thanks, I've pushed it to the repository now!

