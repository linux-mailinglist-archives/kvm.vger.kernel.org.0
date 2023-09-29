Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0797A7B3677
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 17:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjI2PQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 11:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjI2PQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 11:16:23 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B2ED6
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 08:16:21 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56c306471ccso13122291a12.3
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 08:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696000581; x=1696605381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GpbTwXug+C5ZcOAyaCOQRA6rIp0O6yfKpgYXnFKXyl4=;
        b=NGiYodD6WL/60ddOkemIJkODWE/FgvqX+qAwi/Fu3FmsG9OT+xzAMScFEMIIQFQxL4
         G123in16KUfiUcQcMGhdmtMo6/JRcSZy2svN1OpppkeX1dqRCzhQTVDK0XoFwzMcmMVy
         eOMOTvfXHjTmgyO7J5Adt+APi3c8+SpKFZFUuE1q6/F67IeJXaIZKcau+ti3E2JvJaay
         qu+eecONURl7Q5aszM3sWFjEtqfbtUf2ovaAevavrqwnb4xLlRL9aO5UqBO4IBRp920O
         u2n6HV1budmUaGGaP9cPXSOLYNrSXg8a4tKQxb+xoYu7FSMlt+S+k7IiP0nQowx+/uO4
         aOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696000581; x=1696605381;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GpbTwXug+C5ZcOAyaCOQRA6rIp0O6yfKpgYXnFKXyl4=;
        b=PwENzLZoD7x9wR3gv8HaBBz2GFYRtqxxJJbs7HHmqC1FhLR4Tn6my1Hax30t/Scujd
         3IKkPaHiJrfWcbLJWy+7+ep8Kwkn1GBwKoXa+S1XaJq6EE+wd3cZdpZKxkChR/wBS9cI
         kY8avMvVMPNk4yMLp2Us85XSYynlv0QlJjfl+IvSV51sqvbA+IYhr2um6shD+XUCDdMN
         nmxLzxZOZVae3gqbyVZy+CzvrBaVXIFEOv8iRGq9dqnoMR5eJ8XGyo42ssP3hCsFBzWC
         vobxwhxMBZagFiqEgcpMYyuc4OWYfOH1G5EvB6wapDfJxEH6BXqTiW7fR5K8fYjSwGVM
         4v1A==
X-Gm-Message-State: AOJu0Yz/McrOXAWpZy4L1GKrbdRK8Zb8Az7smr9oflN+YE/ctjUYQOC4
        HEZUwkQJxfQf4DGmB3d3HspNxE7o9CA=
X-Google-Smtp-Source: AGHT+IGKQx3q812yLaAKd8tO7xYWmySUUuugEo2juRUdTZeXxIzvRvUGCDjefKBX27/fhApzLken+D1OUUs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c1:b0:1c6:1ad4:d1e6 with SMTP id
 u1-20020a17090341c100b001c61ad4d1e6mr72265ple.4.1696000581164; Fri, 29 Sep
 2023 08:16:21 -0700 (PDT)
Date:   Fri, 29 Sep 2023 08:16:19 -0700
In-Reply-To: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
Mime-Version: 1.0
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
Message-ID: <ZRbolEa6RI3IegyF@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
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

On Fri, Sep 29, 2023, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> Most of the time there's no need to kick the vCPU and deliver the timer
> event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
> directly from the timer callback, and only fall back to the slow path
> when it's necessary to do so.

It'd be helpful for non-Xen folks to explain "when it's necessary".  IIUC, =
the
only time it's necessary is if the gfn=3D>pfn cache isn't valid/fresh.

> This gives a significant improvement in timer latency testing (using
> nanosleep() for various periods and then measuring the actual time
> elapsed).
>=20
> However, there was a reason=C2=B9 the fast path was dropped when this sup=
port

Heh, please use [1] or [*] like everyone else.  I can barely see that tiny =
little =C2=B9.

> was first added. The current code holds vcpu->mutex for all operations on
> the kvm->arch.timer_expires field, and the fast path introduces potential
> race conditions. So... ensure the hrtimer is *cancelled* before making
> changes in kvm_xen_start_timer(), and also when reading the values out
> for KVM_XEN_VCPU_ATTR_TYPE_TIMER.
>=20
> Add some sanity checks to ensure the truth of the claim that all the
> other code paths are run with the vcpu loaded.  And use hrtimer_cancel()
> directly from kvm_xen_destroy_vcpu() to avoid a false positive from the
> check in kvm_xen_stop_timer().

This should really be at least 2 patches, probably 3:

  1. add the assertions and the destroy_vcpu() change
  2. cancel the timer before starting a new one or reading the value from u=
serspace
  3. use the fastpath delivery from the timer callback

