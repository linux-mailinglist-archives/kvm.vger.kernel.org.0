Return-Path: <kvm+bounces-3968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A9380AE51
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 830701C20CFB
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D128A4CB3E;
	Fri,  8 Dec 2023 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KafJddU5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC481720;
	Fri,  8 Dec 2023 12:54:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUlu5Mr+lxsHp7HzrXRjN6moP8fbuUI4wvNMCzQLfxfJkZmx7IMtWHlg6+bSFj4+YI1zWwgbYkr98mStdJ1sJ41Q3hy7T8/oqqw7Bb/TFnQFZ1L0mjc1rdQAQ2fsDzyYzJ683zXLxg0OyXyqsdZLTgBoH2xtjrJ8ny9yhaRMwVZ8Fmt57pZ/0rgJ4Hxyb/nrdfcc7rDqLSB89m1bAubPuqsw7JRqsj02dT6eonTRxvTgnWWgZEnTVR/MpgQNvbEm3AgbrwtVWjgz35eaxidwnbI0GyHk0P7z955Ir/84L5RAJi0JvV2IcsGyqTuYSjO1vECPxUVMaiv/9WBwLQBY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0mDd65rYssYzWRBtV0aogY1FIT4MPMeaYO5Tclb7n0=;
 b=V1ng9i85dbjVsj12owZbg38zBkNWn3Veeh5vAq13SvHwYzAwATSJax1+bejX9vRub2TlZYk28tonGYJjOYHo06C7DMqQHSlvLOAK1A7rSbSDfJMhXvpdDgGISOtumJlHpLum2oUZKEQe7YLd0Dy+YsBkIP8UROr+MvI224/Qb+JPJLmb8jtOPzL7WJy22zJhuFlXtZgTD+yxG2Zq8WjIKiswAPOHPV7IK40AhGpVf9FpM3sRjeiMmfSxXis8RlJIQfnvAlA87RVkR0zPz6uPTj0/akbnnnLzBJzt6TLiu4NwRHZ3xTk/IrLz3rueSgmRNzzTTcjpKWXWS+4oeNsVWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0mDd65rYssYzWRBtV0aogY1FIT4MPMeaYO5Tclb7n0=;
 b=KafJddU5oHkY3qtqj2N/zyA+k8dfkdiBSphEy21RnxKh1oyb19VxHiKft89iIhYSURzfQEEMOISTNLQdjYVUmlORMEHBTJfLwie7KSVrNZMBr+oLXTLklHxcmSLshATDZGABccorqHTfOEtc0V/viz6AF1O2Y02itD3mdwuj8q4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 20:54:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 20:54:21 +0000
