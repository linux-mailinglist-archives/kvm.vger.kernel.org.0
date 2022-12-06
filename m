Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB16D6447E3
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiLFPWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiLFPWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:22:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E7B51
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 07:22:35 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s7so14227734plk.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 07:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UU8AMEdCApUKn2yCNu179y3IuDBUbfO2XN1Qp+qLAs8=;
        b=jG3sZcdZjSQIRjZkl/f7DOP3dlw758+HEdK7GWWq8fnj9XOdoNxOkBB2jC/8fB14wx
         9FNJy2pQnOLNPshZ0wncMGcgTjWilHuX1Bof33jsFVE2FkTXuTJbGdHUPK3/27UaGkvK
         M5eCBf9DWrA3/swfuE4dabHXjTiAR1WKAKwpHstU30D9ufiWl2NcIxhMoypIVrjzmYCl
         spyYHwWMmjSH6fjzFZEmEiwvpNMjodZFbFQeR2MIYjLq4JYYpySczgRZTnLObyGe9JnD
         k6I7+5uanHUHMcum9tuQsR/k+FU6BcxcU7gl4DPlzzQZx8dB4g0Mi3WATLONu2k2T3NX
         tEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UU8AMEdCApUKn2yCNu179y3IuDBUbfO2XN1Qp+qLAs8=;
        b=6Y+XVwLeecAeN8oBuByKAq/7KzJ13PRt7YDbLeOTCto8x0xoW2P8zdwMYZca56vf2i
         UX3BO7BNGXujxS9a+p+TJsVB/inju/wKdxTX7OuASChmW81EKa8v8OvaJ9ayAMiL23ei
         ITd4nwlRDfOe/bEsxX6z9tJcESn7UDQnK33S5xVlHHNynJKAAU7uJv/NIFCoFwDs/6Gi
         fEILzLeafaufn0FHzVHNUIWnNVokWP6wa1l9QKNb5AYnpwg7tmQ6xg3QxCzTPd5EUzA8
         jQyIEyv2Ps9GPfUfJ/kQ50k1QDFV4aaXceSqKOXQeV3F+9EelsJJhx49mTQJYM3ad40r
         dHjQ==
X-Gm-Message-State: ANoB5pnXTLR5OK/lVjcbl05quS1Sc3hoojir7l4Ql3Pv31biTZ30bv4X
        5/JvKOW18Beyml6PuoEVBqCdLA==
X-Google-Smtp-Source: AA0mqf4Ycm0ZpEHchEyW5wHkELYu+0YMn7TsJMJRfE0+nFFPq8XQvhmYhp2h5imhee7dmv/YvgeI/Q==
X-Received: by 2002:a17:90b:2544:b0:20a:f341:4ed9 with SMTP id nw4-20020a17090b254400b0020af3414ed9mr98991840pjb.11.1670340155171;
        Tue, 06 Dec 2022 07:22:35 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902d2c300b00176b84eb29asm12790880plc.301.2022.12.06.07.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:22:34 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2ZmD-004cnQ-5r;
        Tue, 06 Dec 2022 11:22:33 -0400
Date:   Tue, 6 Dec 2022 11:22:33 -0400
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
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y49eObpI7QoSnugu@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca>
 <20221206135810.GA27689@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206135810.GA27689@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 02:58:10PM +0100, Christoph Hellwig wrote:

> Most importantly NVMe is very quiet on the relationship between
> VFs and PFs, and there is no way to guarantee that a PF is, at the
> NVMe level, much in control of a VF at all.  In other words this
> concept really badly breaks NVMe abstractions.

Yeah, I think the spec effort is going to be interesting for sure.

From a pure Linux and implementation perspective a decision must be
made early on how to label the DMAs for kernel/qemu vs VM controlled
items at the PCI TLP level.

> controlled functions (which could very well be, and in some designs
> are, additional PFs and not VFs) by controlling function.  

In principle PF vs VF doesn't matter much - the question is really TLP
labeling. If the spec says RID A is the controlling RID and RID B is
the guest RID, then it doesn't matter if they have a PF/VF
relationship or PF/PF relationship.

We have locking issues in Linux SW connecting different SW drivers for
things that are not a PF/VF relationship, but perhaps that can be
solved.

Using VF RID / VF PASID is appealing at first glance, but there is
list of PCI emulation details that have to be worked out for that to
be good. eg what do you do with guest triggered FLR? Or guest
triggered memory disable? How do you handle PCIe AER? Also lack of
PASID support in CPUs is problematic.

Lots of trade offs..

Jason
