Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC77B5EC5
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 03:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbjJCBnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 21:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbjJCBnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 21:43:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3DEC4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 18:42:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d848694462aso554080276.3
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 18:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696297379; x=1696902179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fD3Xa8/vhFMIhH4RbdgiQUOLcrn+ryvbOzbRIeJeNfY=;
        b=tQdRESmWduGQE85CErokYGNSLnnvkK7SUGyEwjQtRp54HoX/3g7LVF1Gnark88iakh
         xfZnouYSHhuAJEOdcyXuZNmtYRf9+LMAyg8AgKtOfRm7IEUJxj/3+PwsltQ/EDATq8kt
         RDYyhoDf0OqANdJX/677jJtUCxRQdWoRg02d7KmxQNPvrCxFCC5hzdUTQ4h1ZlDr77FL
         zP4+ON796Ds9ldkKE/dG9ZjCMsplI4WqpIBSY5Kit3suZI/t/4MlJb/o00PiYk8AjKaX
         KvFmP6Zs2onmEkyWygkxlTbIy13kkFPHYjUB3R9OQBGhLAuyKtewm4loq+lRCxTWWEDR
         2UvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696297379; x=1696902179;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fD3Xa8/vhFMIhH4RbdgiQUOLcrn+ryvbOzbRIeJeNfY=;
        b=jhwNCk7xCMNDrLCS6rUaxlOlJhMn0+wQgPE/wWnFjgt7jUUM/G8xdVne3EyPuldT3x
         BkVNuNlsJVTHkbaG1p3Y3mgnvU2OnmV0/xE/h7qBiwrPfWc5dHCD3ViKcWs2Zo9unoDa
         uUxpzmxabuBW0lHwJLNgJkMgFryMcpQcqRy6ex9P8BTx2ZwyHtNlTvmOHTCoZOvdBV5F
         XJaI4AV+eyO21F2uOX1eP3VwC9mXGTaj6NViyazga/9Qs9mScxvl8aM4KnhC+EJ7mfeD
         RtC60ogG7lcTGTdlSjyxXtIJ9fIZl+IhV3gq7coth9VnbFozCj0442oFzG/IKCfEnWGo
         7w6A==
X-Gm-Message-State: AOJu0Yz0XBimJLMKsIWYVuN37QeGjq7Q6i5QYpigma91nHcvSB3d4YzY
        g+jM6DEuwaIqLpEzduuoIK58ss4s+Kw=
X-Google-Smtp-Source: AGHT+IHBWTaJik82WBgvMqCFwbjJHa4GFzJZkgqGHbEG/l2KauJ16tH+FN+XncRJjiRf+QJz8JKbMW9q5as=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:136b:b0:d81:4107:7a1 with SMTP id
 bt11-20020a056902136b00b00d81410707a1mr209690ybb.2.1696297378712; Mon, 02 Oct
 2023 18:42:58 -0700 (PDT)
Date:   Mon, 2 Oct 2023 18:42:57 -0700
In-Reply-To: <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
Message-ID: <ZRtxoaJdVF1C2Mvy@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Anish Moorthy wrote:
> On Fri, Sep 22, 2023 at 9:28=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > > So when exit reason is KVM_EXIT_MEMORY_FAULT, how can we tell which f=
ield in
> > > the first union is valid?
> >
> > /facepalm
> >
> > At one point, I believe we had discussed a second exit reason field?  B=
ut yeah,
> > as is, there's no way for userspace to glean anything useful from the f=
irst union.
>=20
> Oh, was this an objective? When I was pushing for the second union
> this I was just trying to make sure all the efault annotations
> wouldn't clobber *other* exits. But yeah, I don't/didn't see a
> meaningful way to have valid information in both structs.

Clobbering other exits means KVM is already broken, because simply accessin=
g memory
in guest context after initiating an exit is a KVM bug as it would violate =
ordering
and maybe causality.   E.g. the only reason the preemption case (see below)=
 isn't
completely buggy is specifically because it's host paravirt behavior.

In other words, ignoring preemption for the moment, not clobbering other ex=
its isn't
useful because whatever buggy KVM behavior caused the clobbering already ha=
ppened,
i.e. the VM is already in trouble either way.  The only realistic options a=
re to fix
the KVM bugs, or to effectively take an errata and say "don't do that" (lik=
e we've
done for the silly PUSHD to MMIO case).

