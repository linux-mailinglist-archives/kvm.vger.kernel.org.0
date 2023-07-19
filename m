Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A527E759D17
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjGSSIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 14:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGSSIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 14:08:47 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCEA1FC4
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 11:08:46 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-345bc4a438fso11105ab.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 11:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689790125; x=1690394925;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ui7psRwlM+a2Yq2a67GdTfFgGYuP52lm5NF/97EmBNk=;
        b=k7EVc44FYiypDLV/fHhx/l0W/p55++c1waRmlDHNoXkyDC062iZy4xZNWy13BQ8zUQ
         eEo0ENPBTHxBXH3b2a3PvvmIQnul68T0DUgrjvYXl/Y4byzhcRl1sn7Y7ow7S0i5YTCt
         /3iQSGRmTa7D8Zuo9FeljT//bedT5YZ5rlZzhQMjJO3T6SKPqc9xaI4NHiD4ha9529hg
         ftsePExNxOn7hMagk7Q861cvY5rsiLUF+/LtIDlvzkYXxCpingSUDyfn2bjaygPk7iB8
         2Gge/K1av5A7Qn88tXinPk6eizF1Or0YwQUXqN2DfP14nOIapipovplnMiexJH5vH1of
         O9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689790125; x=1690394925;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ui7psRwlM+a2Yq2a67GdTfFgGYuP52lm5NF/97EmBNk=;
        b=VMQK2lH7xPcPh7T6PWd+CxfANSc7PJOHxO2EW2CMYMIkG1d3P4EYYCHRlpaCh9jXTC
         rCkVM7NHkWtIX7tFZ87Vb2bS0tMF08mCW86mbqPoG7Y2Bp8vTotauEEANpdg3A0Gk2EG
         J7DOoMFI/176rUOsMKb3p2xUwxsnsaQUE+F5tiS4JF5062oQ7vmp9Ql4VTX1D05sCURe
         pz7jmf44X+HmM51yhctGE6BVWTZjwtSKrrhib5PutMhpxpPhp6r/1alO2kR2+5uiizjd
         gXPg7yuTLHgWuXmw6hZkqGOJLbWMnDPAEA1zx5CcHdOBdYunhF9VrGnHuIeMFjAlt+TL
         h53A==
X-Gm-Message-State: ABy/qLZ3ClQ9fdBBKG5fCdictmS0ak6HxaQ1DyrNSHNjawwPL0+uEKcJ
        Eu+pnq633nO17+/NKVrmk8hbSs2Pk0I1Gz4QldFHm5vZKAUmJ7VbUgo=
X-Google-Smtp-Source: APBJJlFsTmlpr7GV+U/70DOIelMDDS0dmLjRhEYxnF8+V5U/pQYyVYDxY16IUVtaOA1aH+mCwhk6nUeUyInLp8cO2V4=
X-Received: by 2002:a05:6e02:1b07:b0:335:6626:9f38 with SMTP id
 i7-20020a056e021b0700b0033566269f38mr26261ilv.0.1689790125468; Wed, 19 Jul
 2023 11:08:45 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Jul 2023 11:08:34 -0700
Message-ID: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
Subject: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Normally, we would restrict guest MSR writes based on guest CPU
features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
the case.

For the first non-zero write to IA32_SPEC_CTRL, we check to see that
the host supports the value written. We don't care whether or not the
guest supports the value written (as long as it supports the MSR).
After the first non-zero write, we stop intercepting writes to
IA32_SPEC_CTRL, so the guest can write any value supported by the
hardware. This could be problematic in heterogeneous migration pools.
For instance, a VM that starts on a Cascade Lake host may set
IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
migrated to a Skylake host, KVM_SET_MSRS will refuse to set
IA32_SPEC_CTRL to its current value, because Skylake doesn't support
PSFD.

We disable write intercepts IA32_PRED_CMD as long as the guest
supports the MSR. That's fine for now, since only one bit of PRED_CMD
has been defined. Hence, guest support and host support are
equivalent...today. But, are we really comfortable with letting the
guest set any IA32_PRED_CMD bit that may be defined in the future?

The same question applies to IA32_SPEC_CTRL. Are we comfortable with
letting the guest write to any bit that may be defined in the future?
At least the AMD approach with V_SPEC_CTRL prevents the guest from
clearing any bits set by the host, but on Intel, it's a total
free-for-all. What happens when a new bit is defined that absolutely
must be set to 1 all of the time?
