Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB197A5072
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjIRRFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjIRRFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:05:48 -0400
Received: from out-220.mta0.migadu.com (out-220.mta0.migadu.com [IPv6:2001:41d0:1004:224b::dc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCDA83
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:05:42 -0700 (PDT)
Date:   Mon, 18 Sep 2023 10:05:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695056741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nMBiS+IljrgodrWqzoZsrI2LeVIaCTpc0c/ZVYKUDNI=;
        b=D/h15oDlDr8UNc8syeBgN37f5knUwkL3Zs63EZ6PYuv8B9K5j5HVGmn4AjwuUMFowYY/c6
        GPorLqgvfbmYjIZckkuTFXD4Ilh3CPoVbYtbcB+42CHRMRxwwFHxKGssSPY1eickirGu+f
        WwSq+5VzX6jfuz+1Vsn7936hhAyhebU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool v3 08/17] Add helpers to pause the VM from vCPU
 thread
Message-ID: <ZQiDYLgicCnXA5a0@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
 <20230802234255.466782-9-oliver.upton@linux.dev>
 <20230918104028.GA17744@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918104028.GA17744@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Will,

On Mon, Sep 18, 2023 at 11:40:28AM +0100, Will Deacon wrote:
> On Wed, Aug 02, 2023 at 11:42:46PM +0000, Oliver Upton wrote:
> > +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> > +{
> > +	/*
> > +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> > +	 * signal exit.
> > +	 */
> > +	vcpu->paused = true;
> > +	kvm__pause(vcpu->kvm);
> > +}
> > +
> > +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> > +{
> > +	vcpu->paused = false;
> > +	kvm__continue(vcpu->kvm);
> > +}
> 
> Why is it safe to manipulate 'vcpu->paused' here without the pause_lock
> held?

Heh, I hacked this up to get _something_ working and never re-evaluated
the locking that I completely sidestepped.

> Relatedly, how does this interact with the 'pause' and 'resume'
> lkvm commands?

Poorly, if I had to guess. I hadn't actually tested with them. I'll take
another crack at this to safely quiesce when handling calls.

Thanks for having a look.

-- 
Best,
Oliver
