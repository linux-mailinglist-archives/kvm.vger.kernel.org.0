Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7436575AA15
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 10:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjGTI6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 04:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjGTIxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 04:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965E62115
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 01:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689843174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gwK8AXz7jkXfdRTnSd9jL9yJK/TtFs99GYswlm71JSI=;
        b=Cx8tmmtlQ8URKH+Jitd3ztpFczqHNxbQ7Wiwn0sDcctS7d3Tf2XICjDkUZEju6v+qfHQPa
        2EIemam3jUVrUMNubrawevQ/xkG3C9APVWO9XISMh1AzxlaSc3WpzeE0LYlk8FonitlOKH
        A26xubp14id/TChonZFVdrhHafAjnAE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-3OwwNMXhMeira2AVwmr1UA-1; Thu, 20 Jul 2023 04:52:48 -0400
X-MC-Unique: 3OwwNMXhMeira2AVwmr1UA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C67FD10504C1;
        Thu, 20 Jul 2023 08:52:47 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 810D240C206F;
        Thu, 20 Jul 2023 08:52:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
In-Reply-To: <20230718164522.3498236-4-jingzhangos@google.com>
Organization: Red Hat GmbH
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 20 Jul 2023 10:52:46 +0200
Message-ID: <87o7k77yn5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:

> All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> from usrespace with this change.

Typo: s/usrespace/userspace/

>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 053d8057ff1e..f33aec83f1b4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  .set_user = set_id_dfr0_el1,
>  	  .visibility = aa32_id_visibility,
>  	  .reset = read_sanitised_id_dfr0_el1,
> -	  .val = ID_DFR0_EL1_PerfMon_MASK, },
> +	  .val = GENMASK(63, 0), },
>  	ID_HIDDEN(ID_AFR0_EL1),
>  	AA32_ID_SANITISED(ID_MMFR0_EL1),
>  	AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  .get_user = get_id_reg,
>  	  .set_user = set_id_aa64dfr0_el1,
>  	  .reset = read_sanitised_id_aa64dfr0_el1,
> -	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
> +	  .val = GENMASK(63, 0), },
>  	ID_SANITISED(ID_AA64DFR1_EL1),
>  	ID_UNALLOCATED(5,2),
>  	ID_UNALLOCATED(5,3),

How does userspace find out whether a given id reg is actually writable,
other than trying to write to it?

