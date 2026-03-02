Return-Path: <kvm+bounces-72341-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UFqFDCY1pWmh5gUAu9opvQ
	(envelope-from <kvm+bounces-72341-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 07:58:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C31F11D3A31
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 07:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9FDEC3018C0F
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 06:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F133815D7;
	Mon,  2 Mar 2026 06:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZifj2He"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88443201004;
	Mon,  2 Mar 2026 06:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434708; cv=none; b=rB5NahE+KADceT2E33rv8vFJc1O6RQAqH5KyPUwJUj/wYiV2JBK+RWVnM9dk+rUstZbJtVVkQMoDFH7Qx5FTI9WTUZvc+LfzcCuW4hx7u0P8u2hwXfPnTrxSD0edK+D6mJ2Sex9EK9msFmXA2hdJ7c9yutpwA0GzU4Vnsx8f7dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434708; c=relaxed/simple;
	bh=QuE/TCSzAlqPVDJUGj0JHRDKd+76fYi6RJN1xDSWzNc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rEB7H2CgED9CkeIpCDuZ+Dcz0niVr5M/NTqmCYnuUqPx5miXWdkEB7WFoWoEkuT4suqhkGDc32gJHwZ/hSwZSjM+hvNHuhLzmyzl615L60q2/KS0g9+rHpQ6fczoJUJkiTkjvh4PAg3T4XD9yaU+Pl1FPoQRBAVo9y1/lRMguZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZifj2He; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D62BC19423;
	Mon,  2 Mar 2026 06:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772434708;
	bh=QuE/TCSzAlqPVDJUGj0JHRDKd+76fYi6RJN1xDSWzNc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OZifj2Heh2DmSYpOSLto0qL7rXlaSTJ2G5yJ2ss4heuQdoO4Twftcgmr3l8y9BiTZ
	 AelS3AWCJQazEYl4vnWh6Q4bBV60oiOcTrTzTs9tKS17WNqcGyjsp9p2ba447pJ2VC
	 a+GzTYsuhU+KXm6ktaBKunKT7j5Bq56zQWvtGJkdTBpvnK4esZdvHuBSF00rZl14Q7
	 fS4JccZPf3vKR0DLFGJAqT06mJDDLYMAuJO+BdB09PWjvw9569MYO36qqmIAtniuwV
	 E7bHSSXILvQWuPXEwgXKHjLGReLpiqSAzAYfmkzbIdaZgkCTSGjS7Fjp78ffZwSi55
	 7W8/TZCIyMb5A==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: dan.j.williams@intel.com, Alexey Kardashevskiy <aik@amd.com>,
	x86@kernel.org
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
Subject: Re: [PATCH kernel 2/9] pci/tsm: Add tsm_tdi_status
In-Reply-To: <699e97d6e8be7_1cc51003c@dwillia2-mobl4.notmuch>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-3-aik@amd.com>
 <699e97d6e8be7_1cc51003c@dwillia2-mobl4.notmuch>
Date: Mon, 02 Mar 2026 12:28:10 +0530
Message-ID: <yq5afr6iu399.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72341-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aneesh.kumar@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:email,intel.com:email]
X-Rspamd-Queue-Id: C31F11D3A31
X-Rspamd-Action: no action

<dan.j.williams@intel.com> writes:

> Alexey Kardashevskiy wrote:
>> Define a structure with all info about a TDI such as TDISP status,
>> bind state, used START_INTERFACE options and the report digest.
>> 
>> This will be extended and shared to the userspace.
>> 
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>> 
>> Make it uapi? We might want a sysfs node per a field so probably not.
>> For now its only user is AMD SEV TIO with a plan to expose this struct
>> as a whole via sysfs.
>
> Say more about what this uapi when sysfs already has lock+accept
> indications?
>
> Or are you just talking about exporting the TDISP report as a binary
> blob?
>
> I think the kernel probably wants a generic abstraction for asserting
> that the tsm layer believes the report remains valid between fetch and
> run. In other words I am not sure arch features like intf_report_counter
> ever show up anywhere in uapi outside of debugfs.
>

Agreed. For CCA, we use rsi_vdev_info, but we need a generic mechanism
to associate this with the report that the guest has attested.

In CCA, we call rsi_vdev_get_info(vdev_id, dev_info) and later use that
information in rsi_vdev_enable_dma(vdev_id, dev_info).

Perhaps we could add a generation number (or meas_nonce) to the TSM
netlink response and use it when accepting the device, so we can
reliably bind the device measurement to the attested one?

-aneesh

