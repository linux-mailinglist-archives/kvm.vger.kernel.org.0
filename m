Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA07354401
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241861AbhDEQBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:01:31 -0400
Received: from mail-eopbgr700058.outbound.protection.outlook.com ([40.107.70.58]:33066
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238034AbhDEQBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 12:01:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxhVZZIWhKYRoWjMFxz7WFOBXkfUc15Xfj5dSAbJ0/8IvWb4QqFYtlVHI2Zd8rpyTBXMypB3EJzKdKfUikUzlwhPRYr/qLO+CwpUQTuF11zDTVzSL5RH9dXrfo+iF0t9VRpDsC7FbjBUMfW75yYtkZBrO3eXePencN1m3n9XJlCYFSNDgvwJNAeXp9apgVQCDh/rBd0E/VVw9WshrPynGbfp2cH4ANmczt6R2FIBoqX1SNxB8y27ylBBcR1b4rZBsVzeKEKdgtnDpiCLTeXdRP4121y6c3PagZhcMevHqn5olRiolYyVnrB8DQMmLo87srSD+A8Fj1UZrInZVvdhFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpAo+xVJUdWDAEyOtjhYoA3jnp0ykdwOFhsJGf/ZLX4=;
 b=HKgleTKf0HvcmdWgIjbdjUl0Hks+BhAMtKQMqabd9f1aamR6I0u3hlnb6GseWWsNvbNmw+ZEvWk+TIqx2TZsUEqzVhU1VMaH5cW4ELdBugPZR5suORLN+SxrydQqVcNpyVzBkYEWltP0Puhjt6EXHuAhN6weTMu7YqtNhNwEju5d7GozqxnDraoNUziutdYpZ/omRTwHRwsUnta6Na2NegqBwPRcae7HPJYaqHtfTX/gqFAUExEoecslaeVpg1G0B3lyIz1sneaYKr+VLqNBHEe0tNPFAL6oJcYR/VJ+6tyi04MsLTB42Unxz170+vVPlqHmXO8Qi8gp9DxKy4I9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpAo+xVJUdWDAEyOtjhYoA3jnp0ykdwOFhsJGf/ZLX4=;
 b=dgy3aVw6puh0z+irzWW+YuAV+jR63dt57NfmVNXIL7rN9FMsznvF5ZZAw166w9wRbfMbsZU/MHVH9rKtwJ3Z1EgOqLmX7oy86a37f1TpMrKhmZ0xPUvmMhnDU8BD9gBkIGVsRBjgB4TOSFofjTTUmHG7ueZBfrLK5OkzRTnvapA=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 16:01:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:01:22 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/5] crypto: ccp: Play nice with vmalloc'd memory for SEV
 command structs
To:     Sean Christopherson <seanjc@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210402233702.3291792-1-seanjc@google.com>
 <20210402233702.3291792-4-seanjc@google.com>
 <8ea3744f-fdf7-1704-2860-40c2b8fb47e1@csgroup.eu>
 <YGsnjqFLoqXTrAHo@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <72d52bd3-453c-e6fa-4209-e2296ee34829@amd.com>
