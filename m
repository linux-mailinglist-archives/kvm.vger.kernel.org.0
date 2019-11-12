Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2456DF97A2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfKLRwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:52:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725997AbfKLRwQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 12:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573581134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXe9dpihyILI8TfpWYMAc+umzSANj6TLPk5mDOmImvc=;
        b=dMxgV/7mdrOWo2LjYsTOAU5MgYZoOnAgsc+PJLvl1bfirhrktKyjsQyLBbG1+LSHR8kJB7
        B6g/zqp9Fu3L8xhCRRaxL1L8MNhPy9cqcczzWTiOWRLWAIFOnK0CHjz2JfkmXY+KqxvncY
        9H7D0Uh0d8hYlBfENJ3Pg3but7mwDA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-pVEg7w1XOqeOwFvv2tw_QQ-1; Tue, 12 Nov 2019 12:52:11 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CAE48C18E9;
        Tue, 12 Nov 2019 17:52:11 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 241B128D3A;
        Tue, 12 Nov 2019 17:52:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/2] Makefile: add "cxx-option" for C++
 builds
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com
References: <20191107010844.101059-1-morbo@google.com>
 <20191107010844.101059-3-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <18785109-ffd0-b536-bb63-e1a2b6cf5c97@redhat.com>
Date:   Tue, 12 Nov 2019 18:52:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191107010844.101059-3-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: pVEg7w1XOqeOwFvv2tw_QQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/2019 02.08, Bill Wendling wrote:
> The C++ compiler may not support all of the same flags as the C
> compiler. Add a separate test for these flags.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  Makefile | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 4c716da..9cb47e6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -48,6 +48,8 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
> =20
>  cc-option =3D $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/nul=
l \
>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;=
)
> +cxx-option =3D $(shell if $(CXX) -Werror $(1) -S -o /dev/null -xc++ /dev=
/null \
> +              > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;=
)
> =20
>  COMMON_CFLAGS +=3D -g $(autodepend-flags)
>  COMMON_CFLAGS +=3D -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> @@ -62,8 +64,6 @@ fno_pic :=3D $(call cc-option, -fno-pic, "")
>  no_pie :=3D $(call cc-option, -no-pie, "")
>  wclobbered :=3D $(call cc-option, -Wclobbered, "")
>  wunused_but_set_parameter :=3D $(call cc-option, -Wunused-but-set-parame=
ter, "")
> -wmissing_parameter_type :=3D $(call cc-option, -Wmissing-parameter-type,=
 "")
> -wold_style_declaration :=3D $(call cc-option, -Wold-style-declaration, "=
")
> =20
>  COMMON_CFLAGS +=3D $(fomit_frame_pointer)
>  COMMON_CFLAGS +=3D $(fno_stack_protector)
> @@ -75,11 +75,19 @@ COMMON_CFLAGS +=3D $(wclobbered)
>  COMMON_CFLAGS +=3D $(wunused_but_set_parameter)
> =20
>  CFLAGS +=3D $(COMMON_CFLAGS)
> +CXXFLAGS +=3D $(COMMON_CFLAGS)
> +
> +wmissing_parameter_type :=3D $(call cc-option, -Wmissing-parameter-type,=
 "")
> +wold_style_declaration :=3D $(call cc-option, -Wold-style-declaration, "=
")
>  CFLAGS +=3D $(wmissing_parameter_type)
>  CFLAGS +=3D $(wold_style_declaration)
>  CFLAGS +=3D -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> =20
> -CXXFLAGS +=3D $(COMMON_CFLAGS)
> +# Clang's C++ compiler doesn't support some of the flags its C compiler =
does.
> +wmissing_parameter_type :=3D $(call cxx-option, -Wmissing-parameter-type=
, "")
> +wold_style_declaration :=3D $(call cxx-option, -Wold-style-declaration, =
"")
> +CXXFLAGS +=3D $(wmissing_parameter_type)
> +CXXFLAGS +=3D $(wold_style_declaration)

As mentioned in my mail to the previous version of this patch: I think
both options are not valid with g++ as well, so I think this patch
should simply be dropped.

 Thomas

