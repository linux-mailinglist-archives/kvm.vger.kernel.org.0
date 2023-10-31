Return-Path: <kvm+bounces-253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 657FD7DD8A9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADEC6B210A4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 22:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A1127466;
	Tue, 31 Oct 2023 22:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G3UY0Y0V"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8012744C
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:56:27 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A381910A;
	Tue, 31 Oct 2023 15:56:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6qU6sfLiSBrcltbcgqxYCjyYGAvY6vFEiqUvO8RExLWBZ6Pn1t4/7iJHMs3dB88HeXwaK873YgltB+aWftuidyjQze9VkM/s6OB6pC4vOJXd3cBUgDE8daHlgHy0B2Z9j/mHc6lx3+qtvWApAqrM7k01NLOpb0HO7m/DJvxUMjbQ9nA+qM/41sTKVXaVbBCZzIUOdRBdAvdgdIG2oEHxhi7GBN5Y71jONgHPa08HSsnT7IhEFAPU6nw/blOLg6FImJGuDPJaLskT/rxmZ/j0EtZEcdIZxBvJnDpREznqroudEO0a4U0LyOaooJ8ILIJX0T08oWk4xGnlLMZPdcvow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TM/du3fLk1yqES8zTn4pd8zqcPj9x0EB2RkYIUTm5Q=;
 b=VsWdnLjLCrv42tne4pOT5PH/YZt0nJeJ2YHOy0vLOpHrO2Vplap5VNAMVGmBjoJ3xlAFhz/drhckPo/xBSQ8nHGVJ0K8+khI+SXpReyUvuqpg6Ozr622zjoudpg+kDLuJg3TGxDGIgLuChzAAxLesXrZzFbQIWcCsuECBQkzZl7xV3sZTdtdjbMXGR0DKU2fplxEJTsU+UHtkR4YUCa2JIdHn27mIFvFLK62UksC3TGORnBZe9aN0qCxyDE97CzEH2QLR+xAXjXewotCTgjMJiemvav2lVSOYoxfL3R0p3IrgYVWIN78hky6mjSWBr76avkXIVkk8yjpfSdJPn7E6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TM/du3fLk1yqES8zTn4pd8zqcPj9x0EB2RkYIUTm5Q=;
 b=G3UY0Y0VVRBo223gKOAz8gZY4pvi0BCAgrSGn3C5zORg15Uqsy9qmfMKeYLogcoSA6xBNfeJkxnwG4W4qPoE77+SZYzLDPcibw7azlyoJt8Pv9xxqr95Nl+fvr6eI2eNtEwasGc5XnMit83bxZTwhgRoo4Ebmh7YZMMdky+AfcQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.27; Tue, 31 Oct 2023 22:56:22 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2%7]) with mapi id 15.20.6954.019; Tue, 31 Oct 2023
 22:56:22 +0000
