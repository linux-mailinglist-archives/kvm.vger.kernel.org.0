Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614E8744ABC
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 19:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjGARmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 13:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjGARmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 13:42:37 -0400
Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AB31991
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 10:42:35 -0700 (PDT)
Date:   Sat, 1 Jul 2023 10:42:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688233353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tnh9qdBnPUJuyMP1cG7zLaM8l1NgjvNEN4PkBGU4vkU=;
        b=tdnWnAZcA7JaHuDZjJECWw7KaOiLwNknOOwUd0rW7qDnCpfJLQm7G9i6My3oi+x8p5zPUq
        9aS1FqKNHFDZETcvrHeQ0BvwfUHFIAnGqsJGozHYTR+92Z6BmeEH7ycv3NWgNrn5xHAiiJ
        V5xSO2UCoDIumuHaArArEfScg+zmgmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Kristina Martsenko <kristina.martsenko@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, isaku.yamahata@intel.com,
        seanjc@google.com, pbonzini@redhat.com, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>
Subject: Re: KVM CPU hotplug notifier triggers BUG_ON on arm64
Message-ID: <ZKBlhJwl9YD5FHvs@linux.dev>
References: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kristina,

Thanks for the bug report.

On Sat, Jul 01, 2023 at 01:50:52PM +0100, Kristina Martsenko wrote:
> Hi,
> 
> When I try to online a CPU on arm64 while a KVM guest is running, I hit a
> BUG_ON(preemptible()) (as well as a WARN_ON). See below for the full log.
> 
> This is on kvmarm/next, but seems to have been broken since 6.3. Bisecting it
> points at commit:
> 
>   0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")

Makes sense. We were using a spinlock before, which implictly disables
preemption.

Well, one way to hack around the problem would be to just cram
preempt_{disable,enable}() into kvm_arch_hardware_disable(), but that's
kinda gross in the context of cpuhp which isn't migratable in the first
place. Let me have a look...

--
Thanks,
Oliver
