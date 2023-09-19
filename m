Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E404C7A56C0
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 02:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjISA5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 20:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISA5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 20:57:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226DE10B;
        Mon, 18 Sep 2023 17:57:38 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695085056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mGW7UJ921F2lqbPln9a/p0i49suUeiMYTKN+LrbaPgc=;
        b=F3+iWSX4NecHuDd+ipCo5K5BTOlsMrcCBcUjVCoWE7oxh6EbOgvfDwa1PXdNWsF6XHySRZ
        HZv41f7UUJRBPa7vkJKaPoyLj0uHf1YrVNjT65X+TRPaTpzlu8XMnZH7Er2WTxYKDkzCYx
        8Q3V8Ff7RcvcqXKId5jwmRDB5tiq3dNt0sBd67hSyv+iMkL15SvENZKZeD+cuAgqfjY4fR
        35l0uWmYUwdAS2SH0kevX125d4sFzeLM8+EuOBiwoNfAlB4dmHeX3qrJwY8v9HMQBZUVSS
        D7DOOY0rYfWmDEVwKodYi+MjTUJKhhjAdhbxMJ/c+MgyTE7Wjs4C2xBu6F2NpA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695085056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mGW7UJ921F2lqbPln9a/p0i49suUeiMYTKN+LrbaPgc=;
        b=n3qcZ3nfCekra8vxrSWyDkxn9OH0z6qYLOkrAUkCsBLF77P9aWc9dVOiiVFTsLL+4csvGI
        /I+w7A1sVZyP+cAA==
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        alex.williamson@redhat.com, kevin.tian@intel.com,
        reinette.chatre@intel.com, kvm@vger.kernel.org,
        brett.creeley@amd.com, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio] vfio/pci: remove msi domain on msi disable
In-Reply-To: <20230919003251.GR13795@ziepe.ca>
References: <20230914191406.54656-1-shannon.nelson@amd.com>
 <20230918141705.GE13795@ziepe.ca> <87led3xqye.ffs@tglx>
 <20230918233735.GP13795@ziepe.ca> <87a5tjxcva.ffs@tglx>
 <20230919000215.GQ13795@ziepe.ca> <874jjrxb43.ffs@tglx>
 <20230919003251.GR13795@ziepe.ca>
Date:   Tue, 19 Sep 2023 02:57:35 +0200
Message-ID: <871qevx9mo.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18 2023 at 21:32, Jason Gunthorpe wrote:
> On Tue, Sep 19, 2023 at 02:25:32AM +0200, Thomas Gleixner wrote:
>
>> > I don't think we need to try and fix that..
>> 
>> We might want to detect it and yell about it, right?
>
> It strikes me as a good idea, yes. If it doesn't cost anything.

It should not be expensive in the interrupt allocation/deallocation
path, where hardware needs to be accessed anyway. So one extra read is
not the end of the world.

Thanks,

        tglx
