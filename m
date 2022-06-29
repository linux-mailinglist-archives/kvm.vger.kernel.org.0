Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD82560A85
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 21:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiF2ToU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 15:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiF2ToU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 15:44:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F9D255B4
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 12:44:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0KF5BGLr9ZmkHZu4HMjtlLNFW+cpu6tlK3/vrUNtjazqgUS3C51LmGfvokayyFwmiHyzV9KucIKpvxJGqKOAUNwPIXiV+qhGfmSsfTpt2NVt4L0Mr7NSbRo1y2xVBsYA18fejnO+vPlHAvXSd2Dn2XT1LbvFLbE698aowSpSGManfbKjfgTw/fhSnuYhbtReXAgmQfwIubYkvvW9C5HGc9X2rvNBo7UXRgm9JPcTmdMUGTdpe4KrS2djPT5UW5XMVPe1K3AgLVIALaWRJgH5wtMhqE/YdNctGn6kdAJWrzTCbXAC4YyCzfgJL3FXZy9cno6arVuRQtLx9Zm3a3CKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHr6kMtvIbq8g+mEImb+WNMEF4pNuhFX4M+P3zf2+9M=;
 b=U7VYIxrPCtn3AkYAio+DkZLlUcjfWOskbyYbCf0c9Lk309NHxSjGFwcD6piTZsmxKR29pZch699/hvQfI4xfm+kf7oi3DLn0lep6moixqEke9eSA1KU4jfPMda775GcmKQ5vMqfw735vV2PFwvG52GepIKB197yWapR5mwgMzvSQ9UbFQmPpStzW1dtaF+XEnWGzkc2Y88HIIQ78ey75IjR1dihFlQj3m4LUdKR1r3cbX2vm4EAeZiwoWoiCwfaCkLwb1d862MDN/8JVSClVKyiFIw2eoh2xEFyfhj3zGm7mItj8J8E6QrIx6X+dX8Nu4n7NnzFmm06hWBpuFiRe2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHr6kMtvIbq8g+mEImb+WNMEF4pNuhFX4M+P3zf2+9M=;
 b=cEitfvPgBXTjMP2kCa1x3L6SmJKWDDNNtaBQ48L2c42KUVqp+nER1IfpAaFdb4O9Wsb9ErUnb0v6e720OMxmG2/h8rNB5PHew38iZCeNsRM47zNRDECses37zYg81gZ2WrDqTiJ/fiv9pHG/7ZjEjRCZjuYrMB5gDszo6jNBhc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by BYAPR12MB3015.namprd12.prod.outlook.com
 (2603:10b6:a03:df::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 19:44:17 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::1001:3c79:9504:8d6a]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::1001:3c79:9504:8d6a%10]) with mapi id 15.20.5373.018; Wed, 29 Jun
 2022 19:44:16 +0000
