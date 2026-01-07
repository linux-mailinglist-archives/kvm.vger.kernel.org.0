Return-Path: <kvm+bounces-67198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F357CFC272
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 07:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAF8E302354F
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 06:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD57926ED59;
	Wed,  7 Jan 2026 06:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k7UZ/scz"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF9320468E
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 06:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766172; cv=fail; b=BRgG3RV5uNuWByP4CQeRvcphrP2o8ESbB0piLYdyu0/20pwVAR0Z9rWv7R5S7vmrvM3S8YbFPc32Gx2itow5TXvlONyjqjtMJwOmrcmosQ0ASMBYLRPGQrmnDFJSVHFszBX8lwDriFhQvc9O4sziQFNTBnwi+Z5nd8u37yqcYIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766172; c=relaxed/simple;
	bh=qnyoiNT6L8clJDG6+sOZSB6dJyaiztC1srf74QMx8RQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oyAHCV5LYeDPXVbcDTO5CgLdQ8DNAATm4a/8y/+GAiWLRQUSVugKbpbdikUafq+NkD1WnPPaKci5LevieFSCi/a91jKFoqpfWv//3qI9m/dC3CX2gxihC34xoOyYtC+omqbfPRsae8/CYzvqbqv4DXWZJqJGaaMWFt/UUwSC+qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k7UZ/scz; arc=fail smtp.client-ip=52.101.52.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2kxI0g7MJy+90Du2buqxes6bc3ZmvSc2EOPe4Kw9pkHF1+Qj0qCcggJfhGZc6a263csBEfRb3cDyY6tovPf4yiHJ0qAtgkGTtFn0qsNYKdKeGyVD7HfM0fR0BLTcnp+e6/1r1fdb3ErtT/mNWocVM+hpW4I5HVe+MhSvjvgrKdpE2ruuZqJP7iXLYtLZ7uS88kegByknecJVCHytZmvsbDBMdir95UjO+KdHQ9M6JGZf3yWhwgbIGFYL7+7QmzRgvfNPOV9WHmR3ake5XZmUcGKEX5V6MQbmm09GlP66s+lihpqJ/FrbctXxwL9uaK6afKnBo6oo5L17HqXdcM1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvg5K5lW+0NQl68vAtLvH0ZkmseIXLDHINkaLTWpEJ4=;
 b=kcM6dCTFIOanJynHZEs+BQijGKLZCAYYlU26T6Ypul1zqDnieNS/ubB+VFa3wJs52zp4apmA8tpCyaV7IR5d4IUgAqXNewfFmUKGm9CYGuOCsvMaiLoo9UmJ/63oYER/vYDRQM0XMKNqd7xfKhYSkYvn+HgctkaTez0y3v1JZ1aOaUS4JfdDHXbaz9v1zwhIdmODSD/Jpf4gb7tzV/fsOtJdGgRozLs6kGo/DYuUAW1yQk1Be1uoXmgF2r2KQCPDZ+rz8RG3l77iUmdi5wQeaBPPwkeiKIZDaaO/OYofXVUoC8R1P/aEN+bmzzvosczNVfA3QReb/BQCjgjYx83TPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvg5K5lW+0NQl68vAtLvH0ZkmseIXLDHINkaLTWpEJ4=;
 b=k7UZ/scz4K5tm7vzfT7hRSkG5FMuXMEvhRhD4wRl8EG+TijoGxw71wqGkOmEXjpjyzTkppO656NJ0BKyhI5zSrftqJVgBdHnYQvrfSQp02pCwRcND5PWRAj0yBojbrogMFX/LpxuLOMFOFzc2QJB1zbKd6EAkY163kjSy+QEphc=
Received: from CH2PR14CA0057.namprd14.prod.outlook.com (2603:10b6:610:56::37)
 by SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 06:09:25 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::b2) by CH2PR14CA0057.outlook.office365.com
 (2603:10b6:610:56::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 06:09:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Wed, 7 Jan 2026 06:09:24 +0000
Received: from [10.252.204.230] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 7 Jan
 2026 00:09:17 -0600
Message-ID: <2440cf13-e4d4-4894-b41a-fbdf7cd9b3b5@amd.com>
Date: Wed, 7 Jan 2026 11:39:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 0/5] amd_iommu: support up to 2048 MSI vectors
 per IRT
