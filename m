Return-Path: <kvm+bounces-66471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE98CCD5F83
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 13:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD2B530813F7
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 12:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418A9280014;
	Mon, 22 Dec 2025 12:21:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06AC27AC57;
	Mon, 22 Dec 2025 12:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766406079; cv=none; b=ao8c/d0QjH5A+2LPTOjDwQpwPo07iPXvYtrnPyMsVBp3Z1FtCAwOLuoiENIHMYFfFcGEmIGSE/7U6LJjBwhxPLvUilwPqhpSVY3PiQHqdPhn3X0vL27OO3jDrOUlVFn7QSutYk5q9HSXb4w6DFQag7Cve4nm21iFGWcTnP3VixY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766406079; c=relaxed/simple;
	bh=LRSc0fdnPuz4AXmmdTQ5+V9eIsQnieA3RrxGpEYvnIw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KROfZEv5lNumgKR8j+UrONBaj0aZtuKSBkWV534gBuunBWp3hWD6WBm0ko0nIA0mqoMPtB8tzkTWXUlczo9c2TDU3kTcTpVjwJQSC9pwKpL7giHJQHImb/KSEWYkwIEjlD0TrPXUSQDvgw7CdmZ4MOspvB4VIh2BMLa4PPSfL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZcft749MzHnH5r;
	Mon, 22 Dec 2025 20:20:38 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F2FE840565;
	Mon, 22 Dec 2025 20:21:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 12:21:12 +0000
Date: Mon, 22 Dec 2025 12:21:11 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: <mhonap@nvidia.com>
CC: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kvm@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
Subject: Re: [RFC v2 01/15] cxl: factor out cxl_await_range_active() and
 cxl_media_ready()
Message-ID: <20251222122111.00003844@huawei.com>
In-Reply-To: <20251209165019.2643142-2-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
	<20251209165019.2643142-2-mhonap@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 9 Dec 2025 22:20:05 +0530
mhonap@nvidia.com wrote:

> From: Zhi Wang <zhiw@nvidia.com>
> 
> Before accessing the CXL device memory after reset/power-on, the driver
> needs to ensure the device memory media is ready.
> 
> However, not every CXL device implements the CXL memory device register
> groups. E.g. a CXL type-2 device. Thus calling cxl_await_media_ready()
> on these device will lead to a kernel panic. This problem was found when
> testing the emulated CXL type-2 device without a CXL memory device
> register.
> 
> [   97.662720] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   97.663963] #PF: supervisor read access in kernel mode
> [   97.664860] #PF: error_code(0x0000) - not-present page
> [   97.665753] PGD 0 P4D 0
> [   97.666198] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
> [   97.667053] CPU: 8 UID: 0 PID: 7340 Comm: qemu-system-x86 Tainted: G            E      6.11.0-rc2+ #52
> [   97.668656] Tainted: [E]=UNSIGNED_MODULE
> [   97.669340] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   97.671243] RIP: 0010:cxl_await_media_ready+0x1ac/0x1d0
> [   97.672157] Code: e9 03 ff ff ff 0f b7 1d d6 80 31 01 48 8b 7d b8 89 da 48 c7 c6 60 52 c6 b0 e8 00 46 f6 ff e9 27 ff ff ff 49 8b 86 a0 00 00 00 <48> 8b 00 83 e0 0c 48 83 f8 04 0f 94 c0 0f b6 c0 8d 44 80 fb e9 0c
> [   97.675391] RSP: 0018:ffffb5bac7627c20 EFLAGS: 00010246
> [   97.676298] RAX: 0000000000000000 RBX: 000000000000003c RCX: 0000000000000000
> [   97.677527] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   97.678733] RBP: ffffb5bac7627c70 R08: 0000000000000000 R09: 0000000000000000
> [   97.679951] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   97.681144] R13: ffff9ef9028a8000 R14: ffff9ef90c1d1a28 R15: 0000000000000000
> [   97.682370] FS:  00007386aa4f3d40(0000) GS:ffff9efa77200000(0000) knlGS:0000000000000000
> [   97.683721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   97.684703] CR2: 0000000000000000 CR3: 0000000169a14003 CR4: 0000000000770ef0
> [   97.685909] PKRU: 55555554
> [   97.686397] Call Trace:
> [   97.686819]  <TASK>
> [   97.687243]  ? show_regs+0x6c/0x80
> [   97.687840]  ? __die+0x24/0x80
> [   97.688391]  ? page_fault_oops+0x155/0x570
> [   97.689090]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.689973]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.690848]  ? __vunmap_range_noflush+0x420/0x4e0
> [   97.691700]  ? do_user_addr_fault+0x4b2/0x870
> [   97.692606]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.693502]  ? exc_page_fault+0x82/0x1b0
> [   97.694200]  ? asm_exc_page_fault+0x27/0x30
> [   97.694975]  ? cxl_await_media_ready+0x1ac/0x1d0
> [   97.695816]  vfio_cxl_core_enable+0x386/0x800 [vfio_cxl_core]
> [   97.696829]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.697685]  cxl_open_device+0xa6/0xd0 [cxl_accel_vfio_pci]
> [   97.698673]  vfio_df_open+0xcb/0xf0
> [   97.699313]  vfio_group_fops_unl_ioctl+0x294/0x720
> [   97.700149]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.701011]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.701858]  __x64_sys_ioctl+0xa3/0xf0
> [   97.702536]  x64_sys_call+0x11ad/0x25f0
> [   97.703214]  do_syscall_64+0x7e/0x170
> [   97.703878]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.704726]  ? do_syscall_64+0x8a/0x170
> [   97.705425]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.706282]  ? kvm_device_ioctl+0xae/0x130 [kvm]
> [   97.707135]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.708001]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.708853]  ? syscall_exit_to_user_mode+0x4e/0x250
> [   97.709724]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.710609]  ? do_syscall_64+0x8a/0x170
> [   97.711300]  ? srso_alias_return_thunk+0x5/0xfbef5
> [   97.712132]  ? exc_page_fault+0x93/0x1b0
> [   97.712839]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   97.713735] RIP: 0033:0x7386ab124ded
> [   97.714382] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> [   97.717664] RSP: 002b:00007ffcda2a6480 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   97.718965] RAX: ffffffffffffffda RBX: 00006293226d9f20 RCX: 00007386ab124ded
> [   97.720222] RDX: 00006293226db730 RSI: 0000000000003b6a RDI: 0000000000000009
> [   97.721522] RBP: 00007ffcda2a64d0 R08: 00006293214e9010 R09: 0000000000000007
> [   97.722858] R10: 00006293226db730 R11: 0000000000000246 R12: 00006293226e0880
> [   97.724193] R13: 00006293226db730 R14: 00007ffcda2a7740 R15: 00006293226d94f0
> [   97.725491]  </TASK>
> [   97.725883] Modules linked in: cxl_accel_vfio_pci(E) vfio_cxl_core(E) vfio_pci_core(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) qrtr(E) intel_rapl_msr(E) intel_rapl_common(E) kvm_amd(E) ccp(E) binfmt_misc(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) polyval_clmulni(E) polyval_generic(E) ghash_clmulni_intel(E) sha256_ssse3(E) sha1_ssse3(E) aesni_intel(E) i2c_i801(E) crypto_simd(E) cryptd(E) i2c_smbus(E) lpc_ich(E) joydev(E) input_leds(E) mac_hid(E) serio_raw(E) msr(E) parport_pc(E) ppdev(E) lp(E) parport(E) efi_pstore(E) dmi_sysfs(E) qemu_fw_cfg(E) autofs4(E) bochs(E) e1000e(E) drm_vram_helper(E) psmouse(E) drm_ttm_helper(E) ahci(E) ttm(E) libahci(E)
> [   97.736690] CR2: 0000000000000000
> [   97.737285] ---[ end trace 0000000000000000 ]---
> 
> Factor out cxl_await_range_active() and cxl_media_ready(). Type-3 device
> should call both for ensuring media ready while type-2 device should only
> call cxl_await_range_active().
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Li Ming <ming.li@zohomail.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Li Ming <ming.li@zohomail.com>
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Manish Honap <mhonap@nvidia.com>

