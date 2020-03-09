Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A848D17DF2C
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 12:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgCIL56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 07:57:58 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35409 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726215AbgCIL56 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583755077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JlRj9Vqw5kVHj8y9+BpywPdNrroWVPcoF5Lt1CkGwdM=;
        b=OP6qrEHfWwHt2W3TI9sOxohG2UqXGuN6kVYHZTJeQvDn33/8SwKVoCgxNF9nPGxbD9mcwU
        MhEW7CQcnU1kiHTQr9qP616fGCN9N4EpaI7tmFSwruQAnmXhFSThMKJ1EvHrYBS1LHo0fR
        zsikMwvK/IOdmYfsgvn13UWHKRzjeBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-Sr7-7OUHPOuxLwTebliNgQ-1; Mon, 09 Mar 2020 07:57:53 -0400
X-MC-Unique: Sr7-7OUHPOuxLwTebliNgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88C48010C7;
        Mon,  9 Mar 2020 11:57:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B26960C05;
        Mon,  9 Mar 2020 11:57:43 +0000 (UTC)
Date:   Mon, 9 Mar 2020 12:57:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add ITS tests
Message-ID: <20200309115741.6stx5tpkb6s6ejzh@kamzik.brq.redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 11:24:07AM +0100, Eric Auger wrote:
> This series is a revival of an RFC series sent in Dec 2016 [1].
> Given the amount of code and the lack of traction at that time,
> I haven't respinned until now. However a recent bug found related
> to the ITS migration convinced me that this work may deserve to be
> respinned and enhanced.
> 
> Tests exercise main ITS commands and also test migration.
> With the migration framework, we are able to trigger the
> migration from guest and that is very practical actually.
> 
> What is particular with the ITS programming is that most of
> the commands are passed through queues and there is real error
> handling. Invalid commands are just ignored and that is not
> really tester friendly.
> 
> The series can be fount at:
> https://github.com/eauger/kut/tree/its-v4
> 
> Best Regards
> 
> Eric
> 
> History:
> v3 -> v4:
> - addressed comments from Drew and Zenghui
> - added "page_alloc: Introduce get_order()"
> - removed "arm: gic: Provide per-IRQ helper functions"
> - ITS files moved to lib64
> - and many more, see individual logs
> 
> v2 -> v3:
> - fix 32b compilation
> - take into account Drew's comments (see individual diff logs)
> 
> v1 -> v2:
> - took into account Zenghui's comments
> - collect R-b's from Thomas
> 
> References:
> [1] [kvm-unit-tests RFC 00/15] arm/arm64: add ITS framework
>     https://lists.gnu.org/archive/html/qemu-devel/2016-12/msg00575.html
> 
> Execution:
> x For other ITS tests:
>   ./run_tests.sh -g its
> 
> x non migration tests can be launched invidually. For instance:
>   ./arm-run arm/gic.flat -smp 8 -append 'its-trigger'
> 
> Eric Auger (13):
>   libcflat: Add other size defines
>   page_alloc: Introduce get_order()
>   arm/arm64: gic: Introduce setup_irq() helper
>   arm/arm64: gicv3: Add some re-distributor defines
>   arm/arm64: gicv3: Set the LPI config and pending tables
>   arm/arm64: ITS: Introspection tests
>   arm/arm64: ITS: its_enable_defaults
>   arm/arm64: ITS: Device and collection Initialization
>   arm/arm64: ITS: Commands
>   arm/arm64: ITS: INT functional tests
>   arm/run: Allow Migration tests
>   arm/arm64: ITS: migration tests
>   arm/arm64: ITS: pending table migration test
> 
>  arm/Makefile.arm64         |   1 +
>  arm/Makefile.common        |   2 +-
>  arm/gic.c                  | 469 +++++++++++++++++++++++++++++++++++--
>  arm/run                    |   2 +-
>  arm/unittests.cfg          |  38 +++
>  lib/alloc_page.c           |   7 +-
>  lib/alloc_page.h           |   1 +
>  lib/arm/asm/gic-v3-its.h   |  39 +++
>  lib/arm/asm/gic-v3.h       |  32 +++
>  lib/arm/gic-v3.c           |  76 ++++++
>  lib/arm/gic.c              |  34 ++-
>  lib/arm/io.c               |  28 +++
>  lib/arm64/asm/gic-v3-its.h | 172 ++++++++++++++
>  lib/arm64/gic-v3-its-cmd.c | 463 ++++++++++++++++++++++++++++++++++++
>  lib/arm64/gic-v3-its.c     | 172 ++++++++++++++
>  lib/libcflat.h             |   3 +
>  16 files changed, 1510 insertions(+), 29 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/gic-v3-its-cmd.c
>  create mode 100644 lib/arm64/gic-v3-its.c
> 
> -- 
> 2.20.1
> 
>

This looks pretty good to me. It just needs some resquashing cleanups.
Does Andre plan to review? I've only been reviewing with respect to
the framework, not ITS. If no other reviews are expected, then I'll
queue the next version.

Thanks,
drew

