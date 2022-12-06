Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84206644622
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiLFOtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiLFOtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:49:45 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA01D2AE30
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:48:24 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f3so13575076pgc.2
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 06:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3b5bdWA85OzMOTjNeR+xYtDEAbTCZli0u3K40D9kx4=;
        b=OFUOd4PNQR8bRxCK6qegIBSYa3MK8J/1a32WRukCTxAY5fTbE+omxk8YDjbYTugGMt
         YeXjCnUiKvlBk7edXLLva1LG+EYEPJj21wfIj1MmX7CR4SOWyOYUEzYSPs05BYdfhIq5
         z1IaXMgmuZsbEAXA7r01df8vhuih3NfsWItIHWKZi0n6rXD8IocqnRosa8UqEyN/8mVL
         i6iXH2dMdNFy5yDeIFaIvU+1FfeV0PfX9RbViXvdq9awFDH4LYyYXr/zLukIzNQ2rY4g
         WSup0IALJEblLWRnTR/3BL3KE6NdkyZhPvl0lshlmlVISJYUUF2mgQiKaTs/T2Pmpe+Y
         t8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3b5bdWA85OzMOTjNeR+xYtDEAbTCZli0u3K40D9kx4=;
        b=qHUM0CTCLVrMqVYm082i1K2vTdnTvemwBjMqElcbVbwYjcMJVINS2gsLycUxI60Ip/
         QSBIBX4cI6nWG42pn11zLuxYkJCeTR+GPGMz68Seb2RDRya2lSO+jiqnlGSUwcbQyy1Q
         Z79DMjlXsk20gyEylk7nigVfh/TbyIk9fkRdZaM1QAD6PMPTAqaOKAbXj0r6fIgBPsws
         YP388TrjUEmyuz0iBaTJT+J9QfjHQjQNj61y/d5FPmOFEwmV8soavY0IygpSd6QInV8k
         Sy5/7G/To3qEC4RF2zPzIZoX5CX24pEs6vbL+w0uBkUguw6p5Nh6Ouea6z8OlePeteqG
         SGzg==
X-Gm-Message-State: ANoB5pkofCnWRbCcEF9MfQ+68wDmaf0+YJyAIdTlqHChw2yg74zaCGpH
        7oayDHlTdG+rGSzu75PHjyBK0g==
X-Google-Smtp-Source: AA0mqf6wZNYJR+nxEDntmIwoB1WTx5lMm+/0X87R2SrkgFXKtucbmHuGQYhQGln4hWgCmve4UUXs+g==
X-Received: by 2002:a63:105c:0:b0:46f:f72c:cdae with SMTP id 28-20020a63105c000000b0046ff72ccdaemr62687659pgq.237.1670338104328;
        Tue, 06 Dec 2022 06:48:24 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e5c200b00186c5e8a8d7sm12785747plf.171.2022.12.06.06.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:48:23 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2ZF8-004cPA-AK;
        Tue, 06 Dec 2022 10:48:22 -0400
Date:   Tue, 6 Dec 2022 10:48:22 -0400
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
Message-ID: <Y49WNo7XWZ2aFfds@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com>
 <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca>
 <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca>
 <20221206140002.GB27689@lst.de>
 <Y49PqoAhZOeraLVa@ziepe.ca>
 <20221206143126.GB30297@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206143126.GB30297@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 03:31:26PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 10:20:26AM -0400, Jason Gunthorpe wrote:
> > In the VFIO restore model there is no "live OS" on resume. The
> > load/resume cycle is as destructive as reset to the vfio device.
> 
> Of course there may be and OS.  As soon as the VF is live Linux
> will by default bind to it.  And that's the big problem here,
> the VF should not actually exist or at least not be usable when
> such a restore happens - or to say it in NVMe terms, the Secondary
> Controller better be in offline state when state is loaded into it.

Sadly in Linux we don't have a SRIOV VF lifecycle model that is any
use.

What we do have is a transfer of control from the normal OS driver (eg
nvme) to the VFIO driver. Also, remember, that VFIO only does live
migration between VFIO devices. We cannot use live migration and end
up with a situation where the normal nvme driver is controlling the
VF.

The VFIO load model is explicitly destructive. We replace the current
VF with the loading VF. Both the VFIO variant driver and the VFIO
userspace issuing the load have to be aware of this and understand
that the whole device will change.

From an implementation perspective, I would expect the nvme varient
driver to either place the nvme device in the correct state during
load, or refuse to execute load if it is in the wrong state.

To be compatible with what qemu is doing the "right state" should be
entered by completing function level reset of the VF.

The Linux/qemu parts are still being finalized, so if you see
something that could be changed to better match nvme it would be a
great time to understand that.

Jason
