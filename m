Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D14E6825
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351059AbiCXR4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbiCXR4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:56:25 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4F8B53F3
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:54:52 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c23so6281568ioi.4
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gpG1idH+Yq/AlWXjwzOnwn1kVIZQXLkaIHYX97/MawQ=;
        b=MYpAl0OQXl6DvwrVD7oy+bSQQqNg8SzP7VXOO84WaYazJhr9XS2f5kxDw24CAaifTr
         XYAEnoOIj46wwuvT0rRDJAfb1aoGKUamh9vzpKSzPEOEY+bJYsaPhBoaINOBXhEmOAiw
         KiedNaBLZ3jdwTBxaM/VKdEvZdBAryD3zg3fpOvnZ4cB81KKHHb+eJhpWqpsj7Hn7cjJ
         m1i4GTvG4gz6KPMJIEu7blaa1fXR1yDB7K4DH0wCvMfRckd60AUbHwP+/DWoye89eoQc
         I7I5cSKenjipPbDxDB1h2Jg2wbo79tKxwivIUKIr25hGbyxwtosPkudzXi5SCnSnMA6G
         evRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gpG1idH+Yq/AlWXjwzOnwn1kVIZQXLkaIHYX97/MawQ=;
        b=4vvDtqTcbOkCPwZJdt9BwbPWDiNBrmHsWsbzIz26N328CI7WEUzG/pM354+eRDxchZ
         BM92UFOMTu6jFlKxc8yVK0rjziz4UbQRKLm/nF9IAV6ncnhMNLE07qQgqB2lD6JVlxr4
         vy1rmPwNTamsg47vs3P1eBKbWxl5lo4+gLAc+TBP+Lof9p6r5bEWSdiSyAaeAmudHlRr
         sfOdeCx+jFkVjilv8lnOSCdyMSt0rAPJxx0wD5xgszFDOrfT/3zlaSSFrV87ZGW7Y91/
         v1ukpVHYYJ6Md4li99UG4AQEX9vDmijeXdqnmKG+HnZ/ip5qJsqi/GSzp+Qd4biHa3PX
         R1Mw==
X-Gm-Message-State: AOAM531wTvtKvi/zCBeHgiZhGYsf8pbeLVtg6+dF3bsgtN/NqpN6eN2k
        MWpoZxmfmF1rwTMreKtCwLkC8g==
X-Google-Smtp-Source: ABdhPJzbnF79TQYRTFkOeaXA/rSl336nRsKoUTSPeMgbge7b88rutsAZOrGq0gv9kjT12x/P/sclOg==
X-Received: by 2002:a05:6638:2651:b0:321:64e1:ef44 with SMTP id n17-20020a056638265100b0032164e1ef44mr3392957jat.202.1648144492021;
        Thu, 24 Mar 2022 10:54:52 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i81-20020a6bb854000000b00649c1b67a6csm1740776iof.28.2022.03.24.10.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:54:51 -0700 (PDT)
Date:   Thu, 24 Mar 2022 17:54:48 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <YjywaFuHp8DL7Q9T@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Thu, Mar 24, 2022 at 09:23:10AM -0700, Reiji Watanabe wrote:

[...]

> > > + */
> > > +#define KVM_ARM_ID_REG_MAX_NUM	64
> > > +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > +
> > >   struct kvm_arch {
> > >   	struct kvm_s2_mmu mmu;
> > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > >   	/* Memory Tagging Extension enabled for the guest */
> > >   	bool mte_enabled;
> > >   	bool ran_once;
> > > +
> > > +	/* ID registers for the guest. */
> > > +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > 
> > This is a decently large array. Should we embed it in kvm_arch or
> > allocate at init?
> 
> 
> What is the reason why you think you might want to allocate it at init ?

Well, its a 512 byte array of mostly cold data. We're probably
convinced that the guest is going to access these registers at most once
per vCPU at boot.

For the vCPU context at least, we only allocate space for registers we
actually care about (enum vcpu_sysreg). My impression of the feature
register ranges is that there are a lot of registers which are RAZ, so I
don't believe we need to make room for uninteresting values.

Additionally, struct kvm is visible to EL2 if running nVHE. I
don't believe hyp will ever need to look at these register values.

[...]

> > Which itself is dependent on whether KVM is going to sparsely or
> > verbosely define its feature filtering tables per the other thread. So
> > really only bother with this if that is the direction you're going.
> 
> Even just going through for ID register ranges, we should do the check
> to skip hidden/reserved ID registers (not to call read_sanitised_ftr_reg).
> 
> Yes, it's certainly possible to avoid walking the entire system register,
> and I will fix it.  The reason why I didn't care it so much was just
> because the code (walking the entire system register) will be removed by
> the following patches:)

Let me go through the series again and see how this flows. If there is a
way to avoid rewriting code introduced earlier in the series I would
suggest going that route.

--
Thanks,
Oliver
