Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B114D4171
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 07:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbiCJHAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 02:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbiCJHAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 02:00:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E035C12F40A
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 22:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646895587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=skQuq6bUu9CQKoQjP/6DzDdhCXF+NhdIYDq6kSNE/tU=;
        b=CKIm+q6HiXaf/RJEI9PTJD+pjC6vmFmvbFkTCRmhKIkrJkafTDf7406ddmYDAwnK68M1wA
        ynbKwzXiZFyOGK1wLtJsqqRKzbkeIzR6TDt2Pb+yOnbrxN79mKRJ2U7UoOQhsAle7dD8Zk
        RCRhkL7YTfrsCcHI9Z6E9WMkoxNW75o=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-NfgvrOX5NEmBdFWX-mJk4w-1; Thu, 10 Mar 2022 01:59:46 -0500
X-MC-Unique: NfgvrOX5NEmBdFWX-mJk4w-1
Received: by mail-ej1-f72.google.com with SMTP id ey18-20020a1709070b9200b006da9614af58so2594368ejc.10
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 22:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=skQuq6bUu9CQKoQjP/6DzDdhCXF+NhdIYDq6kSNE/tU=;
        b=ZJVr4SD93YvHUdw82dE1qaNSYGNHcdFCHWM+phUPGR3yaM3ktcZ159J1vCJCejURwQ
         Z3PNejz/uENJTrTBff3SYwCuE0++s1ia+Gj9g59YNkgvnjJFlEHF8ZW5V6xqWErJ2cmv
         JFGvh0yyEn9HxqYIVofbH0hm0Dy1vKHked1StADKfMiSpcYRMXI3NbczhVYRYlmuYUu/
         uTyLrlLX0OUbz72YxR/Ijp5/iXJxSmoZhmFo21nqV9/ktW9D7GpCzJS1VUnxgayXoFJX
         +QVz0ELRKIWZQdD/S4Q1WD80K69y7k1s2YSQlJIEhR9vG++Nku1aQum+f7pYxb1s02hd
         6djA==
X-Gm-Message-State: AOAM531YpCcWQ/RvEUvbVIUpTo/4VY/wGTDXq9TAjXdBysKU+X3TG/sG
        mLB/aOX9q5jA1iJX51/q8X8KyVuBO+RXBOaue+9ugLStI+8urZ3OiTBl/k0rn+j4Muuqsnf+jVw
        6K+NNZSxbZ01k
X-Received: by 2002:a05:6402:518c:b0:416:b9bb:46d with SMTP id q12-20020a056402518c00b00416b9bb046dmr670695edd.297.1646895585516;
        Wed, 09 Mar 2022 22:59:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcJDnzMitALmVPhEH/srLzLmpQDrONXmjWGOdwmzwyTnp1nu72Pal3goJ8BGfiwfD2EJCK0A==
X-Received: by 2002:a05:6402:518c:b0:416:b9bb:46d with SMTP id q12-20020a056402518c00b00416b9bb046dmr670683edd.297.1646895585295;
        Wed, 09 Mar 2022 22:59:45 -0800 (PST)
Received: from gator (cst-prg-19-210.cust.vodafone.cz. [46.135.19.210])
        by smtp.gmail.com with ESMTPSA id z15-20020a170906240f00b006d703ca573fsm1446380eja.85.2022.03.09.22.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 22:59:44 -0800 (PST)
Date:   Thu, 10 Mar 2022 07:59:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] arm/run: Fix using
 qemu-system-aarch64 to run aarch32 tests on aarch64
Message-ID: <20220310065941.2na6kig2o5hxh4vx@gator>
References: <20220309162117.56681-1-alexandru.elisei@arm.com>
 <20220309162117.56681-3-alexandru.elisei@arm.com>
 <20220309165812.46xmnjek72yrv3g6@gator>
 <Yijf5TlbOKhV+Mw6@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yijf5TlbOKhV+Mw6@monolith.localdoman>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 09, 2022 at 05:12:05PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Mar 09, 2022 at 05:58:12PM +0100, Andrew Jones wrote:
> > On Wed, Mar 09, 2022 at 04:21:17PM +0000, Alexandru Elisei wrote:
> > > From: Andrew Jones <drjones@redhat.com>
> > > 
> > > KVM on arm64 can create 32 bit and 64 bit VMs. kvm-unit-tests tries to
> > > take advantage of this by setting the aarch64=off -cpu option. However,
> > > get_qemu_accelerator() isn't aware that KVM on arm64 can run both types
> > > of VMs and it selects qemu-system-arm instead of qemu-system-aarch64.
> > > This leads to an error in premature_failure() and the test is marked as
> > > skipped:
> > > 
> > > $ ./run_tests.sh selftest-setup
> > > SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> > > 
> > > Fix this by setting QEMU to the correct qemu binary before calling
> > > get_qemu_accelerator().
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > [ Alex E: Added commit message, changed the logic to make it clearer ]
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arm/run | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 2153bd320751..5fe0a45c4820 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -13,6 +13,11 @@ processor="$PROCESSOR"
> > >  ACCEL=$(get_qemu_accelerator) ||
> > >  	exit $?
> > >  
> > > +# KVM for arm64 can create a VM in either aarch32 or aarch64 modes.
> > > +if [ "$ACCEL" = kvm ] && [ -z "$QEMU" ] && [ "$HOST" = "aarch64" ]; then
> > > +	QEMU=qemu-system-aarch64
> > > +fi
> > > +
> > >  qemu=$(search_qemu_binary) ||
> > >  	exit $?
> > >  
> > > -- 
> > > 2.35.1
> > >
> > 
> > So there's a bug with this patch which was also present in the patch I
> > proposed. By setting $QEMU before we call search_qemu_binary() we may
> > force a "A QEMU binary was not found." failure even though a perfectly
> > good 'qemu-kvm' binary is present.
> 
> I noticed that search_qemu_binary() tries to search for both
> qemu-system-ARCH_NAME and qemu-kvm, and I first thought that qemu-kvm is a
> legacy name for qemu-system-ARCH_NAME.
> 
> I just did some googling, and I think it's actually how certain distros (like
> SLES) package qemu-system-ARCH_NAME, is that correct?

Right

> 
> If that is so, one idea I toyed with (for something else) is to move the error
> messages from search_qemu_binary() to the call sites, that way arm/run can first
> try to find qemu-system-aarch64, then fallback to qemu-kvm, and only after both
> aren't found exit with an error. Just a suggestion, in case you find it useful.

We don't have to move the error messages, even if we want to use
search_qemu_binary() as a silent check. We can just call it with
a &>/dev/null and then check its return code. I still need to
allocate some time to think more about this though.

Thanks,
drew

