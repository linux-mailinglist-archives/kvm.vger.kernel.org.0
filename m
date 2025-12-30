Return-Path: <kvm+bounces-66866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A62CEAB49
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E36C730060DF
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932F423F40D;
	Tue, 30 Dec 2025 21:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="YdAc/5+U";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="r/kUGXwu"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90563A1E81;
	Tue, 30 Dec 2025 21:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129466; cv=none; b=Qy5pkQIw4aXarAqsb/681FTur0qrKXeIDVl6Z1dFZDDuao6mdSixSfLZPCMcLNiEcCmbIf7Qh0+8TL1A+71Xqr8PkW1Eg78o2cB5ynwwLX4RM+0EOzh3Eu9Dn3o/9sFC7I4kaEMtdRdh/9DmNooljp+cK5z+AqZdPAy7B2E/Uts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129466; c=relaxed/simple;
	bh=23pZtuKI6hZxEU+5r0j0fvSd2Faldgal1ZPXSF6OX9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=KhL8Idvq3OgX9PwtIITtEJpRNI2/KVJ9fsF2H5V8OVnrBzVyR00H6gqms4JrzFA7navPLYPHbhddzxJ6LxtgC86cJAM1P2VGHnloMue/zJ4r8tKbdtmZVjibgfHNjPfL3PQofWBvCFuBpn1YQxljga7zxmApuxBBt2Qjn07Y8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=YdAc/5+U; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=r/kUGXwu; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DB6F27A0055;
	Tue, 30 Dec 2025 16:17:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 30 Dec 2025 16:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm1; t=1767129461; x=1767215861; bh=qN
	YNjYfPAZkTCpyt5WK5132yIKd/qwo5ilMauEb4eqk=; b=YdAc/5+U/MOveftl7F
	6KR7GZK97H8qTDkoU7UxU9Q9AQcdpmDKPUD9Jq8YmEOqmrsDnb4Yc4eYPXaMxDHp
	JlClaGvTF0DHE9doUCMGtBliIJxzH/GokzMIIr+/9yPCEigCoL0Q6gkdtNmJyT1u
	Q8NbPr/ZYeVOzBgMAvOdUFNCbeV6DCjpFPRvX+nY5oIsZtzJgq76Sx0rdxSEA59O
	2GbLj5JjmHJrMETYpdQo66PzYmV0zm06bjQ4Y/H26QMhEjm5nt+b+59gsCJkffl3
	AOP5DbbVUcBz7Qry3JCAQr6Ja5Ji8Diki7r7xotFAhEwOE+Ly5j0+u7MOTMPyLdv
	3s8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1767129461; x=1767215861; bh=qNYNjYfPAZkTCpyt5WK5132yIKd/
	qwo5ilMauEb4eqk=; b=r/kUGXwurfOKl4MSczPr+hDszXhza0J6/mAtCVEA5qcJ
	i9kDLyAODOLh+0rJ2YtqYHO5wZKJlWOjxx95LDUs33x5ie3Ugv0NnRZ9YATki1v1
	YECVyKcK7RhP8Sj9bL1e2Muwpg1RLr6QgwmNyIHg1INXWdG/yyJQZ4OT7LJw+kci
	dlZioectON8so3mpXDlCw0eSG5HKDSScPMNNC7tlcK+qIA339xMAyt9icrgNDEI+
	M2nDYRQw3ys3o7vms14NUhJh8z5tTtjIAkDtjhdWDJmyX7qYgGVsH0U2VmQujQcD
	5x8xPbDlafH4okSNSxDDq9srJp+uSjI9rRE9K5YWqQ==
X-ME-Sender: <xms:dUFUaSKRyhCZYFtrD1QxB8YqxZCb0yDgpqfQV9LX83jgLRmbyaXsfg>
    <xme:dUFUaR7bxlThe2uC9VqQWKIagHBPIjk5rmsGU9hpY6e-i51qYb4Ghzvejjp_PKsbH
    UD17yz-DZmpGYggAKb_pTaFZeONYmuQsO8y6jYZeTeaAwvm2iEI5kM>
