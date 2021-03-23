Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D77345DE0
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 13:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCWMO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 08:14:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhCWMO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 08:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616501666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h/sgfTViU8x10vMyLijvwu5xxkIBYyNFxDgFuFkfH2M=;
        b=VdMoUgJAHLDg+i9pRKh2d5VSZRBx3fszj8rcJPBauJD62dVLLR0E5BBpEDFef0Kf3oskLU
        +BO/9mTnh3D0EIazFXtUAAL6jfNgLqPLfDi7feifCWnhW9ZU1Dj8IY1u7zJMeQr8ORPV+X
        dM+sHZB1rs28h7KjOhGorGXVIyWEfIM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-4RfPmdRDMrCOYlznRpVMVQ-1; Tue, 23 Mar 2021 08:14:22 -0400
X-MC-Unique: 4RfPmdRDMrCOYlznRpVMVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E118F84B9A0;
        Tue, 23 Mar 2021 12:14:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 168755C1C5;
        Tue, 23 Mar 2021 12:14:18 +0000 (UTC)
Date:   Tue, 23 Mar 2021 13:14:15 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:
> @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
>              c = *s - 'A' + 10;
>          else
>              break;
> -        acc = acc * base + c;
> +
> +        if (is_signed) {
> +            long __acc = (long)acc;
> +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> +            assert(!overflow);
> +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> +            assert(!overflow);
> +            acc = (unsigned long)__acc;
> +        } else {
> +            overflow = __builtin_umull_overflow(acc, base, &acc);
> +            assert(!overflow);
> +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> +            assert(!overflow);
> +        }
> +

Unfortunately my use of these builtins isn't loved by older compilers,
like the one used by the build-centos7 pipeline in our gitlab CI. I
could wrap them in an #if GCC_VERSION >= 50100 and just have the old
'acc = acc * base + c' as the fallback, but that's not pretty and
would also mean that clang would use the fallback too. Maybe we can
try and make our compiler.h more fancy in order to provide a
COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
both gcc and clang. Or, we could just forgot the overflow checking.

Anybody else have suggestions? Paolo? Thomas?

Thanks,
drew

