Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7B7B5D2F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 00:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbjJBWed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 18:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjJBWec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 18:34:32 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4420893
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 15:34:29 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-49970221662so137077e0c.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 15:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696286068; x=1696890868; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0D+gsuQdOwcWnbWTeVpJ3kkjsJtSvYb638sfQAfzu6A=;
        b=YJtdg5BTPz1jdaBmWqMb65JAOzGIPSaAGlQ8l4KK+d4G/0g7LEzs7MDVBaXg5UsBt4
         LepwxzkUGbMNdk2hg9+iFQmS9rg4bZKeOBRmyoaDKM7jNF6EeVSZ8XBP/CZY6RSx0b04
         IWg0a8jtbZULOMBjEeN+SIijMcy5vTBUev16axHCUQVawLHlO/GdEWNFCrVv7ZgROJz6
         oSxFVIQ8fJBc7cuOp2Z7qD5WccnEIwJoe0n5jE2m1Pq0tMoVVKiGV9qM0eoUbBnI3lAz
         qhru17GzqWR8GmJHTheezxsBJiURZlhTSTWeyi/aPO9kKLI67+04b165c35gJFLqVHlJ
         Ej6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696286068; x=1696890868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0D+gsuQdOwcWnbWTeVpJ3kkjsJtSvYb638sfQAfzu6A=;
        b=cnGC9yp239krlAw2Rp4ZYsiYB7jVLwHju+46hmQrctvuktcpYvdeMBClvKnvwiG7HL
         iLrHIZaPEhxlV2kc3h061lTTbhHrDySarvl6BotEtq9XrsXC95e95R2PoeRIrNEWgYWd
         lASIYvZjjlRb3NDLoiOBkJWIU2HgxZA3+IAGJOS88mR4vAl1EdEYxIdDbt3uTJJ3I7A2
         UbRnn37fUQJOdULQX8GkOPpdh4M3OvXAkL6pfnzH5Ma2oMsE+pTAR8ML/oMt0RYgJoks
         JgrWfAYjXwRRzov6IIOE2Kk+ex9G/GdtecSZqQfJBkUXkeCnjtnEAom9vEWVfO00EiAb
         YBIg==
X-Gm-Message-State: AOJu0YzB3n2/FrcZpPhbQ89fno1kB57q+JQgBT7Gv5yxvjD4iN2Kb5Eb
        fD/WjI0zgYxnmCeXjfwhF0J7uXwRva9JI3nyEbj1Iw==
X-Google-Smtp-Source: AGHT+IFpYXxgcGLgPpprP4KPLQoN5qCpiAYZTRtw0p896539ZQWnBJ0XhZh8uY+8KZAQ/hzk0BT8KycGM7WYrJRxXJQ=
X-Received: by 2002:a05:6122:a20:b0:49c:79f3:27a4 with SMTP id
 32-20020a0561220a2000b0049c79f327a4mr12486615vkn.3.1696286068162; Mon, 02 Oct
 2023 15:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
In-Reply-To: <ZQ3AmLO2SYv3DszH@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 2 Oct 2023 15:33:52 -0700
Message-ID: <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To:     Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 9:28=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> > So when exit reason is KVM_EXIT_MEMORY_FAULT, how can we tell which fie=
ld in
> > the first union is valid?
>
> /facepalm
>
> At one point, I believe we had discussed a second exit reason field?  But=
 yeah,
> as is, there's no way for userspace to glean anything useful from the fir=
st union.

Oh, was this an objective? When I was pushing for the second union
this I was just trying to make sure all the efault annotations
wouldn't clobber *other* exits. But yeah, I don't/didn't see a
meaningful way to have valid information in both structs.

> The more I think about this, the more I think it's a fool's errand.  Even=
 if KVM
> provides the exit_reason history, userspace can't act on the previous, un=
fulfilled
> exit without *knowing* that it's safe/correct to process the previous exi=
t.  I
> don't see how that's remotely possible.
>
> Practically speaking, there is one known instance of this in KVM, and it'=
s a
> rather riduclous edge case that has existed "forever".  I'm very strongly=
 inclined
> to do nothing special, and simply treat clobbering an exit that userspace=
 actually
> cares about like any other KVM bug.
>
> > When exit reason is not KVM_EXIT_MEMORY_FAULT, how can we know the info=
 in
> > the second union run.memory is valid without a run.memory.valid field?
>
> Anish's series adds a flag in kvm_run.flags to track whether or not memor=
y_fault
> has been filled.  The idea is that KVM would clear the flag early in KVM_=
RUN, and
> then set the flag when memory_fault is first filled.
>
>         /* KVM_CAP_MEMORY_FAULT_INFO flag for kvm_run.flags */
>         #define KVM_RUN_MEMORY_FAULT_FILLED (1 << 8)
>
> I didn't propose that flag here because clobbering memory_fault from the =
page
> fault path would be a flagrant KVM bug.
>
> Honestly, I'm becoming more and more skeptical that separating memory_fau=
lt is
> worthwhile, or even desirable.  Similar to memory_fault clobbering someth=
ing else,
> userspace can only take action if memory_fault is clobbered if userspace =
somehow
> knows that it's safe/correct to do so.
>
> Even if KVM exits "immediately" after initially filling memory_fault, the=
 fact
