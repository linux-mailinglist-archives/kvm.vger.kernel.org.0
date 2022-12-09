Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC54A648928
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLITng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLITnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:43:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB62B37F6
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670614938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jq0LQTQBg0+rmhWGIeMnIJne4xa5LaY7FdOCo+93wIE=;
        b=aCSIK8UYvWWLksdRKAxcvjQsztPCv+Nhl6EE/pWUmIbt4ame0/o277EvDVSYxB5nnz2jfP
        XFFPSQKhHi2bQvu6VarUmFdfTkn56FPQ/3x83sZZgWwxl1MR8kxV+RQp3ipAOQ45Zb38DT
        lkfHXaEZMLH+SMDijv9LCoNLEBympGk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-V522KiA4OfS5jvHD1HxBIg-1; Fri, 09 Dec 2022 14:42:17 -0500
X-MC-Unique: V522KiA4OfS5jvHD1HxBIg-1
Received: by mail-io1-f69.google.com with SMTP id l22-20020a05660227d600b006dfa191ca8aso2707039ios.20
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 11:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jq0LQTQBg0+rmhWGIeMnIJne4xa5LaY7FdOCo+93wIE=;
        b=z3OABCx0q5zClHwr+7w4TpB2DCoAiDZi3NdrPk4hSYfhcE0+JWjFUoRxAmYvaUdQy9
         r8bMxHggf1fLqCVDxphybApStvpqdodEiwdXXSngcBUvia2qEfPpLcbm1G4ikEC9n6st
         p/35JJlzauYef75BTv7nOp+F0nqxyIGm3aZtZ5zBknIOa9qQU4kmdjItB2UFPJplUqPC
         423w+fscTVIez3jW4+YXCVjsGMvwmN1FufgxbKbtVHTXn4ylCQhYxEhBZb5yP6p2TCsM
         roxAcIDOe+uvXPtZtilPKaschU6u3RIo1tgrFAIqJ9eAZpBsk/BWHfqCrW0qm7gUkyye
         aWwg==
X-Gm-Message-State: ANoB5pnTHOKjNQixThGBT6r8p7Y72p7OZmd7wZ7LoGPhmWOcJk4Zf6zB
        m9wjqg1IK5+rdz5rIsMfGjifBi5pUC5jsMt4Uj5vBeJwFzSq/1iNNcqYzUa/vF/tICTFJLYCl/q
        5FaAs4+gY5cgQ
X-Received: by 2002:a05:6e02:dcd:b0:303:14e5:939b with SMTP id l13-20020a056e020dcd00b0030314e5939bmr4121507ilj.32.1670614936294;
        Fri, 09 Dec 2022 11:42:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7HDCfG8HIirddDBy5abfmsh3Z13s4dFWYbmbzWXP0z6slaAKwR8U7kO+M1HJHsaj3PRv6PRw==
X-Received: by 2002:a05:6e02:dcd:b0:303:14e5:939b with SMTP id l13-20020a056e020dcd00b0030314e5939bmr4121505ilj.32.1670614936021;
        Fri, 09 Dec 2022 11:42:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c4-20020a92d3c4000000b00302e09e0bb2sm669724ilh.50.2022.12.09.11.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 11:42:15 -0800 (PST)
Date:   Fri, 9 Dec 2022 12:42:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221209124212.672b7a9c.alex.williamson@redhat.com>
In-Reply-To: <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
References: <167044909523.3885870.619291306425395938.stgit@omen>
        <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20221208094008.1b79dd59.alex.williamson@redhat.com>
        <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Dec 2022 13:40:29 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/8/2022 11:40 AM, Alex Williamson wrote:
> > On Thu, 8 Dec 2022 07:56:30 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> >>> From: Alex Williamson <alex.williamson@redhat.com>
> >>> Sent: Thursday, December 8, 2022 5:45 AM
> >>>
> >>> Fix several loose ends relative to reverting support for vaddr removal
> >>> and update.  Mark feature and ioctl flags as deprecated, restore local
> >>> variable scope in pin pages, remove remaining support in the mapping
> >>> code.
> >>>
> >>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>> ---
> >>>
> >>> This applies on top of Steve's patch[1] to fully remove and deprecate
> >>> this feature in the short term, following the same methodology we used
> >>> for the v1 migration interface removal.  The intention would be to pick
> >>> Steve's patch and this follow-on for v6.2 given that existing support
> >>> exposes vulnerabilities and no known upstream userspaces make use of
> >>> this feature.
> >>>
> >>> [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
> >>> steven.sistare@oracle.com/
> >>>     
> >>
> >> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >>
> >> btw given the exposure and no known upstream usage should this be
> >> also pushed to stable kernels?  
> > 
> > I'll add to both:
> > 
> > Cc: stable@vger.kernel.org # v5.12+  
> 
> We maintain and use a version of qemu that contains the live update patches,
> and requires these kernel interfaces. Other companies are also experimenting 
> with it.  Please do not remove it from stable.

The interface has been determined to have vulnerabilities and the
proposal to resolve those vulnerabilities is to implement a new API.
If we think it's worthwhile to remove the existing, vulnerable interface
in the current kernel, what makes it safe to keep it for stable kernels?

Existing users that could choose not to accept the revert in their
downstream kernel and allowing users evaluating the interface more time
before they know it's been removed upstream, are not terribly
compelling reasons to keep it in upstream stable kernels.  Thanks,

Alex

