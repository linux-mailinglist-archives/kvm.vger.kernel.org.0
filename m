Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81D775D0D0
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjGURnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 13:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjGURnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 13:43:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C5A3586
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:43:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d064a458dd5so363000276.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 10:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961380; x=1690566180;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DBmD+NWofmGocm5Vnh+WkykM6ONviwwjpnheMJOIK8=;
        b=Kleh8QpsTsNUhesVcFKaorRemH2b7oCPrjs/EZvvDbSIhnU646cwazqZifDUNyxi+Q
         5JqV9CUAW8QaG2YIfQCin1qnHve1MgXICSxbyDPLV8MjQRP2Kpasi9pL5sbB8O7UYjBa
         jgRp3U3UDnkkD6e19TR7wMGjHPVEilwKuPvhlll1BPS6C8DVpWehyFU2WczctGneBM1v
         8h/JnmhFLy8tlfXVq6NzVrFmSK26MkEiOaRidvtVK6eqi9qhd/VP0gDfCAxADqhE52gi
         5Uc2vJ9HkSFyp91F1M5r9W96Us+3KtG0sWvhTTO0jFsQ1GbEx81tOU6Kjmmi3SIi/0Fk
         yy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961380; x=1690566180;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7DBmD+NWofmGocm5Vnh+WkykM6ONviwwjpnheMJOIK8=;
        b=L2OsJ4Rxon7fxaK0wx5kjh/mideOjMsZ7tFPLimdHWe5YrHJMFIdFE6pt9KF2M2j/i
         FdhrSASYJaMVsCkj82SNOgW+CC6eRjxL5W46bGnbRqwOy7m055cH1ITo51v30Wn5szNY
         sY2sVcI2QwGQ9hUuTFCrwheT886da3EV9PCaI/VBxXyLSy7G9/YgLdVHdRnpuQ1PPLRB
         cTPkMM90uLSjHw7JoJxFwJahAd8RWqGLQoFnnlXawJG35vbVIb7CZYW29DGsVJ1sF4M6
         SPpeaPMyHoU2ieR5vSQc/pMLy1qzfIgS8f4xaL0uOG/1ZXrAFYoR9CUK1i98gZRWFGl7
         uX2g==
X-Gm-Message-State: ABy/qLZE2Van7TOJzbGnhVqbF3oTTX3T9EEJIjmZe3rGYXdbulL7Zv1N
        xkGyf8uwtLa3J5pWhaIeceoSTInrqOA=
X-Google-Smtp-Source: APBJJlE/aF1pYHHKoAMy1+E4aY5+aL4FeQDb+p2ML0zhZVvr/Ah+OV80Lx1tRjSoeSb0qOhWhlHbRbztBVY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10cd:b0:c1c:df23:44ee with SMTP id
 w13-20020a05690210cd00b00c1cdf2344eemr19665ybu.0.1689961379855; Fri, 21 Jul
 2023 10:42:59 -0700 (PDT)
Date:   Fri, 21 Jul 2023 10:42:58 -0700
In-Reply-To: <29baac45-7736-a28c-3b2d-2a6e45171b8b@intel.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <fdc155f5-041b-a1b1-15aa-8f970180a13a@intel.com> <29baac45-7736-a28c-3b2d-2a6e45171b8b@intel.com>
Message-ID: <ZLrDopLH+3vN8rE6@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023, Xiaoyao Li wrote:
> On 7/21/2023 11:05 PM, Xiaoyao Li wrote:
> > On 7/19/2023 7:44 AM, Sean Christopherson wrote:
> > > @@ -6255,12 +6298,17 @@ int kvm_init(unsigned vcpu_size, unsigned
> > > vcpu_align, struct module *module)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (r)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_async=
_pf;
> > > +=C2=A0=C2=A0=C2=A0 r =3D kvm_gmem_init();
> > > +=C2=A0=C2=A0=C2=A0 if (r)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_gmem;
> > > +
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_chardev_ops.owner =3D module;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_preempt_ops.sched_in =3D kvm_sched=
_in;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_preempt_ops.sched_out =3D kvm_sche=
d_out;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_init_debug();
> > > +=C2=A0=C2=A0=C2=A0 kvm_gmem_init();
> >=20
> > why kvm_gmem_init() needs to be called again? by mistake?
>=20
> I'm sure it's a mistake.

Yeah, definitely a bug.

> I'm testing the gmem QEMU with this series. SW_PROTECTED_VM gets stuck in=
 a
> loop in early OVMF code due to two shared page of OVMF get zapped and
> re-mapped infinitely. Removing the second call of kvm_gmem_init() can sol=
ve
> the issue, though I'm not sure about the reason.

Not worth investigating unless you want to satiate your curiosity :-)
