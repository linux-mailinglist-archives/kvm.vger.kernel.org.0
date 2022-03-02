Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782094CA943
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiCBPjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiCBPjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:39:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D9986C7C2C
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 07:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646235530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2bLaqf8zZzG+Mk9l9cA2M2oVm1v17+4Q4r3Pv+L0Fb8=;
        b=WWFrjR+fTdyrOzJAxYBXDI+doz11/qgCsJfNymycJL7A4TeHG4DVBwc07gX0fi7FYGa6kx
        Ds8gqDqzPtPBaQGZRydunewH+OzyEeQ25H1hY29ucxWJyse88qdxt27mgKL7xlJBoeXqkP
        u/QARMZOzRgfdhGKnTpv08HKXTULGm4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-mqEy3_S2OX2VZuYwKVy01Q-1; Wed, 02 Mar 2022 10:38:49 -0500
X-MC-Unique: mqEy3_S2OX2VZuYwKVy01Q-1
Received: by mail-oo1-f72.google.com with SMTP id z4-20020a4ad1a4000000b0031beb2043f7so1436148oor.20
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 07:38:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2bLaqf8zZzG+Mk9l9cA2M2oVm1v17+4Q4r3Pv+L0Fb8=;
        b=yaNavfmdRVjH5FOsrzdGklj50hgxNwQBpIxEv+NdDGIr6pCm1jrnR9hth10JYKwUuM
         Xdd8tX/f9UinyWgicgSWYM6W0SiOmfLMB/Qm/m6MJFj4bMRw+3+7m0+tyo/4iKzNEBOz
         H/HANLTnthOqJd7FbSTJWxOKWMB6LPnwWe019cZ0y2chakeB0Hb1CGD250I2ardd0uDo
         WNrohD3k9JMyIFiO1E9kLG2N4f65i/BUdcbICynp/2jE5bbuGgzYkXBdVBABPzPEGsmn
         72FITAlLYEjuw9CkrSuBhk+n/mmONrDDmMDoSO4i/4sIBZDaR8W79izs2LC7QzG9+A4z
         mWZQ==
X-Gm-Message-State: AOAM532aSs8oti+OxnlG9ik/ze3parXSMyEKkmCppN4hStzP69jdc/gS
        aJ8veEk6f4Go5G5yWZDRrLy48NllYwHlFypbH+O488PF+BnbIIRJZWmcTGjY7dJhwzuSwtXcpwr
        ZnlvIld/ijW1P
X-Received: by 2002:a05:6830:2908:b0:5ad:1ed7:70ea with SMTP id z8-20020a056830290800b005ad1ed770eamr15951691otu.186.1646235528341;
        Wed, 02 Mar 2022 07:38:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsq68iTiCIfg5IQs6o2AS7Q9lBJl+mszGsi/lLInLk2Mtj8Nz6mg+OCfT3JRVOvQi0XeGosA==
X-Received: by 2002:a05:6830:2908:b0:5ad:1ed7:70ea with SMTP id z8-20020a056830290800b005ad1ed770eamr15951675otu.186.1646235528094;
        Wed, 02 Mar 2022 07:38:48 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c26-20020a4ae25a000000b0031c268c5436sm7783319oot.16.2022.03.02.07.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 07:38:47 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:38:45 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, vgoyal@redhat.com,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] Allow returning EventNotifier's wfd
Message-ID: <20220302083845.02433972.alex.williamson@redhat.com>
In-Reply-To: <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
References: <20220302113644.43717-1-slp@redhat.com>
        <20220302113644.43717-2-slp@redhat.com>
        <20220302081234.2378ef33.alex.williamson@redhat.com>
        <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Mar 2022 16:23:42 +0100
Sergio Lopez <slp@redhat.com> wrote:

> On Wed, Mar 02, 2022 at 08:12:34AM -0700, Alex Williamson wrote:
> > On Wed,  2 Mar 2022 12:36:43 +0100
> > Sergio Lopez <slp@redhat.com> wrote:
> >   
> > > event_notifier_get_fd(const EventNotifier *e) always returns
> > > EventNotifier's read file descriptor (rfd). This is not a problem when
> > > the EventNotifier is backed by a an eventfd, as a single file
> > > descriptor is used both for reading and triggering events (rfd ==
> > > wfd).
> > > 
> > > But, when EventNotifier is backed by a pipefd, we have two file
> > > descriptors, one that can only be used for reads (rfd), and the other
> > > only for writes (wfd).
> > > 
> > > There's, at least, one known situation in which we need to obtain wfd
> > > instead of rfd, which is when setting up the file that's going to be
> > > sent to the peer in vhost's SET_VRING_CALL.
> > > 
> > > Extend event_notifier_get_fd() to receive an argument which indicates
> > > whether the caller wants to obtain rfd (false) or wfd (true).  
> > 
> > There are about 50 places where we add the false arg here and 1 where
> > we use true.  Seems it would save a lot of churn to hide this
> > internally, event_notifier_get_fd() returns an rfd, a new
> > event_notifier_get_wfd() returns the wfd.  Thanks,  
> 
> I agree. In fact, that's what I implemented in the first place. I
> changed to this version in which event_notifier_get_fd() is extended
> because it feels more "correct". But yes, the pragmatic option would
> be adding a new event_notifier_get_wfd().
> 
> I'll wait for more reviews, and unless someone voices against it, I'll
> respin the patches with that strategy (I already have it around here).

I'd argue that adding a bool as an arg to a function to change the
return value is sufficiently non-intuitive to program for that the
wrapper method is actually more correct.  event_notifier_get_fd()
essentially becomes a shorthand for event_notifier_get_rfd().  Thanks,

Alex

