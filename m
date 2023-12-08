Return-Path: <kvm+bounces-3900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0071809B29
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 05:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E36E41C20CC0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 04:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2F2523B;
	Fri,  8 Dec 2023 04:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FmG95ClQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB4C10DF;
	Thu,  7 Dec 2023 20:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702010980; x=1733546980;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRbc8jEQsK6Twf+fS79kJj0RpcKvEBd0c38qzLKizrs=;
  b=FmG95ClQIe54FWVvc3yFxeqksYWIK91V0GT3JDNc26rWa2rN/W3/FnMf
   PpPLs2NgjKce7nkfFaN4p+pXG+kVR6n0aKc5+r4PuXx6gu9aa6hQITJvi
   UCXOdmUufAL++dpjFlLFaEhqXmKOTm4zdVemZhxcHfQ7djr/3SDFuK9HI
   vfowd+T6aFg5fyCpDzU/NeQrwl9zb6SjLHNA4G6aMArtgu2wBQUoWAxS3
   1jJCMxLijT3VPmU2pQuC9zrRqh9kR6N8RjiOmYM51zZwPKRunxa6ABlIO
   EvZtTaPljzaFBBhUuzRf1059LhoiAcD6dBdpvFCnilVZt832LqXq+yHj5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="1180700"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="1180700"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 20:49:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10917"; a="765363581"
X-IronPort-AV: E=Sophos;i="6.04,259,1695711600"; 
   d="scan'208";a="765363581"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 20:49:38 -0800
Date: Thu, 7 Dec 2023 20:54:31 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 01/13] x86: Move posted interrupt descriptor out of
 vmx code
Message-ID: <20231207205431.75a214c2@jacob-builder>
In-Reply-To: <87wmtruw87.ffs@tglx>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
	<20231112041643.2868316-2-jacob.jun.pan@linux.intel.com>
	<87wmtruw87.ffs@tglx>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Wed, 06 Dec 2023 17:33:28 +0100, Thomas Gleixner <tglx@linutronix.de>
wrote:

> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> > +/* Posted-Interrupt Descriptor */
> > +struct pi_desc {
> > +	u32 pir[8];     /* Posted interrupt requested */
> > +	union {
> > +		struct {
> > +				/* bit 256 - Outstanding Notification
> > */
> > +			u16	on	: 1,
> > +				/* bit 257 - Suppress Notification */
> > +				sn	: 1,
> > +				/* bit 271:258 - Reserved */
> > +				rsvd_1	: 14;
> > +				/* bit 279:272 - Notification Vector */
> > +			u8	nv;
> > +				/* bit 287:280 - Reserved */
> > +			u8	rsvd_2;
> > +				/* bit 319:288 - Notification
> > Destination */
> > +			u32	ndst; =20
>=20
> This mixture of bitfields and types is weird and really not intuitive:
>=20
> /* Posted-Interrupt Descriptor */
> struct pi_desc {
> 	/* Posted interrupt requested */
> 	u32			pir[8];
>=20
> 	union {
> 		struct {
> 				/* bit 256 - Outstanding Notification */
> 			u64	on	:  1,
> 				/* bit 257 - Suppress Notification */
> 				sn	:  1,
> 				/* bit 271:258 - Reserved */
> 					: 14,
> 				/* bit 279:272 - Notification Vector */
> 				nv	:  8,
> 				/* bit 287:280 - Reserved */
> 					:  8,
> 				/* bit 319:288 - Notification Destination
> */ ndst	: 32;
> 		};
> 		u64		control;
> 	};
> 	u32			rsvd[6];
> } __aligned(64);
>=20
It seems bit-fields cannot pass type check. I got these compile error.

arch/x86/kernel/irq.c: In function =E2=80=98intel_posted_msi_init=E2=80=99:
./include/linux/percpu-defs.h:363:20: error: cannot take address of bit-fie=
ld =E2=80=98nv=E2=80=99
  363 |  __verify_pcpu_ptr(&(variable));     \
      |                    ^
./include/linux/percpu-defs.h:219:47: note: in definition of macro =E2=80=
=98__verify_pcpu_ptr=E2=80=99
  219 |  const void __percpu *__vpp_verify =3D (typeof((ptr) + 0))NULL; \
      |                                               ^~~
./include/linux/percpu-defs.h:490:34: note: in expansion of macro =E2=80=98=
__pcpu_size_call=E2=80=99
  490 | #define this_cpu_write(pcp, val) __pcpu_size_call(this_cpu_write_, =
pcp, val)
      |                                  ^~~~~~~~~~~~~~~~
arch/x86/kernel/irq.c:358:2: note: in expansion of macro =E2=80=98this_cpu_=
write=E2=80=99
  358 |  this_cpu_write(posted_interrupt_desc.nv, POSTED_MSI_NOTIFICATION_V=
ECTOR);
      |  ^~~~~~~~~~~~~~
./include/linux/percpu-defs.h:364:15: error: =E2=80=98sizeof=E2=80=99 appli=
ed to a bit-field
  364 |  switch(sizeof(variable)) {     \
>=20
> > +static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
> > +{
> > +	return test_and_set_bit(POSTED_INTR_ON,
> > +			(unsigned long *)&pi_desc->control); =20
>=20
> Please get rid of those line breaks.
will do.


Thanks,

Jacob

