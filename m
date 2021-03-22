Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ADC343E7A
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhCVKyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:54:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCVKxy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 06:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616410433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SpoExD1anuwhKZKyJsCjy4Plv/KO1097hVfIRzphDu0=;
        b=bLoCetek9zcdD1PUlhfmTsmlFxdb9vV7n5CxrfW0ZOVo+YEnCjtxtvUnviOyQ0wDpJrRnz
        Gtj931uspTnZ9IZtjQ4rZgefMZ60FcTLw6ww27+H+sKPK9rmdTrylFB1WO8aYfU/aVstBg
        lTPpjcbs+adEDpFtTbScf4QzP4Ly8Bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-A9icRGCWOQ2mCRuStmhJtQ-1; Mon, 22 Mar 2021 06:53:51 -0400
X-MC-Unique: A9icRGCWOQ2mCRuStmhJtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5836B814337;
        Mon, 22 Mar 2021 10:53:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 720825F9C9;
        Mon, 22 Mar 2021 10:53:49 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:53:46 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling
 cpumask_test_cpu for CPUs above nr_cpu
Message-ID: <20210322105346.qyfhbyk5szvcc7z2@kamzik.brq.redhat.com>
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-2-nikos.nikoleris@arm.com>
 <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
 <df9a70d0-0129-d3a4-9530-77a7354b8e47@arm.com>
 <20210322101229.5f4epjxjzaq7i5ti@kamzik.brq.redhat.com>
 <d30766b7-97d2-cfd6-cf6a-3799bd9a6fd6@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30766b7-97d2-cfd6-cf6a-3799bd9a6fd6@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 10:40:26AM +0000, Nikos Nikoleris wrote:
> 
> Prior to this change, a call of cpumask_next(cpu, mask) where cpu=nr_cpu
> - 1 (assuming all cpus are enumerated in the range 0..nr_cpus - 1) would
> make an out-of-bounds access to the mask. In many cases, this is still a
> valid memory location due the implementation of cpumask_t, however, in
> certain configurations (for example, nr_cpus == sizeof(long)) this would
> cause an access outside the bounds of the mask too.
> 
> This patch changes the way we guard calls to cpumask_test_cpu() in
> cpumask_next() to avoid the above condition. A following change adds
> assertions to catch out-of-bounds accesses to cpumask_t.
> 

Thanks, I've added it. It looks like Alexandru would also like commit
message improvements. I can add those too.

Thanks,
drew

