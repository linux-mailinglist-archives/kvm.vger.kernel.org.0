Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9E74536ED
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhKPQKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbhKPQKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 11:10:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48030C061767
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 08:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1Yo3H2hAQJrInO1ZgOXKFv4MkPBbS8M/agH4Bqfu+m4=; b=n8MfBPMsjBptNAuWdesgSfbMxW
        pMfyXhmefwCfLvE74pnifJ6oiKGN3D6w/ZTzihurw9e7gHK8YJ3ZOlD3IBMiunzDDvKX1V74MV2BB
        aFt/fYjg96xGf3rDsQNg8maNdcgiw6iLHZZUYS/TRrmqltbE9kKvCJSIOUvxTtldGST1StopupK0w
        cCEAThJU5peV1wn9u/ORPBP+v/JZrrRwy5HAUwJjzdfOaXJ3g8Q5/z2uNqLpHLjzNJ6+8lNKExT83
        9AgFd3TAwnBRzxFDY6VjZyuM5zZ4t3cKgzJXICDKUtpGbIQSd0ZfL3RFL4aGUV44Q9oDrydSrOyWm
        RY67dHGw==;
Received: from 54-240-197-233.amazon.com ([54.240.197.233] helo=freeip.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mn0z1-002H7m-Oy; Tue, 16 Nov 2021 16:06:56 +0000
Message-ID: <9733f477bada4cc311078be529b7118f1dec25bb.camel@infradead.org>
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
Date:   Tue, 16 Nov 2021 16:06:52 +0000
In-Reply-To: <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
References: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
         <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
         <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
         <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
         <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
         <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
         <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
         <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
         <2c7eee5179d67694917a5a0d10db1bce24af61bf.camel@infradead.org>
         <537a1d4e-9168-cd4a-cd2f-cddfd8733b05@redhat.com>
         <YZLmapmzs7sLpu/L@google.com>
         <57d599584ace8ab410b9b14569f434028e2cf642.camel@infradead.org>
         <94bb55e117287e07ba74de2034800da5ba4398d2.camel@infradead.org>
         <04bf7e8b-d0d7-0eb6-4d15-bfe4999f42f8@redhat.com>
         <19bf769ef623e0392016975b12133d9a3be210b3.camel@infradead.org>
         <ad0648ac-b72a-1692-c608-b37109b3d250@redhat.com>
         <126b7fcbfa78988b0fceb35f86588bd3d5aae837.camel@infradead.org>
         <02cdb0b0-c7b0-34c5-63c1-aec0e0b14cf7@redhat.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-ecP7w5JgpRvjmfwRhIZI"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-ecP7w5JgpRvjmfwRhIZI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-11-16 at 16:49 +0100, Paolo Bonzini wrote:
> On 11/16/21 16:09, David Woodhouse wrote:
> > On Tue, 2021-11-16 at 15:57 +0100, Paolo Bonzini wrote:
> > > This should not be needed, should it?  As long as the gfn-to-pfn
> > > cache's vcpu field is handled properly, the request will just cause
> > > the vCPU not to enter.
> >=20
> > If the MMU mappings never change, the request never happens. But the
> > memslots *can* change, so it does need to be revalidated each time
> > through I think?
>=20
> That needs to be done on KVM_SET_USER_MEMORY_REGION, using the same=20
> request (or even the same list walking code) as the MMU notifiers.

Hm....  kvm_arch_memslots_updated() is already kicking every vCPU after
the update, and although that was asynchronous it was actually OK
because unlike in the MMU notifier case, that page wasn't actually
going away =E2=80=94 and if that HVA *did* subsequently go away, our HVA-ba=
sed
notifier check would still catch that and kill it synchronously.

But yes, we *could* come up with a wakeup mechanism which does it that
way.


> > > It would have to take the gpc->lock around
> > > changes to gpc->vcpu though (meaning: it's probably best to add a
> > > function gfn_to_pfn_cache_set_vcpu).
> >=20
> > Hm, in my head that was never going to *change* for a given gpc; it
> > *belongs* to that vCPU for ever (and was even part of vmx->nested. for
> > that vCPU, to replace e.g. vmx->nested.pi_desc_map).
>=20
> Ah okay, I thought it would be set in nested vmentry and cleared in=20
> nested vmexit.

I don't think it needs to be proactively cleared; we just don't
*refresh* it until we need it again.

> > +static void nested_vmx_check_guest_maps(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> > +	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +	struct gfn_to_pfn_cache *gpc;
> > +
> > +	bool valid;
> > +
> > +	if (nested_cpu_has_posted_intr(vmcs12)) {
> > +		gpc =3D &vmx->nested.pi_desc_cache;
> > +
> > +		read_lock(&gpc->lock);
> > +		valid =3D kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc,
> > +						   vmcs12->posted_intr_desc_addr,
> > +						   PAGE_SIZE);
> > +		read_unlock(&gpc->lock);
> > +		if (!valid) {
> > +			/* XX: This isn't idempotent. Make it so, or use a different
> > +			 * req for the 'refresh'. */
> > +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> > +			return;
> > +		}
> > +	}
> > +}
>=20
> That's really slow to do on every vmentry.

