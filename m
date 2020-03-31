Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447F6199C60
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgCaRBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 13:01:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49308 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730541AbgCaRBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 13:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585674111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LZe7O33StYIVezYuIPV1VWwBoQLShM+Sb98LvVz5rpk=;
        b=chmGpUCYA7xorayYhz/RB6jy/aIVc2fgWVi9emcyC+UOaEcmlePBXY1X+ggI6owXWzO9KB
        Z1mNUTi5BauaMDTg01DGAwx+eIMzdQVa4u5OIic1f7t3aYpgUlx9t0Xd8jW3KZgNNhrVZa
        EzY96yIN4RxqbCRtygaA1qdR2lQLauA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-SKHLPy9YMRaw8xzjKsJVog-1; Tue, 31 Mar 2020 13:01:50 -0400
X-MC-Unique: SKHLPy9YMRaw8xzjKsJVog-1
Received: by mail-wm1-f71.google.com with SMTP id f8so1323434wmh.4
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 10:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LZe7O33StYIVezYuIPV1VWwBoQLShM+Sb98LvVz5rpk=;
        b=Z8wNuiEx4kX4c416O6Mz7NNmydr7GqT1JYlPRedEPw43em7aWpR+1UMCVgxPMyIcIG
         31OMtMRuv7RBhj9PnBr/9xK6LwM3guvztdAEqTcH+ZaXuMd53TuIM4jLSLZjMHIZK4Dk
         LPDxTLQGe0lJTcr5hb/NY7gSmRv1/xTS+v+5qKaTDlrEpUBTdAsUP5LawXRYPmLqzKbl
         PMfDeql7Gtuyrn/wJ/sp53jlewDtHwpwSK+xu3IR6vffkxLF2U9KwuRNEwvmBdo0L/lY
         sxAV2CTtUjO8xV7CrXYIvrAJEBH5BllHLhYfhf2ix+VXUIs+Vlye1WRX3Hm0zbVOISuz
         9zEA==
X-Gm-Message-State: ANhLgQ22nL0Hf8mv7561wnllZ3W0dlGTFEaiKP89UwEtSs6xO7+mUo8C
        t3eOD2JWUGIHbTk2MWyKoS6dA5c7eW2R50hlnNSwsEifXBmoViToq7B9AYY5xNAraJYMQywO2e0
        JrRhbkEJSbUPw
X-Received: by 2002:a7b:c404:: with SMTP id k4mr4144931wmi.37.1585674108907;
        Tue, 31 Mar 2020 10:01:48 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuEYR0ktXbZSvoFfZEbWpWdoat35LhlqNsxna/SnP4q5iDHIj7WUFpbnroBnoEkxCsCrlOC4g==
X-Received: by 2002:a7b:c404:: with SMTP id k4mr4144920wmi.37.1585674108726;
        Tue, 31 Mar 2020 10:01:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id f20sm4270099wmc.35.2020.03.31.10.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 10:01:48 -0700 (PDT)
Subject: Re: [PATCH] x86: vmx: skip atomic_switch_overflow_msrs_test on bare
 metal
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20200321050616.4272-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74577744-fbcc-c97b-fd7a-afa913c4c581@redhat.com>
Date:   Tue, 31 Mar 2020 19:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200321050616.4272-1-namit@vmware.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/20 06:06, Nadav Amit wrote:
> The test atomic_switch_overflow_msrs_test is only expected to pass on
> KVM. Skip the test when the debug device is not supported to avoid
> failures on bare-metal.
> 
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/vmx_tests.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2014e54..be5c952 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9546,7 +9546,10 @@ static void atomic_switch_max_msrs_test(void)
>  
>  static void atomic_switch_overflow_msrs_test(void)
>  {
> -	atomic_switch_msrs_test(max_msr_list_size() + 1);
> +	if (test_device_enabled())
> +		atomic_switch_msrs_test(max_msr_list_size() + 1);
> +	else
> +		test_skip("Test is only supported on KVM");
>  }
>  
>  #define TEST(name) { #name, .v2 = name }
> 

Queued, thanks.

Paolo

