Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534A5253841
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHZTYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:24:36 -0400
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:4065
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgHZTYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:24:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtjZri9JtxDB97vPpnafp7vKJYW4ja3OgDHtIQnSB7VQT5ciB8RgyHd9rh/8v1VbMvJNqBMVtXoUU8MeMZ8DL5TEWNWFhDBepr8tTs92W6pCyI2r3gL646wpJ4mjTvXL2RdQDeYqTRDsVkJNcALdLgC2fT0c3KV3GhnAsz7cSkShc0W0TLen+U2PzlvH8CYSVwm4uPvZwRj3bldy845yYGGzQ8yHyIdwLE2t5ge1StkU+wVqGxIyYjxZ8RcIviYB9bcGv9JDF2k49mpvx2GlFsR2NJZPD/212/QGWgCrKPx/Mj0/itYnA2LZaukBnFiYfnma61ImqAHOpWaf4uvZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILvPigiAOF9JYcifou24gmexah1gvAGHFPjwUT30giM=;
 b=GVuiuubEbv0CjG8qlJvh8stqkBgGfG07Pl49Z1PWL5SwxrmnUcrYaCuZ3gMFkIpnl0V9wWiFx83NKBa2OlNQmAe7MD+Waxg5crqUIPr/HGH4OAMd8fISDP48OMiWa9exXyDo9BYQLFS/z2IQL8jrzHo/H1Xf+QLNjZZrp6Zljmaq9RNVkiWAq6U8N3tk+mJSGT7W7hqP1XxtT/ApiQyTqskWClX3iWGv8RQqNb3khJYHdeUkzdNx0ycQb3afFTA6z0Z0soY5uUHayqowHv46B+DDUn7O/iz9fHUAX6SLfphi2L3ukA+EfLuM2b7rtTGCeppvRKIDAVhI0INZavVv3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILvPigiAOF9JYcifou24gmexah1gvAGHFPjwUT30giM=;
 b=JPwIO50N8LBlBj38xwF+01zBg+HwRAcYUSMFjHtVU8ly11wv8DZjryT/TqS+m+XGY23q7ZxLbPooyVDqp2KnTkgrFSRljl4KfAdtx/v2TbIioQD+NJ36/czEzgp4wUnEYbFUiw1cr9DHUzkJ63i4CMFVi33LzmDm2D/T4r3Ko1k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2985.namprd12.prod.outlook.com (2603:10b6:5:116::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Wed, 26 Aug 2020 19:24:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 19:24:31 +0000
Subject: Re: [PATCH 1/4] sev/i386: Add initial support for SEV-ES
To:     Connor Kuehl <ckuehl@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <88dc46aaedd17a3509d7546a622a9754dad895cb.1598382343.git.thomas.lendacky@amd.com>
 <9cd2e58f-dfa2-e2ae-4886-dc194318c411@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <661cc790-f1de-56ab-cd9f-14f087851eb6@amd.com>
Date:   Wed, 26 Aug 2020 14:24:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <9cd2e58f-dfa2-e2ae-4886-dc194318c411@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0701CA0029.namprd07.prod.outlook.com
 (2603:10b6:803:2d::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0701CA0029.namprd07.prod.outlook.com (2603:10b6:803:2d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:24:30 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2c4b9eea-52f1-49e2-6e66-08d849f5a82c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2985:
X-Microsoft-Antispam-PRVS: <DM6PR12MB298595736207263AB43239A8EC540@DM6PR12MB2985.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/sedoGysyEEgkBqkdBq4vn9IF3KQaY8D127Lp9dHn7+B2VLNgSEsH+Sg8eL6wjigE+TjAGtivGDluB5BwhunK5xRs3xXUgwP8EY0u34y2tNhx5cqKGYFBnLU/cQffNbvbLVLHboF4kygEKn2Zf4QYGg7y4wG50WT6spQYilgXTVG66j5ejS8VR1EFQLJjBSEjP9evFh5dvask4p3G+zanecFnFY18XHI1VI4o6W7MawQI7syrJzFeeHOFFbQvE008BI7Tujopr5PsVCTBE56JB6IAz0kUFdp02/dU5EdQnq9XaMSxYi35DD8S2+mlkARmJ+5m4krMDyktKv88cF40LoKngc6ovz0RooepxeVn2Ug8U0wlVl/41j1RuuXlq8KCeLIrNT8ZpZlHdhpgMJosqcfTIN8P0h3GIT4D1ghnI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(31696002)(478600001)(66556008)(86362001)(66946007)(2906002)(66476007)(5660300002)(316002)(31686004)(36756003)(16576012)(6486002)(4326008)(186003)(7416002)(2616005)(54906003)(53546011)(8936002)(26005)(956004)(52116002)(8676002)(83380400001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 91Eoyx+U6NJUK2o6AgZMQNAqpBNBeHB4j0C01x0m7j0NYlI6Fxx2dzFilFqB8/jk9KO4sUY3kxJOm7gD9ArYlIls9pI0xUghL02yOCtq0w0HoiRGf8EnClNL5ZRoaDziqXschMDr7H7YvQ0vEm6M1NCLKQM8CMZMCyZDK0P5eABpknddkkHk1ixgQg3znRAddNDqBr3aJkDuY0AB5wI81de88W1G5VyQG2u6hKPS4+D2hyKLMyTsbbELSn8oWnr11Hkonc/LLQSAyrQ6gbZCjRqGOJbscU0Uk0LeAabezARdZGJQh+VIfRnA/u8hbGKK9JXadXhcldrLWzIdIZZ3Z3Hv33v+OQW/p1NdWVtAE96dcwG0HVgB0RywUOtKeL1PVJZ3iSW3hwE1TUFwAiDwQ9LWRXSia+joOB99RwYnWU8W8k5Zw3c7cguDWeKSK008oWvpThAecGVBWrrAKw2Wz4+ZSM3CAiIZeOIhbXrDTzc4wVPvHCQ3G3NKGCGBrOBDURBM5olZiU/g5gJJdkTusX21Y5SXHhbbxMTBBYvhrG2tMurQMAAigTQaDEAtJ13EY3Dl7vOum5N8q+5zcJyag+dbS2FQHKzicsk6+lowyQjM/1jSCY378fifiWeitCdBoNhYsgfjyo3FxIhFaiXMuw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4b9eea-52f1-49e2-6e66-08d849f5a82c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:24:31.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8G1d0ewGNtJYCe6jxEH9UHplbOE2wngqK9mVIiBDPVlP9QK0jMnybGST0oq3A5ccixsLOR08VAo8XreNrUFAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2985
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/20 2:07 PM, Connor Kuehl wrote:
> On 8/25/20 2:05 PM, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Provide initial support for SEV-ES. This includes creating a function to
>> indicate the guest is an SEV-ES guest (which will return false until all
>> support is in place), performing the proper SEV initialization and
>> ensuring that the guest CPU state is measured as part of the launch.
>>
>> Co-developed-by: Jiri Slaby <jslaby@suse.cz>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Hi Tom!

Hi Connor,

> 
> Overall I think the patch set looks good. I mainly just have 1 question 
> regarding some error handling and a couple of checkpatch related messages.

Ugh, I was positive I ran checkpatch, but obviously I didn't.

> 
>> ---
>>   target/i386/cpu.c      |  1 +
>>   target/i386/sev-stub.c |  5 +++++
>>   target/i386/sev.c      | 46 ++++++++++++++++++++++++++++++++++++++++--
>>   target/i386/sev_i386.h |  1 +
>>   4 files changed, 51 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 588f32e136..bbbe581d35 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -5969,6 +5969,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t 
>> index, uint32_t count,
>>           break;
>>       case 0x8000001F:
>>           *eax = sev_enabled() ? 0x2 : 0;
>> +        *eax |= sev_es_enabled() ? 0x8 : 0;
>>           *ebx = sev_get_cbit_position();
>>           *ebx |= sev_get_reduced_phys_bits() << 6;
>>           *ecx = 0;
>> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
>> index 88e3f39a1e..040ac90563 100644
>> --- a/target/i386/sev-stub.c
>> +++ b/target/i386/sev-stub.c
>> @@ -49,3 +49,8 @@ SevCapability *sev_get_capabilities(Error **errp)
>>       error_setg(errp, "SEV is not available in this QEMU");
>>       return NULL;
>>   }
>> +
>> +bool sev_es_enabled(void)
> 
> I don't think this bothers checkpatch, but it'd be consistent with the 
> rest of your series if this function put the return type on the line above.

I was being consistent with the file that it is in where all the other 
functions are defined this way.

> 
>> +{
>> +    return false;
>> +}
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index c3ecf86704..6c9cd0854b 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -359,6 +359,12 @@ sev_enabled(void)
>>       return !!sev_guest;
>>   }
>> +bool
>> +sev_es_enabled(void)
>> +{
>> +    return false;
>> +}
>> +
>>   uint64_t
>>   sev_get_me_mask(void)
>>   {
>> @@ -578,6 +584,22 @@ sev_launch_update_data(SevGuestState *sev, uint8_t 
>> *addr, uint64_t len)
>>       return ret;
>>   }
>> +static int
>> +sev_launch_update_vmsa(SevGuestState *sev)
>> +{
>> +    int ret, fw_error;
>> +
>> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, 
>> &fw_error);
>> +    if (ret) {
>> +        error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
>> +                __func__, ret, fw_error, fw_error_to_str(fw_error));
>> +        goto err;
>> +    }
>> +
>> +err:
>> +    return ret;
>> +}
>> +
>>   static void
>>   sev_launch_get_measure(Notifier *notifier, void *unused)
>>   {
>> @@ -590,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void 
>> *unused)
>>           return;
>>       }
>> +    if (sev_es_enabled()) {
>> +        /* measure all the VM save areas before getting launch_measure */
>> +        ret = sev_launch_update_vmsa(sev);
>> +        if (ret) {
>> +            exit(1);
> 
> Disclaimer: I'm still learning the QEMU source code, sorry if this comes 
> across as naive.
> 
> Is exit() what we want here? I was looking around the rest of the source 
> code and unfortunately the machine_init_done_notifiers mechanism doesn't 
> allow for a return value to indicate an error, so I'm wondering if there's 
> a more appropriate place in the initialization code to handle these 
> fallible operations and if so, propagate the error down. This way if there 
> are other resources that need to be cleaned up on the way out, they can 
> be. Thoughts?

I was following the existing method of terminating that is being performed 
in this file. I'll see if others have an idea about how to handle these 
types of errors, which could probably be addressed as a separate patch series.

Thanks,
Tom

> 
>> +        }
>> +    }
>> +
>>       measurement = g_new0(struct kvm_sev_launch_measure, 1);
>>       /* query the measurement blob length */
>> @@ -684,7 +714,7 @@ sev_guest_init(const char *id)
>>   {
>>       SevGuestState *sev;
>>       char *devname;
>> -    int ret, fw_error;
>> +    int ret, fw_error, cmd;
>>       uint32_t ebx;
>>       uint32_t host_cbitpos;
>>       struct sev_user_data_status status = {};
>> @@ -745,8 +775,20 @@ sev_guest_init(const char *id)
>>       sev->api_major = status.api_major;
>>       sev->api_minor = status.api_minor;
>> +    if (sev_es_enabled()) {
>> +        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
>> +            error_report("%s: guest policy requires SEV-ES, but "
>> +                         "host SEV-ES support unavailable",
>> +                         __func__);
>> +            goto err;
>> +        }
>> +        cmd = KVM_SEV_ES_INIT;
>> +    } else {
>> +        cmd = KVM_SEV_INIT;
>> +    }
>> +
>>       trace_kvm_sev_init();
>> -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
>> +    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
>>       if (ret) {
>>           error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
>>                        __func__, ret, fw_error, fw_error_to_str(fw_error));
>> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
>> index 4db6960f60..4f9a5e9b21 100644
>> --- a/target/i386/sev_i386.h
>> +++ b/target/i386/sev_i386.h
>> @@ -29,6 +29,7 @@
>>   #define SEV_POLICY_SEV          0x20
>>   extern bool sev_enabled(void);
>> +extern bool sev_es_enabled(void);
>>   extern uint64_t sev_get_me_mask(void);
>>   extern SevInfo *sev_get_info(void);
>>   extern uint32_t sev_get_cbit_position(void);
>>
> 
