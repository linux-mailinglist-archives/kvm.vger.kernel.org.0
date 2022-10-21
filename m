Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50618607EA4
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJUTGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJUTGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:06:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263982CCBA;
        Fri, 21 Oct 2022 12:06:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hfk2OEPhvEh4Z9Yxtvz15UJ2okOGI5ua9/zOWitXua0qHi9pDUMn8XEbnChXfUvzIoFsLdcWwt8igeFetm36Tm2jabtzE9pLzknWDQM99lNvWQzzRhjVAKc7l/hSQSOiMIXdk3AmELjti85fQUS6pQf1G9S12a5xzG0v65aVj5H0XTIo2D2apyYjX4fhBJgDDOyD3CYz/aSIVd1HdpjHpS/QUmzh1oIbJM8dO61OOvOiHEZ1cDl8YfXO+HswWFqQWEx9Y3lNtVBL+WdyXFfp9SxfkWMBZOYPT9AXEUnYslZDSFqlqAMBuTMKdLpqG+zz1VIKhbdnfD1JMe8N8L4laA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMunpw0eVE6M9TmbzVzSKg0hn8odQLLx3NPRXRRUY0o=;
 b=h8kqTjgnvsLe6TvSz2Jvj592r7CKiYxyV9OftdLDi3RbgkPRxV7dRqSQvw7iFlg4VKOv5fozYpxUB0MUwmJEyKX5oYk+nXktUnf08KGwWPrLgaNBZtVEQNXekoJwf2i/9wX6wxgNMSeeJfkPxkzDkRuav1uLa/DZE8FWZcZaY9jIkp4Enwf3EewxsIAUpZqpMiz9q+wOqMAD2bI+rcm4GoF0f6GG0T+xii7u/KoD48EjvY/bICi8Bc8cAyRz4CPsHUg5jnhltyTFl4CqnVLBoJ6A+scyPsbyhNAHsrrKevcfMrUtcQeG1dqLcnrWLoy+CPCgMVp7Ns2cyRNUIymkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMunpw0eVE6M9TmbzVzSKg0hn8odQLLx3NPRXRRUY0o=;
 b=hPYwhiF9BsoHMj6TAGnpHuHQXpXxs5ilOxmSvAjKssFch4m3uHL0Jfwq0zLdrJItADZ6SXA4gj5pEBybeWt11PgY3ZNvKmLiCi5FAFnd8iK7yNCD91TTUcK1uhHimixiGE7frMdw+xLDOGQ6Jk1c0ihMLX6wZoqZd/3/NFH2vfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB4565.namprd12.prod.outlook.com (2603:10b6:208:26b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 19:06:41 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 19:06:40 +0000
Message-ID: <27a90573-53cd-846a-e09f-c22c649db60a@amd.com>
Date:   Fri, 21 Oct 2022 14:06:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0181.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::6) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN2PR12MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: 5036518a-0e3c-495d-3a93-08dab39762c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZXVRwdhW1G/hpjiij0ay7XjuoA6PMPEDx10/rUzgTzO24IrlP/BSEf15NyDTQfEmUZWSVniiIPMvUvkFHspPcJRM/nNegMGJfX5kVQWoMdTC91drBa4LiOl2UfkbJZKsYeSA0MXjyZOOt3u+TZaF/IJfcHmiaazwQbpMlH5b+Xu0ltjPK0TLT34MBXR8A6db8x2nigMeNwVMsbskNaVQ813PJ/0PHLwBvAfxoDRcB8IX4gho0TDF7yFVwvrxhO+o6/3NwbEI1vKPfvBbOyxT9GKiYP/GnxhmSoSUDbEVZsvklgrFIeD6oKK+rzw54zEoe7LKpz6fd74bU2nCP1XEcXgymhxKTEQs2NbhQJphPp6JHmZf2lMEC9wTJ8iYXjMWKedZXT4q4PpfcPhWjKDxos88D7LdDmX/OnBKTAI9UqWsbjYiJt8O2ZrN/qKlSJzOLS7po1mV5ewfwl68b5Wi/WHGc+HcUpVLvDO5KJZtVHe0qWm2JyYBY10Ju+SKh2r5YbZtpZ85GVsKnzT2yWJC85Q24ZXjktnZOOsqy+iOBuQwz7O8QhF6JP32H2A0qYTTny7KkyM0V/EG51tKAxLYRHQz0aFR+mPYc3hlYh+nwthDMxn7fyMVNkXHqRctWYeiwzohK+ry+h3n+ESwwi73y/OKMHByzv7aD1Xsd1CU9Wcgq2jQtL5ahimAsbRI+U3dIEzP9oQ64xiXt1DyfLv+/+Ne0lKxngh+AZDI/ELlPw9KvT7/v5KhqYUMcUhXsCSJS0vofGbr3+km2zYSvl5rT6M9hYP8aZu9v5h2AEo8QpI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(86362001)(83380400001)(26005)(41300700001)(6512007)(6506007)(53546011)(66946007)(66556008)(66476007)(31696002)(7406005)(5660300002)(7416002)(8676002)(8936002)(316002)(36756003)(4326008)(6666004)(31686004)(186003)(6486002)(478600001)(2906002)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXFlNVVhaDJJb09mck83WEJpSjdxeU4ySW90Sk81SGJ4ZWRLZG9wUU9SNHpu?=
 =?utf-8?B?ak8vQnEzelgyaE5hb005Y1A5aHU2U1huVEl2SkhMRkZYbmRyYkN5a2ZGMzNX?=
 =?utf-8?B?VmJ6RUN1dEZYdWxBMk5MLzQrcTNpZXNIUUpTNFlTUDVuMElpUW9Dbm9HQms2?=
 =?utf-8?B?YlE0cWowQ1JIeUh1VEl5dVdNKzlKTkorYWdvVDVHWEUvcG5FRU9jQWZQN20x?=
 =?utf-8?B?eHFCTDA4bHRTUmJZcEF2QUlXZXRSc2IvdTluUkN6eUU0QVlSdFpBYjVick1H?=
 =?utf-8?B?UlRheWlxSnZLb3Z2WWRHMC9xTERWSkV1NEoyaHBhQTlRbEVaKzFaOHBibXE5?=
 =?utf-8?B?dGt5eFRSNjEyWXhQTi9iSEhiNXE0TDlxOFU4WGcwZEszbVNhQ1I0cEtkNzhV?=
 =?utf-8?B?V1gyOXUrekFiQVpmSlhuMU5wbDI1WXpWZXEzVFcybUllQ0JpUXVnVXI4TEJt?=
 =?utf-8?B?NExrMzcydVlJUVlYVW1CL3JoQTBsZkxyU1hWb3Y4OUNnbS93ak9hK0Q5cVlM?=
 =?utf-8?B?RFRjQSsra2RHQWpSMTRTL0ZGMGlBWjBsTW93Ny84RUhEampXbzk1Tml5T0J2?=
 =?utf-8?B?VGZydjJGd1ZNZmhKSjZyY1VzbXkwenhKd0NSZmpsVUhzdzBiQ2ZrRm9lT21T?=
 =?utf-8?B?VFc4anBNTHdWRFJnWE9ydnJWKytERFYvSEpuNHoydy9PRDlqaVRUSHRvQjlx?=
 =?utf-8?B?cHFSdDNkWVNnMnA1cVZGT29KQjR2RWQyTTlCSzIvUXM3WU9Jd1ZORTUxbFZU?=
 =?utf-8?B?S3ovUTllbjNNN2tnNGwyY1B1VnRlcWZzMmU4bFF5NkdPK01FUGZZUmNZMzNs?=
 =?utf-8?B?V1A5cjd2QnJ6NGF4NVB4Mjk1T0w4SFFEYXFHakFGcUtIemMxMzFaMVRYaHhm?=
 =?utf-8?B?Q1pyWHErbmhjNVY2TVFIYTl2ZE1GOVFsTmFJVTdkVWtVdFU0d05TaEtUTWtZ?=
 =?utf-8?B?dHAwRGpabkhSVlJkQlJhbHkraUJLN0xyczRFaGFyNlBiSTBERUJjNXpXMjBU?=
 =?utf-8?B?azh1MVhEWnRkRVpLRnBTSHhxZlpaeDZvVGxHamg0UVlOaG43VVBSdVlnV3ht?=
 =?utf-8?B?b2FZWkdIQXNuTk9CZzQrNmxNempLRjllY3FZSzVCeHNZY2ZnSDBNUlNmS0ht?=
 =?utf-8?B?eGs1QWgxVytEZkd5L3pKUlI4QzEyc1I1d3NyZmpGb3hTRHMvNGl1VDhQVHhr?=
 =?utf-8?B?Y2p3N0xGM3pxU2FpRDlkcTEvUFpldmpJdDBrWE5SeHhBaGxEaVI3cURlRG13?=
 =?utf-8?B?MCtoM1hHbVF6VXo1UVR4bGV1QVpPaWRGc2gxUk15RWk4UkdqZDU4ZWFGSXJm?=
 =?utf-8?B?WnQ1TDRSNUdaL3RQVHdnMlRYRm1vc1NtUjlyNDhneFNXZnBYUFk3a1djSzVR?=
 =?utf-8?B?eE15SXlUYjJaSEhDT1U0MElwdjl3eHcrZmxEM2VkOUlnMkk3eEQ5N1Rpb3VE?=
 =?utf-8?B?WVRkL2IrZmdIYjI3NW1SS25Mam9mT2RpZmxReHRTdjVkQzRZZ3I5WitVaHgr?=
 =?utf-8?B?YXpXSEdjQ0lwNmlpcWF2ZnR5Ni9XYXpOQ3hlbmhsN3U1dXluN2M2bFcvZ3Y5?=
 =?utf-8?B?a0JXUWFPd2FpcXBUQUlGNCtGeGUxS2xJN2ZLNzkxVUVDdWJrb2hlejljckZS?=
 =?utf-8?B?cFlWdGpuNTdidGE3YmVOY0xhVnUyVHFzSi9OZWRHTHNRbjVCSlhMTWNSazFC?=
 =?utf-8?B?YXFvUDB5V1p1WENVa0FqZEpTVk45NUp5dGIyUEVlWFQxWEpJanBiWjg1S1Zu?=
 =?utf-8?B?V0FLTzNCWVlIL0FQZDVDWEdCNVFLNGJZaWhuRXZHOXNOYTFxa3V2cXdLT25I?=
 =?utf-8?B?b1Z3MFFBNXJLdmg2NEZLR29Wdm01UEppTkFSaHZNemprMFF6MGxja3RwR1VW?=
 =?utf-8?B?RnVoZEVDNVk1dFFFblBncXRobmNVbzBsWUZVcjIwZUJMK3V1ckcrMDdMdmlk?=
 =?utf-8?B?dUIwZytqZ0ZESjgySWRUWXpyRndwM1BVZVFKSCtTYzBxSXJYTmhIUTJ0NG9B?=
 =?utf-8?B?ZTFEa3FHR1dlZHAxYUMzY2EzWkVoMXlBOFFvV0hpeksyWllubVdHSmQ5QjBx?=
 =?utf-8?B?eUlOTStlU3VjRkw0RHgrckpVSEVXR2RBc0pHNC9GbFJua24rTG5FekFXU2lo?=
 =?utf-8?Q?xNvr5V7ome3phCVKRA0mIGrE9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5036518a-0e3c-495d-3a93-08dab39762c2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 19:06:40.7175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /UcRZi6mKs7BT5pefgngkPcKibCsKgwBe8ObGdOPfz9p8e5zU5R28AXtsFhnaZS00PZ0tBKbONJmsr0+SMvI3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4565
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/20/22 18:13, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Version 2 of GHCB specification added the support for two SNP Guest
> Request Message NAE events. The events allows for an SEV-SNP guest to
> make request to the SEV-SNP firmware through hypervisor using the
> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
> 
> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
> difference of an additional certificate blob that can be passed through
> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
> provides snp_guest_ext_guest_request() that is used by the KVM to get
> both the report and certificate data at once.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++--
>   arch/x86/kvm/svm/svm.h |   2 +
>   2 files changed, 192 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7fc0fad87054..089af21a4efe 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c

> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> +{
> +	struct sev_data_snp_guest_request req = {0};
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned long data_npages;
> +	struct kvm_sev_info *sev;
> +	unsigned long rc, err;
> +	u64 data_gpa;
> +
> +	if (!sev_snp_guest(vcpu->kvm)) {
> +		rc = SEV_RET_INVALID_GUEST;
> +		goto e_fail;
> +	}
> +
> +	sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> +
> +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
> +		rc = SEV_RET_INVALID_ADDRESS;
> +		goto e_fail;
> +	}
> +
> +	/* Verify that requested blob will fit in certificate buffer */
> +	if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {

Not sure this is a valid check...  Isn't it OK if the guest has supplied 
more room than is required? If the guest supplies 8 pages and the 
hypervisor only needs to copy 1 page of data (or the SEV_FW_BLOB_MAX_SIZE 
number of pages) that shouldn't be an error. I think this check can go, right?

Thanks,
Tom

> +		rc = SEV_RET_INVALID_PARAM;
> +		goto e_fail;
> +	}
> +
> +	mutex_lock(&sev->guest_req_lock);
> +
> +	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
> +	if (rc)
> +		goto unlock;
> +
> +	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
> +					 &data_npages, &err);
> +	if (rc) {
> +		/*
> +		 * If buffer length is small then return the expected
> +		 * length in rbx.
> +		 */
> +		if (err == SNP_GUEST_REQ_INVALID_LEN)
> +			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
> +
> +		/* pass the firmware error code */
> +		rc = err;
> +		goto cleanup;
> +	}
> +
> +	/* Copy the certificate blob in the guest memory */
> +	if (data_npages &&
> +	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
> +		rc = SEV_RET_INVALID_ADDRESS;
> +
> +cleanup:
> +	snp_cleanup_guest_buf(&req, &rc);
> +
> +unlock:
> +	mutex_unlock(&sev->guest_req_lock);
> +
> +e_fail:
> +	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +}
> +
