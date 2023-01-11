Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212E9666298
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbjAKSOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjAKSOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:14:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889B6FCC;
        Wed, 11 Jan 2023 10:14:46 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673460884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZYuW/cbFP1npKoEuiZS220jTN+uu0yF86SLxB0rDLw=;
        b=n2adJGAWgm3oaXK8gv1F+D9qxvKrLD4Ca14k99SFx9vASL2BHee2wrua46zwXKETDr7NY1
        CihQXUsAliDiTmuIS4LC9HP5NJXixU2O6ESxByMfRStuY8KoIg+XSxVffYOVysRDMk61Ux
        vCPOYSK5O+eLozOk77UiqL2EbyFEELkUyv2EFAil9baOlJ4isy8h37jJ2X4rYxLNminLAL
        X+glBz8TS4JmYzze0yvyeylTQFDYsyHZGmbV48mQSUbBYgA+gCwbcS/BKbDLRuxonmVOuJ
        tSTzCZ/cB7Uw+MWWYtKZf3dJIWfN0aYlo0Tin6Rw9E1KHRvMaxWZTA7E+k3xIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673460884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZYuW/cbFP1npKoEuiZS220jTN+uu0yF86SLxB0rDLw=;
        b=wvHogutoxNI5fWcTtr0163kh24SEW5rPzVUVvUTShaM5FgXjE2tJHvhgxvlrQUBOhdLlku
        MiqiniY06TRlnYBQ==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v3 1/9] irq: Add msi_device_has_isolated_msi()
In-Reply-To: <1-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: <1-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Date:   Wed, 11 Jan 2023 19:14:44 +0100
Message-ID: <87h6wxhraj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason!

On Thu, Jan 05 2023 at 15:33, Jason Gunthorpe wrote:

> Subject: Re: [PATCH iommufd v3 1/9] irq: Add msi_device_has_isolated_msi()

Nit: The correct prefix for this is 'genirq/msi:' 

Other than that:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
