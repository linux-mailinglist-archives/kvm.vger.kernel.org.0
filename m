Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7B762CE09
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 23:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbiKPWuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 17:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiKPWuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 17:50:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FF0BC38;
        Wed, 16 Nov 2022 14:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lrWvpraj2tudmu/ige/lbZ86sck2SMh/xJF9Y8u+bo4=; b=u7n4bcTH8MDuHo9VHG4fifjxAY
        IKxL5VzL+a9VIQqlzf+Z4qcHfeXitjMVSAYI5Wxqj/C+4mD8yNbbOtN0h+BgBXWCfZWLxuwixpPWn
        Z6OlDCoysjr7JCJu8OEN+iEu3Lkl2vrAwFq/E6E6atFxLSl2e526CpV8S4MdZbePWeiEpC8dmp0XV
        MtBix4k9tcLNfoyozEmPcRs/4eZtUUSoCyUnCVQkj2ZRQxU9WR6PkQ3WKVcLxoo6Z9ct8Dj/bea+i
        Zr0gt5RFxMSkO42EJad5lN2kbU6VMtw/9i16H5t57d0Q1YkYjZCFEVqzEw/EoGGkHHQDh0426S1s+
        /B1rXTiQ==;
Received: from [205.251.233.232] (helo=freeip.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovRE8-000L13-Cr; Wed, 16 Nov 2022 22:49:52 +0000
Message-ID: <6acfdbd3e516ece5949e97c85e7db8dc97a3e6c6.camel@infradead.org>
Subject: Re: [PATCH 03/16] KVM: x86: set gfn-to-pfn cache length
 consistently with VM word size
From:   David Woodhouse <dwmw2@infradead.org>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>,
        "Kaya, Metin" <metikaya@amazon.co.uk>
Date:   Wed, 16 Nov 2022 14:49:42 -0800
In-Reply-To: <95d6d0a68cb8a4277be0066c26b482e7554c7f26.camel@infradead.org>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
         <20221027161849.2989332-4-pbonzini@redhat.com>
         <Y1q+a3gtABqJPmmr@google.com>
         <c61f6089-57b7-e00f-d5ed-68e62237eab0@redhat.com>
         <c30b46557c9c59b9f4c8c3a2139bd506a81f7ee1.camel@infradead.org>
         <89ea0f72514d93967b679a01960d05b34a90ea14.camel@infradead.org>
         <000fac2ae9394da6b51c2138c5816a45@amazon.co.uk>
         <95d6d0a68cb8a4277be0066c26b482e7554c7f26.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-Z1ejiCtUMokiG5I+9xiA"
User-Agent: Evolution 3.36.5-0ubuntu1 
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


--=-Z1ejiCtUMokiG5I+9xiA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-11-14 at 16:16 -0800, David Woodhouse wrote:
>=20
> I'm playing with using a second GPC for the overrun onto the second
> page. Debating if it's already too ugly to live before I even fix up
> the actual copying part...

Well it certainly didn't get any *prettier*. Utterly untested other
than building it, so it's certainly going to be broken, but as an
illustration.

I can't see a sane way to get the two pages vmapped consecutively,
given that they might be IOMEM. So I can't see how to make a single GPC
do this "nicely", and I think we have to declare that the runstate area
is the only case that actually needs this, then do it this way as a
special case... even though it's fugly?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 81114a376c4e..3fc08f416aa3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -647,6 +647,7 @@ struct kvm_vcpu_xen {
 	struct gfn_to_pfn_cache vcpu_info_cache;
 	struct gfn_to_pfn_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
+	struct gfn_to_pfn_cache runstate2_cache;
 	u64 last_steal;
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4b8e9628fbf5..14ba45b541bf 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -198,38 +198,101 @@ static void kvm_xen_update_runstate(struct kvm_vcpu =
*v, int state)
 	vx->runstate_entry_time =3D now;
 }
=20
+/*
+ * The guest region is arbitrarily aligned, and could be split across
+ * two pages.
+ *
+ * d1: Pointer to kernel map of first byte of region.
+ * d2: Pointer to kernel map of first byte of second page.
+ * l1: length of first range [ =3D=3D PAGE_SIZE - (d1 & ~PAGE_MASK) ]
+ * src: Source pointer.
+ * len: Source length to be copied.
+ * dst_ofs: Destination offset within the guest region.
+ */
+static inline void memcpy_to_runstate(void *d1, void *d2, size_t l1,
+				      void *src, size_t len, size_t dst_ofs)
+{
+	size_t copylen;
+
+	if (dst_ofs < l1) {
+		copylen =3D min(l1 - dst_ofs, len);
+		memcpy(d1 + dst_ofs, src, copylen);
+		if (copylen =3D=3D len)
+			return;
+
+		src +=3D copylen;
+		dst_ofs +=3D copylen;
+		len -=3D copylen;
+	}
+
+	BUG_ON(dst_ofs < l1);
+	memcpy(d2 + dst_ofs - l1, src, len);
+}
+
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx =3D &v->arch.xen;
-	struct gfn_to_pfn_cache *gpc =3D &vx->runstate_cache;
-	uint64_t *user_times;
+	struct gfn_to_pfn_cache *gpc1 =3D &vx->runstate_cache;
+	struct gfn_to_pfn_cache *gpc2 =3D &vx->runstate2_cache;
 	unsigned long flags;
