Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA5444DD6
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 04:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhKDDu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 23:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhKDDu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 23:50:26 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B5C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 20:47:47 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f8so5011855plo.12
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 20:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M0r2p3OOH61oDyvN0PBFDZ4Q0DOlfJgJGVtNc++dJCk=;
        b=mr/KTiNxbDQ4evUG6tUYsyusqMMA37EOsr4ukvw9saX7asucZVYuLBKZI2eht4aPKh
         LthpBG576+NU1DQ8S/EDEtUzOXqIgljstx6070WVHOAkqzbw8IQuSJxktCYuTmNZ65kG
         9NWEDhWL9C6eASsgSelnsnmVvCW0OkHDrIakow//p+o8FVyIlXCdAsMTaxZ2PWSyA3Ks
         bL1r3jAOsQo789iAq7CNU+iwsPCBqbZTj2RZgfuPQN8b/UgkfPdXD3dWW68UvGijRC6G
         NBFpDMLgCAQIywWnO18+ATgJD7R6zenlmHpdFUYf3R3Xow31PL/jaEyO6GkNVXyvE/v/
         dUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M0r2p3OOH61oDyvN0PBFDZ4Q0DOlfJgJGVtNc++dJCk=;
        b=nihLs0bu5SeHh8uXcAKhbif1KSgHNrQJ8S1I67MjAeAN/RnO4bNfqfTl88AhBtQQ37
         BJVKUwDcXAqk0813A7QZOmGvF5HCUBCMeatnTyj6ZnwBc/Lw5918WNmp71gat+vLIXuO
         QpMaRYu+B3CnGBCCVNbfPgn9TlE7vA6cXilcd38+BCH4TgOAI3jHWNhKyBw9IRdq8kNB
         a4/nPg5uVOBb34jLZmYLNCxlHqfiX2nMGuK9jygq1eEB61IOUJdAmSxhMQYW6zbCOawb
         zAbelgUwmNzIk0F1ko5SB2QTQQJSGpHK5jedi5xVGSSBtjXesSoueylPpWC8p7pJ/5ug
         DDyw==
X-Gm-Message-State: AOAM533vmEJ9lDZ4RImM/dujOxlzFp62APfqyqGL8VME7P/0RIMYzkVL
        YXlRQIJvojYxvc9EDUBJxHdkgQ==
X-Google-Smtp-Source: ABdhPJwlHPu6tW1vJnStRsXPTMgK4BsJQmRUJd5P2uIIae7yUo0eCPgGaA0mOKtJjyoNIGwo7FfonA==
X-Received: by 2002:a17:902:a412:b0:140:a4a:4ba with SMTP id p18-20020a170902a41200b001400a4a04bamr42454941plq.52.1635997666974;
        Wed, 03 Nov 2021 20:47:46 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f22sm2932671pgk.21.2021.11.03.20.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 20:47:46 -0700 (PDT)
