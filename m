Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5622397C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbfETOMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:12:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39526 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729690AbfETOMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:12:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id n25so12804521wmk.4
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qeg8db0+2C6DHS9BrKS2+OQAmnLBtsvdtYzt5HKYRfk=;
        b=e1Gto/HwIlZ0ISZlQHJeXV+cMbp24oBxZv9t4wvaEZFTsrfpqChaYyTcCA7Wga4S7t
         10WdqHk64Eh7HsEXyzg10RPT2z41As1y1lGolUCHFH5Jrsc7Hi+FHAw1fO9tIesU3vt9
         l145Fiful3cHTs8rgOLlGLr76j1YglSVzpho4D2uWRhFqGZO9FvDywedMee2xvFTd+zc
         CINguPzq64WR1dJQHRK6mRpUH1zccqQUuw04UXzH1Lf1VykKNZo6YKLyk8f5udx+HeUJ
         rFDktcrCxtRFbfgz5WjMd8kkHAmcKL6w4S5i5OJ9I7zKXI/WMGel8uBKlBfEsVFGYym/
         QlIw==
X-Gm-Message-State: APjAAAXBEQhtDfgnexdyFq1w3y1m7/dDdCOIMiSO60EFY8AHItSx5QrU
        rmpnxW8zaaoBLtQ539aGi68vdg==
X-Google-Smtp-Source: APXvYqzYvPI7DB+MuZk2dyTIWk22tMgWmxdIItCCl2gVfUHBKTcLhRImm+5Xfk/fC30fdr6vNqvJtw==
X-Received: by 2002:a1c:1d46:: with SMTP id d67mr31278820wmd.98.1558361519212;
        Mon, 20 May 2019 07:11:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id b194sm15359515wmb.23.2019.05.20.07.11.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:11:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Change ALTERNATE_APIC_BASE to saner
 value
To:     "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190430140926.3204-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1499531-96d1-1f89-1f96-8a8bd5431b4c@redhat.com>
Date:   Mon, 20 May 2019 16:11:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430140926.3204-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/19 16:09, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> According to the SDM, during initialization, the BSP "Switches to
> protected mode and ensures that the APIC address space is mapped to the
> strong uncacheable (UC) memory type." This requirement is not followed
> when the tests that relocate the APIC.
> 
> Use the TPM base address for the alternate local-APIC base, as it is
> expected to be set as uncacheable by the BIOS.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/apic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/apic.c b/x86/apic.c
> index de4a181..173b8b1 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -159,7 +159,7 @@ static void test_apic_disable(void)
>      report_prefix_pop();
>  }
>  
> -#define ALTERNATE_APIC_BASE	0x42000000
> +#define ALTERNATE_APIC_BASE	0xfed40000
>  
>  static void test_apicbase(void)
>  {
> 

Queued, thanks.

Paolo
