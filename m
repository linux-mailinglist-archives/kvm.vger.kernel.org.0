Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FCA731BB5
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 16:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbjFOOrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 10:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345036AbjFOOrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 10:47:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B345273D
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:46:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C50A1FB;
        Thu, 15 Jun 2023 07:47:39 -0700 (PDT)
Received: from [10.57.85.226] (unknown [10.57.85.226])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A06A13F663;
        Thu, 15 Jun 2023 07:46:54 -0700 (PDT)
Message-ID: <9a1a4e84-6567-fde2-945c-9ceb40e42c9f@arm.com>
Date:   Thu, 15 Jun 2023 15:46:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH 1/3] arch-run: Extend timeout when booting
 with UEFI
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>
References: <20230607185905.32810-1-andrew.jones@linux.dev>
 <20230607185905.32810-2-andrew.jones@linux.dev>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230607185905.32810-2-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/2023 19:59, Andrew Jones wrote:
> Booting UEFI can take a long time. Give the timeout some extra time
> to compensate for it.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   scripts/arch-run.bash | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97b27d1..72ce718b1170 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -94,7 +94,17 @@ run_qemu_status ()
>   
>   timeout_cmd ()
>   {
> +	local s
> +
>   	if [ "$TIMEOUT" ] && [ "$TIMEOUT" != "0" ]; then
> +		if [ "$CONFIG_EFI" = 'y' ]; then
> +			s=${TIMEOUT: -1}
> +			if [ "$s" = 's' ]; then
> +				TIMEOUT=${TIMEOUT:0:-1}
> +				((TIMEOUT += 10)) # Add 10 seconds for booting UEFI
> +				TIMEOUT="${TIMEOUT}s"
> +			fi
> +		fi
>   		echo "timeout -k 1s --foreground $TIMEOUT"
>   	fi
>   }

This looks fine to me but at the same time, I wonder if it's worth the 
complexity. In arm/unittests.cfg, timer is the only test where we 
specify a timeout. If we were to bump it from 10s to 20s it would solve 
the problem too but also the timeout would be extended for non EFI runs too.

In any case:

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos
