Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA362699364
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 12:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjBPLmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 06:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPLmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 06:42:42 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8507F46D59
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 03:42:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOpmDCjBuMSbLerrJWDJp3iEfov2BbDSzftuC02YTLesZs8XxVPptJrOqgHTuIYzHaNxL3TdhUyVn4A5RxpWThRAcYMs1XvHRQA4qqoua2W2WlWUdtwUEtbTR+EQxJIevuXhu1RjALS+F9WcaKbzhK9zwfGCpTPterRZHpC5WYF6Anx9xdF+ggC3Fup/5TmYy59PbQKcpYBnkmRvLsg6HFQ/P3MjHEHvv2WU2mlUuw58aGlyY4XfJVHw2FvvDLCdHt3hbYgRsLE7OuW2IOIuLVdHsdXTOi/pHy5HoR1P+CTNXUdLfg3iI/1jM2t4PCxJTCLmaGbBM4nFEDuwgyUFFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhfYAdVNLp5yfe04UmwGgNX/QChzyu1N/w4IGtLcXDY=;
 b=UkMwU6u7fTHWEW19mKhtG3dcfzo0yxDrMFD6vVZoBW7ORY/DigbuXrh2Q4huBDAhFmHRWclUv/FZ5Le+NtHO2ryzrfWcQIdAoeTMBFdtIWpjlQh9YRtQa9OrzI4vTUZssorDI73+BzTpaQcLkyLgcZ2RSZnL5AOx3ff+/QcHUEuLytQI5fljSPbCLOZ+Y94Qt1oYcc8nL046tcmL171ywkz38PQP7zBvsOI49i26VfPTc3FIjThtFI+9diZBgjIUumqd5oHUBOXqzr+zzQO+joBi/+FPX8vbaNtYUbiAEQq7MI0cIeBVi1EiqXgJQ/P5XwrTI+uKiwkCPiM2d1HZ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhfYAdVNLp5yfe04UmwGgNX/QChzyu1N/w4IGtLcXDY=;
 b=oYy/pdIZBO9JslTp2388hATI6hwfjpgbvcTbTEn4V+27VJQE2/y9Wn73mZN/IdPNqlHikHgbK8rlJ30R5QnhE3rQhrD/3HhSbFHb1JHoIbl7ppt5F0bIowty8zvXxiIOZE6EnbWBTdo2NIOC385KqE4269G57l1iHFhSNHTkPlA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH0PR12MB5203.namprd12.prod.outlook.com (2603:10b6:610:ba::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Thu, 16 Feb 2023 11:42:27 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 11:42:27 +0000
Message-ID: <5df77c33-21cd-51cd-92c6-46241951e30a@amd.com>
Date:   Thu, 16 Feb 2023 18:42:16 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode
 is already on
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230208131938.39898-1-joao.m.martins@oracle.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230208131938.39898-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::9) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|CH0PR12MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: b3b50508-8b92-421e-4935-08db1012e0c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mqoobOlqhWIXMBJtaJZBZghAlbHD/VxqoUv85zGSXV/0lJrBPHzyh3VWmgliVmRDYzxGu7uyqeZUITeGd3YexxQN+D27OhIS6foxkzX2bSZBn2frjhaq+QClIDLnMdycRwBPFHfP8xbsAqiU06qeqL8q1+GqS2WKi4awHPdM1Hjd97B2mERG57p3hlsbv7V2GnnLoLlQTEC0CDsiy/WWltv0doBgdkMQUOP9mePgasJyvvKJ1qqN8wh+R6Dub1a0jtUe87w4IZX5lanEeCdXtn38IzSGYaDAMWJxant77gqVC2jZ68EGpqdW0bfT5Cpazy0K/ZG2L0FHhj1MIB4EIku3wmmOb69D5QRLbyuLhsW4dA9naid+QQVNV6COU2J7bVrS4DOmNfz6/sDre8/K7Y/IThRshSKDWHSjngcUvKuKoxAHg1Li3Z1lmYErbwY4ftfxcvLhyYNocdHVOCHQQ+ToWq68pGVW17yctplP3x1crhXmVkdepKAK5ANQgHuMSzLsAFkzMAxgq+pfQcK3TXI+825gLMKHMiQLPaw5kIiR0YMGwMV7L9aofVjKMDPihng5y7dluIMzqJ/4m25YA8AQuhQWk7R8MiUJUS1fLUiMS7qaLoSMuY7yn8keSBBYFd1Fa3KTKHZCevNLtKGAkCJlQWIFogOfw3ixcHfLBGM6FCjV+MIhvJL7vLH6C9FFAqohuGaaJANPvzea26nxc8i7oUMumDchhCz+GZmU9ak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199018)(53546011)(2616005)(316002)(2906002)(15650500001)(478600001)(31696002)(38100700002)(8936002)(8676002)(86362001)(4326008)(6512007)(6666004)(41300700001)(66476007)(6506007)(36756003)(5660300002)(66946007)(31686004)(66556008)(26005)(186003)(6486002)(83380400001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlVTb2UxbUpDVmVXd2hLdmdNamtsejNHVVRiY0ZicGYzRWdRWTNKWkJGTlBV?=
 =?utf-8?B?Sk12akF1ZHFVVStSMlRSaTRobWg5RC9sWjB6eHRnRWlVd01jRXhMWXFDbE5B?=
 =?utf-8?B?MmwvbmxtVkIzZEFVNWJ0dUxxNis3QXlkNE5ZbnFET0hOUlIzZkh3NGhwQVR6?=
 =?utf-8?B?ejh5WVorUnZ0RGJ1Q0xtemlXTDJudU4rdVlNZ213MDhZWkNBK0NLMkpXbWdX?=
 =?utf-8?B?TzNXMkxkZFFLL09xUXpBdXlpeHV0eURHY2xVTnJpZWJ4L0VUVFo1eWpDSVpp?=
 =?utf-8?B?ZkZ4QXFkNEJkTEU3Ui9ublB2dWVkSlEvR2FQLzNuZjljeSt0c21xZWpOVFhV?=
 =?utf-8?B?MFYwU1JmbUxERVJlZFJDaExsK0pSa2lZUzRxWUZQOEowNmV3Y0tuRHVxL2VH?=
 =?utf-8?B?d01la1F6eHIydExLZUt3YzVHbHhvUXlDdlg5SXJYNnR4SlcyWGtyRlQwV1V6?=
 =?utf-8?B?TGloMlhyUXB4VHNEYVFrL2l4YjVxVXFiM1M0bXhnLzdLWjg3ZnNNWE83cXBE?=
 =?utf-8?B?ZVpIYmN0eC9lMHJ3NFhjQS9EQ0VvZU9yRmV0NTNnMjRtVU5WdjZ1em9FTS9U?=
 =?utf-8?B?VVVta1RiNGtWalp1bm9BZmduK000VUJLV2U3VGhwbHBueHJWM1NVOWtBKzNp?=
 =?utf-8?B?QTN1NFArSVVKK3BYRGs5SURWWUN5cGs5OTZnbFV5Tkt4R1Q4QzB6bFlFTGFY?=
 =?utf-8?B?VkhoakRNOU1RcjFJR3FlVXhZZTJJL2xJOUNMemFiRnFhQkxtUjNJTnBkY3Ru?=
 =?utf-8?B?QVdMcGYyOG1MTFVaeEVpeGdRNEEyMTBPZkFhdHlJN1lvL2IvdnZwcGVrblJI?=
 =?utf-8?B?THNsY3N1cVBMelVtQ2t4STZucXh5NktoTTlDZGxnL2xqZHB4WFlWRXg3V2dm?=
 =?utf-8?B?YnBkN2Ewck8xcDg4ZlJMLzZUSXVwZjJnN2svYnhDMWNxZFJhaHptdHdPUWg4?=
 =?utf-8?B?aDRPTGsyd0hZL1orYzY5OEFCYXNHNkNCdENtbHQ0ZlE0dUovb2Y0R2I0L2FS?=
 =?utf-8?B?VE4vbm84cXR2V1prV0hRQ3c3OU55OFFIMEYyU082NkdKbzVtaGdIY0xyUHY4?=
 =?utf-8?B?eXJmSFhSM2xHY3l0YkhGYmdxQVY0SUMwZUxiZUpXVEU2cWdKRVFrNjBiVHA1?=
 =?utf-8?B?dkdCcU1qS01KSW11NWNyVElmSk4rZzdMUGF4TC9hNVhoeDZMbkpHZjRQcVpF?=
 =?utf-8?B?aTJFVzFQTm4xVko1UGJYL0tHcGFUNDZoWFhkZG04SldUSUIyK2VEU0taWG0r?=
 =?utf-8?B?bmUyVWR6MHZQcVUzYVNjR2FmbXdSdHlxQmthMDRVQWJyZWxUUVE2eXFyUmRW?=
 =?utf-8?B?eVhRL3E3eXJKQWI1bC9iTWdFNm5HMUpqUWpCZHc5MnBzMTc4UTk1Rk85YUVr?=
 =?utf-8?B?WjZPYXY4ME5CNk01ZTBXZVlaU2VIZFkwZXhxNjA3eUtIWE5BbE9yU0llenhw?=
 =?utf-8?B?dk1JTEtyUmEzNm84SEJodUUzNDJWSDhORHp1ZTZXVXN4VGNOMEpvOXJ0dlpp?=
 =?utf-8?B?bmhjNkpUd2w5U0lKOUdSVEtmRW1nNGhTcStTVEZmRkx3cE1MbE4zaTUyVU1P?=
 =?utf-8?B?b3NnRHVpRG9XeXZzUmlETkhLSCtNTzFoL2FSQ2l2d0ZzWVE3RWRoK2lYUUxl?=
 =?utf-8?B?ZWlsRHhkVjluRXZVWnQ3ZUdCZnpHcjNyWG43ODFKbEVUVkI0aXoycXY3MXFa?=
 =?utf-8?B?NmdFVFVlbGl4VlBrUnhzNlpVYmNPSU5hTnNaVGF6b0REYU5SZUpKREwzLzZ6?=
 =?utf-8?B?WEZ0WkI1bmNHdlZtSmFHV0U3ekcwN0RtekkzRzVXdXhhOTc5b09yRzVPWEtm?=
 =?utf-8?B?NmlGT1F6Zi91bldsSmcyRk9qTHZna3dGMnZFYmErMXVjYWl3WjFKOTRDNUtD?=
 =?utf-8?B?UkdGZDhqSEwyOEszY3l4QVVZVWtDR09ZbzBHMmhsaEttbWw2cjZ4UWtHZnMx?=
 =?utf-8?B?MUxwNXVsU1QrU1YrN0xwc1RVd1NJaC9teFBDTmgrRkY1Y2pxODZJV1NkR0J2?=
 =?utf-8?B?ekhvWXlYN1I2Qmh1R0N0TFhqZzJsQ3NWeHRYWDhuaHB4eHhKODlQTnJteThO?=
 =?utf-8?B?SlFCRWMwYkROZU1GYU1Nc25nTU1oNDVnRSs3NUl2aEpCM05aL2MzaFRhaEdl?=
 =?utf-8?Q?aKqjUdSpUhVq8a0oSPTBCibIH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b50508-8b92-421e-4935-08db1012e0c5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 11:42:27.3131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0Q02suQ/mkbIoFxEVxZRUokAncm/coWT4sq6l8OhqAncI/SDzTA9f3rrdMVKr1/IXy9f0KUu5jCKen5k+AmPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5203
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/2023 8:19 PM, Joao Martins wrote:
> On KVM GSI routing table updates, specially those where they have vIOMMUs
> with interrupt remapping enabled (e.g. to boot >255vcpus guests without
> relying on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF
> MSIs with new VCPU affinities.
> 
> On AMD this translates to calls to amd_ir_set_vcpu_affinity() and
> eventually to amd_iommu_{de}activate_guest_mode() with a new GATag
> outlining the VM ID and (new) VCPU ID. On vCPU blocking and unblocking
> paths it disables AVIC, and rely on GALog to convey the wakeups to any
> sleeping vCPUs. KVM will store a list of GA-mode IR entries to each
> running/blocked vCPU. So any vCPU Affinity update to a VF interrupt happen
> via KVM, and it will change already-configured-guest-mode IRTEs with a new
> GATag.

Could we simplify this paragraph to:

On AMD with AVIC enabled, the new vcpu affinity info is updated via:
	avic_pi_update_irte()
		irq_set_vcpu_affinity()
			amd_ir_set_vcpu_affinity()
				amd_iommu_{de}activate_guest_mode()

where the IRTE[GATag] is updated with the new vcpu affinity. The GATag 
contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM 
(via GALog) when interrupt cannot be delivered due to vCPU is in 
blocking state.

> The issue is that amd_iommu_activate_guest_mode() will essentially only
> change IRTE fields on transitions from non-guest-mode to guest-mode and
> otherwise returns *with no changes to IRTE* on already configured
> guest-mode interrupts. To the guest this means that the VF interrupts
> remain affined to the first vCPU these were first configured, and guest
> will be unable to either VF interrupts and receive messages like this from
> spurious interrupts (e.g. from waking the wrong vCPU in GALog):
> 
> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
> 3122): Recovered 1 EQEs on cmd_eq
> [  230.681799] mlx5_core 0000:00:02.0:
> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
> recovered after timeout
> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
> 
> Given that amd_ir_set_vcpu_affinity() uses amd_iommu_activate_guest_mode()
> underneath it essentially means that VCPU affinity changes of IRTEs are
> nops if it was called once for the IRTE already (on VMENTER). Fix it by
> dropping the check for guest-mode at amd_iommu_activate_guest_mode().  Same
> thing is applicable to amd_iommu_deactivate_guest_mode() although, even if
> the IRTE doesn't change underlying DestID on the host, the VFIO IRQ handler
> will still be able to poke at the right guest-vCPU.
> 
> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
> Some notes in other related flaws as I looked at this:
> 
> 1) amd_iommu_deactivate_guest_mode() suffers from the same issue as this patch,
> but it should only matter for the case where you rely on irqbalance-like
> daemons balancing VFIO IRQs in the hypervisor. Though, it doesn't translate
> into guest failures, more like performance "misdirection". Happy to fix it, if
> folks also deem it as a problem.
> 
> 2) This patch doesn't attempt at changing semantics around what
> amd_iommu_activate_guest_mode() has been doing for a long time [since v5.4]
> (i.e. clear the whole IRTE and then changes its fields). As such when
> updating the IRTEs the interrupts get isRunning and DestId cleared, thus
> we rely on the GALog to inject IRQs into vCPUs /until/ the vCPUs block
> and unblock again (which is when they update the IOMMU affinity), or the
> AVIC gets momentarily disabled. I have patches that improve this part as a
> follow-up, but I thought that this patch had value on its own onto fixing
> what has been broken since v5.4 ... and that it could be easily carried
> to stable trees.
> 
> ---
>   drivers/iommu/amd/iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index cbeaab55c0db..afe1f35a4dd9 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3476,7 +3476,7 @@ int amd_iommu_activate_guest_mode(void *data)
>   	u64 valid;
>   
>   	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
> -	    !entry || entry->lo.fields_vapic.guest_mode)
> +	    !entry)
>   		return 0;
>   
>   	valid = entry->lo.fields_vapic.valid;

Apart from the commit message change:

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
