Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4E7C8D41
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 20:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjJMSpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 14:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjJMSps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 14:45:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66190BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 11:45:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9f973d319so8987085ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 11:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697222741; x=1697827541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ws3TNljM7U6dR7W0bGuw6beKuVMmLn0pBMtIeO28SXE=;
        b=o/bmnhgAKzOwSltr+28ZopWmB0QBT+J5gtJUMwEDsyOHk0X6Xwyxr2cqlPjfvKsoyq
         zyvtbTb0tFoJBlhwtvAc3FJB0JsSvBBXai2OULXINY3+hVJC7ZcgnKOd61LrCh+/PS0A
         eJhM2QgiHM6MV/9+4qVjKOe3FfLF/XwAY+3tXnSamXG/rq9mVxiUT9CpxO9tNCcbefrY
         HipJKAq8wwIEOTb412oezeMePzpxEnSOEzM4gDfBZwoXl6LlXLanGLgWlBE2e97x4T7p
         eTmosgEcVnUXTYI9Itnn+oeAEGuYC/AR0TKUqof4uH7mz+UJ5CBaJ5wWsjtyH70LAZCx
         a4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697222741; x=1697827541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ws3TNljM7U6dR7W0bGuw6beKuVMmLn0pBMtIeO28SXE=;
        b=uyyVpqHIiFYh9yPzHTkzaznaAh6syhyOig+hjjH0aPFfU7dof/JEvTOy5l9q+9ntAS
         jBBxOS6F0jGhbHxA16YfBJDcxr7l6/eq6CwzXes0JE/PmyNBuTYGgmmNa2kPvoe1YSj+
         mF52nz5L8GSLRWeXq7uuqD50DZqMi8gkcBx0MFxMMGPTPbG3UWGj2dt2aCNjzVVu7Lt+
         s2MKtOirsF8ofzgN6VSoI5CEFYja2AtRjB+ZssBd9ADBAAtAkvx+mj43XdmP8kaK0bPy
         3TXdEfiQJkOqlPbW1dNOPR2JyK47uua43ycz1a263MsbAetKsdqBv2d+NpYtC+ZTlfWE
         R4zg==
X-Gm-Message-State: AOJu0YzUT6xa+XTtW/8+UPp2srAOKfMeGF6TrBGIxqx9iDfVzbW77BTH
        IDPPpoCSZH+Xc3pvVMP7Sy8y5mgIe0E=
X-Google-Smtp-Source: AGHT+IEhWzwxolK4HR2lnXpvlQbepCLBD9azTuRK2bP2lLobqQAr8ceBilk59vUTCOnRGf8PBQ2ioDqI7+4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab1d:b0:1ca:2620:78ad with SMTP id
 ik29-20020a170902ab1d00b001ca262078admr3280plb.8.1697222740713; Fri, 13 Oct
 2023 11:45:40 -0700 (PDT)
Date:   Fri, 13 Oct 2023 11:45:39 -0700
In-Reply-To: <CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230914015531.1419405-8-seanjc@google.com> <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com>
 <ZQ3AmLO2SYv3DszH@google.com> <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com> <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
 <ZR88w9W62qsZDro-@google.com> <CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com>
