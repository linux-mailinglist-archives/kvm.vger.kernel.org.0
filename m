Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941386D647D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbjDDOAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbjDDOAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:00:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D1AFC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680616649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYn7OYIVH83txTjtRmdLLOaHNTCqXl6caXuullcfhyc=;
        b=HkW/D4dAF8CRlnGdFLoszg+zk9GkE41dBCuZv+GHZNda5tId2ecpc6eMz0JEXhbJQSweyD
        Cho7oLR3+WDUDAplSGTuMW50UZ/TymiZA0+dhAwhyRRzzTKItgPRx3z8zyeU75ivKwowv7
        xdfSaqubTGCzlglkB95ekxaeHf37zQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-7LQDqqgVOqK7cz1eWn9vKA-1; Tue, 04 Apr 2023 09:57:26 -0400
X-MC-Unique: 7LQDqqgVOqK7cz1eWn9vKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B5A101A551;
        Tue,  4 Apr 2023 13:57:21 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B8FA2027062;
        Tue,  4 Apr 2023 13:57:18 +0000 (UTC)
Date:   Tue, 4 Apr 2023 15:57:17 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>, armbru@redhat.com
Subject: Re: [PATCH v2 05/11] qemu-options: finesse the recommendations
 around -blockdev
Message-ID: <ZCwsvaxRzx4bzbXo@redhat.com>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
 <20230403134920.2132362-6-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403134920.2132362-6-alex.bennee@linaro.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 03.04.2023 um 15:49 hat Alex Bennée geschrieben:
> We are a bit premature in recommending -blockdev/-device as the best
> way to configure block devices, especially in the common case.
> Improve the language to hopefully make things clearer.
> 
> Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20230330101141.30199-5-alex.bennee@linaro.org>
> ---
>  qemu-options.hx | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 59bdf67a2c..9a69ed838e 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -1143,10 +1143,14 @@ have gone through several iterations as the feature set and complexity
>  of the block layer have grown. Many online guides to QEMU often
>  reference older and deprecated options, which can lead to confusion.
>  
> -The recommended modern way to describe disks is to use a combination of
> +The most explicit way to describe disks is to use a combination of
>  ``-device`` to specify the hardware device and ``-blockdev`` to
>  describe the backend. The device defines what the guest sees and the
> -backend describes how QEMU handles the data.
> +backend describes how QEMU handles the data. The ``-drive`` option
> +combines the device and backend into a single command line options
> +which is useful in the majority of cases. Older options like ``-hda``
> +bake in a lot of assumptions from the days when QEMU was emulating a
> +legacy PC, they are not recommended for modern configurations.

Let's not make the use of -drive look more advisable than it really is.
If you're writing a management tool/script and you're still using -drive
today, you're doing it wrong.

Maybe this is actually the point where we should just clearly define
that -blockdev is the only supported stable API (like QMP), and that
-drive etc. are convenient shortcuts for human users with no
compatibility promise (like HMP).

What stopped us from doing so is that there are certain boards that
don't allow the user to configure the onboard devices, but that look at
-drive. These wouldn't provide any stable API any more after this
change. However, if this hasn't been solved in many years, maybe it's
time to view it as the board's problem, and use this change to motivate
them to implement ways to configure the devices. Or maybe some don't
even want to bother with a stable API, who knows.

Kevin

