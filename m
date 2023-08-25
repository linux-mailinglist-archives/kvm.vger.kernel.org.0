Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2C7884EA
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 12:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbjHYK1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 06:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244405AbjHYK1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 06:27:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0822127;
        Fri, 25 Aug 2023 03:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpjSdhc8Q8e5SmTo3E0T4xYKoO83OeK3ZTQcXl818dU+2npVmpnVHb7HsrboZqpxdnXmpTwquOQdtTHyOrVQeehyvoarzs1CW8bAhDcaYCQEYiQF7+gmrr0jJrJP1x4UR6oxVJo53QK+lHq/4edNVIXSvqNLIkLXKuQA6d7Z81rDHwPzwPva6j9xMxZjDnCl5mr5IHabCql48o+LActxVdoSsaOnR9kNSxdpIqKPURdeMjbAfaEyknpgyYZBG949wDKAIOQJ08KBK38oeW3eYlAOxmHCiQ0umDIZH/edQBpm+1C36pfftQyPpVlg1p/EU+vD70itmE/Hn1RgR+dlXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMD5/IIrn2M3JA3rIIPWGD0/E++nFZyhsV9OWsFSDN4=;
 b=BMNrgM1FtqYSJcAG9IiH2JPccQlPWPEQ8knc8b88T93rZQ8P7nnENv7MISkkmItpnuzRWY93vQeH32hksjh1ccCCQ7+IqFgEyVAZ2vbC3PMurbTec/0kyViLVsXVI5fTFcIAp+pTyI+Re0ntKyFpnIx5Nx3hwrRUXZ77kcbK6RPe+QFbv12lkoT1zxt6lvt2K/r5b/1yZ0KV5dO2vXAvuiwYTLpOWlFDzKIMMCuR70785gkVtKkO4Oa7EbfHVQsqMxHSQoykj+COG2whRjoMq8nDiSdqkwCcB0aGFkOsNdDVK5n07K2ulf4z1MpP/xiOkKJvaZB9KqyjPF5HZ8nvcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMD5/IIrn2M3JA3rIIPWGD0/E++nFZyhsV9OWsFSDN4=;
 b=tVpfHTYdPxlCAu2QRg6gry43+/YcSuctDhdc/AkMRGwnS1ubDUe2dPwHJ1TwSt5oPTWmQ8o+tG56rajR4IoMJ7+JeCrYJzBLOBwO1GyKMG1elcE5TsCsyOKR0AUkTAM+AK1DWSfoeUgaHYlE+d7/RELuU9jrMtxsOnve3F/kQ20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.29; Fri, 25 Aug
 2023 10:26:55 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::52dc:b225:8fec:154c%4]) with mapi id 15.20.6699.028; Fri, 25 Aug 2023
 10:26:55 +0000
