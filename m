Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD707312DF
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 11:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbjFOJAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 05:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241158AbjFOI7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 04:59:52 -0400
Received: from out-35.mta0.migadu.com (out-35.mta0.migadu.com [IPv6:2001:41d0:1004:224b::23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049671720
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 01:59:50 -0700 (PDT)
Date:   Thu, 15 Jun 2023 08:59:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686819589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7gLMuGKceimfr6zrz+UW6frOfSWL8pcQ8YFkxEcKcg=;
        b=WcLfv8fuISsDvB7xPmZgRm5n6aYo+ElQv1T1BYpmC/cLA5tG4/H28Xhfof3HhBOlca/3y5
        c5Or+cPi7fY+EiZ/5gtEEwMMgxc0LnVuH/sVNSANXJDLw16K1yzIVXF2S+a/gT3TnNcpjw
        6ISnkXOchkXSXMM1CwQOIS0n5KU+qHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool 12/21] Add helpers to pause the VM from vCPU
 thread
Message-ID: <ZIrS+wRuzzp3BZ9L@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230526221712.317287-13-oliver.upton@linux.dev>
 <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On Fri, Jun 09, 2023 at 06:59:53PM +0800, Shaoqin Huang wrote:
> Hi Oliver,
> 
> I have a play with this series, the guest always hang when hotplug two more
> cpus, it seems the kvm_cpu_continue_vm forget to continue the current cpu.

Thanks for testing the series out. Heh, a bit of a silly bug on my part,
sorry about that.

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
> Here should add:
> 	vcpu->paused = false;
> > +	kvm__continue(vcpu->kvm);
> > +}
> > +

LGTM, I'll stick this in v2.

> >   int kvm_cpu__start(struct kvm_cpu *cpu)
> >   {
> >   	sigset_t sigset;
> 
> -- 
> Shaoqin
> 

-- 
Thanks,
Oliver
