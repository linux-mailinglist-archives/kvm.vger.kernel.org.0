Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083D9349425
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 15:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCYOda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 10:33:30 -0400
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:2048
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231483AbhCYOdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 10:33:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJNYdywfJGrGoyhisFqWrj8zEVyrbFftcMXbd4PnLHLcbmIWpSy3347MkWWYgUswiZU35ULh+JMYrB4gofbsKNwMm7eM4cdmeSkM4cUDWhbInceY1E1zr6mTVirRCis2yZwCnnEfhuIrqYBXh1I4/nTdlB8QxQZ3SU+bHLVPy5JrQw5xwcRNP42elcQEMvc0I0Cu4MEfwC1FfS+y3FOFCHQpede1asNqxQGddJCK6JF38UnoXB69LKbONA2LliLms7doMZ7B2t8FiE7R3629ATCbPSb6cD+t5blULgNprbKgsBKAgBSCPrXqJPpQBsRBjR+rfE3z3zX6b84B0qVx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cpI8+tw47fmeb5CoGD3MFJ89QhNYJsMj32MXz+FNjk=;
 b=C7Fo3XFTNvZ2qp97RmcsBIpEt/HrP3pSfkPPDeI35f0CkGtR/LSSQhAd4llHvL/F1gMIifQ8RF9j9ltsLvxskldYeY6Qz2HjuuqrD9MdAaS2FrbwGyqO8i2c2zNeyEvJn1Cp1WqDK0NHhfBaTxvtGFK9DOvRyxJLq5Ygji8VW1e33onvuRyHC5Kvm27ANZvlF4MrllZIZUgEseNsgyLFOKBEKFzT+/ZZFjaQM6ValBnFDZ5F+09Yjxky0i7vCbdX+vLXycX+sfZ5efhtjyUQWJzgZBX/H9Bjm7LBidU7dx6rotW+KVcFN/DKwZZq7IpXuBDQvZeBcqrhaW01HpCXtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cpI8+tw47fmeb5CoGD3MFJ89QhNYJsMj32MXz+FNjk=;
 b=49D+xJaB9cth+GYFy1PSNj2MwtgD/ZOtkBpMCf0IN20XQYJ+ROpAGlrKBRcS+ve+JJ8GdPPyZDodNN0dsWnwcJwSHWs94+XO8HJI3GWgjQVmIFfZGNhU+UawWGy0cycDgpsXq+NYPm3ovZgDyfJuON9Xp+HAwkw5/+ughZZxbXQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 14:33:02 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 14:33:02 +0000
Cc:     brijesh.singh@amd.com, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 05/30] x86: define RMP violation #PF error code
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-6-brijesh.singh@amd.com>
 <1fa50927-9e5a-fb23-3763-490310df12a9@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <3a599008-1f16-238e-23fa-7eb2e3cc5179@amd.com>
