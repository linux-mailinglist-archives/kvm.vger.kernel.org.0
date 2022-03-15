Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351844D9E75
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 16:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349565AbiCOPRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 11:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349554AbiCOPRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 11:17:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07F8B4EA21
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647357395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m/7BYXukn7buzDSsXOMYbRlp86FSMB6fqjAlxafd0GI=;
        b=DQnBmS+KGdSPWOqwElYcR+hUwYHr5OOzABO8WecjXJbU57r6MZwc6/PitAR+NPI2SHyZBX
        c6EiMARJu7WEUy8yrSetnKg+RUul1dMyk3vLJ/CGOkF5k6l9IdQVrgAn2jKQ2qXqE9xu0J
        8j8G1dPqVY1xf8bUP+hcKciCYYzWfWg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-OQpE8-UTMIOm_FlYmYKbZg-1; Tue, 15 Mar 2022 11:16:34 -0400
X-MC-Unique: OQpE8-UTMIOm_FlYmYKbZg-1
Received: by mail-wm1-f72.google.com with SMTP id i128-20020a1c3b86000000b0038a05a88880so1377431wma.1
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 08:16:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m/7BYXukn7buzDSsXOMYbRlp86FSMB6fqjAlxafd0GI=;
        b=Jq4lqnAjCMs7eerJOTGU5dYkNSFAbHVAf9q5+ht9lAY9/F4MFj2l1l8BH2rpNGEDl6
         TTneDE9TR+Uz4QMOmKc3Qm/SGhaNOiN3OG+6SWJTRAmfh3fugon6ZITKakQaLHxqzaYv
         CX9wd3iQUGEtUq5XOuuQXhczpPrav3ojMe9XlTz5znO2rS5kMjHm/MYjATurrxtE35CG
         pSPiPL9XliSHIhjBBugt4G4NAhTE6cTzuLF5ujzxn0tR6zTrWzbleOJeIQH5DOS6/8iW
         KrbYYeWI4hY2f3ZzqaHsXdZXrt/0D6dF7xsJkl9uahq++G5v0D2YbOf9w7d+JFJwPzZy
         ebOg==
X-Gm-Message-State: AOAM533RJ8CAJ9+beHCS9CcS+KFfpjAybVuK5P1eaR5+7bYmANToWn+i
        COzd9uKJ2SJD3I94MghlgzZcD9jbXEKxzgvIKg0q7M5i85c9s51LjcLU7TegKPkAZO1dq7VFs0Z
        DuyxhH3DUmEdj
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id e18-20020adfdbd2000000b001ea93826bffmr20441328wrj.705.1647357392854;
        Tue, 15 Mar 2022 08:16:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8Aa12w4oOTyt/U2Fn3zGv+XBxaSJ3EAWOWRw+ZWLtaqS3q+xxi95Suhv+sCUMw2Y229UZCA==
X-Received: by 2002:adf:dbd2:0:b0:1ea:9382:6bff with SMTP id e18-20020adfdbd2000000b001ea93826bffmr20441312wrj.705.1647357392616;
        Tue, 15 Mar 2022 08:16:32 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id l25-20020a1c7919000000b0038999b380e9sm2467699wme.38.2022.03.15.08.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 08:16:32 -0700 (PDT)
Date:   Tue, 15 Mar 2022 16:16:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <20220315151630.obxraie6ikqrwtrw@gator>
References: <20220315080152.224606-1-drjones@redhat.com>
 <YjCHcV3iyTtSrw3k@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjCHcV3iyTtSrw3k@monolith.localdoman>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 12:33:17PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Mar 15, 2022 at 09:01:52AM +0100, Andrew Jones wrote:
> > Add QEMU_ARCH, which allows run scripts to specify which architecture
> > of QEMU should be used. This is useful on AArch64 when running with
> > KVM and running AArch32 tests. For those tests, we *don't* want to
> > select the 'arm' QEMU, as would have been selected, but rather the
> > $HOST ('aarch64') QEMU.
> > 
> > To use this new variable, simply ensure it's set prior to calling
> > search_qemu_binary().
> 
> Looks good, tested on an arm64 machine, with ACCEL set to tcg -
> run_tests.sh selects qemu-system-arm; ACCEL unset - run_tests.sh selects
> ACCEL=kvm and qemu-system-aarch64; also tested on an x86 machine -
> run_tests.sh selects ACCEL=tcg and qemu-system-arm:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> One thing I noticed is that if the user sets QEMU=qemu-system-arm on an arm64
> machine, run_tests.sh still selects ACCEL=kvm which leads to the following
> failure:
> 
> SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> 
> I'm not sure if this deserves a fix, if the user set the QEMU variable I
> believe it is probable that the user is also aware of the ACCEL variable
> and the error message does a good job explaining what is wrong.

Yes, we assume the user selected the wrong qemu, rather than assuming the
user didn't expect KVM to be enabled. If we're wrong, then the error
message should hopefully imply to the user that they need to do

 QEMU=qemu-system-arm ACCEL=tcg ...

> Just in
> case, this is what I did to make kvm-unit-tests pick the right accelerator
> (copied-and-pasted the find_word function from scripts/runtime.bash):
> 
> diff --git a/arm/run b/arm/run
> index 94adcddb7399..b0c9613b8d28 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -10,6 +15,10 @@ if [ -z "$KUT_STANDALONE" ]; then
>  fi
>  processor="$PROCESSOR"
> 
> +if [ -z $ACCEL ] && [ "$HOST" = "aarch64" ] && ! find_word "qemu-system-arm" "$QEMU"; then

Instead of find_word,

 [ "$QEMU" ] && [ "$(basename $QEMU)" = "qemu-system-arm" ]

> +       ACCEL=tcg
> +fi
> +

When ACCEL is unset, we currently set it to kvm when we have /dev/kvm and
$HOST == $ARCH_NAME or ($HOST == aarch64 && $ARCH == arm) and tcg
otherwise. Adding logic like the above would allow overriding the
"set to kvm" logic when $QEMU == qemu-system-arm. That makes sense to
me, but we trade one assumption for another. We would now assume that
$QEMU is correct and the user wants to run with TCG, rather than that
$QEMU is wrong and the user wanted to run with KVM.

I think I'd prefer not adding the special case override. I think it's
more likely the user expects to run with KVM when running on an AArch64
host and that they mistakenly selected the wrong qemu, than that they
wanted TCG with qemu-system-arm. We also avoid a few more lines of code
and a change in behavior by maintaining the old assumption.

I've pushed this to arm/queue -- and MR coming up.

Thanks,
drew

