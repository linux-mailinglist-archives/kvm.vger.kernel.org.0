Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A076489D1
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 22:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLIVCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 16:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLIVCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 16:02:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918FAAE4F9
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 13:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670619684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dWQmkdsHq9QW+ZmGeSbWJsITDM/QLBUaKDZ10YQ4tMk=;
        b=JFitXUPxBAx/+082bszzon7tqi1CpPkIdFfTT15sneAIk26ZSonvoq0PczzpkHrV5uMzdd
        qeyb/qouigAGmSInUO84+b8W8TjbYXtCZ9+emgXG128EVLCON0ySh5vDv3hWNXuDIMfNKC
        JZc8e+Efb10iuUZxmUJSsmQmphrlZ5U=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-_fgNWSltNQKsS-MC9I-fzQ-1; Fri, 09 Dec 2022 16:01:23 -0500
X-MC-Unique: _fgNWSltNQKsS-MC9I-fzQ-1
Received: by mail-il1-f199.google.com with SMTP id d6-20020a056e02214600b00303620c6e39so676619ilv.6
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 13:01:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dWQmkdsHq9QW+ZmGeSbWJsITDM/QLBUaKDZ10YQ4tMk=;
        b=FhgQrurN7QMOM9g5mKVuaSVkWKBv0inDhnDVLluYqr0RNL8JB+aJaJmilYuYgwvv6V
         e6+i8oshVnyNA8IbSvGCqjy7yCFOX2vhA5/JV/YRhqWrL0yY58+1EIQrrUidoZ6G1Knj
         46gMLggMHuoU2o7vAnS2JwoKSGkZjofFbf9Bz0aIzlG6rqINq+pHyPNBIAtYv06nTwEu
         HCRELRaG3ydASvN39lYmHhQBtMfPGrT4ys/ucfC0nBCX4uB0rEWUqbfrqbvhw2G2Otgw
         CidwYavqTTuuxZ2ihHgyazHedTLJ4zUjxqJz4guWfR9ozY21atsx+W4Xr4ZqM27vODBX
         Vebw==
X-Gm-Message-State: ANoB5pkT3lpoNSAalwj1lVz9lNKKc9PTngGMOyp0DCVCEkZlObvNqIHJ
        UfjnbOPYDzaHLlepJMxEVhyXZ4hK0LgGEbG1xPkj4dwhSNLee3fY3lEJu5uL6IHLgDodU+0rCxX
        8A9kIskDXWMQ2
X-Received: by 2002:a6b:d812:0:b0:6e0:1a0b:dbb9 with SMTP id y18-20020a6bd812000000b006e01a0bdbb9mr4302175iob.1.1670619683011;
        Fri, 09 Dec 2022 13:01:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6EMTyflc4bLRlXHJIr6EigP7JSAk0LfsGiZWEUM2gYijKHZ+HUKjTYIvjwRMIXlYL277b0Hg==
X-Received: by 2002:a6b:d812:0:b0:6e0:1a0b:dbb9 with SMTP id y18-20020a6bd812000000b006e01a0bdbb9mr4302152iob.1.1670619682652;
        Fri, 09 Dec 2022 13:01:22 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q20-20020a027b14000000b00375ac4c5c02sm764462jac.76.2022.12.09.13.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 13:01:21 -0800 (PST)
Date:   Fri, 9 Dec 2022 14:01:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221209140120.667cb658.alex.williamson@redhat.com>
In-Reply-To: <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
References: <167044909523.3885870.619291306425395938.stgit@omen>
        <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20221208094008.1b79dd59.alex.williamson@redhat.com>
        <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
        <20221209124212.672b7a9c.alex.williamson@redhat.com>
        <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
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

