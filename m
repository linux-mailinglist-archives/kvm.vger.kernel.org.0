Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B91827AE9F
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 15:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgI1NE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 09:04:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgI1NEZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 09:04:25 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601298264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bkPr3FOCLrxNO0NQbpe9PUNMFJQs5zP8NoEUMZGJhjM=;
        b=aqjMceldYjK7GUtfBKNJ7ZuSjzrHitZ40WxahKAyDOMtayKGH2fy3/bmx9rgz+Fxdprdg/
        EEOMttNPzwxcgRMMIZVQiKJIl5OtgW6KecQ338W8lD6pPAc9Pshj98pAGa75Mx0BZh5Bsq
        NjkDdaM4cLfubbpaXmuMLEsk4zmptqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Kk8XWjIEMcOVGmcypBYHOQ-1; Mon, 28 Sep 2020 09:04:22 -0400
X-MC-Unique: Kk8XWjIEMcOVGmcypBYHOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8591D18C9F53;
        Mon, 28 Sep 2020 13:03:46 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0D5278822;
        Mon, 28 Sep 2020 13:03:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: use ncat rather than nc.
To:     Jamie Iles <jamie@nuviainc.com>, kvm@vger.kernel.org
References: <20200921103644.1718058-1-jamie@nuviainc.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <33ca8cfb-3f82-5f9b-b7c1-9f3ce75bd9ff@redhat.com>
Date:   Mon, 28 Sep 2020 15:03:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200921103644.1718058-1-jamie@nuviainc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/2020 12.36, Jamie Iles wrote:
> On Red Hat 7+ and derived distributions, 'nc' is nmap-ncat, but on
> Debian based distributions this is often netcat-openbsd.  Both are
> mostly compatible with the important distinction that netcat-openbsd
> does not shutdown the socket on stdin EOF without also passing '-N' as
> an argument which is not supported on nmap-ncat.  This has the
> unfortunate consequence of hanging qmp calls so tests like aarch64
> its-migration never complete.
> 
> We're depending on ncat behaviour and nmap-ncat is available in all
> major distributions.
> 
> Signed-off-by: Jamie Iles <jamie@nuviainc.com>
> ---
>  scripts/arch-run.bash | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 660f1b7acb93..5997e384019b 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -101,13 +101,13 @@ timeout_cmd ()
>  
>  qmp ()
>  {
> -	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | nc -U $1
> +	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>  }
>  
>  run_migration ()
>  {
> -	if ! command -v nc >/dev/null 2>&1; then
> -		echo "${FUNCNAME[0]} needs nc (netcat)" >&2
> +	if ! command -v ncat >/dev/null 2>&1; then
> +		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
>  		return 2
>  	fi

Sounds reasonable, and still seems to work fine with the sprs ppc64 test.

Tested-by: Thomas Huth <thuth@redhat.com>

