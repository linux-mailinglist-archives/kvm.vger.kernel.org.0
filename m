Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A17E181C7A
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgCKPi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 11:38:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729473AbgCKPi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 11:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583941136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W5t/PCQFrEfrTtXP6H3fAc6etVr5BGU7Jh+WijcxdM8=;
        b=R/kMVGAgED5gqcCRr0PNzD+DSUmTVEFvm6wg0l638hwVEl0x0RP+TF53IDBTMNAPCDJP2H
        TONHmzaXNDUzCl1JfLbMMbGCd+zWbryFNaJ3Px47oY12HdbkBY0yr+IOYYZoq6wfuJdy/b
        iNMjLF5JlGp8QnVm0vBgoE+Sbp235wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-ukR6C7iqPe-lkwOjA2QKpw-1; Wed, 11 Mar 2020 11:38:54 -0400
X-MC-Unique: ukR6C7iqPe-lkwOjA2QKpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A8A189F764;
        Wed, 11 Mar 2020 15:38:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-206-80.brq.redhat.com [10.40.206.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF0F5C13D;
        Wed, 11 Mar 2020 15:38:45 +0000 (UTC)
Date:   Wed, 11 Mar 2020 16:38:42 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v6 07/13] arm/arm64: ITS:
 its_enable_defaults
Message-ID: <20200311153842.knuyqfnzqopb35gj@kamzik.brq.redhat.com>
References: <20200311135117.9366-1-eric.auger@redhat.com>
 <20200311135117.9366-8-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311135117.9366-8-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 02:51:11PM +0100, Eric Auger wrote:
> +/* must be called after gicv3_enable_defaults */
> +void its_enable_defaults(void)
> +{
> +	int i;
> +
> +	/* Allocate LPI config and pending tables */
> +	gicv3_lpi_alloc_tables();
> +
> +	for (i = 0; i < nr_cpus; i++)
> +		gicv3_lpi_rdist_enable(i);

You still haven't explained what's wrong with for_each_present_cpu. Also,
I see you've added 'i < nr_cpus' loops in arm/gic.c too. I'd prefer we not
assume that all cpu's are present (even though, currently, they must be),
because we may want to integrate cpu hotplug tests with these tests at
some point.

> +
> +	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
> +}
> -- 
> 2.20.1
> 
> 

