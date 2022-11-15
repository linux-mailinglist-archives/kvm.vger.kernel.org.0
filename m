Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903A562A33A
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 21:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiKOUoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 15:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiKOUoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 15:44:08 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D122716B
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:44:07 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id c15so9513502qtw.8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 12:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ECoiQphPx/OtplfgR59pYK5naHquqFUNWyJla1khSUQ=;
        b=Pa0J8kPRbHJNfUmq3wuVFdt9Zy47+elTBM8U1hacGVidQYxMybV5vRaek8qthlzMP4
         8wOmQEkU3j+ug5AdIDcOCfM+JT+mH7FyaoylD16X1JAOCkgJDDv548vrMNHi9i9b35Jv
         R8+O3pmIxs6Cqg4/SmxuKAyYPQFUw+XLDoouz+p0MAMcczgu+97++Uh7dCugxvqqVjb9
         tKrp6GSnR8OM30qC4JTzW9z1Egt/WjgNnL3sjMD/tOyTNaCy+wB1B4IaPuYNjl9TtvZl
         IRllDGvuAxKTydlJw0YsnybWkkQazOtzoHfGLJmPbFE0gK4nhFxzgErpSgfzJ9JoGpX8
         xpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECoiQphPx/OtplfgR59pYK5naHquqFUNWyJla1khSUQ=;
        b=o4mygISDtdts9C6W8LO+No5l3xLEyruQPOKaYzpHWVk8f4EwT5/1+mFosAhGT7vWjz
         IQq70D4TN3ZxIjgZ3kEaR3fH27qSNUMmL+Xd8MlwaF2OjJyFCqNOt3dTxXxeYZe5OGVZ
         VGIH0jxBkFVmwxU+89m3i8enDhJMz5+milfZHB3Ay/rwSK9I4vL0glMkgB7+jUsL1toD
         U+F3pXcgWBweA1ePbCZdp0YOYMatz+54+z0mjo86pD+/6P8nRMDayK9XTlHXRMYsgUlU
         MOPXJM0jGnupjYWTu9r33b46K/Mk+q9roHQVIosdFQ/1wZmR+ImsQF3VcPpS91bhWHQi
         jzQg==
X-Gm-Message-State: ANoB5pkj6DJr4JwhCuB2ykijRvazbpFbiejZfWFRE3PbC4dAuuMQEhrd
        jBZIkftUbvtRPInmlQWCmpLfZoNlPni5Sg==
X-Google-Smtp-Source: AA0mqf4FYNUb+jrIXphPf1/+Ab8E0qucddXaPi6rz80gzr1477j4pVNHM4uRIRY2E74LViIJEC6jAg==
X-Received: by 2002:a05:622a:59ca:b0:39e:ebb2:c15e with SMTP id gc10-20020a05622a59ca00b0039eebb2c15emr18206322qtb.22.1668545046592;
        Tue, 15 Nov 2022 12:44:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id y11-20020ac87c8b000000b0039d085a2571sm7667183qtv.55.2022.11.15.12.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:44:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ov2mr-004s6r-IW;
        Tue, 15 Nov 2022 16:44:05 -0400
Date:   Tue, 15 Nov 2022 16:44:05 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch 09/10] vfio/fsl-mc: Remove linux/msi.h include
Message-ID: <Y3P6FU1e3qFC4m/U@ziepe.ca>
References: <20221113201935.776707081@linutronix.de>
 <20221113202428.826924043@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113202428.826924043@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 09:34:08PM +0100, Thomas Gleixner wrote:
> Nothing in this file needs anything from linux/msi.h
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Diana Craciun <diana.craciun@oss.nxp.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c |    1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
