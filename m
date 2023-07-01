Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A2274497A
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjGANyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 09:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjGANyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 09:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336483C0A
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 06:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688219615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2IjovWfMHQBGLIRkOdUHEmG1DKd+aohXEA56hUSbGAE=;
        b=Qtq3wU1O9u/aY5uaYtMkBxtLqo+5dZrHsWZrjCg86CRQfYf87/i/+z26o8TC8gAqe4iGwi
        q1xwFvQAtsXLdh80N+HVJe+tQLYFi2B/a84ADwLZUDnIef+jnIGGyuM7Xuy+E0AA/+cxG0
        k53f+KZmIgcewVkDonjseVwWFiHQkXU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-6VYj6dHOMBS9CPB8cSD0YQ-1; Sat, 01 Jul 2023 09:53:34 -0400
X-MC-Unique: 6VYj6dHOMBS9CPB8cSD0YQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-765a23de186so324722085a.3
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 06:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688219613; x=1690811613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2IjovWfMHQBGLIRkOdUHEmG1DKd+aohXEA56hUSbGAE=;
        b=UafuBL48TGl6TRKtplbXxb+CL+PkOzLI0FLhmYN9MUx4xecKlGLt6x1V+9DRK7Zq5/
         IzuOcH3SnoqdjWPPBy4K9AIWyFqO0giFKboVS3ViqIuvCMijS+mHuRlMKqUKE+wI2DXV
         FWrrdS/jBjgpkb+LvMDNXZyfD/7u/C+lRJTEmscSMXjhq3jj5ZJtkeD1riDNDeidUSEv
         7WEmXffPKh+Bq4MuFlNwHEWxEq3DIiJ95mjd6zt0K0RvbdY4OfwAJ06GjWSGrxdNRy3Y
         vwvsmOxcBCO2iJnoGXPBcpkbSKuXNNRXjp+Qsjp1tsEVLkmZK/V/PSUkmxWLsDnGMk17
         j9Vw==
X-Gm-Message-State: AC+VfDwBmnNHhZJ9zn2RMlr4lTagV3fDX1kuM7cS8xPd2s9R7/38psiG
        FaEDndRuSHmxUzT9U2wB657vbdh1y8/OXM0CxQ89I1ZyrzOU8uW7tjqrJJTGsQgAl58sWuW/CZ6
        3Z1ryp/1gpR30VMeeibyCo7SxKz604egOaUev
X-Received: by 2002:a05:620a:3851:b0:767:77e:a3d with SMTP id po17-20020a05620a385100b00767077e0a3dmr4603024qkn.21.1688219613447;
        Sat, 01 Jul 2023 06:53:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Ju9Hdl8J4Ncb3S1Vpkub7sL5ouxn24WN///g1JCutJVKWjxizyixwHj8KeFFUK9tHw6bcJGD57fVmpr0j7+4=
X-Received: by 2002:a05:620a:3851:b0:767:77e:a3d with SMTP id
 po17-20020a05620a385100b00767077e0a3dmr4603016qkn.21.1688219613188; Sat, 01
 Jul 2023 06:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com> <20230627003306.2841058-7-seanjc@google.com>
In-Reply-To: <20230627003306.2841058-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 1 Jul 2023 15:53:21 +0200
Message-ID: <CABgObfZnxeJ4brTJ_aVZ=6i09vy2LA1msXb2Lco2uDOXKDsrAQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.5
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 2:33=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM VMX changes for 6.5.  The highlight is moving away from .invalidate_r=
ange()
> for the APIC-access page, which you've already reviewed.  Everything else=
 is
> minor fixes and cleanups.
>
> The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f3=
3f:
>
>   KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 =
-0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.5
>
> for you to fetch changes up to 0a3869e14d4a5e1016aad6bc6c5b70f82bc0dbbe:
>
>   KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares (20=
23-06-06 15:07:05 -0700)

Pulled all of them, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM VMX changes for 6.5:
>
>  - Fix missing/incorrect #GP checks on ENCLS
>
>  - Use standard mmu_notifier hooks for handling APIC access page
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Jinrong Liang (1):
>       KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA set handl=
er
>
> Jon Kohler (1):
>       KVM: VMX: restore vmx_vmexit alignment
>
> Sean Christopherson (7):
>       KVM: VMX: Treat UMIP as emulated if and only if the host doesn't ha=
ve UMIP
>       KVM: VMX: Use proper accessor to read guest CR4 in handle_desc()
>       KVM: VMX: Inject #GP on ENCLS if vCPU has paging disabled (CR0.PG=
=3D=3D0)
>       KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs are unsupported
>       KVM: VMX: Retry APIC-access page reload if invalidation is in-progr=
ess
>       KVM: x86: Use standard mmu_notifier invalidate hooks for APIC acces=
s page
>       KVM: x86/mmu: Trigger APIC-access page reload iff vendor code cares
>
> Xiaoyao Li (2):
>       KVM: VMX: Use kvm_read_cr4() to get cr4 value
>       KVM: VMX: Move the comment of CR4.MCE handling right above the code
>
>  arch/x86/kvm/mmu/mmu.c          |  4 +++
>  arch/x86/kvm/vmx/capabilities.h |  4 +--
>  arch/x86/kvm/vmx/nested.c       |  3 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  2 --
>  arch/x86/kvm/vmx/sgx.c          | 15 ++++++----
>  arch/x86/kvm/vmx/vmenter.S      |  2 +-
>  arch/x86/kvm/vmx/vmx.c          | 66 ++++++++++++++++++++++++++++++++++-=
------
>  arch/x86/kvm/x86.c              | 14 ---------
>  include/linux/kvm_host.h        |  3 --
>  virt/kvm/kvm_main.c             | 18 -----------
>  10 files changed, 73 insertions(+), 58 deletions(-)
>

