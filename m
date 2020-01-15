Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC6613C352
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 14:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgAONif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 08:38:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20698 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbgAONie (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 08:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579095513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mBqp69Fqz5mLKYHCRTglNa/HKvq2J1D/ERo8MF/L118=;
        b=B/MSgXNY1yRINk95EkioRMzQKP+iACsWOQpYuKoUO+ZCBLzCFFosLViAVDX5OlB5j196gx
        f+cBqelTFmteg2O6vhbhqHa34SwJ39J5PsYI4HM60EJOhxP2nmKxPejTfWbfBzU/pwEvzN
        ufyujfjSUFOZoGQHzZtFIyo5fwGY/fY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-dgUjrQ9AOuSyw2K0POtlaQ-1; Wed, 15 Jan 2020 08:38:32 -0500
X-MC-Unique: dgUjrQ9AOuSyw2K0POtlaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84BD7DB70
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 13:38:31 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CD62842BF;
        Wed, 15 Jan 2020 13:38:28 +0000 (UTC)
Subject: Re: [PATCH v2] travis.yml: Prevent 'script' from premature exit
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20200115131701.41131-1-wainersm@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <451f4b9f-a8db-29a4-5d9d-82b3f7db9628@redhat.com>
Date:   Wed, 15 Jan 2020 14:38:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200115131701.41131-1-wainersm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/2020 14.17, Wainer dos Santos Moschetta wrote:
> The 'script' section finishes its execution prematurely whenever
> a shell's exit is called. If the intention is to force
> Travis to flag a build/test failure then the correct approach
> is erroring any command statement. In this change, it combines
> the grep's in a single AND statement that in case of false
> Travis will interpret as a build error.
>=20
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  Changes v1 to v2:
>    - Simplify the grep's in a single statement [thuth]
>    - Also grep for SKIP (besides PASS) [myself]
>  .travis.yml | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/.travis.yml b/.travis.yml
> index 091d071..0a92bc5 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -119,5 +119,4 @@ before_script:
>  script:
>    - make -j3
>    - ACCEL=3D"${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> -  - if grep -q FAIL results.txt ; then exit 1 ; fi
> -  - if ! grep -q PASS results.txt ; then exit 1 ; fi
> +  - grep -q 'PASS\|SKIP' results.txt && ! grep -q FAIL results.txt

I think we want to see at least one "PASS" in the output, otherwise it's
an indication that something went wrong in the CI - I've seen bugs in
the past that caused all tests to SKIP, and we should fail the CI in
that case, too. So I'd suggest to remove the "SKIP" from the grep
statement again.

 Thomas

