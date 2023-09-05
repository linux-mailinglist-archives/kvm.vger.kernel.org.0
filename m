Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B95279268F
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbjIEQDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354903AbjIEPnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 11:43:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79A4A8;
        Tue,  5 Sep 2023 08:43:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xlzbbgpe1QI7XYtWR22RJrMAFKfUoXSacIj8ooMKbtFMlY842H0CYO4rygGPEti1HdU0GcN5I90IOc6y5W7wF2nl5ULiFU7MjicHwUJlRTxa5D7xd+U0Un7wm2DJb8ccmxpcTMIf6rc+BdejTIxd2BjHhkZ0A+tKGLJODhhdovuVquhs4JpFQNHELh68udpItroeyz11vuOYyx+0zDeol08/fC4HnBNjAt49TaxBD5BhgOqJ+V3kFp6cK4B+z4vHwTzCR+UukOlB8G6TxvPtT5JV246+i9fKRx+qM3hggAcfjUOgcUz7o3RUOU4qsnle0OXwr0ad3lYEcFRG3stljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LbMAXlUiUK6DgMvBQ848tC+ZctvqfMtxMS+KcQhB1M=;
 b=adPfY9jC91CpfcybGLKZHnOd/l+hDmy+vDMqTm8Q779ykIh9fl/WHsM+VzzOX2xaXqIxCgLR11HQiLA2KhSeEPANU5PSIm48wBLgU0+c3gt3WWieYzd2TsQe9qsmMQ+cZ5+6Kn/gNEASsIi7ivIOY766YTr7+AkAB9F+RUHcslJQYPTp2dxjlzLtd1amsip90fIubUJaBs9c/f/+aK86yH8L6Z+hkM0KdUC48BoDc6SYCSchWGLDnXeZEAJizc5VXoR/FxMb6rheTx0AnIqGoLUU0OWu0k8wiIPyYbU8vsNycg2bbsC4lsl9xdMDZe6goXmMlrVu+HE3X/4Ez8iEsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LbMAXlUiUK6DgMvBQ848tC+ZctvqfMtxMS+KcQhB1M=;
 b=x1XKFuxFwf7w8JDVaKVMimuF10E38uq6aL7PL5l+Ybp7GIKqA6w1earA+P6XGeLy2app6vNyPeo4N9h346uCYWKPrk1+0sZIPdV3kKxtd2e8m9cv2JGpQDIagGW+fFGJS4T7YYrnXJEciE550N0KbizXAxE82FNjPm5rKUVSBe8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 15:43:45 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 15:43:45 +0000
Message-ID: <dc03c6b8-0c44-9212-ee38-6d83af0d00d5@amd.com>
Date:   Tue, 5 Sep 2023 10:43:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 11/13] KVM: SVM: Add support for IBS virtualization for
 SEV-ES guests
