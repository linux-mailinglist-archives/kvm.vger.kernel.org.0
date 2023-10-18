Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892637CE9F1
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 23:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjJRV11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 17:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJRV1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 17:27:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4DDB0;
        Wed, 18 Oct 2023 14:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+/NHjJREuHtzgu7MMT01wq/ORaxEprQ1mw0QFHySEqlaXqmYc7N8ngoBxK3wpfbj2Q86VjosvU71di+BtIczDHxVR+j83qlBO3EFXRQ72UY1La2quS6/V5FVmQ3asIOLxm5dYs0hG2GvVaV4AavfbucF5e9HIowBKlTGwALb1Of8kEqSVc/Rjbkl0dafyDwCVNFkVlwwh9ON3nR+xhAqVyUAXgjiI0dVt/YebWqrrOlpL2jENiW9EvtReH+N1Z+XnOb/WO48m85H86vd0NtP98geybPEq15NJ9j2bu15DzyqOnS1hHrVyEwSWypLBXJnv7mg4qayLDY4B9tr04M0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWMGk27Dtb2j0J/2AkKU4t1IYXnxb02KM9twjBgHwSI=;
 b=DqE2ru1CRlcEremJTE0yBKWds5RloQNckbPyl4/gvK/5iIi+xrSLHWnRDUwVENxJH+UGqeY9v9CTDEcP1WqkCu+2Vp7gAq4zr7xJWtsfDllLn7x4Knu6BFW2u8e7OnsBhaASkaLZlW3Km9EToofklDL29OYCKENGjy3pnvf3PC23z0kN165ev5cCf9o3SQX6G5kq4Ljh/Lr2zEKWrRUCR43oRtJP2abJFPquRoe1gwX75RzfkMrU7v1pRBKr2dDQfYihLceeQ27XkDpLWtbqsgPgG2sEvpStGaYb4gxT01ata2XOoZ75wO8Y1ODen4DWuWuEhUZaDRMAg9qE9z1jQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWMGk27Dtb2j0J/2AkKU4t1IYXnxb02KM9twjBgHwSI=;
 b=nQ9Sh/rZ9xxrURgEVbKUzEfhBe+EqSVPMZz9io4U92qYBZHMESbsMSSegLYksLLTGdwoNCFSr/EMnnIFat5Pa5hcN9+VbSy3BF59RljDwzRKV3rqeBzjeElPux8Ek0C0XkgzIjvt1FabBGvYhgf4rnHF4/jgg+52Z9DNJmN5fN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 21:27:19 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6ac8:eb30:6faf:32b2]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::6ac8:eb30:6faf:32b2%5]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 21:27:19 +0000
