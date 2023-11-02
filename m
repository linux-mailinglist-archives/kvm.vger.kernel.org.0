Return-Path: <kvm+bounces-357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DAB7DEB91
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:01:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB4ED1F223FF
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B26EB186A;
	Thu,  2 Nov 2023 04:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w4/v8rNQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2B1851
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 04:01:41 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFCD128;
	Wed,  1 Nov 2023 21:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1huwHDvtJMjs1pLJgcuwxh8r+oisMz78Nyye09cwEz/j6ZEEgUdFhzbFb6nUPZmwjTQepcLRSog4fINh0/kES2iKAIu/7JmChxs8QeRGEEGuaDiNNNP1K3Y1wZFCOD5Oh9iPDmWQjhGXDpeqePtBCeVSwFsBm5HwLj/nrD3pNcHgbktgSvdBcObTudoDkoCnPYDJmKE887m2qOZi/y/Zy8kgoCmZkwcA6ZAF22XNwpgmYoi+CtegPwtLbm7bvDv3iBVkPLqFk3qbvk7Wcn8WUmP9+BgRjX9LDCW2Ui5tOiC7eF3X5+z9S/cqiDHJAvK0CuMpPbkSM2Rc6NV/bEGwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ru8EDG0HszA/8XIaAh+aWckt5wUEoOLHWCbJUrbk8O0=;
 b=MCo3RGP0r9EHalXIDSb8nxNZiAzNASXaVGRd6RefH4FPEkQc6IT8YhTVf3NgOugWbRuiG5CRtSGi+mQt7H50U0TQ2nisM07A9ezcn2FwcgOS3j149bM/XjTYm9OkDh5x3E9wAqQEFeqxdBOQpcW9G1sJgtOdZNvMsOKqpnPU07iSVVPMAe8NXKPXKowm/vR7xsuMdNAIbKxVLpQ1/hy46/Qus+NXhKD8D8AX5vos06JfV5e1tgCatEWJdHbXxI/5Gx81Z2mhMfi/ucgqClVvTNKkGEJ8pFTUF9D/dO/omNdulhx/vXvRLmxlXsKJ8EfIUge96tuX4QOXZqRaDfUdZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru8EDG0HszA/8XIaAh+aWckt5wUEoOLHWCbJUrbk8O0=;
 b=w4/v8rNQH6UdayInhuA4/Lybeukunk/Zit4pPR2RtT+L5Ist1SHgv7jVkcJOyA87Lg8oLJKn0tIJFw2laCo80/TQ631U3wLTzgf0FC67gDIB2os8RmOdNAbDpIXFFKY5oZ6GF2qSDSjT8swDGxTKLegpB7C37LpxNN//pc1kXtY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB6445.namprd12.prod.outlook.com (2603:10b6:8:bd::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.29; Thu, 2 Nov 2023 04:01:33 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 04:01:33 +0000
