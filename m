Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD15B212408
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgGBNB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:01:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45158 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbgGBNB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 09:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593694915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v8SnQ4u0UTLmhKt73+PAqeYdxoNSV8q95I5k2+Mk11E=;
        b=QsUNtgkEIlIv2Tjby72mO7MB6t6zNkTq2pDfhvYwLRJw+Ltycvi7fGR++J2PHL79oiQ5Lf
        uJJkIelP7TnFg8MQ3qzMSwQ3li1toS9icg16AG4Wr72+Lb66KLTGu+MuHNDe9mmCqa6Xle
        o9fFJjIryH00XX+b3pzQ1qDUGJNQcdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-3QslMo8oMuerZaJzE0OIgg-1; Thu, 02 Jul 2020 09:01:53 -0400
X-MC-Unique: 3QslMo8oMuerZaJzE0OIgg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 364B0A0BD7;
        Thu,  2 Jul 2020 13:01:51 +0000 (UTC)
Received: from [10.36.112.70] (ovpn-112-70.ams2.redhat.com [10.36.112.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EE3C73FC7;
        Thu,  2 Jul 2020 13:01:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/8] arm64: its: Handle its command
 queue wrapping
To:     Jingyi Wang <wangjingyi11@huawei.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-5-wangjingyi11@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <870ae6e6-0c02-1770-085b-4e031e391a24@redhat.com>
Date:   Thu, 2 Jul 2020 15:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200702030132.20252-5-wangjingyi11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jingyi,

On 7/2/20 5:01 AM, Jingyi Wang wrote:
> Because micro-bench may send a large number of ITS commands, we
> should handle ITS command queue wrapping as kernel instead of just
> failing the test.
> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  lib/arm64/gic-v3-its-cmd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
> index 2c208d1..34574f7 100644
> --- a/lib/arm64/gic-v3-its-cmd.c
> +++ b/lib/arm64/gic-v3-its-cmd.c
> @@ -164,8 +164,9 @@ static struct its_cmd_block *its_allocate_entry(void)
>  {
>  	struct its_cmd_block *cmd;
>  
> -	assert((u64)its_data.cmd_write < (u64)its_data.cmd_base + SZ_64K);
>  	cmd = its_data.cmd_write++;
> +	if ((u64)its_data.cmd_write  == (u64)its_data.cmd_base + SZ_64K)
> +		its_data.cmd_write = its_data.cmd_base;
>  	return cmd;
>  }
>  
> 