-	size_t user_len;
-	int *user_state;
+	size_t user_len, user_len1, user_len2;
+	size_t times_ofs;
+	u8 *update_bit;
=20
 	kvm_xen_update_runstate(v, state);
=20
-	if (!vx->runstate_cache.active)
+	if (!gpc1->active)
 		return;
=20
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
+	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
 		user_len =3D sizeof(struct vcpu_runstate_info);
-	else
+		times_ofs =3D offsetof(struct vcpu_runstate_info,
+				     state_entry_time);
+	} else {
 		user_len =3D sizeof(struct compat_vcpu_runstate_info);
+		times_ofs =3D offsetof(struct compat_vcpu_runstate_info,
+				     state_entry_time);
+	}
=20
-	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
-					   user_len)) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+	if ((gpc1->gpa & ~PAGE_MASK) + user_len >=3D PAGE_SIZE) {
+		user_len1 =3D PAGE_SIZE - (gpc1->gpa & ~PAGE_MASK);
+		user_len2 =3D user_len - user_len1;
+	} else {
+		user_len1 =3D user_len;
+		user_len2 =3D 0;
+	}
+	BUG_ON(user_len1 + user_len2 !=3D user_len);
+
+ retry:
+	read_lock_irqsave(&gpc1->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc1, gpc1->gpa,
+					   user_len1)) {
+		read_unlock_irqrestore(&gpc1->lock, flags);
=20
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (state =3D=3D RUNSTATE_runnable)
 			return;
=20
-		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa, user_len))
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc1, gpc1->gpa, user_len1))
 			return;
=20
-		read_lock_irqsave(&gpc->lock, flags);
+		read_lock_irqsave(&gpc1->lock, flags);
+	}
+	if (user_len2) {
+		read_lock(&gpc2->lock);
+		if (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
+			read_unlock(&gpc2->lock);
+			read_unlock_irqrestore(&gpc1->lock, flags);
+
+			if (state =3D=3D RUNSTATE_runnable)
+				return;
+
+			if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc2,
+							 gpc2->gpa, user_len2))
+				return;
+
+			goto retry;
+		}
 	}
=20
 	/*
@@ -252,25 +315,23 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v=
, int state)
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
 #endif
=20
-	user_state =3D gpc->khva;
-
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
-		user_times =3D gpc->khva + offsetof(struct vcpu_runstate_info,
-						  state_entry_time);
-	else
-		user_times =3D gpc->khva + offsetof(struct compat_vcpu_runstate_info,
-						  state_entry_time);
-
 	/*
-	 * First write the updated state_entry_time at the appropriate
-	 * location determined by 'offset'.
+	 * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
+	 * field. We need to set it (and write-barrier) before the rest.
 	 */
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
=3D
-		     sizeof(user_times[0]));
+		     sizeof(uint64_t));
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_t=
ime) !=3D
-		     sizeof(user_times[0]));
+		     sizeof(uint64_t));
+	BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) !=3D 0x80);
=20
-	user_times[0] =3D vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	if (user_len1 >=3D times_ofs + sizeof(uint64_t))
+		update_bit =3D ((u8 *)gpc1->khva) + times_ofs + sizeof(u64) - 1;
+	else
+		update_bit =3D ((u8 *)gpc2->khva) + times_ofs + sizeof(u64) - 1 -
+			user_len1;
+
+	*update_bit |=3D (XEN_RUNSTATE_UPDATE >> 56);
 	smp_wmb();
