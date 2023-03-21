Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9166C377B
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCUQ5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCUQ52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ABC4FF15
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679417786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9OqcAcS7FNBCqJpb8LojZmWJLhRai7O1ouWODgUg8X0=;
        b=JEg1OBuH4dG3TBksk429UdK/uW4Gje196Awb6Xo7jF1tJkXpebyxsOxhqoNODXymgkrS1N
        3cMsp/CQ2eD/24bp/iHPb0jzy21supkUCsjiFKzG/QaU17EffjWrTBqadjb2Nn502O1iOu
        ISZMEnSac1QGzTBhIrGLuq13NlkA3x0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-anT9EMW9NruOruHojfLxnQ-1; Tue, 21 Mar 2023 12:56:25 -0400
X-MC-Unique: anT9EMW9NruOruHojfLxnQ-1
Received: by mail-wm1-f71.google.com with SMTP id m27-20020a05600c3b1b00b003ee502f1b16so168863wms.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417783;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9OqcAcS7FNBCqJpb8LojZmWJLhRai7O1ouWODgUg8X0=;
        b=c0zY3lyASiWQLEjwa1aw0Tv12Os5qjSYOUq2d9g0QdM+v1oG6bhLwzW9CLbXe/40HU
         oXLDyBSMBCnTUGBt5Wszhw+xWSp0+ejuc2Y4jmBKX6Y4STtSMZd6NVJTzQX+wsPAg7QT
         m2/49wk8wlXvIo+tcrVxV1CnLwmD0c6BSuyFQ6t62wJJTsGFRVWTysglVLpdcVLDbjX3
         ntAUGkxxpWzSeq5GoF1oopO1/CLwcVY4mw0bfX8zX1SzynhTbfmxdxK5NDLegHXcTPha
         s/eIZdna1585BpwOhIYyhItO6b/LctYFpIbV3eVgXEWV5qEfYmfjqI/2s14FayfW1gcu
         5UfA==
X-Gm-Message-State: AO0yUKW0J2UTbxtI3SVMAYRgU4NU/+g7xQ2Opy2WG/+ITamEUzhFZl3/
        DP5nTSCeOuk3C1tRhKvc2sajYcu9Iw9zZiB+1ypStxYiJqRy/Z0j+AUBlN4A5P1dAA2CEH/2ZJj
        wyGsjtiIOAK7DAy07SNB5
X-Received: by 2002:a5d:54c1:0:b0:2ce:9da7:6d42 with SMTP id x1-20020a5d54c1000000b002ce9da76d42mr3148431wrv.38.1679417783651;
        Tue, 21 Mar 2023 09:56:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set9VlqhK62PIZ1ifVe9xiKQRc0PeyNde10rompP/NnikUzFrHTHj5ki6GBJAVhBpZihOwxnJAw==
X-Received: by 2002:a5d:54c1:0:b0:2ce:9da7:6d42 with SMTP id x1-20020a5d54c1000000b002ce9da76d42mr3148413wrv.38.1679417783301;
        Tue, 21 Mar 2023 09:56:23 -0700 (PDT)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id x12-20020a5d650c000000b002c5544b3a69sm11738114wru.89.2023.03.21.09.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 09:56:22 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:56:20 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBnhtEsMhuvwfY75@work-vm>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBnMZsWMJMkxOelX@suse.de>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Jörg Rödel (jroedel@suse.de) wrote:
> Hi Dave,
> 
> On Tue, Mar 21, 2023 at 03:06:19PM +0000, Dr. David Alan Gilbert wrote:
> > Interesting; it would have been nice to have known about this a little
> > earlier, some people have been working on stuff built on top of the AMD
> > one for a while.
> 
> Sorry for that, we wanted to have it in a state where it could at least
> boot an SMP Linux guest. It took us some more time to get the
> foundations right and get to that point.
> 
> > You mention two things that I wonder how they interact:
> > 
> >   a) TPMs in the future at a higher ring
> >   b) Making (almost) unmodified guests
> > 
> > What interface do you expect the guest to see from the TPM - would it
> > look like an existing TPM hardware interface or would you need some
> > changes?
> 
> For a) without b) the guest interface will be the SVSM TPM protocol. The
> ring-0 code will forward any request to the TPM process and return to
> the guest when it is done.
> 
> For b), or the paravisor mode, this is the vision, which is probably
> more than a year out. The idea behind that is to be able to emulate what
> Hyper-V is doing to boot Windows guests under SEV-SNP on an open source
> SW stack.
> 
> How the TPM interface will look like for that paravisor mode is not
> clear yet. In theory we can emulate a real TPM interface to make this
> work, but that is not sure yet.

OK, I'm just trying to avoid having guests that have a zillion different
TPM setups for different SVSM and clouds.

Timing is a little tricky here; in many ways the thing that sounds
nicest to me about Coconut is the mostly-unmodified guest (b) - but if
that's a while out then hmm.

Dave

> Regards,
> 
> -- 
> Jörg Rödel
> jroedel@suse.de
> 
> SUSE Software Solutions Germany GmbH
> Frankenstraße 146
> 90461 Nürnberg
> Germany
> 
> (HRB 36809, AG Nürnberg)
> Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

