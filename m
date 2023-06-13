Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C972D9DB
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 08:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbjFMGZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 02:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239787AbjFMGZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 02:25:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD8310E9;
        Mon, 12 Jun 2023 23:24:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agQVqb2QiWmI9Qleefmkvl77cxuF0R1FmrFTvuvYqg2FUbxBpaVIbAaTgw4g5RSC3vhcMOk0P2k074+vyeTRu5VOjJ5muqtl42MlyCmZAQ3TM7mPW8lbkxaeHfjE+/MyVNipwPJTtFfnruCfBCF0F39qZHHfDnhv3ABd7ItW4BepVjT2U44hwN0QiNy2tpwqKSIzpYIUUfVy88fsTTxyVbjEwAopGOGAuO3Z3WQdwp2yOlQ557rrW8fhDrsxxo5nTtKf5CzMfBrRR2S8dTkUkEGiGVEDWP20DFEk5nyl7JfC6HNbQLb5YbBzqkBFW+VfGlR8/AkCldJ7d2xZshiTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZrdoT+SmpCpw+oRibw3ifLtz3GMBwNulXQaObwZcDI=;
 b=WBCmlXCwpepftG77+Kg27RN9wOXUKzXNVLhBI9VWosnWQS9j7UCkaMsOtVYSsvWcbD1yZjNMQo7hGH7XQWKY54LYcPWCIHGly8V47jTlF2tSwi0UE2MkXvZd3Tmyoluo9Z5AhTvmbLOn494m73DvbNyHb5k0eRL/je2X3JOC9czlOwoLmcZwYpkj2U7V5UJRIcu4rK2bl15LbxvJ/XdEukn9ZcpOxnO6rQPbzxw+o9D7ZnipBrXqw6QTdhD5SUpfmCSG1s2+obokZcFbGdaVXGGL9O8vDiC+jwTlY8atMpNSKMxnDvuiWtWZvTlcOKnLqSNbmbq7BjoBQjpvU90/4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZrdoT+SmpCpw+oRibw3ifLtz3GMBwNulXQaObwZcDI=;
 b=l5eD/AMcYU1DuFEP8s/zBHCC50qWmONHeq4T4cGKjOzB6yb7uvQjentHk9FYEsKc+KYNIXZxHGW39h5wHe7b3RHym+trTD/bNA8kRdFBWAHev+KcpfZguAZrRa4kI+GYtF/bQnTl/PYqEzjVV3b1jtMTcrlUExs2ylSSdSfRuBg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 PH8PR12MB8608.namprd12.prod.outlook.com (2603:10b6:510:1bc::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Tue, 13 Jun 2023 06:24:57 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 06:24:57 +0000
Message-ID: <ec1880ea-4b81-faf8-054e-220d58ac9775@amd.com>
Date:   Tue, 13 Jun 2023 16:24:41 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH RFC v9 48/51] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-49-michael.roth@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20230612042559.375660-49-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0034.ausprd01.prod.outlook.com
 (2603:10c6:10:eb::21) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: dfdcce69-16c3-4802-15f9-08db6bd6e81a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjWWQVOMRbHvOY/tNqIjXQYMqRNW6KixoS/vt3OXaSgdfYI47/qqzbLrAXBCQ/ZAjoXYnZIRjEHOIYzPWiyetO1TOSPBQK0mtmMtFF7FHPHM4aM0tBWfhmC9SnEdn3rvmn0Y0q11quk+PpLYbU4tgFd5R8TrYBqR0NoXkS6omsoT8CoTEYPMz5XSBWWJ0z53gAy3JIZwPT61KSTxW7ijHc9Nb0a9zg8dLTgfT20BU9PelnECFasmj4hTBNrrF2N+T/EbFHormHW2hjLqFNpAji/Z9StBo9VYFp4WaMRs8iruoDZxCX1td2LISjzhYifY2vvTwr9aWGMLJZp3Rdzk8hrTW+zimjZJ2vtF2S200lgW2g6qbtWhESCZC4y22rDBAIipghwTKOWsh9LhFCneZuNGTzYBL550yuka7I6MqApSZCnMeLGgR6rB19PhgLmj0tOrlr9lLIKoCgUo6W5QZFVTFY5yXvTk0B+KAACHi/G5953bwOKoXp82WGpOO5CIsdEVIPcENU781MUEWI3/Q8ZE4HXEp6rvnIVxTzILhwsVdAxUobwq6F+ifrkITDvEFsEGb8aFpZ7B2LuOtFLJJDwLSagfkDxpyfMs6m5KybL/uzLEFakhvh55liv1tF393u59izGNqbg4QSY3qEJNGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(6506007)(2616005)(6666004)(31686004)(26005)(53546011)(6512007)(54906003)(478600001)(186003)(6486002)(83380400001)(66946007)(4326008)(66556008)(316002)(8676002)(38100700002)(8936002)(5660300002)(7406005)(7416002)(2906002)(66476007)(30864003)(41300700001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGt3MVByNmoybkZZeGY0M0w5OXpDVEg1QU83ZysyNm9rUHRjSGJYd3loT1o3?=
 =?utf-8?B?Vmh3US9KYTdZRGJaN3EybmRDT0ZwMlVGMzlsZ3MzOXZEcFJGVTN3RkhTNFgr?=
 =?utf-8?B?OHdoMXZYM094VzhiRit1c3UxUVZWRVp2ektHQmhiKzdtdUZPY2EzaFhGdkFU?=
 =?utf-8?B?Y2h0aUp2QnVZYjcvVFBMZG1icmF0YnpkdGNFQTM0TTFrMWRJaDQxUnhRQ1dL?=
 =?utf-8?B?SzUvRlE5R0J6N2lwY0tLbEthVW1vZ3h4dTF2TlNWQ3I4M2g0NmZaZnlpU1Rm?=
 =?utf-8?B?T0k5Q0RZdWRqV2VrbFYxZnFpT2dRNzJwMG91RUFMSFkraVpNellVeXgzdGdW?=
 =?utf-8?B?YXBobUFkMlJ5b3Y3S3dDbG9JNmVoeXUxTWNGTG5aTjdKYkdaUk9idmVjUEtE?=
 =?utf-8?B?R1p2OFBZQ290czFKTTcrdFppait3VWJPRjFFdzEva0FiRmpXbHdHSWVnbmtB?=
 =?utf-8?B?U05KUjNkYTJjOGxKY3pEenJsTllReVdBSjZyY1lXMzBnU0FJajlZMWNPdGpT?=
 =?utf-8?B?Y28vZCtiRjhFWmd3em5oTmsrQ3ZHVElIN0RJMlZYdTdBdHNHTDVwaHo4aW16?=
 =?utf-8?B?TnZTb1ZYZExRWDRwRUFBYjVpa01oVU4xUUVwSnhQYXFzKzZ5TlFZekdvUmhw?=
 =?utf-8?B?VXlWSVhwbzZuZUxWT0ppRjRWSWVtR3VJTnVtcTZRSVUybHl4T3NUZlFMei9m?=
 =?utf-8?B?eFhoTGp6SnB3YXhGTVpnS2hwR21SNVl4S3dKbFY0QUZ0RzVyNXV3bUJRdjRv?=
 =?utf-8?B?bXpXdjJWVFlMM0hXWTZod1BNQ2hyN0E3UGZYbWEyTXo4WWFIcDlOUkVRdHJ5?=
 =?utf-8?B?ZStzQk5yS3ZsQWoybWE4eG1UZjUzNjA2azFKcFBaQThYUStDU3R1enkwWGZm?=
 =?utf-8?B?TVBVVkV1NTVLVENXbWFvdnUxTzlvUlltcjI2QUJ3NkJSdmV3dmhDOVhhWTd0?=
 =?utf-8?B?UDJtV1JYeER5TE12RHUxOEF1L1dVSk9NVTFRMk5WL0R3L2ZhT3IyZ1lIV2ZR?=
 =?utf-8?B?TXZ5WldBTHFmdEM2RHBtb1hWbnBtMTU0R20zL0JNSG5VeFJreUQ4K3o0VzAy?=
 =?utf-8?B?TTRFU2w0REVUK1dEdHZ2c2xwanZvTlFrMkNKcjlrbUNQYnNRNm9uWjUwa0FW?=
 =?utf-8?B?YXRyU043SERiR0NQd1hOTGZiUHZDWW42eHEyUzBmbzM0aU55aThEa1pSR29o?=
 =?utf-8?B?THJJVWgvczlFZU9iYlU0TzAwQ1NPT1p4VzJ5RlBYN1diUFdaMzBxTWxxZWNw?=
 =?utf-8?B?Wk80bklIOUVMZjdxMy9DUWFiVCsrandmS1pUeXR0NktYTEM4cnJDWnFpZkRs?=
 =?utf-8?B?ZDkrekU1eFltZ3N0N2FmT0dWS2pwL0FGZEQ3Qm1QbHM4ZGdlQkhodHdZNFZq?=
 =?utf-8?B?V3NzVy91eFlESnNIRWMyVG96WEFXQVArT1NDeWFYRFY5MjZIZmJRMFhKc3Jq?=
 =?utf-8?B?OEsySWw2OHl5QklPVVhqQkFnd0pTbG9nbW50MGZRdUNENnhMckIxYS95RjFV?=
 =?utf-8?B?b255RS8wbURXRC9mOXhnMG9CclNPZis0eW9lenFDQXZ2YnRiYndkV1U4eHNa?=
 =?utf-8?B?d2RkT0V6UU9YMHA1QjdwZnhjWnhGK0RGUExicDZ3RW80ZTNyc3FPOGtYT3Ny?=
 =?utf-8?B?ZW42T2FuT1ZLR0w4M241dEdwM3B5VndXQi92NVdQalVNeU1VYTVuZmk4MHVG?=
 =?utf-8?B?bUliMVkwajVXWVJMS3RZZG9lYTBoYXV3RjU1ODRSbkNpN0tad2hYQk1RSGlV?=
 =?utf-8?B?dGF0enhuM1MwU3c3RDBWMkxyTHJaTUt3NVZPT05SdUlxNStiejBJR29Edy9Q?=
 =?utf-8?B?WkFmQzQxRDdTaFhkc0NYa3YxSEtvR054aGYycHg0WUszdzhQNEFTZ0dnNS9H?=
 =?utf-8?B?UDA2TjFlNS81cFUxUE9lcldRNUtpbU9xWVZ5dVY5MWV2MW52NEJPODRkQnMy?=
 =?utf-8?B?U3lPU0NNZForR09lcVZDVTZsZ0crSFBPcEE2OW1jdDlUOW1zVEtNQmlxemo1?=
 =?utf-8?B?cjZ3b1dQSkJkMjZ2VlpjWm1PU3lxTS9TZENEeUI1WGg0VFNreGNlUHVKendN?=
 =?utf-8?B?SXloNHVmSlRXeG5wQ1VEcFlVVnVTUkRUUHBLSDZCaGlmYWRLUnRGbU13cElF?=
 =?utf-8?Q?dyCogLYYewhSGJCLCgFOTCT18?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdcce69-16c3-4802-15f9-08db6bd6e81a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 06:24:56.9329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTSTd25kpiCSjunftAf/+K+XvJW1+Vct3N7BuL24Wrs1mMa3EKDIywQT8FTnc6l5kdj8bXm5PVBQloW7YpIYUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/23 14:25, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> system-wide configuration value for SNP guests. The information includes
> the TCB version string to be reported in guest attestation reports.
> 
> Version 2 of the GHCB specification adds an NAE (SNP extended guest
> request) that a guest can use to query the reports that include additional
> certificates.
> 
> In both cases, userspace provided additional data is included in the
> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
> command to give the certificate blob and the reported TCB version string
> at once. Note that the specification defines certificate blob with a
> specific GUID format; the userspace is responsible for building the
> proper certificate blob. The ioctl treats it an opaque blob.
> 
> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
> command that can be used to obtain the data programmed through the
> SNP_SET_EXT_CONFIG.
> 
> Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Co-developed-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: squash in doc patch from Dionna]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   Documentation/virt/coco/sev-guest.rst |  27 ++++
>   drivers/crypto/ccp/sev-dev.c          | 178 ++++++++++++++++++++++++++
>   drivers/crypto/ccp/sev-dev.h          |   2 +
>   include/linux/psp-sev.h               |  10 ++
>   include/uapi/linux/psp-sev.h          |  17 +++
>   5 files changed, 234 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> index 11ea67c944df..6cad4226c348 100644
> --- a/Documentation/virt/coco/sev-guest.rst
> +++ b/Documentation/virt/coco/sev-guest.rst
> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>   status includes API major, minor version and more. See the SEV-SNP
>   specification for further details.
>   
> +2.5 SNP_SET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar to
> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
> +command also accepts an additional certificate blob defined in the GHCB
> +specification.
> +
> +If the certs_address is zero, then the previous certificate blob will deleted.
> +For more information on the certificate blob layout, see the GHCB spec
> +(extended guest request message).
> +
> +2.6 SNP_GET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_GET_EXT_CONFIG is used to query the system-wide configuration set
> +through the SNP_SET_EXT_CONFIG.
> +
>   3. SEV-SNP CPUID Enforcement
>   ============================
>   
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index b8e8c4da4025..175c24163ba0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1491,6 +1491,10 @@ static int __sev_snp_shutdown_locked(int *error)
>   	data.length = sizeof(data);
>   	data.iommu_snp_shutdown = 1;
>   
> +	/* Free the memory used for caching the certificate data */
> +	sev_snp_certs_put(sev->snp_certs);
> +	sev->snp_certs = NULL;
> +
>   	wbinvd_on_all_cpus();
>   
>   retry:
> @@ -1829,6 +1833,126 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_ext_snp_config input;