Message-ID: <4f8bb755-e208-fd8c-f948-f7d64260f8a7@amd.com>
Date:   Wed, 18 Oct 2023 16:27:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
        liam.merwick@oracle.com, zhi.a.wang@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <09556ee3-3d9c-0ecc-0b4a-3df2d6bb5255@amd.com>
 <ZTBCVpXaGcyFaozo@google.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZTBCVpXaGcyFaozo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0188.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6038d7-d318-4483-919d-08dbd0210234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jfG51GHguAlJflx3A1sZpaV5weTXWfPvB7WxiP32ouRLQ7qQaz73dHBsOcWd7cb5DdOEvq/r6yyt9ufRWHkoNQmWGcvcGsiHtSJ8Jv/4nGR6udvNFJbhzRI4NirRvtBBKmQ8fzILojfm8X1yxNWhDVuCa754ewA9hutejdhLb6sPeNQ0PLg1vamSF9aiahQrF2UbeBGebRBpp7sASyoVhCHBxktviS13X2mLY2GNIuJsjEHVkOwSSgTZ183xHPjjOIc/6+wXIsvlyXEEv2rxtx/ZmqwTKldi/K2qAMgqCHRs00Tu4TVZO7c0Es5sjSwV7ucULA+B6GLgWhloCoifLnushJzsDv55Dt9J600y1aLhjP4/iTrJqRZMzvO3SFO/ZpDhfg3aEY/muxZlLFiQeqosykVYFHPsgKd22vrIt8QzzP1PF2cshlJA4/XcNnjeQkYndCZo10qnrCLQzxe8/ILDIcGyKB2NAnPd/Uc2IEYkIw++1vFxfzit++WSz3vip321ppwfIPN93ROmtxxGxzCjdbe4jvW87pYXVgpZdOtu5bnL5h+yUxZdfFjYJbjwFi6pWcE+nIexYL5LDekRTBHDP+WONbILoQXLaiiMSpwG4fnKUKKYg5/LPsqXESPk4zx8v/uVFnkS4lN9s94cVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(66476007)(54906003)(31686004)(6486002)(478600001)(36756003)(83380400001)(38100700002)(66946007)(26005)(66556008)(6506007)(41300700001)(316002)(2616005)(7406005)(6916009)(53546011)(31696002)(86362001)(4326008)(6512007)(7416002)(2906002)(6666004)(8676002)(5660300002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVRyenU2Mk5RbGxyL2lFMWpJSDZCeU80UXZxMmVsNjhVaHR4Yit4Y2tpWGJq?=
 =?utf-8?B?L2s1OUE1STVmY3grUGlmZ2RJZ0FCN0xkKy9SN2haSTcxd0l2Z20raHc1UkVB?=
 =?utf-8?B?ZWQ3T0FtM0RrOW5hMVBvYnlTR3dzbEQwRi8xR3VWR1JUS085WUJhek9Md2M3?=
 =?utf-8?B?S09nNTU5S3N1bnF0WDNxUTdJTVJ5dDhKaytqaGoxSW9vcFY5bHcxS3Y0Wlpi?=
 =?utf-8?B?QTdJOU9BU2I2a0lIVWJLcVhGbm1OakxZb3BFZXlWczI3eUpDQ2IvRFd5ajZz?=
 =?utf-8?B?WmxZWnpzTFFBbFFmaUxtV3lwRWV0NEplMHdYRm5nYzVQWXY0RGtWYy9tTm50?=
 =?utf-8?B?QjhXTVZoT0ZLVU5xNFd2czVEcUxWUyt4U2hUOFNLSUZWOCtoTk54c2ZOVlU3?=
 =?utf-8?B?b3JqaXBLTGIvUVJ3VG9hVmY4b2xvaWE4M1JyWjNuV0ZTbXJJMlZzanYwWGtJ?=
 =?utf-8?B?aE5oMjBuQmtYT0hZdWVGdGJBT2Q5ZEczMUZEcUp2OSt3SnUwN0o4YlVscXNN?=
 =?utf-8?B?K09ReXNaRGp4VWhMSlFFTVdzMkpnOE9FS1JUZXhxTTZmRlZOemlRNW9uTjB4?=
 =?utf-8?B?NE12SXV0YWM1ZkxOek5HM1doOFhsUVQ1Z1luY2QyZTU2ZHZIT09ubGNSSWMr?=
 =?utf-8?B?WktvQk5ucDZZWTFYSFRvUTdjekNxK28xVVozQ2YrZWZxQTBlNjlGdVkwUkFQ?=
 =?utf-8?B?cHhOdkszZHRwdi94ZDN3dVFiNzdZaTRXZk9yY3dFaDN3dU1qK01rSHNxTFZW?=
 =?utf-8?B?TDk3VnBNOTg1NUoyeU5abStQWUMzSWdnMEFUeGxORjZUZW5rTnhxYllkWHNu?=
 =?utf-8?B?QkJvUnhtNHE1bXhFcGgwU1FCWjVtbmJ5QUY3aTIwaWNyVHBLTGpNdzVaQW5W?=
 =?utf-8?B?dkkvbGZzZTAzYk0vSlN5Q0QwR0pxZkd4SVJ0enY0OGxwQVplV3crRzNsbzI2?=
 =?utf-8?B?b0RKaWRYTVNJOUptazgyVVpZSDhGb01wRnpjbEJNRUVIQVJLSGluYW1kWjho?=
 =?utf-8?B?U3ZrekFlbnBmbVIvWGdrNit1NHJmb1VESU9hbDdGOXRUVDlOT0JtbzlZdkVm?=
 =?utf-8?B?UkMzOExFU2tZdHlGWVlsaVlnbmVrNnFnWW0wYUpjSGY3V0VSb0FLR0Y3dVM1?=
 =?utf-8?B?emVUMEtkc2paeTA1OW5CRTI0NUY3a2RYTG83SG5CMGFJUlVvVU9LZ245R21I?=
 =?utf-8?B?YmlQQXdPWGdDQzhBM0JNYjhXUWJWSno1aFM1MmRnL2ZlMnlHM0dWK3BQdEpr?=
 =?utf-8?B?RHRYd0xnUVdHVGxOSWlQeFIxdlRDMTRCRGJuWWpiOWY0SERHT21YMVVmWUVt?=
 =?utf-8?B?K2tDVzZ6UlhrNi9xUCt6TzBsS1ZMMFppVHhBMDlRekl2RmpMNjhKREV0NzdJ?=
 =?utf-8?B?aS9iZ3FEZ1hGNEJlcmw4NWliOU9rRklFcXZUQzNvVnZERy9Pa1lQWXVIKzlz?=
 =?utf-8?B?SDFMMWEwSk45VlUyQ3p2TUpzQ0VOUGlER21Hd3Rvci9JWkR3U0RqNVFWb2pj?=
 =?utf-8?B?bDZxZHhsZW5LMkZ4Y1NlcFdiemE3STdZa0J3MngyUTk1bnpIU3V4eG16UG83?=
 =?utf-8?B?akV3VHBHVVh2am8yTDc0dEZwRlJUSy9RSmNrNTZIbng2UmFDRmpqTFFqVFln?=
 =?utf-8?B?d1FFTllvTWtWUEhCUGlSRysyT2xWZ283NTY3T0FxM3hjSXBkZ2NiRnFlaXI3?=
 =?utf-8?B?ZHFXUHdzREYxZHZ1d0RxMElab1BuUGo2Y1BaSDZyMklUUzg5dVZnbXJrTlRp?=
 =?utf-8?B?WmxSa1BWMnZjY09ENEZSbXpURGg4eWlET1Y3SEo1SDNxZVlFdnZhY1ZoaktM?=
 =?utf-8?B?Tk5mU25xS3ozTWlPeDNCVUF1aVQwY0hzNXJ1WmNyQ1hGR1c1LytOVjJUTXFp?=
 =?utf-8?B?QTFSWGtndEwvREI5Tzl0M1d2ZlZJM3VVdkJvbXNRb1dkcExleXRsVnN6WkFH?=
 =?utf-8?B?czE3L1lUdk1namVYSU02TVhrS2hYb0hJbEZHRFlYWkNwOXNQS1pxNSt2RXZa?=
 =?utf-8?B?VHdGUktPSzdLZUdta0g0NXc2b3Y3b2lpdVcrdWVFNjI2NDR0a2FHRFUwY3dX?=
 =?utf-8?B?VjdnOGVDMW0yZnVSRmJBeXZMTWY4a0xZQ0JnWXp2cXIrQU1DT3BVcFI1K2Vz?=
 =?utf-8?Q?8uv5PEWK3j++8ZzvDrlAtc9Nc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6038d7-d318-4483-919d-08dbd0210234
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 21:27:19.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIXdNm6UxUujc6bWp61bdXpRtGCo8nmOcP4xYxjYw4GVaudPyIa0oAwPonfDAIcOFOmjVJArWsLrIIH8MuM85w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/18/2023 3:38 PM, Sean Christopherson wrote:
> On Wed, Oct 18, 2023, Ashish Kalra wrote:
>>> static int snp_handle_ext_guest_request(struct vcpu_svm *svm)
>>> {
>>> 	struct kvm_vcpu *vcpu = &svm->vcpu;
>>> 	struct kvm *kvm = vcpu->kvm;
>>> 	struct kvm_sev_info *sev;
>>> 	unsigned long exitcode;
>>> 	u64 data_gpa;
>>>
>>> 	if (!sev_snp_guest(vcpu->kvm)) {
>>> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_GUEST);
>>> 		return 1;
>>> 	}
>>>
>>> 	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>> 	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>> 		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SEV_RET_INVALID_ADDRESS);
>>> 		return 1;
>>> 	}
>>>
>>> 	vcpu->run->hypercall.nr		 = KVM_HC_SNP_GET_CERTS;
>>> 	vcpu->run->hypercall.args[0]	 = data_gpa;
>>> 	vcpu->run->hypercall.args[1]	 = vcpu->arch.regs[VCPU_REGS_RBX];
>>> 	vcpu->run->hypercall.flags	 = KVM_EXIT_HYPERCALL_LONG_MODE;
>>> 	vcpu->arch.complete_userspace_io = snp_complete_ext_guest_request;
>>> 	return 0;
>>> }
>>>
>>
>> IIRC, the important consideration here is to ensure that getting the
>> attestation report and retrieving the certificates appears atomic to the
>> guest. When SNP live migration is supported we don't want a case where the
>> guest could have migrated between the call to obtain the certificates and
>> obtaining the attestation report, which can potentially cause failure of
>> validation of the attestation report.
> 
> Where does "obtaining the attestation report" happen?  I see the guest request
> and the certificate stuff, I don't see anything about attestation reports (though
> I'm not looking very closely).
> 

The guest requests that the firmware construct an attestation report via 
the SNP_GUEST_REQUEST command. The certificates are piggy-backed to the 
guest along with the attestation report (retrieved from the FW via the 
SNP_GUEST_REQUEST command) as part of the SNP Extended Guest Request NAE 
handling.

Thanks,
Ashish
