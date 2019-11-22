Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9310704A
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfKVLVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:21:33 -0500
Received: from foss.arm.com ([217.140.110.172]:43866 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfKVKpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0C75328;
        Fri, 22 Nov 2019 02:45:09 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C9EC3F6C4;
        Fri, 22 Nov 2019 02:45:09 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] runtime: set MAX_SMP to number of online
 cpus
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20191120141928.6849-1-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <86280ced-214f-eb0f-0662-0854e5c57991@arm.com>
Date:   Fri, 22 Nov 2019 10:45:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120141928.6849-1-drjones@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/20/19 2:19 PM, Andrew Jones wrote:
> We can only use online cpus, so make sure we check specifically for
> those.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 200d5b67290c..fbad0bd05fc5 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,5 +1,5 @@
>  : "${RUNTIME_arch_run?}"
> -: ${MAX_SMP:=$(getconf _NPROCESSORS_CONF)}
> +: ${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}

I tested it on my machine by offlining a CPU and calling getconf _NPROCESSORS_CONF
(returned 32) and getconf _NPROCESSORS_ONLN (returned 31). man 3 sysconf also
agrees with your patch.

I am wondering though, if _NPROCESSORS_CONF is 8 and _NPROCESSORS_ONLN is 1
(meaning that 7 CPUs were offlined), that means that qemu will create 8 VCPUs
which will share the same physical CPU. Is that undesirable?

Thanks,
Alex
>  : ${TIMEOUT:=90s}
>  
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
