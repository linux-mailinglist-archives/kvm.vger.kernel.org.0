Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3E327265B
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgIUNzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:55:41 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:40318
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726471AbgIUNzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 09:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiPeA9Y8DC5lFuDPCPioh7veGHlA+prLDlA6Wqa0C+gn/csnurAJaI3Jv+e/lGgiGjjViFa+NcrD/NGybqsakVfQ66ty6pZ9GPZ14oDoOjz+wdZkiiwHTzqHqj2Gn3Ct4i+Moy+iDbILKZNcRSPE8e+/VjLzrgT8mduik0ee9n0MI/PI78z/GUPHxyGL83S8c/9xkVDGx1W0rFn/eDAdMBGJFiExGeBTrgcLoyRY13G7LAlw61RvGjrt6bGf9slAvP+UkqZASHM9E0sufOFV71WY+yKJ609gFXYGD4ouK6jqsSjvloiGDD0mt79WW/KAUwnThGzSJc5WH5SXxYuxCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=degpsbBo984arjxl2XYhfPiKZ5IRhJ1LWWxCdWq19ig=;
 b=jJmmqineiWxfYj03H9olmjnCnRTLTEz+aWD+ZE6ngcfclN/qQoLjeJBvY5RbfEmv9U7fKVzgLBK2T7CpY8caBf0+ahP4u8iTAqK2rvnHt36YTAhuIhMnHHFfKJQTg++EzCrr33CeBcYz5AL29P1z65MnJA1MeF9kbjUg5KgOd3BV9My2vAcuaIeHyZzBfKhxDyC8xNagGVTz4Zp3TuBhJyFfM4f6Kzwa+N5GlEc8laLt5Ona3hwygfT/kyCQXeBV0oNMj8lUiVNsPmEZZA0OrOsUoOC448dJExkkLgs4548XpllwReaaQGibpBKT8Z+BTRyaXrEUKq40IMdEqw/m+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=degpsbBo984arjxl2XYhfPiKZ5IRhJ1LWWxCdWq19ig=;
 b=aCm9aaDqGWlr1sgYJERdAO+bwRx2jNwrzN+7NS0aXtv1QyAuoK7yjaoGEkFhB1oZewhIAebSsGvdtvVb3I1kMK3h3qkTpHN7vkMM10abWWXcPRdgXLhumBaQC9D++NPIbVhcL24URen0XJneOsn9wb37xx+/HUwZPlV+0pvZRh0=
