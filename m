Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2160463B
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiJSNDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiJSNCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 09:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6471C97F0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 601D5B823B5
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3115AC433C1;
        Wed, 19 Oct 2022 12:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666183557;
        bh=Obz1Eb/Z1rSTVB9Z76pArj6atKQy6kIjY4hqiJTSRN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RkiBykevhVkmTsqyfTzSmxmpZk5zDiQoxov0nhLJFVZ3c+l+SFBpCnk6nAGBoAZ+r
         b0XAJgDCjOw63BLWbG9NOiy01bZeMHUX7Xo0rxHT9p7mswzqAfSfOUuzgFqRiS5s8A
         QU1yrVdLg5fz6GQK5ABx4nduS5pX1OyjUSMzWFL+CxoibJ0euIbcoDKRYtyeTJJtrS
         z9NPxJZCmcQsmyAkK9AcT61Mr13cchMvt4LruB7efjoZf8NrFuFKuweD7H3miMBY9K
         ex8zHjquIYRq8PioeqP5UYjAlQVY7RVLkieDnJS12PuNRgxmwmDKTeimyWcuvhCXzW
         94+yYKa3d5UgQ==
Date:   Wed, 19 Oct 2022 13:45:50 +0100
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
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019124549.GC4220@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07Sd6lVfD4IUywQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07Sd6lVfD4IUywQ@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 04:21:11PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +struct pkvm_hyp_vm {
> > +	struct kvm kvm;
> > +
> > +	/* Backpointer to the host's (untrusted) KVM instance. */
> > +	struct kvm *host_kvm;
> > +
> > +	/*
> > +	 * Total amount of memory donated by the host for maintaining
> > +	 * this 'struct pkvm_hyp_vm' in the hypervisor.
> > +	 */
> > +	size_t donated_memory_size;
> 
> I think you could get rid of that member. IIUC, all you need to
> re-compute it in the teardown path is the number of created vCPUs on
> the host, which we should have safely stored in
> pkvm_hyp_vm::kvm::created_vcpus.

Oh, well spotted! I've dropped this as you have suggested.

Will
