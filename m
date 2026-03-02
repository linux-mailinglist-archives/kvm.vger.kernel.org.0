Return-Path: <kvm+bounces-72342-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPqDEV9CpWkg7AUAu9opvQ
	(envelope-from <kvm+bounces-72342-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 08:55:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D121C1D4331
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 08:55:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0D8083013DE8
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 07:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BF2387371;
	Mon,  2 Mar 2026 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImjHKrId"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947863859FD;
	Mon,  2 Mar 2026 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438107; cv=none; b=YISyDgbjQ2CqtkH7y53mfyDwogzS2tkHCtOseaZ+Y2y6Ibc1DsryCaUVW2VV+ZskI9BxwDH4KOXgykPGDhtulqCrnD9Lq2T32dLs3yWUzwoegx0Y8ez15HgJPmhH/j/3+DLh37Jqc+YYkDIbewuQm0Ul+vv6URd0mdfcXdwukWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438107; c=relaxed/simple;
	bh=TpSHHOMB+i4iaPaUlJVmKGcvqLj7+j67v8W16M22Nc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t1rngud9hBaL4lgt/vCV+727eb6KPrLlDtjqB46cQ0mN1+c6eLfky7TQWA0A6HIu8l+jhiW+S/pCODgCGoXiXTqAx4sucKd6SnQYX4B1UC8PKnC5WJSW/Lt8IQu+kiJu4tCQGsR1bmRhfRbGz3+6J8jO/U4qHd8ATK7Pj4haXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImjHKrId; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8181C19423;
	Mon,  2 Mar 2026 07:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438107;
	bh=TpSHHOMB+i4iaPaUlJVmKGcvqLj7+j67v8W16M22Nc4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ImjHKrIdoo15tSikWAsezZ9zmWHDO6VGBVoSqiP2coKiypFMXFUQjAF0i2d1xi4xN
	 tRzNS4Sg4dyzE1mz6b9uakWZPbSJcKcl77IgnWyH5mvWK9ZC+UKn73Aq3zx9NSGUVY
	 HrVcG87kXYw0i6utiq7NHNfuLgg2sP6vGGnpGzvzK/UqkE3oxrZcMzQ6+zeOrMDIn+
	 V7VOirFzBKNg39OpP4HUx6sPZl5IpXLNBCpbPqOjYGh0NarJUr0jwW7yV8qjcatDOY
	 lvFN5ONLkqbjf7w612WT58JnVSiSzOf+21r2l8ww3pC8D7brwNZq5A5+oUQZm9TYfm
	 nNmRGvVyzcvxA==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>,
	linux-coco@lists.linux.dev, iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP
 devices
In-Reply-To: <20260225053806.3311234-5-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-5-aik@amd.com>
Date: Mon, 02 Mar 2026 13:24:47 +0530
Message-ID: <yq5acy1mu0mw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72342-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email]
X-Rspamd-Queue-Id: D121C1D4331
X-Rspamd-Action: no action

Alexey Kardashevskiy <aik@amd.com> writes:

> SWIOTLB is enforced when encrypted guest memory is detected
> in pci_swiotlb_detect() which is required for legacy devices.
>
> Skip SWIOTLB for TDISP devices.
>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  include/linux/swiotlb.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 3dae0f592063..119c25d639a7 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -173,6 +173,15 @@ static inline bool is_swiotlb_force_bounce(struct de=
vice *dev)
>  {
>  	struct io_tlb_mem *mem =3D dev->dma_io_tlb_mem;
>=20=20
> +	/*
> +	 * CC_ATTR_GUEST_MEM_ENCRYPT enforces SWIOTLB_FORCE in
> +	 * swiotlb_init_remap() to allow legacy devices access arbitrary
> +	 * VM encrypted memory.
> +	 * Skip it for TDISP devices capable of DMA-ing the encrypted memory.
> +	 */
> +	if (device_cc_accepted(dev))
> +		return false;
> +
>  	return mem && mem->force_bounce;
>  }
>=20=20


I=E2=80=99m wondering whether we need more than that. Perhaps we could start
with a simpler assumption: a TDISP-capable device will never require
SWIOTLB bouncing. That would significantly simplify the DMA allocation
path for T=3D1.

Without this assumption, we might need to implement a private
io_tlb_mem.

We should also avoid supporting TDISP mode on devices that require
things like restricted-memory SWIOTLB pool.

Something like:

modified   arch/arm64/mm/mem_encrypt.c
@@ -18,6 +18,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
+#include <linux/device.h>
=20
 static const struct arm64_mem_crypt_ops *crypt_ops;
=20
@@ -53,3 +54,12 @@ int set_memory_decrypted(unsigned long addr, int numpage=
s)
 	return crypt_ops->decrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
+bool force_dma_unencrypted(struct device *dev)
+{
+	if (device_cc_accepted(dev))
+		return false;
+
+	return is_realm_world();
+}
+EXPORT_SYMBOL_GPL(force_dma_unencrypted);
modified   include/linux/swiotlb.h
@@ -173,6 +173,11 @@ static inline bool is_swiotlb_force_bounce(struct devi=
ce *dev)
 {
 	struct io_tlb_mem *mem =3D dev->dma_io_tlb_mem;
=20
+	if (device_cc_accepted(dev)) {
+		dev_warn_once(dev, "(TIO) Disable SWIOTLB");
+		return false;
+	}
+
 	return mem && mem->force_bounce;
 }
=20
@@ -287,6 +292,9 @@ bool swiotlb_free(struct device *dev, struct page *page=
, size_t size);
=20
 static inline bool is_swiotlb_for_alloc(struct device *dev)
 {
+	if (device_cc_accepted(dev))
+		return false;
+
 	return dev->dma_io_tlb_mem->for_alloc;
 }
 #else
modified   kernel/dma/direct.c
@@ -159,6 +159,14 @@ static struct page *__dma_direct_alloc_pages(struct de=
vice *dev, size_t size,
  */
 static bool dma_direct_use_pool(struct device *dev, gfp_t gfp)
 {
+	/*
+	 * Atomic pools are marked decrypted and are used if we require require
+	 * updation of pfn mem encryption attributes or for DMA non-coherent
+	 * device allocation. Both is not true for trusted device.
+	 */
+	if (device_cc_accepted(dev))
+		return false;
+
 	return !gfpflags_allow_blocking(gfp) && !is_swiotlb_for_alloc(dev);
 }
=20
modified   kernel/dma/swiotlb.c
@@ -1643,6 +1643,9 @@ bool is_swiotlb_active(struct device *dev)
 {
 	struct io_tlb_mem *mem =3D dev->dma_io_tlb_mem;
=20
+	if (device_cc_accepted(dev))
+		return false;
+
 	return mem && mem->nslabs;
 }
=20


