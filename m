Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A6604D7E
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiJSQet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJSQer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:34:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8772C643A
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:34:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 456D2B824C7
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0615BC433D6;
        Wed, 19 Oct 2022 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666197282;
        bh=UnZHOknXQq3gyRrT0eS1FMSV2PFdrfEWHlCoNdtH08c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUn3DJhIx8Grd2+KiehhXTNOSLmbzU3usAC12ccg9EyrTetrOQPApFTfE1ICkaQ+E
         XwEEL0oi+8NLrkoJIaAEviqBr8jR65tNQzwfeleKSXYeOX3SN0nUrF1vori50xaSLo
         8J4l7on2A1g1HBzDOVzvaotMkBuQu6G7Y8pSu087QqRDp0tfYbYQyvkMY1J3rgrYzo
         3j3/V0zlEVsrM8l6518rimdToMECpFDCeafmy9nUgwek5Gxt3iY+mn0rP4Dr6QJIY3
         z5MBVUaPgHMErrAOokN/H5TtES6Gy9RKnAWhhezE2zelt/XPvurA8wriEEx1Khw5bc
         MLuQ18WXLBKgg==
Date:   Wed, 19 Oct 2022 17:34:35 +0100
From:   Will Deacon <will@kernel.org>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 13/25] KVM: arm64: Instantiate pKVM hypervisor VM and
 vCPU structures from EL1
Message-ID: <20221019163434.GB4499@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-14-will@kernel.org>
 <Y1AfBrXcYlWBxig8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1AfBrXcYlWBxig8@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 04:00:06PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:57 (+0100), Will Deacon wrote:
> > +struct kvm_protected_vm {
> > +	pkvm_handle_t handle;
> > +	struct mutex vm_lock;
> 
> Why is this lock needed btw? Isn't kvm->lock good enough?

Good question. I can't see why kvm->lock wouldn't work for this series,
so I'll drop this for now. I have vague recollections that we ran into
lock ordering issues in an early implementation wrt vcpu locking, but
for now let's drop it.

Cheers,

Will
