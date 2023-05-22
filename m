Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C9270C541
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 20:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjEVSen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 14:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjEVSel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 14:34:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9969D
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 11:34:40 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae7eea1d5dso21412635ad.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 11:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684780480; x=1687372480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncyyvzCwaBiOGfdAK57eDSyGsVrCv17gynkqmLbIh7Q=;
        b=cGPQFY6F+JsGLicyWmQ7+nx3BT8FDTky0Wpm3XMm47C67teffHRLLERrhhaXB78/CL
         ntljpUrXT68Ppi5/Br2bFbLfK6HZXVLGLYn6zwBMkZqCqOHJE8c6nTf4PHZT3kOdALRD
         WYT++yPJw8eQcaZW/JCptRL2KmXZBG59VSW+dbF+1yGNjbzEvGw3WCB6+aR/o2UoFfMD
         3Q48kdKs3/9fpMluVeCEMRk7evs7OTjc7hyrDlbNEi7WL2d2onFS7my6C8fDbmseK36M
         m4pArVT+6V0srD5bk1rZT2WYLS9kqpm+kH9gzo69MoI63Q2Bq2DN4xM3T0ZgHxCuj8pL
         CMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684780480; x=1687372480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncyyvzCwaBiOGfdAK57eDSyGsVrCv17gynkqmLbIh7Q=;
        b=dLBkPZtB3hSMuj9uPE6+vF9wmqqp2ok+zb/POwULoP5jhSq2v2opf6b4chxRUhezEZ
         vph/wE92q42lnkkk5eZrKWS81+rtZWROEnfZBjrgZwg5B94GWFB1DjGdP7gOD3FQuwFR
         3PWqGGXFJ7EjshCnxoquKe/gyInOVT3pRTho/E/FJ6oVdeBh5IezIK3cAtLkOo/7CUeL
         SZ+umJpZQMpeExgIqXcOofMd6mWuw3HmJbzXLkbaXxv6zoamnT4j2ANQJyYp7DY4z/LY
         4ALh473Awg0Wr3rL4XLqkmdqoyWlFWA6nM+XsvkxzEwfgEcTEWKUh9NVehGPn/asmL3u
         KQ7A==
X-Gm-Message-State: AC+VfDyHxzT5WqW0ks68kpp3ToqkeRwaJvSEV09ok4KIBqG8/ZFf3kF2
        Onz3x4UHaJVLKr6GCbWjBPkGLVBYSPo=
X-Google-Smtp-Source: ACHHUZ4vYpOScPsGTy+iBltm4E7gLuJQusAKoigKV11l60H7+6wz2QnxSdUf70tvT+CQhoqlL+09UUYI3KI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cad2:b0:1ad:ec0b:42f9 with SMTP id
 y18-20020a170902cad200b001adec0b42f9mr2629780pld.6.1684780479772; Mon, 22 May
 2023 11:34:39 -0700 (PDT)
Date:   Mon, 22 May 2023 11:34:38 -0700
In-Reply-To: <20230522063725.284686-1-apopple@nvidia.com>
Mime-Version: 1.0
References: <20230522063725.284686-1-apopple@nvidia.com>
Message-ID: <ZGu1vsbscdO48V6h@google.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
From:   Sean Christopherson <seanjc@google.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Alistair Popple wrote:
> Some architectures, specifically ARM and perhaps Sparc and IA64,
> require TLB invalidates when upgrading pte permission from read-only
> to read-write.
> 
> The current mmu_notifier implementation assumes that upgrades do not
> need notifications. Typically though mmu_notifiers are used to
> implement TLB invalidations for secondary MMUs that comply with the
> main CPU architecture.
> 
> Therefore if the main CPU architecture requires an invalidation for
> permission upgrade the secondary MMU will as well and an mmu_notifier
> should be sent for the upgrade.
> 
> Currently CPU invalidations for permission upgrade occur in
> ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
> directly from this architecture specific code as the notifier
> callbacks can sleep, and ptep_set_access_flags() is usually called
> whilst holding the PTL spinlock. Therefore add the notifier calls
> after the PTL is dropped and only if the PTE actually changed. This
> will allow secondary MMUs to obtain an updated PTE with appropriate
> permissions.
> 
> This problem was discovered during testing of an ARM SMMU
> implementation that does not support broadcast TLB maintenance
> (BTM). In this case the SMMU driver uses notifiers to issue TLB
> invalidates. For read-only to read-write pte upgrades the SMMU
> continually returned a read-only PTE to the device, even though the
> CPU had a read-write PTE installed.
> 
> Sending a mmu notifier event to the SMMU driver fixes the problem by
> flushing secondary TLB entries. A new notifier event type is added so
> drivers may filter out these invalidations if not required. Note a
> driver should never upgrade or install a PTE in response to this mmu
> notifier event as it is not synchronised against other PTE operations.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/mmu_notifier.h |  6 +++++
>  mm/hugetlb.c                 | 24 ++++++++++++++++++-
>  mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d6c06e140277..f14d68f119d8 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -31,6 +31,11 @@ struct mmu_interval_notifier;
>   * pages in the range so to mirror those changes the user must inspect the CPU
>   * page table (from the end callback).
>   *
> + * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
> + * read-write for pages in the range. This must not be used to upgrade
> + * permissions on secondary PTEs, rather it should only be used to invalidate
> + * caches such as secondary TLBs that may cache old read-only entries.

This is a poor fit for invalidate_range_{start,end}().  All other uses bookend
the primary MMU update, i.e. call start() _before_ changing PTEs.  The comments
are somewhat stale as they talk only about "unmapped", but the contract between
the primary MMU and the secondary MMU is otherwise quite clear on when the primary
MMU will invoke start() and end().

	 * invalidate_range_start() is called when all pages in the
	 * range are still mapped and have at least a refcount of one.
	 *
	 * invalidate_range_end() is called when all pages in the
	 * range have been unmapped and the pages have been freed by
	 * the VM.

I'm also confused as to how this actually fixes ARM's SMMU.  Unless I'm looking
at the wrong SMMU implementation, the SMMU implemenents only invalidate_range(),
not the start()/end() variants.

	static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
		.invalidate_range	= arm_smmu_mm_invalidate_range,
		.release		= arm_smmu_mm_release,
		.free_notifier		= arm_smmu_mmu_notifier_free,
	};

Again from include/linux/mmu_notifier.h, not implementing the start()/end() hooks
is perfectly valid.  And AFAICT, the existing invalidate_range() hook is pretty
much a perfect fit for what you want to achieve.

	 * If invalidate_range() is used to manage a non-CPU TLB with
	 * shared page-tables, it not necessary to implement the
	 * invalidate_range_start()/end() notifiers, as
	 * invalidate_range() already catches the points in time when an
	 * external TLB range needs to be flushed. For more in depth
	 * discussion on this see Documentation/mm/mmu_notifier.rst

Even worse, this change may silently regress performance for secondary MMUs that
haven't yet taken advantage of the event type, e.g. KVM will zap all of KVM's PTEs
in response to the upgrade, instead of waiting until the guest actually tries to
utilize the new protections.
