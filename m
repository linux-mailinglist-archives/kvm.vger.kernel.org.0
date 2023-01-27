Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF66C67F15B
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjA0Wqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjA0Wqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:46:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCD3783C7;
        Fri, 27 Jan 2023 14:46:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVibwPhfC30Y9Y2Cm2TyG8D0sE/BIjglwOZGNhn7UiL2zt6tobT61+Zj3fthpwAoQuNIxey1KICVCnm8xy9RwuXMJvvPy519pegCuzzJLM9hHhctR1TvBJOkrXyvpi44tM+Kdf2rC3TQy0WKr5ED61aeHk4H1gKU3eh9AmRH99re3nKdEMLdcrtHyWDbf0lqzK4aN5OSDi3yNBX1xdD+MoN1/ICBHH/+ZuJHcTEGnekUbvpzCDmtVxR8+0aJAhd9J1dsTp5AfO3dciDClrnmGUQsb9PEtmUJtT5YHU2RmVDQRGuOAtvwizXKwX4fxOu/vV3g7MAMFCBvIuPflgjIlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ja2etefyCvSYDx7YpPRYqAyy1ODYKgbDa+obRuLob4M=;
 b=HQkIQaBca1LZr9gD0K0NzxV7+9syu9nZkOwguo/Mi4RjQc0AXnyHm+9fsZkYFMUM2dY1rg7A5zXvErpciSs4lAEoDsr7MACGNCUzV/Vhjc0/56/e/zvePcneCx3KhaewfE480MKbI0Y5tTszqXsh9uddDL6UOb5IBjDkf87rUZs8+ts0skhlthw/M4wFfvXUSw6Wo9lLos3AXAJUV86OBgmNyBTm72Jc1UJ4nHZ07xLgSbeXGNW3PCxdyzLg0FNmJNZFNRCtiRQSjAtu5IDUXXfv0O5/TMC2BPJVtP/Ahx6OkDJYPkdnp9eb4soPM+zpr5WkE4MAaH/HvVD6e/5AtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ja2etefyCvSYDx7YpPRYqAyy1ODYKgbDa+obRuLob4M=;
 b=urGtRDDkSzUSzV/DXx0eAuICKTvSHMnMIXAnYvnUTeVRKsno7emmXi6T4k3T5mSwj8Unw2nQaJdn3W282cY71P1qMA7neKXfXD2O/d5Bj3K5q0GXa0g/FhQPBZA0k8TOxubUGlMgMOihWSeBju345k0qsOk7ITDevU+eBFhvLk0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 22:46:34 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%7]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 22:46:34 +0000