Message-ID: <eb0eab09-3625-d3f2-d1bf-ef6595fb04e1@amd.com>
Date:   Fri, 25 Aug 2023 12:26:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/2] KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if
 pointer is NULL
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
References: <20230825022357.2852133-1-seanjc@google.com>
 <20230825022357.2852133-3-seanjc@google.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20230825022357.2852133-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0849.namprd03.prod.outlook.com
 (2603:10b6:408:13d::14) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: a2662bdf-1124-4631-7980-08dba555ce51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1eLNTx0DQqo5qoR0ISFIyeJA3BpKrC6VYfRg1koP6qEvakXPdb8XhONXhP8i3qjxu7unDXAzkvnSbHaGvH+9OAXTE6Ea7hyEHqZwPIxxicu31fegfyokMGak4XuoyeBDE70nSqIEoeAHLVwDx5EzfTdph1tiblkvDSTYu+9ltBfkpqOBkotFxdx9ov2yjtT8f6w4nyv+3HjURduR5JY8B8iDUhiJD9B5ddxqP1U11ykIxp4iAzHF8QUL6pAc/7xXGrhD6f2EwwIZUCBz9yfkudFIMHArZapAP9M0PMlOQ+lT0a75ZRBb8codRVMmI1lE+9DlBKJfwtFQcidJZkdLJZR1QiRb3xAePH+Y0A75vIzB5YVepWtdBv7W3TNFXvzOhjgrv68H5dpiR0zadQ2sdsAa8KB2yozlvC7b5PLi5pg5jtpFRiq8uD1ONvzfC4yU7opUTUxGuJoH7x22Sfzp9vXdmoxHPrr1FsLEXN58gsNzWyy020xg8q59krQd26ukF71ndYLHY2fP53396ZwkNNexhO8AGmZg5H6FS1RvOkZaq4woeOUD1GaI4zkKgZt6ismDcTt2RXoSR9OqtLD8a+mtOmywF8ewUl0Op3BWGX3l3iK96iZ75lBDxcz8u7PX++2/TYuxDUgHdLclc3YuvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199024)(1800799009)(186009)(38100700002)(8676002)(4326008)(8936002)(31696002)(41300700001)(6486002)(6506007)(53546011)(6666004)(316002)(36756003)(66476007)(66556008)(110136005)(66946007)(86362001)(6512007)(26005)(478600001)(83380400001)(31686004)(2906002)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUZQelVCRXhWNWxRZXVOUytpYjFIaFhSeUx0dy9vSDhwaGFpRElvMkptL1Ir?=
 =?utf-8?B?SFZISVJUdVhQVkhDK00wNWkyMFpVY2FydUJvaGRwbHBROXJPVXhXdkZRV0Ny?=
 =?utf-8?B?elRtWWV0bmFZZlMwWlR2Sk9LYXhPS2VFOCtldnhLU2lxOHptK1JRMllKMjMr?=
 =?utf-8?B?Z0VNYlRxemRtcldVczNpcHV0NGoxejAwSzBtN3g0ZmZmNWpTZXhQY1lTN0E0?=
 =?utf-8?B?b0ZnMHgxSWlVVFdTbFdyMmNqdFdSVXl6VkYvVk53TjRaSTVlZlVOZEJNWS9J?=
 =?utf-8?B?aUlRSHMxeGhSaUpPcHArdVlUNkVhK1AzRlhrTmNTSSszTUk3MlZoTDhkNXQ2?=
 =?utf-8?B?SHpSRTAzL0diSWJ0UVA1d3hKNUE0U0h6dlhrVldQN0JKREkzSi9JVnFuOWdT?=
 =?utf-8?B?UUpaV0tCUEZ2ZWNHWU9LNTd2YU54UmpEbVRVcDF0bUlJNG5vaHFhVnMwQ3ZS?=
 =?utf-8?B?NEtWcHBWVWpCTGtyclJZVzg3bkVDMHpnUnN2Z0p1c3NFLzFuekVPcmdrenhG?=
 =?utf-8?B?NFBiVFl4NndiZmpnU3BYTlhQUjU5dnlGVTlkU1dIaEd0MFNTNEk2ZlRZN3JR?=
 =?utf-8?B?ajBCNEVVazhSQ1pxOHh5OExCTm82WDhKeUtxbzEyZ1BVQzV4YjY4UUlSQjFs?=
 =?utf-8?B?VEhoY1dMVDgyQUhKUGVab3d5K2lMQmxEaCtmNHlvbnJOWWd0eGZ0enJzWXp6?=
 =?utf-8?B?eUJoYkhWSHhmQXJVTEp6d1hiU0paTXpvRjVQeVRNVGFNMnByZ2lkK3l0WHd2?=
 =?utf-8?B?MGtuWFI2N0thOU1ZQm40VG1vd3BNWWhZOGNFRVlMNnVaT0NweWUyOUFyOTdG?=
 =?utf-8?B?Y0pwSU85TlZScnQ5YzZQQUlMNGpQK0Y1bmNsWTNPdDJqUExLQ1JHUXIzS2pO?=
 =?utf-8?B?MXlSZFcrSEF2K2lkOW5WbThBVkFhUTEzWDVuZ0FkekJOWlVHa2JUSVJ4ZytE?=
 =?utf-8?B?UjNPekJYQXFUWktzaG01YWplZC9FQ0ZESStKNUs1MytaU0tkMHlUNGp6RE5k?=
 =?utf-8?B?b0tqT2ZkdFQ1R2lCOXYvdXhWKzVoVG1UcUptKzMxcEVERDUvYnRoaFJBSHdi?=
 =?utf-8?B?SVNRQnJiU0tIcXl4S2Z1VlJmSCtYS2NlSEE0WkYrY0NQQnByOU5ycXVZNDNt?=
 =?utf-8?B?WkVWVmRDVWl5ZXpOWDRhdC96Q3lZWlJrc3dPbmtCSXd3Yld0VnhvQzIyZzdk?=
 =?utf-8?B?bGVKckhqSXZ0OGQ4MWMzMGt2VkkwNk15d012M2Erai8wYi9HWm94dnkrQ0to?=
 =?utf-8?B?bzIvRDMxWG9HNlFKZDhRUmdHdkFZT1dSeG9lanFyUThJSGs1V3RWM25XR3Bp?=
 =?utf-8?B?M0lYamhlZWRhZWVxNFBkeHpFL1Nxa0xOM1BRdW8xTUJHKzFhYUw3aDUvd3FZ?=
 =?utf-8?B?SzVLZnFDaThnamMxNUNsRGVRRnI2L2l4clZ1U3VhaCtKdnVoWmI1azhEU1Br?=
 =?utf-8?B?WlJGSUE2NUo3R1lSOFNyZ3dYQ3lFN2c5MTVhNDRHQlczdHhVTXh1NmdCNXg4?=
 =?utf-8?B?Tm9RZ0VURUVOZXdnc3BlWGRxekExelJOSHBCTzNmWFluNnJkOWRza3VKbGMx?=
 =?utf-8?B?WEw1VUJ6cGpMdGwxQTV5V2U5UEFIY1Y2dGFYWkR5Mm5OeDdRNkFQa2VvR0Jz?=
 =?utf-8?B?L0E0TzBPNWZHY0JVaVpqQjAwY1I1UGNoZFRmWDVwVmlBT0NVTzFYNFg2VFVs?=
 =?utf-8?B?azZIUndkRU5kU0xJY2YrOHQvY2JaajlnYkExcllWTWVFUmpadW5uV1hDL3R5?=
 =?utf-8?B?S2JhWlVpd2NnV1dPM3BKMVpyZGZyNTBVU0tkMDRNbkRreGZ6UVZCUXBtcXRI?=
 =?utf-8?B?MWZWcDRUaGtwdDUxNzIydWVZNzNxUlV2cDZwT2tSNWVOWU1jN2tQL0xwK25L?=
 =?utf-8?B?RzFTN0hMNm1WekRsT2M4OTBUMThoVDd6V1VmcUZsRzRLa0lyZ3FtOWJleXQx?=
 =?utf-8?B?OFBiQitBWHBNU1ZjeHFuMjJJd0NPS3E1WkMzRFhJdFhLbU5VT0FzZzhQejFJ?=
 =?utf-8?B?R3JlTnRQaVdnTUxrQmRwQkh2VlhlYVVib2ovVDBJc3FaTlZaY1JDUFZxM01N?=
 =?utf-8?B?UUlHUE9KV0p5bHB1OUYrSmlwWnVSOTZBNWRLcEp6YmhFcUZWRDY5TjcrNHlp?=
 =?utf-8?Q?deNWIqlVc/kGqu0oESkoU5qAn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2662bdf-1124-4631-7980-08dba555ce51
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 10:26:55.6838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMsJMVVEsXzyYY59mwvujuRbQ9s4Uw4H9ULKK8zbcpQwgAP+YjAny0c6W57cvXM6BfSgqc+c/i8d6c7GPdJYTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2023 4:23 AM, Sean Christopherson wrote:
> Skip initializing the VMSA physical address in the VMCB if the VMSA is
> NULL, which occurs during intrahost migration as KVM initializes the VMCB
> before copying over state from the source to the destination (including
> the VMSA and its physical address).
> 
> In normal builds, __pa() is just math, so the bug isn't fatal, but with
> CONFIG_DEBUG_VIRTUAL=y, the validity of the virtual address is verified
> and passing in NULL will make the kernel unhappy.
> 
> Fixes: 6defa24d3b12 ("KVM: SEV: Init target VMCBs in sev_migrate_from")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/sev.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index acc700bcb299..5585a3556179 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2975,9 +2975,12 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   	/*
>   	 * An SEV-ES guest requires a VMSA area that is a separate from the
>   	 * VMCB page. Do not include the encryption mask on the VMSA physical
> -	 * address since hardware will access it using the guest key.
> +	 * address since hardware will access it using the guest key.  Note,
> +	 * the VMSA will be NULL if this vCPU is the destination for intrahost
> +	 * migration, and will be copied later.
>   	 */
> -	svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
> +	if (svm->sev_es.vmsa)
> +		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
>   
>   	/* Can't intercept CR register access, HV can't modify CR registers */
>   	svm_clr_intercept(svm, INTERCEPT_CR0_READ);

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