It probably doesn't have to be.

Ultimately, all it *has* to check is that kvm->memslots->generation
hasn't changed since the caches were valid. That can surely be made
fast enough?

If we *know* the GPA and size haven't changed, and if we know that
gpc->valid becoming false would have been handled differently, then we
could optimise that whole thing away quite effectively to a single
check on ->generations?

> > So nested_get_vmcs12_pages() certainly isn't idempotent right now
> > because of all the kvm_vcpu_map() calls, which would just end up
> > leaking =E2=80=94 but I suppose the point is to kill all those, and the=
n maybe
> > it will be?
>=20
> Yes, exactly.  That might be a larger than normal patch, but it should=
=20
> not be one too hard to review.  Once there's something that works, we=20
> can think of how to split (if it's worth it).

This one actually compiles. Not sure we have any test cases that will
actually exercise it though, do we?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 465455334c0c..9f279d08e570 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1510,6 +1510,7 @@ struct kvm_x86_nested_ops {
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+	void (*check_guest_maps)(struct kvm_vcpu *vcpu);
 };
=20
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 280f34ea02c3..f67751112633 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -309,7 +309,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page =3D NULL;
 	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vmx->nested.virtual_apic_cache);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc =3D NULL;
=20
@@ -3170,10 +3170,12 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu=
 *vcpu)
 	}
=20
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		map =3D &vmx->nested.virtual_apic_map;
+		struct gfn_to_pfn_cache *gpc =3D &vmx->nested.virtual_apic_cache;
=20
-		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->virtual_apic_page_addr), map)=
) {
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(map->pfn));
+		if (!kvm_gfn_to_pfn_cache_init(vcpu->kvm, gpc, vcpu, true,
+					       vmcs12->virtual_apic_page_addr,
+					       PAGE_SIZE, true)) {
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(gpc->pfn));
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
 		           nested_cpu_has(vmcs12, CPU_BASED_CR8_STORE_EXITING) &&
 			   !nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
@@ -3198,6 +3200,9 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *=
vcpu)
 	if (nested_cpu_has_posted_intr(vmcs12)) {
 		map =3D &vmx->nested.pi_desc_map;
=20
+		if (kvm_vcpu_mapped(map))
+			kvm_vcpu_unmap(vcpu, map, true);
+
 		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->posted_intr_desc_addr), map))=
 {
 			vmx->nested.pi_desc =3D
 				(struct pi_desc *)(((void *)map->hva) +
@@ -3242,6 +3247,29 @@ static bool vmx_get_nested_state_pages(struct kvm_vc=
pu *vcpu)
 	return true;
 }
=20
+static void nested_vmx_check_guest_maps(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
+	struct gfn_to_pfn_cache *gpc;
+
+	int valid;
+
+	if (nested_cpu_has_posted_intr(vmcs12)) {
+		gpc =3D &vmx->nested.virtual_apic_cache;
+
+		read_lock(&gpc->lock);
+		valid =3D kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc,
+						   vmcs12->virtual_apic_page_addr,
+						   PAGE_SIZE);
+		read_unlock(&gpc->lock);
+		if (!valid) {
+			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+			return;
+		}
+	}
+}
+
 static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
@@ -3737,9 +3765,15 @@ static int vmx_complete_nested_posted_interrupt(stru=
ct kvm_vcpu *vcpu)
=20
 	max_irr =3D find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256)=
;
 	if (max_irr !=3D 256) {
-		vapic_page =3D vmx->nested.virtual_apic_map.hva;
-		if (!vapic_page)
+		struct gfn_to_pfn_cache *gpc =3D &vmx->nested.virtual_apic_cache;
+
+		read_lock(&gpc->lock);
+		if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE)) {
+			read_unlock(&gpc->lock);
 			goto mmio_needed;
+		}
+
+		vapic_page =3D gpc->khva;
=20
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3749,6 +3783,7 @@ static int vmx_complete_nested_posted_interrupt(struc=
t kvm_vcpu *vcpu)
 			status |=3D (u8)max_irr;
 			vmcs_write16(GUEST_INTR_STATUS, status);
 		}
