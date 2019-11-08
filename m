Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0CF421F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbfKHIbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:31:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49555 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726072AbfKHIbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 03:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573201893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gmSUwSztyzqN4Y3AzKbu13byGYY0jeEel4aBDRl3LTA=;
        b=J14gkw8BnAQEqfaVnb2YMLYvEejs5wtcIcgtoo881fvqYeqKtCL+T72z3wKyafnqLzdUyY
        5sNi6/ctCV1SaAMK082nXhZmBYrQhrpb7C/kMoSwOfgpKEn2cYgzkxSiLbLbYAgtU3XGII
        WrMgjyzkoBeR9bLrcJbZFStSUNePuPc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-tkvvRkyePXebSJxK1panFw-1; Fri, 08 Nov 2019 03:31:32 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 006BB107ACC3;
        Fri,  8 Nov 2019 08:31:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 923A4271B8;
        Fri,  8 Nov 2019 08:31:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 5/6] x86: use a non-negative number in
 shift
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20191015000411.59740-1-morbo@google.com>
 <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-6-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b8c2d502-c215-e96d-a919-66cc339d3719@redhat.com>
Date:   Fri, 8 Nov 2019 09:31:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191030210419.213407-6-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: tkvvRkyePXebSJxK1panFw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/2019 22.04, Bill Wendling wrote:
> Shifting a negative number is undefined. Clang complains about it:
>=20
> x86/svm.c:1131:38: error: shifting a negative signed value is undefined [=
-Werror,-Wshift-negative-value]
>      test->vmcb->control.tsc_offset =3D TSC_OFFSET_VALUE;
>=20
> Using "~0ull" results in identical asm code:
>=20
> =09before: movabsq $-281474976710656, %rsi
> =09after:  movabsq $-281474976710656, %rsi
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   x86/svm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/svm.c b/x86/svm.c
> index 4ddfaa4..cef43d5 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -1122,7 +1122,7 @@ static bool npt_rw_l1mmio_check(struct test *test)
>   }
>  =20
>   #define TSC_ADJUST_VALUE    (1ll << 32)
> -#define TSC_OFFSET_VALUE    (-1ll << 48)
> +#define TSC_OFFSET_VALUE    (~0ull << 48)
>   static bool ok;
>  =20
>   static void tsc_adjust_prepare(struct test *test)
>=20

Reviewed-by: Thomas Huth <thuth@redhat.com>

