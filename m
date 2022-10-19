Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7489E604FE4
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJSStJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 14:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiJSSs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 14:48:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E481D3C59;
        Wed, 19 Oct 2022 11:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhP1UfS4a8P2Ys/htG1wUq9lz9xJzA/OfKLLXst38m1reaOgrqGik0qlCzsBTMJpA7rlUYtRmnORq4hmrqYtbyLF/Nrkz6KRDvbR15YhcJ5hHmFPN4O6n7xIrrSYqjq1ZOSMge5zrQXKdZJxloiLPcmEUva1K8gOJyXiUmoHyJgAR9rFbCnWCKWlvKfcv2Fi/iBjTz0vq0ps5l/GJP5Tbp/5gC2VPIAxA24vdtmacUuyWjogjyUHEl53Dt9V6/wTlduh28AUTs5oyzD2yGoEcl5pL5GMMtZufUH3ifnUO0iaT4CBX1+zEwnak/a8ZKT6glSDfxauF9UEgDfVzjcfnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeuHJ5ix0QerSQILlXdrXnTORdS2TPIk5iiyBcbHJPk=;
 b=iiiS3msUyiltGMRw+7jfhFc/l/JAbdVigjjdRiKCsjEChkpKUY9y0edxEaVIXOZ+RB8aC3xEdgx9wxU8X2GHVv5+aGwd2xsdbuhL4Fs1qHrWGjii2Y7HIE2+pY6jwVOZm1SCh/DdiJf39qr0sU5tBaXObTupMXRxS6FzotjYl0BHRAWrw/sgpEBCSWRRkO10QKZDdQwvHAHYN28RclKuV+McaNLFvWGpKqQeRHAVYhLOosDEHrDntoaGUSZtcl6evExd9lGl22hxOUxDGD6YTyAM/Nm7fARzb7zoiL7MXgrGD46U6GRvPiXT1V4ekIS17ZwlDjHYuO+hyVuVLWF0bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeuHJ5ix0QerSQILlXdrXnTORdS2TPIk5iiyBcbHJPk=;
 b=E3GZcH7dO0YEL+dI+SeiMv7zaDfPMT0jhMdIDe7PsLyLFVvmxlp4/lk15iM+21rlWIRJg+7x9ZTYPqcj9F8aTq2jKaWR8gOUqEr1T/7hWXtg5JC/Tu1lV1G7uIAgY2abxUpYb7z+R+sWyOO9a3T8QPjFYtyO8Pv9xQyiUAOSg5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4366.namprd12.prod.outlook.com (2603:10b6:806:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 18:48:55 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6dad:12a0:10d6:5967%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 18:48:55 +0000
Message-ID: <d3ab29c8-8f22-28eb-dfe3-6100a8f16e4b@amd.com>
Date:   Wed, 19 Oct 2022 13:48:48 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic> <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
In-Reply-To: <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:23a::27) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA0PR12MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 768a53b1-f975-4c87-c832-08dab20292af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veh7vrUsvQnYm3IXZo7QVtFOYP9uR8k/BiV5zNsVVUM0qWiqoy16wfTwzPBX03STiqHb7qYI/0GaD6W8sQu6TT4OwabN15CHON3J4RoliBGYGo65B54PNoPAx6u0QzuXHLzTm9XI+syN+/1mXMtQnDjWjSEJ7JvE/I8GzyKS1sXxiRTOcD6RykMotLDaaoo3fDITWRf9flwaYJLsM+8Z9GIpsrsORSCDvl6FWnXV8eLs5m2T51Xswqn642JHxYvnTLJ17sY0rCR/tZDwIBhDw6pNMQ7xi66tMmhClweK6bRrC347eC11JiChgly2RoaqIJl75vs3n5ntV5X7CiZs0faG8VlZ9m2apoX0F27QNb1I6KWzMRW+2H4x0HQ/HO8SbkmPzmn9VnHVbQBFz6molpf6kdUky8+PS8f41cTGkAbNZaSk6NQwJZotwHi3pWz0CMrG3iVLIDyHDdC5y0IZ9Kw2eCHLffT/M8aq8BPB9AYVRGmfVkJCU4fmB+dqepxb5zcYWsYos5UoOog+fuahHn/5EwroGiIDFOCrBHFMT7zgF+bi6gKp3M4M/J3x1sWTD2Lc56mlo6OhGOW8wB0CHNkfirmbiEzg8EMDfTzekqasqbaeHBKdyrLGaQybekD4WC0U66mOjvNOprODNO9ZpvaBn01OU4P25eA0m4LZP4k1NnaFbIWkyndqXmEchWu/7cVK1Gm6/YtqYl1xN72Oz7wMBv+AuYY5o2P1YtE1/x55z15DHGTNJdhgoQDoDWg9dTFfLcxloTBr+5elWNeRZ4bNU/PwGwaAij9ipbfuTJsh/qu1cxcRB7kRDV/TGvwg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(66556008)(31686004)(36756003)(186003)(86362001)(41300700001)(38100700002)(6666004)(83380400001)(2616005)(6506007)(66476007)(5660300002)(2906002)(478600001)(6916009)(6486002)(7416002)(31696002)(8936002)(316002)(4326008)(8676002)(26005)(7406005)(66946007)(6512007)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUttbFRyTThVWXVKUzhaaHdUQW5MZm4vS3N6VDA5by9scWVXSEZtYmRObzlP?=
 =?utf-8?B?aWtjdFV2Vlo2aGcvc0ZvZHkyZWtFUG1LYlJ1d1RtbDNxZ1l0ZkVvVGRKU2Rl?=
 =?utf-8?B?SmpKckk1TzJJWjlEeENFZnJKYW80YnBtNTRuWXhhNnN3TEMwYUtyRGlUaTRH?=
 =?utf-8?B?OHFuSEMxd0pqeFNkSEVCL3pvM0x6S1ZxUmhPQ3lodjUrUWN3UmgwOXFQZjIr?=
 =?utf-8?B?dlBXT3pxdDJzL2duNjNBRVRIZG9oc2V3SWtKZENGL0pua3FIYU5QQ1NJaTVo?=
 =?utf-8?B?N3BhYzhWc20zUjhTejd2bERkc21KekNDbndXQzZWTzUyV3RtRlVHVVRoeVBy?=
 =?utf-8?B?dVQzU1NoQng5ZnozcnpXUDRNd1lsZm1RNUg1alZXc0dvcHVLZjkzMmhIdDBV?=
 =?utf-8?B?NnVMcTFTdG9mQkROT2pWdE4yWFAzUFdiamd3YytJTzRlN1IrUHpOWG1EZHNQ?=
 =?utf-8?B?QzZFMkpzN2dUcjFQRXZjMTBrNUhBS25TZFQxV0E4T0gyZmZCWk9hQjgrRDZW?=
 =?utf-8?B?VWlwWGo4NmNQZ2hGOWRSOWxqcXdjQlNDdDk0aVNnb1BtUTQzckRncHBSUVZ1?=
 =?utf-8?B?eW1laVFrb3laUm5MWmJjMk1sdGUvVWNrV21XWXl4dWRsWGx6YzNyZmMvVXAy?=
 =?utf-8?B?WGROanlxSVdrcXY2cjNMZWo2VVpraXp0UmtCMko4ZzJPTVBoWHZZbm5IcmRt?=
 =?utf-8?B?a2ZFOFpPbVdZRFFGYXFCN2l4My9iRVdCVm5vbEF0OG03OHFqT0w5cWlodkJU?=
 =?utf-8?B?c243NXNWbjNURzg3Rlc3UnNDS3luWWVUL2VsaUpla2tIaUFrMDQzUDFGUXlB?=
 =?utf-8?B?Z1M1SU9wNXYyZlhnVkxMRkR0QUE2V3Y2K00xTmpqcnZreFVBV3Rta25QQkFa?=
 =?utf-8?B?N1l5TVlqTEdxVmgxZ0oyWEZvQzN6bStGQU54VUkrNGU5b1NESDl0a29uZjhT?=
 =?utf-8?B?RWpJNlBYVjBqemFCeUl6ZE1XMmdzU3hFOWVYZm1XVkVGM21Fa0gvWTlTQzFU?=
 =?utf-8?B?L1EwUGxaUGhMdGUvc09HZC83bmljVER0U0p1S1pWMkoyRzJZMkExSTFwZ2x5?=
 =?utf-8?B?OHB4dkQzbHkvOEE3Yk91eG1sTGh4MHlNM0VZS2l2N0hEYjl1VXJDTmRKaTNr?=
 =?utf-8?B?d1h4SE9Fc2gvclZtV0dEaVBmMmM2YlFUTSszYUVZUkpqeHZOcmRWclltbFlR?=
 =?utf-8?B?TGFHL2taK1N2Q2ZlTmlETDJSbmJGRHFFVUhuaUtXYTVPWWlVYTZkOUdpWmxw?=
 =?utf-8?B?ZXJpOURkQWpYM1NOSUNRYlUzQ2tOV2Flc0drU2NSamV6ejN1eFZsWTBmNFZ6?=
 =?utf-8?B?WWY2STBWUk9VRi9JZlJpUmxlRWloV3hxUThvRTZQUWpNNTVGd3pRQys1c25V?=
 =?utf-8?B?b0JoeFpQd3IrZHRyU1dabWhJWm84Zm1GSkJadUFRdmtOVFF5UzJCQVVKMFVG?=
 =?utf-8?B?Sk9vN2Jzdk9xTHJwQ3lxUkk0Nm5kRFBHVGtpT1RkUkdiN21IS3NsMVFBQ1dy?=
 =?utf-8?B?eUY0OTY1cElZWkthQ01sV1RqUGNNVGpDNXM4dmV6L2liVk9aWlU5U3V1UEVr?=
 =?utf-8?B?ZjBzU05NbUJ6OWFSZ1A0VzJzeExxV054c1RScFBvS3hPdHM3d2dBOTFrR05q?=
 =?utf-8?B?SnJxRTlUZzNwRUpsV2VoN3NEV1RzZFJjbkkwcGYzMTdoOUxqaFptVFJsSGlE?=
 =?utf-8?B?Ym13ZEhVV2pwOGZJdWg5U21SMkFKT2tFR2txSzAveFE1am1LN2l3dUtNNHRP?=
 =?utf-8?B?cjgvMHEwbGdUTTU0OUtQY1Q4QVFRY25lNUNiNXZwSStjZVV3Y0xKNnJ5dG1z?=
 =?utf-8?B?QWhLbG9DSEJoNXkwQW4wdFllYTBOcjlPUWtmYjYrSCtQVjkyTVdMdWhkSXBZ?=
 =?utf-8?B?d295YjhiM1Y1UU02dXM3MHlUenhsak1zeTlvWlhGREVRR3IxY1k5S08zQ3dx?=
 =?utf-8?B?Q1VPYkNHYlRJaHJDRGtnbW1HTVdmejVKL1hsK0FEMktKamJRMnhGUjdlWWNR?=
 =?utf-8?B?Mlp5bWZ4c2ZjRUJsMkdlRW9ia1pWSk8wMkRSU041QTZSSXA4UEw2eS9tNVJT?=
 =?utf-8?B?b21xRk81SzkzZU1LVC9sbWkxcFEwUXl5a0Z5WGFKVEJNRjNlWVVvb1VIdlVp?=
 =?utf-8?Q?kpFkybzNYqW0p5V6+J+tTrPaO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768a53b1-f975-4c87-c832-08dab20292af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:48:54.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjqqwdMU7mK9EQ6DuooJ4DhAXUJvIdfJFLr/H/MA9o4AnEntg1z/7BznUbFPVLxdJqtSXQRSxJtysJxFu3s/xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4366
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another follow up:

