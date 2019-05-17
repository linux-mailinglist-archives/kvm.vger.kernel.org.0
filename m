Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D401D21979
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 16:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbfEQOEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 10:04:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34291 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbfEQOEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 10:04:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id f8so891928wrt.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 07:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ay0mnXwH55BT3mIc1KqqMT1PJjmGnEozvmL7TssXHuo=;
        b=LfdwX6U5r7oJ1g6UllzWEqU5cDpMioInfnpiV2vsow+64GtlyJnpaIrFUbSVv12zdt
         ZMZUkKaTSVzSvsimrsa5GGWyXtMSOpBF7ppv4093cwV8N+VPU5szFOufJ6uehJRdmsKg
         hEhdfwAfo9n+gcHCxeyUDD3w8Vq/l/WXd4yB16MESy2GTBhOTVZys7Wd9U/ZK3mkWH90
         q2gWWbKwDjH1mbyN55z2BnCqKyxedynreXqAFPDjdXbitwNJKxAl+xAQo1KFtpK6EgFG
         HDCAXm40EHmAaSAWKnvrQ1osA0/OWmoJHZu5DmqXXYdP+drqQ9KNcIxxtGkioOFGbBye
         wRjA==
X-Gm-Message-State: APjAAAVAnogzTaw4TLzPLvf7dL67+BFhgHD1PY4gRs16LwsGzmn7PrOe
        iXovrlKCL0CIlQ531NB4hW2AWw==
X-Google-Smtp-Source: APXvYqzOmt30lVKUv7iRVyaFJ+WmgvnzDm6OvelTWemiW1erIRYQzcy/pRp5fFjnkNTRIiOUVuVzqw==
X-Received: by 2002:adf:ce07:: with SMTP id p7mr20887296wrn.241.1558101847058;
        Fri, 17 May 2019 07:04:07 -0700 (PDT)
Received: from [172.27.174.155] (23-24-245-141-static.hfc.comcastbusiness.net. [23.24.245.141])
        by smtp.gmail.com with ESMTPSA id v5sm15816002wra.83.2019.05.17.07.04.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 07:04:06 -0700 (PDT)
Subject: Re: [PATCH -next] kvm: fix compilation errors with mem[re|un]map()
To:     Qian Cai <cai@lca.pw>, rkrcmar@redhat.com
Cc:     karahmed@amazon.de, konrad.wilk@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1558101713-15325-1-git-send-email-cai@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e22619d8-3441-634e-d2c0-fe8ddd7f03e5@redhat.com>
Date:   Fri, 17 May 2019 16:04:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558101713-15325-1-git-send-email-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ThOn 17/05/19 16:01, Qian Cai wrote:
> The linux-next commit e45adf665a53 ("KVM: Introduce a new guest mapping
> API") introduced compilation errors on arm64.
> 
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:9: error: implicit
> declaration of function 'memremap'
> [-Werror,-Wimplicit-function-declaration]
>                 hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>                       ^
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:9: error: this function
> declaration is not a prototype [-Werror,-Wstrict-prototypes]
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1764:46: error: use of
> undeclared identifier 'MEMREMAP_WB'
>                 hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
>                                                            ^
> arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1796:3: error: implicit
> declaration of function 'memunmap'
> [-Werror,-Wimplicit-function-declaration]
>                 memunmap(map->hva);
> 
> Fixed it by including io.h in kvm_main.c.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  virt/kvm/kvm_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8d83a787fd6b..5c5102799c2c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -51,6 +51,7 @@
>  #include <linux/slab.h>
>  #include <linux/sort.h>
>  #include <linux/bsearch.h>
> +#include <linux/io.h>
>  
>  #include <asm/processor.h>
>  #include <asm/io.h>
> 

Thanks---this is already included in v2 of my pull request to Linus.

Paolo
