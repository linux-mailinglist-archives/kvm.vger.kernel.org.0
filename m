Return-Path: <kvm+bounces-32759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE8F9DBB04
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 17:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB9F916087D
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DBC1BD9FF;
	Thu, 28 Nov 2024 16:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZHiQsPrE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39CD1BD9CB;
	Thu, 28 Nov 2024 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732810093; cv=none; b=uA0Le7xl2GWpHeDY55hlbnZed3ZCicE+Hf2IxzQdyLnt6zzJxhGWKovcL5l+Xq2BydHwEXDCKVjGMVIbRFGVqlL4w0lMTLBddsymauAryC+s/Xe+hD8WtFAwXyi6mkF/l2ZU6CI3ofU3u5/cWXSGAU0yNLu4oZG4I5Ih4ngFLQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732810093; c=relaxed/simple;
	bh=EXr/Xa4IzkrMZ/1Uwppwz8/I/eKNWK/N7JTkg3JjU0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYXw6Xia9GVCqGkj0Ap7BX6sqsrexeGIv1737DdKTpFoHb77MYbpr0IRrgo/XFfWRlqizuJF+EzqdoBepJYF1++8zQ4eJ01KNBOoqYWEWuk6jbLZVWZ5HPfed1Q8M1S2Ts+0qOOiXZKsocN8+NN9wreXyWfuQAAn0VIMdG/vRX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZHiQsPrE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1F7AD40E015E;
	Thu, 28 Nov 2024 16:08:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JEf4IJx5ofLC; Thu, 28 Nov 2024 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732810083; bh=tBvIZsR8D+2ZYbu6rMifmZidC/N+3RXk90l43tBthoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHiQsPrEmGchPW6AX34zhC0DXJifHmYraIbuw2eGIlUSIBdvs2x0Txyzcllihy0le
	 O/ZcEuRB2/1I3BfoMe2Z6UDamwe+oRMBylPyoKQV+nZcUULKtfPjdVh0yY86ATetYf
	 num6/FfOS7BwPqxtdAEQZS8ttdL+eXiIn0G+WaU25rUy/85kZR1tu4Lm3F9h9DUmlf
	 VVvqIgON5qAq1899eUJKEDSEX2Sc3d3Tq1vH9ufEDLP2BwLwUhUsHHPA4/xWMJy/Qs
	 VTbR7Soxca7BCmUQFtu9oSHkeoWC6XR3KXUqjqIx7wevdtdjBQunv3pLfmh/vqpdDE
	 mU22AlQb8USSUWRFbbH15ZsbAe79YudL81DRhScjyLZCxG4dh0ML8PRZ2MPmH1u3Mq
	 nW6ZdlRNN1C7V30cFMkOhYIclVZnQulD7rVFZgQ2M3rMTlS2nADnJK6NZUgIQ/Yu4u
	 7bneZKZnezhTjAp+cTf93wlPE7iJVh4FoXkG4c8yrHWQo1Dei8r4TPfw2ESX4HqvB8
	 LtcwNCbrCZs3B+U/8R2wvge5ZavvVuMNwe9Wrj3n3LEm+ewNz2nF4pB+8YbxDk7/z6
	 xDUApg/qq3yO+lsH0B38ZLLhsBOwOsJ6eWh7J/cMlIJ5jos9vYNM7e4EuzS59tNKVO
	 iQWU8ByhfllLt/Cj7lBQs/RE=
