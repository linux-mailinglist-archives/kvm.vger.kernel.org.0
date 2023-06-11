Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF07972B2AC
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjFKQBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 12:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjFKQBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 12:01:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9788097
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 09:01:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b1b51ec3e9so138005ad.0
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686499271; x=1689091271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQ1N9WL3eNjzq+2JvC0LUbWsGxnsU5gHhKdxp1bQqFI=;
        b=U8eWpW1rIOgTjrfHfL9mjGce1SYCiKyBeUe6GqsDOC8+bzv+lB4PDBxVYZuGAsjpjH
         7RqWf6wU/o4g9qZm6DzCgFzZYzlfFfvWFbuppfyzF+yqRHHIaCKFvJxj4/0DNs0xXF9c
         ZYcfKWxVJrzjqXgFtBTHm6opCgTv71HMSx8KrNJGRpucE/he9778RoDeK8yka70p/FXs
         l5a1REe0Ol7VTM1VCz8/H3C6LMNCbBK/bXls/d9qcu5PYKFdFQIpNvQhnHUpozuHINaf
         zGRmN7pmot8+rHPlBW0GQtAGNF964hrbTwVr9svom9UFaKPkT2of2rcGT5TDJNDKc28h
         mhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686499271; x=1689091271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQ1N9WL3eNjzq+2JvC0LUbWsGxnsU5gHhKdxp1bQqFI=;
        b=Dw0Acpt57+KKEJMK5/vVcW2Jzh7bnAR1btPVPYqP6HN8nSmxTryoMQlXDaXDHp+Zpx
         7ePDKxaKHQnIyRf0uMnMoHeKueMuIfInQTkZ0OHuegVimq8HFQhTKMUpauisFM00OYL/
         CXB/4WsygS6T0+UubpdI/Qrktox75ZMXsPfYk0rgUeC2Ovdd8DEvvD+jy2IuO0z88jdM
         VYGFD6i4rNVGmgueXxYdguNqaPTEtQGcooLIUdsx+bDwfID/YLgR3X1AYdvE+PqOeQ+K
         ebZYaBPIA+BtmtgUDoeYdEwX3Kg1P+vfCAL2ua7Wme0EhlNizcOgd1ISwBMe+n2CQjcm
         vtVA==
X-Gm-Message-State: AC+VfDzNh8dPF+gd85cVMpDDlF68iNkkJQj9tjkaNXcwFwcan6NgDDMV
        N8SJDK24wt1Ek/S55OPONfNduQ==
X-Google-Smtp-Source: ACHHUZ4c9Ppxv2ytbhO39hoK8kL3OhVbcHzWUsLHWOkWT0338uHA/UlBtmrY7QVbcNPZ4wXUXhk9Sw==
X-Received: by 2002:a17:902:c407:b0:1ac:36e6:2801 with SMTP id k7-20020a170902c40700b001ac36e62801mr146004plk.12.1686499270925;
        Sun, 11 Jun 2023 09:01:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id h5-20020a63e145000000b00528513c6bbcsm5995565pgk.28.2023.06.11.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 09:01:09 -0700 (PDT)
Date:   Sun, 11 Jun 2023 09:01:05 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <20230611160105.orvjohigsaevkcrf@google.com>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIV7+yKUdRticwfF@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

Thank you for the clarification!
But, I still have some questions on your comments.

> > > We emulate reads of PMCEID1_EL0 using the literal value of the CPU. The
> > > _advertised_ PMU version has no bearing on the core PMU version. So,
> > > assuming we hit this on a v3p5+ part with userspace (stupidly)
> > > advertising an older implementation level, we never clear the bit for
> > > STALL_SLOT.
> > 
> > I'm not sure if I understand this comment correctly.
> > When the guest's PMUVer is older than v3p4, I don't think we need
> > to clear the bit for STALL_SLOT, as PMMIR_EL1 is not implemented
> > for the guest (PMMIR_EL1 is implemented only on v3p4 or newer).
> > Or am I missing something ?
> 
> The guest's PMU version has no influence on the *hardware* value of
> PMCEID1_EL0.
> 
> Suppose KVM is running on a v3p5+ implementation, but userspace has set
> ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> the preceding line would advertise the STALL_SLOT event, and KVM fails
> to mask it due to the ID register value. The fact we do not support the
> event is an invariant, in the worst case we wind up clearing a bit
> that's already 0.

As far as I checked ArmARM, the STALL_SLOT event can be supported on
any PMUv3 version (including on v3p0).  Assuming that is true, I don't
see any reason to not expose the event to the guest in this particular
example. Or can the STALL_SLOT event only be implemented from certain
versions of PMUv3 ?


> This is why I'd suggested just unconditionally clearing the bit. While

When the hardware supports the STALL_SLOT event (again, I assume any
PMUv3 version hardware can support the event), and the guest's PMUVer
is older than v3p4, what is the reason why we want to clear the bit ?


> we're on the topic, doesn't the same reasoning hold for
> STALL_SLOT_{FRONTEND,BACKEND}? We probably want to hide those too.

Yes, I agree on that.  
I will include the fix for that as a part of this series!

Thank you,
Reiji
