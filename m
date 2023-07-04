Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E77474F0
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjGDPHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGDPHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 11:07:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6670DE6
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 08:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688483196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HxNSeorzFhEFOo0iS/GO95xpCNcPqOVD1/XTzwVYfhw=;
        b=NAIFoTRQjDxc6nJiV0PB+HRWD5HRNQjq6K9XIcI60/Y+YqGXHQM5YFi7SSoXL2nwrNfNC6
        3lsADVs5iXKavGEft6CfsZh4HdD2DGSAPHdBQj3XizzBmthau4enGfxg6VyX5zZicU2iJ/
        /VfT2kKwzqGIfdl8TWy2ojd0z2aBbzE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-lrd9Cgr6MpeMF9gT0piRjA-1; Tue, 04 Jul 2023 11:06:32 -0400
X-MC-Unique: lrd9Cgr6MpeMF9gT0piRjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D9653810B0B;
        Tue,  4 Jul 2023 15:06:31 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5173640C2063;
        Tue,  4 Jul 2023 15:06:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
In-Reply-To: <ZJm+Kj0C5YySp055@linux.dev>
Organization: Red Hat GmbH
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-2-jingzhangos@google.com>
 <ZJm+Kj0C5YySp055@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 04 Jul 2023 17:06:30 +0200
Message-ID: <874jmjiumh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Wed, Jun 07, 2023 at 07:45:51PM +0000, Jing Zhang wrote:
>> Since number of context-aware breakpoints must be no more than number
>> of supported breakpoints according to Arm ARM, return an error if
>> userspace tries to set CTX_CMPS field to such value.
>> 
>> Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 50d4e25f42d3..a6299c796d03 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1539,9 +1539,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>>  			       const struct sys_reg_desc *rd,
>>  			       u64 val)
>>  {
>> -	u8 pmuver, host_pmuver;
>> +	u8 pmuver, host_pmuver, brps, ctx_cmps;
>>  	bool valid_pmu;
>>  
>> +	brps = FIELD_GET(ID_AA64DFR0_EL1_BRPs_MASK, val);
>> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs_MASK, val);
>> +	if (ctx_cmps > brps)
>> +		return -EINVAL;
>> +
>
> I'm not fully convinced on the need to do this sort of cross-field
> validation... I think it is probably more trouble than it is worth. If
> userspace writes something illogical to the register, oh well. All we
> should care about is that the advertised feature set is a subset of
> what's supported by the host.
>
> The series doesn't even do complete sanity checking, and instead works
> on a few cherry-picked examples. AA64PFR0.EL{0-3} would also require
> special handling depending on how pedantic you're feeling. AArch32
> support at a higher exception level implies AArch32 support at all lower
> exception levels.
>
> But that isn't a suggestion to implement it, more of a suggestion to
> just avoid the problem as a whole.

Generally speaking, how much effort do we want to invest to prevent
userspace from doing dumb things? "Make sure we advertise a subset of
features of what the host supports" and "disallow writing values that
are not allowed by the architecture in the first place" seem reasonable,
but if userspace wants to create weird frankencpus[1], should it be
allowed to break the guest and get to keep the pieces?

I'd be more in favour to rely on userspace to configure something that
is actually usable; it needs to sanitize any user-provided configuration
anyway.

[1] I think userspace will end up creating frankencpus in any case, but
at least it should be the kind that doesn't look out of place in the
subway if you dress it in proper clothing.

