Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC5C52A51E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 16:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349164AbiEQOn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 10:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347404AbiEQOnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 10:43:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B643E2E0BC
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652798602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EUOebm1848nquUkzsfc+CUVVZX634BgGKga1hmkbgcs=;
        b=JYr0zcYASDkdzm4e4hSQyyQpoTusPSIrikhLHVE/FfVSqu7ivP5aVZg9ZgeXT4BSnXeLNr
        kdqibrUEjjlC9j87HLDwNB5qcMOjHvPzORHU48l8HzejER5WtZAPb/hA0mID6vIOc+6iIb
        QevMTL6h3W5r4Irl+ArtRz3jgiMAjbM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-hGe1Zt3kNJi_Xa8kR3S5zg-1; Tue, 17 May 2022 10:43:21 -0400
X-MC-Unique: hGe1Zt3kNJi_Xa8kR3S5zg-1
Received: by mail-ej1-f69.google.com with SMTP id gn26-20020a1709070d1a00b006f453043956so7477847ejc.15
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 07:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EUOebm1848nquUkzsfc+CUVVZX634BgGKga1hmkbgcs=;
        b=JwlL8ki98Iwo6FGE/bNNnDI4LbpVfWvwcsPwO3F69mHmhElq9EZQcDJqFfEBs1fD1F
         0GLDmVVAuzRrPwyDLYNF6kddyAfpYAYIZz4bR6JG1Bulptc9CgSFIjzrYkId4i785ub5
         8QVetB1OkqoNo9HL6ECiUdK2zhhDuM8pYT9hl0GEPxSuMoHQSTYpnnwu2RvpOOBunrzT
         +TscnYv5MtWJzCcCEwNmBL9xsaSmNYt2+jaDcTlYcNgmNY+8PW9Cb5OLNtSgMFptdxuy
         XgAxEb7Lo+YKwtor13AK7Eho9EDwL0fQEVNGReazjby+nkdMIfpeeQs9z7LVq55W6fLv
         ikTA==
X-Gm-Message-State: AOAM5334Edigy4kezSGAqHKwdlEkF3Ly49XLz7nHlgjjr3GQ/xAXbfrD
        RErFyxtAHEQcwCuVYxjh7rmsQgEbXM+VhCw3ux1hPzuglWIpjmrPQXMweJg0hx6K++1ToNp/zD6
        TeIPKxnTZhz93
X-Received: by 2002:a17:907:7e84:b0:6fe:2a21:1467 with SMTP id qb4-20020a1709077e8400b006fe2a211467mr10719927ejc.673.1652798599929;
        Tue, 17 May 2022 07:43:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlnoJM/lXQ64XKdKCEL4Apv61bFcxyV3tHdLZlG0EczC2ChtveMzId+2dKEbYOZdkVKaMbrw==
X-Received: by 2002:a17:907:7e84:b0:6fe:2a21:1467 with SMTP id qb4-20020a1709077e8400b006fe2a211467mr10719913ejc.673.1652798599759;
        Tue, 17 May 2022 07:43:19 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id t23-20020aa7d717000000b0042ac7b34b4asm1153428edq.81.2022.05.17.07.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 07:43:19 -0700 (PDT)
Date:   Tue, 17 May 2022 16:43:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on
 arm64 systems
Message-ID: <20220517144317.ggdesc23xgxq6pnh@gator>
References: <20220317165601.356466-1-alexandru.elisei@arm.com>
 <20220317174507.jt2rattmtetddvsq@gator>
 <YjN3xyfiLU2RUdGr@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjN3xyfiLU2RUdGr@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 06:03:07PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Mar 17, 2022 at 06:45:07PM +0100, Andrew Jones wrote:
> > On Thu, Mar 17, 2022 at 04:56:01PM +0000, Alexandru Elisei wrote:
> > > From: Andrew Jones <drjones@redhat.com>
> > > 
> > > If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
> > > be run by using the TCG accelerator. In this case use TCG instead of KVM.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > [ Alex E: Added commit message ]
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arm/run | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 28a0b4ad2729..128489125dcb 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
> > >  fi
> > >  processor="$PROCESSOR"
> > >  
> > > -ACCEL=$(get_qemu_accelerator) ||
> > > +accel=$(get_qemu_accelerator) ||
> > >  	exit $?
> > >  
> > > -if [ "$ACCEL" = "kvm" ]; then
> > > +if [ "$accel" = "kvm" ]; then
> > >  	QEMU_ARCH=$HOST
> > >  fi
> > >  
> > >  qemu=$(search_qemu_binary) ||
> > >  	exit $?
> > >  
> > > +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > > +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> > > +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> > > +	accel=tcg
> > > +fi
> > > +
> > > +ACCEL=$accel
> > > +
> > >  if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> > >  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> > >  	exit 2
> > > -- 
> > > 2.35.1
> > >
> > 
> > Ha, OK, I guess you posting this is a strong vote in favor of this
> > behavior. I've queued it
> 
> Ah, yes, maybe I should've been more clear about it. I think this is more
> intuitive for the new users who might not be very familiar with
> run_tests.sh internals, and like you've said it won't break existing users
> who had to set ACCEL=tcg to get the desired behaviour anyway.
> 
> Thanks you for queueing it so fast! Should probably have also mentioned
> this as a comment in the commit, but I take full responsibility for
> breaking stuff.
> 
> Alex
> 
> > 
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

I finally merged this.

Thanks,
drew