Message-ID: <ZSmQUyfldIMMpx7X@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023, David Matlack wrote:
> On Thu, Oct 5, 2023 at 3:46=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Oct 05, 2023, Anish Moorthy wrote:
> > > On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspac=
e could be
> > > > "unreliable" is if something other than a memory_fault exit clobber=
ed the union,
> > > > but didn't signal its KVM_EXIT_* reason.  And that would be an egre=
gious bug that
> > > > isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruptio=
n would affect
> > > > each and every other KVM_EXIT_* reason.
> > >
> > > Keep in mind the case where an "unreliable" annotation sets up a
> > > KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
> > > unrelated comes up and causes KVM_RUN to EFAULT. Although this at
> > > least is a case of "outdated" information rather than blatant
> > > corruption.
> >
> > Drat, I managed to forget about that.
> >
> > > IIRC the last time this came up we said that there's minimal harm in
> > > userspace acting on the outdated info, but it seems like another good
> > > argument for just restricting the annotations to paths we know are
> > > reliable. What if the second EFAULT above is fatal (as I understand
> > > all are today) and sets up subsequent KVM_RUNs to crash and burn
> > > somehow? Seems like that'd be a safety issue.
> >
> > For your series, let's omit
> >
> >   KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page
> >
> > and just fill memory_fault for the page fault paths.  That will be easi=
er to
> > document too since we can simply say that if the exit reason is KVM_EXI=
T_MEMORY_FAULT,
> > then run->memory_fault is valid and fresh.
>=20
> +1
>=20
> And from a performance perspective, I don't think we care about
> kvm_vcpu_read/write_guest_page(). Our (Google) KVM Demand Paging
> implementation just sends any kvm_vcpu_read/write_guest_page()
> requests through the netlink socket, which is just a poor man's
> userfaultfd. So I think we'll be fine sending these callsites through
> uffd instead of exiting out to userspace.
>=20
> And with that out of the way, is there any reason to keep tying
> KVM_EXIT_MEMORY_FAULT to -EFAULT? As mentioned in the patch at the top
> of this thread, -EFAULT is just a hack to allow the emulator paths to
> return out to userspace. But that's no longer necessary.

Not forcing '0' makes handling other error codes simpler, e.g. if the memor=
y is
poisoned, KVM can simply return -EHWPOISON instead of having to add a flag =
to
run->memory_fault[*].

KVM would also have to make returning '0' instead of -EFAULT conditional ba=
sed on
a capability being enabled.

And again, committing to returning '0' will make it all but impossible to e=
xtend
KVM_EXIT_MEMORY_FAULT beyond the page fault handlers.  Well, I suppose we c=
ould
have the top level kvm_arch_vcpu_ioctl_run() do

	if (r =3D=3D -EFAULT && vcpu->kvm->enable_memory_fault_exits &&
	    kvm_run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAULT)
		r =3D 0;

but that's quite gross IMO.

> I just find it odd that some KVM_EXIT_* correspond with KVM_RUN returning=
 an
> error and others don't.

FWIW, there is already precedent for run->exit_reason being valid with a no=
n-zero
error code.  E.g. KVM selftests relies on run->exit_reason being preserved =
when
forcing an immediate exit, which returns -EINTR, not '0'.

	if (kvm_run->immediate_exit) {
		r =3D -EINTR;
		goto out;
	}

And pre-immediate_exit code that relies on signalling vCPUs is even more ex=
plicit
in setting exit_reason with a non-zero errno:

		if (signal_pending(current)) {
			r =3D -EINTR;
			kvm_run->exit_reason =3D KVM_EXIT_INTR;
			++vcpu->stat.signal_exits;
		}

I agree that -EFAULT with KVM_EXIT_MEMORY_FAULT *looks* a little odd, but I=
MO the
existing KVM behavior of returning '0' is actually what's truly odd.  E.g. =
returning
'0' + KVM_EXIT_MMIO if the guest accesses non-existent memory is downright =
weird.
KVM_RUN should arguably never return '0', because it can never actual compl=
etely
succeed.

> The exit_reason is sufficient to tell userspace what's going on and has a
> firm contract, unlike -EFAULT which anything KVM calls into can return.

Eh, I don't think it lessens the contract in a meaningful way.  KVM is stil=
l
contractually obligated to fill run->exit_reason when KVM returns '0', and
userspace will still likely terminate the VM on an undocumented EFAULT/EHWP=
OISON.

E.g. if KVM has a bug and doesn't return KVM_EXIT_MEMORY_FAULT when handlin=
g a
page fault, then odds are very good that the bug would result in KVM return=
ing a
"bare" -EFAULT regardless of whether KVM_EXIT_MEMORY_FAULT is paried with '=
0' or
-EFAULT.

[*] https://lore.kernel.org/all/ZQHzVOIsesTTysgf@google.com