> > The more I think about this, the more I think it's a fool's errand.  Ev=
en if KVM
> > provides the exit_reason history, userspace can't act on the previous, =
unfulfilled
> > exit without *knowing* that it's safe/correct to process the previous e=
xit.  I
> > don't see how that's remotely possible.
> >
> > Practically speaking, there is one known instance of this in KVM, and i=
t's a
> > rather riduclous edge case that has existed "forever".  I'm very strong=
ly inclined
> > to do nothing special, and simply treat clobbering an exit that userspa=
ce actually
> > cares about like any other KVM bug.
> >
> > > When exit reason is not KVM_EXIT_MEMORY_FAULT, how can we know the in=
fo in
> > > the second union run.memory is valid without a run.memory.valid field=
?
> >
> > Anish's series adds a flag in kvm_run.flags to track whether or not mem=
ory_fault
> > has been filled.  The idea is that KVM would clear the flag early in KV=
M_RUN, and
> > then set the flag when memory_fault is first filled.
> >
> >         /* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
> >         #define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
> >
> > I didn't propose that flag here because clobbering memory_fault from th=
e page
> > fault path would be a flagrant KVM bug.
> >
> > Honestly, I'm becoming more and more skeptical that separating memory_f=
ault is
> > worthwhile, or even desirable.  Similar to memory_fault clobbering some=
thing else,
> > userspace can only take action if memory_fault is clobbered if userspac=
e somehow
> > knows that it's safe/correct to do so.
> >
> > Even if KVM exits "immediately" after initially filling memory_fault, t=
he fact
> > that KVM is exiting for a different reason (or a different memory fault=
) means
> > that KVM did *something* between filling memory_fault and actually exit=
ing.  And
> > it's completely impossible for usersepace to know what that "something"=
 was.
>=20
> Are you describing a scenario in which memory_fault is (initially)
> filled, then something else happens to fill memory_fault (thus
> clobbering it), then KVM_RUN exits? I'm confused by the tension
> between the "KVM exits 'immediately'" and "KVM did *something* between
> filling memory_fault and actually existing" statements here.

Yes, I'm describing a hypothetical scenario.  Immediately was in quotes bec=
ause
even if KVM returns from the *current* function straightaway, it's possible=
 that
control is deep in a call stack, i.e. KVM may "immediately" try to exit fro=
m the
current function's perspective, but in reality it may take a while to actua=
lly
get out to userspace.

> > > E.g. in the splat from selftests[1], KVM reacts to a failure during R=
eal Mode
> > event injection by synthesizing a triple fault
> >
> >         ret =3D emulate_int_real(ctxt, irq);
> >
> >         if (ret !=3D X86EMUL_CONTINUE) {
> >                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> >
> > There are multiple KVM bugs at play: read_emulate() and write_emulate()=
 incorrectly
> > assume *all* failures should be treated like MMIO, and conversely ->rea=
d_std() and
> > ->write_std() don't handle *any* failures as MMIO.
> >
> > Circling back to my "capturing the history is pointless" assertion, by =
the time
> > userspace gets an exit, the vCPU is already in shutdown, and KVM has cl=
obbered
> > memory_fault something like five times.  There is zero chance userspace=
 can do
> > anything but shed a tear for the VM and move on.
> >
> > The whole "let's annotate all memory faults" idea came from my desire t=
o push KVM
> > towards a future where all -EFAULT exits are annotated[2].  I still thi=
nk we should
> > point KVM in that general direction, i.e. implement something that _can=
_ provide
> > 100% "coverage" in the future, even though we don't expect to get there=
 anytime soon.
> >
> > I bring that up because neither private memory nor userfault-on-missing=
 needs to
> > annotate anything other than -EFAULT during guest page faults.  I.e. al=
l of this
> > paranoia about clobbering memory_fault isn't actually buying us anythin=
g other
> > than noise and complexity.  The cases we need to work _today_ are perfe=
ctly fine,
> > and _if_ some future use cases needs all/more paths to be 100% accurate=
, then the
> > right thing to do is to make whatever changes are necessary for KVM to =
be 100%
> > accurate.
> >
> > In other words, trying to gracefully handle memory_fault clobbering is =
pointless.
> > KVM either needs to guarantee there's no clobbering (guest page fault p=
aths) or
> > treat the annotation as best effort and informational-only (everything =
else at
> > this time).  Future features may grow the set of paths that needs stron=
g guarantees,
> > but that just means fixing more paths and treating any violation of the=
 contract
> > like any other KVM bug.
>=20
> Ok, so if we're restricting the exit to just the places it's totally
> accurate (page-fault paths) then, IIUC,
>=20
> - There's no reason to attach it to EFAULT, ie it becomes a "normal" exit

No, I still want at least partial line of sight to being able to provide us=
eful
information to userspace on EFAULT.  Making KVM_EXIT_MEMORY_FAULT a "normal=
" exit
pretty much squashes any hope of that.

> - I should go drop the patches annotating kvm_vcpu_read/write_page
> from my series

Hold up on that.  I'd prefer to keep them as there's still value in giving =
userspace
debug information.  All I'm proposing is that we would firmly state in the
documentation that those paths must be treated as informational-only.

The whole kvm_steal_time_set_preempted() mess does give me pause though.  T=
hat
helper isn't actually problematic, but only because it uses copy_to_user_no=
fault()
directly :-/

But that doesn't necessarily mean we need to abandon the entire idea, e.g. =
it
might not be a terrible idea to explicitly differentiate accesses to guest =
memory
for paravirt stuff, from accesses to guest memory on behalf of the guest.

Anyways, don't do anything just yet.

> - The helper function [a] for filling the memory_fault field
> (downgraded back into the current union) can drop the "has the field
> already been filled?" check/WARN.

That would need to be dropped regardless because it's user-triggered (sadly=
).

> - [KVM_CAP_USERFAULT_ON_MISSING] The memslot flag check [b] needs to
> be moved back from __gfn_to_pfn_memslot() into
> user_mem_abort()/kvm_handle_error_pfn() since the slot flag-triggered
> fast-gup failures *have* to result in the memory fault exits, and we
> only want to do those in the two SLAT-failure paths (for now).

I'll look at this more closely when I review your series (slowly, slowly ge=
tting
there).  There's no right or wrong answer here, it's more a question of wha=
t's the
easiest to maintain.

> [a] https://lore.kernel.org/all/20230908222905.1321305-5-amoorthy@google.=
com/
> [b] https://lore.kernel.org/all/20230908222905.1321305-11-amoorthy@google=
.com/
>=20
> > And if we stop being unnecessarily paranoid, KVM_RUN_MEMORY_FAULT_FILLE=
D can also
> > go away.  The flag came about in part because *unconditionally* sanitiz=
ing
> > kvm_run.exit_reason at the start of KVM_RUN would break KVM's ABI, as u=
serspace
> > may rely on the exit_reason being preserved when calling back into KVM =
to complete
> > userspace I/O (or MMIO)[3].  But the goal is purely to avoid exiting wi=
th stale
> > memory_fault information, not to sanitize every other existing exit_rea=
son, and
> > that can be achieved by simply making the reset conditional.
> >
> > ...
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 96fc609459e3..d78e97b527e5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4450,6 +4450,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >                                 synchronize_rcu();
> >                         put_pid(oldpid);
> >                 }
> > +
> > +               /*
> > +                * Reset the exit reason if the previous userspace exit=
 was due
> > +                * to a memory fault.  Not all -EFAULT exits are annota=
ted, and
> > +                * so leaving exit_reason set to KVM_EXIT_MEMORY_FAULT =
could
> > +                * result in feeding userspace stale information.
> > +                */
> > +               if (vcpu->run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAULT=
)
> > +                       vcpu->run->exit_reason =3D KVM_EXIT_UNKNOWN
> > +
> >                 r =3D kvm_arch_vcpu_ioctl_run(vcpu);
>=20
> Under my reading of the earlier block I'm not sure why we need to keep
> this around. The original idea behind a canary of this type was to
> avoid stomping on non-memory-fault exits in cases where something
> caused an (ignored) annotated memory fault before the exit could be
> completed. But if the annotations are going to be restricted in
> general to just the page fault paths, then we can just eliminate the
> sentinel check (and just this block) entirely, right?

This isn't a canary, it's to ensure KVM doesn't feed userspace garbage.  As=
 above,
I'm not saying we throw away all of the code for the "optional" paths, I'm =
saying
that we only commit to 100% accuracy for the paths that the two use cases n=
eed to
work, i.e. the page fault handlers.
