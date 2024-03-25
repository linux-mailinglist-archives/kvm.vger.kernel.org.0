Return-Path: <kvm+bounces-12608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 811CA88ABB0
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35DC03062F6
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA398002A;
	Mon, 25 Mar 2024 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EhKD4Avk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B19F7F7F7
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383849; cv=fail; b=bamxumVL1dYgN55F/a6vAMlE3fO9uGDJbM4Z7W3a3TbofPLhxSB5rD9LA2lD/xH+g6G9S/rUco20l5pct8omlIL7W0lHYUUPwTThk9VJLAzTDYZbjWWBCnxKcp1olqK+FDczerYvYYDNDnFA1M4EyKyIgGQ40sdY2Zz/J1rD56U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383849; c=relaxed/simple;
	bh=nYgikqayfrOT4BUPPqF6Ug32uSAhiHE/SPjASm0cTFQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ol+s6oemSR/M62XlE8mpFG4c1uj2MqEPuhLf+DKwE1hPiyEWleZ4PN4tSQPhRRZXCFDOeUFYa6WHMVal62nel1DIJrjdTW8a0zn9uZJMbS4stSgwyUqBYDj0Bmu43hFutZ5oSunpBhUHYBx2+hHCArufA+Rhi6dOMJ+a3rcUiYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EhKD4Avk; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPcvAocrgVDZ7WaK4MHm+Nx97ETDCIoTndQqRKVE+o67yaNKGTwhe0IHwa+MApGNSNRfcKNJAv/HeVByUM0sRl2T77ks3VXBBB7nyyKgNx3i2Cnfz7mUqAFGDD2zdTekUeySAKcr/FIcUyG52pD+sX7nj5IIaralTThu4pw9vndrZom2wBX/V9jd38aFsuwU3UFiJqNgDzCQQBl771fioZjoriLkGXCGxclqxSahtGMmzjYjJCnV5HKxmJUpHO7uqQNvgDtNE5zX2LwDX9PecGKp/AciqwBtJVoaXq61DPYE0pMVFzJ3vuvq5oLM2uk2Y6lQPkErsSWofL5tZD5Neg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lhl/RYng8iHOXj2dAmz/2i2ZIiv+hcOYP8Cq7DjhBgA=;
 b=cOmqjIgsypM5nByUby5Mrg5TpZK6XUpTE2+jAFwxLL0pB9bMfI1dooKOevFVQELnD2cRqlhAJFPMttslDs4bMfN63nRcpvw23Zx2Wu/n42JSVLMHhw0FvjyWtjouc5HkwbEARV4iL6C90AyOMmZKCiY7jB84bVWrm/r/6uEg6XKXnkCc2bcKgi8igcVFjcuauBe9VgPNOgHuTBTXcEXKei2gv7S4S47ucPg694vsciq9P51b6GiuQzMxnuHQfP6fEjh+xPB2kgfG3urNUrSsdf02sIemhbJoX6lX+MZMWFPKmVcO04B3Vb08+OTyP/wsI+DQZSYIgJpvVIl1O6y5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lhl/RYng8iHOXj2dAmz/2i2ZIiv+hcOYP8Cq7DjhBgA=;
 b=EhKD4AvkvQGNGnPN/hTy+enDkpLpq9U9/cIaZkGC8d8rcUbO+6xIIAuz304O6QJP6FqIidymTIQm6r7auSobkxGv0j2ql1lniKpRB876lodJhY/h1fufeoNmoSDboe0Nct9uLCE7RxfejNoz5Pt7DXI5An6Um9gAVqT0lPUd45M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by PH0PR12MB8149.namprd12.prod.outlook.com (2603:10b6:510:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 16:24:04 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 16:24:04 +0000
Message-ID: <39d0ed49-a6a2-c812-c4e7-444a460cb18b@amd.com>
Date: Mon, 25 Mar 2024 11:24:02 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v3 08/18] arm64: efi: Improve device tree
 discovery
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 shahuang@redhat.com, pbonzini@redhat.com, thuth@redhat.com,
 Pavan Kumar Paluri <papaluri@amd.com>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-28-andrew.jones@linux.dev>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20240305164623.379149-28-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15)
 To SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|PH0PR12MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: e50b2fd3-82f3-4aed-0ba7-08dc4ce7fcd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5aUMnr0RPQBM2+3KcL+I8/1VQ3lmnDoCQrdg8p1SB6L8CBAigylJkWDPCC+fsmsr37Q+a/zLGLwgQcR1adpohkTqKvGy6bt8EnZGaw3uVIUfO4zS09AY0aZdWCV4Ubr3GNtf8Ii64QygBbzk4jo/JI9n0zaG9OXWWIYuRltsf1l/50xSBV/XJXJVEebZ0oTqHCljHu350RrxIcuj5QCpvQ/A/FC1cpJNn5ONM5dXjiEupVDKpIShHXn8OCfX4rpwJ7tf2MwBZceYde4wDDAJlrOjGKTrTre2Cc8XN/uSXEq+eWq2lazHp1KJTnC+b3VeSXjGKu9xD5/Am+S5feEtn1GWjPPJL5lsdss+dzm7rweQ6WInyV3Zo1wlIb8RyMOdY6qXxxPZ1PSJGtdGoBuQyk9raRgkHSfMQ1cRwR44cEmYww0xBpiEeVuu5HVXNrf/7n6rQHCILNSqsKbNYIUlEnaL0qx7CR+CXtnAfbutE290q0MQBHgcg7Hn7J9coNyaIA7aVOYWA+SfhZzBHXSWlD9Vc9UV9LU02sQOnsJ7LbHd3KFX2IIm1O38+283JF3Tbv4XND45OjJZpiqVAiFGFw4fhIF21nbqREyFhL07vBuyTVBVXf/HmNjq77tMyIBmMpt3zobnmIhXmwRkexGgTXSg9JMoy8RorxLf4BVV83Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UU4rRHFvMTcxc2ZVTlg0Y2xneXRwWm1JaUJ4ekFzbjVzT2NpQlhBUHdRMzkz?=
 =?utf-8?B?MURuejY2bUlzK2hkTGxrN1h4T3YyQVlYTEZnVVJqc25SQzZza0xlMjdZTGl1?=
 =?utf-8?B?U3ZHZnRYYUFIMTBFZGE2dS9OaWdKK3JSMjgyUitrVjNOTXN1Y1hsUjh6YUlQ?=
 =?utf-8?B?aTgxNEtFTkV5cXpSK2FuVVNXbVpnUFdEVXBWOTc0bjZ6WVBQekZvYWk1U29Z?=
 =?utf-8?B?ck8xRzgwLy81L3ZVTWk3RW52U3JweG5vd2htMzk1TmRrVmY4SmRFc05UUFgv?=
 =?utf-8?B?WncwUXM3SkVwUng0akU5NWJ0emNyWHk5OG9kRkRvU0tHZzhRa3phenVNVzZT?=
 =?utf-8?B?RDRiYUFXTlpzc2Nzcm8rRzNDaHpnRnZ5R1YvU3psUjdHMzZ4SktlbURqVFQr?=
 =?utf-8?B?U05yb0VwTnhNbzhVcUJwakhPcldoQm1RVFBzWW5XUG50NFo2OEpsVlFENytN?=
 =?utf-8?B?SCtYckNQRkc5WmRWUDZoaHVPL0c5WWlBK29FSHB3SnFiVnJhUGVPVmI0ZHQy?=
 =?utf-8?B?S1FEQVM0a0lqd1FXTk5kN2g5QXlaSVZ1VkRzZkVWTFpBUC9zeWhuUUNidDFD?=
 =?utf-8?B?VXZuZTBJOWFiSHJTQ2grTVNuVXVrdzlQYUVSejgvOTlORHpUVUU2OHZQS3FD?=
 =?utf-8?B?Zko5Y3ljWVdOaVUrVHBWdkpBcW5PaGtvUFBZZnlkbXRYL2JENHpDN01LV3Y5?=
 =?utf-8?B?Nzl0aTlqdGMwUlJpL25JcFZ1N2hZT3gxUkRIc2RUUVZQQUF4T2dHU1I5Szh5?=
 =?utf-8?B?MlJFSDAxS2RVeE1zaERTVVRucXdQR2dzQUh2S1lzWlBoQ1VDL3NGM3JKZjY4?=
 =?utf-8?B?ZkVJTWJhUjJ4YjFSWlN1UC9GQmlWanREa0dsT3N6dDNDaWdNQWZwMWFET05h?=
 =?utf-8?B?UTY0NlpZd2JaL1UxWjRCT0sxWkdpZ2FrSUkyM0hSUlUxeXlCQzFsVFV3Tzlu?=
 =?utf-8?B?REJqRlp0aUFGa25ZT2I5eCtJeUlHdm5PVVZ6cTBVWittdWV1eVNhUTBGUGpD?=
 =?utf-8?B?VFd6MmRDK0cxSkZiK3cybnJWNmpOUXJnQUVBY3NHSTYrRCt1T0hXR3g1NjBT?=
 =?utf-8?B?TzZsWWJ1K096K1NENEM5ckJCbmFtcGtwdkdyY1JabEpzeFFaUXNoQ2RISk8w?=
 =?utf-8?B?a3o0c2IxZ0hKRUExZ2V1OVdRTndVY05acDAvSmIzby90d0tHYmF4NENyb201?=
 =?utf-8?B?SUs2ZVlZcmZIWUIwRExmTS91RklRUnlkWFRZNTE0UWs2bDBrZVBqWFd5VHBa?=
 =?utf-8?B?eXovTXZGeXRWNm1kc3RWSnh2bkZuTDRYT3hrWkd1WnAveXREMi90WHBGSWJN?=
 =?utf-8?B?anNwNmNQeVduQ2VQRmQrZmVJN2xEQUpoRXcrdm53b1hYOWFkYlYrV01mYjJp?=
 =?utf-8?B?cUhkVjlBeGFoZG03cmtuSURyYmRQVFpqcGtHcTVBcktmdjlhYkJzelQyK01o?=
 =?utf-8?B?VEJHNFBEM3RYd29QREJ1b1FkSXk3QnpxbzFvYTNkYzVJYVUzNlk0dWVRLzR2?=
 =?utf-8?B?TGRuZ1NtZUNqYmJRNG01aHVrT2xTOHB6YjFqdmsxTEczUHIyNzZMQ2lHbHMw?=
 =?utf-8?B?ckpNbVdSTG1BRUdrRE0vWXFwd3FKTENlbTA4azJSZ1VzRTRDR3YzZHNrU0xH?=
 =?utf-8?B?QS8rTVQzeGNvYlRPMVhLQklKbHFJelAxeWpuTjRQSjRTVnpQMjd1Y0tYbEVD?=
 =?utf-8?B?c0k3a0JQM0t6YmpFQmM1dHdQbDJIRGpCclNJd3M4aGo2NDVFRjBDOVJzV2xz?=
 =?utf-8?B?c3BkZjNhWDZQaGlrNmNMOFlBYzdmS2U2MzFnbzg3RE5rQW1LSmxNR0tmbXlY?=
 =?utf-8?B?WHBhN2w0d3pyM1grRWpjbThLN05iZFRGZGJVTXdUenBhS0h2TldEMEp5eU5G?=
 =?utf-8?B?L1FPeHpBNmlFekZVdnVQSjFqenFTazNTb0NOU1JvQ2k0NGVNeTdvZEwrUTBi?=
 =?utf-8?B?V2FBL3RMeThRWCtpMFl6cENLUUw2SkoyMCtWc2lGdFQ0dnFSd0x3c1I5aWlw?=
 =?utf-8?B?RlR1WUp1Wml5c2Rld2c5ZlVGazQ4R1FvM1JxdnpmMTJNc3ZSVmNYMnNjQ0M1?=
 =?utf-8?B?RHUyWFZoT2pXTGI3VDNNTldOb3ljOUhwN0NBVEtHaXFyZkhBYTN0bHIrandy?=
 =?utf-8?Q?TkIcvm0RPGHDtTg0qqRTc66BV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50b2fd3-82f3-4aed-0ba7-08dc4ce7fcd7
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 16:24:04.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXcLzfmn9KFmB9JseCT8jr2QodnT9HVuvgZZXmF8UMIB7S72tLc9xM6aA3mTLT6YOk1x4WGxFgelhpxxPqJNqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8149

