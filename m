Return-Path: <kvm+bounces-33720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 287779F0982
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 11:31:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B212188C9F5
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 10:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9971C3BE2;
	Fri, 13 Dec 2024 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwAmFDLe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861481B6CFD;
	Fri, 13 Dec 2024 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734085856; cv=none; b=ExWiUu+qloeSOTopfgIQ9bPgCOOylAEjCHTZrBRaZpNeLCL4dnSX2ydekr6qxtmiZkMZnaEakQhRa1z2Cma+cCgVmK+aNVFtVA/CPkIpNL/SDJomq/gJUJFPZSmQiTPzwAEtWoMC1yMsFSg6/aq863ygOIvMH9+ArmeNWzMJE3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734085856; c=relaxed/simple;
	bh=BTQhG+pcPpVWdFU7M6WGNSEHiOAWlPk9OMovbRGe8jk=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=dnKbCgMEx1TUk/UVLXfkPV6OB9XV2Fse775L3/C86brW6n5/9Ax5EqtJDZ7F9AxqcmUF1IwI9wRjUcktS2q+fO2FtqFG2HaoHwFDqlDlRq6Yv+yKAoetO4sb16Z8KJQqxCGiND+c9GM/a1SvPK1W0UfXn8jxQ9lBz8mTmQ5H6kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwAmFDLe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65922C4CED0;
	Fri, 13 Dec 2024 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734085855;
	bh=BTQhG+pcPpVWdFU7M6WGNSEHiOAWlPk9OMovbRGe8jk=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=KwAmFDLewAK8qtG2JcgTDln5oAPvX7T6s21n+sVrQK/zovEQltlKTZMfOOydVCYBZ
	 wexQmXSVYI3h7TBHmpxxuKJCAtIKDA3xJNa8/Im/UBR7LXeWQh180GN2AD0v8T0VFC
	 xau4jIIld3rUWglJe0O5Ly1c3n+LVRPKkn4Ap2bFPikm9rfX1t0FvFxCEdhmOO7GmQ
	 T1Kv1o7hm5xTuEGg8jC3v4laVOub2r/1lqEAAYkD9VqHdQWO6/vYMu4tQswLjScRFC
	 qcBNgWj6+WXQRdmWrvKriaNXsmUfp6QHYu1lvvdq1sD36YHJ/Kyex37L0CjkCkv8o5
	 SYIrwECkF64TQ==
From: Kalle Valo <kvalo@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Philipp Stanner <pstanner@redhat.com>,  Igor Mitsyanko
 <imitsyanko@quantenna.com>,  amien Le Moal <dlemoal@kernel.org>,  Niklas
 Cassel <cassel@kernel.org>,  Basavaraj Natikar
 <basavaraj.natikar@amd.com>,  Jiri Kosina <jikos@kernel.org>,  Benjamin
 Tissoires <bentiss@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Sergey
 Matyukevich <geomatsi@gmail.com>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  Alex Dubov <oakad@yahoo.com>,  Sudarsana
 Kalluru <skalluru@marvell.com>,  Manish Chopra <manishc@marvell.com>,
  Andrew Lunn <andrew+netdev@lunn.ch>,  "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub
 Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Rasesh Mody
 <rmody@marvell.com>,  GR-Linux-NIC-Dev@marvell.com,  Sanjay R Mehta
 <sanju.mehta@amd.com>,  Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,  Jon
 Mason <jdmason@kudzu.us>,  Dave Jiang <dave.jiang@intel.com>,  Allen Hubbe
 <allenbh@gmail.com>,  Bjorn Helgaas <bhelgaas@google.com>,  Alex
 Williamson <alex.williamson@redhat.com>,  Juergen Gross <jgross@suse.com>,
  Stefano Stabellini <sstabellini@kernel.org>,  Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>,  Mario Limonciello
 <mario.limonciello@amd.com>,  Chen Ni <nichen@iscas.ac.cn>,  Ricky Wu
 <ricky_wu@realtek.com>,  Al Viro <viro@zeniv.linux.org.uk>,  Breno Leitao
 <leitao@debian.org>,  Thomas Gleixner <tglx@linutronix.de>,  Kevin Tian
 <kevin.tian@intel.com>,  Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>,  Mostafa Saleh <smostafa@google.com>,
  Jason Gunthorpe <jgg@ziepe.ca>,  Yi Liu <yi.l.liu@intel.com>,  Kunwu Chan
 <chentao@kylinos.cn>,  Dan Carpenter <dan.carpenter@linaro.org>,  "Dr.
 David Alan Gilbert" <linux@treblig.org>,  Ankit Agrawal
 <ankita@nvidia.com>,  Reinette Chatre <reinette.chatre@intel.com>,  Eric
 Auger <eric.auger@redhat.com>,  Ye Bin <yebin10@huawei.com>,
  linux-ide@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-input@vger.kernel.org,  netdev@vger.kernel.org,
  linux-wireless@vger.kernel.org,  ntb@lists.linux.dev,
  linux-pci@vger.kernel.org,  kvm@vger.kernel.org,
  xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 09/11] wifi: qtnfmac: use always-managed version of
 pcim_intx()
References: <20241212192935.GA3360239@bhelgaas>
Date: Fri, 13 Dec 2024 12:30:42 +0200
In-Reply-To: <20241212192935.GA3360239@bhelgaas> (Bjorn Helgaas's message of
	"Thu, 12 Dec 2024 13:29:35 -0600")
Message-ID: <87cyhvoox9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bjorn Helgaas <helgaas@kernel.org> writes:

> [cc->to: Igor]
>
> On Mon, Dec 09, 2024 at 02:06:31PM +0100, Philipp Stanner wrote:
>> pci_intx() is a hybrid function which can sometimes be managed through
>> devres. To remove this hybrid nature from pci_intx(), it is necessary to
>> port users to either an always-managed or a never-managed version.
>> 
>> qtnfmac enables its PCI-Device with pcim_enable_device(). Thus, it needs
>> the always-managed version.
>> 
>> Replace pci_intx() with pcim_intx().
>> 
>> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
>> Acked-by: Kalle Valo <kvalo@kernel.org>
>
> Hoping for an ack from Igor, too.

Igor hasn't been around for a while so I'm not expecting see an ack from
him, I think the whole qtnfmac driver should be removed in the future.
Feel free to take the patch as is.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