input = {0} would do as well as the memset() below but shorter.

> +	struct sev_snp_certs *snp_certs;
> +	int ret;
> +
> +	if (!sev->snp_initialized || !argp->data)
> +		return -EINVAL;
> +
> +	memset(&input, 0, sizeof(input));


but this memset() seems useless anyway because of copy_from_user() below.

> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
> +	if (input.config_address) {
> +		if (copy_to_user((void * __user)input.config_address,
> +				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
> +			return -EFAULT;
> +	}
> +
> +	snp_certs = sev_snp_certs_get(sev->snp_certs);
> +
> +	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
> +	if (input.certs_address && snp_certs) {
> +		if (input.certs_len < snp_certs->len) {
> +			/* Return the certs length to userspace */
> +			input.certs_len = snp_certs->len;
> +
> +			ret = -EIO;
> +			goto e_done;
> +		}
> +
> +		if (copy_to_user((void * __user)input.certs_address,
> +				 snp_certs->data, snp_certs->len)) {
> +			ret = -EFAULT;
> +			goto put_exit;
> +		}
> +	}
> +
> +	ret = 0;
> +
> +e_done:
> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
> +		ret = -EFAULT;
> +
> +put_exit:
> +	sev_snp_certs_put(snp_certs);
> +
> +	return ret;
> +}
> +
> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
> +{
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_ext_snp_config input;
> +	struct sev_user_data_snp_config config;
> +	struct sev_snp_certs *snp_certs = NULL;
> +	void *certs = NULL;
> +	int ret = 0;

This '0' is not used below - it is always overwritten when "goto e_free" 
and the good exit is "return 0" and not "return ret". I'd suggest either 
not initializing it and letting gcc barf when some future change uses 
it, or initialize to something like -EFAULT.


> +
> +	if (!sev->snp_initialized || !argp->data)
> +		return -EINVAL;
> +
> +	if (!writable)
> +		return -EPERM;
> +
> +	memset(&input, 0, sizeof(input));

same here.

> +
> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> +		return -EFAULT;
> +
> +	/* Copy the certs from userspace */
> +	if (input.certs_address) {
> +		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
> +			return -EINVAL;
> +
> +		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
> +		if (IS_ERR(certs))
> +			return PTR_ERR(certs);
> +	}
> +
> +	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
> +	if (input.config_address) {
> +		memset(&config, 0, sizeof(config));


and here.

> +		if (copy_from_user(&config,
> +				   (void __user *)input.config_address, sizeof(config))) {
> +			ret = -EFAULT;
> +			goto e_free;
> +		}
> +
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +		if (ret)
> +			goto e_free;
> +
> +		memcpy(&sev->snp_config, &config, sizeof(config));
> +	}
> +
> +	/*
> +	 * If the new certs are passed then cache it else free the old certs.
> +	 */
> +	if (input.certs_len) {
> +		snp_certs = sev_snp_certs_new(certs, input.certs_len);
> +		if (!snp_certs) {
> +			ret = -ENOMEM;
> +			goto e_free;
> +		}
> +	}
> +
> +	sev_snp_certs_put(sev->snp_certs);
> +	sev->snp_certs = snp_certs;
> +
> +	return 0;
> +
> +e_free:
> +	kfree(certs);
> +	return ret;
> +}
> +
>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   {
>   	void __user *argp = (void __user *)arg;
> @@ -1883,6 +2007,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	case SNP_PLATFORM_STATUS:
>   		ret = sev_ioctl_snp_platform_status(&input);
>   		break;
> +	case SNP_SET_EXT_CONFIG:
> +		ret = sev_ioctl_snp_set_config(&input, writable);
> +		break;
> +	case SNP_GET_EXT_CONFIG:
> +		ret = sev_ioctl_snp_get_config(&input);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		goto out;
> @@ -1931,6 +2061,54 @@ int sev_guest_df_flush(int *error)
>   }
>   EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>   
> +static void sev_snp_certs_release(struct kref *kref)
> +{
> +	struct sev_snp_certs *certs = container_of(kref, struct sev_snp_certs, kref);
> +
> +	kfree(certs->data);
> +	kfree(certs);
> +}
> +
> +struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len)
> +{
> +	struct sev_snp_certs *certs;
> +
> +	if (!len || !data)
> +		return NULL;
> +
> +	certs = kzalloc(sizeof(*certs), GFP_KERNEL);
> +	if (!certs)
> +		return NULL;
> +
> +	certs->data = data;
> +	certs->len = len;
> +	kref_init(&certs->kref);
> +
> +	return certs;
> +}
> +EXPORT_SYMBOL_GPL(sev_snp_certs_new);
> +
> +struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs)
> +{
> +	if (!certs)
> +		return NULL;
> +
> +	if (!kref_get_unless_zero(&certs->kref))
> +		return NULL;
> +
> +	return certs;
> +}
> +EXPORT_SYMBOL_GPL(sev_snp_certs_get);
> +
> +void sev_snp_certs_put(struct sev_snp_certs *certs)
> +{
> +	if (!certs)
> +		return;
> +
> +	kref_put(&certs->kref, sev_snp_certs_release);
> +}
> +EXPORT_SYMBOL_GPL(sev_snp_certs_put);
> +
>   static void sev_exit(struct kref *ref)
>   {
>   	misc_deregister(&misc_dev->misc);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 19d79f9d4212..22374f3d3e2e 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -66,6 +66,8 @@ struct sev_device {
>   
>   	bool snp_initialized;
>   	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
> +	struct sev_snp_certs *snp_certs;
> +	struct sev_user_data_snp_config snp_config;
>   };
>   
>   int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5ae61de96e44..2191d8b5423a 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -24,6 +24,16 @@
>   
>   #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
>   
> +struct sev_snp_certs {
> +	void *data;
> +	u32 len;
> +	struct kref kref;
> +};
> +
> +struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len);
> +struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs);
> +void sev_snp_certs_put(struct sev_snp_certs *certs);
> +
>   /**
>    * SEV platform state
>    */
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 4dc6a3e7b3d5..d1e6a0615546 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -29,6 +29,8 @@ enum {
>   	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
>   	SEV_GET_ID2,
>   	SNP_PLATFORM_STATUS,
> +	SNP_SET_EXT_CONFIG,
> +	SNP_GET_EXT_CONFIG,
>   
>   	SEV_MAX,
>   };
> @@ -201,6 +203,21 @@ struct sev_user_data_snp_config {
>   	__u8 rsvd1[52];
>   } __packed;
>   
> +/**
> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
> + *
> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
> + *		reported_tcb does not need to be updated.
> + * @certs_address: address of extended guest request certificate chain or
> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
> + * @certs_len: length of the certs
> + */
> +struct sev_user_data_ext_snp_config {
> +	__u64 config_address;		/* In */
> +	__u64 certs_address;		/* In */
> +	__u32 certs_len;		/* In */
> +};

__packed or padding missing (there are other places like btw, I remember 
seeing quite a few of those). Thanks,


> +
>   /**
>    * struct sev_issue_cmd - SEV ioctl parameters
>    *

-- 
Alexey