Content-Language: en-US
To:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        seanjc@google.com
Cc:     linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
        x86@kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        bp@alien8.de, santosh.shukla@amd.com, ravi.bangoria@amd.com,
        nikunj@amd.com
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-12-manali.shukla@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230904095347.14994-12-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:806:6e::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN2PR12MB4045:EE_
X-MS-Office365-Filtering-Correlation-Id: dafd1821-9eb0-46df-9ee4-08dbae26e38f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2gv4kg0lUwHwFONY8/cgcdoNeh5iMkrojyhmQAHNb4tkbdp/1AbB1+CqYwrxqHlMztwluYN9zCZowv71HRjO4bxa9ePaKHPS8k0hRr+LTL9jISaIjrmVgAYNy1HzhChP+bfKiZSetmsGVeXtxb+MNtofa5S5bc11BPBx9owf3fnDAX3HqTAdkzHflFWeH7Ds/r9+nVbv7kPBU8QNlplDAkOuXU5lxdwd2WH4C+Bl8sG543i2S/ooRkYqdQjyQcAf49u7WkwlaBrlWojo0B+V6cLMSUPmpyA4uewwduWStnXtuX0j0RXi8CRj4kV/00dl6nZN4ubrIL9voEoPv10n7zNqBWIJ3nER6H43HTKsHGite9SOJpP7/SfrtPC93+TBB7RGiUonMgGbK6rwn7jzpUEdPo4X0hVWFw/O3LlgRpeoZqVOs32WEGJzGs8uV+KAXN0UhLBwXWo2eejXcHC/NCWiCXWbQDHvA5BmO8jSYkWrCY39QNCOpAx3Bj+xEoscdoQPe3XPCRmuYO8IIB++YPPNI3tr5iofep896vxi9/2P89kvFPt70tOXWGapPt3k6HFvqj/f5ogZU/dz6xg0k+d9o09L2LNJHb+5i+EinjYxV5cZOjHqs/YXd2lokFetvpou+tzdO9TVXiBvRiaiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199024)(1800799009)(186009)(66476007)(66556008)(66946007)(31696002)(86362001)(41300700001)(316002)(6512007)(2616005)(26005)(966005)(53546011)(6486002)(6506007)(31686004)(4326008)(5660300002)(8936002)(8676002)(478600001)(36756003)(38100700002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1l3cndRSDM5SkptZEVhRE5lYzdybWRDc3BZQ2JBeVc2ZlBWa1pDektEOVZZ?=
 =?utf-8?B?cTJ2NXZSTnBxS2ZseDUzWGh1dWRlbmxNYmpDMWFGeGdmQkJWb3lhU3VhdXJI?=
 =?utf-8?B?MmV0R0JoMzBSdi9tRllkekZyYllaNHRLb3M1NVRJd1JrTHRHRkhHd1dZekZI?=
 =?utf-8?B?SE02WlJNNWpNa2t1U25yRkROamlFd2w1dmNyMm93blQ1ZEg2YjZkZHF6S3Bh?=
 =?utf-8?B?OUpYVGV0UUZKdzY2Y3pyNHlvd2JDTXRWWmZYS3pZbFAzbjliOWRNZ3FLYy80?=
 =?utf-8?B?eUVGT0w0UVdMSnBkSGs2WThITlNURkNLbnp3eUJsYno0VTRGVitJdHpuSDI5?=
 =?utf-8?B?ZXVwdDUwUE9SL0NUWElvblpYelNSc1huZDU5cjB5VmdJeDBFUGxvdjNpbTFM?=
 =?utf-8?B?eEtQTjdxQUpMZDVXeTJSL1h5T0JCV3dIbEtiNHFjb20vSHdjZFArcTRCVHIz?=
 =?utf-8?B?WlorV2pwUnBMbllXNFYxbklDM1lhejN5WlFpRWtIRzBQNmNoMnV5am8yS090?=
 =?utf-8?B?bzVSOSt4UWRLOUgvWUwwZXg2MHJDNzRrZ3U0Yy9uMjhYM1RmSzdqMG11YlE5?=
 =?utf-8?B?S3pUclE3QkFSRzBJL3N0ekY5a2lvSWtOV1dhMFRzQkEyM0N2WHUvRTc4Y2Vj?=
 =?utf-8?B?OU1oU0x6YUZERFNha3ZEakZlZjNEM3lOZU9PM1FkTFZOdTJkU0Nvc1BDWmRm?=
 =?utf-8?B?QjFTNFlobXczM1VLZnljTHhPRzg2N1FEWFNEMVhmMzVxNlNPTXI0dU96dXcw?=
 =?utf-8?B?a0tqMjJ0SnhPK1ZJT0plZFV5dWJ0bDg3ZlNGbnBucnYyTjIwcWZxUVd6Q2tI?=
 =?utf-8?B?MDZZaG9DckhEWDRFNi9IK3JOclF5MVF2SHZ2UWJzMTZjRFcrcEIwU0VTWVZQ?=
 =?utf-8?B?WlpIeU5PWVErOEIwQzVSOFlmWitWMjdGcEZHL0ZQd3Q1d1hFdnUzZXJkemxT?=
 =?utf-8?B?R0g1ZkI5QlRpRnVZOW9DRnRSZlBhb0ZxNjVRRkRRdWJTSml4UTAyS25WVVNy?=
 =?utf-8?B?YWRjL3hIWWdGSGdmblpNYVBzWnRsR2N4R24rUUt6Nk55VHBiejJBbll3ZjhN?=
 =?utf-8?B?d05tdE1pckliSVZKczFGbHVmZ0xXZkdSczdRSkgxUFlLdzVPU2lxbjQ3cU15?=
 =?utf-8?B?T0ZCYWE3NWVhWWNqVVpsbytrMFFyejJzalFuUW5ML0c4Zy9kTnBVWUpBcm5G?=
 =?utf-8?B?b2pFZXNUclFQNVAxb0UwNzczWEYzaVVBTHVyU1k4YXVITXJFaHlDTGFITWZ4?=
 =?utf-8?B?SXB5elZFcEwrdUkxUmpVWW9uYWZSekxIWGxRUEVuM2hXamVhM0RiU3Rscllz?=
 =?utf-8?B?UHBaYThXRDB3SUptWFJQUC9OWHgrYXdKUGc0TEMrTnM1bkthdVVHR083OE80?=
 =?utf-8?B?OGFUY28xZzk1b3RPMCtFNVdlTjNqd2VSaVlnVVNLSEtXN3JKT09obzJFQ0lR?=
 =?utf-8?B?UGZ2bys0bFBqV3RTU21OQjk3a0tLTWt1dW1pQ0NSaVE5dG1yREpidUIvQmJC?=
 =?utf-8?B?N1pVUDJNVWlpS3pCakZVSmFOZ3A5Q0JQc2dUMDBWaG5TL3c5Z0JtalNuZ3BV?=
 =?utf-8?B?UVhOK2hReGpZeXJLQ08rbmUzdm5NcUN1ZFd6aWFIQ01odEx1NTFRbHZCRHpn?=
 =?utf-8?B?eXRVbzdKbjFFcFF1dWJ6cTZUL2xOZDJvc2loQ1pKOTl1K215aktveEFCbHEz?=
 =?utf-8?B?T05ML2FmMFUva3BJMTBKN1V3YXVhdGh3RUhBcXlSZmF2SVFoWFI2dzhQYWMz?=
 =?utf-8?B?dTFuekNXY3JwQkM3QXBBN2xoMDN2OEdVZ09HTFovOVQxSGViOUhGc2tRUjZD?=
 =?utf-8?B?T2I4MEx0Tm1lcEJsdllXRzJQbHJFMjlsbTR1Nm5paTBwVU5pUko0UDVUclNC?=
 =?utf-8?B?Y3RuVVViVHBEblFSK3YrOE95UkNDeWNxMWUreEdqVlRRcGpod3l4OEJhaDhZ?=
 =?utf-8?B?Y2VFanNXQWM3ajFhMmErOVdrT2F0TDF1SXo0cld3WEpNRzFzRzBQTTVYeCtB?=
 =?utf-8?B?T095WXJwaVp5YVloSmZrb09tSGd5QlRjVWdzUlFIRnVjUEdTTjZMQXRpOUVE?=
 =?utf-8?B?MDBsNlJFY25ab1VmNDNIaGg4ZTBQNzR2WFVpMDRVYlFkTDZDOVgzekZ5WlhJ?=
 =?utf-8?Q?RmpZ85msh13kqbL/eBAo0mM0b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafd1821-9eb0-46df-9ee4-08dbae26e38f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 15:43:45.8040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8i6g7khDEGuTNcZ6ZonFTwj0bebOCAxzkUYqPV82fTc+jx6FaYyHBVGbGytzZvQnJPEsl0O31DdFuaa1czzz9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4045
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/23 04:53, Manali Shukla wrote:
> Since the IBS state is swap type C, the hypervisor is responsible for
> saving its own IBS state before VMRUN and restoring it after VMEXIT.
> It is also responsible for disabling IBS before VMRUN and re-enabling
> it after VMEXIT. For a SEV-ES guest with IBS virtualization enabled,
> a VMEXIT_INVALID will happen if IBS is found to be enabled on VMRUN
> [1].
> 
> The IBS virtualization feature for SEV-ES guests is not enabled in this
> patch. Later patches enable IBS virtualization for SEV-ES guests.
> 
> [1]: https://bugzilla.kernel.org/attachment.cgi?id=304653
>       AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
>       Instruction-Based Sampling Virtualization.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>   arch/x86/include/asm/svm.h | 14 +++++++++++++-
>   arch/x86/kvm/svm/sev.c     |  7 +++++++
>   arch/x86/kvm/svm/svm.c     | 11 +++++------
>   3 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 4096d2f68770..58b60842a3b7 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -469,6 +469,18 @@ struct sev_es_save_area {
>   	u8 fpreg_x87[80];
>   	u8 fpreg_xmm[256];
>   	u8 fpreg_ymm[256];
> +	u8 lbr_stack_from_to[256];
> +	u64 lbr_select;
> +	u64 ibs_fetch_ctl;
> +	u64 ibs_fetch_linear_addr;
> +	u64 ibs_op_ctl;
> +	u64 ibs_op_rip;
> +	u64 ibs_op_data;
> +	u64 ibs_op_data2;
> +	u64 ibs_op_data3;
> +	u64 ibs_dc_linear_addr;
> +	u64 ibs_br_target;
> +	u64 ibs_fetch_extd_ctl;
>   } __packed;
>   
>   struct ghcb_save_area {
> @@ -527,7 +539,7 @@ struct ghcb {
>   
>   #define EXPECTED_VMCB_SAVE_AREA_SIZE		1992
>   #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
> -#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1648
> +#define EXPECTED_SEV_ES_SAVE_AREA_SIZE		1992
>   #define EXPECTED_VMCB_CONTROL_AREA_SIZE		1024
>   #define EXPECTED_GHCB_SIZE			PAGE_SIZE
>   
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d3aec1f2cad2..41706335cedd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,7 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>   #define sev_es_enabled false
>   #endif /* CONFIG_KVM_AMD_SEV */
>   
> +static bool sev_es_vibs_enabled;
>   static u8 sev_enc_bit;
>   static DECLARE_RWSEM(sev_deactivate_lock);
>   static DEFINE_MUTEX(sev_bitmap_lock);
> @@ -2256,6 +2257,9 @@ void __init sev_hardware_setup(void)
>   
>   	sev_enabled = sev_supported;
>   	sev_es_enabled = sev_es_supported;
> +
> +	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_SEV_ES_VIBS))
> +		sev_es_vibs_enabled = false;

sev_es_vibs_enabled = sev_es_enabled && cpu_feature_enabled(X86_FEATURE_SEV_ES_VIBS);

But won't this require VNMI support, too? So should that also be checked
along with vibs from svm.c (since AVIC isn't supported with SEV).

>   #endif
>   }
>   
> @@ -2993,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>   		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
>   			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
>   	}
> +
> +	if (sev_es_vibs_enabled && svm->ibs_enabled)
> +		svm_ibs_msr_interception(svm, false);

I might be missing something here...  if svm->ibs_enabled is true, then
this intercept change will already have been done. Shouldn't this be
doing the reverse?  But, it looks like svm->ibs_enabled is set in the
init_vmcb_after_set_cpuid() function, which is called after
sev_es_init_vmcb() is called...  so it can never be true here, right?

Thanks,
Tom

>   }
>   
>   void sev_init_vmcb(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6f566ed93f4c..0cfe23bb144a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4194,16 +4194,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
>   	guest_state_enter_irqoff();
>   
>   	amd_clear_divider();
> +	restore_mask = svm_save_swap_type_c(vcpu);
>   
> -	if (sev_es_guest(vcpu->kvm)) {
> +	if (sev_es_guest(vcpu->kvm))
>   		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
> -	} else {
> -		restore_mask = svm_save_swap_type_c(vcpu);
> +	else
>   		__svm_vcpu_run(svm, spec_ctrl_intercepted);
>   
> -		if (restore_mask)
> -			svm_restore_swap_type_c(vcpu, restore_mask);
> -	}
> +	if (restore_mask)
> +		svm_restore_swap_type_c(vcpu, restore_mask);
>   
>   	guest_state_exit_irqoff();
>   }
