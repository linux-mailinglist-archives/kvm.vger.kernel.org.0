Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E0426E582
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIQTyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 15:54:24 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:21254
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728290AbgIQQMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:12:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZMZEvqygOV+GaHYDeMz/WyupZQb9gYPNkZQgY33gl7ubfyEtbMos1XJyxDEKT7fNHcBXzCT8foO2XcYsZSHgDbn23BBmUEkBR7LsWodMOOOvtaqDQOC3+83BmKtgceBz8StMVCj2oMb/dxTHJt5ZMgvmrQha/bBwuBC24MYWfCSFFM/rVWeQJzEBm+gG7GcKMvNbQtRnqEMNp6VnOihSZho5yJ9pmThzba3gZIblOEuI5HQihGqoR80l4m8mIizjYhxbO76JR+vb6mtUVkQJP6byLhjgA+dlsBoQDgS9dS/DtoZ1v0J5opTkuZQk2E72f0DgyWWfFjse3NiLKQ8SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/eq/JFdFG5RCwhMtaziUiEDG2xEtqQn/xKir7bYh5g=;
 b=QvfK4GvCK1jvyKrb2RmU3ba7QqwSTaah1d8VUlvz+EmIvOWihQsh711HFO76pBDJGVmAv7IwgyQPSvHdCBMJys23/u4o5qf/L1P8MZXu+pqLu106SOx9bwHUCHfGRDgADgeUR2eNcBrkEhNM5t35dxdVpOdJ+w07wlaAfgmdHxLFLQAjeqgBEeHwBbyAeyVcXYXJzBxugr479AUOzo5mp23OgtkLP9FZHpnInygIrVYFeR+9zf5dODcxdlOXdqXlCM2i0uaj7s0taZf8oSBkdAPt5yDimSiU3Fv9PqC2vl4mOnlqg7F3bqfihGHnwby2qsL6AI/cFHXZFsdFWg0rxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/eq/JFdFG5RCwhMtaziUiEDG2xEtqQn/xKir7bYh5g=;
 b=knVFBys3ay7FUUA8oNvkykrTKH5O7bTjWrte6SJ7iV6rBWnBbW2IGXeCWAYFAg583oWqh9f8elmV6gyvm3is0oTLXsF/f+J/X7qBcAIEWKlydj0szQF2F4zCXgD1/WYx9lsJfsAj92olubSn9nNUc+To93XnJYwkF1h8tk7owGg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16; Thu, 17 Sep 2020 16:11:32 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 16:11:32 +0000
Subject: Re: [PATCH v3 5/5] sev/i386: Enable an SEV-ES guest based on SEV
 policy
From:   Tom Lendacky <thomas.lendacky@amd.com>
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
 <81e64c83-f41c-d8f0-3268-ec6185f4a8dc@amd.com>
Message-ID: <3c401a2d-db30-8d85-c474-5bb56f1c6f16@amd.com>
Date:   Thu, 17 Sep 2020 11:11:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <81e64c83-f41c-d8f0-3268-ec6185f4a8dc@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:805:f2::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR04CA0075.namprd04.prod.outlook.com (2603:10b6:805:f2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Thu, 17 Sep 2020 16:11:31 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e44a48b-031c-4615-9a27-08d85b2457cf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB317977C683E61A4782CA3545EC3E0@DM6PR12MB3179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVl0ot/Vndp0NR2V6Dx1W8Qd6AMfJvUuHEEfEAUtX6sK072lbQaGcdZ4VG+rP8wffgZao8/mLfz4UcBGSrJO+gQsvgNLSeG3/L30Glit2dVze0AM0FJtovRkc/xzV7Uc53xREtwpk5FFug2hZ/3FEwo7mzWRz0DfaxISi+TxgdVp+NhEsF/PcqKPUKR3VvsqxxaQkuInmQX2qUTvIjih5z55F/UlypXyAS5OYPchlqiLGIOMlFuthonhPCLJn6/GYDGkSliu7B3EQc1pkWW117qzWbOdhP65B95iWArD2aaN8qsug7qwkylyF+gZ62qXzGJkYrNYC68+138IIwmxqb6AL8ssofhCdccXsKWz99w38xYZKTAarsjZ6IwwyrRR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(6916009)(31696002)(66556008)(83380400001)(6512007)(66946007)(66476007)(956004)(2616005)(316002)(478600001)(86362001)(2906002)(36756003)(5660300002)(6486002)(54906003)(16526019)(6506007)(31686004)(7416002)(4326008)(186003)(52116002)(8676002)(8936002)(53546011)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2NHWQNJoIyBb9BLWLAbAwzIIlY2nZNM16tgzW7Gqz0LBoHdQZW/L7SafshVPoVZrWcW7gZdF1b/UNSCqoaibifnxHyJPzBSFPfJTM5Qcs1LJ6clf/v89CMrlL/XsZFm5TJtL/QBPghIcb0up8CaUe5LwMvqxriKK6+I3juss+iDblII7mbOzGatB5GsNcGnp0Fwga7TIh/4Vl9qkGi04PrFmSO6Hi2cjxR6tjGNAFZrYDSSQwUs3SQJDgt1iOzYrmqwAD13XG5ZvdVSPOfy8uJMIa6BqNzu8K6BcbIngsBRQRQ6QPlkkMZhDB2JopvPPYYPN7+zkP9C6ZjqCJMhGcoIrBfKMr9y1ikl2D/kS6ko3Wwh+QswP46wi2wAfKMGpkUmM2Nr6QA36LRUhHLFjce8wV8rgeVTaVufXzaOZKV7sFWXEqACzsTKiablYJeteOKX6JTQqH7G+IGF/tldMzSEf08MAgKJj4QdTD02PUPUNI84J2GCnUowSbTGCEYlRjgAxWOARzsgTXB6JmAMWUKbCEfYtxj7aDLn2AJx5Ui+ABhPh+uc9lAH6vHdZKrPoN98K6kIRi8EpEMv/B+LL0zg8npk1jg2lzaLEPTSdD6FowEMsWKNIOcVS7Pjc76MThWRszphWmowx2Cc1LSOhlQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e44a48b-031c-4615-9a27-08d85b2457cf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 16:11:32.6097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/FMx82DxKQiV8gaeVsEZrYnxsyJN+DFSIZ8s2jHfsTy4kxePhd48/zmP24RjHm1evWmNVvVwQqX9NigibKURQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/17/20 11:07 AM, Tom Lendacky wrote:
> On 9/17/20 10:34 AM, Dr. David Alan Gilbert wrote:
>> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> Update the sev_es_enabled() function return value to be based on the SEV
>>> policy that has been specified. SEV-ES is enabled if SEV is enabled and
>>> the SEV-ES policy bit is set in the policy object.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>   target/i386/sev.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>>> index 6ddefc65fa..bcaadaa2f9 100644
>>> --- a/target/i386/sev.c
>>> +++ b/target/i386/sev.c
>>> @@ -70,6 +70,8 @@ struct SevGuestState {
>>>   #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>>>   #define DEFAULT_SEV_DEVICE      "/dev/sev"
>>> +#define GUEST_POLICY_SEV_ES_BIT (1 << 2)
>>> +
>>
>> I'm surprised that all the policy bits aren't defined in a header 
>> somewhere.
> 
> I have another version to be issued with changes to use QemuUUID, so I can 
> look at moving the bits to a header.

Hmmm... and they already are defined in target/i386/sev_i386.h. I guess I 
was looking for sev.h and didn't notice sev_i386.h. So I'll update to use 
the values in sev_i386.h.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> But other than that,
>>
>>
>> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>>
>>>   /* SEV Information Block GUID = 00f771de-1a7e-4fcb-890e-68c77e2fb44e */
>>>   #define SEV_INFO_BLOCK_GUID \
>>>       "\xde\x71\xf7\x00\x7e\x1a\xcb\x4f\x89\x0e\x68\xc7\x7e\x2f\xb4\x4e"
>>> @@ -375,7 +377,7 @@ sev_enabled(void)
>>>   bool
>>>   sev_es_enabled(void)
>>>   {
>>> -    return false;
>>> +    return sev_enabled() && (sev_guest->policy & 
>>> GUEST_POLICY_SEV_ES_BIT);
>>>   }
>>>   uint64_t
>>> -- 
>>> 2.28.0
>>>
