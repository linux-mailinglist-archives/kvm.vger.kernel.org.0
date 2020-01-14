Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709EC13AFF1
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 17:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANQsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 11:48:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36963 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727102AbgANQso (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 11:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579020523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=M1febqbVNrxto/flIrpcMLZic9VhKNLLx/8bn8mKjJ8=;
        b=TMGY9USEL3+Mnbcui45OFzkPUMNHMn/OVLiAnoXRRqIh+WFcvqDhyHrUFDvckpZRLmqHGU
        Rtu52ZpQNLUGE+8Zc/IJvYfYo5b2s/wTf+yasBdGQOH3p915gYly1vin0DgYAHByppIrvy
        T5OsMkdpOzWEqb2CBsX+PRdA/6kFVKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-KgAeMfx_O42pZdgrNdoQ6w-1; Tue, 14 Jan 2020 11:48:41 -0500
X-MC-Unique: KgAeMfx_O42pZdgrNdoQ6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43F6C158132
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 16:48:39 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBEA060BF1;
        Tue, 14 Jan 2020 16:48:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests] travis.yml: Prevent 'script' section from
 premature exit
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200113195102.44756-1-wainersm@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <59bd7e8c-8321-8868-27a9-fb8a968e1ce0@redhat.com>
Date:   Tue, 14 Jan 2020 17:48:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200113195102.44756-1-wainersm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/2020 20.51, Wainer dos Santos Moschetta wrote:
> The 'script' section finishes its execution prematurely whenever
> a shell's exit is called. If the intention is to force
> Travis to flag a build/test failure then the correct approach
> is erroring any build command. In this change, it executes a
> sub-shell process and exit 1, so that Travis capture the return
> code and interpret it as a build error.
> 
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  .travis.yml | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 091d071..a4405c3 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -119,5 +119,5 @@ before_script:
>  script:
>    - make -j3
>    - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> -  - if grep -q FAIL results.txt ; then exit 1 ; fi
> -  - if ! grep -q PASS results.txt ; then exit 1 ; fi
> +  - if grep -q FAIL results.txt ; then $(exit 1) ; fi
> +  - if ! grep -q PASS results.txt ; then $(exit 1) ; fi

Basically a good idea, but I think we can even simplify these two lines
into:

 grep -q PASS results.txt && ! grep -q FAIL results.txt

If you agree, could you update your patch and send a v2?

 Thanks,
  Thomas

