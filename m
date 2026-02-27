Return-Path: <kvm+bounces-72236-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJS3N7cYomnFzAQAu9opvQ
	(envelope-from <kvm+bounces-72236-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:20:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3231BEA10
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35D243077220
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9743E47AF4B;
	Fri, 27 Feb 2026 22:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="Es1DC/U3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XBrZbus/"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFD25B1D2;
	Fri, 27 Feb 2026 22:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772230803; cv=none; b=MXX6xh54LQdNdBNIc9tWLJv+pugOBCCyB/MexVaDjtvQJuKgOBzTFV3VtD8XFwDa6TLfzkJGGo+NWWIIbPuGt+SgWk7iw/Av7mZqkWjLVScztL/T80ezYfA5GAKq10fQS9dzzdq4qFS4LX+XeZ7ypFMqbM7Fo98/XEOkT2EwqU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772230803; c=relaxed/simple;
	bh=rPQz8B0SOrK7HV/FEXdNt77/ExTGf3U+GZSmcaxuWNA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VP5KYnxCFj6nBdc6KdKAanWhAa8Kx8DDDs+oxTcGJJ/i8XofpXWQkysBjtQC4WpDFPi0pqrT5XSclG9jpUqeMJaEgw3I6hy50l0JCsII5WFn73MnGJtlA/kbB4qQT3YcBqRuvBU5el1/N3scsFt6zEc2q/AqeLCWyXBNpoUhhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=Es1DC/U3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XBrZbus/; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5EE9A7A0204;
	Fri, 27 Feb 2026 17:20:00 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 17:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772230800;
	 x=1772317200; bh=izSc26ZI1tq5Ik8AF+VQsxzONKQuIgaCv51HGKfgmRA=; b=
	Es1DC/U3NkcErFV1js5AzqHTsWFnzz3a8JgfuNt9t8GGgMi68PsAsOaC4kvNQesc
	maCJR4QSYcP4G1xtbkquEYWY8/UjZVHO8+cbrrUprJSEDqIz0qYH20NmNJJYKNFf
	Z5YGTQctWEUfLdaFnP72xvnc+TwESJVeAX7sn9CCoxfcIx1UarD7NSCVVbfu+zcg
	Fpi2BlrNp2B9UGH1apyNhrCZm4YlnMMDoc1d00LpcLQjCWGU3teC7sUxgR3Uz4Zr
	1ZbrHDbvPxufQ62PCAsdeFIspamstmKcKi0aHjLbNX8clk/XTinB+zF43U3IPIyb
	0jABzG+wKsWbaEFettUzQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1772230800; x=
	1772317200; bh=izSc26ZI1tq5Ik8AF+VQsxzONKQuIgaCv51HGKfgmRA=; b=X
	BrZbus/NB0VwIRoavQOzOFYRygCIJvK6jld2878Cpx5ls1Zoh0akdk75VZU66vgj
	YsmZ0ZRKT5RQ/WHebEon7LZuUu2hw9+drSOg3s9XsY3zn99DYXII7QEK4AwPebY9
	1aId0nc9MiwnRHioYnJzIGS7+pgjcDxdbc+NhgnjgSpuD+NaXdg7/MOfM56aXn7B
	Y2A/OgRliAkhhWTIyCbtRcmR37cQr7NcndwxIe1DDkI8D4appY2DtmzpG/HOKAfW
	ZwfzTku71jkcQHSXUMYOEj1OF8pi5HjIpF8ZUIizD2b9m2RxqTxhl5P1d7+bZvix
	vgZFeVLL8pe1qDtPPCAgQ==
X-ME-Sender: <xms:jxiiaYUzf2jbPOLw3Q-9Kqla8JkcxNHEGarRBU2f2kHPO3fLhEjtSw>
    <xme:jxiiaQZCw-K6bpNcsYuSaIAw3r4v7SPgHdIv6LIZ1qRlIQlUpTLqpWlVGfXdvJrHn
    H_mkPrOPF8wahuHsK1jKsKjt492UxCMELteNVYkfNWEmwBuTbm0EA>
X-ME-Received: <xmr:jxiiaVfgSV64P-wj44fdKBh5e3v_pUn5A9r6Snadi39EZmcZgu8oY8m0V_U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvhedtudekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtjeertdertddvnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvkeekhfeikeffjeelveeileekteelkeejtdeigfdvleegvdetffduiedt
    ueefjeenucffohhmrghinhepvhhfihhopghthihpvgdupghiohhmmhhupghsrghmvggpuh
    huihgurdhpfhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsggprh
    gtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrrghnrghnthgr
    sehgohhoghhlvgdrtghomhdprhgtphhtthhopegumhgrthhlrggtkhesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohepvhhiphhinhhshhesghhoohhglhgvrdgtohhmpdhrtghpthht
    ohepjhhrhhhilhhkvgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkhhvmhesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrlhgvgiesshhhrgiisghothdroh
    hrgh
X-ME-Proxy: <xmx:jxiiaa0KETunVd5UTlc17FdWh26BSfRPH_Hc6ghpi776Z8aEMTXwdw>
    <xmx:kBiiacL0veGY8XOLhcmPWOjrQtNWQ6WlZV2PnUC8sVeIDgRTTERouw>
    <xmx:kBiiaZFALDqoMTH6FU7h7HrsQOUYdiCYeT64zPJcoTzC5dYgcYvg3Q>
    <xmx:kBiiaYXhbj9J6drVmOeo01Bqph7Uc1x6NtOAbi5uq2FfCVRVjtwLAQ>
    <xmx:kBiiafvpdm3947Fc-Aq5vdIxW_hTMhcgmX9yUDSNsQvEl91K9T2BpzTR>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 17:19:59 -0500 (EST)
Date: Fri, 27 Feb 2026 15:19:58 -0700
From: Alex Williamson <alex@shazbot.org>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: David Matlack <dmatlack@google.com>, Vipin Sharma <vipinsh@google.com>,
 Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, alex@shazbot.org
Subject: Re: [PATCH v4 0/8] vfio: selftest: Add SR-IOV UAPI test
Message-ID: <20260227151958.4aba263e@shazbot.org>
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm3];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72236-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[messagingengine.com:dkim,shazbot.org:mid,shazbot.org:dkim,run.sh:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E3231BEA10
X-Rspamd-Action: no action

On Tue, 24 Feb 2026 18:25:24 +0000
Raghavendra Rao Ananta <rananta@google.com> wrote:

> Hello,
> 
> This series adds a vfio selftest, vfio_pci_sriov_uapi_test.c, to get some
> coverage on SR-IOV UAPI handling. Specifically, it includes the
> following cases that iterates over all the iommu modes:
>  - Setting correct/incorrect/NULL tokens during device init.
>  - Close the PF device immediately after setting the token.
>  - Change/override the PF's token after device init.
> 
> The test takes care of creating/setting up the VF device, and hence, it
> can be executed like any other test, simply by passing the PF's BDF to
> run.sh. For example,
> 
> $ ./scripts/setup.sh 0000:16:00.1
> $ ./scripts/run.sh ./vfio_pci_sriov_uapi_test
> 
> TAP version 13
> 1..45
> # Starting 45 tests from 15 test cases.
> #  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match ...
> Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
> #            OK  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
> ok 1 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
> #  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close ...
> Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
> #            OK  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
> ok 2 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
> [...]
> #  RUN           vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token ...
> Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
> #            OK  vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
> ok 45 vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
> # PASSED: 45 / 45 tests passed.
> # Totals: pass:45 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Thank you.
> Raghavendra
> 
> v4: Suggestions by David and Alex
> - Assert that the value computed in sysfs_val_get() in an int. Rename the
>   function to sysfs_val_get_int() to better reflect what the function is doing. (Alex)
> - Add the missing Signed-off-by tag in patch-7 (David).
> 
> v3: Suggestions by David Matlack (thanks!)
> - Introduce a patch to add -Wall and -Werror to the vfio Makefile.
> - Use snprintf_assert() where they were missed.
> - Rename the functions as suggested in the sysfs lib and the test file.
> - Alloc the output char * buffer in the functions sysfs_driver_get() and
>   sysfs_sriov_vf_bdf_get() instead of relying on the caller to pass one.
>   The caller is now responsible for freeing these buffers.
> - Remove unnecessary initializations of local variables in sysfs and the
>   vfio_pci_device libraries.
> - Move the inclusion of -luuid to the top level Makefile.
> - Introduce vfio_pci_device_{alloc|free}() and let the test and the functions in
>   vfio_pci_device.c use this.
> - Return -errno for the ioctl failure in __vfio_device_bind_iommufd() instead of
>   directly calling ioctl_assert().
> - Since the vfio-pci driver sets the 'driver_override' to the driver of PF,
>   instead of clearing sriov_drivers_autoprobe and binding the VF explicitly to
>   the 'vfio-pci' driver, only assert that it's already bound.
> - By extension to the above point, remove the unnecessary functions from the sysfs
>   lib.
> 
> v2: Suggestions by David Matlack (thank you)
>  - Introduce snprintf_assert() to check against content trucation.
>  - Introduce a new sysfs library to handle all the common vfio/pci sysfs
>    operations.
>  - Rename vfio_pci_container_get_device_fd() to
>    vfio_pci_group_get_device_fd().
>  - Use a fixed size 'arg' array instead of dynamic allocation in
>    __vfio_pci_group_get_device_fd().
>  - Exclude vfio_pci_device_init() to accept the 'vf_token' arg.
>  - Move the vfio_pci_sriov_uapi_test.c global variable to the FIXTURE()
>    struct or as TEST_F() local variables.
>  - test_vfio_pci_container_setup() returns 'int' to indicate status.
>  - Skip the test if nr_vfs != 0.
>  - Explicitly set "sriov_drivers_autoprobe" for the PF.
>  - Make sure to bind the VF device to the "vfio-pci" driver.
>  - Cleanup the things done by FIXTURE_SETUP() in FIXTURE_TEARDOWN().
> 
> v3: https://lore.kernel.org/all/20260204010057.1079647-1-rananta@google.com/
> v2: https://lore.kernel.org/all/20251210181417.3677674-1-rananta@google.com/
> v1: https://lore.kernel.org/all/20251104003536.3601931-1-rananta@google.com/
> 
> Raghavendra Rao Ananta (8):
>   vfio: selftests: Add -Wall and -Werror to the Makefile
>   vfio: selftests: Introduce snprintf_assert()
>   vfio: selftests: Introduce a sysfs lib
>   vfio: selftests: Extend container/iommufd setup for passing vf_token
>   vfio: selftests: Expose more vfio_pci_device functions
>   vfio: selftests: Add helper to set/override a vf_token
>   vfio: selftests: Add helpers to alloc/free vfio_pci_device
>   vfio: selftests: Add tests to validate SR-IOV UAPI
> 
>  tools/testing/selftests/vfio/Makefile         |   4 +
>  .../selftests/vfio/lib/include/libvfio.h      |   1 +
>  .../vfio/lib/include/libvfio/assert.h         |   5 +
>  .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
>  .../lib/include/libvfio/vfio_pci_device.h     |  11 +
>  tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
>  tools/testing/selftests/vfio/lib/sysfs.c      | 141 ++++++++++++
>  .../selftests/vfio/lib/vfio_pci_device.c      | 156 ++++++++++----
>  .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
>  .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
>  .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
>  11 files changed, 507 insertions(+), 51 deletions(-)
>  create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
>  create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
>  create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> 
> 
> base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3

Please rebase:

$ git log --oneline --no-merges d721f52e31553a848e0e9947ca15a49c5674aef3..v7.0-rc1 tools/testing/selftests/vfio/a55d4bbbe644 vfio: selftests: only build tests on arm64 and x86_64
1c588bca3bd5 vfio: selftests: Drop IOMMU mapping size assertions for VFIO_TYPE1_IOMMU
080723f4d4c3 vfio: selftests: Add vfio_dma_mapping_mmio_test
557dbdf6c4e9 vfio: selftests: Align BAR mmaps for efficient IOMMU mapping
03b7c2d763c9 vfio: selftests: Centralize IOMMU mode name definitions
193120dddd1a vfio: selftests: Drop <uapi/linux/types.h> includes
e6fbd1759c9e selftests: complete kselftest include centralization

Thanks,
Alex

