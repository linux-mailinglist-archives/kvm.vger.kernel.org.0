Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4D913C676
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAOOru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:47:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgAOOru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 09:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579099669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fXoSn08carTcr6ps7XYMBMV6vHfYgWCs+qaP6AWsLiY=;
        b=P8iSK4EF5HzZyXk3qeWykTmRvEnCN9l8docU9hsytvXSt+yTuzV2gVD8IaQkp65iTVNZ1Y
        Fn12wLFLSMuvDOnj8qI3sD4LC/RTHnJQWyPaHGNkqF8XbSRhyxrQQmRmHhX+jGHlZrHheJ
        jhG4tTJ+CPr6RiIXWo4nhBQlOUhHIIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91--l2R1fmWPK2ooNnXZl7JAw-1; Wed, 15 Jan 2020 09:47:48 -0500
X-MC-Unique: -l2R1fmWPK2ooNnXZl7JAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AE21801E72
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 14:47:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43ECF19C5B;
        Wed, 15 Jan 2020 14:47:44 +0000 (UTC)
Subject: Re: [PATCH v3] travis.yml: Prevent 'script' from premature exit
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200115144610.41655-1-wainersm@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a345a894-24f4-22ec-89d1-e1d83dbb52d9@redhat.com>
Date:   Wed, 15 Jan 2020 15:47:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200115144610.41655-1-wainersm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/2020 15.46, Wainer dos Santos Moschetta wrote:
> The 'script' section finishes its execution prematurely whenever
> a shell's exit is called. If the intention is to force
> Travis to flag a build/test failure then the correct approach
> is erroring any command statement. In this change, it combines
> the grep's in a single AND statement that in case of false
> Travis will interpret as a build error.
> 
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  Changes v2 to v3:
>    - Do not grep for SKIP, it needs at least one PASS [thuth]
>  Changes v1 to v2:
>    - Simplify the grep's in a single statement [thuth]
>    - Also grep for SKIP (besides PASS) [myself]
>  .travis.yml | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 091d071..f0cfc82 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -119,5 +119,4 @@ before_script:
>  script:
>    - make -j3
>    - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> -  - if grep -q FAIL results.txt ; then exit 1 ; fi
> -  - if ! grep -q PASS results.txt ; then exit 1 ; fi
> +  - grep -q PASS results.txt && ! grep -q FAIL results.txt

Reviewed-by: Thomas Huth <thuth@redhat.com>

