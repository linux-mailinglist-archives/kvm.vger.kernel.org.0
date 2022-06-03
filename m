Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB853C9E8
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 14:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiFCMVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 08:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiFCMVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 08:21:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0103C275C0
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 05:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654258875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DsaFPT0eC1zcjYMKyqe8kEslz7AwD0aYXafQi/mWjJU=;
        b=N52yscxGJin1zC9tBEduZRorNKMToLNh/ceV0oxF7CE5IvlaWTe2a9EcX3rAyl5JGHfsY1
        2Cila6bkv0k5itRp3mc+yHvwsaowRVZTOHvu9YfVlagV4zbRQ0FEUxPhq+6mr6G8ToAmuR
        cJGn2LvTc+T5KUWoUIZJ8brdS55/gxE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-Aw0dw0LQOgWTzyuU0Pb7NA-1; Fri, 03 Jun 2022 08:21:12 -0400
X-MC-Unique: Aw0dw0LQOgWTzyuU0Pb7NA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A11BA8001EA;
        Fri,  3 Jun 2022 12:21:11 +0000 (UTC)
Received: from localhost (dhcp-192-194.str.redhat.com [10.33.192.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 548292026D07;
        Fri,  3 Jun 2022 12:21:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, alex.bennee@linaro.org
Subject: Re: [PATCH kvm-unit-tests] arm64: TCG: Use max cpu type
In-Reply-To: <20220603111356.1480720-1-drjones@redhat.com>
Organization: Red Hat GmbH
References: <20220603111356.1480720-1-drjones@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Fri, 03 Jun 2022 14:21:10 +0200
Message-ID: <87v8ti7xah.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:

> The max cpu type is a better default cpu type for running tests
> with TCG as it provides the maximum possible feature set. Also,
> the max cpu type was introduced in QEMU v2.12, so we should be
> safe to switch to it at this point.
>
> There's also a 32-bit arm max cpu type, but we leave the default
> as cortex-a15, because compilation requires we specify for which
> processor we want to compile and there's no such thing as a 'max'.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  configure | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/configure b/configure
> index 5b7daac3c6e8..1474dde2c70d 100755
> --- a/configure
> +++ b/configure
> @@ -223,7 +223,7 @@ fi
>  [ -z "$processor" ] && processor="$arch"
>  
>  if [ "$processor" = "arm64" ]; then
> -    processor="cortex-a57"
> +    processor="max"
>  elif [ "$processor" = "arm" ]; then
>      processor="cortex-a15"
>  fi

This looks correct, but the "processor" usage is confusing, as it seems
to cover two different things:

- what processor to compile for; this is what configure help claims
  "processor" is used for, but it only seems to have that effect on
  32-bit arm
- which cpu model to use for tcg on 32-bit and 64-bit arm (other archs
  don't seem to care)

So, I wonder whether it would be less confusing to drop setting
"processor" for arm64, and set the cpu models for tcg in arm/run (if
none have been specified)?

