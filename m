Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2ED5EB16A
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIZTie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 15:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIZTic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 15:38:32 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9FE6CF64;
        Mon, 26 Sep 2022 12:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=y/fhhdO+hP5SZGRczsI4VmDv/zHyzfyxBK/7E32g0Fc=; b=Jja4SiCUJTT/PeyL/ZQOcHGXdn
        lMtW7G6herngtQ8QyA/+X7G8sY1RETTMsuYQQmaMTDI/RcCe7jqrmwsqo9bBE6j1P5R42hFnQBpOG
        rkX8lBmAHsWLbxvFtjA8S0nbrPv+w6Kg2Jt51U0IzmPPxrAObcLsC/eeE4I+NJT9w/3uWqjuvieRP
        ygFIT4H5bkpWj0lmabIbKh6uty0Irgmr0hxyuZNPTONxORKvdJMzMo+2CzvLOrWz52JzA9IccUht0
        qhx2y/FkRkTAwAtKV9qt25O29JjSRo2bquTCp8xVizyy2FX5ybSF6gFtbjeWH7sNdBBpCbCEvVaIc
        gn1jeUhA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1octvm-0048Eh-01;
        Mon, 26 Sep 2022 19:38:18 +0000
Date:   Mon, 26 Sep 2022 20:38:17 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Deming Wang <wangdeming@inspur.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Use filp instead of fd
Message-ID: <YzH/qXr6bZaTY+EV@ZenIV>
References: <20220926065407.2389-1-wangdeming@inspur.com>
 <YzHcX2VLh+0n2mAP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzHcX2VLh+0n2mAP@nvidia.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 02:07:43PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 26, 2022 at 02:54:07AM -0400, Deming Wang wrote:
> > The function of kvm_vfio_group_set_spapr_tce and kvm_vfio_group_del
> > use fd indirectly.But,it only be used for fd.file. So,we can directly
> > use the struct of file instead.
> > 
> > Signed-off-by: Deming Wang <wangdeming@inspur.com>
> > ---
> >  virt/kvm/vfio.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> I thought about changing this too when I was looking at
> this. fdget/fdput includes a tiny micro-optimization that is legal
> here, however I doubt anyone cares about performance on this path.

Microoptimization or not, I'd rather keep fget() limited to cases where
we really need it.  There are non-trivial cases and having them easy
to find is a good thing.

Again, the preferred way to do descriptor lookups is fdget() family,
not fget() one.
