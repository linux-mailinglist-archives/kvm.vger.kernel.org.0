Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933F239EE93
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 08:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhFHGQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 02:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHGQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 02:16:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E5DC061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 23:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hXq7wPtX7kYKWnoWTfwLaJx1EkOjDIFZWfU3EbEuOxo=; b=OJLVNM5KE0EOCqh+uGMIsYQmKu
        jIxpWg38kVx5HXClX/JcfiRDYd4n8a/lKtZcChtmimmUzzxlyYG8ig5Rl/jgEfEwwomyCRQaUmeVZ
        PMyd65ltzlmEyDHkzw5SY4R3c61eGy+O8tl1PX17tFmcr2l3enKVkopqJjim5gH3IlA/EWDRCPr68
        V0sV75anyTmHO4/MmMeITY8Jxnm4qaqDvkyOdCAqpMyEfxo9HXI7PASQH7+PZH7Ccxume5sMxw8Qe
        s9Hz6h+wJmQH5jeyZjDupE7FoUP2pjnqMIaS5IVqaWWtvleso4j9flSEdWbOr7XsMaKaMg3+QqT8H
        t/NaR/VA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqV0c-00Gchf-9Z; Tue, 08 Jun 2021 06:14:48 +0000
Date:   Tue, 8 Jun 2021 07:14:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 04/10] driver core: Don't return EPROBE_DEFER to
 userspace during sysfs bind
Message-ID: <YL8K0rWmLjDt5/Dn@infradead.org>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <4-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 09:55:46PM -0300, Jason Gunthorpe wrote:
>  int device_driver_attach(struct device_driver *drv, struct device *dev)
>  {
> @@ -1061,6 +1073,8 @@ int device_driver_attach(struct device_driver *drv, struct device *dev)
>  
>  	__device_driver_unlock(dev, dev->parent);
>  
> +	if (ret == -EPROBE_DEFER)
> +		return -EAGAIN;
>  	return ret;

I'd move this check into bind_store() instead.  That would also play
well with my earlier suggestion for a simple locking wrapper around
driver_probe_device which would get passed the flags argument as well.
