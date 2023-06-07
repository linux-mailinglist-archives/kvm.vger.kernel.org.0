Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3365725B50
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 12:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbjFGKKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 06:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbjFGKKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 06:10:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3163C1BC9
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 03:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686132559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BeQhaSHu7cWs6XucEltOCfbvT3TUoRppwvtRNtAUuIY=;
        b=KqqPaWohd4tImIJmJhpklkCjsTplhuVxjjzPNRRl2lWU989scCwUTH85Ha9IDc+qBHcLcl
        6UwtrE5Pb4zVTTbzqqp7sRhZgldwDowqxUmSP1xZXJeUG3kf9RuJxBosvGcZG265qqPxbx
        m5o1PBWcZV3pOaqymprRcuzFuvLCkLE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-Oj4KIRh6NymDk4IfVC_MTA-1; Wed, 07 Jun 2023 06:09:16 -0400
X-MC-Unique: Oj4KIRh6NymDk4IfVC_MTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6488485A5BB;
        Wed,  7 Jun 2023 10:09:15 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DB292026D49;
        Wed,  7 Jun 2023 10:09:15 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Suraj Jitindar Singh <surajjs@amazon.com>, jingzhangos@google.com,
        alexandru.elisei@arm.com, james.morse@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        oupton@google.com, pbonzini@redhat.com, rananta@google.com,
        reijiw@google.com, suzuki.poulose@arm.com, tabba@google.com,
        will@kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH 3/3] KVM: arm64: Use per guest ID register for
 ID_AA64PFR1_EL1.MTE
In-Reply-To: <87legwo83z.wl-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230602005118.2899664-1-jingzhangos@google.com>
 <20230602221447.1809849-1-surajjs@amazon.com>
 <20230602221447.1809849-4-surajjs@amazon.com>
 <873539ospa.wl-maz@kernel.org> <87h6rl50dl.fsf@redhat.com>
 <87legwo83z.wl-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 07 Jun 2023 12:09:14 +0200
Message-ID: <87wn0fmvn9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06 2023, Marc Zyngier <maz@kernel.org> wrote:

> On Mon, 05 Jun 2023 17:39:50 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> On Sat, Jun 03 2023, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> > On Fri, 02 Jun 2023 23:14:47 +0100,
>> > Suraj Jitindar Singh <surajjs@amazon.com> wrote:
>> >> 
>> >> With per guest ID registers, MTE settings from userspace can be stored in
>> >> its corresponding ID register.
>> >> 
>> >> No functional change intended.
>> >> 
>> >> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
>> >> ---
>> >>  arch/arm64/include/asm/kvm_host.h | 21 ++++++++++-----------
>> >>  arch/arm64/kvm/arm.c              | 11 ++++++++++-
>> >>  arch/arm64/kvm/sys_regs.c         |  5 +++++
>> >>  3 files changed, 25 insertions(+), 12 deletions(-)
>> >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> >> index ca18c09ccf82..6fc4190559d1 100644
>> >> --- a/arch/arm64/kvm/arm.c
>> >> +++ b/arch/arm64/kvm/arm.c
>> >> @@ -80,8 +80,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>> >>  		if (!system_supports_mte() || kvm->created_vcpus) {
>> >>  			r = -EINVAL;
>> >>  		} else {
>> >> +			u64 val;
>> >> +
>> >> +			/* Protects the idregs against modification */
>> >> +			mutex_lock(&kvm->arch.config_lock);
>> >> +
>> >> +			val = IDREG(kvm, SYS_ID_AA64PFR1_EL1);
>> >> +			val |= FIELD_PREP(ID_AA64PFR1_EL1_MTE_MASK, 1);
>> >
>> > The architecture specifies 3 versions of MTE in the published ARM ARM,
>> > with a 4th coming up as part of the 2022 extensions.
>> 
>> Is that the one that adds some more MTE<foo> bits in AA64PFR1 and
>> AA64PFR2?
>
> Yeah, that. You get ID_AA64PFR1_EL1.{MTE,MTE_frac,MTEX}, plus
> ID_AA64PFR2_EL1.{MTEFAR,MTESTOREONLY,MTEPERM}... It this sounds like a
> train wreck, then it probably is one!

With that many features, what could possibly go wrong!

>
>> 
>> > Why are you
>> > actively crippling the MTE version presented to the guest, and
>> > potentially introduce unexpected behaviours?
>> 
>> While the code does not look correct here, I think we'll need some way to
>> control which version of MTE is presented to the guest for compatibility
>> handling; does it make sense to control this per-cpu, or does it need to
>> be a vm-wide setting?
>
> It absolutely needs to be VM-wide. Only having half the vcpus
> supporting tags wouldn't make much sense.
>
> But the problem is that the various versions of MTE are not
> necessarily compatible, as MTE4 makes MTE3 optional (with a fallback
> to MTE2)... There are more subtleties around the what instructions are
> available in which mode, and whether the various subfeatures can be
> configured or not.

So I guess we'll have to expose all of that to userspace, so that it can
actually configure the various configurations that will surely show up
in the wild...

