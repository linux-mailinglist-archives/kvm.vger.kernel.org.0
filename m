Return-Path: <kvm+bounces-12218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F969880D19
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF78F285130
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181E338DD7;
	Wed, 20 Mar 2024 08:33:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7191D1E515;
	Wed, 20 Mar 2024 08:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710923613; cv=none; b=eRGfG3Dt5FuGTMxrPmPYpWUmyCN5LXxjxW5cXT7rJuWLDHwkfTOr3ZrVOYBYzOYX0TQXgmC+kS1ohAKXNOievFaGbH/Qec2TkjILcRSYVv5aVJPM8ltdbkXQTQ7ped1ERagf2zbH21ynM02gBXAvz2bEdEsGKzJyApXKkhBgSgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710923613; c=relaxed/simple;
	bh=MPqS9o9buH0oXOAQqPvPmOIaMtnY1fNPe/ZaWmypGdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoEvIvSkSwxIq4yC4mr1dtN+pckfuZ2TIb7fSUDmUVniO6G3OedjIgAOqSdW4GDyqIzkDsLwJ9EqqFT7HJ2AIKA/XDIPX91WC55rhfDuWtB12jw+Tb7eI4B/lsGjF4mXE6GUJMFbMC3svVAbxenaNa4P/uo8WmUDJBgsBYIHeBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 234862800B3F1;
	Wed, 20 Mar 2024 09:33:22 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0712A5FC4CE; Wed, 20 Mar 2024 09:33:22 +0100 (CET)
Date: Wed, 20 Mar 2024 09:33:21 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, linuxarm@huawei.com,
	David Box <david.e.box@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, "Li, Ming" <ming4.li@intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Message-ID: <ZfqfUaWko_Dzx020@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
 <5d0e75-993c-3978-8ccf-60bfb7cac10@linux.intel.com>
 <20240209203204.GA5850@wunner.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240209203204.GA5850@wunner.de>

On Fri, Feb 09, 2024 at 09:32:04PM +0100, Lukas Wunner wrote:
> On Tue, Oct 03, 2023 at 01:35:26PM +0300, Ilpo Järvinen wrote:
> > On Thu, 28 Sep 2023, Lukas Wunner wrote:
> > > +	spdm_state->responder_caps = le32_to_cpu(rsp->flags);
> > 
> > Earlier, unaligned accessors where used with the version_number_entries.
> > Is it intentional they're not used here (I cannot see what would be 
> > reason for this difference)?
> 
> Thanks, good catch.  Indeed this is not necessarily naturally aligned
> because the GET_CAPABILITIES request and response succeeds the
> GET_VERSION response in the same allocation.  And the GET_VERSION
> response size is a multiple of 2, but not always a multiple of 4.

Actually, scratch that.

I've realized that since all the SPDM request/response structs are
declared __packed, the alignment requirement for the struct members
becomes 1 byte and hence they're automatically accessed byte-wise on
arches which require that:

https://stackoverflow.com/questions/73152859/accessing-unaligned-struct-member-using-pointers#73154825

E.g. this line...

        req->data_transfer_size = cpu_to_le32(spdm_state->transport_sz);

...becomes this on arm 32-bit (multi_v4t_defconfig)...

        ldr        r3, [r5, #0x1c]   ; load spdm_state->transport_sz into r3
        lsr        r2, r3, lsr #8    ; right-shift r3 into r2 by 8 bits
        strb       r3, [r7, #0xc]    ; copy lowest byte from r3 into request
        strb       r2, [r7, #0xd]    ; copy next byte from r2 into request
        lsr        r2, r3, lsr #16   ; right-shift r3 into r2 by 16 bits
        lsr        r3, r3, lsr #24   ; right-shift r3 into r3 by 24 bits
        strb       r2, [r7, #0xe]    ; copy next byte from r2 into request
        strb       r3, [r7, #0xf]    ; copy next byte from r3 into request

...and it becomes this on x64_64, which has no alignment requirements:

        mov        eax, dword [r15+0x40] ; load spdm_state->transport_sz
        mov        dword [r12+0xc], eax  ; copy into request

So for __packed structs, get_unaligned_*() / put_unaligned_*() accessors
are not necessary and I will drop them when respinning.

Thanks,

Lukas