Message-ID: <a9a83068-326d-d9d3-32db-fbb276931d10@amd.com>
Date:   Wed, 29 Jun 2022 21:44:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] target/i386: Add unaccepted memory configuration
Content-Language: en-US
To:     Dionna Glaze <dionnaglaze@google.com>, qemu-devel@nongnu.org
Cc:     Xu@google.com, Min M <min.m.xu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Gerd Hoffman <kraxel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20220629193701.734154-1-dionnaglaze@google.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220629193701.734154-1-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::11) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd1bb49f-0158-46ec-bfaa-08da5a07c05f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3015:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCYEvdLX6SOxxFQrH8pAlcr7VWNxCOhBB9PrrzdiIUXo0MAJ2VGoV6AfrrDefQhFRR/4viq+ewY1r+yKomwzJFaeHKNCNL6GxKXhoUkIOdKSytSOsBUqZWZYpBPYtic1evUBxfvOXxEbnIcaElhuNpNvlUT0obeAAi5iYukP+K92aXQvlMgG62jfiJNmdasQEaFun2lB/p5MVPydgXYpSjM2ou8/i3z6yZddoeGV6HX3tESZu6GDmHEg79Tu2dGO5V+Z/5ccTPNe7BnDqHVViZXg67x4JIoaJjzIoG62vxVNiIlqKzoRcPfgAHI6HG3RkXsbnUmOSMnEdWDRII8YNgUepsjwzT/p1Pd5pzWMj/wNqgtUL4i5nyKWSn3DpJNmYOeJj8pea3AUQK1JuYI6E5DOojj5o3ROYmON66eoi5kV8VYwzSsnwJoEKmJ7Mo6jc+5yB2bsBC3OP5ZQIxldzg8xrT/7EmH5eCwnWI1Am2uhsIOiJfLCQBKR8IMN1qYBAK1x0zC0vV6fjWPhmacyVMXOgMhNOifpXtQqyn6cFBk5trthOzAT1jbp5Vjj/oZUQOBTsM4KgF2YcgmAHVSAxQ+ypDH7NpEbdeTbAFK4Q281LYpafvEqgyM9vc25IwPJS659rTEzWB9c+QlQ4DAf+i+1XerMNlKzEiZ/anSig3KbBBGac3ATm9fetyTuZXAKs7hTycFaMmCnieXH27k4SHOJw15p6JC5+TtKYSIXPq6mJwBHLltZ9Uhn9Zg956z6R4drMzQhmScQkXd7vIgfHziTsNsYcIrIidWZIEc8xiyGox3oH4MhcyzlYbV6Q9pI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(66946007)(4326008)(66476007)(8676002)(86362001)(38100700002)(6486002)(66556008)(316002)(31686004)(26005)(36756003)(6506007)(2616005)(54906003)(186003)(2906002)(6512007)(83380400001)(478600001)(8936002)(31696002)(41300700001)(6666004)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGg2NzdRaldIbFR5ekFtRTl6RkRDL04xa1NVTDBVbk5UNnlHRkZQVnpWekJC?=
 =?utf-8?B?K0llNkhRcmJCS0xIN25OYTdoaVhCT2QySXI3RFRhOWhpSkdpVzZBZEttOElY?=
 =?utf-8?B?UzA1RDVQN0wrampKcm1NdjhOc3hITlJpMjBTcUxidGw1OXZHQVp0U3prSzlQ?=
 =?utf-8?B?VDVNSTdBTm1JeHd4TkRDcVVMdmEwZE5SaHlvNG1sVzZjOHpwb0RIeFhsYTZw?=
 =?utf-8?B?Z2diL1hFcDN0RnR0Zi9COUlHYm02a0MrYkJ0V2d6SXhNQk1ocGNZSmZFKzhJ?=
 =?utf-8?B?d2VPTkZlYU11eThoNGt4aFZjSHMzcFM1Rko4WEh3YmNWVTBOeUlId1R6SHcv?=
 =?utf-8?B?VHh4SWtoaUNoMEYvdm5SV2NrRXJlcjZMazF3eDFHdEIxUmlTY2RBcDFOa3RE?=
 =?utf-8?B?L3orTndsV200KzJ4eWQzUDU4M1hINFFxSmxBdmxQVTJHaVh2N21zZzVyVy9V?=
 =?utf-8?B?UGIrV2hmeHZFUFhyZUo2T0cySVc4WXk4R2FyVkh3cjhXSWVPbWtWbUVFanpV?=
 =?utf-8?B?ZEpzUTZhTDZYcXZwM0tvNGlQYU1zYy9uTVNGRXV4cEhIczVBOXYvWmxqK0Q1?=
 =?utf-8?B?WVJ6ZUVrMUJ0ZXZNd2JsVVVXT2UwNTE4ajdTMHpXdlhwVTdpNkt2SEM5UEE3?=
 =?utf-8?B?NXdQazhRckx6SnVaWlhXREhXMWNPcXJkSmhRMGtFYVRxT3VUcmRGTGpkSmxj?=
 =?utf-8?B?QTNZZUJwRS9LZmM5R1JoK0JxMm42cE9kVDhrQUlqczFjSVNYV2l3cGd6b01H?=
 =?utf-8?B?WC8wcnBWaEtnbkZWem93ZVdCalhqNjk0Z1lqZm9KaWs0ZWFXRDgzMG5rNnRC?=
 =?utf-8?B?RkxGU24vL0FCWC9pTXpDdy9Dc3JPc1pEaHJqU0ZFV3dtaXBPNko2ajdzYWxD?=
 =?utf-8?B?RGs4N2tDWC82alQzdmlWc3UyNDlaZmVySC9sbmJubDRiVCt5OWZBYmhPZUwv?=
 =?utf-8?B?L09XT1MwVFppZk8rVFVtTjdjUVl1bWRNclFNRmVic1lndXRCRDc3QS9ON3VP?=
 =?utf-8?B?YnZhTU13YmhsU0l6K1FDVU84V3VVanh3TzdGdUUzSUtYNUs0SThPNUlYV1dj?=
 =?utf-8?B?RWtnd0o4dWtRY2FOSHlKa05qV3dpcjE4NHdualA0RVl4VnNtMGt2Q1VJRHA3?=
 =?utf-8?B?bTYwZnFKZEI2TUhpVFpnUGkwWWtaVFFySmkweVRiWmRGT1poc3J0ckVJeFBK?=
 =?utf-8?B?RGpwWEYxK0ZKUmNnVlYwZnA3eXZSVjdWOHk4TUhVQnZtZFEyN3BIdXR2OEJE?=
 =?utf-8?B?ZXFlckVqanVDZi91cjluQW1MQ3g0RnJneks0Tlg1ZVNrZHhyY0ZOZkpMUlNS?=
 =?utf-8?B?STA5Q2t5ckE4NU43aUxiSll1TVFvSHQvcytaRDFzdFRsMmpiVEg0c0dvbnVl?=
 =?utf-8?B?aWJKdk1FbFh6dUZnYUdRcFRvaUxBeDc4Wk9BTmxBcE5jcmhudXhVZHNvUzln?=
 =?utf-8?B?V1VQNDJmbktmVHpDV1lBMVlkMUpsZEwrSDdmLzY0UXVRa2Q1N1c3OTRoTTdW?=
 =?utf-8?B?VkVUT3J2emxWM0pmSnptQ01PcVVaRFRTL1hJUW5YVFRXbFNFU3pvMVpLV0hX?=
 =?utf-8?B?UXpEbzIzL0pUVU5qZWhHWEpUdnQ4ZEFBS05kQzJtUjdUKzliT0E0NHRkd1JH?=
 =?utf-8?B?Nyszb0I2Vy9ncGZuTGYxTkwreHROZ0wxbDAyM3dYeHRSUE5mMVZVaXdxdStU?=
 =?utf-8?B?bjhYVE1RYytXQ0x2Ujdac28xRnFFV0tTUlljTnpScnpieG93Z1puQ0dTczk1?=
 =?utf-8?B?M1Q5NHcyUERyNGV3bno5eFhPa2I2UHkrMVFna1JpNDVXRGc1UXhUTk00WDRk?=
 =?utf-8?B?UW1wWmZOVzExeE1uYmgyNU9xMEZDZmc2azlWVWNSb2NKM0dVcUFQaWJCM0xH?=
 =?utf-8?B?eVByTmhGOXVVQWVVUUErUG41QlVHdWQza0xhZE90SUdnSFBCWWpYcFQ4ZDhq?=
 =?utf-8?B?S3lRblNtamREQzRnZ2FqNHlGbituMXo3MUVzaS9wZW52MWZXbC80b0h4aEts?=
 =?utf-8?B?a3BKUU5Oa2dOVkVvbWx1eXdwZndCU3ZRRVlzN3ZESURsaHdwaGYyeHF0WlB2?=
 =?utf-8?B?dUlOKzJ1N1d6N3ZqaXVISXRNazhFVXdqSzl0ZHVJQ2Y4dDBsVVBaWVBzZW9F?=
 =?utf-8?Q?hw/Xtc4q68yZoqNadGInYRsQ/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1bb49f-0158-46ec-bfaa-08da5a07c05f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 19:44:16.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtOL7uc1emE9en+wVfH5PHORP1z+lTiXn2IPSCIEie2fged+n+iZQrCg3dJJPfUiH7Ddu5Q2fVpKU3t7SJmrnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3015
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> For SEV-SNP, an OS is "SEV-SNP capable" without supporting this UEFI
> v2.9 memory type. In order for OVMF to be able to avoid pre-validating
> potentially hundreds of gibibytes of data before booting, it needs to
> know if the guest OS can support its use of the new type of memory in
> the memory map.
> 
> Cc: Xu, Min M <min.m.xu@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Cc: Gerd Hoffman <kraxel@redhat.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---

