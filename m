Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73976A50F
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 01:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjGaXts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 19:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjGaXtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 19:49:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4091B10CA
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 16:49:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583a4015791so45283257b3.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 16:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690847384; x=1691452184;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P0B1vNA3ci/7bTz6J8zSEr8JBoaBX3/9supBaUWD6qE=;
        b=qnuw0rzs0aChuqx6tVMgxOIDj2ItOTMGy8pND2RUsV5r9DroUikVmslsyt2JUENBwy
         pyMHM43IWGoi7vSRxErdUp4pP/WbLXA5AnUVLErr9oBqdU077R2QZoo/T9EOvpuGlVrR
         DuaQ4wWjPKhbUwVOw+hB3rk0B+UOLBbvQk6EVGFdXlmFYuUL6GRuyDy7LJFclEFpUw9l
         QkDfFZeRQWvVPQLJqSIqA+ECQ+x6WrTrABoJ7cjgu2AnHAN0PGq6LqnMhtIXjc0y15eU
         LZEBD2oIC/bJYBIK80rdsd70+YnaY39/Ua8/gfxq3WU1KCCXmFqRPED3zgGjTWF2IUAH
         7RZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690847384; x=1691452184;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P0B1vNA3ci/7bTz6J8zSEr8JBoaBX3/9supBaUWD6qE=;
        b=gOAiIXy8hfqKDljSs1MLgVSDs+aBXI+eXpa2Cgzx+LLcYajtOolk9exCoKdBy6Wk6p
         7WO8CF0Ix/FCOADj53tYmWgvaYKscqzmgiptbH+1ziEoG9SRMuu8ChWvbBLwM3RbZYqH
         ecR//eiJiOOXkMIbYryFTmD7e0FBbXTL1ECFl1yFZ57cmlf7XGRglB5qvHEMsLYFAjyh
         Ym6OtvNenK/RQqSj61jDV9hWqFehvUZmrIOEKMxlz+NFDMbs2EqZnq4YF79M2uy2Jpqv
         obCWzNjy4waxAJzppixpxFmPCMg6LNXzNUyJZ4yE/adol5sWV0BwmA2d328j/obVYVaE
         x0qQ==
X-Gm-Message-State: ABy/qLZTy5l4tYnE6NGnEAsoS4Xk+rDzV+mzzxmfqh2/qmW5TpAsIsew
        oEdg51KEpJDnibc1qIPoB1iC92eNjWM=
X-Google-Smtp-Source: APBJJlG3b+MECtgklEXpYRiWU0PZdTRPEnCroBHY+CPtJ5mOl9YiL4cfZoWA9B2dU7Iy3VqBUQvsVCY56K8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2546:0:b0:d10:dd00:385 with SMTP id
 l67-20020a252546000000b00d10dd000385mr74364ybl.0.1690847384498; Mon, 31 Jul
 2023 16:49:44 -0700 (PDT)
Date:   Mon, 31 Jul 2023 16:49:42 -0700
In-Reply-To: <20230728001606.2275586-2-mhal@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <20230728001606.2275586-2-mhal@rbox.co>
Message-ID: <ZMhIlj+nUAXeL91B@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU issues
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023, Michal Luczaj wrote:
> In a spirit of using a sledgehammer to crack a nut, make sync_regs() feed
> __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() with kernel's own
> copy of data.
>=20
> Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
> have exclusive rights to structs they operate on. While this is true when
> coming from an ioctl handler (caller makes a local copy of user's data),
> sync_regs() breaks this contract; a pointer to a user-modifiable memory
> (vcpu->run->s.regs) is provided. This can lead to a situation when incomi=
ng
> data is checked and/or sanitized only to be re-set by a user thread runni=
ng
> in parallel.

LOL, the really hilarious part is that the guilty,

  Fixes: 01643c51bfcf ("KVM: x86: KVM_CAP_SYNC_REGS")

also added this comment...

  /* kvm_sync_regs struct included by kvm_run struct */
  struct kvm_sync_regs {
	/* Members of this structure are potentially malicious.
	 * Care must be taken by code reading, esp. interpreting,
	 * data fields from them inside KVM to prevent TOCTOU and
	 * double-fetch types of vulnerabilities.
	 */
	struct kvm_regs regs;
	struct kvm_sregs sregs;
	struct kvm_vcpu_events events;
  };

though Radim did remove something so maybe the comment isn't as ironic as i=
t looks.

    [Removed wrapper around check for reserved kvm_valid_regs. - Radim]
    Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>

Anyways...

> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
> A note: when servicing kvm_run->kvm_dirty_regs, changes made by
> __set_sregs()/kvm_vcpu_ioctl_x86_set_vcpu_events() to on-stack copies of
> vcpu->run.s.regs will not be reflected back in vcpu->run.s.regs. Is this
> ok?

I would be amazed if anyone cares.  Given the justification and the author,

    This reduces ioctl overhead which is particularly important when usersp=
ace
    is making synchronous guest state modifications (e.g. when emulating an=
d/or
    intercepting instructions).
   =20
    Signed-off-by: Ken Hofsass <hofsass@google.com>

I am pretty sure this was added to optimize a now-abandoned Google effort t=
o do
emulation in uesrspace.  I bring that up because I was going to suggest tha=
t we
might be able to get away with a straight revert, as QEMU doesn't use the f=
lag
and AFAICT neither does our VMM, but there are a non-zero number of hits in=
 e.g.
github, so sadly I think we're stuck with the feature :-(