Message-ID: <f0dc32ea-3b77-1e9e-42fd-3f115c001f7c@amd.com>
Date: Fri, 8 Dec 2023 14:54:14 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 16/50] x86/sev: Introduce snp leaked pages list
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-17-michael.roth@amd.com>
 <20231206204255.GEZXDcz9yfyMiyYQ1H@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231206204255.GEZXDcz9yfyMiyYQ1H@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:806:f2::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b61379-d39f-47c6-9962-08dbf82fd843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IR6o5tliSKpLkV9yTEmMpauMzmfJDAxDZWF+hIo3m5HRjf0FjUMr6JynaTGEpN2waw4xThs3feTOt2VBDizIWXBTi19Pz5FwDaVGsFcB4RQOl+LPI8IPg/6UmFFRPTw+OZR5LGYkpkziUFsG2Jo0kKsmP8CaSZy6wyOgdYgxpyM8ui5DFxGIHB4greC8WCQz2qp1aU9OqD0wctTdUYsqJ+GV+0VGawSSl85CIU4qiyUvqcpKqc+Hij6DAwGkYedOAu6RjeHe4DvbF7qZERMi46ENAUMehxqAwcpBkbEVDAo/jQfUuGouweq/F7ROu1U5YAl7FVIclT/az6N4uKqIhJK+T5EFldF37snUQkZbfasJWY7Hc6/nToCQLw0QO26aOVPhNctJXxrmGU+la168yDlXBt01T2xeXazRXOaT4Ypj0BajPk9RXI+OV0kbEwCO6RkfZStr/r5Fya05+0oc8LTEPHKXeSKOPEeVyiuHggOhPrx+BU/FdRCHOWhKodPflVp5ram6NvlUZ96bYzvmoPwY/Uql7NMqiW7eSl+iVlRS+0P6DAmKWCXKE9EcW57QUw2cfyaWW+ujcerkG7VBKRzD73DodG/1D9GcbYKVlc3TyHz06NkY3OACrDc/MbyI+DRi1CFBJOiNxWxhth7+XQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(31686004)(38100700002)(66556008)(66946007)(86362001)(66476007)(31696002)(36756003)(26005)(83380400001)(2616005)(6512007)(53546011)(6506007)(6486002)(7416002)(7406005)(4744005)(2906002)(316002)(110136005)(6636002)(6666004)(478600001)(8676002)(5660300002)(4326008)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3ZJOUVUZndTK0ptWUlLckRKUVpRMkxIZm4xbTdwa2ozWWFWVFZNSWhGb0tk?=
 =?utf-8?B?UjlWaWZ1N3hEOWlzeEVuSVl4a1dPd0Q4cEVZVnEwWHgvSW5jNE85SWZlelhU?=
 =?utf-8?B?aHQrNFhtcnlCZEk1VXFrZzN6dGFSUEVGNnVZYjhhTi9rS0lITEV2c2xyenRO?=
 =?utf-8?B?VkJPcjRyZmN5cXp4MjRoZzFIWU93TmRKcnZOZVhINkpQQ1hsNG5FOGxBOTkz?=
 =?utf-8?B?ajVqSkswMld1Sm5wYXN5RkdxN1dmc043ZUpuVVdqeUZJMDBQWHp2MklnYTJG?=
 =?utf-8?B?UHJZN1JpN1Yxd0FkOGc0azZNT2FvR0I0WEZ3QUYxQzhGbHBJL21oTFpnKzQ1?=
 =?utf-8?B?cnFmVVhDMStrOFRIVXRxRzFCa2h4cHM0ZXdaOTB5Vnd3ZDArOEk4eDJZV2x5?=
 =?utf-8?B?dThLa005WnJtZjdYTEFjd0dONGxwL3BMMWF6ZUcrL1o2WExaRlBZamhUZ3RT?=
 =?utf-8?B?WEJDclNCTUJmMFh3S0tGWXFYMzRxUmVhTStFL2ZQdWtBZkQ1dVduVU4yZ2lQ?=
 =?utf-8?B?S0VVdlhYQkE5ZTlOU2tGMVFYalhPaTlIcVZWcmFnczRBZGhGQTV6UlVjVGpB?=
 =?utf-8?B?djFPelRYK1BCY0llZFVVN0hET0JBNUVIYWpnUnRqMWRLWTRQN000NVBFbXkz?=
 =?utf-8?B?WEMrODhpWTFCWVdqYy9MMk9SdlB1MTFuZ3ZFY2Z3MmsyYi9sQ2F4V3VuNG9R?=
 =?utf-8?B?cWJBWU5DOFN0N3NWRDQxaEgwUFgwMkU1b2FsdGpkUW5RcDlvNGU5bTdXV3p2?=
 =?utf-8?B?MDYzdlVoNTNoMlByZW9pT0VKTDI3OG40cDVETHdOMmFtOHIwdWRqTHM0SFBL?=
 =?utf-8?B?NndGQ2l0QzM4M21EOHU5T0tBcGc1TVZEbUx0elZHWkJKV2JMVHhOY0x3MDVO?=
 =?utf-8?B?Szk1Rzk2ZDBYUnF6Vm11NkVwdzFLNEtTczhERGZlQmdlWkdXaEtDcWk2QTJQ?=
 =?utf-8?B?d1lKcW9FNFNmK0VrTlRDOUFOWGtNWkVCOFN1TEdrWkphY1JwanBETlg5U2ZS?=
 =?utf-8?B?T1BrSTRGdjN2ZjNVSnhxejlSMzhHL0tHQ0lOQUl5QTNxYTlsdjBYSmJaNGJ2?=
 =?utf-8?B?ZXROdjBQVGRTcnkvZmlFLzlrVkZaYVpkdWcwbEl0U0xHZFArc3NSOWk5cjRE?=
 =?utf-8?B?dW1pMCs2b1ZnRytOeFl1eXBkY29WeU1HRzlQMFFPZ1VsV2dJTUF4cHRGMmdK?=
 =?utf-8?B?MjkwUStpRVZTU01MMDdibDREVlJiRy9JVDZPWVNiTHhQekJtVXU2M0lnMjlO?=
 =?utf-8?B?T3duWS9kZlRscFpJeW51ei92Wk85bUVheDlkWTM3dldhSS9VMS9MVVdFT1BL?=
 =?utf-8?B?bE1sajRWaHBHbkI4eWwvT1VBUTMyUnFjUzZpbktTNUhJU3VYMWdIQ25qZjBJ?=
 =?utf-8?B?ZTBmSGpnYXp5MXpWSlZpSGhVOTROUjJCWnYyckpabHc2UzZMYVkvNkx2dHBU?=
 =?utf-8?B?Qko4c214bXlCWG1HYzd2dnAwZ2EzdEYvQWNQZFgyUUZMYXFzcmZFS0YzdDdC?=
 =?utf-8?B?TW8wazhyazREWVBwbDdVdFRhWGcxQjlmK3ZMQUJ6Y3M2SlExbE81SjE2ZG1O?=
 =?utf-8?B?UndFNVpqY0ZSUGw5Yjc4UnNEci96L3JBT2ZGbmFMRS9wanVIYWFjRjMxRzNu?=
 =?utf-8?B?Yk04VkRWNGE3OEM2N254OWF1VGtzTmYzNEkxL0MrajYwQ2tzSGMyb2Q5S1o5?=
 =?utf-8?B?SkZya3h4ZzF4eUZhOTJkYVEvU1hHYVNocUo0TnRnQndLcG9wb2dzbXdnay83?=
 =?utf-8?B?WUd1ZjNjdGZEZHlPaWgzQ25BVFF3b3phd0xudFRJSnN4SXNqci9Xazh4N2I3?=
 =?utf-8?B?N24xcW9nbk9WRFVuRkJPc1hKYnFLY2tjYXJXbnVlUjFqcXFqMUoyMkFxQ2p4?=
 =?utf-8?B?K2N4NFZxM0JWdHUwYU1wVTdheTc4V2VZR0krYit5S1RnSGVzOXpkUUJsWlho?=
 =?utf-8?B?L3kvbmxReXd3TEpZYkx6eTJGSVdUMjUyT2dJSzYxWWVTcWhXb0I3UjBJQ0RF?=
 =?utf-8?B?UHY2YkFFSXZWbW5IVm9Xem8rT2hlMkpadjQ5V0RIUWxuWEFuMm5nZ0NhT1FB?=
 =?utf-8?B?YzhXMmlLcFV3L3psdlhxOEdweVRpWUM5Nk94TGdiL1Flbm4wM3kvcDZCMHFa?=
 =?utf-8?Q?+s99FiQb5MEZspLcpEY8NvcYU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b61379-d39f-47c6-9962-08dbf82fd843
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 20:54:21.3463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jsjs6M9BCMyGYfJJu/qT8WpHL/+USVuOcxRAYOX/cGWQXBJRZEC0U87HGDI+NpHW17lTd6jl8LrIha1hE/U7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662

On 12/6/2023 2:42 PM, Borislav Petkov wrote:
> On Mon, Oct 16, 2023 at 08:27:45AM -0500, Michael Roth wrote:
>> +	spin_lock(&snp_leaked_pages_list_lock);
>> +	while (npages--) {
>> +		/*
>> +		 * Reuse the page's buddy list for chaining into the leaked
>> +		 * pages list. This page should not be on a free list currently
>> +		 * and is also unsafe to be added to a free list.
>> +		 */
>> +		list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>> +		sev_dump_rmpentry(pfn);
>> +		pfn++;
>> +	}
>> +	spin_unlock(&snp_leaked_pages_list_lock);
>> +	atomic_long_inc(&snp_nr_leaked_pages);
> 
> How is this supposed to count?
> 
> You're leaking @npages as the function's parameter but are incrementing
> snp_nr_leaked_pages only once?
> 
> Just make it a bog-normal unsigned long and increment it inside the
> locked section.
> 
> Or do at the beginning of the function:
> 
> 	atomic_long_add(npages, &snp_nr_leaked_pages);
> 

Yes will fix accordingly by incrementing it inside the locked section.

Thanks,
Ashish

