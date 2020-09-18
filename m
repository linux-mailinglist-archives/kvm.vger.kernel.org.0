Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7397D26F791
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 10:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRIBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 04:01:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726040AbgIRIBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 04:01:21 -0400
X-Greylist: delayed 88276 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 04:01:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600416080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GVFinjKpebbOcYbTtDAH+8ZTpHrKqsTQijsV2GuanqY=;
        b=J2teavoTBulbAztF9GxJsHujHLP+VX5x76yNX8FAKqJQl1yk2Lw0tMxZVXWvvx9sxhjUmC
        t/PwD+tlcpXmH0Gkk6EhGtfUU5ibcHqzgtXDRvPJK/pudU9nL4kXnBYYsTV7A7Pwesi9Vi
        2SrBSVGu+QaDwIgAgUxbJAibQ6f28i0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-3QxO-G4LMpK-m_HA6ew9Aw-1; Fri, 18 Sep 2020 04:01:18 -0400
X-MC-Unique: 3QxO-G4LMpK-m_HA6ew9Aw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2B6A6408F;
        Fri, 18 Sep 2020 08:01:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CC237881C;
        Fri, 18 Sep 2020 08:01:08 +0000 (UTC)
Date:   Fri, 18 Sep 2020 10:01:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        will@kernel.org, zhang.zhanghailiang@huawei.com,
        xiexiangyou@huawei.com
Subject: Re: [RFC v2 0/7] kvm: arm64: emulate ID registers
Message-ID: <20200918080106.5c6jqarj3mhwi3mv@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-1-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 08:00:54PM +0800, Peng Liang wrote:
> In AArch64, guest will read the same values of the ID regsiters with
> host.  Both of them read the values from arm64_ftr_regs.  This patch
> series add support to emulate and configure ID registers so that we can
> control the value of ID registers that guest read.
> 
> v1 -> v2:
>  - save the ID registers in sysreg file instead of a new struct
>  - apply a checker before setting the value to the register
>  - add doc for new KVM_CAP_ARM_CPU_FEATURE
> 
> Peng Liang (7):
>   arm64: add a helper function to traverse arm64_ftr_regs
>   arm64: introduce check_features
>   kvm: arm64: save ID registers to sys_regs file
>   kvm: arm64: introduce check_user
>   kvm: arm64: implement check_user for ID registers
>   kvm: arm64: make ID registers configurable
>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
> 
>  Documentation/virt/kvm/api.rst      |   8 +
>  arch/arm64/include/asm/cpufeature.h |   4 +
>  arch/arm64/include/asm/kvm_coproc.h |   2 +
>  arch/arm64/include/asm/kvm_host.h   |   3 +
>  arch/arm64/kernel/cpufeature.c      |  36 +++
>  arch/arm64/kvm/arm.c                |   3 +
>  arch/arm64/kvm/sys_regs.c           | 481 +++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.h           |   6 +
>  include/uapi/linux/kvm.h            |   1 +
>  9 files changed, 532 insertions(+), 12 deletions(-)
> 
> -- 
> 2.26.2
>

Hi Peng,

I'd much rather see a series of patches where each patch converts a single
ID register from using ID_SANITISED() to having its own table entry, where
its own set_user() and reset() functions take into account its features
using high level arm64_ftr* functions. Any ID registers that can still
share code can certainly do so with some post-conversion refactoring.

Thanks,
drew