>>>   int sev_platform_init(int *error);
>>> +/**
>>> + * sev_snp_init - perform SEV SNP_INIT command
>>> + *
>>> + * @error: SEV command return code
>>> + *
>>> + * Returns:
>>> + * 0 if the SEV successfully processed the command
>>> + * -%ENODEV    if the SEV device is not available
>>> + * -%ENOTSUPP  if the SEV does not support SEV
>>> + * -%ETIMEDOUT if the SEV command timed out
>>> + * -%EIO       if the SEV returned a non-zero return code
>>
>> Something's weird with those args. I think it should be
>>
>>     %-ENODEV
>>
>> and so on...
>>
> 
> Yes, off course %-<errno>
> 

I see that other drivers are also using the same convention:

include/linux/regset.h:
..
/**
  * user_regset_set_fn - type of @set function in &struct user_regset
  * @target:     thread being examined
  * @regset:     regset being examined
  * @pos:        offset into the regset data to access, in bytes
  * @count:      amount of data to copy, in bytes
  * @kbuf:       if not %NULL, a kernel-space pointer to copy from
  * @ubuf:       if @kbuf is %NULL, a user-space pointer to copy from
  *
  * Store register values.  Return %0 on success; -%EIO or -%ENODEV
  * are usual failure returns.  The @pos and @count values are in
...

include/linux/psp-tee.h:
..
/**
  * psp_tee_process_cmd() - Process command in Trusted Execution Environment
  * @cmd_id:     TEE command ID (&enum tee_cmd_id)
  * @buf:        Command buffer for TEE processing. On success, is updated
  *              with the response
  * @len:        Length of command buffer in bytes
  * @status:     On success, holds the TEE command execution status
  *
  * This function submits a command to the Trusted OS for processing in the
  * TEE environment and waits for a response or until the command times out.
  *
  * Returns:
  * 0 if TEE successfully processed the command
  * -%ENODEV    if PSP device not available
  * -%EINVAL    if invalid input
  * -%ETIMEDOUT if TEE command timed out
  * -%EBUSY     if PSP device is not responsive
  */
...

Thanks,
Ashish
