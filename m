Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428FB3FE5F6
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhIAXHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:07:54 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:11296
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232406AbhIAXHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:07:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cR/fdN4e4w3+R/OgIfBji7ukotLMmL1ZsxjCJSsOIQYzQqD0Bqb7+pH95PGqTtd3jwu2PT2lKdKtYfmeGzTXJg2VegSdh8+TiQdknffjkCJEO6vwcwm6azVDHUCz/amsbnmASw0nVBTUyOK43Qxc5yzCJd6EFNz+dTkRGw35KVwYJcXASYcv/azoU9KJgDSIoHCs8x7NLEtJG5GE+thFBJQF7hsAcaHseQmQT74yi3rEtF+EYu5RWrvblrRvuJuH8ypjjE0D+H/1oi4Yz+4PFgh9Lpk8eRCnLKgQTSkBuwkge+GBgV/xq1ZQBrQe8EgP8IMzQnvPikx5RL3Qz/wqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOn9b0agE+qjYDBs6/lP0fmuYhqWX70pFrmvfF71wc8=;
 b=D38IJgkER0OA3GdsZ6Kn54HR9oIMK4BJ8QmSXLpFSsojuAfufHUqOZCSNmBkOcg8L3n3bh+IHmbHmfcDPlzr8lkh3pLHO4YUBPoEkiWvEvX4YgXih3RHFHfhPkxy7MHbC+/OyXR3qbb39X63W8a2C1S6AO7yRO18S0jEkb0iGIHY3O9cfNqm6mzrTTkUvUR/792thv7/fBHmuvu9iIyzQNEhJfZSIKTu+gBVCLT3gW+SQywdCSMZ0vkOY+z0LfNxpuJoOJK/aAIeGQQGlc16GdCpQt8ZQDHpqtn8hytXXTFqONl/RuWMwnQNO1D5o6GFfrbOlxNfQrqs9DUk2EtrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOn9b0agE+qjYDBs6/lP0fmuYhqWX70pFrmvfF71wc8=;
 b=0F8AfvO9Ij5L7LlGA1lMU6SeyPyISzt4yUXaNBCHusLByLT0VEgWovaOqOReDoOSd37P96lBECCf8w0YoeBe88hGmkzv80p/DqJWAP4o4xMttNPnMH4iaykDSXgJ0uQ2DxvG++tK61Hdl/rSOZZ7U0eooBsIzaHht+ym0OQHUbI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 1 Sep
 2021 23:06:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4457.025; Wed, 1 Sep 2021
 23:06:51 +0000
Subject: Re: [PATCH Part2 v5 17/45] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
To:     Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        tfanelli@redhat.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-18-brijesh.singh@amd.com>
 <2b07b160-48af-4682-1a4b-2716cd13fb65@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <922d1ed3-4b51-9cf4-4858-19b16e08badf@amd.com>
