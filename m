Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C694309CF5
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 15:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhAaOcx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 09:32:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:44996 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhAaOUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 09:20:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 57DB1AF13;
        Sun, 31 Jan 2021 14:19:44 +0000 (UTC)
Subject: Re: [PATCH v6 02/11] exec: Restrict TCG specific headers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
 <20210131115022.242570-3-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <7a8bedbb-7e76-61bc-f158-f550d78539fa@suse.de>
Date:   Sun, 31 Jan 2021 15:19:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210131115022.242570-3-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/21 12:50 PM, Philippe Mathieu-Daudé wrote:
> Fixes when building with --disable-tcg on ARM:
> 
>   In file included from target/arm/helper.c:16:
>   include/exec/helper-proto.h:42:10: fatal error: tcg-runtime.h: No such file or directory
>      42 | #include "tcg-runtime.h"
>         |          ^~~~~~~~~~~~~~~
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  include/exec/helper-proto.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/exec/helper-proto.h b/include/exec/helper-proto.h
> index 659f9298e8f..740bff3bb4d 100644
> --- a/include/exec/helper-proto.h
> +++ b/include/exec/helper-proto.h
> @@ -39,8 +39,10 @@ dh_ctype(ret) HELPER(name) (dh_ctype(t1), dh_ctype(t2), dh_ctype(t3), \
>  
>  #include "helper.h"
>  #include "trace/generated-helpers.h"
> +#ifdef CONFIG_TCG
>  #include "tcg-runtime.h"
>  #include "plugin-helpers.h"
> +#endif /* CONFIG_TCG */
>  
>  #undef IN_HELPER_PROTO
>  
> 

Ok, this would go away when applying the refactoring to ARM though right?

Ie the file should not need including at all later on right?

Anyway:

Reviewed-by: Claudio Fontana <cfontana@suse.de>
