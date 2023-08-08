Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A665774A94
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbjHHUbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjHHUbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB74F44806;
        Tue,  8 Aug 2023 09:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7512662509;
        Tue,  8 Aug 2023 16:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06C2C433C8;
        Tue,  8 Aug 2023 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691512984;
        bh=qn/5n73aPx19R3sftb3hyCv0xP0bVP4jPYkwssW5D70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EI/M+9L9WfV7CfX9Gg3l8wginZaWaHFChW2GM/OsGfB64YDDzgU8NJsfkDrHXAvR5
         VAaNmxsPoqAHDEiP8QulOu4i3ulD9YXkGKshknFhvU2u/SxvikGwp/YsrNUGVLkPw1
         FTzl+keanf3MdzsjLZoGYa7oT0z7q0DKG1X4hSjicnx40hnIFKQ1T80kw3emqiyqrU
         qSJHtLdCG2fha5vwJPzSzfRqjDfWoP2oD1r97l9SogvHJSiPgP8wzPENILebk1zzmj
         2zFUZQP4wQ/G7opUpEJ2KrCWciEWKfgvHzrrOBU53m0/AjNq+SZusg16vaM6+4MQNT
         uUWZZf7j9O3Ag==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTPnS-003BwZ-B2;
        Tue, 08 Aug 2023 17:43:02 +0100
MIME-Version: 1.0
Date:   Tue, 08 Aug 2023 17:43:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
In-Reply-To: <CAJHc60yiGnVc=ysdOaNemWaDpTBSk02mRLenK3sN2XtN_Cp98g@mail.gmail.com>
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-3-rananta@google.com> <87tttpr6qy.wl-maz@kernel.org>
 <ZMgsjx8dwKd4xBGe@google.com> <877cqdqw12.wl-maz@kernel.org>
 <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
 <ZNJaPxTtPRCv0HOl@google.com>
 <CAJHc60yiGnVc=ysdOaNemWaDpTBSk02mRLenK3sN2XtN_Cp98g@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fc430350dd7d8ac664054a99f1e452c1@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: rananta@google.com, seanjc@google.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, pbonzini@redhat.com, chenhuacai@kernel.org, yuzenghui@huawei.com, anup@brainfault.org, atishp@atishpatra.org, jingzhangos@google.com, reijiw@google.com, coltonlewis@google.com, dmatlack@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-08-08 17:19, Raghavendra Rao Ananta wrote:
> On Tue, Aug 8, 2023 at 8:07 AM Sean Christopherson <seanjc@google.com> 
> wrote:
>> 
>> On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
>> > On Wed, Aug 2, 2023 at 4:28 PM Raghavendra Rao Ananta
>> > <rananta@google.com> wrote:
>> > >
>> > > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
>> > >
>> > While working on the renaming, I realized that since this function is
>> > called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rename
>> > this and the other kvm_flush_*() functions that the series introduces
>> > to match their kvm_arch_flush_*() counterparts?
>> 
>> Hmm, if we're going to rename one arch hook, then yes, I think it 
>> makes sense to
>> rename all the common APIs and arch hooks to match.
>> 
>> However, x86 is rife with the "remote_tlbs" nomenclature, and renaming 
>> the common
>> APIs will just push the inconsistencies into x86.  While I 100% agree 
>> that the
>> current naming is flawed, I am not willing to end up with x86 being 
>> partially
>> converted.
>> 
>> I think I'm ok renaming all of x86's many hooks?  But I'd definitely 
>> want input
>> from more x86 folks, and the size and scope of this series would 
>> explode.  Unless
>> Marc objects and/or has a better idea, the least awful option is 
>> probably to ignore
>> the poor "remote_tlbs" naming and tackle it in a separate series.
>> 
> Sure, I think it's better to do it in a separate series as well. I'm
> happy to carry out the task after this one gets merged. But, let's
> wait for Marc and others' opinion on the matter.

Yeah, let's punt that to a separate series. I'm more interested in
getting this code merged than in the inevitable bike-shedding that
will result from such a proposal.

Raghavendra, any chance you could respin the series this week?
I'd really like it to spend some quality time in -next...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