Message-ID: <c7bf981c-3d24-4221-b35c-fc41a3ba6e2b@amd.com>
Date: Thu, 2 Nov 2023 09:31:24 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 04/14] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-5-nikunj@amd.com>
 <070e79b2-9cff-3d3d-4210-8a935518d979@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <070e79b2-9cff-3d3d-4210-8a935518d979@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXP287CA0013.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::35) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc7b4b0-19e5-491c-15c7-08dbdb58671a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x2+qzh11o7URwx4BwOK6yVGuiO269vg4y1BuoiNEvnWNhg0MdZvHi1RvYdRVdqWKtgNdAmKJ65KwxGRpy2X+efrKDK77mjSYFWZaU4cVSOlDlsESElFXOVDJ1gCzPTdg12ltP6wRrltrAROuTMF7lLi4LR1jstXplWOSnRci/7C2gx772uomqsaxvFJzfWJPFZ2cPKfmbcLk3ADOxY/tFufUkzmAKWiVWiLYI9ysfr1ETRDgoY/g2ZlhQnPOe3MdrbU6akSogCWZbBymZAsmI/tdFhKdWdCpBqPpKq0yeqIx1FIxEZzL4Rsd9Loh2qUK1p+ww83puaUuv39XUd1lkach8X990biX5p87coanwxHZh9ri1I8dAscImCmBfqo0wCtJ02qmHp8nB4ip4AwVVuBZEWdMfpid7SgoHpUO1BU0FbEzeM9kro6eJvMOp4Es+WIZ/LPkJDScz9Er4CEtrv/BRZxzp8GqP1fp9h1k1vNY0exOo5zET6FsbbxdCBIT6evqwi8csc6Ux3qkdkAkGZykZHzeyC/EeUcHYluczWNoNY9ZQ9OxjYUO9ciPqbLkqEolSG56KejIvN0EKZ3fq4iugZ4HmOReXHbtM76GSftdkeU0o3+zh5Sq4p4IJm4Rk93Thc1GPEi5ubsyDMV9og==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(366004)(396003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(30864003)(31686004)(6512007)(26005)(6506007)(38100700002)(36756003)(31696002)(2616005)(7416002)(2906002)(478600001)(3450700001)(6486002)(41300700001)(83380400001)(53546011)(6666004)(8936002)(66946007)(8676002)(316002)(66476007)(5660300002)(66556008)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk5TcElsRXZpSmZGRjdCOEZjMlZqNHJxVGQ1eHVaa3JocmJ4VU1yVWdYeGRN?=
 =?utf-8?B?VHQwd213bTQ5MW9udG9CanVGS0xVOW5iV3pqdlFsQlRzV1RUbmEveis3SGVk?=
 =?utf-8?B?QWpVdFJvaDBsYy90MGpmbUwyT0RCVm1ZbE5zbis3SHVGNVd0RDR3RkgvWEg4?=
 =?utf-8?B?NHVJdVREQzZkSmluVFRmUlpqL2ZkOGZGNHNKWCt4ZTFWL0ZCRDFmeDlUSEw3?=
 =?utf-8?B?SzN0VE9GTnNxdkZQamk0eFRhcEtweUV3OHZwQ3c4blp6L1ZORTVNR1ptYk1H?=
 =?utf-8?B?TmlBWUFjVmNlMHRxc21VUEpoT2ZuTzBFZys0MjlnaTRnOEdselVXejRQeVFy?=
 =?utf-8?B?Rk10cU44Z216ejhreXUxeEQyczlZa2h0aGp4K1FZcVhCUmJKeEZBSHpiVFp2?=
 =?utf-8?B?QldhbnltaURZS1hGNnpEMU43R2RYc2F3ZzV4RjFtYTBxelZncWp2Ym9ZOWdw?=
 =?utf-8?B?dnlmbWk3MWtJR0hvUUZOajNFV0xuTDRLMXpJdFNmM0djUXpwQ3JrbFJ5b0NR?=
 =?utf-8?B?ckVDTURyWG5GS29TaWZ0UzBBVmJSdUxmYUFRSWNqUFVxcG5haW1ISzZHV0Nw?=
 =?utf-8?B?SHIvM2ZFMXhabDl5am5UZklzWEJlVlhrQy9VVWprR2xoWHhDdGloSGtuaGxM?=
 =?utf-8?B?b1NCanlnaStWTVVYcmoxRlNlUmRFTTRFVFcyV3ZmbVBMYUcvcVlFbmtBWGZF?=
 =?utf-8?B?bHRVWlJnVHpyQ1N2L1h5U1RkeDJ5b2R2WXMwdjlkRDhURkN3U3hpWnZEVnBu?=
 =?utf-8?B?NElFTXhGcHd4WlB0Yk90WWd2SEpvOVgrV0c2T3J4Q0cyZlFoZ3N0Mm5SSTRs?=
 =?utf-8?B?OG1rQ3NrL00ybnA4a0h1andQdUVTVDhrby9wMGl0Y2N2SWJKUEw4TWpvY1U2?=
 =?utf-8?B?bGJ1bEUweHE1RUw1d3Z0Ymh4NytERlNkVUphTmlkeE90ckZJbzhyZ25LdnBm?=
 =?utf-8?B?Q0RiV3k0NGQxMGJSU3ZNY205NFp0d3Fwd0FsOVRjU1NMVlFWbkVoekNuREpH?=
 =?utf-8?B?TW9OeUFEaFExVWN6Ym80WnNnR3BsNFNXMXBOVTY1WjE3cEpnRiswZFlKU0kz?=
 =?utf-8?B?QndxSjVSb2pzVzJJSVVTYVRsdi95SC9HbmxEYWxjVG5zY09oOHdoVkVQMEI0?=
 =?utf-8?B?UDY5Mmt1YjZtOUFxL1B0QkRtRGRGcjkxbld3cUpVS0QyNEZiaEtJa1ZYaHFz?=
 =?utf-8?B?VkdJWEc4NXNtUTFmb1A5azR4K0JKa2dtTVYwYUVGYitoNEx4VExJdzRxTmdJ?=
 =?utf-8?B?cDQrbkVZS3I4TEpMQ1BGNkNucTF0aEs5QlhjN3VPOUxXcm1WQWdlamxRUTF0?=
 =?utf-8?B?emJxQTFFQU9FRTBlSlBoUi8ycnZ3R1FQWVdJaTBaLzVZWnBNU1lVelJHVmY1?=
 =?utf-8?B?ZDhuVzh0SGdxbnZLY0NCUjVEQ2JXVmhvWEhpYW5FWUJFUGFDWVY5cmh6TDJZ?=
 =?utf-8?B?UGdGU1MzMHhIUVFYVXJaZGp5aTJ3VFRSQStRaVhmNDA3UVhVb3RpVVErMFpN?=
 =?utf-8?B?NDJvaWt1MzZyV1RRbEdMYmMrZG1QT3Bia1haaWVZd3pZL2RLRE51VC95QjlT?=
 =?utf-8?B?bXVxWlFCVTF1Vk51cGRmOWxhYzZldjV6WjZMMkQ3bmF0bnBoYVBiNTZqQzEr?=
 =?utf-8?B?MWxmaHpwOStobHZYcS8vL080VmxHZUVsdmxJTGxnWkxoeXlXQXpuQThOMzll?=
 =?utf-8?B?cDhkd3FrSXJOeklGMG0reFlQRTNSUnlCNjh3N3lrZTg1ekU0a3Q1ZXBnSGE1?=
 =?utf-8?B?QlpMTDRjT1BqbFlkTTYxRVpaNDBIR2JmcUhKRkVGYmF6RnZsMGk0ajJlVmIw?=
 =?utf-8?B?cVNLY2dKanhoZFlEOThYWU52ejBWUVhUb2UweGxKaFh3Y05uSnpvRGFzSUJQ?=
 =?utf-8?B?cE1ySXRQaGlmOGUvRFlVcTlnZWRjbkFKVzBJRnkxbDlaM2VpWXpJS080dGxn?=
 =?utf-8?B?dTYzVGVGRGZ4TW5jM3pydFUwWmE2YnozSk5RTzZndHF5ZGUwREVyN2x6Q0ZX?=
 =?utf-8?B?a0E5WGE5Nmo4REp2MmhnWHhBWTlKK0xTTVBCRnVLUXZHKzVaUjJBbGtVeHNM?=
 =?utf-8?B?VmlQcE9nZ0JCeFh2eVRpN3U0ek5tZEh4L1VqWE9sZjJ5OWlzRlhDU0dZenFI?=
 =?utf-8?Q?zZVq7VyquhLC7k9TMt5+0V96a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc7b4b0-19e5-491c-15c7-08dbdb58671a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 04:01:33.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9p4kT/jwQFNFCv/0VbFdhVzeEbVvatVfB4adHJ7gl6H6sXU1ld0h2hwpDh+LdVEEPw9EFMJDf+gOfis9pGzz9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6445

On 10/30/2023 11:46 PM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> Add a snp_guest_req structure to simplify the function arguments. The
>> structure will be used to call the SNP Guest message request API
>> instead of passing a long list of parameters.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Some minor comments below.
> 
>> ---
>>   .../x86/include/asm}/sev-guest.h              |  11 ++
>>   arch/x86/include/asm/sev.h                    |   8 --
>>   arch/x86/kernel/sev.c                         |  15 ++-
>>   drivers/virt/coco/sev-guest/sev-guest.c       | 103 +++++++++++-------
>>   4 files changed, 84 insertions(+), 53 deletions(-)
>>   rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (80%)
>>
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
>> similarity index 80%
>> rename from drivers/virt/coco/sev-guest/sev-guest.h
>> rename to arch/x86/include/asm/sev-guest.h
>> index ceb798a404d6..22ef97b55069 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.h
>> +++ b/arch/x86/include/asm/sev-guest.h
>> @@ -63,4 +63,15 @@ struct snp_guest_msg {
>>       u8 payload[4000];
>>   } __packed;
>>   +struct snp_guest_req {
>> +    void *req_buf, *resp_buf, *data;
>> +    size_t req_sz, resp_sz, *data_npages;
> 
> For structures like this, I find it easier to group things and keep it one item per line, e.g.:

Ok, I will change that.

>     void *req_buf;
>     size_t req_sz;
>     
>     void *resp_buf;
>     size_t resp_sz;
> 
>     void *data;
>     size_t *data_npages;
> 
> And does data_npages have to be a pointer? 

Going through the code again, you are right, it need not be a pointer.

> It looks like you can just use this variable as the address on the GHCB call and then set it appropriately without all the indirection, right?

I can use the data_npages value directly in the GHCB call, am I missing something.

@@ -2192,8 +2199,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
      vc_ghcb_invalidate(ghcb);
        if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-        ghcb_set_rax(ghcb, input->data_gpa);
-        ghcb_set_rbx(ghcb, input->data_npages);
+        ghcb_set_rax(ghcb, __pa(req->data));
+        ghcb_set_rbx(ghcb, req->data_npages);
      }
        ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
