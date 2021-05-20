Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF2338B5BD
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhETSGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 14:06:44 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:5953
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232837AbhETSGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 14:06:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHWgDA4kK90mEFXZJgFDnmbYX5n7APK1PLMDkmOzJnJl3IR3689Nff5A3+ajwBQMbcmk4Q0kabcFuL302D0cvUtgCVARu3qkWLSK9MbNhL/K2y3dqUYu2Cb/nF5luE4JGEDXJ9W+MG33LtKp9+Ha+J/vPCsg9aJ3+iImxHYvej3We150ITin03h2bOXnF65IZC2kSDtXZYtVDF/+OudpWZ6aaaLTwcbdx3FICpKhTNfyeDpY0aexEOxj8x7iDQ7ynDNlbturF6/EZAqNunaBVGRpammPmCh0ifBYyyCEZ8Gv+BtjHvn/VtpxGYRSX5RD47N/VlVqCyJbw1I2b/hKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqJ2GA4FGrMm3S0sgTJKKz6UXLoSbkjelpmc+8OvtJI=;
 b=jCXzwYGFsR9iXfi1LO74kLxzRwdYMhDjTrVXJyBTJ/NcS8KoYLB3LWfVleBg7cpPMHv1X0KlSvEWXcc+mORRRT/bVpjU+9R2K7jPskyt3XU0LXW4A6qul0Cpy62c6+5kdDvgc8ZxWxjEyVt8tzU7JFGH3H6+J527OLjv9B4pbaHrTc0LuWyWymGAIuh0Wwunu0PmLPXIzgahiOAGPFAAPbvXpZZi2/SxXuP7LkuQw0wRtqQOA9fFAnTi6tHXuwgHGP1FXO5QnYnITKk+wt55YR411I5pCVjhwX4oG+aJv2WRgYq6hS6wM2eqEaJTeA0Ngh7rfzUUAV2WnoPaixtg6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UqJ2GA4FGrMm3S0sgTJKKz6UXLoSbkjelpmc+8OvtJI=;
 b=FCdTr6cEAXKRHg5DQCdpLcgR64jw41lkmuoWpuVxuGtMEP5bsueLi0wab+hZAx1rs0Pip6YGoSBV4/I1i5P+vmtcYRgjOp6hk0/Mz+ReYOd3ZfTVRSst1KVd/2SGJcqvGpjdSkBk8Tm5eNuD2tfCXYA0uRF4AVLhux9MnvgWjFc=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 18:05:18 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 18:05:18 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 11/20] x86/compressed: Add helper for
 validating pages in the decompression stage
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-12-brijesh.singh@amd.com> <YKah5QInPK4+7xaC@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <921408d1-a399-7089-8647-f9617eb12919@amd.com>
Date:   Thu, 20 May 2021 13:05:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKah5QInPK4+7xaC@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0401CA0023.namprd04.prod.outlook.com
 (2603:10b6:803:21::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0023.namprd04.prod.outlook.com (2603:10b6:803:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 18:05:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 479dccb2-44c4-4a4d-fa2c-08d91bb9d348
X-MS-TrafficTypeDiagnostic: SN1PR12MB2414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2414CF14179BF2558DF5ABC8E52A9@SN1PR12MB2414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKDHN5/JjF4RCEIX+eKrDGKO5cEpxoxAeY93peRatFnvmVtbi68A0zAa1lJjkuUsjN0EnNMDPBx2eMiZSqpHtMSWfMa18Kqv9sg1TZDpHedu2STwmuSyiHTrh46OhSpZv8GKCDF6fay9ZaYxBDMFMHlcI1eTqRDu5G5LoDrr48HeCl3Cs9QoJu03csnmEyvxF62dUQSehSQNzhxVWQdzkwdzXhfPAUq6MrJilRYHNeIEAyBz+r6/C/tDUp2FdXKrxgUoNt9KrBeOWLuyUWBRuPPwO4A+KI6ahiskeNQgcMgsbyKAny30O3FcRLGdsuz0Y0TvvKg/8RQOoUb3vofIL+7/mqvIDWnk1H+8sAZRo5lOEC6oUob0gBpmQL83RJyBOFqcNSSJjay2nxGGn32+hZR72c06AGgRoR4dUqtyEBR40Qng7Mkip5ZCmhHHYNMFRv+BV5jxEs0c6tJ87HvOYOrmIG7W8Rj9/V0QcwZbL3hVP1QKOm5liEb4TplLrmmwIDbD7XXnwqYPRNP1cKy8OSYPEoM/MC+YItrdrkzRlSaIM4j2QAq2FR/z1j8X/lu3vbzO6G65BOvMx+qmXZgKa2U94mb+INj72dGwsdMALS+VaoOMONcuEnlNhyloE2HcmCsJgcKK61NTYFLc5HuH12citqL5mqE45iS4tZyQERe6QEwhqb7nQvUp3i6SUWc6X7fUcqojNmat4AE5TiS39i0SyBIXHozZOf9Ou9FWYqA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(7416002)(6486002)(478600001)(36756003)(316002)(6506007)(6916009)(53546011)(83380400001)(26005)(31686004)(5660300002)(52116002)(44832011)(16526019)(6512007)(4326008)(38350700002)(8936002)(38100700002)(66476007)(66556008)(8676002)(31696002)(2906002)(956004)(86362001)(186003)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NzJJeHFBeS9YTzB1NWNwMzdJN2F0MldneDFVN0Nab0lZeGQxNld0S1laSDlm?=
 =?utf-8?B?cEo0TWJUYTJMWXI5ZlFtdHNkYmY1WkRFdGkrWVZLdVJ4Q1JxUnFaMHpBbmFw?=
 =?utf-8?B?aGtmQjBUZkJvaW9xaVF4YkJBRi9VYzh0eXhhSTNTYkJkd1htTkdpWUg0UXVx?=
 =?utf-8?B?MFcvRUJRcU5VMzBEcC9XekVuOUFjVG1JUHdlcUFEMjJHclo2cUsxTlM1SjRV?=
 =?utf-8?B?bUMzRVNUbEZ5clhCdlpnUFZrSytBajA5ZDhTK3FuWCtLN3RPNzFrSnBSTHp3?=
 =?utf-8?B?UDhNR0MwSjNDTFpaM04ySlVRNXM1cmJNd05ydDlDMUxxOG00SE5aTnRiWVNV?=
 =?utf-8?B?ajVvNXF6VTh5b0p6Q2xmOWtaUThaaHZBREhNQkk1aHpMUFE5Z1o3Z29Qa04v?=
 =?utf-8?B?NnN4NGJrdWNodWdmNXZLRHo4TkVHTmxlVW1OSFB0VytXUVM2Zm44T1cyUkQx?=
 =?utf-8?B?Yk9RTUhPK1NITDhsUTRsbU9TVm1qazQyWCtrb1dqSVZYb2wwYUh5WFdvU0s5?=
 =?utf-8?B?VEN5dFBnUEJvZXhUdGxBRmliSTJNbDNoalNwbW9FRlp0em1uSGRjemI5MVlI?=
 =?utf-8?B?aTlMc1JNd2JRVXNnSjJqOFY1TDdKUFF4SGhyTjJEY0FKL3EwTXhibmsydU5G?=
 =?utf-8?B?M1pXVmlhZWo2V3ZveFdLY3ZnRHpmcEprM1BBYi9VS0E5NU4ybkhIZ05qSVhW?=
 =?utf-8?B?L3dZOXVWMmpkUmNDSjBJNVFQM2svYWQ3TUVZZnBONXE0SU12bTNQdEJURDZr?=
 =?utf-8?B?T1VPZmwyOGJVTDUrZ0VjZHdwL0F2VDZIcGRPTWxnQUlwaWFNUGd2eTV3NUN4?=
 =?utf-8?B?aXVwNVpaS1NpeExuNjNvN3dIRVJKNURKRlg0VElGeW9Ka1kyVE9aNnVnaTBG?=
 =?utf-8?B?RFZEV1pWMG5aczRIZ0dHQzhMWkh6UHBwWnZucVExSmdRMG1sWFlJbTU5OHNF?=
 =?utf-8?B?VjlDUlRBcWhzMGVDS2JpdkVHQjVjbDUzK3BXKzFPTnlsT1NBbjlIeUt0ZGll?=
 =?utf-8?B?bGZzWnlyUWtoMy9GZWlLVDh0V1BqbjNOa2NCNmdtS3pLSTVyY2RZK2lhaXY2?=
 =?utf-8?B?aFpkaFlrVXpVTVdNdUxMWGZjblVuQXorVEk4WDY5Mkg1bFREWmE4eFJmRWgw?=
 =?utf-8?B?cWxZWnE2NzlPL2wwSXE1TjlnRUVDeVozM3J6Q1RXQlFhN1lsRGoyRTRJWFFF?=
 =?utf-8?B?QWRqOUR6aVJJRkgyekppK1Bkc1BrVkt0SFc5VnVuRTRVRXc4a1dGcGY1TEEv?=
 =?utf-8?B?UUdMcThPbmMwdXVjb04vSkliN1YzcGI5ZXpJMTdsUWtJMnhIeTIxTWtxbVky?=
 =?utf-8?B?MHIyelZFWk9pOE9PcEgvY29Tby96TVBPMjZPS0ljN3BsdVZBSHVFdDBLY1M4?=
 =?utf-8?B?QU94TmdsZkJVN1E2UmV2c1BBOGVWZEVUOWlpMW83S24yUXc0OW1LNDBQY1hU?=
 =?utf-8?B?VkVtVzV3b0cwQjlMc0E0NVBSckh4eWo5UU9HZTRQd1JFcUllZ2dTTVgzV0Zs?=
 =?utf-8?B?V1laOUo2SG9lalEyaDJoZ0R5b0V4alBXQlJEcHJKallVb2ttY0ZyODhiK0VE?=
 =?utf-8?B?NTVsSmdZSXdSQys2UFFFMHBXTWppc0gxaXV3RUNGWldWbWhRbzhMQXY5ZUR2?=
 =?utf-8?B?TGw5OHdmKy9yNGZkZU1QL1JMTlVqZktlRnNrYzJQSFhNUDlJMk1wTGZDeFVs?=
 =?utf-8?B?aXZQNXBLK3kxRndTQzJHQy9IVHVMMitVNUNXb0NJdjllcjdyS1p6ZTFqc005?=
 =?utf-8?Q?QrV4VhBGtdddqtNcqkP9uOHTgnRJDjVrhLS+QZM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479dccb2-44c4-4a4d-fa2c-08d91bb9d348
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 18:05:17.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QExKG7EcaIa/raVooIsSfez6zCKg5ikhByPCt8dpAkOkfV9Tl8n+g/aivuoDTZnCxs4UD/5mGVqeQQbGImu8ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2414
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 12:52 PM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:07AM -0500, Brijesh Singh wrote:
>> @@ -278,12 +279,28 @@ static int set_clr_page_flags(struct x86_mapping_info *info,
>>  	if ((set | clr) & _PAGE_ENC)
>>  		clflush_page(address);
>>  
>> +	/*
>> +	 * If the encryption attribute is being cleared, then change the page state to
>> +	 * shared in the RMP entry. Change of the page state must be done before the
>> +	 * PTE updates.
>> +	 */
>> +	if (clr & _PAGE_ENC)
>> +		snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);
> From the last review:
>
> The statement above already looks at clr - just merge the two together.

Maybe I am missing something, the statement above was executed for
either set or clr but the page shared need to happen only for clr. So,
from code readability point I kept it outside of that if().

Otherwise we may have to do something like.

...

if ((set | clr) & _PAGE_EN) {

   if (clr)

    snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);

  }

I am okay with above is the preferred approach.

>
>> @@ -136,6 +137,55 @@ static inline bool sev_snp_enabled(void)
>>  	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;
>>  }
>>  
>> +static void snp_page_state_change(unsigned long paddr, int op)
> From the last review:
>
> no need for too many prefixes on static functions - just call this one
> __change_page_state() or so, so that the below one can be called...

