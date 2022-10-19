Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDBF604D4A
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJSQY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiJSQYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5613643F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6262AB824F4
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DE5C433D6;
        Wed, 19 Oct 2022 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666196689;
        bh=OHysm+Nli+SvZ2iZyvMMu+hT8N70B5GzA8H3xvijOIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mmBCAu2s20SRms0d0qpPEyfmbMP22GEwn7GJqchil/K4jKT/eg79qP6t3UdH+gKqA
         qy6D5k/EmnXhpbZuK9ndMi6+30cTfhZ0SnNsFeO4XqB2qCeFfB+RlxGu1uJHFLVVnK
         OfLJC3tKLLuxsNLUNTydXbfiXW1sBzs2dYQmAOmoYyZ92u2oxsnRRMXf4PoZgPCNBB
         YJ/565mNPuxMCngPdPdR+OJrMn79Ugx49NyonCf0nWLLRH35CUevvl7oE1NOJ1PC/N
         xiqpa8S1mnGdiPJOKlvm36bvxH/8sJDCVxGvDKPVJw7aXatrpnyYh5ZJnHSuxhoEDy
         ui6zQQcolBpoA==
Date:   Wed, 19 Oct 2022 17:24:42 +0100
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
Subject: Re: [PATCH v4 20/25] KVM: arm64: Return guest memory from EL2 via
 dedicated teardown memcache
Message-ID: <20221019162441.GA4499@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-21-will@kernel.org>
 <Y1AdKgqANCzlv/7Q@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1AdKgqANCzlv/7Q@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 03:52:10PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:52:04 (+0100), Will Deacon wrote:
> >  struct kvm_protected_vm {
> >  	pkvm_handle_t handle;
> >  	struct mutex vm_lock;
> > -
> > -	struct {
> > -		void *pgd;
> > -		void *vm;
> > -		void *vcpus[KVM_MAX_VCPUS];
> > -	} hyp_donations;
> > +	struct kvm_hyp_memcache teardown_mc;
> >  };
> 
> Argh, I guess that somewhat invalidates my previous comment. Oh well :-)

Yup! There's a slight chicken-and-egg problem here, so we introduce
explicit tracking of the donations in the host to start with, but then
once we have the teardown memcache we can stop tracking things explicitly
and remove the temporary pointers.

Will