On Fri, 9 Dec 2022 14:52:49 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/9/2022 2:42 PM, Alex Williamson wrote:
> > On Fri, 9 Dec 2022 13:40:29 -0500
> > Steven Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> On 12/8/2022 11:40 AM, Alex Williamson wrote:  
> >>> On Thu, 8 Dec 2022 07:56:30 +0000
> >>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >>>     
> >>>>> From: Alex Williamson <alex.williamson@redhat.com>
> >>>>> Sent: Thursday, December 8, 2022 5:45 AM
> >>>>>
> >>>>> Fix several loose ends relative to reverting support for vaddr removal
> >>>>> and update.  Mark feature and ioctl flags as deprecated, restore local
> >>>>> variable scope in pin pages, remove remaining support in the mapping
> >>>>> code.
> >>>>>
> >>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >>>>> ---
> >>>>>
> >>>>> This applies on top of Steve's patch[1] to fully remove and deprecate
> >>>>> this feature in the short term, following the same methodology we used
> >>>>> for the v1 migration interface removal.  The intention would be to pick
> >>>>> Steve's patch and this follow-on for v6.2 given that existing support
> >>>>> exposes vulnerabilities and no known upstream userspaces make use of
> >>>>> this feature.
> >>>>>
> >>>>> [1]https://lore.kernel.org/all/1670363753-249738-2-git-send-email-
> >>>>> steven.sistare@oracle.com/
> >>>>>       
> >>>>
> >>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >>>>
> >>>> btw given the exposure and no known upstream usage should this be
> >>>> also pushed to stable kernels?    
> >>>
> >>> I'll add to both:
> >>>
> >>> Cc: stable@vger.kernel.org # v5.12+    
> >>
> >> We maintain and use a version of qemu that contains the live update patches,
> >> and requires these kernel interfaces. Other companies are also experimenting 
> >> with it.  Please do not remove it from stable.  
> > 
> > The interface has been determined to have vulnerabilities and the
> > proposal to resolve those vulnerabilities is to implement a new API.
> > If we think it's worthwhile to remove the existing, vulnerable interface
> > in the current kernel, what makes it safe to keep it for stable kernels?  
> 
> I do not think it's worth while, but I have stopped fighting for 6.2.
> 
> > Existing users that could choose not to accept the revert in their
> > downstream kernel and allowing users evaluating the interface more time
> > before they know it's been removed upstream, are not terribly
> > compelling reasons to keep it in upstream stable kernels.  Thanks,  
> 
> The compelling reason is that stable is supposed to be stable and maintain
> existing interfaces, and now I will need to re-merge the interfaces at
> regular intervals when we update UEK from stable. Oracle is a current user 
> of these interfaces in our business. Do we count?

These are the rules for stable from
Documentation/process/stable-kernel-rules.rst:

 - It must be obviously correct and tested.

(check)

 - It cannot be bigger than 100 lines, with context.

(We're pushing this a bit, but we could certainly disable w/o removing
the interface in far fewer lines.  We're close enough that I think a
direct backport is preferable)

 - It must fix only one thing.

(check)

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

(This is a point where you could present an objection)

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

(This as well)

 - Serious issues as reported by a user of a distribution kernel may also
   be considered if they fix a notable performance or interactivity issue.
   As these fixes are not as obvious and have a higher risk of a subtle
   regression they should only be submitted by a distribution kernel
   maintainer and include an addendum linking to a bugzilla entry if it
   exists and additional information on the user-visible impact.

(N/A, but note the mention of a user visible impact)

 - New device IDs and quirks are also accepted.

(N/A)

 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.

(AIUI, the vulnerabilities here may not have exploits, but they are real)

 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).

(N/A)

 - It must follow the
   :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
   rules.

(Of course)

 - It or an equivalent fix must already exist in Linus' tree (upstream).

This last bullet is really the crux of what brings us to this point, if
you're not willing to defend the vulnerabilities to maintain the
interface in the mainline kernel, why should the upstream community
maintain them in the stable kernels?

The question is not about who is using the interface, it's the fact that
the resolution to the existing vulnerabilities is to remove the
interface and nobody is making a case around the validity or
exploit-ability of those vulnerabilities to carry along the interface
in the interim.

If the revert does go into mainline, but were to skip stable, that only
delays your re-merging burden briefly, while continuing to expose stable
kernels to the vulnerabilities, and risks further users adopting an
interface that no longer exists.  Thanks,

Alex

