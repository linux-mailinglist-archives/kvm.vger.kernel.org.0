Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67769645D9C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLGP2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLGP2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:28:12 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E812A45081
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:28:11 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id h24so16367971qta.9
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XGO1FhZWkK5TOsydyJB0fKSPiWUBE/AEvRVZM+ENXt4=;
        b=dHdBHJiYFWRdN1Mj4BBrRwZL0r4zfVE2pQTjL+t5GyvUr6J48QaNwkCeqn8E6KUy+/
         ddOg25EgvQSeLgy39ety8J+lc4FC1NiQuomIkQ1TtdLkwtfTo0LIBuxHc2sgiU68IEPA
         7LgAiuMSdblrpZHDDsB17C1HMJvIae2xZFqvxlOycWFqnhsnCsvmqkaFanFzgBeKv+Jt
         4iegXYZ1LG1bFQFaR6oZwtij/1lRNv67GZ8PtXsnRrbx5xOSQNoYxU6GNRvv49lQG99L
         h2G5aPAaBvwZB/p+2hy5lyIopkJ3qZZMVvR76Eiuz6Iz+2gGMe1CZmg9Jca7RZ2fQq14
         I8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGO1FhZWkK5TOsydyJB0fKSPiWUBE/AEvRVZM+ENXt4=;
        b=oX84wipqL0oakWI4efVQmkpgGmtdgeW186rSYigCgUU2aGj8T5SatLQ3sHJYuOilvQ
         65XRdJzJA+sczkufpCebLC/tnkbdWt6dhG6vTFkUjzWW/22yAfM0Ny9y7U4cXgSjqSCk
         UPi17GjCYSd76bqwbPXEyCV75/aBieJw85DjoaCz7j5moofPq6ynRtBDj8/qGRA07GXD
         fj3ZR0dZ2TPRxS5fmoVIpFpmr8ukHg8ZhNEmGYlXRJvDbUM+YXXN5nR3/5f3M8MTV8aS
         tjd0n119Jp1j/HZEa9+rSwy4/bhdfnhWtecV5fS0M+FsyrujopxirZ/X8oOLqG8xr+ew
         u7yg==
X-Gm-Message-State: ANoB5pnkW9cxR5bRgviTz5Wwmej5Tcitv4cOI/PZJt3HHGbKkePtvCqR
        obtlaOXA3VaO0jMAz7F4QTnFcw==
X-Google-Smtp-Source: AA0mqf5QkiHAOGDhU59+JIz4+mx1iY7RDHdC+NI8ZBAk3BCnuRlBVlyvrH/lZ/fFjV7iTQsxEqMRdA==
X-Received: by 2002:a05:622a:4d96:b0:3a6:8ddd:5095 with SMTP id ff22-20020a05622a4d9600b003a68ddd5095mr7617494qtb.145.1670426891116;
        Wed, 07 Dec 2022 07:28:11 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id l28-20020a37f91c000000b006fca1691425sm16160908qkj.63.2022.12.07.07.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:28:10 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2wLB-005Edj-Up;
        Wed, 07 Dec 2022 11:28:09 -0400
Date:   Wed, 7 Dec 2022 11:28:09 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 2/8] vfio/type1: dma owner permission
Message-ID: <Y5CxCS53/aBT14EH@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-3-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670363753-249738-3-git-send-email-steven.sistare@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:55:47PM -0800, Steve Sistare wrote:
> The first task to pin any pages becomes the dma owner, and becomes the only
> task allowed to pin.  This prevents an application from exceeding the
> initial task's RLIMIT_MEMLOCK by fork'ing and pinning in children.

We do not need to play games with the RLIMIT here - RLIMIT is
inherently insecure and if fork is available then the process can blow
past the sandbox limit. There is nothing we can do to prevent this in
the kernel, so don't even try.

iommufd offers the user based limit tracking which prevents this
properly.

And we are working on cgroup based limit tracking that is the best
option to solve this problem.

I would rather see us focus on the cgroup stuff than this.

Jason
