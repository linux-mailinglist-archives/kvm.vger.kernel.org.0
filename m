Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B0F4E8AFD
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 00:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiC0W6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 18:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiC0W6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 18:58:47 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9245338780
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 15:57:08 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e22so15082713ioe.11
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 15:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CjWd0tIkzvNawm0BRbire5c+xv5CyJVt3CvwKbjZGYU=;
        b=HU76r327df81wux7lLJZxlV3xKwgkiZjrfmZN0JJlNrgn286Yoa3KZ3e+NFurt2IgZ
         n0v7rnpAql29TEOlz4ors0rA686wMsjljCfDmr2eg13AAHxepLJbv2rHOW7lwfO8dVqh
         v13zcVXNXuLHhcIOcJZUJNCoqTpfPKD+uRKD1VEOT8N+plRJkMFTUo1/Lak5SOkDR31A
         eKAjnziVgArmkcd4r2Z3iTyGhshRtWtKDXMkYlOME/wloMIutNcV6ZnUX/WmXrdp04tV
         2Uh4pSP1wPgF/AqyyqdxgblfNNGCtY57PicJzBObHDvMKzNQQ3qFEVoU0CY2sYcJScbK
         DEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CjWd0tIkzvNawm0BRbire5c+xv5CyJVt3CvwKbjZGYU=;
        b=vDIGZ4R2QJ1K379zlaQzVhm0xtmzLD6mdVuruaUE4ni0HD5/PE2ppRIt3Ylb3RblpD
         obtYwi+CZoc+FUFK7o+M8GOnkOxfcis5f1Tkxhx/76XXtYtIwzNoUWnGJzcs5eGMpKC1
         2VRXStM8IKWUqDHpEe2rpwrCi4v9HlvC/U5mWyM8FJ9ikQX9Djto2oGsE30Zht3aIc+M
         RCQKHQCEzObz6WqlYOzv4F3s1SJ1XcjQlFZE5s0Hvj0DLjEsf/a4HHkMclCDGDA+0E/d
         S56ovu4Mf26yX3TO2sIsXfdgUBWABOMsZgf6y61hBvu/Bt2XuuCUnwnyUGH39Xqu1jHu
         7WCA==
X-Gm-Message-State: AOAM531J+nlyi1L2/KhXYD3REqAB9/wa8YWIQ+Xk9iMs73IrJE9ByhDm
        tgD2fqSKKMCmdeLDFW+JMGIrJw==
X-Google-Smtp-Source: ABdhPJzjbeGKj2yG5O0QaikywUktGbrV4+4ADpjpuGoc+EZm/o+U4LtS5BnIg2inPsj+f6pnLX9jsA==
X-Received: by 2002:a05:6602:22da:b0:645:ec83:6393 with SMTP id e26-20020a05660222da00b00645ec836393mr4926399ioe.165.1648421827735;
        Sun, 27 Mar 2022 15:57:07 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id d15-20020a92360f000000b002c81e1fdae1sm6168555ila.85.2022.03.27.15.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 15:57:06 -0700 (PDT)
Date:   Sun, 27 Mar 2022 22:57:03 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
Message-ID: <YkDrv2JdZhVFnGMk@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com>
 <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
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

On Fri, Mar 25, 2022 at 07:35:39PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > > > > + */
> > > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > > +
> > > > >   struct kvm_arch {
> > > > >           struct kvm_s2_mmu mmu;
> > > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > > >           /* Memory Tagging Extension enabled for the guest */
> > > > >           bool mte_enabled;
> > > > >           bool ran_once;
> > > > > +
> > > > > + /* ID registers for the guest. */
> > > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > > >
> > > > This is a decently large array. Should we embed it in kvm_arch or
> > > > allocate at init?
> > >
> > >
> > > What is the reason why you think you might want to allocate it at init ?
> >
> > Well, its a 512 byte array of mostly cold data. We're probably
> > convinced that the guest is going to access these registers at most once
> > per vCPU at boot.
> >
> > For the vCPU context at least, we only allocate space for registers we
> > actually care about (enum vcpu_sysreg). My impression of the feature
> > register ranges is that there are a lot of registers which are RAZ, so I
> > don't believe we need to make room for uninteresting values.
> >
> > Additionally, struct kvm is visible to EL2 if running nVHE. I
> > don't believe hyp will ever need to look at these register values.
> 
> As saving/restoring breakpoint/watchpoint registers for guests
> might need a special handling when AA64DFR0_EL1.BRPs get changed,
> next version of the series will use the data in the array at
> EL2 nVHE.  They are cold data, and almost half of the entries
> will be RAZ at the moment though:)

Shouldn't we always be doing a full context switch based on what
registers are present in hardware? We probably don't want to leave host
watchpoints/breakpoints visible to the guest.

Additionally, if we are narrowing the guest's view of the debug
hardware, are we going to need to start trapping debug register
accesses? Unexposed breakpoint registers are supposed to UNDEF if we
obey the Arm ARM to the letter. Even if we decide to not care about
unexposed regs, I believe certain combinations of ID_AA64DF0_EL1.{BRPs,
CTX_CMPs} might require that we emulate.

--
Thanks,
Oliver