Message-ID: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
Date: Wed, 1 Nov 2023 09:56:11 +1100
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-coco@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org
From: Alexey Kardashevskiy <aik@amd.com>
Subject: TDISP enablement
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0048.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::17) To LV3PR12MB9213.namprd12.prod.outlook.com
 (2603:10b6:408:1a6::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS7PR12MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: c99b06e4-180b-4115-ad0f-08dbda6499a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KBjTHR7igBqwhLsVt+fYAT2pEEoj8CiLv2UnP3K/Qj0/t5vOUjkXpN6FZqJfBhGKS90PG7miotWhXIAcvua+OgxwOpRSFbqnmVp8MIeie/B21NI+cVnPxdFJAwWum5hYq01BPBKmI0UI5FC4kbvt/mnJ47QVd2h+lOzAuvMrBJmTh65T6BL5ucTF3JNjIB4blCq7XO4dFTMMFL+8B4MGio75runYtLE4vn5KHMCcm1+UQ0x3lYvn84REBP6PHSemWPE+3ms7/wUtKQE/DpWrNGzTRu3R9ZKEhcC8dJZhFiil7ooHoaS0CVXrSPrc9ouAbyu3AEl4ITHaUcD7VKswFpL0RS/BJ68e9m/6pQw48cE4NDZo6IpUTpNB2mek+BuF2xr3Xh3a6EYY/JlqDdVgJn0xj7tAQiSv3bo9+FXYpPTC/cWp7BObBDsDrkDF317Rz9tlW62u7hHwaROKFdJT783BGukB1BZwVlvtqeZCmJhuXXtfQdDMr7qSbzbSbJ7E/uZfk6DLulFvmIrlGAvajOldudtlW6xukS68P83uDGiR7sdEEWQ7vA25Cq+E74MKLWsUk7KTwcMe5uHRT423ILuJ3HQLbfULSrrV0af7NbFsypqRs55M1DYYLQYgRmBrYK4jzzF7/MxF73c34Nvpxg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(136003)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(6512007)(6506007)(6666004)(478600001)(83380400001)(2906002)(41300700001)(5660300002)(66946007)(66556008)(6486002)(66476007)(8936002)(7116003)(8676002)(6916009)(316002)(4326008)(38100700002)(2616005)(3480700007)(31696002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTJodCtEVUpMMnA5M2hIRzVuTmVUMll0aWlpZm5DVEVoMmxwZE03ZkhMNWxm?=
 =?utf-8?B?bFM2Rnlsc25NR3lsL003UXR0Rng5VEZxdU9EcC9OUmlpZTdzUVRHS1o0MTlQ?=
 =?utf-8?B?MzdCVVhETTlOSk43MDlwMUlaR0UzRlowVDhRbHRQK1dXY1pmUjZ1NWJrSkxZ?=
 =?utf-8?B?bkdsUkMwTFFoUjBaYmtXK1J2cTJrc01ocWhkeGErM2VibHJUUDFpaXhJeW5m?=
 =?utf-8?B?WW9MOGpWNHJrNVVvbTRsWGUrL082UzZFbjJqMnhyY3VkbjM4V1lCTEthblRk?=
 =?utf-8?B?VFpJaEgwSm1LdjJXOWNpVUxHWEtIMGsrM3hEY21TWGlyRVUyYnZxN1NiMFZq?=
 =?utf-8?B?SGtpUndEYWJJUHVJVXZvRVhPeUtWVU5OZC9sc29wdG8wcFJobE1SRHZTclJ2?=
 =?utf-8?B?bXZUZENseFBNZk1MdXpLUmQwUEZHbUQ0Qjd3NnRtUDhWRlZuQU5iZElIM2dy?=
 =?utf-8?B?ZmxVQXo1V0N0U0R0R3ZHWjZDMjNyNTFrSGM5M0RFOExKNFQvWFNwOEtpak01?=
 =?utf-8?B?bWVGMzBkY0RCOVMyc3V3aUFkT29VVmVodTFkbnJxdnBPeWt0UzhESzBXVlRw?=
 =?utf-8?B?VW9EdWhFaDZkcDZBWE9MYm9GTmJmMXF6aStXLzhISUJWSjNhT2FjUXJPUS9R?=
 =?utf-8?B?bko1U2xySVQwbHh4bUJBL0tVY0J0eXE2dmtWSDJ4SXppVkF3aXdTdENBbkpp?=
 =?utf-8?B?N2pvOGUrZjE2aXhSdlpUQTF0aGZPWXhQWG1vM2k5MldQRG51MlhPeHU4SDFD?=
 =?utf-8?B?S2M3Nm83Zi9waERKNCsyZVVQaVlSSFh0YjVndzlEODkveHhBQzhLd3A5NGZG?=
 =?utf-8?B?Zzc3OG9qQ2NWRzV5MnJXYTUvMnVFTWFpTko2NDZTSzUxQmZqUU9ZdzJURnRD?=
 =?utf-8?B?M3BzcFJHNStMZkhtRkdnOHpTZFd1TmNuWVdya1laZXpod3FiS2lDQ2VLYlNN?=
 =?utf-8?B?ME9pRkhwQjVXVlhXRjNGMUFtQ1oybUI3WDI3bEozVzRaNkxSanpzdm1YemNk?=
 =?utf-8?B?dUpuZjhBTTNpTTk2OGRaVnpCYmgrWWs1QTlObnNYYytzbXFudW5EZGFINlEz?=
 =?utf-8?B?S2I0SEtXNmQwbnlRZWh6VnBxWXpLMXdBbEpLVWNuTGlIeWdmb1JYL3pBSzJR?=
 =?utf-8?B?L0JtaUtueWRETjY4Ymw1MjdlOW10L0tyTWpqRmp6M29JaGNrZnJFNHhXYW5L?=
 =?utf-8?B?M1QzTDFxUkRIY3pyV2g5bVU2cUJUakNRZkFHeWVtUlBjcDZodTgyNHhReFhs?=
 =?utf-8?B?UGllL0tzS0FnRDEvalVTSjBLSUpjc3Zrcmg3OWRueUcvcFo3Uk52V1l0T3U5?=
 =?utf-8?B?V0h4Ymt6V3BmUGRnY0tuZHk5a0t0SFF3TEpndlp1eVRHcTdMeFpCaGxuQjVB?=
 =?utf-8?B?TFRZQndEdlRFN2tvVUVDUElQNE9kWTU1dFhlMHhsOURMQWJ2S1Y2RlYzMlFZ?=
 =?utf-8?B?ZlZLNm9OVTFIOTVOUjhGajY0R0xoNE1OTUVJQmFjVmw4TmdOQW9KSU91OFRr?=
 =?utf-8?B?NTJVWnlOMFk0YXpWemJBNUpwVm40ejhORUZ6VW5SQjZKNHc0bCtHMWlFcjht?=
 =?utf-8?B?bkZ0cXJ1WitUL2huMThONyt6L3ptciszTlgrc2RQWFpodXgvNzJ5a3krT3Ns?=
 =?utf-8?B?YVVLSGNjb0Qyb3RLcFBiNXMxa1A4dXRyZC8yMWZQQzdyZys1YWl6c2ZKeGVr?=
 =?utf-8?B?L3Fic01Pci9USGJGZml1eEh1SGJYd3NkUStuNXZTZnFFb2p2citsenl4M0JC?=
 =?utf-8?B?STJRaFdVZzg4TDF5T0dnRC9TczJPWW5ZUy9oRkgxRlhWZ25ZdHVVS29jRnh4?=
 =?utf-8?B?TnV6dFdncFkrMGZMSXlCNHVzNE92UUt4RGV6K3BaM2EveTRSMVE2VE1hQ2Ru?=
 =?utf-8?B?QzRKRXZ5MURaSUN3ZkNvMGhWdmtoc2lZQlRYdSsrMkx2UkRUZEk5UjYySjF2?=
 =?utf-8?B?L1V5bEc3RGJIWmdwVEt6NTVBaDlEUy9HVzRTS0JEanFzOGIwandLeUxlc09m?=
 =?utf-8?B?ZC9PR2FEQXkyOHErdlVtbGoxMGQ1cmlsTlZRUEs5OUJ3ZzFxSjVjaHhEODdN?=
 =?utf-8?B?dDYyMXoxd2RaaHhlOHVIUm0zNEtzTy9GM3NWaDQ4aGRyME9LeTh2dHRCcTZP?=
 =?utf-8?Q?do071ToUwufgf89Y5wNRZYS59?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99b06e4-180b-4115-ad0f-08dbda6499a2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 22:56:22.0105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KNJA9OSUVJsAkuH9WjIumpEM5mWGDysCSzU8kQkAWbmtg1nTFs2f6ogGLhL1h4m+esAFG5MPAf7NKvBDRjtDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936

Hi everyone,

Here is followup after the Dan's community call we had weeks ago.

Our (AMD) goal at the moment is TDISP to pass through SRIOV VFs to 
confidential VMs without trusting the HV and with enabled IDE 
(encryption) and IOMMU (performance, compared to current SWIOTLB). I am 
aware of other uses and vendors and I spend hours unsuccessfully trying 
to generalize all this in a meaningful way.

The AMD SEV TIO verbs can be simplified as:

- device_connect - starts CMA/SPDM session, returns measurements/certs, 
runs IDE_KM to program the keys;
- device_reclaim - undo the connect;
- tdi_bind - transition the TDI to TDISP's LOCKED and RUN states, 
generates interface report;
- tdi_unbind - undo the bind;
- tdi_info - read measurements/certs/interface report;
- tdi_validate - unlock TDI's MMIO and IOMMU (or invalidate, depends on 
the parameters).

The first 4 called by the host OS, the last two by the TVM ("Trusted 
VM"). These are implemented in the AMD PSP (platform processor).
There are CMA/SPDM, IDE_KV, TDISP in use.

Now, my strawman code does this on the host (I simplified a bit):
- after PCI discovery but before probing: walk through all TDISP-capable 
(TEE-IO in PCIe caps) endpoint devices and call device_connect;
- when drivers probe - it is all set up and the device measurements are 
visible to the driver;
- when constructing a TVM, tdi_bind is called;

and then in the TVM:
- after PCI discovery but before probing: walk through all TDIs (which 
will have TEE IO bit set) and call tdi_info, verify the report, if ok - 
call tdi_validate;
- when drivers probe - it is all set up and the driver decides if/which 
DMA mode to use (SWIOTLB or direct), or panic().


Uff. Too long already. Sorry. Now, go to the problems:

If the user wants only CMA/SPDM, the Lukas'es patched will do that 
without the PSP. This may co-exist with the AMD PSP (if the endpoint 
allows multiple sessions).

If the user wants only IDE, the AMD PSP's device_connect needs to be 
called and the host OS does not get to know the IDE keys. Other vendors 
allow programming IDE keys to the RC on the baremetal, and this also may 
co-exist with a TSM running outside of Linux - the host still manages 
trafic classes and streams.

If the user wants TDISP for VMs, this assumes the user does not trust 
the host OS and therefore the TSM (which is trusted) has to do CMA/SPDM 
and IDE.

The TSM code is not Linux and not shared among vendors. CMA/SPDM and IDE 
seem capable of co-existing, TDISP does not.

However there are common bits.
- certificates/measurements/reports blobs: storing, presenting to the 
userspace (results of device_connect and tdi_bind);
- place where we want to authenticate the device and enable IDE 
(device_connect);
- place where we want to bind TDI to a TVM (tdi_bind).

I've tried to address this with my (poorly named) 
drivers/pci/pcie/tdisp.ko and a hack for VFIO PCI device to call tdi_bind.

The next steps:
- expose blobs via configfs (like Dan did configfs-tsm);
- s/tdisp.ko/coco.ko/;
- ask the audience - what is missing to make it reusable for other 
vendors and uses?

Thanks,
-- 
Alexey



