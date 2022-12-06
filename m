Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA2D644575
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiLFOUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiLFOUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:20:30 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2114E2AF0
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:20:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id u5so5195390pjy.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 06:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kqoRf+XjnNXwhswsLJCrkOPC8aiO2DP0YqepNTsM5Q=;
        b=PoQVjmSy5xTwYFliGZR9OOSDBYM5gBvnpPzZAXulgAt+dJ3Yv8FA4gQGPA91tTC39N
         LGXjgSMxpNAMzBSzlnp2xg1KYYV/JyCxcLAYFBX2GZBMB0c6RiEu0J9jayvnlM8zlPWG
         TdNJ79c/8kWJX+0OpcsbH1BvWcP0DQJsxGigdO6dHgXKsTvh4pKLxnIP4dNArwZavnr0
         HBz6rREOxYExVSGE1TnP+BVjoIYmJJDAMTGM+K96jzrzY+42XewZ26j/jzggHCY5vxlf
         6X+Jvmcwo02YE8V2CwVpCFdPv6KPxJ0YwyCtTTBQptMnF+3oJt9+Bpi5mqqdqf2hToqR
         FWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kqoRf+XjnNXwhswsLJCrkOPC8aiO2DP0YqepNTsM5Q=;
        b=gwuVBBsAgfSSGeXNxXMLMZ+rVhC7Npka1Mgo9T08PMcvgnBh/kdE8WDuFFfwKJzgbL
         xJnJJZOXjmp4qy2EGTRPQ9sjSgj6hIlHxVzV30qSW+suG/6NPAQDGf75UndpOlmkZGJL
         EKMiNg/crRB1i2yL7anlOE4qcvcGBe4P8BP4BLDdcWbnP4AzNyOEkDhKazNjvKt2Es6t
         SrCbEqIT09Zf7Yft8EQ8r6CH11PlLx7FgqBS8SPKB7MdNWzknBAGdV7tvGTVYr0NRukE
         FuhObvtoNa1OdT+kWkNH8d9Y1QN1l3PFhLQtaHkqo4CpPSyP8uZOuPKo59Bs8o1mTJTk
         ShFA==
X-Gm-Message-State: ANoB5pkjgYrEDHA2XQR9FNk6L/tFYT22sqtAwIpI1dpsdP8mTwZID++F
        ivkw2kDFnLiRUKSy0UsGKp5JMA==
X-Google-Smtp-Source: AA0mqf5gHYWwo38iLmYp9F1iuP/OVjscdmaIJjaPvl1VQQ29+QjauKFugs2/SKKCFzZz6Vg4bd1Tjw==
X-Received: by 2002:a17:902:b184:b0:189:1d01:a4ae with SMTP id s4-20020a170902b18400b001891d01a4aemr71127865plr.93.1670336428643;
        Tue, 06 Dec 2022 06:20:28 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b0018997f6fc88sm12648048plk.34.2022.12.06.06.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:20:27 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2Yo6-004c0g-KS;
        Tue, 06 Dec 2022 10:20:26 -0400
Date:   Tue, 6 Dec 2022 10:20:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <Y49PqoAhZOeraLVa@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com>
 <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca>
 <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca>
 <20221206140002.GB27689@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206140002.GB27689@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 03:00:02PM +0100, Christoph Hellwig wrote:
> > >From what I understood this series basically allows two Intel devices
> > to pass a big opaque blob of data. Intel didn't document what is in
> > that blob, so I assume it captures everything you mention above.
> 
> Which would be just as bad, because it then changes the IDs under
> the live OS on a restore.  This is not something that can be done
> behind the back of the hypervisors / control plane OS.

Sorry, what live OS?

In the VFIO restore model there is no "live OS" on resume. The
load/resume cycle is as destructive as reset to the vfio device.

When qemu operates vfio the destination CPU will not be running until
the load/resume of all the VFIO devices is completed.

So from the VM perspective it sees a complete no change, so long as
the data blob causes the destination vfio device to fully match the
source, including all IDs, etc.

Jason
