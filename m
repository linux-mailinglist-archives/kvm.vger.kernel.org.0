Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6F570587
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiGKO1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 10:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKO1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 10:27:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49D383E778
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657549625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AbErK0bCIAQSkWRANxlcsQH4wjElnnliu1hTmkvJ0+o=;
        b=NP7Dloauy+1x1fcSYtRBLJIyDJlHth6mml5nGYVafgdVshPcI6ogMxFaOg6Nhkuo3CGOKu
        jE8uTkKBHb81WVNS+Z2xpEXwNXwb+oS/7qBKPAmCAzZlXvw1jemasUvXrGv+TPC0p/RriZ
        2Nv+9K1kISOLy0rd+JjxtWLJSziwNB4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-6_jy7fk0MNO3dIo625RhlA-1; Mon, 11 Jul 2022 10:27:04 -0400
X-MC-Unique: 6_jy7fk0MNO3dIo625RhlA-1
Received: by mail-wr1-f69.google.com with SMTP id r17-20020adfa151000000b0021d6c4743b0so697713wrr.10
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AbErK0bCIAQSkWRANxlcsQH4wjElnnliu1hTmkvJ0+o=;
        b=QOrqSoqw9zmCfVCvWo/Ww29aRNDRSoW0mH/HiHqp4ab1/K8984nzFFho4+POCkeRYm
         koJvviuo162BbSA7p0V6o4NKmoRpYWtoX4YbbIKvAtuKPiGUbgpfGaJG0+1THvgDGfKW
         NypL4o2PbeyZle+fMwdVToU2Dn17IuXDoFhV/rVJyf98jy8/n/vhiPpTjgdkg2ygywk/
         A0b5MXDissTTDH+X0lJ8arQd8M06nmXEU9uNw9ojsV2aksh3ZYW7bGCchb5uwrTXptx5
         h0xUC3ZuisBTdojlxVroHo3QypFn2a7mxQwp8pRoCVDN9XMU6cxoYN/saBfrsVoMf01G
         hMbw==
X-Gm-Message-State: AJIora8jOa9XAVBviZIsI5T9WD/T8nuJkFbi5Ao8HzIEUg/D/NuOuuny
        EiyudKnuOHn2FAzBUrSsFZAXmEkC0ZbhJ7LZ8JiZsxrvua2dg+nx5cDi5FZ2t7B1jtQj8NY7I9u
        je0DYvvNLH8mR
X-Received: by 2002:adf:f20e:0:b0:21d:8aa6:69da with SMTP id p14-20020adff20e000000b0021d8aa669damr16905742wro.66.1657549623042;
        Mon, 11 Jul 2022 07:27:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t6JrSxYzE7lTcuRNdNCGMDPUqq72htqeelx3kHencLRcEto4bMByJBBBcklphe8DQX6EU83A==
X-Received: by 2002:adf:f20e:0:b0:21d:8aa6:69da with SMTP id p14-20020adff20e000000b0021d8aa669damr16905726wro.66.1657549622871;
        Mon, 11 Jul 2022 07:27:02 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id y5-20020adff6c5000000b0021d83071683sm5922049wrp.64.2022.07.11.07.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:27:01 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:26:59 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] arm: enable MTE for QEMU + kvm
Message-ID: <YswzM/Q75rkkj/+Y@work-vm>
References: <20220707161656.41664-1-cohuck@redhat.com>
 <YswkdVeESqf5sknQ@work-vm>
 <CAFEAcA-e4Jvb-wV8sKc7etKrHYPGuOh=naozrcy2MCoiYeANDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA-e4Jvb-wV8sKc7etKrHYPGuOh=naozrcy2MCoiYeANDQ@mail.gmail.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Mon, 11 Jul 2022 at 14:24, Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> > But, ignoring postcopy for a minute, with KVM how do different types of
> > backing memory work - e.g. if I back a region of guest memory with
> > /dev/shm/something or a hugepage equivalent, where does the MTE memory
> > come from, and how do you set it?
> 
> Generally in an MTE system anything that's "plain old RAM" is expected
> to support tags. (The architecture manual calls this "conventional
> memory". This isn't quite the same as "anything that looks RAM-like",
> e.g. the graphics card framebuffer doesn't have to support tags!)

I guess things like non-volatile disks mapped as DAX are fun edge cases.

> One plausible implementation is that the firmware and memory controller
> are in cahoots and arrange that the appropriate fraction of the DRAM is
> reserved for holding tags (and inaccessible as normal RAM even by the OS);
> but where the tags are stored is entirely impdef and an implementation
> could choose to put the tags in their own entirely separate storage if
> it liked. The only way to access the tag storage is via the instructions
> for getting and setting tags.

Hmm OK;   In postcopy, at the moment, the call qemu uses is a call that
atomically places a page of data in memory and then tells the vCPUs to
continue.  I guess a variant that took an extra blob of MTE data would
do.
Note that other VMMs built on kvm work in different ways; the other
common way is to write into the backing file (i.e. the /dev/shm
whatever atomically somehow) and then do the userfault call to tell the
vcpus to continue.  It looks like this is the way things will work in
the split hugepage mechanism Google are currently adding.

Dave

> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

