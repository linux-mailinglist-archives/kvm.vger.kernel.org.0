Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5D6CC61F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjC1PXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjC1PXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:23:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFBC1204D
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:21:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p12-20020a25420c000000b00b6eb3c67574so12301638yba.11
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680016856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5BDyXdwLNDkkL1EG1Vlg4E16wOafaNr02fD8vdba9Dk=;
        b=RbKYy2noIQch80Msv5bqAn0EyQhd27bVKyUSI0EMZX8IuPWMo+mLVJKHSwqUfD5zMt
         1S1fMEbHqh8a+fnJiferohyaGfiQ6WbTT2eMABg4attHMptZRuReJHL4lQdFgejv4vtM
         s16zpjwXOQRsJ+YLsCocF7ZPAaq6tfdZ0Utq8NEh0JSnAfU1lch1kOy6Gb+T4vZK8OrP
         j9izUYQxl9+jkwjEN+kCtsyZG+WnWn3bD5Uij8BqKyGQzOX6LsAfBmQUtIuzDz5IKQ4N
         mj4ac674SwliP4++uxcrQMgQoUpTHfFDNqsYBozygFtoY0n9v2QBxuKjBdL7arM545og
         Uw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5BDyXdwLNDkkL1EG1Vlg4E16wOafaNr02fD8vdba9Dk=;
        b=QGC//q6ohK7czY9rEy8ZkmSeOuaHw7uiceZR3ZClP1SOKcogxPstVf93716ZsOQ4TE
         eC4+HQTN7kdFm4Sq2JHzxUbG634pxBbtI7yeleMeUcyppolQkdVQKrHuzLsrYEq7/I4b
         Tq8+ASEr8mcvsfwPBk95ZqL7e4E8X9vybJrX+KCFD/3oF1VrSIFDAhEQ0niZ1unhNBoO
         +P1qCmqScsFoFRts7Sy960e/4fCQkub7ldyFiHI2+fm/WTit6nMXvj+FTJjhXalRcpxI
         oUbLxVT/GUqX5hCxH5SdKUUxl2og0+hZT9Q+i9WZF9OfXRMHlLOe69ROikfW9SOzSvlW
         Kp1g==
X-Gm-Message-State: AAQBX9fjYO0deJAE3Y4RW8J57eC8fr/gfZogRYlL11bOol2FBgy9+sPj
        G+1QDid9cDrg2aGEDuWppE9grFWQO/c=
X-Google-Smtp-Source: AKy350Y8HtUvudF/HEaI9/VQYB1jeEz2Bcg1zL2sdiujAx+T2SuW0eY/9HbiCKVqy3WNPHtE3AE9PjyBVew=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:b75:9519:dbcd with SMTP id
 w3-20020a05690210c300b00b759519dbcdmr10605629ybu.12.1680016855844; Tue, 28
 Mar 2023 08:20:55 -0700 (PDT)
Date:   Tue, 28 Mar 2023 08:20:49 -0700
In-Reply-To: <cde77b1f-e612-2a9e-e437-8892f7f1fde9@oracle.com>
Mime-Version: 1.0
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com> <ZBODjjANx6pkq5iq@google.com>
 <655ac0f7-223b-9440-1bcb-e93af8915bfa@oracle.com> <ZB20W14VzVZZz+nI@google.com>
 <cde77b1f-e612-2a9e-e437-8892f7f1fde9@oracle.com>
Message-ID: <ZCMF0ReWqG0Q7Zna@google.com>
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
From:   Sean Christopherson <seanjc@google.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023, Joao Martins wrote:
> [I was out sick, hence the delay]
> 
> On 24/03/2023 14:31, Sean Christopherson wrote:
> > On Thu, Mar 16, 2023, Joao Martins wrote:
> >> On 16/03/2023 21:01, Sean Christopherson wrote:
> >>> Is there any harm in giving deactivate the same treatement?  If the worst case
> >>> scenario is a few wasted cycles, having symmetric flows and eliminating benign
> >>> bugs seems like a worthwhile tradeoff (assuming this is indeed a relatively slow
> >>> path like I think it is).
> >>>
> >>
> >> I wanna say there's no harm, but initially I had such a patch, and on testing it
> >> broke the classic interrupt remapping case but I didn't investigate further --
> >> my suspicion is that the only case that should care is the updates (not the
> >> actual deactivation of guest-mode).
> > 
> > Ugh, I bet this is due to KVM invoking irq_set_vcpu_affinity() with garbage when
> > AVIC is enabled, but KVM can't use a posted interrupt due to the how the IRQ is
> > configured.  I vaguely recall a bug report about uninitialized data in "pi" being
> > consumed, but I can't find it at the moment.
> > 
> > 	if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
> > 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
> > 
> > 		...
> > 
> > 	} else {
> > 			/* Use legacy mode in IRTE */
> > 			struct amd_iommu_pi_data pi;
> > 
> > 			/**
> > 			 * Here, pi is used to:
> > 			 * - Tell IOMMU to use legacy mode for this interrupt.
> > 			 * - Retrieve ga_tag of prior interrupt remapping data.
> > 			 */
> > 			pi.prev_ga_tag = 0;
> > 			pi.is_guest_mode = false;
> > 			ret = irq_set_vcpu_affinity(host_irq, &pi);
> > 	}
> > 
> > 
> 
> I recall one instance of the 'garbage pi data' issue but this was due to
> prev_ga_tag not being initialized (see commit f6426ab9c957).

Yep, that's the one I was trying to recall.

> As far as I understand, AMD implementation on irq_vcpu_set_affinity will
> write back to caller the following fields of pi:
> 
> - prev_ga_tag
> - ir_data
> - guest_mode (sometimes when it is unsupported or disabled by the host via cmdline)
> 
> On legacy interrupt remap path (no iommu avic) the IRQ update just uses irq data
> mostly. It's the avic path that uses more things (vcpu_data, ga_tag, base,
> ga_root_ptr, ga_vector), but all of which are initialized by KVM properly already.

Ya, on my Nth read through, I don't see any issues with KVM's behavior.  I was
thinking that KVM's "pi" could bleed into amd_iommu_deactivate_guest_mode(), but
I had just gotten turned around by the many "data" variables.  Bummer.
