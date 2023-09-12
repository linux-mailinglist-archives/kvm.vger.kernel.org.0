Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E3079D1BD
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbjILNEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235561AbjILNDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:03:50 -0400
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1147A1BF6
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 06:03:03 -0700 (PDT)
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
        by isrv.corpit.ru (Postfix) with ESMTP id BD93721218;
        Tue, 12 Sep 2023 16:03:05 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
        by tsrv.corpit.ru (Postfix) with ESMTP id 8303327867;
        Tue, 12 Sep 2023 16:03:01 +0300 (MSK)
Message-ID: <90ab0eef-1ac7-36df-dcba-67d1f772b1a5@tls.msk.ru>
Date:   Tue, 12 Sep 2023 16:03:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 2/4] target/ppc: Restrict KVM objects to system emulation
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
References: <20230912113027.63941-1-philmd@linaro.org>
 <20230912113027.63941-3-philmd@linaro.org>
From:   Michael Tokarev <mjt@tls.msk.ru>
In-Reply-To: <20230912113027.63941-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

12.09.2023 14:30, Philippe Mathieu-Daudé:
> kvm-stub.c only defines kvm_openpic_connect_vcpu(),
> which is clearly not used by user emulation.

Yes, kvm-stub only defines this function.  But you also move kvm.c
from ppc_ss to ppc_system_ss, and the commit message does not say
a word about this.  Hopefully there's no usage of symbols in kvm.c
in other configurations (or else it wont link).

I think commit message might be just a bit more verbose.  Right now
it is misleading/confusing, which is worse than no commit message
at all :)

For the changes,

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>

I even tried to build some targets (ppc user and system on x86)
with this change, but I can't say I verified every configuration.

/mjt

> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


> ---
>   target/ppc/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/ppc/meson.build b/target/ppc/meson.build
> index 4c2635039e..bf1c9319fa 100644
> --- a/target/ppc/meson.build
> +++ b/target/ppc/meson.build
> @@ -30,7 +30,6 @@ gen = [
>   ]
>   ppc_ss.add(when: 'CONFIG_TCG', if_true: gen)
>   
> -ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
>   ppc_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user_only_helper.c'))
>   
>   ppc_system_ss = ss.source_set()
> @@ -46,6 +45,7 @@ ppc_system_ss.add(when: 'CONFIG_TCG', if_true: files(
>   ), if_false: files(
>     'tcg-stub.c',
>   ))
> +ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
>   
>   ppc_system_ss.add(when: 'TARGET_PPC64', if_true: files(
>     'compat.c',