X-ME-Received: <xmr:dUFUaVy7kS9XDrtOSgStKDY_R7gMMOZYefvGtrcKgXPIXrCVrvFevuHgoMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdekuddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghilhhl
    ihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeifeegieelheehueehgfehhffghedvgfdtieffuefhvddvkeehhfeuueduffefleen
    ucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsggp
    rhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtohhrvhgrlh
    gusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhhvmh
    esvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:dUFUaVbvwrpVWAOizbgomNx-NCSgnmj-uz3zRs6_GiDPAJ9BOqlp0A>
    <xmx:dUFUaXQ1Ik2G4aZK7F9fTDBkPKow7FlLl1bkS7uqbPk_Ltcf-3hNsw>
    <xmx:dUFUafy6tdWgT711Ad3S-NBzIGNe2t_bimoWT1VBZjvzxgKOmNSY6A>
    <xmx:dUFUaR0TmZqsIagjk3sDdfi-_Qx7Df_S7fZ-20PnJkZ5U66KyD_TEA>
    <xmx:dUFUadeHxkInRfl5u7ZImoF4xj3rLFt5X0KE-8tQJ81Sc-PFHYJeioGH>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Dec 2025 16:17:40 -0500 (EST)
Date: Tue, 30 Dec 2025 14:17:39 -0700
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v6.19-rc4
Message-ID: <20251230141739.7e11a0c4.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc4

for you to fetch changes up to acf44a2361b8d6356b71a970ab016065b5123b0e:

  vfio/xe: Fix use-after-free in xe_vfio_pci_alloc_file() (2025-12-28 12:42:46 -0700)

----------------------------------------------------------------
VFIO fixes for v6.19-rc4

 - Restrict ROM access to dword to resolve a regression introduced
   with qword access seen on some Intel NICs.  Update VGA region
   access to the same given lack of precedent for 64-bit users.
   (Kevin Tian)

 - Fix missing .get_region_info_caps callback in the xe-vfio-pci
   variant driver due to integration through the DRM tree.
   (Michal Wajdeczko)

 - Add aligned 64-bit access macros to tools/include/linux/types.h,
   allowing removal of uapi/linux/type.h includes from various
   vfio selftest, resolving redefinition warnings for integration
   with KVM selftests. (David Matlack)

 - Fix error path memory leak in pds-vfio-pci variant driver.
   (Zilin Guan)

 - Fix error path use-after-free in xe-vfio-pci variant driver.
   (Alper Ak)

----------------------------------------------------------------
Alper Ak (1):
      vfio/xe: Fix use-after-free in xe_vfio_pci_alloc_file()

David Matlack (2):
      tools include: Add definitions for __aligned_{l,b}e64
      vfio: selftests: Drop <uapi/linux/types.h> includes

Kevin Tian (2):
      vfio/pci: Disable qword access to the PCI ROM bar
      vfio/pci: Disable qword access to the VGA region

Michal Wajdeczko (1):
      vfio/xe: Add default handler for .get_region_info_caps

Zilin Guan (1):
      vfio/pds: Fix memory leak in pds_vfio_dirty_enable()

 drivers/vfio/pci/nvgrace-gpu/main.c                |  4 ++--
 drivers/vfio/pci/pds/dirty.c                       |  7 ++++--
 drivers/vfio/pci/vfio_pci_rdwr.c                   | 25 ++++++++++++++++------
 drivers/vfio/pci/xe/main.c                         |  5 ++++-
 include/linux/vfio_pci_core.h                      | 10 ++++++++-
 tools/include/linux/types.h                        |  8 +++++++
 .../vfio/lib/include/libvfio/iova_allocator.h      |  1 -
 tools/testing/selftests/vfio/lib/iommu.c           |  1 -
 tools/testing/selftests/vfio/lib/iova_allocator.c  |  1 -
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |  1 -
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  1 -
 .../selftests/vfio/vfio_iommufd_setup_test.c       |  1 -
 12 files changed, 46 insertions(+), 19 deletions(-)

