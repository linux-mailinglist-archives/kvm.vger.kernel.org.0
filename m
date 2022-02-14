Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B554B5D0D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiBNVkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiBNVkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:40:14 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD61116EA95
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:40:05 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so20840044ooq.10
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YT6zZyQUvGCeRrKRg8UxpuA8RbCscUJsYx2Teoa3eXs=;
        b=nNSlXen+XWntdZGO88GxihKqGKTiozCUFjIhVrT3c8yLknujX/fPBZC8CiTQIbnIxf
         hadBjF94k8idc9OGUSSHwAYwEBH5FKIneaY+vRlZpoXVi2DpOzEGVMIgEgHWBcaHXEqt
         b1+5u+Lr2sbWV9XhV5b+W7Z9GrAdyGA9nhTTrhnhtcrDq9eQDGW2SNfQP/FomXFw2Iou
         nJyEUHWhmx3anSxE1qPsKgPmRgNPPLINjYGKZNunKc+9l8lXugTvWOChL6MOmK399BRo
         vefgp7vYDaJ3zlUmMpTcVrGBGPotgK/ke+IC0prlPw82V90bi5Rni+NUhCykPCKc5zTo
         fJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YT6zZyQUvGCeRrKRg8UxpuA8RbCscUJsYx2Teoa3eXs=;
        b=yi9SX6vxFRGwMq1iBcogKDyO9tnASi8D638q9SBgyU3L0MGJLHd0vC7cfXhguIWzEH
         0z2b2uhJ+DSpsRcvBJWsNOT+lbowjxpOivfaBNB/LwmOpzO1R6pgyeUZMDl+L2P8Vazo
         Cci8qpcwDlV/DH6zSVsJmHMHKAzaP+dAiX7uRGAUcUOtcoRLHRCPYCmhoLD/blADFnVV
         UTnuu9TU/UbWf2owdWHmgF8lmBa2Z8NCwrNgnb2jGMXrwACW17WUpCK9cKKQ6UqiwakU
         OuIaONEg1esJ5Eoy4HkE01fBb2g/MgGHfwMIRvF7nTK6Dx2cMUI0IejbPCJCQFeRmwI+
         FHdg==
X-Gm-Message-State: AOAM530Cbk3TKQqGeFFiSwvQG7E2jVhgh8xZoGSSk9/8eEodXr649fA9
        RW4xGDLUiA11E1BWaToOJcjp+ESaP7ZEq8Vo9PQkjxjqnPlWzw==
X-Google-Smtp-Source: ABdhPJzglRPtH4rEDP5iajQA0w8EoodebhUI6+Qf3zS0BMUscj+6/gfIHlyc9B9UtSUIURw0u8UKy3SH/AK0BM/4m7M=
X-Received: by 2002:a05:6870:d693:: with SMTP id z19mr297809oap.129.1644874804935;
 Mon, 14 Feb 2022 13:40:04 -0800 (PST)
MIME-Version: 1.0
References: <20180814173049.21756-1-jmattson@google.com> <20180814185231.GF30977@char.us.oracle.com>
 <CALMp9eQ+NHvq4uDQp86AmHbeFxj0_nhWzOeoa-tp9vhQ7qk04g@mail.gmail.com>
In-Reply-To: <CALMp9eQ+NHvq4uDQp86AmHbeFxj0_nhWzOeoa-tp9vhQ7qk04g@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Feb 2022 13:39:54 -0800
Message-ID: <CALMp9eR_5EgJH6KuD028MhioPGdVRfmHTwNSzceNN+jaSeiX8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: vmx: Add IA32_FLUSH_CMD guest support
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Aug 14, 2018 at 12:30 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Aug 14, 2018 at 11:52 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Tue, Aug 14, 2018 at 10:30:48AM -0700, Jim Mattson wrote:
> >> Expose IA32_FLUSH_CMD to the guest if the guest CPUID enumerates
> >> support for this MSR. As with IA32_PRED_CMD, permission for
> >> unintercepted writes to this MSR will be granted to the guest after
> >> the first non-zero write.
> >
> > I can't seem to find the Intel docs (even thought all the pages
> > are all set), but my understanding is that the ARCH_CAPABILITIES Bit(3)
> > would suffice. That is it says that for nested OSes you shouldn't
> > use the IA32_FLUSH_CMD?
>
> If the L0 hypervisor performs an L1D$ flush on every emulated VM-entry
> from L1 to L2 (which kvm may or may not do, depending on its
> configuration) and if it reports that in
> IA32_ARCH_CAPABILITIES.SKIP_L1DFL_VMENTRY[bit 3], then it would be
> pointless for the L1 hypervisor to use IA32_FLUSH_CMD on VM-entry to
> L2. However, (a) the L0 hypervisor may not perform an L1D$ flush on
> every emulated VM-entry from L1 to L2, and (b) there may be other
> reasons that an L1 guest (hypervisor or not) wants to perform an L1D$
> flush using IA32_FLUSH_CMD. It is more forward-thinking to provide
> this capability than it is not to. And it's all configurable from
> userspace, so if you don't want it, you don't have to enable it.

Ping.