Date:   Thu, 25 Mar 2021 09:32:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <1fa50927-9e5a-fb23-3763-490310df12a9@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0056.namprd02.prod.outlook.com
 (2603:10b6:803:20::18) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0056.namprd02.prod.outlook.com (2603:10b6:803:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 14:33:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be7122e1-6544-4695-a2ec-08d8ef9ae4f8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45124AF78C059F0B21064528E5629@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3r45O4A5eD5k6J64DmcpFK7aQV6G1B9bhqFCRcukMYlc2oMh4QcuErH3gLQ4fs2D3P6EPORaZDHIzxFsOULpr5UtuTFyWh6Ltlzg9rUYbCE0BeUZueMY0Q/a1yofu4InQ1fb5Z02eshvxGBEhxYodmLaRq0cQwXKOOn/327etFa/Qw6EvTFFuY0NEpy9Ve3flmyet3Nc/Ieo6uWEwyXGmaQwem1GkWnm7tFdOzUru7wbzMID4JcuuCbhe8SRwicneNpSk8QIbDwcsIvNac3LSP0kwsbDzkcN0gE40oEJi2ZkijpbhFM/sBebXOLpOwEp4m4FHFpVjEE4S2htdi89YbqNGdU2Aov+HxulL0ZJidWSRTs+5s5kmRNBwq3Lh/M1jVGTTu/WD9PfxDacGvihXONhdo4oqoHMi2tSknjMVTF7fkdlL9iKWCQEfqymkOF57jVKxdiYAD8YLo38leWVziCBt8fQny9YfW7klYjafL/v7A58/E8t3Kh8cmPtWduHjNkOkHvFs1figt1+cCA20xAK27OgBPmbCZlbXhiUW5Q9EunLqjjVjCEjpinl+8dJx5vPrLpxbRFUgp3N4fsuSM4AUwXc6jJNYqlQMq3aYK8X67A1049zajs57wnqZHXGshPhsMiTB0YkeYKWFdCKj4Qtq3hDEoyqZTVjz0I5D7H1YOR3xJcDHcCJM4xxmlzrJ7ATw+4z/BYowFq56cEDYr/+T9N8DcH+AmKKQxP2hA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(8936002)(54906003)(7416002)(31686004)(83380400001)(2616005)(186003)(8676002)(26005)(16526019)(956004)(36756003)(4326008)(44832011)(6486002)(2906002)(52116002)(5660300002)(66476007)(53546011)(66946007)(31696002)(38100700001)(86362001)(316002)(6512007)(478600001)(6506007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a256RnFKZmNvbkkyNmJxUGtvZHdLZHcxTExEUDhiMXZaVkRZeWEvMitTS3dI?=
 =?utf-8?B?RXpQYjNJQnlWZExaanRZSEs2WjAzdkRGZVlJVVBXZXJ4bVR4bW1WMkplTTd0?=
 =?utf-8?B?Q3V3YVJoU3FjRlFiY1JOMFl0cWthUFN4UHpqcHkrc2ozNGtnY3NLM2FiTG9n?=
 =?utf-8?B?WW5YZDZUTEVXLzNRZm1wNWI1SUpJNlIwNDRxT2FIV0dtOHFkUU1yVTBHS002?=
 =?utf-8?B?OEpuMW5kTjFzMEd0ckpUb0lXOHlyUmN3SHZsM0dGTGhBQkNteUI5amx0Y3Zr?=
 =?utf-8?B?bjliMitwa2VuLzVKMDlmNytrQjRHTWtUakR6czlOMW9pUUFzdzVTRUFnaGdM?=
 =?utf-8?B?NVhEMVg0TGE3QndVQzRrMVpxbWt3QnhiS283OEtMeHhWUE5BeC9uamd0dzZk?=
 =?utf-8?B?cEh3dnZBaUpqRmxGZEdmbmZlS3hWNzRDN1hnYUNwQjRxdkp2M1lOZk9RbWox?=
 =?utf-8?B?d3VIU1VYeWhRaDRUTDdjWEZoYUdXbVlLQ1JjM3ZRU2Q0dzV5bmJVeDNiZjlG?=
 =?utf-8?B?QVRaL1JhUTkzbWc2TmFiZ0N2WkluQ0pHclZnWGpsdk5IMU9vZWN3ZHJCaCsv?=
 =?utf-8?B?L1FVakdma2h3MnJidEJVN1R2bDJxclYwSEY5NEVpZnd3TGtqVmF2N1VBM0ky?=
 =?utf-8?B?MXlSeGg2VkwyZVZxSitRckF1Z2JrS2tLZ1gyQ3lOK0pOL1ZuNlJNSTNhcEJL?=
 =?utf-8?B?aGJUZWxTdmdjYm1ZQjFXVjZuL2g4b1l6MzRmU01maVlwUVNTUmo5dzEwYVNC?=
 =?utf-8?B?ckZvTmduT2hZYmd3Umk4Ui94RmZKenhDdFI5WmJhUWJ6MG5rSDlnZHpjS1Za?=
 =?utf-8?B?NlZucnh2QmpOemlhNzdwbi83eHFNcFJJVU9XY1RhOUtkUXN3NVgwR1JSaGxh?=
 =?utf-8?B?M1RHd1B0Vm5FdEtPZTQ3R2NXQWN2RHFhbmxvbE9SQjI4ajRtUFlpWUxuOXNG?=
 =?utf-8?B?MTFsOEgxTnNtY2pqUEdld21QUjdGc3JZTCtMNzBWZU81eGY3NUgyd3NUeStr?=
 =?utf-8?B?Ym5WQm5rMjIzMU90MStkVjM1Z2dyNldvWjAxdTZ2NFAwVG15MGRRdGllaFll?=
 =?utf-8?B?NXJwTm1KU3N6R0VsMlZDUndqaW5pM281bTlpbm93aG9EbWE2VzBzSUNvd29S?=
 =?utf-8?B?emdnSFNmT1NHUURoZkFYNDBjZG8ySnV0MGx3VlUvZnptak1WUEtCYzNpblBv?=
 =?utf-8?B?aFlPUWpkTS9Pc0ZsR2t5bkprYTJKKzR0QWRrMG1jMWgwMEQ4MVJMaEpQZFQz?=
 =?utf-8?B?eGRrZ2NyQVNsSEh3eG1HL3F5dk1DelpyTm5LSlZtbHhYRGJGelQ5ek9DL2s2?=
 =?utf-8?B?TEVpM09vZ3RZVDQ4VDlLdjFtcjBEV2orYzZ3RDUxNVp2SGtGVmxodDB3TDZN?=
 =?utf-8?B?c01UTm96cXR1cHBYU055V3ptVmE1cFNOREI0RkY2NmhQSS9yMU1QZjBYd3Fw?=
 =?utf-8?B?c2gxOFdjc1pqc0wxUkxnNDd0WXo2QXFxUGd0cFljRlVyWUNTdERINGhFd3BZ?=
 =?utf-8?B?clgxSFpmWU9FaVhqN1hvRXpHNHlQN3VYRE1jVU5QdExlTWhsWmZZVzFoODRz?=
 =?utf-8?B?WC9YUHlaZi96ejNJTVdCQnVVWnU0RXY4VnkyMmRXcmxhYWpiUGJhcG45YlB2?=
 =?utf-8?B?cXg4TWY0djVnZEE2b2srTlRXYjY4UmlhWU1vVEllc3J3Q05McXU5MUNVTWx6?=
 =?utf-8?B?WXlZY1d0bWtNc0xTS3ZBNytuV2IxTDh0TWNHWG5INWZVVkVDcGxUQXBRZkF2?=
 =?utf-8?Q?Tw5U+cbd+NqUStO9NJVacpVsvM1JhWiW+oohejq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7122e1-6544-4695-a2ec-08d8ef9ae4f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:33:02.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IC/0cgNhSHOwfEXiIwWhXK8xIxdKmOqoA6K3S7vdISHGzLSiTdK+9/uHo7ZyhW9EXzgBBjKuGKs6eA1fuHCrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/21 1:03 PM, Dave Hansen wrote:
>> diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
>> index 10b1de500ab1..107f9d947e8d 100644
>> --- a/arch/x86/include/asm/trap_pf.h
>> +++ b/arch/x86/include/asm/trap_pf.h
>> @@ -12,6 +12,7 @@
>>   *   bit 4 ==				1: fault was an instruction fetch
>>   *   bit 5 ==				1: protection keys block access
>>   *   bit 15 ==				1: SGX MMU page-fault
>> + *   bit 31 ==				1: fault was an RMP violation
>>   */
>>  enum x86_pf_error_code {
>>  	X86_PF_PROT	=		1 << 0,
>> @@ -21,6 +22,7 @@ enum x86_pf_error_code {
>>  	X86_PF_INSTR	=		1 << 4,
>>  	X86_PF_PK	=		1 << 5,
>>  	X86_PF_SGX	=		1 << 15,
>> +	X86_PF_RMP	=		1ull << 31,
>>  };
> Man, I hope AMD and Intel are talking to each other about these bits.  :)
>
> Either way, this is hitting the limits of what I know about how enums
> are implemented.  I had internalized that they are just an 'int', but
> that doesn't seem quite right.  It sounds like they must be implemented
> using *an* integer type, but not necessarily 'int' itself.
>
> Either way, '1<<31' doesn't fit in a 32-bit signed int.  But, gcc at
> least doesn't seem to blow the enum up into a 64-bit type, which is nice.
>
> Could we at least start declaring these with BIT()?


Sure, I can bit the BIT() macro to define the bits. Do you want me to
update all of the fault codes to use BIT() or just the one I am adding
in this patch ?