Hi,

On 3/5/2024 10:46 AM, Andrew Jones wrote:
> Check the device tree GUID when the environment variable is missing,
> which allows directly loading the unit test with QEMU's '-kernel'
> command line parameter, which is much faster than putting the test
> in the EFI file system and then running it from the UEFI shell.
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/efi.c       | 19 ++++++++++++-------
>  lib/linux/efi.h |  2 ++
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index d94f0fa16fc0..4d1126b4a64e 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -6,13 +6,13 @@
>   *
>   * SPDX-License-Identifier: LGPL-2.0-or-later
>   */
> -
> -#include "efi.h"
> +#include <libcflat.h>
>  #include <argv.h>
> -#include <stdlib.h>
>  #include <ctype.h>
> -#include <libcflat.h>
> +#include <stdlib.h>
>  #include <asm/setup.h>
> +#include "efi.h"
> +#include "libfdt/libfdt.h"
>  
>  /* From lib/argv.c */
>  extern int __argc, __envc;
> @@ -288,13 +288,18 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
>  	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
>  	efi_char16_t *val;
>  	void *fdt = NULL;
> -	int fdtsize;
> +	int fdtsize = 0;
>  
>  	val = efi_get_var(handle, image, var);
> -	if (val)
> +	if (val) {
>  		efi_load_image(handle, image, &fdt, &fdtsize, val);
> +		if (fdtsize == 0)
> +			return NULL;
> +	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) != EFI_SUCCESS) {
> +		return NULL;
> +	}
>  
> -	return fdt;
> +	return fdt_check_header(fdt) == 0 ? fdt : NULL;

The call to fdt_check_header() seems to be breaking x86 based UEFI
tests. I have tested it with .x86/efi/run ./x86/smptest.efi

Thanks,
Pavan
>  }
>  
>  efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> diff --git a/lib/linux/efi.h b/lib/linux/efi.h
> index 410f0b1a0da1..92d798f79767 100644
> --- a/lib/linux/efi.h
> +++ b/lib/linux/efi.h
> @@ -66,6 +66,8 @@ typedef guid_t efi_guid_t;
>  #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
>  #define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
>  
> +#define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
> +
>  #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
>  
>  typedef struct {