Message-ID: <cb551b5a-6a80-37bf-0179-a623861a6a7c@amd.com>
Date:   Fri, 27 Jan 2023 16:46:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC 3/8] KVM: SVM: write back corrected CPUID page
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20230127025237.269680-1-jarkko@profian.com>
 <20230127025237.269680-4-jarkko@profian.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230127025237.269680-4-jarkko@profian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0193.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: e876b198-1033-4aa6-f949-08db00b85756
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vHSc8rKE07U03iycSG/2v+UIP4Ew4b6syYuXdrmuVRsmyppKckGD6Pl3hSTSNSILo4CAVGtL9onokIc5BEXcX9C3+Yqke6B4AcIX1HVunXkUBsA8vzTLckEeJLUptOLVvvT04wXJbAbVYBaN7mFxZhvCypUlssZw1d3v5dnOMHMXvi4TVJgNlGarVSq+CeQb617nczaFl8eu4ULp1t5Iff0lVdN96A0BWaVkPD5UaQT0N1+zlsvHd6lJ4FEjsNJsxZigW46hsPZ+7OK+uoOV0PG/e5ALh5InIZ0Tgvpj6xyJAl4Fy+D3kqVebGaL9lpo2czVO8Y5mFrOjb9+y5sKv6QgXGcYjokTuu8XEKf51CmR2ukoIuxGsQQ/Ghu3CqLE4nawZkwfp4R9rYf7r1M1Su5f4Z6cH3nuGjkbJuGq0ZE/S3xoY+vL/6eYINsNgQhTDX4/rwFjXi+QlE4wCi2vCbXRSmid6sq7JQwPOuYnm+OTYPFEaup6TomEHEiJz/VAEtmyDD0Cr5z5Q934Ep17wq8BWCLDGlv+GJT/nUJjGBzQQZvqQTCbMbYpwCjyTs1CrZf8ju+x2HBRIzVKm7x0Ot88P4F5fuRwTS0vxiMYsCu489gYokKWPCTisaDCfQmleXEc+I1F9ayn0Soum0PmX1IJqrVG4zu0/5qFmyhCTOpLgXnFoQ6QUEdGMknN5K/2L2Prx61k6Az7xDYQA3UVrVIEsqFluPzdMEL6cKZX5NtAdNUR/rBX5IUIM37+FxYLyI4tMNck3WGvRGPh1fWt4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(34036004)(39860400002)(346002)(451199018)(6486002)(31686004)(186003)(508600001)(26005)(6512007)(966005)(2616005)(83380400001)(6666004)(110136005)(316002)(54906003)(41300700001)(8676002)(41320700001)(38100700002)(6506007)(53546011)(8936002)(4326008)(86362001)(31696002)(5660300002)(66946007)(66556008)(66476007)(7416002)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3BuZkFBV2htT0thQ2E4bk5lc0o4a3BZTWVkaVRMK3ovS3ZiRHd1cFVKOU0r?=
 =?utf-8?B?b3E3MVZ5ay9EL0lONHhXUE9QM01uMjlzMjY4SWw4Q3pvcDM2OWpDL0o1dEtV?=
 =?utf-8?B?K1lvRzhQVHYxUzVsZWFGZExZNE01M2Z2blJPanpldU9pR0dXUDU1SFlIbmF5?=
 =?utf-8?B?S2h6T1VIYWxSaER6cFJiekMzVVBIaEJLL3lWcmRlVTRRWXh3MlAvUlFTOWti?=
 =?utf-8?B?MXhZN3RycW5CTmJhYXNRdlpzMEZEZldaOU1OUlJPbFRubDltd1d2OVErejVY?=
 =?utf-8?B?Q3crN3RMZk1BYkpsNS9ldUtDT1BaR1N0ZVdWdXAzNENYRkRuVHpvTGQxUTBC?=
 =?utf-8?B?aDkvYUkxRXYwS3pzSHVvV3UzUVd4cXRQNjYxdlpRcFgxeThuT2kvVnBsUmN3?=
 =?utf-8?B?VDRzSVppcEJDSXhTRjN3RmlMOEk3WmFEZ3cxS2FKSXA3Nm53by94OGxoT2hS?=
 =?utf-8?B?VGNOOHV1WnBiN1FSU3FKZWZteWxTekh5ZCt6V2NmL05XUXFaanB1NkVSVXEx?=
 =?utf-8?B?SEhWd2N5Y1ZsYnhKR0VrV0J4R0Q5MkV5U0ZqUmRhV1czL2U0MUMxV2k1aVND?=
 =?utf-8?B?dXdmc0NqdkxzWWdaWjliQWg0b3FHSHNESFZKUFhTZ04zUjdzZTRFbk5EWlBU?=
 =?utf-8?B?bklDdWh5eTA0THVJTW5iN0N6SUsxcG5CZGNPU1lDY29SOGRTMUU1M3p6c2I1?=
 =?utf-8?B?WmcvajRFQXNudlV3U0E3RjNwNHpmSUtodyttT3pWNkx5NitNTE1tYmRjTE9W?=
 =?utf-8?B?U0ZqQ1lHTEhOeUkxdXVTUStVU0dlbld6NUZ0RTRRcWVvRmhPbVZHaHk5Umpl?=
 =?utf-8?B?V0pOR2dWSVRSdUxualhkVFJ4OVFjamhuMEpjeURITGdCUUV0cjZCQ3duR1g2?=
 =?utf-8?B?aTBvb3lvQW9HVGtqWkQzcUFpL0x6VmFMdlZNTU9LVm9xWG1jZ1pKL0x2OXJx?=
 =?utf-8?B?NjNkcGpLWmV3R2ZtZmRPbXJOdG9rbG85cndTQmc0Tm5jS0hPWUJMWitONDlI?=
 =?utf-8?B?SFBlTkhkNWJnT01YYXRoeFE4V0FzZkgwT0Z5a1lZa2M5eDRGWEtaUzlaT0NZ?=
 =?utf-8?B?T24wUEJNRncxV1dFVUVlc1BzNHJYcFByd05zUDNOSmY2dEFjdHYrbHlTeXVN?=
 =?utf-8?B?bTdET2c5Ti9JTmFXYStOTnd0OFROMDhDTmE0RS9Rd2RzSmI4SkRHcm4zQjhu?=
 =?utf-8?B?QkhRUm1kQnN6dWQrU2JyS2VUSkcvd3podHNwblQ0QlMvbldHRHVUU2VVd1pK?=
 =?utf-8?B?N1g4SFA0eGZsWmZ2UXB1UGdjUXh4Y290bmZ2U1V6ZC9TbnR5cGZSZEw5UmN6?=
 =?utf-8?B?ZWJWdmFlTlkySW9VaEMwLzAxWTgvWW9MRS9JaVRWaUlYNHgvSUhpNCs4bm1S?=
 =?utf-8?B?c3BLNksrQUozWVk2TzYvNGJPNlI0T0lTZk1ORUphaDhHb2c0TWduQ0h3Vysy?=
 =?utf-8?B?VXpnQmNtaWVZZnFrMmYwVXE0WUw2bkhWQTloelIvYjZwdVZibW0rRlhGZzJS?=
 =?utf-8?B?UkhGUHpsS3I5Z0M1SkliTzNncUVlejlSSXFSZDk3bjBoTUROWlE2OG1BMzdK?=
 =?utf-8?B?eFhrTGpteDBaeFdaVHc5SUlQL013K0xSOUVPaDZrQmViQVg4cHl6TC9MSEp0?=
 =?utf-8?B?UzZjUnRnUUtjdEl5TWY4elZHMEJZN1dTOUlKa1JGdGhKalQreGc2a3Q0Z3Vo?=
 =?utf-8?B?Umo2c2VVenZFTFlIL3ZvQlV2TnFRdGt4WDRRRmFzcW5SNHNWWDVPMzdPSVZD?=
 =?utf-8?B?T2M1SFBjUDZVd29hT01nM2FwUXU5SkE3dXJnWjgrYm1aVnVnYk12cGNtMklK?=
 =?utf-8?B?YUcycW10V1BjRXRwU2dkQXNPdVBScWZPbXhnbGpNaTRtN2NINFgzNVVTbEtY?=
 =?utf-8?B?Y3NvZm5BUXRSOWlkNmthcWI0NlF1T2hNZVBDNFphTExjN3ZmQ1NwRU5VTTNI?=
 =?utf-8?B?T3dnVFdTazRpR2liOTAyblAxUndXMU9mOS9EbVJJVVJsSU9qQ1BPU3NRWW1t?=
 =?utf-8?B?Rm1XeFNFYk5SOHpsN2dVNWFlYk52bzg2a2FtSFZ2eVkzQ2lsNlVOZklYNVVh?=
 =?utf-8?B?d3NRdkN6QW8wM0NDQXJjQ2NmR0Q0SDIwVVc3YmlUUm1HdG5xUzhEcDEycWh5?=
 =?utf-8?Q?uyMgNyXQGjhrGzm5CrGOgaCaD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e876b198-1033-4aa6-f949-08db00b85756
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 22:46:34.4387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZY5yn/ND7VNiEm9AkTlFQ+jSfl+mtMYqJOiiYDMWvbiyqowpVZwT2ktTGRndbO8wgf3bHv+GVN+5ol9XwE2pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/23 20:52, Jarkko Sakkinen wrote:
> From: Tom Dohrmann <erbse.13@gmx.de>
> 
> When doing a launch update for a CPUID page the firmware checks that the values
> conform to the policy laid out in the processor programming manual. If the
> values don't conform, the firmware will return SEV_RET_INVALID_PARAM.
> In addition to returning an error the firmware will choose some acceptable
> values and write them back to the page that was used for the launch update, so
> that the VMM can inspect the changes and try again with the corrected values.
> This is specified in section 8.17.2.6 in the SEV-SNP Firmware ABI spec.
> Because launch updates are always done on the private UPM mappings, the pages
> are first copied from the shared mappings to the private mappings. When the
> firmware corrects the values, the corrected values are in the private mappings,
> inaccessible to userspace. In order to make the corrected values accessible to
> userspace, the page containing them must be copied from the private mappings
> back to the shared mappings.
> 
> [jarkko@profian.com: fixed checkpatch.pl errors]
> Link: https://lore.kernel.org/lkml/Y76%2FI6Nrh7xEAAwv@notebook/
> Signed-off-by: Tom Dohrmann <erbse.13@gmx.de>
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> ---
>   arch/x86/kvm/svm/sev.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6d3162853c33..4a8e552d8cfe 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2230,6 +2230,23 @@ static int snp_launch_update_gfn_handler(struct kvm *kvm,
>   			pr_err("SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n",
>   			       ret, *error);
>   			snp_page_reclaim(pfns[i]);
> +
> +			/*
> +			 * When invalid CPUID function entries are detected, the firmware
> +			 * corrects these entries.  In that case write the page back to
> +			 * userspace.

I would additionally add that the firmware does not encrypt the page, 
which allows the hypervisor to copy the page back to userspace.

Thanks,
Tom

> +			 */
> +			if (params.page_type == SNP_PAGE_TYPE_CPUID &&
> +			    *error == SEV_RET_INVALID_PARAM) {
> +				int ret;
> +
> +				host_rmp_make_shared(pfns[i], PG_LEVEL_4K, true);
> +
> +				ret = kvm_write_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> +				if (ret)
> +					pr_err("Guest write failed, ret: 0x%x\n", ret);
> +			}
> +
>   			goto e_release;
>   		}
>   	}
