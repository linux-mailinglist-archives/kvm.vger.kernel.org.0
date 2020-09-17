Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE31926E09A
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgIQQZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:25:10 -0400
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:64517
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728448AbgIQQXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:23:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ma7x7TswjP/5Fokw4ATgcV+OuNvFtJz7RdpOm7gcjUb15c/v3n1u1T5wNBqkrMFlhRsi5XOLsqMwhWAs4+OKXcGFkxVo2YbmYAVOg3s1AdgipLuEhRoLIQWqy+grSHh173Js4gaA6f69x29+tOUtw4wqxtP+OM5zUKoyJ8hagWSUKR5e7fDsbX7k8aln2e0kPBrIQBNu2u6F/aKyhCdsfhFIVIKXAlBaNgCGUJQW51lVlYYe513S23trdMtukmZJtXliMjU2Hsu6hFHYFaO+2CNYE6t07gN2Ow1cbgN9dRYNLcszsdeI6WDMt/rtQzwR5k7XphPJ0+6phem/E7qqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++fF/0IKAuyREH4cF9PuV/I1Qr1q5dQM811yLm4F3mc=;
 b=Aas+G7Xb8Hoht9srh+WrxkhMYLKDXmtIH+IvSvY6tTUppcLXZ7XVEpQlotxwYb7Z4z3W2/ce6zRvBQSrH+PwkeXPaORnOhAwQADnh8fPrsAP0ke4/7v0KP4o098pJqNVU5Ox8lKMrIxxDXQRhKCDJ6jypK8A0wGoKKf3FdQDOu0xKk5so3zmL0FhZ50tiJVOQhsaWldc2icFlOi+XfDI0O9MsS24PFCVjEFFHBaSmREksksdHFwiRk6luX6783POGdVu+sLmidKHtAYkbPUYmdGYtpu9uERgdM6pljloPVNXHuQzSZnUe8CqC239gvVOQ0o+QtE86Opdb3sNq3SpiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++fF/0IKAuyREH4cF9PuV/I1Qr1q5dQM811yLm4F3mc=;
 b=v6eX/WMnu8X2bBUEWgrSIwU00E9gTwVBdAOPgw0n+oXGy/7PaFN0DfIJN+7Mc8zaFK1iNKSrb0/6rrGcL15H/A4rEcjuOt9/+ri1gknhfCEXlkM3WrWo7MA54Qi1dC0Ld4VBLrX0nYvb2CXgrgcDkNbMOpHgiWzdj2j7O1bQKf4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3690.namprd12.prod.outlook.com (2603:10b6:5:149::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Thu, 17 Sep 2020 16:07:08 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 16:07:08 +0000
Subject: Re: [PATCH v3 5/5] sev/i386: Enable an SEV-ES guest based on SEV
 policy
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <8e560a8577066c07b5bf1e5993fbd6d697702384.1600205384.git.thomas.lendacky@amd.com>
 <20200917153429.GL2793@work-vm>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <81e64c83-f41c-d8f0-3268-ec6185f4a8dc@amd.com>
Date:   Thu, 17 Sep 2020 11:07:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200917153429.GL2793@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0066.namprd12.prod.outlook.com
 (2603:10b6:802:20::37) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0066.namprd12.prod.outlook.com (2603:10b6:802:20::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Thu, 17 Sep 2020 16:07:06 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9e99544-6148-4c09-baa2-08d85b23ba4e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3690:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB36906B6C69703F8CDC4673A5EC3E0@DM6PR12MB3690.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Zlw0tH+uu8dtWe29a54aYtqb4RngLitnkFyKNgGmJHXyD5lAEmynY60UaBdAEvmdBXVk+VIgG3lwpfd43QOxceMNpTWMSQnBThk1/rrCb9JBofbp9LkmC5Z58h70bq1wnayUR8Ekk7BXnfltfimvHJI6yP9rdBemSVMh5cVA64Rbo0Pcg0NAQ4snptEqo3+yMRDAsgG0qiq3uzqNXwJHT5WqhtooJ3BsxzbMYd6pJEMuF7SGV6U2DGhTfXAN7/LUvWpXzotDxptaZJjxMbJ4bI6eHWVq7RrANP7wxYFk4/TZyJjtfVBMkB076y25KXqFIe2mQCOY9VNbqtW82j8c1EQxGyquciL3DFLuvbmyNQD+FKAV8S6K0Fs5vqB0OdP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(66556008)(31696002)(66476007)(66946007)(2616005)(8676002)(86362001)(316002)(2906002)(8936002)(54906003)(956004)(186003)(52116002)(16526019)(26005)(4326008)(6506007)(5660300002)(6916009)(31686004)(53546011)(6486002)(6512007)(83380400001)(7416002)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GQnDHWxPvVhBOHKd3OWbrflHyQmyYwiKMFUZ2pyeDs54UiiJbzY4ziFzCUEFVMNqxyDTh2QyuIFU2jMFZsZ7S6JCnrd9SrxGHpTz1EJORGzQxoQnCTV3ZVyE1GHg56LbHqZ1qFtM4enFx+Bhq+xdkyrodURNaV6jl82oHgc8WvZi0WbwNGrjh+92Kw6nZnWvpjMKo+zyKdnlSta3NcaeDfyBaT1k/ukuQK0ndHoztLzc5a2AFd5WDTxh65VfFk4NwjL7740DnhBkX6v/XYssOuExQM8LHie04xS5iC8MIS3ZJccvoe7aAU+ugtWEBMXpHKHrmROqIBrlKUREnB5neyPycBzE8dh2FCPk3sIAvTZG1Y+VtBRVIv571wu8R29yVAa+vRNRu+oDeafXfDDG5nzsxDO+LUh6wF8xUZYaqx0RTFvEeSsAKqhUB9IBbchOO/zy9CPfMvfoiLaFMyiQOZY/vPdjZ+4ldP7KnDzzcxJK1kIOs8r/A6BTHtuNvNwbp1JZxi/w11FZNp4l7q8DXTHxjpgtHY+XR0u2u9ynJVZpDnwmJl99zZUGrHBog3OocUjWwOGD56aThi4oPma1ORKdS0b08rt9yfxzSlUtyQKynQGmY3kiMmepb+3GiyCz6lybMUUzovfdPJRMSauEzw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e99544-6148-4c09-baa2-08d85b23ba4e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 16:07:08.3228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sYMD20S5895Akp99uYC48lCkxCBAhsMT84I7TpSnLfdqRZKQmSgPXctm1gXogJ7+r7W0a0JMM79x00lOY0L4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3690
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/17/20 10:34 AM, Dr. David Alan Gilbert wrote:
> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Update the sev_es_enabled() function return value to be based on the SEV
>> policy that has been specified. SEV-ES is enabled if SEV is enabled and
>> the SEV-ES policy bit is set in the policy object.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   target/i386/sev.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 6ddefc65fa..bcaadaa2f9 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -70,6 +70,8 @@ struct SevGuestState {
>>   #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>>   #define DEFAULT_SEV_DEVICE      "/dev/sev"
>>   
>> +#define GUEST_POLICY_SEV_ES_BIT (1 << 2)
>> +
> 
> I'm surprised that all the policy bits aren't defined in a header somewhere.

I have another version to be issued with changes to use QemuUUID, so I can 
look at moving the bits to a header.

Thanks,
Tom

> 
> But other than that,
> 
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
>>   /* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
>>   #define SEV_INFO_BLOCK_GUID \
>>       "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
>> @@ -375,7 +377,7 @@ sev_enabled(void)
>>   bool
>>   sev_es_enabled(void)
>>   {
>> -    return false;
>> +    return sev_enabled() && (sev_guest->policy & GUEST_POLICY_SEV_ES_BIT);
>>   }
>>   
>>   uint64_t
>> -- 
>> 2.28.0
>>
