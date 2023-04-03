Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F4E6D4B39
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjDCO6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjDCO6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6B412060
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 07:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680533844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IAM3GigFSe3rAFPTa3nz+duJjEw0gXwIUuq3W6GV7qk=;
        b=gcEEGsFPazNtdKdWM/HEg+i7/tiKWHV9eR24IV/d05mTP5nZwYDQKE+oDtf03nXQ7ROpqT
        mXkjQvC2sSlHA6YynwgPf8glhOon0SZGKuakum/RWCZUKl4nYNUi1iQBrd8LtewSu1sh9t
        8/rG3X47QlE7vi1Ld39nPFn8stNHiuo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-RzRfRMcwONmFVr_DC0uUKQ-1; Mon, 03 Apr 2023 10:57:20 -0400
X-MC-Unique: RzRfRMcwONmFVr_DC0uUKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D142857FB5;
        Mon,  3 Apr 2023 14:57:20 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF7E40C20FA;
        Mon,  3 Apr 2023 14:57:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 6484821E6926; Mon,  3 Apr 2023 16:57:19 +0200 (CEST)
From:   Markus Armbruster <armbru@redhat.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
Subject: Re: [PATCH qemu] sev/i386: Fix error reporting
References: <20230403031231.2003480-1-aik@amd.com>
Date:   Mon, 03 Apr 2023 16:57:19 +0200
In-Reply-To: <20230403031231.2003480-1-aik@amd.com> (Alexey Kardashevskiy's
        message of "Mon, 3 Apr 2023 13:12:31 +1000")
Message-ID: <87wn2t814g.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexey Kardashevskiy <aik@amd.com> writes:

> c9f5aaa6bce8 ("sev: Add Error ** to sev_kvm_init()") converted
> error_report() to error_setg(), however it missed one error_report()
> and other 2 changes added error_report() after conversion. The result
> is the caller - kvm_init() - crashes in error_report_err as local_err
> is NULL.
>
> Follow the pattern and use error_setg instead of error_report.
>
> Fixes: 9681f8677f26 ("sev/i386: Require in-kernel irqchip support for SEV-ES guests")
> Fixes: 6b98e96f1842 ("sev/i386: Add initial support for SEV-ES")
> Fixes: c9f5aaa6bce8 ("sev: Add Error ** to sev_kvm_init()")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  target/i386/sev.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 859e06f6ad..6b640b5c1f 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -922,7 +922,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  
>      ret = ram_block_discard_disable(true);
>      if (ret) {
> -        error_report("%s: cannot disable RAM discard", __func__);
> +        error_setg(errp, "%s: cannot disable RAM discard", __func__);
>          return -1;
>      }
>  
> @@ -968,15 +968,14 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  
>      if (sev_es_enabled()) {
>          if (!kvm_kernel_irqchip_allowed()) {
> -            error_report("%s: SEV-ES guests require in-kernel irqchip support",
> -                         __func__);
> +            error_setg(errp, "%s: SEV-ES guests require in-kernel irqchip support",
> +                       __func__);
>              goto err;
>          }
>  
>          if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> -            error_report("%s: guest policy requires SEV-ES, but "
> -                         "host SEV-ES support unavailable",
> -                         __func__);
> +            error_setg(errp, "%s: guest policy requires SEV-ES, but host SEV-ES support unavailable",
> +                       __func__);
>              goto err;
>          }
>          cmd = KVM_SEV_ES_INIT;

Preexisting, but here goes anyway: __func__ in error messages is an
anti-pattern.  Error messages are for the user, not the developer.  The
developer can find the function just fine; grep exists.