Date:   Wed, 1 Sep 2021 18:06:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <2b07b160-48af-4682-1a4b-2716cd13fb65@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0401CA0043.namprd04.prod.outlook.com
 (2603:10b6:803:2a::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0401CA0043.namprd04.prod.outlook.com (2603:10b6:803:2a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 23:06:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d23affc5-6201-4767-93b6-08d96d9d2e69
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB443073B76B07E16B51B12A27E5CD9@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dd5HGjVJ95rasiUM2DPL0pM5bgz1iOHTs5tyx46G5GPfO/Fd7URhyQAwztDyQ4quT1KZa1cbOJ5m0UMpH08i1lZI9qwfbjzxFdaxIbZRloC/dcemt00DtG6LcwGfwgP9Coh73QC0lBW4kaN+xPcEg7Eb483avr8E8y8PlrqiTjwOqqdRluxjU7p6/WU0UHMnuqJ+q9tJqgnWtdSmL/Y90KmoJKPcoA01KsS40hRuG8M/bNlIxRKoaUAQTZsOG5y4qk08Xd94gE4IVAX8S0nwNVfQ7Ccf6oq7K12djtmGgYX4ZDnGycgfg3rZbmDQ8CkRn1fR1bTKrELgvj/sEqeIaOQEZKxs8Z1Ftr5Chd+X1Umk4whlIBrxCRYGboOrjEFXJdvMfB8c9Cb1cKnAaL7XxexaXwp9fhgpkNhE2Rn6YvWC5q/r/cmMYp3wP4TtFyBpA9c1mGKgP8el+3PeE4f9/+BEZbl9WGd+WaR5COv+PZ4hm3P+chG0RorxKtMZz/HErUYmsAG9iTuEZr86tVZIBkZDXyYCHxB6nSgdDnIQrBlcXpQT0lYa0ETrgJhOWdaFcnfQHA1evwWodKSzoSitO5qLbi28QV3yq2RSaqR7E8C8ZDOGB2oWdZRBGILpgwC1A8TEwOj3NjBK6pS+ASCV2TS4cDMWEwSuJmXQKAQ575tvqlsetRRGhpeYkJUpDuUB9NbNGuigaYVJB7k4PK9xhkf8ZhzTmDDWcFwz0YKZdd9fb4FsL/kCe/77DRXcCzTB8vFTbXhYD8bCI9QXdrHH2FFDTKpxPQMJchvh017kQ1thtTlEqjOmQskjDuNYwq82rwoj9v55k1kAu0I1UlcRrpbzTYU0pNmlvzUmGhQtNH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(6486002)(186003)(956004)(6506007)(6512007)(66946007)(31696002)(45080400002)(966005)(66556008)(26005)(66476007)(478600001)(4326008)(8676002)(7406005)(2906002)(8936002)(83380400001)(52116002)(7416002)(54906003)(36756003)(86362001)(38100700002)(38350700002)(44832011)(5660300002)(316002)(53546011)(31686004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUJRVFlsYy9YU3AvdE9TSTAvY1pudzZ6c1FCWGsrckoyL0NSaEhNcDAyeCtn?=
 =?utf-8?B?TEdvL2ZFbjNjMDZNcVkvT1RTODhuMitxTnlCMVJyS1YyaEFTbjlJeUZVNlFI?=
 =?utf-8?B?N2RqMURnaGhHN2hvYkNpZDd3MU9uTm5sK0E1c0gxUmE4N2pPYVRKUU91MmVP?=
 =?utf-8?B?OS9ER3VaOFB3Y25MMmxEb1dVZHBlZ3ZFS004UFVaMmNMWGZFUUM4c3YrSDhV?=
 =?utf-8?B?cWpzUGxTTXZ6RHlGaUIwVWN2NmlQS3NiS0JSb2ZMc3hWdTNEN1dycGdzaWJE?=
 =?utf-8?B?MUtPOG4wcTdhYmRObFpLMWVIKzZZb2xXTlh3UUUva00wZUNHdGxLdnYzNXJT?=
 =?utf-8?B?OHg4ZEQ2MkErUkFrbytpR3RQMVJac1NkZ1VHQUFkOEVxOGJveEUyQk54b1NC?=
 =?utf-8?B?dXFIYTc1dFMrSzFxMHdwTkFzTFl1bjZGTXQvQlc2NnhCTkF5dEkvQVovdlRz?=
 =?utf-8?B?eE0zZGVrampXMUJ3MWZDMmhoUk1GZy9YcHZhYjJBVGV2RUJKZXZLcTNaYk12?=
 =?utf-8?B?RUVjSFU5Y0VHV0pJNWVQRTYwMHUveGhSQ2laNkRxYWw0V2NJWXVYYjA0K0NE?=
 =?utf-8?B?T3VlNUgyR1VPR2tKWm81TFRrdS80NU1ucjdFS1RIbHVQeVVUcUtmNnFpZ0or?=
 =?utf-8?B?QUZ2V0JEb2N5ZHFna3pvOVl2T0IvNk50TlFiRjJnOExHMUNkaVBBVjNPUHFi?=
 =?utf-8?B?Z1hxU1IzWkRvcnU1RFZnS2dhcUFyNi9FbUpMQWVySC8ranhTV3ZsaENkLzBR?=
 =?utf-8?B?SVZnR0xMZEM3eG5Hcy9TdHdYVUVSaklXeXpxeVRhdEhBWkN1dWg5bEZEdEg1?=
 =?utf-8?B?eXZKMFRjbjJhaEU5WXR0dDIwdmxZOWNkbnZqS21qcnhQdGhSZldCSisrK2lN?=
 =?utf-8?B?M0xGVk5HVzNPZnpUT1lKMjhveldLRUpoWVNRME5vVDM3Wnc3QUNwTGNEVWEv?=
 =?utf-8?B?cklzRFBlT2I5QWlnV2xkK3h0ajZjR3hkaDgwaG42dUVFZUpEUFNXWUdMU1No?=
 =?utf-8?B?K0N1M0Q4T3MzWmRXeWlibVlXUU1YOU9HRXdBaEJmbjRVSEdWVjN0cVk0OHZB?=
 =?utf-8?B?elR3d3B6d0xYMlVGdXE0aGl1eDd1M1J5aXAvcXEzZk1VTWdpRGJEcitVaG5S?=
 =?utf-8?B?Vy9jamw5cGpyQnpyL1IxT0FBVU8zWHl6QVRSdDFRK3BBY0FrMnBKUG1RRldJ?=
 =?utf-8?B?R0dTSlg3WXNuR2pJTGpCalB2RTluY3BaY09ZL2VLeDBMZUZxVWVSZGZmOXVG?=
 =?utf-8?B?Tk5tVHhLRDZ1L3JKTHRxc0JvNk01b0EwSzBFUExVMi9CVTBITUF4Z240SER1?=
 =?utf-8?B?NVVlSWdtcjdTYUU3dFA5T04vMStmU3AwbkVpS2VzQmFxVlR1ZFk3dDNSbkY4?=
 =?utf-8?B?RjVFMU9vWmhzdXcwRTkyOEZWTGc2YXZTaVc4OC9wMW5jTjBGbmFvNVl3OGQ5?=
 =?utf-8?B?VmJNZTE4cTMrNndDWEg1L1V6VE5vMENhQTFsMmIyU1FUSWJmVEZYdHQ2SUNL?=
 =?utf-8?B?bGFDcFNLK202QVpwaVJCYUZCdis5VndLY2pOeklWODMxZkQzcFpwejY0Nk5M?=
 =?utf-8?B?SXpWcUdFUFBwWXp4ejVhQTJodlB0aWFucGwzbGVneEIvUjh1Skdqa0I3dGNI?=
 =?utf-8?B?akpEQlg2TUVkWnZXa2hsa0tHVllsTmVsbE5jRmIrQlg4cmx6MHFVODNDdURv?=
 =?utf-8?B?Qk92VnoxNnVRY0NMRGkzd2NpeEdOKytlSmlkY3h6clRvSm9uZlB6Mzk5bHVD?=
 =?utf-8?Q?AGQXE1Yx0mlB8kEZd9lgPe8a+uQq6sL7zIWy6ZA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d23affc5-6201-4767-93b6-08d96d9d2e69
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 23:06:51.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2npwEIG6d56XkIEhEca+nwcsUUlgy/vxjOU57tpOun70TUfO9/D91UEX+97yLENNEzsBjANG2RozsvRCHl4FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/21 4:02 PM, Connor Kuehl wrote:
> On 8/20/21 10:58 AM, Brijesh Singh wrote:
>> +2.4 SNP_SET_EXT_CONFIG
>> +----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_ext_config
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
>> +reported TCB version in the attestation report. The command is similar to
>> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
>> +command also accepts an additional certificate blob defined in the GHCB
>> +specification.
>> +
>> +If the certs_address is zero, then previous certificate blob will deleted.
>> +For more information on the certificate blob layout, see the GHCB spec
>> +(extended guest request message).
> Hi Brijesh,
>
> Just to be clear, is the documentation you're referring to regarding the
> layout of the certificate blob specified on page 47 of the GHCB spec?
> More specifically, is it the `struct cert_table` on that page?

Yes that is correct.


>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F56421.pdf&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C62df2fe1cb384de88ed708d96d8bda20%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637661270135555480%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=V4S8atM%2BTlZ%2BiIlddRjpTNIx4yecGEoETuFVjeNWWNQ%3D&amp;reserved=0
>
> If so, where is the VCEK certificate layout documented?

You can get the VCEK from the KDS using the chip id. The certificate is
standard X.509.

thanks

>
> Connor
>
>> +/**
>> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
>> + *
>> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
>> + *		reported_tcb does not need to be updated.
>> + * @certs_address: address of extended guest request certificate chain or
>> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
>> + * @certs_len: length of the certs
>> + */
>> +struct sev_user_data_ext_snp_config {
>> +	__u64 config_address;		/* In */
>> +	__u64 certs_address;		/* In */
>> +	__u32 certs_len;		/* In */
>> +};
