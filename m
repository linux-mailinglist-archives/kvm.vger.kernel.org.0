Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2280D704A81
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 12:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjEPK1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 06:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjEPK1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 06:27:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6FF468E
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 03:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684232778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A8RPDB5oCUZPol53GuFRKa1PDnfifaD9ISAfpPJWqOU=;
        b=WoNrQaIRdRLKO44WdstukE5Sz6Up2LNlNGNSMpzStnCqhiOWO7Nde/b+T8MFLP7v2QGgAu
        am8AQmu+iSMq4tqe4r5qCUm+voW101VRx//XoIcZEBzcrA11uOTcaYq8v/F6Iz3ScBbOPV
        ekeUjVzZUcDKCuJQ3L89DXePJWKcmK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-M7Zkyq0vMxez3ve1Zok7Lw-1; Tue, 16 May 2023 06:26:13 -0400
X-MC-Unique: M7Zkyq0vMxez3ve1Zok7Lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B31E785A5B1;
        Tue, 16 May 2023 10:26:12 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70AA740C206F;
        Tue, 16 May 2023 10:26:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v8 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
In-Reply-To: <20230503171618.2020461-6-jingzhangos@google.com>
Organization: Red Hat GmbH
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-6-jingzhangos@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 16 May 2023 12:26:11 +0200
Message-ID: <87ilcsh8sc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03 2023, Jing Zhang <jingzhangos@google.com> wrote:

> Since reset() and val are not used for idreg in sys_reg_desc, they would
> be used with other purposes for idregs.
> The callback reset() would be used to return KVM sanitised id register
> values. The u64 val would be used as mask for writable fields in idregs.
> Only bits with 1 in val are writable from userspace.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
>  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
>  arch/arm64/kvm/sys_regs.h | 10 ++++---
>  3 files changed, 77 insertions(+), 36 deletions(-)
>

(...)

> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index e88fd77309b2..21869319f6e1 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -65,12 +65,12 @@ struct sys_reg_desc {
>  		       const struct sys_reg_desc *);
>  
>  	/* Initialization for vcpu. */

Maybe be a bit more verbose here?

/* Initialization for vcpu. Return initialized value, or KVM sanitized
   value for id registers. */

> -	void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> +	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
>  
>  	/* Index into sys_reg[], or 0 if we don't need to save it. */
>  	int reg;
>  
> -	/* Value (usually reset value) */
> +	/* Value (usually reset value), or write mask for idregs */
>  	u64 val;
>  
>  	/* Custom get/set_user functions, fallback to generic if NULL */