=20
 	/*
@@ -284,7 +345,9 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, =
int state)
 	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=3D
 		     sizeof(vx->current_runstate));
=20
-	*user_state =3D vx->current_runstate;
+	memcpy_to_runstate(gpc1->khva, gpc2->khva, user_len1,
+			   &vx->current_runstate, sizeof(vx->current_runstate),
+			   offsetof(struct vcpu_runstate_info, state));
=20
 	/*
 	 * Write the actual runstate times immediately after the
@@ -299,19 +362,28 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v=
, int state)
 	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=3D
 		     sizeof(vx->runstate_times));
=20
-	memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
-	smp_wmb();
+	memcpy_to_runstate(gpc1->khva, gpc2->khva, user_len1,
+			   vx->runstate_times, sizeof(vx->runstate_times),
+			   times_ofs + sizeof(u64));
=20
+	memcpy_to_runstate(gpc1->khva, gpc2->khva, user_len1,
+			   &vx->runstate_entry_time, sizeof(vx->runstate_entry_time) - 1,
+			   times_ofs);
+	smp_wmb();
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-	user_times[0] &=3D ~XEN_RUNSTATE_UPDATE;
+	*update_bit =3D vx->runstate_entry_time >> 56;
 	smp_wmb();
=20
-	read_unlock_irqrestore(&gpc->lock, flags);
+	if (user_len2)
+		read_unlock_irqrestore(&gpc2->lock, flags);
+	read_unlock_irqrestore(&gpc1->lock, flags);
=20
-	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
+	if (user_len2)
+		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
 }
=20
 static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
@@ -584,23 +656,52 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, stru=
ct kvm_xen_vcpu_attr *data)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
=20
-	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR:
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR: {
+		size_t sz;
+
 		if (!sched_info_on()) {
 			r =3D -EOPNOTSUPP;
 			break;
 		}
 		if (data->u.gpa =3D=3D GPA_INVALID) {
+			r =3D 0;
+		deactivate_out:
 			kvm_gpc_deactivate(vcpu->kvm,
 					   &vcpu->arch.xen.runstate_cache);
-			r =3D 0;
+		deactivate2_out:
+			kvm_gpc_deactivate(vcpu->kvm,
+					   &vcpu->arch.xen.runstate2_cache);
 			break;
 		}
=20
-		r =3D kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
-				     NULL, KVM_HOST_USES_PFN, data->u.gpa,
-				     sizeof(struct vcpu_runstate_info));
+		if (IS_ENABLED(CONFIG_64BIT) && vcpu->kvm->arch.xen.long_mode)
+			sz =3D sizeof(struct vcpu_runstate_info);
+		else
+			sz =3D sizeof(struct compat_vcpu_runstate_info);
+
+		/* Handle structures which cross a page boundary by using two GPCs */
+		if ((data->u.gpa & ~PAGE_MASK) + sz <=3D PAGE_SIZE) {
+			r =3D kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
+					     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+					     sizeof(struct vcpu_runstate_info));
+			goto deactivate2_out;
+		} else {
+			/* Map the end of the first page... */
+			r =3D kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate_cache,
+					     NULL, KVM_HOST_USES_PFN, data->u.gpa,
+					     PAGE_SIZE - (data->u.gpa & ~PAGE_MASK));
+			if (r)
+				goto deactivate2_out;
+			/* ... and the start of the second. */
+			sz -=3D PAGE_SIZE - (data->u.gpa & ~PAGE_MASK);
+			r =3D kvm_gpc_activate(vcpu->kvm, &vcpu->arch.xen.runstate2_cache,
+					     NULL, KVM_HOST_USES_PFN,
+					     (data->u.gpa + PAGE_SIZE) & PAGE_MASK, sz);
+			if (r)
+				goto deactivate_out;
+		}
 		break;
-
+	}
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
 		if (!sched_info_on()) {
 			r =3D -EOPNOTSUPP;
@@ -1834,6 +1935,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
=20
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache);
+	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache);
 }
@@ -1844,6 +1946,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 		kvm_xen_stop_timer(vcpu);
=20
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate_cache);
+	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.runstate2_cache);
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
 	kvm_gpc_deactivate(vcpu->kvm, &vcpu->arch.xen.vcpu_time_info_cache);
=20

--=-Z1ejiCtUMokiG5I+9xiA
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMTE2MjI0OTQyWjAvBgkqhkiG9w0BCQQxIgQgnlKwCnL+
5tWWcZdPBbtsY3EXv8YgG5DHEk/ZKJTXrU4wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAONmGtj5nywvvIKP2SaRz0LTcleHf0hamd
h/tMnIox6JDub1dsoWdoB1wFWjqt8ggvvIJsJtMYnZu5SIWxh4voa8n7jrpPuEHMmuJ5nwHJd1LB
XW3AJvGoVSyedlKZ0L62Ukydwh5M654mo1qspkS4F2iaRqaJNxcVaQ4T2IES0zUzAp0BMPL6TasJ
E4corsMELsQN5ag/jwLWvV/u8SO7y5+qo67QU8+tAfDjJDWODUcmTQJmPjXgH4AdVLN7ys9+9fnz
zqjZ1dk7Ji3Xhg0enkPLMr2BjSaIqgiA+3qCZxZ733jn1sEgv92nR463+x57TbI3D+sSRlv+V4wB
9RhIW6RachM15YxbrtQ0gcRs3ZOK2qEU6Nk0qLZf0m7pEme/KB98MMIQf/8BbhU2KUhT7SldhX3v
KAJYkmqQ1qFvG4LRqcWDoiWQuU1f4J9FUXLeXrpWQaUPr9Y0D8pVKW/O7yV9l6ShVlLjZFZoIeda
Bf9ltT1lV12nIa6jfL2urLAH6L/7iAzOCVCioL3s4NmQoEslA0CQsxkwu8LxBXVsk1lizcuRFacO
zWrCusW9w/mNVx/in3uFCLoH4yBFZDvQ7zuhwEMLdbOCHTyG4xgyMu8W4KeTqyOKD7DagtF/ibRQ
eHeP8DS4juvShcPUFpqENHjmMhLJgaoz9vCDyg15EAAAAAAAAA==


--=-Z1ejiCtUMokiG5I+9xiA--

