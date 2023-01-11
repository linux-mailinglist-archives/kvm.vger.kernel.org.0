Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CC66658FE
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbjAKK1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 05:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbjAKK1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 05:27:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEECCE0F;
        Wed, 11 Jan 2023 02:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zfQriuAKBv+9Au7hyV/l+byObp8DxaCbFBDpUOsYJKo=; b=kGPTu6PfSqvN99rvLY+WUguN2Q
        xglK2FWdVcYGEwmQNsqLtcqj10hkoAYnJ44FybqTUrdYRxDh4Sz3wKNiHjEmr5343YtRWEsFmq6BM
        LVvFQeWRqYWxKrY9Udaag4ai+uYLdigDm2Nq42l9Qof9RFjx0cx/UyWxZba19N/4o77bRUtT68k03
        p1CnyRJF3LqfRwXNCAyDW49WQWnouXdPNOWUOzHCqGipHlwximu4wVfwfO7+Yo3RdpEnXsQfmfJgn
        Z5wXTnA8xFIr990SgKTQVoTfXss6jm3h4vnfpsDt0ICHPvrftSKwZJWFC7Rv3sAq7HMFLSu2q9E/G
        xb2xZfQA==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFYK4-0042GT-Tk; Wed, 11 Jan 2023 10:27:09 +0000
Message-ID: <1bd1d36e976b0f64e88e7ab44dfcc049718703d1.camel@infradead.org>
Subject: Re: [PATCH] Documentation: kvm: clarify SRCU locking order
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 11 Jan 2023 10:26:55 +0000
In-Reply-To: <Y7dRaY+spKan+VcV@google.com>
References: <20221228110410.1682852-2-pbonzini@redhat.com>
         <Y7RpB+trpnhVRhQW@google.com> <Y7dRaY+spKan+VcV@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-8cUp4V42iLxFbJ97lg66"
User-Agent: Evolution 3.44.4-0ubuntu1 
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


--=-8cUp4V42iLxFbJ97lg66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-01-05 at 22:38 +0000, Sean Christopherson wrote:
>=20
> > > +- kvm->lock is taken inside kvm->srcu, therefore
> >=20
> > Prior to the recent Xen change, is this actually true?
>=20
> I was thinking of a different change, but v5.19 is still kinda recent, so=
 I'll
> count it.=C2=A0 Better to be lucky than good :-)
>=20
> Commit 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")=
 introduced
> the only case I can find where kvm->srcu is taken inside kvm->lock.
>=20
> > There are many instances where kvm->srcu is taken inside kvm->lock, but=
 I
> > can't find any existing cases where the reverse is true.=C2=A0 Logicall=
y, it makes
> > sense to take kvm->lock first since kvm->srcu can be taken deep in help=
ers,
> > e.g. for accessing guest memory.=C2=A0 It's also more consistent to tak=
e kvm->lock
> > first since kvm->srcu is taken inside vcpu->mutex, and vcpu->mutex is t=
aken
> > inside kvm->lock.
> >=20
> > Disallowing synchronize_srcu(kvm->srcu) inside kvm->lock isn't probelma=
tic per se,
> > but it's going to result in a weird set of rules because synchronize_sc=
ru() can,
> > and is, called while holding a variety of other locks.
> >=20
> > In other words, IMO taking kvm->srcu outside of kvm->lock in the Xen co=
de is the
> > real bug.
>=20
> I'm doubing down on this.=C2=A0 Taking kvm->srcu outside of kvm->lock is =
all kinds of
> sketchy, and likely indicates a larger problem.=C2=A0 The aformentioned c=
ommit that
> introduced the problematic kvm->srcu vs. kvm->lock also blatantly violate=
s ordering
> between kvm->lock and vcpu->mutex.=C2=A0 Details in the link[*].
>=20
> The vast majority of flows that take kvm->srcu will already hold a lock o=
f some
> kind, otherwise the task can't safely deference any VM/vCPU/device data a=
nd thus
> has no reason to acquire kvm->srcu.=C2=A0 E.g. taking kvm->srcu to read g=
uest memory
> is nonsensical without a stable guest physical address to work with.
>=20
> There are exceptions, e.g. evtchn_set_fn() and maybe some ioctls(), but i=
n most
> cases, taking kvm->lock inside kvm->srcu is just asking for problems.
>=20
> [*] https://lore.kernel.org/all/Y7dN0Negds7XUbvI@google.com

So...

If we apply the patch below, then the Xen code never takes kvm->lock
inside kvm->srcu. (Never takes kvm->lock at all, in fact; I'm just
rereading the manual search/replace to make sure the change is valid in
all cases.)