Date:   Wed, 3 Nov 2021 20:47:42 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Allow guest to set the OSLK bit
Message-ID: <YYNX3t3yOL9LKKdP@google.com>
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-4-oupton@google.com>
 <CAAeT=FxdXX77kkANAgLX-xbsvjdeRtCZQ25dZQ1Rqw+-jU=_dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxdXX77kkANAgLX-xbsvjdeRtCZQ25dZQ1Rqw+-jU=_dg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021 at 08:31:35PM -0700, Reiji Watanabe wrote:
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Allow writes to OSLAR and forward the OSLK bit to OSLSR. Change the
> > reset value of the OSLK bit to 1. Allow the value to be migrated by
> > making OSLSR_EL1.OSLK writable from userspace.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  6 ++++++
> >  arch/arm64/kvm/sys_regs.c       | 35 +++++++++++++++++++++++++--------
> >  2 files changed, 33 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index b268082d67ed..6ba4dc97b69d 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -127,7 +127,13 @@
> >  #define SYS_DBGWCRn_EL1(n)             sys_reg(2, 0, 0, n, 7)
> >  #define SYS_MDRAR_EL1                  sys_reg(2, 0, 1, 0, 0)
> >  #define SYS_OSLAR_EL1                  sys_reg(2, 0, 1, 0, 4)
> > +
> > +#define SYS_OSLAR_OSLK                 BIT(0)
> > +
> >  #define SYS_OSLSR_EL1                  sys_reg(2, 0, 1, 1, 4)
> > +
> > +#define SYS_OSLSR_OSLK                 BIT(1)
> > +
> >  #define SYS_OSDLR_EL1                  sys_reg(2, 0, 1, 3, 4)
> >  #define SYS_DBGPRCR_EL1                        sys_reg(2, 0, 1, 4, 4)
> >  #define SYS_DBGCLAIMSET_EL1            sys_reg(2, 0, 7, 8, 6)
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 0326b3df0736..acd8aa2e5a44 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -44,6 +44,10 @@
> >   * 64bit interface.
> >   */
> >
> > +static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > +static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > +static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > +
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> >                                  struct sys_reg_params *params,
> >                                  const struct sys_reg_desc *r)
> > @@ -287,6 +291,24 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >         return trap_raz_wi(vcpu, p, r);
> >  }
> >
> > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > +                          struct sys_reg_params *p,
> > +                          const struct sys_reg_desc *r)
> > +{
> > +       u64 oslsr;
> > +
> > +       if (!p->is_write)
> > +               return read_from_write_only(vcpu, p, r);
> > +
> > +       /* Forward the OSLK bit to OSLSR */
> > +       oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > +       if (p->regval & SYS_OSLAR_OSLK)
> > +               oslsr |= SYS_OSLSR_OSLK;
> > +
> > +       __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > +       return true;
> > +}
> > +
> >  static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
> >                            struct sys_reg_params *p,
> >                            const struct sys_reg_desc *r)
> > @@ -309,9 +331,10 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >         if (err)
> >                 return err;
> >
> > -       if (val != rd->val)
> > +       if ((val | SYS_OSLSR_OSLK) != rd->val)
> >                 return -EINVAL;
> >
> > +       __vcpu_sys_reg(vcpu, rd->reg) = val;
> >         return 0;
> >  }
> >
> > @@ -1176,10 +1199,6 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> >         return __access_id_reg(vcpu, p, r, true);
> >  }
> >
> > -static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> > -static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> > -static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > -
> >  /* Visibility overrides for SVE-specific control registers */
> >  static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >                                    const struct sys_reg_desc *rd)
> > @@ -1456,8 +1475,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >         DBG_BCR_BVR_WCR_WVR_EL1(15),
> >
> >         { SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
> > -       { SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
> > -       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
> > +       { SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
> > +       { SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x0000000A,
> >                 .set_user = set_oslsr_el1, },
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> I assume the reason why you changed the reset value for the
> register is because Arm ARM says "the On a Cold reset,
> this field resets to 1".
> 
> "4.82 KVM_ARM_VCPU_INIT" in Documentation/virt/kvm/api.rst says:
> -------------------------------------------------------------
>   - System registers: Reset to their architecturally defined
>     values as for a warm reset to EL1 (resp. SVC)
> -------------------------------------------------------------
> 
> Since Arm ARM doesn't say anything about a warm reset for the field,
> I would guess the bit doesn't necessarily need to be set.

That would be great, because it would avoid the migration issue that
Oliver described in [PATCH v2 4/6]:

	There is an issue, though, with migration: older KVM will not show
	OSLSR_EL1 on KVM_GET_REG_LIST. However, in order to provide an
	architectural OS Lock, its reset value must be 1 (enabled). This would
	all have the effect of discarding the guest's OS lock value and
	blocking all debug exceptions intended for the guest until the next
	reboot.

> 
> Thanks,
> Reiji
> 
> 
> >         { SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
> >         { SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
> > @@ -1930,7 +1949,7 @@ static const struct sys_reg_desc cp14_regs[] = {
> >
> >         DBGBXVR(0),
> >         /* DBGOSLAR */
> > -       { Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
> > +       { Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },
> >         DBGBXVR(1),
> >         /* DBGOSLSR */
> >         { Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
