Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F036E162C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 22:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjDMU6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 16:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjDMU6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 16:58:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB9C8697
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:58:34 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-63779b48340so1214096b3a.3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 13:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681419513; x=1684011513;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nEv2HVs1S+Egpav/jnzfzsQjcllfLnLuCFh+OUzwj8A=;
        b=N/NxeDGiy0A3sp3zsLS3ONiWVymFkZsvGZW/ifZ+0iNpy4Cnu0yvtFO/vEmGTqLWiH
         KXoYXslYuFxGsyEH33NwF0ERBM0GsmdjykR3Dc67bRTjpbFQ6HEMvFLZiBlBl5vRR2up
         +3M0y1sLKYIO3HqKiayhyGXRcqPTcmkSVYAJBXoefUccwC7wXAkJ7K/acVdWDJF/zSZE
         Ws36H1mGkrL56HIgJFH9kyVJunsDFoGM4WLNHVehJERDrCAYFDw4/1tidyOx0ddiMGCT
         1M62BnNL7CUWlD6K+tKPpRpxO8IEQ/EADHzLI4PjUt2cbDJunv4i411h+dc9f9uqIlsy
         KO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681419513; x=1684011513;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nEv2HVs1S+Egpav/jnzfzsQjcllfLnLuCFh+OUzwj8A=;
        b=RN+A/ysu0jBwKjLFcMmU1357WcrdpBnvfHT0XhmUtosgzfh541TAWXg7cOTtu7d3Q0
         V+1j9+pL3tZcesBYd3Qxvv0/ruskEg6Kmd6KL5sKfXSHrMVd7uUAMyM3Nj2AuRahpFoj
         75cpEljTWqROmFpnWPxMc7bS+x7IMMv0gVMuKJ1js/+f+K2rs5MZypw8k4g1Uy6GbaqD
         XJAcGEGKwbc7LCMCDEJl5TNANX928NOyPlP78V9+UZD1PMl+ABg5E824eYmlPiKcEsva
         8Kkh71urRbLHkYgcnxTGLZrvu2Sy95xqaDyD7L/rRsKzNOILnmcK7XPG4m+gbTpuG0gw
         cpHg==
X-Gm-Message-State: AAQBX9cQTyFtLb8ukm+Vpgjxau1lERbsK6AuhsQh6kHiVaUHP+x+V2sT
        Q0SVuL7rtjr2Qq/E0ceuqAlQxqYvxUo=
X-Google-Smtp-Source: AKy350bSXma0H87PRt68CUCJhjZ6Fcq2Rn85m8fx/BXyeVGSzmlgqoQTUIRypWDhyXYiGsOUwAoC45uhcEQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d25:b0:62e:1972:fab5 with SMTP id
 fa37-20020a056a002d2500b0062e1972fab5mr1835355pfb.4.1681419513538; Thu, 13
 Apr 2023 13:58:33 -0700 (PDT)
Date:   Thu, 13 Apr 2023 13:58:32 -0700
In-Reply-To: <CALzav=dv2MhoZ1BLqJWmmJv=H6vRaRUEcAJPydjrzJf1wdYEOA@mail.gmail.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com> <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
 <ZDWEgXM/UILjPGiG@google.com> <61d131da-7239-6aae-753f-2eb4f1b84c24@linux.microsoft.com>
 <ZDg6w+1v4e/uRDfF@google.com> <ZDhTeIXRdcXDaD54@google.com> <CALzav=dv2MhoZ1BLqJWmmJv=H6vRaRUEcAJPydjrzJf1wdYEOA@mail.gmail.com>
Message-ID: <ZDhs+AnytF030DYe@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, David Matlack wrote:
> On Thu, Apr 13, 2023 at 12:10=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Apr 13, 2023, Sean Christopherson wrote:
> > > Aha!  Idea.  There are _at most_ 4 possible roots the TDP MMU can enc=
ounter.
> > > 4-level non-SMM, 4-level SMM, 5-level non-SMM, and 5-level SMM.  I.e.=
 not keeping
> > > inactive roots on a per-VM basis is just monumentally stupid.
> >
> > One correction: there are 6 possible roots:
> >
> >   1. 4-level !SMM !guest_mode (i.e. not nested)
> >   2. 4-level SMM !guest_mode
> >   3. 5-level !SMM !guest_mode
> >   4. 5-level SMM !guest_mode
> >   5. 4-level !SMM guest_mode
> >   6. 5-level !SMM guest_mode
> >
> > I forgot that KVM still uses the TDP MMU when running L2 if L1 doesn't =
enable
> > EPT/TDP, i.e. if L1 is using shadow paging for L2.  But that really doe=
sn't change
> > anything as each vCPU can already track 4 roots, i.e. userspace can sat=
urate all
> > 6 roots anyways.  And in practice, no sane VMM will create a VM with bo=
th 4-level
> > and 5-level roots (KVM keys off of guest.MAXPHYADDR for the TDP root le=
vel).
>=20
> Why do we create a new root for guest_mode=3D1 if L1 disables EPT/NPT?

Because "private", a.k.a. KVM-internal, memslots are visible to L1 but not =
L2.
Which for TDP means the APIC-access page.  From commit 3a2936dedd20:

    kvm: mmu: Don't expose private memslots to L2
   =20
    These private pages have special purposes in the virtualization of L1,
    but not in the virtualization of L2. In particular, L1's APIC access
    page should never be entered into L2's page tables, because this
    causes a great deal of confusion when the APIC virtualization hardware
    is being used to accelerate L2's accesses to its own APIC.

FWIW, I _think_ KVM could actually let L2 access the APIC-access page when =
L1 is
running without any APIC virtualization, i.e. when L1 is passing its APIC t=
hrough
to L2.  E.g. something like the below, but I ain't touching that with a 10 =
foot pole
unless someone explicitly asks for it :-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 039fb16560a0..8aa12f5f2c30 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4370,10 +4370,13 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,=
 struct kvm_page_fault *fault
        if (!kvm_is_visible_memslot(slot)) {
                /* Don't expose private memslots to L2. */
                if (is_guest_mode(vcpu)) {
-                       fault->slot =3D NULL;
-                       fault->pfn =3D KVM_PFN_NOSLOT;
-                       fault->map_writable =3D false;
-                       return RET_PF_CONTINUE;
+                       if (!slot || slot->id !=3D APIC_ACCESS_PAGE_PRIVATE=
_MEMSLOT ||
+                           nested_cpu_has_virtual_apic(vcpu)) {
+                               fault->slot =3D NULL;
+                               fault->pfn =3D KVM_PFN_NOSLOT;
+                               fault->map_writable =3D false;
+                               return RET_PF_CONTINUE;
+                           }
                }
                /*
                 * If the APIC access page exists but is disabled, go direc=
tly




