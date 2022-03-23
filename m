Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B177B4E4D87
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 08:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiCWHrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 03:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiCWHrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 03:47:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2777771A10
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 00:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648021535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CORX4nBqIOhmV9u+b+wR9hXc3g4iCThhdDjIc63jHp4=;
        b=a/wHK8G9attDvUIsqE1YFrjakz990ySM8QPyARodUqHkxmk92/RZ7XaotTyeUy6gWe+PV+
        BKIXB5Q91oX69tDeH2hmSrj13xxyWFDJ5ldGOpDPRrbyvw14csRb6mClDga0jm7RtUb95f
        ZcQzTM8f9IdZVbE2jHoYzyd/4BFcjIo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-MJwVlglmPOSgzVEDjdWnLw-1; Wed, 23 Mar 2022 03:45:33 -0400
X-MC-Unique: MJwVlglmPOSgzVEDjdWnLw-1
Received: by mail-wr1-f72.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so216096wrp.10
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 00:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CORX4nBqIOhmV9u+b+wR9hXc3g4iCThhdDjIc63jHp4=;
        b=4SMdaIPWQURQsgOPIHxWudDu50P8GhdCU4LhalbzRJ4m7fpe670BQhcSkc6sB8y6l4
         bfY4WsK2/bLyoa0U6rwmBNk4yenWzEF/OlTpaEZRk6KU3ofRwPIl3EtmGEJl7vt4bYeg
         vAToEEBUZR0O73keVYKqDncFfCSWKWeqqdXNprakPo5h5boVWaRj0Ss+erfZG9vssQXK
         m5ORYEuldXORb5sKpjMyp3OFA0gRBHILiL6/QXoDvp2+UzYCMX5KgcCVZr+fyOT5TFvZ
         HN/o1rky6Wu/Tn4tZYjJkNDgBwqZ1djWbY3UQ3LhHbedHoZuqnexY2JioLCxZ6omkVXg
         shtQ==
X-Gm-Message-State: AOAM530EbEUxrccnvw5s5RpoPmq1uKYcpkMqoCycsFw9Uu0iVFIQSHbR
        TjWeENRLTfCMl8aAxPnFiSiq2MmRSU8stB/0S4gA324OQaUiBBOBn5rywJ/Bp+0qKm4f9aT6luH
        wyeFyDPkt6qTI
X-Received: by 2002:adf:fd44:0:b0:203:f45f:ce92 with SMTP id h4-20020adffd44000000b00203f45fce92mr21915388wrs.45.1648021532446;
        Wed, 23 Mar 2022 00:45:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz40npTJz/m9d67QKkaLGDo6gg2kPGdkQ1QbPgBU/R+5VUmuYThix2eVeOErhTc2jILZk9pcw==
X-Received: by 2002:adf:fd44:0:b0:203:f45f:ce92 with SMTP id h4-20020adffd44000000b00203f45fce92mr21915370wrs.45.1648021532213;
        Wed, 23 Mar 2022 00:45:32 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id o9-20020a1c4d09000000b0038ca75056e2sm4917668wmh.45.2022.03.23.00.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 00:45:31 -0700 (PDT)
Date:   Wed, 23 Mar 2022 08:45:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] Allow to compile without -Werror
Message-ID: <20220323074530.nxqcqmkyutfpx2pz@gator>
References: <20220322171504.941686-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322171504.941686-1-thuth@redhat.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 06:15:04PM +0100, Thomas Huth wrote:
> Newer compiler versions sometimes introduce new warnings - and compiling
> with -Werror will fail there, of course. Thus users of the kvm-unit-tests
> like the buildroot project have to disable the "-Werror" in the Makefile
> with an additional patch, which is cumbersome.
> Thus let's add a switch to the configure script that allows to explicitly
> turn the -Werror switch on or off. And enable it only by default for
> developer builds (i.e. in checked-out git repositories) ... and for
> tarball releases, it's nicer if it is disabled by default, so that the
> end users do not have to worry about this.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  See also the patch from the buildroot project:
>  https://git.busybox.net/buildroot/tree/package/kvm-unit-tests/0001-Makefile-remove-Werror-to-avoid-build-failures.patch
> 
>  Makefile  |  2 +-
>  configure | 16 ++++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