I guess I still kept the "snp" prefix because vmgexit was named that
way. Based on your feedback, I am droping the "SNP" prefix from the
VMGEXIT and will update it as well.


>> +{
>> +	u64 val;
>> +
>> +	if (!sev_snp_enabled())
>> +		return;
>> +
>> +	/*
>> +	 * If the page is getting changed from private to shard then invalidate the page
> 							shared
>
> And you can write this a lot shorter
>
> 	* If private -> shared, ...
>
>> +	 * before requesting the state change in the RMP table.
>> +	 */
>> +	if ((op == SNP_PAGE_STATE_SHARED) && pvalidate(paddr, RMP_PG_SIZE_4K, 0))
>> +		goto e_pvalidate;
>> +
>> +	/* Issue VMGEXIT to change the page state in RMP table. */
>> +	sev_es_wr_ghcb_msr(GHCB_MSR_PSC_REQ_GFN(paddr >> PAGE_SHIFT, op));
>> +	VMGEXIT();
>> +
>> +	/* Read the response of the VMGEXIT. */
>> +	val = sev_es_rd_ghcb_msr();
>> +	if ((GHCB_RESP_CODE(val) != GHCB_MSR_PSC_RESP) || GHCB_MSR_PSC_RESP_VAL(val))
>> +		goto e_psc;
> That label is used only once - just do the termination here directly and
> remove it.

Noted.


>
> Thx.
>