Date:   Mon, 5 Apr 2021 11:01:20 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <YGsnjqFLoqXTrAHo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:806:126::10) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0185.namprd04.prod.outlook.com (2603:10b6:806:126::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 16:01:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 199aab80-56d8-406b-f38f-08d8f84c0ec9
X-MS-TrafficTypeDiagnostic: SN6PR12MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27206584B222CC7ED7A8E478E5779@SN6PR12MB2720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xC7A5L5w1wExwRiyobJWYnogqr6yeDqQDt2gMsP4968FQH6pyj9vAVUqH+g28eyWM2/VvmKKod7/P//kJSJyc2JW6gSJu9e2kxB/ODnARjgEPMFtxZ9oD2Kf0Hsvgwz3pcCPGiDp8yk/9basy2+e/YkIG6bVe3/4KvZ0qq3JX+mXmK0xkjjrhoY+o1n/0YLuAzDWNjDPHT4WVStP9oFbeErUjH/za18fXBeCVSVkCiwJrV2noicSogqrFqdmQa4R7OTZrHvh9K1xHg1bWpAjoaT44bjRoekuHAztu4pVoKk8+btZLWhvPJZhzR+yGjQUs1NJQucpahYN8/YmaHczm6N40wGTwLDBSdcrQAGLBCrb55nzRoO2yTMm5KvUQVuVIs/qazm0YDqcHuJ5Si8Cj5N8yqhYzzYkOg68T/qIiKNWbsad7ucZyd443mabpoqJRQ5b9D2/IzSwqlK6FKX0TlXYn8LZPC8L0ESGmzTYzLDzqwsDmHC9aBB9k+IExMP3Eny5+RgukPzWjM0tbsJyZ3uU8dPy08Q6Wur/umdG4CrmqpLH26vz59UAb47TTqfEHb7esb05drrD2YfUYl8n7zacf1yq+modHsLOdGEClM04VGcetw5nCYYuOg5eczkJaEjIjHsDqTfK06pZ8KExT2aTBSTP8f8XlQagCZZu3HvX+I/3DPaIDHBFYNfG+0hzT1oqGsESngINIl5uOhSF/r9NFJ7BR+8yXid1t4XKzLG9VnJXNb/JsLK/wNalDuox
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(86362001)(54906003)(7416002)(66574015)(52116002)(6512007)(16526019)(186003)(26005)(8936002)(6486002)(5660300002)(110136005)(66476007)(31696002)(83380400001)(38100700001)(31686004)(478600001)(66946007)(316002)(66556008)(2616005)(956004)(44832011)(36756003)(6506007)(4326008)(8676002)(53546011)(2906002)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b045V2ZhRVZFeHR1cjlDS2VOZGRnOUZ3S3NER2M1ZUlHbmJ0S0NGb0lUTFNF?=
 =?utf-8?B?b1NSR3QzbHdBTDM3VHFidXp5dExtc1MxTTdMVmhnS1g3dHV5YjROTlp5SlJQ?=
 =?utf-8?B?WUh0cXZ4cHRCZzV6U1VYNUcyUWtHOGRweTBoSjQ5M0lqV2hMRjMrUHdLZ3gx?=
 =?utf-8?B?RVZJb1pZTlR6T3VMaVd1YzNmY2FmVWNreWxZV0tKdkU4bmFQcXNwQWxOZjVz?=
 =?utf-8?B?dHI0c1Z1VmxqOU8yb1hseStmUXppaGJ2RVEzS1lCNVJ4UDNKMDJUR1VUUTJh?=
 =?utf-8?B?S0YxaTJyR0ROVVQ4WkUvZnRBUy9iT0swTmw2ektZNEwrbjQ1dUdVVEZHWTF0?=
 =?utf-8?B?UkNKTEs4UTRSMnIwWVIyS0Frd3JYaGVzYUpYZ1dXVklKUzdRRVdPL1p1bytX?=
 =?utf-8?B?L2N5eTBkZXYxVzVlVWtmemJtdy9panhUSWkvSFNOUHd3RHgrZEZsdmpvaG1P?=
 =?utf-8?B?cDR1WEs1MEI3OXFtcUt5SHpyblkvTlp2bmdCN2prcHU1cTVXZzZLMjQ1OXBx?=
 =?utf-8?B?K2lMQkt6OWQ0bjFxQkk0K202UTVCaVBBUGdiZXlrWHM4L09IUVh0dVhrNXV3?=
 =?utf-8?B?bXpDMkNMamY3RUhUWmtvTzB1QVdiZkp5VEFoZEdjOWMxNU9uTzBzdko5NUk0?=
 =?utf-8?B?b2dKVEUxbDNBNU5yc2RaUXNnUUJlanZBUFgrd29EWWJhYXQyOVp1bG8rZ2dD?=
 =?utf-8?B?L2VhWHd0SUZBOFpFYnhSR2JHVVBDZE9DcEdHK2dPZGNITkxQVEJDbUROY1VO?=
 =?utf-8?B?cTJBMHhCUW9QYzk0ZHhJeXZCekZybVFXc1Jrc0lPaDcyYmc1b01VUkYwbGNh?=
 =?utf-8?B?V21XNzBxL2RvdjdsbUhvaWJDY2xSOW52SFA1c0hOd3hFbjZZaHY3a01BS0VV?=
 =?utf-8?B?N1JnbWlsNE82YnZBbHBaa2lEeUFqbGVYMEZsamZGT2doRGhpNGIxSHo0SFJ4?=
 =?utf-8?B?THpWcTAxU050Y3ovZnJvQ1FUR2NseDd1RzRwMm9ZSFlMR0V4eG9PWU91N24x?=
 =?utf-8?B?ZzBaSGdkaDhBeWdGVmFob2QzZHNSSFJKNlNNMUlkcHJLTWNubnpHSXgvRWEy?=
 =?utf-8?B?bE9vUWNGVTllSkphZ3phTjdvQi9ON0hOR3FqbmtNZ0pZZ1ZQbGJBNkhsVmIz?=
 =?utf-8?B?ZlowaGIveEFMWHN5bkpyMm1tTGZkOHN5bllUQnJZbUFUeEpDVDBuWmdmbFhk?=
 =?utf-8?B?V3ZOUjFya2wrby9EbU51M2JERUoxZnU5bDFRMlgyMlptV1hIUzIxSk56c1JP?=
 =?utf-8?B?dHdhK1pUSHk2ZXVFVHNyL3k0MjNuMkMyRWVEMmhPT2JpdEVrVGFCbytCaEtI?=
 =?utf-8?B?N1lxa3JRN1NNUTZ5eTh1RE5TSTJ0V3lmSUx5L2g2N1ZDaTl6alJWOHZtZC9o?=
 =?utf-8?B?NU9ManRwM1puaWRhV2hmTnpIYjBOcGV2T1JXdDhPNUIzamp6c2hvVjl2eElq?=
 =?utf-8?B?OGk5enRBeGU1MWkwa2pKQkphbnhzYkJ2WEJEcEFHTGF3K1JwNlkyakRVWDVE?=
 =?utf-8?B?YVE1eExDeVQyek9VMVVtQjFyTE5qSkp2eVBiUDFBa3cyN0lmdUFYTUZTdVht?=
 =?utf-8?B?ZGZ1S05JdUpwa1FsczM0YjNJUng5TitmWXpkY3hReXI0RlFyQXkvV2JqckhV?=
 =?utf-8?B?T0EzVVBsUVN4OTJtaVhiWjRDai9Da1RnODQzSTcxb3grSkFXYWg1T3UraEhi?=
 =?utf-8?B?NzQzMlA2THVGOXpkV3JKa25ZbmxJcUZZZE1PM1VGWDg2aHV5SVVTUjVpM1R4?=
 =?utf-8?Q?+8KFq6JRtfm8vCeAH08NYYdYzVkn7fPo1peUeBR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199aab80-56d8-406b-f38f-08d8f84c0ec9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 16:01:22.6102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQjcke9fZp2FnkN9VlAEzoUzOcvKOdun1kMyjUvrH4ubplpKnXEOgFrmD4cHB9O6QGbW1dMH2WYunnd5GGu/iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/5/21 10:06 AM, Sean Christopherson wrote:
> On Sun, Apr 04, 2021, Christophe Leroy wrote:
>> Le 03/04/2021 à 01:37, Sean Christopherson a écrit :
>>> @@ -152,11 +153,21 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>>>   	sev = psp->sev_data;
>>>   	buf_len = sev_cmd_buffer_len(cmd);
>>> -	if (WARN_ON_ONCE(!!data != !!buf_len))
>>> +	if (WARN_ON_ONCE(!!__data != !!buf_len))
>>>   		return -EINVAL;
>>> -	if (WARN_ON_ONCE(data && is_vmalloc_addr(data)))
>>> -		return -EINVAL;
>>> +	if (__data && is_vmalloc_addr(__data)) {
>>> +		/*
>>> +		 * If the incoming buffer is virtually allocated, copy it to
>>> +		 * the driver's scratch buffer as __pa() will not work for such
>>> +		 * addresses, vmalloc_to_page() is not guaranteed to succeed,
>>> +		 * and vmalloc'd data may not be physically contiguous.
>>> +		 */
>>> +		data = sev->cmd_buf;
>>> +		memcpy(data, __data, buf_len);
>>> +	} else {
>>> +		data = __data;
>>> +	}
>> I don't know how big commands are, but if they are small, it would probably
>> be more efficient to inconditionnally copy them to the buffer rather then
>> doing the test.
> Brijesh, I assume SNP support will need to copy the commands unconditionally? If
> yes, it probably makes sense to do so now and avoid vmalloc dependencies
> completely.  And I think that would allow for the removal of status_cmd_buf and
> init_cmd_buf, or is there another reason those dedicated buffers exist?


Yes, we need to copy the commands unconditionally for the SNP support.
It makes sense to avoid the vmalloc dependencies. I can't think of any
reason why we would need the status_cmd_buf and init_cmd_buf after those
changes.


