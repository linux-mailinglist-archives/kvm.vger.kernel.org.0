Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC52E67D619
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 21:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjAZUVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 15:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAZUVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 15:21:07 -0500
Received: from out-151.mta0.migadu.com (out-151.mta0.migadu.com [IPv6:2001:41d0:1004:224b::97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477543A840
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 12:21:02 -0800 (PST)
Date:   Thu, 26 Jan 2023 20:20:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674764460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8JRB0ZTuKzOcaN6t/zgZzy2q4XicQ9675yPHBbKAJE=;
        b=SEN0QyX13UyBorIsbpCTmG6er5954SCoAlZj9H4TrOI9Nkx8Rb4eX1Yk3Wop+Juk4BdXCI
        KZSOnhA+XQMdFLD6T42NDwp1hJPi4m9ftdbLg58+OLgaMIyzGLKRAnggcD29NcTStHoyGv
        KCtNbNIQ8a2NffR4AX4B8uTKrsedhgQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        maz@kernel.org, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        reijiw@google.com, ardb@kernel.org, Julia.Lawall@inria.fr,
        yuzenghui@huawei.com, seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v2 1/3] KVM: arm64: Add helper vgic_write_guest_lock()
Message-ID: <Y9LgplvWZtdjXCEE@google.com>
References: <20230119234405.349644-1-gshan@redhat.com>
 <20230119234405.349644-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119234405.349644-2-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On Fri, Jan 20, 2023 at 07:44:03AM +0800, Gavin Shan wrote:
> Currently, the unknown no-running-vcpu sites are reported when a
> dirty page is tracked by mark_page_dirty_in_slot(). Until now, the
> only known no-running-vcpu site is saving vgic/its tables through
> KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on KVM device
> "kvm-arm-vgic-its". Unfortunately, there are more unknown sites to
> be handled and no-running-vcpu context will be allowed in these
> sites: (1) KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} command
> on KVM device "kvm-arm-vgic-its" to restore vgic/its tables. The
> vgic3 LPI pending status could be restored. (2) Save vgic3 pending
> table through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES}
> command on KVM device "kvm-arm-vgic-v3".
> 
> In order to handle those unknown cases, we need a unified helper
> vgic_write_guest_lock(). struct vgic_dist::save_its_tables_in_progress
> is also renamed to struct vgic_dist::save_tables_in_progress. Besides,
> "asm/kvm_mmu.h" needs to be included for "vgic.h" for the definition
> of kvm_write_guest_lock().
> 
> No functional change intended.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c   |  1 +
>  arch/arm64/kvm/vgic/vgic-irqfd.c   |  1 +
>  arch/arm64/kvm/vgic/vgic-its.c     | 13 +++++--------
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c |  1 +
>  arch/arm64/kvm/vgic/vgic-mmio.c    |  1 +
>  arch/arm64/kvm/vgic/vgic-v4.c      |  1 +
>  arch/arm64/kvm/vgic/vgic.c         |  1 +
>  arch/arm64/kvm/vgic/vgic.h         | 13 +++++++++++++
>  include/kvm/arm_vgic.h             |  2 +-
>  9 files changed, 25 insertions(+), 9 deletions(-)

You wouldn't have to add the include all around the shop if you instead
just stuck it in vgic.h...

Having said that, we really ought to get a fix in for this sooner rather
than later. I just hit it myself testing kvmarm/next.

Marc, could you take care of the include fix when applying?

-- 
Thanks,
Oliver