@@ -2212,7 +2219,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
      case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
          /* Number of expected pages are returned in RBX */
          if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-             input->data_npages = ghcb_get_rbx(ghcb);
+             req->data_npages = ghcb_get_rbx(ghcb);
              ret = -ENOSPC;
              break;
          }


> 
>> +    u64 exit_code;
>> +    unsigned int vmpck_id;
>> +    u8 msg_version;
>> +    u8 msg_type;
>> +};
>> +
>> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +                struct snp_guest_request_ioctl *rio);
>>   #endif /* __VIRT_SEVGUEST_H__ */
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 5b4a1ce3d368..78465a8c7dc6 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -97,8 +97,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>>   struct snp_req_data {
>>       unsigned long req_gpa;
>>       unsigned long resp_gpa;
>> -    unsigned long data_gpa;
>> -    unsigned int data_npages;
>>   };
>>     struct sev_guest_platform_data {
>> @@ -209,7 +207,6 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
>>   void snp_set_wakeup_secondary_cpu(void);
>>   bool snp_init(struct boot_params *bp);
>>   void __init __noreturn snp_abort(void);
>> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
>>   void snp_accept_memory(phys_addr_t start, phys_addr_t end);
>>   u64 snp_get_unsupported_features(u64 status);
>>   u64 sev_get_status(void);
>> @@ -233,11 +230,6 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
>>   static inline void snp_set_wakeup_secondary_cpu(void) { }
>>   static inline bool snp_init(struct boot_params *bp) { return false; }
>>   static inline void snp_abort(void) { }
>> -static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
>> -{
>> -    return -ENOTTY;
>> -}
>> -
> 
> May want to mention in the commit message why this can be deleted vs changed.

Sure will do. It has been moved to sev-guest.h now.

> 
>>   static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
>>   static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
>>   static inline u64 sev_get_status(void) { return 0; }
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index 6395bfd87b68..f8caf0a73052 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -28,6 +28,7 @@
>>   #include <asm/cpu_entry_area.h>
>>   #include <asm/stacktrace.h>
>>   #include <asm/sev.h>
>> +#include <asm/sev-guest.h>
>>   #include <asm/insn-eval.h>
>>   #include <asm/fpu/xcr.h>
>>   #include <asm/processor.h>
>> @@ -2167,15 +2168,21 @@ static int __init init_sev_config(char *str)
>>   }
>>   __setup("sev=", init_sev_config);
>>   -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
>> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +                struct snp_guest_request_ioctl *rio)
>>   {
>>       struct ghcb_state state;
>>       struct es_em_ctxt ctxt;
>>       unsigned long flags;
>>       struct ghcb *ghcb;
>> +    u64 exit_code;
>>       int ret;
>>         rio->exitinfo2 = SEV_RET_NO_FW_CALL;
>> +    if (!req)
>> +        return -EINVAL;
>> +
>> +    exit_code = req->exit_code;
>>         /*
>>        * __sev_get_ghcb() needs to run with IRQs disabled because it is using
>> @@ -2192,8 +2199,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>>       vc_ghcb_invalidate(ghcb);
>>         if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
>> -        ghcb_set_rax(ghcb, input->data_gpa);
>> -        ghcb_set_rbx(ghcb, input->data_npages);
>> +        ghcb_set_rax(ghcb, __pa(req->data));
>> +        ghcb_set_rbx(ghcb, *req->data_npages);
>>       }
>>         ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
>> @@ -2212,7 +2219,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
>>       case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
>>           /* Number of expected pages are returned in RBX */
>>           if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
>> -            input->data_npages = ghcb_get_rbx(ghcb);
>> +            *req->data_npages = ghcb_get_rbx(ghcb);
>>               ret = -ENOSPC;
>>               break;
>>           }
>> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
>> index 49bafd2e9f42..5801dd52ffdf 100644
>> --- a/drivers/virt/coco/sev-guest/sev-guest.c
>> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
>> @@ -23,8 +23,7 @@
>>     #include <asm/svm.h>
>>   #include <asm/sev.h>
>> -
>> -#include "sev-guest.h"
>> +#include <asm/sev-guest.h>
>>     #define DEVICE_NAME    "sev-guest"
>>   @@ -192,7 +191,7 @@ static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>>           return -EBADMSG;
>>   }
>>   -static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
>> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
>>   {
>>       struct snp_guest_msg *resp = &snp_dev->secret_response;
>>       struct snp_guest_msg *req = &snp_dev->secret_request;
>> @@ -220,29 +219,28 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>>        * If the message size is greater than our buffer length then return
>>        * an error.
>>        */
>> -    if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
>> +    if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
>>           return -EBADMSG;
>>         /* Decrypt the payload */
>> -    return dec_payload(ctx, resp, payload, resp_hdr->msg_sz);
>> +    return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
>>   }
>>   -static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
>> -            void *payload, size_t sz)
>> +static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
>>   {
>> -    struct snp_guest_msg *req = &snp_dev->secret_request;
>> -    struct snp_guest_msg_hdr *hdr = &req->hdr;
>> +    struct snp_guest_msg *msg = &snp_dev->secret_request;
>> +    struct snp_guest_msg_hdr *hdr = &msg->hdr;
>>   -    memset(req, 0, sizeof(*req));
>> +    memset(msg, 0, sizeof(*msg));
>>         hdr->algo = SNP_AEAD_AES_256_GCM;
>>       hdr->hdr_version = MSG_HDR_VER;
>>       hdr->hdr_sz = sizeof(*hdr);
>> -    hdr->msg_type = type;
>> -    hdr->msg_version = version;
>> +    hdr->msg_type = req->msg_type;
>> +    hdr->msg_version = req->msg_version;
>>       hdr->msg_seqno = seqno;
>> -    hdr->msg_vmpck = vmpck_id;
>> -    hdr->msg_sz = sz;
>> +    hdr->msg_vmpck = req->vmpck_id;
>> +    hdr->msg_sz = req->req_sz;
>>         /* Verify the sequence number is non-zero */
>>       if (!hdr->msg_seqno)
>> @@ -251,10 +249,10 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>>       pr_debug("request [seqno %lld type %d version %d sz %d]\n",
>>            hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>>   -    return __enc_payload(snp_dev->ctx, req, payload, sz);
>> +    return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
>>   }
>>   -static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>> +static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
>>                     struct snp_guest_request_ioctl *rio)
>>   {
>>       unsigned long req_start = jiffies;
>> @@ -269,7 +267,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>        * sequence number must be incremented or the VMPCK must be deleted to
>>        * prevent reuse of the IV.
>>        */
>> -    rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
>> +    rc = snp_issue_guest_request(req, &snp_dev->input, rio);
>>       switch (rc) {
>>       case -ENOSPC:
>>           /*
>> @@ -279,8 +277,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>            * order to increment the sequence number and thus avoid
>>            * IV reuse.
>>            */
>> -        override_npages = snp_dev->input.data_npages;
>> -        exit_code    = SVM_VMGEXIT_GUEST_REQUEST;
>> +        override_npages = *req->data_npages;
>> +        req->exit_code    = SVM_VMGEXIT_GUEST_REQUEST;
>>             /*
>>            * Override the error to inform callers the given extended
>> @@ -335,15 +333,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>       }
>>         if (override_npages)
>> -        snp_dev->input.data_npages = override_npages;
>> +        *req->data_npages = override_npages;
>>         return rc;
>>   }
>>   -static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>> -                struct snp_guest_request_ioctl *rio, u8 type,
>> -                void *req_buf, size_t req_sz, void *resp_buf,
>> -                u32 resp_sz)
>> +static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
>> +                  struct snp_guest_request_ioctl *rio)
>>   {
>>       u64 seqno;
>>       int rc;
>> @@ -357,7 +353,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>       memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
>>         /* Encrypt the userspace provided payload in snp_dev->secret_request. */
>> -    rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
>> +    rc = enc_payload(snp_dev, seqno, req);
>>       if (rc)
>>           return rc;
>>   @@ -368,7 +364,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>       memcpy(snp_dev->request, &snp_dev->secret_request,
>>              sizeof(snp_dev->secret_request));
>>   -    rc = __handle_guest_request(snp_dev, exit_code, rio);
>> +    rc = __handle_guest_request(snp_dev, req, rio);
>>       if (rc) {
>>           if (rc == -EIO &&
>>               rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
>> @@ -377,12 +373,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>           dev_alert(snp_dev->dev,
>>                 "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
>>                 rc, rio->exitinfo2);
>> -
>>           snp_disable_vmpck(snp_dev);
>>           return rc;
>>       }
>>   -    rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>> +    rc = verify_and_dec_payload(snp_dev, req);
>>       if (rc) {
>>           dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
>>           snp_disable_vmpck(snp_dev);
>> @@ -394,6 +389,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>>     static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>>   {
>> +    struct snp_guest_req guest_req = {0};
>>       struct snp_report_resp *resp;
>>       struct snp_report_req req;
>>       int rc, resp_len;
>> @@ -416,9 +412,16 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>>       if (!resp)
>>           return -ENOMEM;
>>   -    rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
>> -                  SNP_MSG_REPORT_REQ, &req, sizeof(req), resp->data,
>> -                  resp_len);
>> +    guest_req.msg_version = arg->msg_version;
>> +    guest_req.msg_type = SNP_MSG_REPORT_REQ;
>> +    guest_req.vmpck_id = vmpck_id;
>> +    guest_req.req_buf = &req;
>> +    guest_req.req_sz = sizeof(req);
>> +    guest_req.resp_buf = resp->data;
>> +    guest_req.resp_sz = resp_len;
>> +    guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +    rc = snp_send_guest_request(snp_dev, &guest_req, arg);
>>       if (rc)
>>           goto e_free;
>>   @@ -433,6 +436,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>>   static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>>   {
>>       struct snp_derived_key_resp resp = {0};
>> +    struct snp_guest_req guest_req = {0};
>>       struct snp_derived_key_req req;
>>       int rc, resp_len;
>>       /* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
>> @@ -455,8 +459,16 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>>       if (copy_from_user(&req, (void __user *)arg->req_data, sizeof(req)))
>>           return -EFAULT;
>>   -    rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
>> -                  SNP_MSG_KEY_REQ, &req, sizeof(req), buf, resp_len);
>> +    guest_req.msg_version = arg->msg_version;
>> +    guest_req.msg_type = SNP_MSG_KEY_REQ;
>> +    guest_req.vmpck_id = vmpck_id;
>> +    guest_req.req_buf = &req;
>> +    guest_req.req_sz = sizeof(req);
>> +    guest_req.resp_buf = buf;
>> +    guest_req.resp_sz = resp_len;
>> +    guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +    rc = snp_send_guest_request(snp_dev, &guest_req, arg);
>>       if (rc)
>>           return rc;
>>   @@ -472,9 +484,11 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>>     static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>>   {
>> +    struct snp_guest_req guest_req = {0};
>>       struct snp_ext_report_req req;
>>       struct snp_report_resp *resp;
>> -    int ret, npages = 0, resp_len;
>> +    int ret, resp_len;
>> +    size_t npages = 0;
> 
> This becomes unnecessary if you don't define data_npages as a pointer in the snp_guest_req structure.

Right, I will change that.

> 
> Thanks,
> Tom

Thanks
Nikunj


