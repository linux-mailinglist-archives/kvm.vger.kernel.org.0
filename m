Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915697B3BEB
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjI2VZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 17:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjI2VZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 17:25:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C85B1AB;
        Fri, 29 Sep 2023 14:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lUINZUiuL2j0GNMbCl2BNRZagyWLVJrsgpBTlTMvAow=; b=e/s77vjRAtxl/bz1Iw+XZZI7a1
        RRk9x9yn5cRkvFe7aSm2LhJ95sR6X9drP5UV2tddO5P1/5G37zgw8vCV1zzK+UNp4+WeiHr0b405d
        /ruZDJ4bOQlggZYz8yUnEfbBNPJ3dL9oEogf6wKEPLksrwk4NKonMIk0DI9pvQco0hiF7mwSlIwct
        QpjTIV2QmJObvKQCeEyXJV6WDTM770m/q2+5L5I3GBBWGOjqhNFcwy079m/jhefIXeIMyvYr0GHUw
        PG+IHwlsGklPgP8EBZLIqbsHdzITQZB4z1IDZMDa+TIbwmhEkfPzZeo9fPwQ9YkGuoH8+K68QCIi1
        QGnSe0SQ==;
Received: from 54-240-197-230.amazon.com ([54.240.197.230] helo=edge-m3-r3-174.e-iad51.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qmKz9-00B2rL-Pm; Fri, 29 Sep 2023 21:25:20 +0000
Message-ID: <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Date:   Fri, 29 Sep 2023 22:25:18 +0100
In-Reply-To: <ZRbolEa6RI3IegyF@google.com>
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
         <ZRbolEa6RI3IegyF@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-+tdzy/ZsRFcuRbtmXrPN"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-+tdzy/ZsRFcuRbtmXrPN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-09-29 at 08:16 -0700, Sean Christopherson wrote:
> On Fri, Sep 29, 2023, David Woodhouse wrote:
> > From: David Woodhouse <dwmw@amazon.co.uk>
> >=20
> > Most of the time there's no need to kick the vCPU and deliver the timer
> > event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast(=
)
> > directly from the timer callback, and only fall back to the slow path
> > when it's necessary to do so.
>=20
> It'd be helpful for non-Xen folks to explain "when it's necessary".=C2=A0=
 IIUC, the
> only time it's necessary is if the gfn=3D>pfn cache isn't valid/fresh.

That's an implementation detail. Like all of the fast path functions
that can be called from kvm_arch_set_irq_inatomic(), it has its own
criteria for why it might return -EWOULDBLOCK or not. Those are *its*
business. And in fact one of Paul's current patches is tweaking them
subtly, but that isn't relevant here. (But yes, you are broadly correct
in your understanding.)

> > This gives a significant improvement in timer latency testing (using
> > nanosleep() for various periods and then measuring the actual time
> > elapsed).
> >=20
> > However, there was a reason=C2=B9 the fast path was dropped when this s=
upport
>=20
> Heh, please use [1] or [*] like everyone else.=C2=A0 I can barely see tha=
t tiny little =C2=B9.

Isn't that the *point*? The reference to the footnote isn't supposed to
detract from the flow of the main text. It's exactly how you'll see it
when typeset properly. I've always assumed the people using [1] or [*]
just haven't yet realised that it's the 21st century and we are no
longer limited to 7-bit ASCII. Or haven't worked out how to type
anything but ASCII.

> > was first added. The current code holds vcpu->mutex for all operations =
on
> > the kvm->arch.timer_expires field, and the fast path introduces potenti=
al
> > race conditions. So... ensure the hrtimer is *cancelled* before making
> > changes in kvm_xen_start_timer(), and also when reading the values out
> > for KVM_XEN_VCPU_ATTR_TYPE_TIMER.
> >=20
> > Add some sanity checks to ensure the truth of the claim that all the
> > other code paths are run with the vcpu loaded.=C2=A0 And use hrtimer_ca=
ncel()
> > directly from kvm_xen_destroy_vcpu() to avoid a false positive from the
> > check in kvm_xen_stop_timer().
>=20
> This should really be at least 2 patches, probably 3:
>=20
> =C2=A0 1. add the assertions and the destroy_vcpu() change
> =C2=A0 2. cancel the timer before starting a new one or reading the value=
 from userspace
