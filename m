Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC33A1538A0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 20:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgBETDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 14:03:31 -0500
Received: from foss.arm.com ([217.140.110.172]:51178 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgBETDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 14:03:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FA6E1FB;
        Wed,  5 Feb 2020 11:03:30 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CE333F52E;
        Wed,  5 Feb 2020 11:03:28 -0800 (PST)
Subject: Re: [PATCH kvmtool 06/16] builtin-run.c: Always use ram_size in bytes
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-7-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <7b6c50f1-9270-be0a-c8bb-a0f59c95be91@arm.com>
Date:   Wed, 5 Feb 2020 19:03:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-7-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> The user can specify the virtual machine memory size, in MB, which is saved
> in cfg->ram_size. kvmtool validates it against the host memory size,
> converted from bytes to MB. ram_size is aftwerwards converted to bytes, and
> this is how it is used throughout the rest of the program.
> 
> Let's avoid any confusion about the unit of measurement and always use
> cfg->ram_size in bytes.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   builtin-run.c            | 19 ++++++++++---------
>   include/kvm/kvm-config.h |  2 +-
>   include/kvm/kvm.h        |  2 +-
>   3 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index cff44047bb1c..4e0c52b3e027 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -262,7 +262,7 @@ static u64 host_ram_size(void)
>   		return 0;
>   	}
>   
> -	return (nr_pages * page_size) >> MB_SHIFT;
> +	return nr_pages * page_size;
>   }
>   
>   /*
> @@ -276,11 +276,11 @@ static u64 get_ram_size(int nr_cpus)
>   	u64 available;
>   	u64 ram_size;
>   
> -	ram_size	= 64 * (nr_cpus + 3);
> +	ram_size	= (64 * (nr_cpus + 3)) << MB_SHIFT;
>   
>   	available	= host_ram_size() * RAM_SIZE_RATIO;

The host_ram_size() gives you size in MB isn't it ? You need to
fix that to make sure we aren't comparing "ram_size" in bytes
with "available" in MB below. So the best option is to
talk bytes everywhere.

Otherwise looks fine.

Suzuki