> that KVM is exiting for a different reason (or a different memory fault) =
means
> that KVM did *something* between filling memory_fault and actually exitin=
g.  And
> it's completely impossible for usersepace to know what that "something" w=
as.

Are you describing a scenario in which memory_fault is (initially)
filled, then something else happens to fill memory_fault (thus
clobbering it), then KVM_RUN exits? I'm confused by the tension
between the "KVM exits 'immediately'" and "KVM did *something* between
filling memory_fault and actually existing" statements here.

> E.g. in the splat from selftests[1], KVM reacts to a failure during Real =
Mode
> event injection by synthesizing a triple fault
>
>         ret =3D emulate_int_real(ctxt, irq);
>
>         if (ret !=3D X86EMUL_CONTINUE) {
>                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>
> There are multiple KVM bugs at play: read_emulate() and write_emulate() i=
ncorrectly
> assume *all* failures should be treated like MMIO, and conversely ->read_=
std() and
> ->write_std() don't handle *any* failures as MMIO.
>
> Circling back to my "capturing the history is pointless" assertion, by th=
e time
> userspace gets an exit, the vCPU is already in shutdown, and KVM has clob=
bered
> memory_fault something like five times.  There is zero chance userspace c=
an do
> anything but shed a tear for the VM and move on.
>
> The whole "let's annotate all memory faults" idea came from my desire to =
push KVM
> towards a future where all -EFAULT exits are annotated[2].  I still think=
 we should
> point KVM in that general direction, i.e. implement something that _can_ =
provide
> 100% "coverage" in the future, even though we don't expect to get there a=
nytime soon.
>
> I bring that up because neither private memory nor userfault-on-missing n=
eeds to
> annotate anything other than -EFAULT during guest page faults.  I.e. all =
of this
> paranoia about clobbering memory_fault isn't actually buying us anything =
other
> than noise and complexity.  The cases we need to work _today_ are perfect=
ly fine,
> and _if_ some future use cases needs all/more paths to be 100% accurate, =
then the
> right thing to do is to make whatever changes are necessary for KVM to be=
 100%
> accurate.
>
> In other words, trying to gracefully handle memory_fault clobbering is po=
intless.
> KVM either needs to guarantee there's no clobbering (guest page fault pat=
hs) or
> treat the annotation as best effort and informational-only (everything el=
se at
> this time).  Future features may grow the set of paths that needs strong =
guarantees,
> but that just means fixing more paths and treating any violation of the c=
ontract
> like any other KVM bug.

Ok, so if we're restricting the exit to just the places it's totally
accurate (page-fault paths) then, IIUC,

- There's no reason to attach it to EFAULT, ie it becomes a "normal" exit
- I should go drop the patches annotating kvm_vcpu_read/write_page
from my series
- The helper function [a] for filling the memory_fault field
(downgraded back into the current union) can drop the "has the field
already been filled?" check/WARN.
- [KVM_CAP_USERFAULT_ON_MISSING] The memslot flag check [b] needs to
be moved back from __gfn_to_pfn_memslot() into
user_mem_abort()/kvm_handle_error_pfn() since the slot flag-triggered
fast-gup failures *have* to result in the memory fault exits, and we
only want to do those in the two SLAT-failure paths (for now).

[a] https://lore.kernel.org/all/20230908222905.1321305-5-amoorthy@google.co=
m/
[b] https://lore.kernel.org/all/20230908222905.1321305-11-amoorthy@google.c=
om/

> And if we stop being unnecessarily paranoid, KVM_RUN_MEMORY_FAULT_FILLED =
can also
> go away.  The flag came about in part because *unconditionally* sanitizin=
g
> kvm_run.exit_reason at the start of KVM_RUN would break KVM's ABI, as use=
rspace
> may rely on the exit_reason being preserved when calling back into KVM to=
 complete
> userspace I/O (or MMIO)[3].  But the goal is purely to avoid exiting with=
 stale
> memory_fault information, not to sanitize every other existing exit_reaso=
n, and
> that can be achieved by simply making the reset conditional.
>
> ...
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 96fc609459e3..d78e97b527e5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4450,6 +4450,16 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                                 synchronize_rcu();
>                         put_pid(oldpid);
>                 }
> +
> +               /*
> +                * Reset the exit reason if the previous userspace exit w=
as due
> +                * to a memory fault.  Not all -EFAULT exits are annotate=
d, and
> +                * so leaving exit_reason set to KVM_EXIT_MEMORY_FAULT co=
uld
> +                * result in feeding userspace stale information.
> +                */
> +               if (vcpu->run->exit_reason =3D=3D KVM_EXIT_MEMORY_FAULT)
> +                       vcpu->run->exit_reason =3D KVM_EXIT_UNKNOWN
> +
>                 r =3D kvm_arch_vcpu_ioctl_run(vcpu);

Under my reading of the earlier block I'm not sure why we need to keep
this around. The original idea behind a canary of this type was to
avoid stomping on non-memory-fault exits in cases where something
caused an (ignored) annotated memory fault before the exit could be
completed. But if the annotations are going to be restricted in
general to just the page fault paths, then we can just eliminate the
sentinel check (and just this block) entirely, right?