Authentication-Results: twiddle.net; dkim=none (message not signed)
 header.d=none;twiddle.net; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3273.namprd12.prod.outlook.com (2603:10b6:5:188::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Mon, 21 Sep 2020 13:55:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Mon, 21 Sep 2020
 13:55:36 +0000
Subject: Re: [PATCH v3 1/5] sev/i386: Add initial support for SEV-ES
To:     Dov Murik <dovmurik@linux.vnet.ibm.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Richard Henderson <rth@twiddle.net>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
 <e8cf44ef-3180-8922-5f0a-2ce532005e51@linux.vnet.ibm.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2d1c5321-4c4a-e98c-ca91-7fbea9ae4ba4@amd.com>
Date:   Mon, 21 Sep 2020 08:55:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e8cf44ef-3180-8922-5f0a-2ce532005e51@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:4:15::31) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR16CA0045.namprd16.prod.outlook.com (2603:10b6:4:15::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 13:55:35 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea9ecd52-6d7e-48c1-341a-08d85e3603c6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3273064F310C9F5633E9E762EC3A0@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQEDaXrl512eNa5EyInkUXIqDMZ/ZP8+xs6JH9GAdwqe7gINsyVNPO0Gp19bnXgzqvnWke7hUCst4lL0S1KBdEHYESe9OfmxXw0xfREvs5cIIgC+ZfrSj2vn0w7O4wsvxJ+L4g59jL9myM5fx3Bzg3Lf5wfzxSLT/LwE/vkaLQhjcWTV9njcy3i3fWOZgYo7MN6Fj2Iuv9MWpeSTC79dEaUpaK/WQj3BQHCCK4IegIAt3PsZ7bTUefAAvxeG9ThUXP42CFvbhNyy8Ah5807+fs02TL4IvcihuEm4Tgb6VGy2YrI7A0sETawIuekH2oE6++oxO5kSm7sz7/6ZxtbwuKcVaJe4zU822deywTww3QOve8PDLve3enWXLy96B0j+cj6KR1/UlcQRZAZiOppjX+0ek/EE/ZuirkpDK97oehA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(478600001)(7416002)(66556008)(8936002)(66946007)(83380400001)(4326008)(86362001)(52116002)(66476007)(8676002)(5660300002)(186003)(316002)(31686004)(956004)(2906002)(26005)(54906003)(6486002)(16526019)(36756003)(31696002)(53546011)(16576012)(2616005)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JReioS71rsPf25GILv4qTlt72yADdG40BeN6lTCS6VpFn8sAActSkBwiRvIiVC/tAsfWc9jrysQzvnJbKMJVdMnXh/T0m0CrP6DEkCYjdzl8pyZ+soYrDHOwwRzagv+6l52jKUJKI03+BIj+I+vkSpiUfwgh7gavHwf8Rzc9bMGoAZgsb1diuoAdeOvE++5xNJV5x6a5TmeKwYhar8eMts7DOgdT95inbc0JRRhorB5cA251QOmArotEdnYWAPp/3CN+gGfQxvge5a3jn6AB2ttGebx0CfA2Dny9kFBZu9qCfZDD+TsLQcTiLhfTlO1v6Ub0B60dHA239Z9fe5gue7yXHPsa7vPfWrbjIka8rtlLtovGO0pTMPI9afrylZe1cryH7GXqfVyahoJZsWyxPk4HqPcGocEs1cJLNJ+GwLSMpfUOp4EGgwOcEeSLEO0jrUQvhCikAlIEhyPDHWjnCSHjrWRRKtZ7i9g3MF2clkYVSVcuoUShrH7Z0xSi0a9Tl1Y2PZbgZSNe4/gF7UzVzmEZzT/1oneu9D2QqHaQOK+9mfTU0I6vxJcYdGpLjln0XQ3foULga7NVv/NCpe9ecccQBxcTok3724J7O7JFNAFyHIsU6oyVUzzpU8SX2pWrvZkb108clteVnzMTyP02cA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9ecd52-6d7e-48c1-341a-08d85e3603c6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 13:55:36.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PrOdQiAL89/NkLk29fIwgUKZYnrEmdsxphTBfOaKgd5zuGODuBo9Ko37aBAKfboXaUqIL5fRy1dhFXMfR+wUKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/20 1:45 AM, Dov Murik wrote:
> On 16/09/2020 0:29, Tom Lendacky wrote:
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
>>
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
>>
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
> 
> goto (and the err: label) is not needed.

Yup, will remove both.

> 
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
>>
>> +    if (sev_es_enabled()) {
>> +        /* measure all the VM save areas before getting launch_measure */
>> +        ret = sev_launch_update_vmsa(sev);
>> +        if (ret) {
>> +            exit(1);
> 
> Other error cases in this function just return on error. Why quit QEMU here?

This is inside an void return function so an error can't be returned. It
matches what happens if sev_launch_finish() fails. To that end, a
LAUNCH_MEASURE error should probably exit(), also.

Thanks,
Tom

> 
>> +        }
>> +    }
>> +
>>       measurement = g_new0(struct kvm_sev_launch_measure, 1);
>>
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
>>
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
>>
>>   extern bool sev_enabled(void);
>> +extern bool sev_es_enabled(void);
>>   extern uint64_t sev_get_me_mask(void);
>>   extern SevInfo *sev_get_info(void);
>>   extern uint32_t sev_get_cbit_position(void);
>>
