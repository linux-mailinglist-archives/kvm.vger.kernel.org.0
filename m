Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802456EFB58
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjDZTug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjDZTue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F4BE65
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SZtaDEST62Fa+Pwd1AmbO1b+l7hEroAcbrU8UJdD1s=;
        b=cEORtbqrgEYNxOP0qfWVrjPM+LIF/V1LjSLuRQYGuNNWvgK+6hEnp/hE02N7BoC/CgWWVR
        qQudWx2N/Y2ijp8ca8PjFbmDq1SS2pbvi6a4eFNWH0foKwbwcVPbhmn2Of4rjxtggGHEOC
        rzqNrL74mGuYG9ZkivC67awbYlfClyk=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-HkylwF-fN_W6_CyPaHg5Cg-1; Wed, 26 Apr 2023 15:49:50 -0400
X-MC-Unique: HkylwF-fN_W6_CyPaHg5Cg-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-42e3b33a37bso1468826137.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538590; x=1685130590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1SZtaDEST62Fa+Pwd1AmbO1b+l7hEroAcbrU8UJdD1s=;
        b=HUoVqOuRgFNKd8qH7tn6I5yTNT0VN1CdOL26XfugyUl+b4ZzkenxQ3V4J81FTLEy14
         P1Y1ncG7qLFLVLTTVQEWBB/pOEfrX84l40zyTEqAT5oY3gzhWS2LZPVF5R89oeM6j++X
         0HCCYOzZLNI2QkEkE+Bm3ya6gMOZ6iP8kl+AsctGQX9PK+77gpndBkqlduQt4+XOvOmN
         lNbvrDGp9wqMmRsZRqECctmQRibABwE4lh41zX2VUNn+UxcSBd+FDzBprl4pBD8xMifW
         z0M6sbXCsX9jcL4wsQivUPReNCXpopGxHQh76c36EK0mexZpc+AIFkelkmb+vYlMwcsi
         Vf0A==
X-Gm-Message-State: AAQBX9dfNBBSvYA4tFX9Lb3yiJSwWwK802UauxGBR53UdSbfv1IyoEIT
        iTXU8hRwi0Ki8xbYFlBn1j/tIVGaveGd5NBQ8nsCpJF1uQCDmvBnBXRVP0aVrWQdy0fn2c1VC86
        8IEI62wLXlXXh3gU5yPFJdNl2ZOvm
X-Received: by 2002:a67:ebcd:0:b0:42e:65bf:3e5e with SMTP id y13-20020a67ebcd000000b0042e65bf3e5emr9232489vso.30.1682538590133;
        Wed, 26 Apr 2023 12:49:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350YBfHvgPHtrHi53jFZKAAWOsb0TK4Q6pAibtYNhL7r5NLXd3/2fu8UixGHvxqw4rBVXMvSzUFT6v3gopgQ6l60=
X-Received: by 2002:a67:ebcd:0:b0:42e:65bf:3e5e with SMTP id
 y13-20020a67ebcd000000b0042e65bf3e5emr9232483vso.30.1682538589851; Wed, 26
 Apr 2023 12:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-2-seanjc@google.com>
In-Reply-To: <20230424173529.2648601-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:49:38 +0200
Message-ID: <CABgObfbxJA27C8dRpa19gOzjGnzBbdzMxASydSXXMP7s+nspPw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.4.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> KVM x86 "misc" changes for 6.4.  The two highlights are Mathias'
> optimization for CR0.WP toggling and Binbin's addition of helpers to quer=
y
> individual CR0/CR4 bits (a very nice and overdue cleanup).
>
> The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6=
e7:
>
>   KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:=
18:07 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.4
>
> for you to fetch changes up to cf9f4c0eb1699d306e348b1fd0225af7b2c282d3:
>
>   KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission =
faults (2023-04-10 15:25:36 -0700)

Pulled (but didn't push yet), thanks.

Paolo


> ----------------------------------------------------------------
> KVM x86 changes for 6.4:
>
>  - Optimize CR0.WP toggling by avoiding an MMU reload when TDP is enabled=
,
>    and by giving the guest control of CR0.WP when EPT is enabled on VMX
>    (VMX-only because SVM doesn't support per-bit controls)
>
>  - Add CR0/CR4 helpers to query single bits, and clean up related code
>    where KVM was interpreting kvm_read_cr4_bits()'s "unsigned long" retur=
n
>    as a bool
>
>  - Move AMD_PSFD to cpufeatures.h and purge KVM's definition
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Binbin Wu (4):
>       KVM: x86: Add helpers to query individual CR0/CR4 bits
>       KVM: x86: Use boolean return value for is_{pae,pse,paging}()
>       KVM: SVM: Use kvm_is_cr4_bit_set() to query SMAP/SMEP in "can emula=
te"
>       KVM: x86: Change return type of is_long_mode() to bool
>
> Mathias Krause (4):
>       KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TD=
P enabled
>       KVM: x86: Ignore CR0.WP toggles in non-paging mode
>       KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
>       KVM: VMX: Make CR0.WP a guest owned bit
>
> Robert Hoo (1):
>       KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()
>
> Sean Christopherson (4):
>       KVM: SVM: Fix benign "bool vs. int" comparison in svm_set_cr0()
>       x86: KVM: Add common feature flag for AMD's PSFD
>       KVM: x86: Assert that the emulator doesn't load CS with garbage in =
!RM
>       KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permiss=
ion faults
>
> Tom Rix (1):
>       KVM: x86: set "mitigate_smt_rsb" storage-class-specifier to static
>
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/kvm/cpuid.c               | 12 +++-------
>  arch/x86/kvm/emulate.c             |  8 +++++++
>  arch/x86/kvm/kvm_cache_regs.h      | 18 ++++++++++++++-
>  arch/x86/kvm/mmu.h                 | 28 ++++++++++++++++++++++--
>  arch/x86/kvm/mmu/mmu.c             | 15 +++++++++++++
>  arch/x86/kvm/pmu.c                 |  4 ++--
>  arch/x86/kvm/svm/svm.c             |  6 ++---
>  arch/x86/kvm/vmx/nested.c          |  6 ++---
>  arch/x86/kvm/vmx/vmx.c             |  8 +++----
>  arch/x86/kvm/vmx/vmx.h             | 18 +++++++++++++++
>  arch/x86/kvm/x86.c                 | 45 ++++++++++++++++++++++++--------=
------
>  arch/x86/kvm/x86.h                 | 22 +++++++++----------
>  13 files changed, 139 insertions(+), 52 deletions(-)
>