Received: from zn.tnic (p200300ea9736A177329C23fffea6A903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a177:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A0AC240E0274;
	Thu, 28 Nov 2024 16:07:49 +0000 (UTC)
Date: Thu, 28 Nov 2024 17:07:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>,
	Roy Hopkins <roy.hopkins@suse.com>
Subject: Re: [RFC PATCH 1/7] KVM: SVM: Implement GET_AP_APIC_IDS NAE event
Message-ID: <20241128160742.GAZ0iVTp1thcQA5jFM@fat_crate.local>
References: <cover.1724795970.git.thomas.lendacky@amd.com>
 <e60f352abde6bfa9c989d63213d4fb04c3721c11.1724795971.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e60f352abde6bfa9c989d63213d4fb04c3721c11.1724795971.git.thomas.lendacky@amd.com>

On Tue, Aug 27, 2024 at 04:59:25PM -0500, Tom Lendacky wrote:
> @@ -4124,6 +4130,77 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  	return 1; /* resume guest */
>  }
>  
> +struct sev_apic_id_desc {
> +	u32	num_entries;

"count" - like in the spec. :-P

> +	u32	apic_ids[];
> +};
> +
> +static void sev_get_apic_ids(struct vcpu_svm *svm)
> +{
> +	struct ghcb *ghcb = svm->sev_es.ghcb;
> +	struct kvm_vcpu *vcpu = &svm->vcpu, *loop_vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned int id_desc_size;
> +	struct sev_apic_id_desc *desc;
> +	kvm_pfn_t pfn;
> +	gpa_t gpa;
> +	u64 pages;
> +	unsigned long i;
> +	int n;
> +
> +	pages = vcpu->arch.regs[VCPU_REGS_RAX];

Probably should be "num_pages" and a comment should explain what it is:

"State to Hypervisor: is the
number of guest contiguous pages
provided to hold the list of APIC
IDs"

Makes it much easier to follow the code.

> +	/* Each APIC ID is 32-bits in size, so make sure there is room */
> +	n = atomic_read(&kvm->online_vcpus);
> +	/*TODO: is this possible? */
> +	if (n < 0)
> +		return;

It doesn't look like it but if you wanna be real paranoid you can slap
a WARN_ONCE() here or so to scream loudly.

> +	id_desc_size = sizeof(*desc);
> +	id_desc_size += n * sizeof(desc->apic_ids[0]);
> +	if (id_desc_size > (pages * PAGE_SIZE)) {
> +		vcpu->arch.regs[VCPU_REGS_RAX] = PFN_UP(id_desc_size);
> +		return;
> +	}
> +
> +	gpa = svm->vmcb->control.exit_info_1;
> +
> +	ghcb_set_sw_exit_info_1(ghcb, 2);
> +	ghcb_set_sw_exit_info_2(ghcb, 5);

Uuh, more magic numbers. I guess we need this:

https://lore.kernel.org/r/20241113204425.889854-1-huibo.wang@amd.com

and more.

And can we write those only once at the end of the function?

> +	if (!page_address_valid(vcpu, gpa))
> +		return;
> +
> +	pfn = gfn_to_pfn(kvm, gpa_to_gfn(gpa));

Looking at the tree, that gfn_to_pfn() thing is gone now and we're supposed to
it this way.  Not tested ofc:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5af227ba15a3..47e1f72a574d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4134,7 +4134,7 @@ static void sev_get_apic_ids(struct vcpu_svm *svm)
 	struct kvm *kvm = vcpu->kvm;
 	unsigned int id_desc_size;
 	struct sev_apic_id_desc *desc;
-	kvm_pfn_t pfn;
+	struct page *page;
 	gpa_t gpa;
 	u64 pages;
 	unsigned long i;
@@ -4163,8 +4163,8 @@ static void sev_get_apic_ids(struct vcpu_svm *svm)
 	if (!page_address_valid(vcpu, gpa))
 		return;
 
-	pfn = gfn_to_pfn(kvm, gpa_to_gfn(gpa));
-	if (is_error_noslot_pfn(pfn))
+	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+	if (!page)
 		return;
 
 	if (!pages)

> +	if (is_error_noslot_pfn(pfn))
> +		return;
> +
> +	if (!pages)
> +		return;

That test needs to go right under the assignment of "pages".

> +	/* Allocate a buffer to hold the APIC IDs */
> +	desc = kvzalloc(id_desc_size, GFP_KERNEL_ACCOUNT);
> +	if (!desc)
> +		return;
> +
> +	desc->num_entries = n;
> +	kvm_for_each_vcpu(i, loop_vcpu, kvm) {
> +		/*TODO: is this possible? */

Well:

#define kvm_for_each_vcpu(idx, vcpup, kvm)                 \
        xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, \
                          (atomic_read(&kvm->online_vcpus) - 1))
			   ^^^^^^^^^^^^^^

but, what's stopping kvm_vm_ioctl_create_vcpu() from incrementing it?

I'm guessing this would happen when you start the guest only but I haz no
idea.

> +		if (i > n)
> +			break;
> +
> +		desc->apic_ids[i] = loop_vcpu->vcpu_id;
> +	}
> +
> +	if (!kvm_write_guest(kvm, gpa, desc, id_desc_size)) {
> +		/* IDs were successfully written */
> +		ghcb_set_sw_exit_info_1(ghcb, 0);
> +		ghcb_set_sw_exit_info_2(ghcb, 0);
> +	}
> +
> +	kvfree(desc);
> +}


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