+		read_unlock(&gpc->lock);
 	}
=20
 	nested_mark_vmcs12_pages_dirty(vcpu);
@@ -4569,7 +4604,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_=
exit_reason,
 		kvm_release_page_clean(vmx->nested.apic_access_page);
 		vmx->nested.apic_access_page =3D NULL;
 	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vmx->nested.virtual_apic_cache);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
 	vmx->nested.pi_desc =3D NULL;
=20
@@ -6744,4 +6779,5 @@ struct kvm_x86_nested_ops vmx_nested_ops =3D {
 	.write_log_dirty =3D nested_vmx_write_pml_buffer,
 	.enable_evmcs =3D nested_enable_evmcs,
 	.get_evmcs_version =3D nested_get_evmcs_version,
+	.check_guest_maps =3D nested_vmx_check_guest_maps,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba66c171d951..6c61faef86d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3839,19 +3839,23 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *v=
cpu)
 static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
-	void *vapic_page;
+	struct gfn_to_pfn_cache *gpc =3D &vmx->nested.virtual_apic_cache;
 	u32 vppr;
 	int rvi;
=20
 	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
 		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
-		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn))
+		WARN_ON_ONCE(gpc->gpa =3D=3D GPA_INVALID))
 		return false;
=20
 	rvi =3D vmx_get_rvi();
=20
-	vapic_page =3D vmx->nested.virtual_apic_map.hva;
-	vppr =3D *((u32 *)(vapic_page + APIC_PROCPRI));
+	read_lock(&gpc->lock);
+	if (!kvm_gfn_to_pfn_cache_check(vcpu->kvm, gpc, gpc->gpa, PAGE_SIZE))
+		vppr =3D *((u32 *)(gpc->khva + APIC_PROCPRI));
+	else
+		vppr =3D 0xff;
+	read_unlock(&gpc->lock);
=20
 	return ((rvi & 0xf0) > (vppr & 0xf0));
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4df2ac24ffc1..8364e7fc92a0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -195,7 +195,7 @@ struct nested_vmx {
 	 * pointers, so we must keep them pinned while L2 runs.
 	 */
 	struct page *apic_access_page;
-	struct kvm_host_map virtual_apic_map;
+	struct gfn_to_pfn_cache virtual_apic_cache;
 	struct kvm_host_map pi_desc_map;
=20
 	struct kvm_host_map msr_bitmap_map;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a689bb62e9e..a879e4d08758 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9735,6 +9735,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
=20
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+		if (kvm_check_request(KVM_REQ_GPC_INVALIDATE, vcpu))
+			; /* Nothing to do. It just wanted to wake us */
 	}
=20
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -9781,6 +9783,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	vcpu->mode =3D IN_GUEST_MODE;
=20
+	/*
+	 * If the guest requires direct access to mapped L1 pages, check
+	 * the caches are valid. Will raise KVM_REQ_GET_NESTED_STATE_PAGES
+	 * to go and revalidate them, if necessary.
+	 */
+	if (is_guest_mode(vcpu) && kvm_x86_ops.nested_ops->check_guest_maps)
+		kvm_x86_ops.nested_ops->check_guest_maps(vcpu);
+
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
=20
 	/*

--=-ecP7w5JgpRvjmfwRhIZI
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEx
MTE2MTYwNjUyWjAvBgkqhkiG9w0BCQQxIgQgLGidaKa3SFSL9dZnn6abCfCQ0cI2544MeuHihU8F
Gnwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAG0OksvP96USQqWzKF1ytM8I7JNA5KXg8xnH2EZ82OwDnqskTxn3vRrjYlryweWA
ZMVV1PaWorwXFD6nUu46KRabeRhDxk38U6N+1oh/aq6b4wEYneOD4JidY6/5QTRUG5Rmf+ynd/ow
RVZvtqEvLRYXf/CBH86BF6Mx7ZA5OK0gewfUl+XCENSexDF82j/tOtoP2qIgGYP9jxWBAJ5N1Ep4
psz1E8oVm0/IyOaJj12Kz80rsXdCCwv+4BIFHym+baRJpH6kFDth8VfhCbYZLUCUZXJ6jpq6yPg4
zLPKbDIGg7yAH28l36c1in16Rc0HXtVBhB5nlGt+APJVMBzxxsgAAAAAAAA=


--=-ecP7w5JgpRvjmfwRhIZI--

