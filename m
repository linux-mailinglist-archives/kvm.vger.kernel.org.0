Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82F37C4569
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 01:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343880AbjJJXZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 19:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJJXZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 19:25:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332FC93
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:25:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81841ef79bso8341490276.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 16:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696980323; x=1697585123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HeGC4OWi2B3xSDk7pV51YuG5udGOz19uDxJz6CzCPa0=;
        b=HHkiFuz5sArgxOoWMSfvTpjqbTYUeUPrYJU0BxVY7sVaqHAKFqeYITgOw56yegv6ZF
         6QAZEbYSJ7A8WlG04JoCIIRbJztwQrHMdSsbmbMyXXJYA99muBXo2P43rZwhUEBNifij
         QCAXDRK/uZAdox4u4nDWgbDJfzmcP2yc40Lrr2dKwhwsuhcEni9YWvSq87xw4X8s+PLk
         T+BN2VR7mlWbVRoooSRfkwvoCROC6lrfWqpp4LJjdZl78368sWOdGxC1uHTv1dWmBMtp
         F5WREj2gYIWtjiZMFf6SZc6Xkqjjum68GpXARhFwKDI25TMSL0nRyK3lrH6XmMfUzwgk
         /KAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696980323; x=1697585123;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HeGC4OWi2B3xSDk7pV51YuG5udGOz19uDxJz6CzCPa0=;
        b=jaaHO9r/nXNojrEBnErVTk8xe65ISDVgzkNuRQMi6G8K1aTYBsm27bOFR1pBvebrSp
         DPhJZWDhgTq/eCmy2sjncpoRjjb4/gWxG4opsUqNRs56EwiJ089nOe+R6ZdkJ5nxR5xN
         8numLf0axljj6zDgWkEtIa01nXK8Hs/lgGHb3bS26TZYnZHOFHuTA5YK7yGyOeKDcnLf
         4sLS76cFrIwmOeOwSEST/b4trhCioskPuZjxDEPyBMAGadIJkftHY0cduGWEMq2IO8yA
         wHUmHMrG0bxrbWcjF6dxufviNsCw5JllEXwxndbq3oFqgSXt8k9s+1r3aEWi0i8Nh9J3
         54sg==
X-Gm-Message-State: AOJu0YzsrNdVt0v/qjdFAGm3uFHo/Jk1WFL0uOZahDrqrNGuC54o5MyC
        1gRSW+cH6LJ57FS4MayuA2AKVhMJcVo=
X-Google-Smtp-Source: AGHT+IFYK+fVYk0vKEeqnqujH5y5GdofbPc89vfeRAgaf9j9ypROwHgATzsZavXiX3HLZETwsmKyq2+QAZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1603:b0:d7a:bfcf:2d7 with SMTP id
 bw3-20020a056902160300b00d7abfcf02d7mr324738ybb.6.1696980323379; Tue, 10 Oct
 2023 16:25:23 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:25:21 -0700
In-Reply-To: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
Mime-Version: 1.0
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
Message-ID: <ZSXdYcMUds-DrHAd@google.com>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Bartosz Szczepanek <bsz@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, David Woodhouse wrote:
> If I understand things correctly, the point of the TDP MMU is to use
> page tables such as EPT for GPA =E2=86=92 HPA translations, but let the
> virtualization support in the CPU handle all of the *virtual*
> addressing and page tables, including the non-root mode %cr3/%cr4.
>=20
> I have a guest which loves to flip the SMEP bit on and off in %cr4 all
> the time. The guest is actually Xen, in its 'PV shim' mode which
> enables it to support a single PV guest, while running in a true
> hardware virtual machine:
> https://lists.xenproject.org/archives/html/xen-devel/2018-01/msg00497.htm=
l
>=20
> The performance is *awful*, since as far as I can tell, on every flip
> KVM flushes the entire EPT. I understand why that might be necessary
> for the mode where KVM is building up a set of shadow page tables to
> directly map GVA =E2=86=92 HPA and be loaded into %cr3 of a CPU that does=
n't
> support native EPT translations. But I don't understand why the TDP MMU
> would need to do it. Surely we don't have to change anything in the EPT
> just because the stuff in the non-root-mode %cr3/%cr4 changes?
>=20
> So I tried this, and it went faster and nothing appears to have blown
> up.
>=20
> Am I missing something? Is this stupidly wrong?

Heh, you're in luck, because regardless of what your darn pronoun "this" re=
fers
to, the answer is yes, "this" is stupidly wrong.

The below is stupidly wrong.  KVM needs to at least reconfigure the guest's=
 paging
metadata that is used to translate GVAs to GPAs during emulation.

But the TDP MMU behavior *was* also stupidly wrong.  The reason that two vC=
PUs
suck less is because KVM would zap SPTEs (EPT roots) if and only if *both* =
vCPUs
unloaded their roots at the same time.

Commit edbdb43fc96b ("KVM: x86: Preserve TDP MMU roots until they are expli=
citly
invalidated") should fix the behavior you're seeing.

And if we want to try and make SMEP blazing fast on Intel, we can probably =
let
the guest write it directly, i.e. give SMEP the same treatment as CR0.WP.  =
See
commits cf9f4c0eb169 ("KVM: x86/mmu: Refresh CR0.WP prior to checking for e=
mulated
permission faults") and fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned =
bit").

Oh, and if your userspace is doing something silly like constantly creating=
 and
deleting memslots, see commit 0df9dab891ff ("KVM: x86/mmu: Stop zapping inv=
alidated
TDP MMU roots asynchronously").

> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1072,7 +1074,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned
> long cr4)
>         if (kvm_x86_ops.set_cr4(vcpu, cr4))
>                 return 1;
> =20
> -       kvm_post_set_cr4(vcpu, old_cr4, cr4);
> +       if (!vcpu->kvm->arch.tdp_mmu_enabled)
> +               kvm_post_set_cr4(vcpu, old_cr4, cr4);
> =20
>         if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
>                 kvm_update_cpuid_runtime(vcpu);
>=20
>=20
> Also... if I have *two* vCPUs it doesn't go quite as slowly while Xen
> starts Grub and then Grub boots a Linux kernel. Until the kernel brings
> up its second vCPU and *then* it starts going really slowly again. Is
> that because the TDP roots are refcounted, and that idle vCPU holds
> onto the unused one and prevents it from being completely thrown away?
> Until the vCPU stops being idle and starts flipping SMEP on/off on
> Linux=E2=86=90=E2=86=92Xen transitions too?
>=20
> In practice, there's not a lot of point in Xen using SMEP when it's
> purely acting as a library for its *one* guest, living in an HVM
> container. The above patch speeds things up but telling Xen not to use
> SMEP at all makes things go *much* faster. But if I'm not being
> *entirely* stupid, there may be some generic improvements for
> KVM+TDPMMU here somewhere so it's worth making a fool of myself by
> asking...?
