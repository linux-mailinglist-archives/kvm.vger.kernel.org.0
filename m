Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B63391B22
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhEZPHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233472AbhEZPHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 11:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622041570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afXKeP+aN56rheXDqzdBoDJQ8Rg9z3z074x1aSluMhg=;
        b=K6a4ffxNDyBl8rCGa1t+N0Va4KG3vpo3NLAcpWW2vT9sADSSyIpsW1drjQFWNwquf5pMn7
        l4udwZO1CnNSOImgipVATIgQxMFZc+tZRhG/SFxmU1xj/K57V81SBn/4dEdjLv5wwBKFyP
        37KHmYTOyzEkhZD89FtHg0Xdxu036w0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-tJpmB5i8Nb2M4hnRU64YeQ-1; Wed, 26 May 2021 11:06:05 -0400
X-MC-Unique: tJpmB5i8Nb2M4hnRU64YeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735B9FCA3;
        Wed, 26 May 2021 15:06:04 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9436061094;
        Wed, 26 May 2021 15:06:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use
 deprecated server/nowait options
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-3-alex.bennee@linaro.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b99b2c07-33e9-7f18-5a43-8ece655fe594@redhat.com>
Date:   Wed, 26 May 2021 17:05:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 5/25/21 7:26 PM, Alex Bennée wrote:
> The very fact that QEMU drops the deprecation warning while running is
> enough to confuse the its-migration test into failing. The boolean
> options server and wait have accepted the long form options for a long
> time.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  scripts/arch-run.bash | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 5997e38..70693f2 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -122,14 +122,14 @@ run_migration ()
>  	trap 'kill 0; exit 2' INT TERM
>  	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
>  
> -	eval "$@" -chardev socket,id=mon1,path=${qmp1},server,nowait \
> +	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
>  		-mon chardev=mon1,mode=control | tee ${migout1} &
>  
>  	# We have to use cat to open the named FIFO, because named FIFO's, unlike
>  	# pipes, will block on open() until the other end is also opened, and that
>  	# totally breaks QEMU...
>  	mkfifo ${fifo}
> -	eval "$@" -chardev socket,id=mon2,path=${qmp2},server,nowait \
> +	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
>  		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
>  	incoming_pid=`jobs -l %+ | awk '{print$2}'`
>  
> 