It does take kvm->scru *without* holding kvm->lock, just not "outside"
it.

I think we can probably revert commit a79b53aaaa ("KVM: x86: fix
deadlock for KVM_XEN_EVTCHN_RESET") after doing this too?



From: David Woodhouse <dwmw@amazon.co.uk>
Date: Wed, 11 Jan 2023 10:04:38 +0000
Subject: [PATCH] KVM: x86/xen: Avoid deadlock by adding kvm->arch.xen.xen_l=
ock leaf node lock

In commit 14243b387137a ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN
and event channel delivery") the clever version of me left some helpful
notes for those who would come after him:

       /*
        * For the irqfd workqueue, using the main kvm->lock mutex is
        * fine since this function is invoked from kvm_set_irq() with
        * no other lock held, no srcu. In future if it will be called
        * directly from a vCPU thread (e.g. on hypercall for an IPI)
        * then it may need to switch to using a leaf-node mutex for
        * serializing the shared_info mapping.
        */
       mutex_lock(&kvm->lock);

In commit 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests"=
)
the other version of me ran straight past that comment without reading it,
and introduced a potential deadlock by taking vcpu->mutex and kvm->lock
in the wrong order.

Solve this as originally suggested, by adding a leaf-node lock in the Xen
state rather than using kvm->lock for it.

Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/xen.c              | 65 +++++++++++++++------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 2f5bf581d00a..4ef0143fa682 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1115,6 +1115,7 @@ struct msr_bitmap_range {
=20
 /* Xen emulation context */
 struct kvm_xen {
+	struct mutex xen_lock;
 	u32 xen_version;
 	bool long_mode;
 	bool runstate_update_flag;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c444948ab1ac..713241808a3d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -604,26 +604,26 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_=
xen_hvm_attr *data)
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
 			r =3D -EINVAL;
 		} else {
-			mutex_lock(&kvm->lock);
+			mutex_lock(&kvm->arch.xen.xen_lock);
 			kvm->arch.xen.long_mode =3D !!data->u.long_mode;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.xen.xen_lock);
 			r =3D 0;
 		}
 		break;
=20
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		r =3D kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
=20
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r =3D -EINVAL;
 		else {
-			mutex_lock(&kvm->lock);
+			mutex_lock(&kvm->arch.xen.xen_lock);
 			kvm->arch.xen.upcall_vector =3D data->u.vector;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.xen.xen_lock);
 			r =3D 0;
 		}
 		break;
@@ -633,9 +633,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 		break;
=20
 	case KVM_XEN_ATTR_TYPE_XEN_VERSION:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		kvm->arch.xen.xen_version =3D data->u.xen_version;
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		r =3D 0;
 		break;
=20
@@ -644,9 +644,9 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 			r =3D -EOPNOTSUPP;
 			break;
 		}
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.xen.xen_lock);
 		kvm->arch.xen.runstate_update_flag =3D !!data->u.runstate_update_flag;
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
 		r =3D 0;
 		break;
=20
@@ -661,7 +661,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 {
 	int r =3D -ENOENT;
=20
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
=20
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
@@ -700,7 +700,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xe=
n_hvm_attr *data)
 		break;
 	}
=20
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return r;
 }
=20
@@ -708,7 +708,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 {
 	int idx, r =3D -ENOENT;
=20
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
 	idx =3D srcu_read_lock(&vcpu->kvm->srcu);
=20
 	switch (data->type) {
@@ -936,7 +936,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 	}
=20
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
 	return r;
 }
=20
@@ -944,7 +944,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct=
 kvm_xen_vcpu_attr *data)
 {
 	int r =3D -ENOENT;
=20
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.xen.xen_lock);
=20
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
@@ -1027,7 +1027,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
 		break;
 	}
=20
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.xen.xen_lock);
 	return r;
 }
=20
@@ -1120,7 +1120,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xe=
n_hvm_config *xhc)
 	     xhc->blob_size_32 || xhc->blob_size_64))
 		return -EINVAL;
=20
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
=20
 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
 		static_branch_inc(&kvm_xen_enabled.key);
@@ -1129,7 +1129,7 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xe=
n_hvm_config *xhc)
=20
 	memcpy(&kvm->arch.xen_hvm_config, xhc, sizeof(*xhc));
=20
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return 0;
 }
=20
@@ -1672,15 +1672,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn =
*xe, struct kvm *kvm)
 		mm_borrowed =3D true;
 	}
