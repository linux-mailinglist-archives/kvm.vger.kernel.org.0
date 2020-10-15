Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA3928EE61
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 10:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgJOIWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 04:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgJOIWi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 04:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602750157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVFDGBRg80cXtAQB6Btx341BeIJFVrWxhg7ZDjDXL58=;
        b=ULArX320m9YNMjwcfie27qGhO7Qg6hGU0js6dYReX5zmuZdNPFhkrKpo9ScAyCONmbLKv5
        sVmBCJf35kv0qEGQOMJGhW2b3MDanHQl/AoOq/G0SmXiArUPy/KYgrlN8zNYCU1DLSRARI
        Tgr/vykREWA1OsrN0t0vgfqgQ3xRuc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-8KhXKqLCOfivSZjCRcLUbw-1; Thu, 15 Oct 2020 04:22:35 -0400
X-MC-Unique: 8KhXKqLCOfivSZjCRcLUbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7E2D10190A0
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:22:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-212.ams2.redhat.com [10.36.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F9015D9CD;
        Thu, 15 Oct 2020 08:22:33 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests 2/3] scripts: Save rematch before calling
 out of for_each_unittest
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-3-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f7586a37-01af-5286-efd4-f248da61c983@redhat.com>
Date:   Thu, 15 Oct 2020 10:22:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201014191444.136782-3-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/2020 21.14, Andrew Jones wrote:
> If we don't save BASH_REMATCH before calling another function,
> and that other function also uses [[...]], then we'll lose the
> test.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  scripts/common.bash | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index a6044b7c6c35..7b983f7d6dd6 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -13,15 +13,17 @@ function for_each_unittest()
>  	local check
>  	local accel
>  	local timeout
> +	local rematch
>  
>  	exec {fd}<"$unittests"
>  
>  	while read -r -u $fd line; do
>  		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
> +			rematch=${BASH_REMATCH[1]}
>  			if [ -n "${testname}" ]; then
>  				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  			fi
> -			testname=${BASH_REMATCH[1]}
> +			testname=$rematch
>  			smp=1
>  			kernel=""
>  			opts=""
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