> =C2=A0 3. use the fastpath delivery from the timer callback

Hm, I think that's borderline. I pondered it and came to the opposite
conclusion. Cancelling the timer wasn't needed without the fastpath
delivery; it isn't a separate fix. You could consider it a preparatory
patch I suppose... but I didn't. It's not like adding the fast path in
itself is complex enough that the other parts need to be broken out.=20

> > =C2=B9 https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2=
@redhat.com/
> >=20
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
> >=20
> > =C2=A0=E2=80=A2 v2: Remember, and deal with, those races.
> >=20
> > =C2=A0arch/x86/kvm/xen.c | 64 +++++++++++++++++++++++++++++++++++++++++=
-----
> > =C2=A01 file changed, 58 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index fb1110b2385a..9d0d602a2466 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -117,6 +117,8 @@ static int kvm_xen_shared_info_init(struct kvm *kvm=
, gfn_t gfn)
> > =C2=A0
> > =C2=A0void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
> > =C2=A0{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WARN_ON_ONCE(vcpu !=3D kvm_g=
et_running_vcpu());
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (atomic_read(&vcpu->=
arch.xen.timer_pending) > 0) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_xen_evtchn e;
> > =C2=A0
> > @@ -136,18 +138,41 @@ static enum hrtimer_restart xen_timer_callback(st=
ruct hrtimer *timer)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_vcpu *vcpu =
=3D container_of(timer, struct kvm_vcpu,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 arch.xen.timer);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_xen_evtchn e;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int rc;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (atomic_read(&vcpu->=
arch.xen.timer_pending))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return HRTIMER_NORESTART;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_inc(&vcpu->arch.xen.t=
imer_pending);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_make_request(KVM_REQ_UNB=
LOCK, vcpu);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_vcpu_kick(vcpu);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0e.vcpu_id =3D vcpu->vcpu_id;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0e.vcpu_idx =3D vcpu->vcpu_id=
x;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0e.port =3D vcpu->arch.xen.ti=
mer_virq;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0e.priority =3D KVM_IRQ_ROUTI=
NG_XEN_EVTCHN_PRIO_2LEVEL;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D kvm_xen_set_evtchn_fa=
st(&e, vcpu->kvm);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rc =3D=3D -EWOULDBLOCK) =
{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0atomic_inc(&vcpu->arch.xen.timer_pending);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0kvm_vcpu_kick(vcpu);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0vcpu->arch.xen.timer_expires =3D 0;
>=20
> Eww.=C2=A0 IIUC, timer_expires isn't cleared so that the pending IRQ is c=
aptured by
> kvm_xen_vcpu_get_attr(), i.e. because xen.timer_pending itself isn't migr=
ated.

-EPARSE. Er... yes?

The timer_expires field is non-zero when there's a pending timer. When
the timer interrupt has fired, the time is no longer pending and the
timer_expires field is set to zero.

The xen.timer_pending field is indeed not migrated. We *flush* it in
kvm_xen_vcpu_get_attr(). It's now only used for the *deferral* to the
slow path.

So... yes, timer_expires *wasn't* previously cleared, because the timer
IRQ hadn't been delivered yet, and yes that was to avoid races with
kvm_xen_vcpu_get_attr(). Partly because the timer_pending field was
internal and not migrated. As far as userspace is concerned, the timer
has either fired, or it has not. Implementation details of the
timer_pending field =E2=80=94 and the per-vcpu evtchn_pending_sel =E2=80=94=
 are not
exposed.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return HRTIMER_NORESTAR=
T;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_=
abs, s64 delta_ns)
> > =C2=A0{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WARN_ON_ONCE(vcpu !=3D kvm_g=
et_running_vcpu());
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Avoid races with the old =
timer firing. Checking timer_expires
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to avoid calling hrtimer_=
cancel() will only have false positives
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so is fine.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (vcpu->arch.xen.timer_exp=
ires)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0hrtimer_cancel(&vcpu->arch.xen.timer);
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_set(&vcpu->arch.=
xen.timer_pending, 0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu->arch.xen.timer_ex=
pires =3D guest_abs;
> > =C2=A0
> > @@ -163,6 +188,8 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vc=
pu, u64 guest_abs, s64 delta_
> > =C2=A0
> > =C2=A0static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
> > =C2=A0{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WARN_ON_ONCE(vcpu !=3D kvm_g=
et_running_vcpu());
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hrtimer_cancel(&vcpu->a=
rch.xen.timer);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vcpu->arch.xen.timer_ex=
pires =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_set(&vcpu->arch.=
xen.timer_pending, 0);
> > @@ -1019,13 +1046,38 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu=
, struct kvm_xen_vcpu_attr *data)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0r =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> > =C2=A0
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case KVM_XEN_VCPU_ATTR_TYPE_=
TIMER:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case KVM_XEN_VCPU_ATTR_TYPE_=
TIMER: {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0bool pending =3D false;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Ensure a consistent snapshot of state is captures, =
with a
>=20
> s/captures/captured

Ack.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * timer either being pending, or fully delivered. Not=
 still
>=20
> Kind of a nit, but IMO "fully delivered" isn't accurate, at least not wit=
hout
> more clarification.=C2=A0 I would considered "fully delivered" to mean th=
at the IRQ
> has caused the guest to start executing its IRQ handler.=C2=A0 Maybe "ful=
ly queued in
> the event channel"?

OK, I'll reword.


> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * lurking in the timer_pending flag for deferred deli=
very.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (vcpu->arch.xen.timer_expires) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pendin=
g =3D hrtimer_cancel(&vcpu->arch.xen.timer);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_xe=
n_inject_timer_irqs(vcpu);
>=20
> If the goal is to not have pending timers, then kvm_xen_inject_timer_irqs=
()
> should be called unconditionally after canceling the hrtimer, no?

It *is* called unconditionally after cancelling the hrtimer.

Or did you mean unconditionally whether we cancel the hrtimer or not?
The comment explains the logic for not needing that. If *either* the
timer is still active, *or* it's already fired and has taken the slow
path and set the timer_pending flag, then timer_expires won't have been
zeroed yet. So the race conditions inherent in doing this conditional
on vcpu->arch.xen.timer_expires are fine because there are only false
positives (which cause us to cancel a timer, and try to inject a
pending IRQ, which wasn't running and wasn't pending respectively).

Sounds like I need to expand that comment?=20

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0}
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0data->u.timer.port =3D vcpu->arch.xen.timer_virq=
;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0data->u.timer.priority =3D KVM_IRQ_ROUTING_XEN_E=
VTCHN_PRIO_2LEVEL;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0data->u.timer.expires_ns =3D vcpu->arch.xen.time=
r_expires;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * The timer may be delivered immediately, while the r=
eturned
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * state causes it to be set up and delivered again on=
 the
>=20
> Similar to the "fully delivered" stuff above, maybe s/timer/hrtimer to ma=
ke it
> a bit more clear that the host hrtimer can fire twice, but it won't ever =
result
> in two timer IRQs being delivered from the guest's perspective.

Ack.

> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * destination system after migration. That's fine, as=
 the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * guest will not even have had a chance to run and pr=
ocess
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * the interrupt by that point, so it won't even notic=
e the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * duplicate IRQ.
>=20
> Rather than say "so it won't even notice the duplicate IRQ", maybe be mor=
e explicit
> and say "so the queued IRQ is guaranteed to be coalesced in the event cha=
nnel
> and/or guest local APIC".=C2=A0 Because I read the whole "delivered IRQ" =
stuff as there
> really being two injected IRQs into the guest.
>=20
> FWIW, this is all really gross, but I agree that even if the queued IRQ m=
akes it
> all the way to the guest's APIC, the IRQs will still be coalesced in the =
end.
>=20

As discussed before, we *could* have made fetching the timer attr also
*pause* the timer. It just seemed like extra complexity for no good
reason. The shared info page containing the event channel bitmap has to
be migrated after the vCPU state anyway.


>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (pending)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hrtime=
r_start_expires(&vcpu->arch.xen.timer,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 HRTIMER_MODE_ABS_HARD);
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0r =3D 0;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> > -
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case KVM_XEN_VCPU_ATTR_=
TYPE_UPCALL_VECTOR:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0data->u.vector =3D vcpu->arch.xen.upcall_vector;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0r =3D 0;
> > @@ -2085,7 +2137,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
> > =C2=A0void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (kvm_xen_timer_enabl=
ed(vcpu))
>=20
> IIUC, this can more precisely be:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (vcpu->arch.xen.timer_=
expires)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0hrtimer_cancel(&vcpu->arch.xen.timer);
>=20
> at which point it might make sense to add a small helper
>=20
> =C2=A0 static void kvm_xen_cancel_timer(struct kvm_vcpu *vcpu)
> =C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (vcpu->arch.xen.timer_=
expires)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0hrtimer_cancel(&vcpu->arch.xen.timer);
> =C2=A0 }
>=20
> to share code with=20
>=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0kvm_xen_stop_timer(vcpu);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0hrtimer_cancel(&vcpu->arch.xen.timer);
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_gpc_deactivate(&vcp=
u->arch.xen.runstate_cache);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_gpc_deactivate(&vcp=
u->arch.xen.runstate2_cache);

In fact if I make the helper return a bool, I think I can use it
*three* times. At a cost of having a third function
kvm_xen_cancel_timer() alongside the existing kvm_xen_start_timer() and
kvm_xen_stop_timer(), and those *three* now make for a slightly
confusing set. I'll take a look and see how it makes me feel.=20

--=-+tdzy/ZsRFcuRbtmXrPN
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwOTI5MjEyNTE4WjAvBgkqhkiG9w0BCQQxIgQg3+bqqXx5
SvfJt2V47/UtgTqjF4TOf7ViAl57O/hBMTIwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAFF55rqEd//oiqAQS2yIQAPEAOf0ieBt7X
yjQ1Alk7hpaGwc7V9RIRA7xxFF4ABc9sreLp7cyfEs3jV8MifBMZn+2ZgKjZI9Om5Ly2niFluE+3
36TiEtVBEBxjiNcWBtDBiTVl8zVIEh8n8Ww+ppkmgJ6AdIFe4pc/+/kq6EJVpRCKs7ZediB+7ok9
g/cE8WvCyQ1uLyHfYz+5+HbkYNNbulsIgSg0afmlai6KgPaySljH9AlX8h/BEMPRK97186gIJp4i
VE3IGFgX4R8X8hxhsz5MzI1XdQj9W0JOH0BYlH2mmPoBuEev6ePOHqy3aSQUJFozhh7JQXW/+Nhj
UA/dLuNmYojEuC55b4aCtpkWk3SA0PeVvRB06N1Zo1km80UdBdFxOf0ZfEg1ptpHxzb0W5sAOytB
gekHL+YBevIFEAAQPPM80XgiaosRgvdzWGFv34R+fR8KgtvlOdxeqkK1n1MOkF4oB7I8XtyrJMNa
h26jADgFGPqL/jEwo6JGpN2pAa7dhrjkY1hTtK++ag+9QLYXIwAr1cdlTb2SqqJkMvQ9bjAZ2E90
OpU6vFqpByAB6PepJWStz6/D1Yl4fk0vtR+bE3Vhjw6oKxTBwzh7o88X96UbfXPh8SgvKs9P7C+2
gef2WSjXCcB4ylg8+EZeIXn8k4PrNk5OV2iNv73f1QAAAAAAAA==


--=-+tdzy/ZsRFcuRbtmXrPN--