Wondering what changed in v2. Did I miss change log?

>   hw/i386/fw_cfg.c  |  6 ++++++
>   target/i386/sev.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++
>   target/i386/sev.h |  2 ++
>   3 files changed, 57 insertions(+)
> 
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index a283785a8d..9c069ddebe 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -23,6 +23,7 @@
>   #include "e820_memory_layout.h"
>   #include "kvm/kvm_i386.h"
>   #include "qapi/error.h"
> +#include "target/i386/sev.h"
>   #include CONFIG_DEVICES
>   
>   struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
> @@ -131,6 +132,11 @@ FWCfgState *fw_cfg_arch_create(MachineState *ms,
>                        &e820_reserve, sizeof(e820_reserve));
>       fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
>                       sizeof(struct e820_entry) * e820_get_num_entries());
> +    if (sev_has_accept_all_memory(ms->cgs)) {
> +        bool accept_all = sev_accept_all_memory(ms->cgs);
> +        fw_cfg_add_file(fw_cfg, "opt/ovmf/AcceptAllMemory",
> +                        &accept_all, sizeof(accept_all));
> +    }
>   
>       fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
>       /* allocate memory for the NUMA channel: one (64bit) word for the number
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 32f7dbac4e..01399a304c 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -64,6 +64,7 @@ struct SevGuestState {
>       uint32_t cbitpos;
>       uint32_t reduced_phys_bits;
>       bool kernel_hashes;
> +    int accept_all_memory;
>   
>       /* runtime state */
>       uint32_t handle;
> @@ -155,6 +156,15 @@ static const char *const sev_fw_errlist[] = {
>       [SEV_RET_SECURE_DATA_INVALID]    = "Part-specific integrity check failure",
>   };
>   
> +static QEnumLookup memory_acceptance_lookup = {
> +    .array = (const char *const[]) {
> +        "default",
> +        "true",
> +        "false",
> +    },
> +    .size = 3,
> +};
> +
>   #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
>   
>   static int
> @@ -353,6 +363,21 @@ static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
>       sev->kernel_hashes = value;
>   }
>   
> +static int sev_guest_get_accept_all_memory(Object *obj, Error **errp)
> +{
> +    SevGuestState *sev = SEV_GUEST(obj);
> +
> +    return sev->accept_all_memory;
> +}
> +
> +static void
> +sev_guest_set_accept_all_memory(Object *obj, int value, Error **errp)
> +{
> +    SevGuestState *sev = SEV_GUEST(obj);
> +
> +    sev->accept_all_memory = value;
> +}
> +
>   static void
>   sev_guest_class_init(ObjectClass *oc, void *data)
>   {
> @@ -376,6 +401,14 @@ sev_guest_class_init(ObjectClass *oc, void *data)
>                                      sev_guest_set_kernel_hashes);
>       object_class_property_set_description(oc, "kernel-hashes",
>               "add kernel hashes to guest firmware for measured Linux boot");
> +    object_class_property_add_enum(oc, "accept-all-memory",
> +                                   "MemoryAcceptance",
> +                                   &memory_acceptance_lookup,
> +        sev_guest_get_accept_all_memory, sev_guest_set_accept_all_memory);
> +    object_class_property_set_description(
> +        oc, "accept-all-memory",
> +        "false: Accept all memory, true: Accept up to 4G and leave the rest unaccepted (UEFI"
> +        " v2.9 memory type), default: default firmware behavior.");
>   }
>   
>   static void
> @@ -906,6 +939,22 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>       }
>   }
>   
> +int sev_has_accept_all_memory(ConfidentialGuestSupport *cgs)
> +{
> +    SevGuestState *sev
> +        = (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
> +
> +    return sev && sev->accept_all_memory != 0;
> +}
> +
> +int sev_accept_all_memory(ConfidentialGuestSupport *cgs)
> +{
> +    SevGuestState *sev
> +        = (SevGuestState *)object_dynamic_cast(OBJECT(cgs), TYPE_SEV_GUEST);
> +
> +    return sev && sev->accept_all_memory == 1;
> +}
> +
>   int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>   {
>       SevGuestState *sev
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 7b1528248a..d61b6e9443 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -58,5 +58,7 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size);
>   void sev_es_set_reset_vector(CPUState *cpu);
>   
>   int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> +int sev_has_accept_all_memory(ConfidentialGuestSupport *cgs);
> +int sev_accept_all_memory(ConfidentialGuestSupport *cgs);
>   
>   #endif

