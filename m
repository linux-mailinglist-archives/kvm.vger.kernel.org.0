Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93A46CB577
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 06:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjC1Ein (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 00:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjC1Eik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 00:38:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FADD1FFB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:38:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b1-20020a17090a8c8100b002400db03706so2890424pjo.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679978294;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rcAqgQ8BH2Pd6M4X5nC8yYas5XPVcEcHPdn5I8yTc5c=;
        b=F0y+ZlDZv9wReZiTDaK8D2Y9QzR6ohdjctRhdfVzmHxpj/4gFzrKKuHU65h5oumTdA
         hrxu4FVimICN0L3xUlSz69j8BsPIvHAbLBY8/VuRKrnlge0Vpo7X65mJhfUPF8jYeezg
         a4mrftgrNyPCrWsWXjF3f6KoFxkan+BJUxt38tE3gzIVRYU/aG8ssHFxvcWDi33R9k72
         CkW1J94yEqUTAiRR8rlNlLtwPatPYJ07NvR2PmrofUDaLk+c6WtoaPXy5vBODi+K5Z/g
         DnthRq7G5PJvL/FTSF/4pnBcbfUc8K80FgH09Lob97afCVDMyUIqyfbfMc/sEvK2H5WM
         J1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679978294;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rcAqgQ8BH2Pd6M4X5nC8yYas5XPVcEcHPdn5I8yTc5c=;
        b=DUg/6PDnjsvkAwujQGSyW/8g+Jx4AKLJL/aAjOVNI3ZoslWJn04Bz01rgDgcMfbMSb
         6Y+bbN2frotU6FE/RpI0iuaIiJzWSFxJy09P+OOlE52GXTt4Aqi7M4MS+S0uQ1271FQd
         CXofuFhz2FXH8+BEloeJDLU/fW81s00nC7H4ECzUDl3m0A6WEFKLJff0PuG1rqUeaIf7
         IGuvP4IFI2ih6/eTkMdmhSXxQ2ENdTRQ4Xyj+x5dQIjAoCckjhNlL8QniOV/CHKYCOo8
         Q0QQVHdmS/1/GJSEmtHHG4RtUvrC+U+D6fIiiUWjoqKTU/ssPX3MKZ8tt2RnTkmrOAER
         lzkA==
X-Gm-Message-State: AAQBX9eECCYzT/IhnCTlFh3g3Of03CJT1nxqF3KxUXQmpqMKHqcVcg1E
        yD1a4AmOihzbtgBfrjn9knm5re06kXo=
X-Google-Smtp-Source: AKy350ZBV7I8ZBSrQ9pzx5uhdonFvp2L4ZDqEPY8dbkJruv2l0Ti8RKraySA1RqdgUvobnP7uUGSs9BFBxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5141:b0:23d:50d0:4ba4 with SMTP id
 k1-20020a17090a514100b0023d50d04ba4mr4324480pjm.3.1679978293792; Mon, 27 Mar
 2023 21:38:13 -0700 (PDT)
Date:   Tue, 28 Mar 2023 04:38:12 +0000
In-Reply-To: <CA+wubQBsiaH_==UJ-JUi7hwS8W1i5MLZ-dPuw2smVH8Z0sqXsw@mail.gmail.com>
Mime-Version: 1.0
References: <20230310125718.1442088-1-robert.hu@intel.com> <20230310125718.1442088-4-robert.hu@intel.com>
 <ZAtaY8ISOZyXB3V+@google.com> <CA+wubQBsiaH_==UJ-JUi7hwS8W1i5MLZ-dPuw2smVH8Z0sqXsw@mail.gmail.com>
Message-ID: <ZCJvNOAP1Qiye2YV@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Use the canonical interface to read
 CR4.UMIP bit
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     Robert Hoo <robert.hu@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 11, 2023, Robert Hoo wrote:
> Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=881=
1=E6=97=A5=E5=91=A8=E5=85=AD 00:27=E5=86=99=E9=81=93=EF=BC=9A
> > Practically speaking, UMIP _can't_ be guest owned without breaking UMIP
> emulation.
>=20
> Agree.
> Can we expect that in the future (not near future) that emulating UMIP
> isn't needed at all? I mean, when all x86 CPUs on the market have UMIP in=
 native.

Heh, define "all x86s on the market".  UMIP didn't come along until Broadwe=
ll, and
we still get bug reports for Core2.  It's going to be a long, long time bef=
ore
KVM can require UMIP support on Intel CPUs.
