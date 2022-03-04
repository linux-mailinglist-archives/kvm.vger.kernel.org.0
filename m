Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FE04CD282
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiCDKjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiCDKjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:39:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7CC9150409
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646390311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lz5RITfbuxi7prNXljqL/BkcwaBGah78jbB9QQ7ar/o=;
        b=W6qkFiHelSwniSLEctyUSRlCYovL71E46got5geGT+e7z05qIHcy1/fg5VX7zr/+6QUL+a
        yAv5uHnmuTQvKF5yXCesc/q9yrn7X7UqxmR991uhnmyizhb/RMwRTn++1gj5dpLY+SbneF
        FeELWYCs5A9Cbh2OVvH+lrh997VuqQY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-4JIWhh2dMNWhKUNFNKEMjg-1; Fri, 04 Mar 2022 05:38:30 -0500
X-MC-Unique: 4JIWhh2dMNWhKUNFNKEMjg-1
Received: by mail-wm1-f70.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso2590323wmz.0
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 02:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lz5RITfbuxi7prNXljqL/BkcwaBGah78jbB9QQ7ar/o=;
        b=yXWM9b2Jc+G0a+i1xiZQHpvmKWdzV4QyAuN/LCg32+K6PlN+JfsZtGe5hsjOhVnJ9n
         +txT43Dei3z4+ANsRwQ9F9fduTqQuUDAoZeqjnrXMRtpS4V4VozgSWtjjDKlsbFA4Ict
         Uvzk7JQQA3sBb4hu+ZfcqhdEYF7QvIAqU+gbu35mu6XaFOyC1+iqqJH/9Lme2DWHD3Hi
         AYNq+9tm7gQKPwHAeLnxtUQum6p/TiXiIg90toUCRjUhcOwOpZ6lFkhS3sgkRLRAMWS8
         7x5+DL340sWCvPvKMispc5O+y9ST8ZlR1U9fu5VeBZvgdGtAwIMe1uYGQ/OPoDWl9QE+
         IHTg==
X-Gm-Message-State: AOAM5331PPzp9TzwirB1Anyxuv2YidzstPI6oudjj4xtoRFeXkEPKTgz
        l+CMh3NJ24FUyHl9ca34TnQ9NDwVdEr20hZzSG/Y7AWB7dALNuVddID0lKp+mPiV75E235xauty
        Ib4D4LVQQjf+T
X-Received: by 2002:a5d:6b06:0:b0:1e3:3e52:8a6 with SMTP id v6-20020a5d6b06000000b001e33e5208a6mr29170203wrw.148.1646390308821;
        Fri, 04 Mar 2022 02:38:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWSO2vMtR421emZNfVw1PPEBsPuI7pwJ1SnQREXhldYhaQLx8hgCPGjgLYLXwejapDNC0UGw==
X-Received: by 2002:a5d:6b06:0:b0:1e3:3e52:8a6 with SMTP id v6-20020a5d6b06000000b001e33e5208a6mr29170192wrw.148.1646390308607;
        Fri, 04 Mar 2022 02:38:28 -0800 (PST)
Received: from redhat.com ([2.52.16.157])
        by smtp.gmail.com with ESMTPSA id e6-20020a5d5006000000b001e75916a7c2sm4242027wrt.84.2022.03.04.02.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 02:38:27 -0800 (PST)
Date:   Fri, 4 Mar 2022 05:38:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        John G Johnson <john.g.johnson@oracle.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        qemu-s390x@nongnu.org, vgoyal@redhat.com,
        Jagannathan Raman <jag.raman@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v3 0/4] Enable vhost-user to be used on BSD systems
Message-ID: <20220304053759-mutt-send-email-mst@kernel.org>
References: <20220303115911.20962-1-slp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303115911.20962-1-slp@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 12:59:07PM +0100, Sergio Lopez wrote:
> Since QEMU is already able to emulate ioeventfd using pipefd, we're already
> pretty close to supporting vhost-user on non-Linux systems.
> 
> This two patches bridge the gap by:
> 
> 1. Adding a new event_notifier_get_wfd() to return wfd on the places where
>    the peer is expected to write to the notifier.
> 
> 2. Modifying the build system to it allows enabling vhost-user on BSD.
> 
> v1->v2:
>   - Drop: "Allow returning EventNotifier's wfd" (Alex Williamson)
>   - Add: "event_notifier: add event_notifier_get_wfd()" (Alex Williamson)
>   - Add: "vhost: use wfd on functions setting vring call fd"
>   - Rename: "Allow building vhost-user in BSD" to "configure, meson: allow
>     enabling vhost-user on all POSIX systems"
>   - Instead of making possible enabling vhost-user on Linux and BSD systems,
>     allow enabling it on all non-Windows platforms. (Paolo Bonzini)


I picked 1,2.
Waiting on updated doc patch to apply 3,4.

> v2->v3:
>   - Add a section to docs/interop/vhost-user.rst explaining how vhost-user
>     is supported on non-Linux platforms. (Stefan Hajnoczi)
> 
> Sergio Lopez (4):
>   event_notifier: add event_notifier_get_wfd()
>   vhost: use wfd on functions setting vring call fd
>   configure, meson: allow enabling vhost-user on all POSIX systems
>   docs: vhost-user: add subsection for non-Linux platforms
> 
>  configure                     |  4 ++--
>  docs/interop/vhost-user.rst   | 18 ++++++++++++++++++
>  hw/virtio/vhost.c             |  6 +++---
>  include/qemu/event_notifier.h |  1 +
>  meson.build                   |  2 +-
>  util/event_notifier-posix.c   |  5 +++++
>  6 files changed, 30 insertions(+), 6 deletions(-)
> 
> -- 
> 2.35.1
> 

