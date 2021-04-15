Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3883610AD
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 19:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhDORDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 13:03:03 -0400
Received: from foss.arm.com ([217.140.110.172]:50972 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234315AbhDORDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 13:03:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A45B11B3;
        Thu, 15 Apr 2021 10:02:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C7973FA45;
        Thu, 15 Apr 2021 10:02:38 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 7/8] chr-testdev: Silently fail init
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-8-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fcf670a8-50ec-ef0f-c4cf-ce0534b33984@arm.com>
Date:   Thu, 15 Apr 2021 18:03:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-8-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/7/21 7:59 PM, Andrew Jones wrote:
> If there's no virtio-console / chr-testdev configured, then the user
> probably didn't want them. Just silently fail rather than stating
> the obvious.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/chr-testdev.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> index 6890f63c8b29..b3c641a833fe 100644
> --- a/lib/chr-testdev.c
> +++ b/lib/chr-testdev.c
> @@ -54,11 +54,8 @@ void chr_testdev_init(void)
>  	int ret;
>  
>  	vcon = virtio_bind(VIRTIO_ID_CONSOLE);
> -	if (vcon == NULL) {
> -		printf("%s: %s: can't find a virtio-console\n",
> -				__func__, TESTDEV_NAME);
> +	if (vcon == NULL)

Yes, please. This finally removes the warning when using kvmtool:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  		return;
> -	}
>  
>  	ret = vcon->config->find_vqs(vcon, 2, vqs, NULL, io_names);
>  	if (ret < 0) {