Content-Language: en-US
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<alejandro.j.jimenez@oracle.com>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>
References: <20251118101532.4315-1-sarunkod@amd.com>
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20251118101532.4315-1-sarunkod@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: af12c306-74f6-4e4c-cdb8-08de4db34e89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|82310400026|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tm9qbGpoQ0dEbllmUFo1dVZZVFZuTEpMUXBJdDRTRkpZMzhlTzQ4SzRYRGlT?=
 =?utf-8?B?VnJWZzJnT0FJSVJNVmJRRE5yUzA1djd6SjhQN1V6MkpJallid0IySHhjSTZ5?=
 =?utf-8?B?STYwK0VyaDBjNHl6ZTNuQmdZcmVYRXVCb3lsamMyZTBlSkliUWpwMy8yYlVo?=
 =?utf-8?B?S1VQNTJtanRmQlplNnlPeERiTlpxc28ySkZ6OGpVRlVibEQvVktTeDVUS3I1?=
 =?utf-8?B?SFZHSklORTFvVkRSWnJmK1FWNEFJV2JnRUZZN3h5Q0UyVGQrc251MHdMTnQw?=
 =?utf-8?B?WDhsUlhHd2VMbm80TWkzZWVadGhRMG9TTUs5dEN2clN0anpiME9icWRkb0Rq?=
 =?utf-8?B?VllXNVNLcmloMG4zeG5OQWFIU1ZaOVhnWENKL2JFazJ5NkFXZTc5dmRrYXlZ?=
 =?utf-8?B?TFlVb2FKWTRBck1Na05uUThwLzZ6K0pXQklXKys5VmhKV1Z4a3dtejM5K0VV?=
 =?utf-8?B?ZHoyZVp2UkRwK2pUMWdtL3NlSkdia0dIMlJsMjBXQWhVcDVwQkl5VkZWMDZU?=
 =?utf-8?B?VEZickI0Tm81SFIxdS9uMlFvbHZuTDFwdzNMODl3ZElQS045MmtzdEovbXdx?=
 =?utf-8?B?V21JMUJuQTRJL0xpRkdHK3lWSGtyZytoSnphMkMwY29mTkY5YjZFMkJwTFlY?=
 =?utf-8?B?OWNNNnY5L3NrMDlyWUxybmhCNGpWVlEvb0Ntd01BN2VNK2FwNFYraEh5RUE5?=
 =?utf-8?B?OEpsRnF3aFNJbXVzZ25TSGhsSlMvbGxGWERFeW1JMjFpczNHSkRlVzgzWExZ?=
 =?utf-8?B?cXBOS0VFSkdJWkpTVy84bkpieWN3WFRJRUtGNWcxTVkvc1J3ZEl3c2k5R0lt?=
 =?utf-8?B?cGYrUmhTM3ZsODVydW5RRlYxUHk3OGU3QUFUY3FYeFpYUU4rd1VzQUc5MTFR?=
 =?utf-8?B?V1hZZmNaNUhJTzVJZ0t4WjlYUDhRa0todHUwcFJBMy9Rb2hNNWlUb0JsQlBs?=
 =?utf-8?B?L3oyb0JtblVsaWM1UlZSS0dTaW9ZM1BWeHFDTmtjcndJVEt1QU44WHVXYjMv?=
 =?utf-8?B?RWZ4ZDIzSkJlTjE5RXUveXZXRCtmMzZ4TStzc3p1cDhmNDIrdU1TT0VFQ3lo?=
 =?utf-8?B?MXdPM09hZVRWSG1HdHRqTFV6bWJId3M5b1JMVXNCQTdHVXpESVNwaktEU3Fs?=
 =?utf-8?B?ZUpWQ3I2NCsxSU9kNFQrTFRVNEVWSTJTd01xb085ekF0ZndYdldPM2tZSnpB?=
 =?utf-8?B?eklMcEhrNlRqQXI4YUpPeDFFNG9PQlZzRE94azQ5KzN2M1YrZmdXckJWUWZx?=
 =?utf-8?B?RGlWdUZBUXdpVHdEMmpqZnRCVnB5OFNJc3lTSGtyUWhyYTlVbXZzeDVMMG9t?=
 =?utf-8?B?Vy9lTzVScjFQeENLblFlSDEyNWRVNkZrTjBzaUtZbCtPWGVlbzFTL2wvMVRr?=
 =?utf-8?B?WU13eGlUdndRWGx4NUc0Rk0zQkRhV29ES1BOTTd0dmZQVnlyLzdJOWNzb3gx?=
 =?utf-8?B?bWpuUHYvYmN4ampXWWg2Rkp4TkpwYitCZlZWT3JzR29qZlk5ZnMwKzUycXJ4?=
 =?utf-8?B?cEtDbFlwR2RYNjBNRkMyZ0pQTGRrWm1VbG1FbHJWZDNNV29wakhUblBUeU5N?=
 =?utf-8?B?WnRuNXg5cHkyR1NBSlNlNm11c05scm9qZnkraGlqenNNQWxDaDlTWUxWV0JP?=
 =?utf-8?B?eVNIZUc3WlQ3LzVSSGRzWFV5Y3Y0MlBuYkZEV0xkdjJIMjBCTzR1YmxWN0Ni?=
 =?utf-8?B?aE5ndVlqYitZdG56RUtLSmp4cXlrb3l2MlBNK0JKK01CWGZBVEVzanZXUk5m?=
 =?utf-8?B?SEZTRmluemtkUTZxUkRvZkdiNEtRYi9RTkVHNVRqL2RERVNvMW1qeDQrWVRS?=
 =?utf-8?B?SnNZOG0zdUlsSWJXQjlMQThPZUQ2bDhEMTBtM1kxYzAyM0ZuRXFiSGQxbVhE?=
 =?utf-8?B?cTVJaFdpcHk0R1lSWVBRTmQyODhOMEpiMTd4ZFBQVVlObWc3S1ZrRU1YSS91?=
 =?utf-8?B?NlkzeUMyN2MyYjlneFp1NmVobDhkRUVpbVhCd1gxSTgrUkJWRkdXUk1lTkdk?=
 =?utf-8?B?VGh1QjVQKzFmaVZOSHFlZG5OQjJRVUIzbGJCQ2RDcUh0UUVibzl6QUlRMlJY?=
 =?utf-8?B?NDRoV1IxaFBSQWpja3JLU2pDYXVoSDAxQWpmWTQ3U0dqM29zVUNWVFcyWWVT?=
 =?utf-8?Q?DU00=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(82310400026)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 06:09:24.5000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af12c306-74f6-4e4c-cdb8-08de4db34e89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847