=20
-	/*
-	 * For the irqfd workqueue, using the main kvm->lock mutex is
-	 * fine since this function is invoked from kvm_set_irq() with
-	 * no other lock held, no srcu. In future if it will be called
-	 * directly from a vCPU thread (e.g. on hypercall for an IPI)
-	 * then it may need to switch to using a leaf-node mutex for
-	 * serializing the shared_info mapping.
-	 */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
=20
 	/*
 	 * It is theoretically possible for the page to be unmapped
@@ -1709,7 +1701,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *=
xe, struct kvm *kvm)
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
=20
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
=20
 	if (mm_borrowed)
 		kthread_unuse_mm(kvm->mm);
@@ -1825,7 +1817,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	int ret;
=20
 	/* Protect writes to evtchnfd as well as the idr lookup.  */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	evtchnfd =3D idr_find(&kvm->arch.xen.evtchn_ports, port);
=20
 	ret =3D -ENOENT;
@@ -1856,7 +1848,7 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	}
 	ret =3D 0;
 out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	return ret;
 }
=20
@@ -1919,10 +1911,10 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 		evtchnfd->deliver.port.priority =3D data->u.evtchn.deliver.port.priority=
;
 	}
=20
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	ret =3D idr_alloc(&kvm->arch.xen.evtchn_ports, evtchnfd, port, port + 1,
 			GFP_KERNEL);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
 	if (ret >=3D 0)
 		return 0;
=20
@@ -1940,9 +1932,9 @@ static int kvm_xen_eventfd_deassign(struct kvm *kvm, =
u32 port)
 {
 	struct evtchnfd *evtchnfd;
=20
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	evtchnfd =3D idr_remove(&kvm->arch.xen.evtchn_ports, port);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
=20
 	if (!evtchnfd)
 		return -ENOENT;
@@ -1959,7 +1951,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
 	struct evtchnfd *evtchnfd;
 	int i;
=20
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.xen.xen_lock);
 	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
 		idr_remove(&kvm->arch.xen.evtchn_ports, evtchnfd->send_port);
 		synchronize_srcu(&kvm->srcu);
@@ -1967,7 +1959,7 @@ static int kvm_xen_eventfd_reset(struct kvm *kvm)
 			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
 		kfree(evtchnfd);
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.xen.xen_lock);
=20
 	return 0;
 }
@@ -2059,6 +2051,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
=20
 void kvm_xen_init_vm(struct kvm *kvm)
 {
+	mutex_init(&kvm->arch.xen.xen_lock);
 	idr_init(&kvm->arch.xen.evtchn_ports);
 	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
 }
--=20
2.35.3



--=-8cUp4V42iLxFbJ97lg66
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMTExMTAyNjU1WjAvBgkqhkiG9w0BCQQxIgQg7p+dqyju
PTCfdNdsZRrMHSqrQu/26LFwNx2A3r+m2uwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgA2payCbTIKEr/LQew0ubc+3mhYYOk8Mg8U
rj5cTGEAzht+qsl/TNufhQNEKU8UCQzo11MNOWtVnwN5rdq7VN7TDqQoKTzWWfPfKPNmINoH8JaU
ppUYC0/IM5xgVHynk1+28KY++r38XGBB/6tjnbX+vnMC85TwPxNSZo1IUCJ00+KIkpf9hFXrjk7T
QwN/IrbOZHCpBw0o95Kzqa/InNt/EIvuTSpGp+bO7NvmEwVRW3pDhH64I7v5vj3nh4XYKKw2uZq8
VnbVoAxao2dOeouJy78em+JeNAGjRtDAaejK/XT/r67EBMu7RmTl+hSbatETDMFjRMzSWk6NzQRa
rdx7c7CEV1S2cWweSNai7V11He78lC2zpLrPnSZ82LtuIBA92pImLovJcoG2JOk5KYbDipdDYq3i
+0Am9JEhahrtCgJiSMrCWri20XtohSsCUaI3M05428Rt9tkPBtB7iPw5Zt581pnIyldqwduQ4Pei
AXXGf2N1MnpSY2sI6ShLOsmPR/XArhGwBvl4cB/TrVG4Qhj78A/GuQ5QHOkxoLAisnNcc2XZ+5Y9
G/f9u0o16OWve5Pq3KjjIVPpRuOIpDf288LyBiW0gqcwlxt7UsAG1W4hpxzidh6BvqwBV58o2tih
gMOk/+TND1QvkHh6AdXUS35/v/iW5VXSB5Yypl309wAAAAAAAA==


--=-8cUp4V42iLxFbJ97lg66--