> =C2=B9 https://lore.kernel.org/kvm/846caa99-2e42-4443-1070-84e49d2f11d2@r=
edhat.com/
>=20
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>=20
>  =E2=80=A2 v2: Remember, and deal with, those races.
>=20
>  arch/x86/kvm/xen.c | 64 +++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 58 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index fb1110b2385a..9d0d602a2466 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -117,6 +117,8 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, =
gfn_t gfn)
> =20
>  void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
>  {
> +	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
> +
>  	if (atomic_read(&vcpu->arch.xen.timer_pending) > 0) {
>  		struct kvm_xen_evtchn e;
> =20
> @@ -136,18 +138,41 @@ static enum hrtimer_restart xen_timer_callback(stru=
ct hrtimer *timer)
>  {
>  	struct kvm_vcpu *vcpu =3D container_of(timer, struct kvm_vcpu,
>  					     arch.xen.timer);
> +	struct kvm_xen_evtchn e;
> +	int rc;
> +
>  	if (atomic_read(&vcpu->arch.xen.timer_pending))
>  		return HRTIMER_NORESTART;
> =20
> -	atomic_inc(&vcpu->arch.xen.timer_pending);
> -	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> -	kvm_vcpu_kick(vcpu);
> +	e.vcpu_id =3D vcpu->vcpu_id;
> +	e.vcpu_idx =3D vcpu->vcpu_idx;
> +	e.port =3D vcpu->arch.xen.timer_virq;
> +	e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
> +
> +	rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
> +	if (rc =3D=3D -EWOULDBLOCK) {
> +		atomic_inc(&vcpu->arch.xen.timer_pending);
> +		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> +		kvm_vcpu_kick(vcpu);
> +	} else {
> +		vcpu->arch.xen.timer_expires =3D 0;

Eww.  IIUC, timer_expires isn't cleared so that the pending IRQ is captured=
 by
kvm_xen_vcpu_get_attr(), i.e. because xen.timer_pending itself isn't migrat=
ed.

> +	}
> =20
>  	return HRTIMER_NORESTART;
>  }
> =20
>  static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s6=
4 delta_ns)
>  {
> +	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
> +
> +	/*
> +	 * Avoid races with the old timer firing. Checking timer_expires
> +	 * to avoid calling hrtimer_cancel() will only have false positives
> +	 * so is fine.
> +	 */
> +	if (vcpu->arch.xen.timer_expires)
> +		hrtimer_cancel(&vcpu->arch.xen.timer);
> +
>  	atomic_set(&vcpu->arch.xen.timer_pending, 0);
>  	vcpu->arch.xen.timer_expires =3D guest_abs;
> =20
> @@ -163,6 +188,8 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu=
, u64 guest_abs, s64 delta_
> =20
>  static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
>  {
> +	WARN_ON_ONCE(vcpu !=3D kvm_get_running_vcpu());
> +
>  	hrtimer_cancel(&vcpu->arch.xen.timer);
>  	vcpu->arch.xen.timer_expires =3D 0;
>  	atomic_set(&vcpu->arch.xen.timer_pending, 0);
> @@ -1019,13 +1046,38 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, =
struct kvm_xen_vcpu_attr *data)
>  		r =3D 0;
>  		break;
> =20
> -	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> +	case KVM_XEN_VCPU_ATTR_TYPE_TIMER: {
> +		bool pending =3D false;
> +
> +		/*
> +		 * Ensure a consistent snapshot of state is captures, with a

s/captures/captured

> +		 * timer either being pending, or fully delivered. Not still

Kind of a nit, but IMO "fully delivered" isn't accurate, at least not witho=
ut
more clarification.  I would considered "fully delivered" to mean that the =
IRQ
has caused the guest to start executing its IRQ handler.  Maybe "fully queu=
ed in
the event channel"?

> +		 * lurking in the timer_pending flag for deferred delivery.
> +		 */
> +		if (vcpu->arch.xen.timer_expires) {
> +			pending =3D hrtimer_cancel(&vcpu->arch.xen.timer);
> +			kvm_xen_inject_timer_irqs(vcpu);

If the goal is to not have pending timers, then kvm_xen_inject_timer_irqs()
should be called unconditionally after canceling the hrtimer, no?

> +		}
> +
>  		data->u.timer.port =3D vcpu->arch.xen.timer_virq;
>  		data->u.timer.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
>  		data->u.timer.expires_ns =3D vcpu->arch.xen.timer_expires;
> +
> +		/*
> +		 * The timer may be delivered immediately, while the returned
> +		 * state causes it to be set up and delivered again on the

Similar to the "fully delivered" stuff above, maybe s/timer/hrtimer to make=
 it
a bit more clear that the host hrtimer can fire twice, but it won't ever re=
sult
in two timer IRQs being delivered from the guest's perspective.

> +		 * destination system after migration. That's fine, as the
> +		 * guest will not even have had a chance to run and process
> +		 * the interrupt by that point, so it won't even notice the
> +		 * duplicate IRQ.

Rather than say "so it won't even notice the duplicate IRQ", maybe be more =
explicit
and say "so the queued IRQ is guaranteed to be coalesced in the event chann=
el
and/or guest local APIC".  Because I read the whole "delivered IRQ" stuff a=
s there
really being two injected IRQs into the guest.

FWIW, this is all really gross, but I agree that even if the queued IRQ mak=
es it
all the way to the guest's APIC, the IRQs will still be coalesced in the en=
d.


> +		 */
> +		if (pending)
> +			hrtimer_start_expires(&vcpu->arch.xen.timer,
> +					      HRTIMER_MODE_ABS_HARD);
> +
>  		r =3D 0;
>  		break;
> -
> +	}
>  	case KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR:
>  		data->u.vector =3D vcpu->arch.xen.upcall_vector;
>  		r =3D 0;
> @@ -2085,7 +2137,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
>  void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_xen_timer_enabled(vcpu))

IIUC, this can more precisely be:

	if (vcpu->arch.xen.timer_expires)
		hrtimer_cancel(&vcpu->arch.xen.timer);

at which point it might make sense to add a small helper

  static void kvm_xen_cancel_timer(struct kvm_vcpu *vcpu)
  {
	if (vcpu->arch.xen.timer_expires)
		hrtimer_cancel(&vcpu->arch.xen.timer);
  }

to share code with=20

> -		kvm_xen_stop_timer(vcpu);
> +		hrtimer_cancel(&vcpu->arch.xen.timer);
> =20
>  	kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
>  	kvm_gpc_deactivate(&vcpu->arch.xen.runstate2_cache);
> --=20
> 2.40.1
>=20
>=20