One bit of visual oddity inline.

> ---
>  drivers/cxl/core/pci.c        | 18 +++++++++++-------
>  drivers/cxl/core/pci_drv.c    |  3 +--
>  drivers/cxl/cxlmem.h          |  3 ++-
>  include/cxl/cxl.h             |  1 +
>  tools/testing/cxl/Kbuild      |  3 ++-
>  tools/testing/cxl/test/mock.c | 21 ++++++++++++++++++---
>  6 files changed, 35 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
> index 90a0763e72c4..a0cda2a8fdba 100644
> --- a/drivers/cxl/core/pci.c
> +++ b/drivers/cxl/core/pci.c
> @@ -225,12 +225,11 @@ static int cxl_dvsec_mem_range_active(struct cxl_dev_state *cxlds, int id)
>   * Wait up to @media_ready_timeout for the device to report memory
>   * active.
>   */
> -int cxl_await_media_ready(struct cxl_dev_state *cxlds)
> +int cxl_await_range_active(struct cxl_dev_state *cxlds)
>  {
>  	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
>  	int d = cxlds->cxl_dvsec;
>  	int rc, i, hdm_count;
> -	u64 md_status;
>  	u16 cap;
>  
>  	rc = pci_read_config_word(pdev,
> @@ -251,13 +250,18 @@ int cxl_await_media_ready(struct cxl_dev_state *cxlds)
>  			return rc;
>  	}
>  
> -	md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
> -	if (!CXLMDEV_READY(md_status))
> -		return -EIO;
> -
>  	return 0;
>  }
> -EXPORT_SYMBOL_NS_GPL(cxl_await_media_ready, "CXL");
> +EXPORT_SYMBOL_NS_GPL(cxl_await_range_active, "CXL");
> +
> +int cxl_media_ready(struct cxl_dev_state *cxlds)
> +{
> +	u64 md_status;
> +
> +	md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
> +	return CXLMDEV_READY(md_status) ? 0 : -EIO;
See below for suggestion that this should return a bool to say
if the media was ready or not.

> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_media_ready, "CXL");
>  
>  static int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
>  {
> diff --git a/drivers/cxl/core/pci_drv.c b/drivers/cxl/core/pci_drv.c
> index 4c767e2471b8..6e519b197f0d 100644
> --- a/drivers/cxl/core/pci_drv.c
> +++ b/drivers/cxl/core/pci_drv.c
> @@ -899,8 +899,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_await_media_ready(cxlds);
> -	if (rc == 0)
> +	if (!cxl_await_range_active(cxlds) && !cxl_media_ready(cxlds))

Syntax here is odd because you are treating the output of
cxl_media_ready() as a boolean. So someone naively looking at this
sees that media_ready is set to true when a check called cxl_media_ready()
returned false. It made me blink.

I'd either use explicit == 0 for each of these, or perhaps for cxl_media_ready()
return a bool.


>  		cxlds->media_ready = true;
>  	else
>  		dev_warn(&pdev->dev, "Media not active (%d)\n", rc);


