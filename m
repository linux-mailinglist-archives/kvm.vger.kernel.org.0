Return-Path: <kvm+bounces-369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A377DEC99
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52B50B2122F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E288522A;
	Thu,  2 Nov 2023 05:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZjX6pCaa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCDE187A
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:53:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6F8128;
	Wed,  1 Nov 2023 22:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3jk4MyS7OVXlpXb+WhHV6cyvwyBx1wF+t6Tq50OR/GJAkhv+DBv7E6jhBgPmZj+XBoH1JQnOJBO4RbMTjVvNEfhohLsqLB5WAQMXNn3Yw5fdq8Osj7qOTQzZwE9MNmKuffVCegBim9B+XQ4VqRlsT5E19JCox24k4mrifDcJxEJHjzuzp2jJv5dFycrKoLnZDF6TpNQ8mjkKdfqNG7HiqlGjq4H0rWGerE8tS5uvWXPBZkbPYXkF9BWaFe/+zR1hmFQ/tudIDNb6SkM4A7iXyK5MgTgLQ1ued31P+Fwa9yBs6+UPEfQjC88WUW/kkKrP3FiS6fPf3mza9av18K0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8S6MYEKz0fmMWBxA19a/KtbeudfMu5ToMEfqLh8fRvg=;
 b=Lva2U+jdtt74H6ktpajKru8erFj8Xlpibj7OTIcVWKhoj/tlVQDulZYSiIkHHrZqNgI6SCDHpZd2w35L8keJcjNf6e72cuqEmKF9GLtsWccZlPqW+MbQZXsKDOyTKLrAITEzalRuZPzy8fiyGK77+u5CeJxFrsTA1PQqy7E1kdfuKRYgL+HYYcUwZMQmFFRIvz676MbBNViXtSBcso7uXFG9j4LtaGkx7T5TN8QclUJptYJ/FzdocfDTa0dmYlznZPaib0AcDNSnyiPcUea50lCkMY7ThTUF72SlUaYvw3qN8MbN1gs/BFeVJlsBzmYW0VUjbZ6UrHcZdzMFX4dbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8S6MYEKz0fmMWBxA19a/KtbeudfMu5ToMEfqLh8fRvg=;
 b=ZjX6pCaaBYCjB5bQRmAgQIDT+BjZAd+6soQWundfmXuANqjopDMd/nzOVTc9jOnYras5YFTYp0ANmgGKWBbl1isjE5B4h5JP7P+JU0Ey1ZtCh/sMms0jpI/KZs9Cx1K/nR4sgg+X52TkB5Sd/h6g8nTXBrqRoLZVQq7tC7iSdcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5781.namprd12.prod.outlook.com (2603:10b6:510:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Thu, 2 Nov
 2023 05:53:46 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:53:45 +0000
Message-ID: <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
Date: Thu, 2 Nov 2023 11:23:34 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0077.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: 85fa8554-5af1-4611-9585-08dbdb681393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gs6tgKtDx4jawT2to27Me4UHEGLZOJ9B5yXfRFlBhUmW6iUaWul2XZuhjxuSPBWg+SZKbp4Z+W8ze3RRdsnKzfbJXc6bd8q5e3SwcGLZvvKuGurV+i1EQoe1jui3uRRF4raskm3oleKF5hrTqraUrI5G0VBvhLgrj2HtgiWpbK39PgyQzy0TjJc6XLSmVBGb/vhKM/kULOCltnaccxy29vSwRar8RVlyoU+U3AbkCGCkyqiTC7XA9RPvV/mvKNNoqb+CIF6bj/FEbOjroF+mXWnRT94UV4TObd/goldlyEz4XBbm35eTqdjZVJpKjx4j0W0ESLWiXHziFlPdkgfGRIGHZcbyu22dX1D7nMMkkSJbA8YIs7lyiZLLtpI+RlPNF/6X6zxdslSg1fRaWWcGwv/toukGQr4DdKQTkC+dp2lcKhw9vDskXkfLvxP4+HbuhNzlUP97K1H2NIRBsaKUWwXsqFc/i37xAdBLKtOAXoECSILC5Ri7fcj5/Oj8WNO0WBvI47lP5hTkVl5eGVLWBPhe38qAqrksF7jExtES6hkeQ3g8dKzPgNYVVDnEvBQ1iYXOZIuFIjaLOZ++zbY9RF3yTp3inWJQuZGHo4lnXrsOURfExLG/5YzetjcKKPfq1uTVjbSiJUpdJKSHmG6DJQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(396003)(39860400002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(31696002)(31686004)(6512007)(66946007)(66476007)(966005)(53546011)(6486002)(66556008)(26005)(8676002)(83380400001)(8936002)(36756003)(4326008)(6506007)(316002)(110136005)(2616005)(478600001)(6666004)(4744005)(5660300002)(7416002)(3450700001)(2906002)(41300700001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDZkY2tvaGdIOE9udVF4cCt1U0VqV2RvS0JRMXZzT1RSalFHK0RVUnd6aGZU?=
 =?utf-8?B?N2FIRXNEMGRweTNWNWRqUmcvZzBWVG1aUzZCTmpXbGYweTlveVFiZHRmaWdU?=
 =?utf-8?B?djkxQVcyZmo2eGVJRGJFNllvS01GdTYvYUU5aVdlL05TZVRna295RzJ1OHNT?=
 =?utf-8?B?RzRnL1RCZGZIUzVSd1lZMTVzRXV5RUsxQk85b1kzOFVVVGZiMVFGRkgrb1NN?=
 =?utf-8?B?OTQwTXB1VGhsWU4wUjRNZzZselA2aENsQ0c2RzNwUFc2OWVRRmZXWVJDcjdy?=
 =?utf-8?B?QnJnS3l2UWVNbDFwQkl2ZHRlbXFaekx1d2tMSE8vRThZWldZQXh1SXkyZ043?=
 =?utf-8?B?bUpBSlRFK2VSNHNncGRoTUlCalBmWjg4RS9vRk9QeTdIOGxCVndtZm9oR1o3?=
 =?utf-8?B?R0pXVGNFeEpITUpMSms5MndJWmkwK1crUmZ2d1VPNXhkN2FTbDZubUZIWDRa?=
 =?utf-8?B?bDdhaFFWNEcvcUZiNll6a1lQNDRwT2lOSERLVDhKZHBwN1A4bUVPa0tNekI4?=
 =?utf-8?B?ZEtTcGtFOHVzc2J3OWhOTE9BekFqK01TUklwNEFiMDJQcXhLT2dSOTM0Y24z?=
 =?utf-8?B?aW1HajYwYmtYVHZzVXRQR2VuT1lTbk5FT0pvQUw1NHFsM2ZvR0puVGg2d1dk?=
 =?utf-8?B?ZlJrcHZrL3FNRzY5Z0ZWSWt0c1pXNGxWTW44VXAzVnNMeXJRR21kRWFmODdn?=
 =?utf-8?B?cmR0OWVLcDlocWovZDd6QzdFSGdQbzhqZk8yYkR1VXc2ZWZGZ1Fhb1RMalFi?=
 =?utf-8?B?RmZQU3F2OGE4UkJwc0kwdjNFbEJUR0l0RTlQR1pmWmlsSVd2YWpKMW9SR0Zp?=
 =?utf-8?B?YkpjNi9vemNSTk9XVVZjQkd5UW9NZkhTaFFjNEU5alEyWkRGRHlKVGp0WDJM?=
 =?utf-8?B?SHJKM0dGcFBuQW5idG5yK09mMndXQjBudXlYcHgvOXQxcSt3dHFJUEJMV3Jm?=
 =?utf-8?B?d0ozYURGbTdYa2lUS2ZMTzMyYWtoNzlQZ1czZ2tWU25sTjNjUVQ4czJyZ3BC?=
 =?utf-8?B?S05jbXgwd05xdTlpK1dOajM0ZmJ6eE9wcFcwb096QmQ0am1SZXNiNGhDdGg5?=
 =?utf-8?B?RzRqMUxjbjRQMHM5SW8xZkcvbWxEVFBSZnJERWdYQmZUNUZnSTJzeUE5UU1J?=
 =?utf-8?B?QXZYNjFYd0E4Z3JJaUpUTTJYN2g1UkRGb1phWnNCcVJsdDdQbHRuNysxMXdM?=
 =?utf-8?B?UDdUV1N0SmpTTWZFdExnZ0NDbkxCZUpvMmNtMkpJU2hsTytaeXIyY0xld0ZW?=
 =?utf-8?B?TDE0OU9QbjRJenRFdkdaOGl0eTFaSmhFdzkwTUhLVm9zdkZXcVJhUTBxaGRj?=
 =?utf-8?B?Nk9DdXMzZXJSS2JVVEp5R2tsNlE3VWVOYWpVM3huUlNtZ3BzcEZsWEFHY0RJ?=
 =?utf-8?B?VURvR2dQalphZFd3VjRWQm9wYysrNURoeVNUVkV5MXJrVG9nY01OUmtGMUEw?=
 =?utf-8?B?bTNZQ0ppclZ5b1BJKzZNMys4c0FYZ2hQMXl0dGI1WDVJMDRjbVdlTnE0K0U0?=
 =?utf-8?B?Mkc1dHlXSmFUV0NhNFZENmV6c3hud1lybkFydzBGOHQ3YUtvdElISXpGR24x?=
 =?utf-8?B?VVBjN1VscmRyQjNnRWd3QWhrMVhyNHI0R0VaR3NuL3I1SDhTZkYyeEl5enJB?=
 =?utf-8?B?QmxrWnp1NzdsN0xiSFZvNi9kUzBCQWczR21HMDJsN3p0SnZ2WldSeHAySzNC?=
 =?utf-8?B?RWFSMTZCakxMcmtvM2JKL2piNlR4em96T2lrdmJaU1pjZGY4bVgvY1hndGov?=
 =?utf-8?B?YzlTMkJGSTFNa1Ftdko0SU1ZUDMyZGlOQ3hnbTJzSHJPbGpWcDEvaDZHbDN4?=
 =?utf-8?B?eWFsK3hJRjF5cjB6V2k0d2VTSTVjYTFZNjNSL1NKUlZMUDVqVkhQTU1MQnBq?=
 =?utf-8?B?OTBkeWw4eng2WW1zeXJRVEN5dWV0TytYWjZOWHdFY0Zpa1RXQTNKSlNzUFpl?=
 =?utf-8?B?K0k1ODU2Rm1HSjFCWURBVk5EK0phUDM3N1h6UWpsZjdiRGFaMW1zT1Y4QldY?=
 =?utf-8?B?b1hkcWF4dDMxVlY0NEt0dG0rVXhpL1VLWUp5QXFocE9mdU4vYjE3VVlHRHMz?=
 =?utf-8?B?d3F3T3UzVFdKQWw3UVV0ZytNNHRSdGhhbTlYQ2JDU1lKdFIwZnU4YWtXV2Rx?=
 =?utf-8?Q?AJqkvHvi4I6v1L930x3+I2d+i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85fa8554-5af1-4611-9585-08dbdb681393
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:53:45.7996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrEDvplQfcJbZjs64OTyFh0/5qpuDQuSB0gqtRkOcz8ooF4+fj4Vy9R8Uma+aNLDwZudwHOFBI7yIgO4wWGiMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5781

On 10/30/2023 10:48 PM, Dave Hansen wrote:
> On 10/29/23 23:36, Nikunj A Dadhania wrote:
> ...
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index 15f97c0abc9d..b0a8546d3703 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
>>  			tsc_clocksource_reliable = 1;
>>  	}
>>  #endif
>> -	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
>> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>  		tsc_clocksource_reliable = 1;
> 
> Why can't you just set X86_FEATURE_TSC_RELIABLE?

Last time when I tried, I had removed my kvmclock changes and I had set the X86_FEATURE_TSC_RELIABLE similar to Kirill's patch[1], this did not select the SecureTSC.

Let me try setting X86_FEATURE_TSC_RELIABLE and retaining my patch for skipping kvmclock.

Regards
Nikunj

1: https://lore.kernel.org/lkml/20230808162320.27297-1-kirill.shutemov@linux.intel.com/