Hello all,

Gentle ping,

On 11/18/2025 3:45 PM, Sairaj Kodilkar wrote:
> Resending this series with KVM and IOMMU maintainers in CC.
>
> AMD IOMMU can route upto 2048 MSI vectors through a single
> Interrupt Remapping Table (IRT) entry. This series brings the same
> capability to the emulated AMD IOMMU in QEMU.
>
> Highlights
> ----------
> * Sets bits [9:8] in Extended-Feature-Register-2 to advertise 2K MSI
>    support to the guest.
> * Uses bits [10:0] of the MSI data to select the IRTE when the guest
>    programs MSIs in logical-destination mode.
> * Introduces a new IOMMU device property:
>          -device amd-iommu,...,numint2k=on
>
>    The feature is **opt-in**; guests keep the 512-MSI behaviour unless
>    `numint2k=on` is supplied.
>
> Passthrough devices
> -------------------
> When a PCI function is passed through via iommufd the code checks the
> host’s vendor capabilities.  If the host IOMMU has not enabled
> 2K-MSI support (bits [44:43] set in the control register) the guest
> feature is disabled even if `numint2k=on` was requested.
>
> The detection logic relies on the iommufd interface; with the legacy
> VFIO container the guest always falls back to 512 MSIs.
>
> Example
> -------
> qemu-system-x86_64 \
> -enable-kvm -m 10G -smp cpus=8 \
> -kernel /boot/vmlinuz \
> -initrd /boot/initrd.img \
> -append "console=ttyS0 earlyprintk=serial root=<DEVICE>"
> -device amd-iommu,dma-remap=on,numint2k=on \
> -object iommufd,id=iommufd0 \
> -device vfio-pci,host=<DEVID>,iommufd=iommufd0 \
> -global kvm-pit.lost_tick_policy=discard \
> -cpu host \
> -machine q35,kernel_irqchip=split \
> -nographic \
> -smbios type=0,version=2.8 \
> -blockdev node-name=drive0,driver=qcow2,file.driver=file,file.filename=<IMAGE> \
> -device virtio-blk-pci,drive=drive0
>
> Limitations
> -----------
> This approach works well for features queried after IOMMUFD
> initialization but cannot handle features needed during early QEMU
> setup, before IOMMUFD is available.
>
> A key example is EFR2[HTRangeIgnore]. When this bit is set, the physical
> IOMMU treats HyperTransport (HT) address ranges as regular memory
> accesses rather than reserved regions. This has important implications
> for memory layout:
>
> * Without HTRangeIgnore: QEMU must relocate RAM above 4G to above 1T on
>    AMD platforms to avoid HT conflicts
> * With HTRangeIgnore: QEMU can safely place RAM immediately above 4G,
>    improving memory utilization
>
> Since RAM layout must be determined before IOMMUFD initialization, QEMU
> cannot use hwinfo to query EFR2[HTRangeIgnore] feature bit.
>
> Another limitation with using the control register is that, if BIOS enables
> particular feature (e.g. ControlRegister[GCR3TRPMode) without kernel support
> QEMU incorrectly assumes that host kernel supports that feature potentially
> causing guest failure.
>
> Alternative considered
> ----------------------
> We also explored alternate approach which uses KVM capability
> "KVM_CAP_AMD_NUM_INT_2K_SUP", which user can query to know if host
> kernel supports 2K MSIs. Similarly, this enables qemu to detect the
> presence of EFR2[HTRangeIgnore] during RAM initialization.
>
> Although current implementation allows 2K MSI support only with
> iommufd, it keeps the logic inside the vfio/iommufd and avoids
> modifying KVM ABI. I am happy to discuss advantages and drawbacks of
> both approaches.
>
> ------------------------------------------------------------------------
>
> The patches are based on top of bc831f37398b (qemu master). Additionally
> it requires linux kernel with patches[1] which expose control register
> via IOMMU_GET_HW_INFO ioctl.
>
> [1] https://lore.kernel.org/linux-iommu/20251029095846.4486-1-sarunkod@amd.com/
>
> ------------------------------------------------------------------------
>
> Sairaj Kodilkar (3):
>    vfio/iommufd: Add amd specific hardware info struct to vendor
>      capability
>    amd_iommu: Add support for extended feature register 2
>    amd_iommu: Add support for upto 2048 interrupts per IRT
>
> Suravee Suthikulpanit (2):
>    [DO NOT MERGE] linux-headers: Introduce struct iommu_hw_info_amd
>    amd-iommu: Add support for set/unset IOMMU for VFIO PCI devices
>
>   hw/i386/acpi-build.c               |   4 +-
>   hw/i386/amd_iommu-stub.c           |   5 +
>   hw/i386/amd_iommu.c                | 163 +++++++++++++++++++++++++++--
>   hw/i386/amd_iommu.h                |  24 +++++
>   include/system/host_iommu_device.h |   1 +
>   linux-headers/linux/iommufd.h      |  20 ++++
>   6 files changed, 207 insertions(+), 10 deletions(-)
>


