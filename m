Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC38BF425B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfKHIn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:43:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28935 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727459AbfKHInX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 03:43:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573202601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXzn7PoZeo9wzV61ObOMhLt3Hg8JrQUlctbm1h0GftI=;
        b=LpGzNuczfclt01AI9H2kXsl6xTPo4qaQb/Kp/QBOA3viQbMMCF25isBUOy8crvMffJ4PB8
        HDs8Z5EwA7ZSN8dZyveZefAO8TKCmvxZ2C2ehJA61MLsS9WU/bwWgk+EZ+mvZ9TisQTeNH
        wjye192SmKvBXquUsgJe0iQIPJw9gQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-rH7vMyCiPY2t__0TJVkj_g-1; Fri, 08 Nov 2019 03:43:19 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B114107ACC3;
        Fri,  8 Nov 2019 08:43:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 343595C290;
        Fri,  8 Nov 2019 08:43:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/6] Makefile: use "-Werror" in
 cc-option
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20191015000411.59740-1-morbo@google.com>
 <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-4-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e4c7494f-1ca5-fe6e-7238-08307fa3bccb@redhat.com>
Date:   Fri, 8 Nov 2019 09:43:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191030210419.213407-4-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: rH7vMyCiPY2t__0TJVkj_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/2019 22.04, Bill Wendling wrote:
> The "cc-option" macro should use "-Werror" to determine if a flag is
> supported. Otherwise the test may not return a nonzero result. Also
> conditionalize some of the warning flags which aren't supported by
> clang.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>   Makefile | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index 32414dc..6201c45 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -46,13 +46,13 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile
>   # cc-option
>   # Usage: OP_CFLAGS+=3D$(call cc-option, -falign-functions=3D0, -malign-=
functions=3D0)
>  =20
> -cc-option =3D $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
> +cc-option =3D $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/nul=
l \
>                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi =
;)
>  =20
>   COMMON_CFLAGS +=3D -g $(autodepend-flags)
> -COMMON_CFLAGS +=3D -Wall -Wwrite-strings -Wclobbered -Wempty-body -Wunin=
itialized
> -COMMON_CFLAGS +=3D -Wignored-qualifiers -Wunused-but-set-parameter
> -COMMON_CFLAGS +=3D -Werror
> +COMMON_CFLAGS +=3D -Wall -Wwrite-strings -Wempty-body -Wuninitialized
> +COMMON_CFLAGS +=3D -Wignored-qualifiers -Werror
> +
>   frame-pointer-flag=3D-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-point=
er
>   fomit_frame_pointer :=3D $(call cc-option, $(frame-pointer-flag), "")
>   fnostack_protector :=3D $(call cc-option, -fno-stack-protector, "")
> @@ -60,16 +60,20 @@ fnostack_protector_all :=3D $(call cc-option, -fno-st=
ack-protector-all, "")
>   wno_frame_address :=3D $(call cc-option, -Wno-frame-address, "")
>   fno_pic :=3D $(call cc-option, -fno-pic, "")
>   no_pie :=3D $(call cc-option, -no-pie, "")
> +wclobbered :=3D $(call cc-option, -Wclobbered, "")
> +wunused_but_set_parameter :=3D $(call cc-option, -Wunused-but-set-parame=
ter, "")
> +
>   COMMON_CFLAGS +=3D $(fomit_frame_pointer)
>   COMMON_CFLAGS +=3D $(fno_stack_protector)
>   COMMON_CFLAGS +=3D $(fno_stack_protector_all)
>   COMMON_CFLAGS +=3D $(wno_frame_address)
>   COMMON_CFLAGS +=3D $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
>   COMMON_CFLAGS +=3D $(fno_pic) $(no_pie)
> +COMMON_CFLAGS +=3D $(wclobbered)
> +COMMON_CFLAGS +=3D $(wunused_but_set_parameter)

Looks good to me up to this point here...

>   CFLAGS +=3D $(COMMON_CFLAGS)
> -CFLAGS +=3D -Wmissing-parameter-type -Wold-style-declaration -Woverride-=
init
> -CFLAGS +=3D -Wmissing-prototypes -Wstrict-prototypes
> +CFLAGS +=3D -Woverride-init -Wmissing-prototypes -Wstrict-prototypes

... but I think this hunk rather belongs to the next patch instead?

  Thomas

