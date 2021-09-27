Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B67341986C
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhI0QDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 12:03:22 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:63809
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235231AbhI0QDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 12:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkqZbbyWPUNiv3JvfhD/iCIaFEBzudgraEFY8KVD1g70ruqmRBYWyYnFD8JCERsBJIxBmXc2mmBnPn5uKz/bEtQ06LD/5a51vpXL1v5FdibHqJkdrI8z6WXDESS4AfaBD6ajDFV+HIPUWGbR8IdXgFFyo35iUgs3zz80zIfjh1GgQ6gUUqUe5ocazUCTSylLtvE+7/Ky6wE0NmUjHq4Cm+uANEHObi+cwBkj3493QSAMy1BsBiVLUilmvHsRWkO0/NJr75OdFEplaOXl8tdeBn5+RfKivbUe1sqJ76WH13zgMHfGJkoFBFQpn2EIljws08I7sG5vFOGeq3D1QptGnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wB2s1NDOuWnkZbKPGJcy0UX/gvd+6YlKM0n2ib5dkyg=;
 b=bpnYrkmbArvvJvxtcr85GxpHSzGy1g8I3WI8j/Fnl0V36CfW7zttc7/swPKdUvUgaKOL1FKfuOmUQEC9MNj32GS3z0Z8oi66PalFoAMZD4ILYZnOIewk4GLp732pbAvimYZysyc9CrKfqMJ+ncoxoE5BVIBSDD/i3VJwl8uRInqhKdPGSE7kxwlDq1JvjOOC0gF5aVUD7clK1UnaawlzmfEyajuHEeJJIlUF2EGH01rX647Vhlw+5RmynQJi9Urn7hwDvyWqqIKPhjeCDLyxDQUez4ZX7dXeqA5ccV0D7uexhXlV++4bE+IHq7cVVPY7xMWpIXxNn6sXSemmkHyuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wB2s1NDOuWnkZbKPGJcy0UX/gvd+6YlKM0n2ib5dkyg=;
 b=dT44VeGfTaClXtMvLc/Nd1s/9Q87nB8u+7JPNi5oislyQgeDMpLtgC/iRhPTBT6Qxx/Npj3ihjE6VweyJDQB3czUkzFPblEw/jV9n5p8IOGxmfbC5W+v1RjE3j0ytB3g4TBBlwKNtHtKkAdkZNPpvX7yBc0plOHButwe01lexXs=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 16:01:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 16:01:39 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
To:     Borislav Petkov <bp@alien8.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-5-brijesh.singh@amd.com> <YU2fQMgw+PIBzSE4@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <a5be6103-f643-fed2-b01a-d0310f447d7a@amd.com>
Date:   Mon, 27 Sep 2021 11:01:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YU2fQMgw+PIBzSE4@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:805:66::40) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by SN6PR08CA0027.namprd08.prod.outlook.com (2603:10b6:805:66::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 16:01:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7e808f3-7713-4248-a00d-08d981d01731
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2718DDE56357B91DFF8E63B2E5A79@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30vAS68B4N5tp3zexaJb66aMPj3vMPYyj72+cLx6n9Vx+tLDUUcOCc7ikt1xo+Sst7AJEdnPf4npAbTl7HbJOWK1kazZ67+rCVOr7Yx3INtMRVNVIqldCKfYtvLjoYHkZqOMy2F3qYt+pxqgU01el9WC7xUWuzMUktcdP0yOQmbkSxj2LQxieq7yZ4+NJJCw57WLv+2nNxgYp7/0zWWbcbB4RNOfoz2VfjclzL7jyihKCMEU+1ImcUUK9bSTyVi0hz6VeoUkXSMidrU4sTUAlEZmQsrWCf8Lk3MJyPo2fwfW4omdd4qpOVhXQYaLxSQl76fOruSUW0371mLPE92iUkfSYOjcop05lF2kqBf2DNCTGE77rLyRUCp28351ZnfJBXjl4H0NHX2SIqCmC9Ec4kcU/k93Urlb/WYwtYM6XFox+In8gNQEXpRU/zWfjD8CQWqGY6jN8A5GlxGSIVIpLc0x9IuLaT1586EZKfHBgUGA7DNCMgLa6FdrY5v9jhBA5n/aBsVMK21uIRPNSsVMriQZmsesAz4giO47kb0pQaFSAATPuav+Ky6NxxL+GGCcfwkOvT0Lq+86n9ZUeVXQ/JDkDuDlff6IWngs42DoYel5hAcg+0vEbcuawXNp+WOALNHO8GzFFXEMTqoOu+bbE98OfH9+zha9PBFT9LsF2pNQoEm3qaOMtKUnMG2gjdeOHptf558g+knZmpWS8oWuGrazRMkNLh5LBWhxDRx1LIMHSnMP7+MyMFnxcGXo85Bg7kq1wF7zjBh2MHM2GUp3bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(5660300002)(86362001)(38100700002)(508600001)(6486002)(7406005)(7416002)(6916009)(66476007)(66556008)(66946007)(31696002)(38350700002)(31686004)(52116002)(4326008)(2616005)(956004)(54906003)(53546011)(316002)(2906002)(16576012)(186003)(26005)(36756003)(83380400001)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFNVSHdxdlZLU3dySGIydCtTV01uaG1iUUk0ckhtNWlqZzZLUVdzd3VuaGJL?=
 =?utf-8?B?OERjSE5sSG8wY3VaZ3NIdFFSKzNUakY3QjltZ3RtUEdSZXFrRm9MRXdoRW9L?=
 =?utf-8?B?cFB6c0xYaTVIRk9JQ2xRLzkwMm0xRmpKK0xPdzVNZFFodko3MTJ6QUJkODBP?=
 =?utf-8?B?TjduTjQ3SVFRM0lvMDRkdVJjRHo3bnd6cUZyT0J6aEhHdCtUMnFvckErSFlp?=
 =?utf-8?B?emQ5OEZyd0FqWHFJUWY1OWJLbmVsUG9XNDkrUm5DaG10bnhtalMyNXRXL2ow?=
 =?utf-8?B?RnVkeS9nUEwrV3k2SDAzVit6bG1ZUURZZFdacERPVm9OdnlDN3JZLzN6b0Nr?=
 =?utf-8?B?TWlBeXllWHl1cHl2NDExdDNpSkVQalMxZTVZZ1Fld0x2OGxzT1l5bHJVdzlN?=
 =?utf-8?B?YzhSN2M2VnhGd1R0bHlBVkFNejU4NU4rUnJEWWxQR2U2NFArUEZUN01VaW5k?=
 =?utf-8?B?c3BDb0NMZzY5WWxOa1kvSk9ySEdDNUlBSklrSnpTRHp3UnJrbGViRVBxYkh6?=
 =?utf-8?B?M2ZVdnNJT3BjQnhpUU5YVmRZdVF4Q05BUGNVV0dHTFlMZmRjNXZvK3ZLdCs1?=
 =?utf-8?B?aWNPWWhzcjQ5RnJKL0lJNXpvTkhEcXE1R1RBQ3hwYWlUWVBDSlVZWTI4Z0x0?=
 =?utf-8?B?TStaSGpJMWJFSUR3MHlOdmZZVzNxUkU3WVppTUR6MjQ1ckNRY2crRG0rSTlE?=
 =?utf-8?B?U3RGTDlGWjZrRUJMNWQwek5UU2tTVStraHRiRVE1aFNmM3dUOHVLbWxoclZN?=
 =?utf-8?B?OUhZdHVEUTRXVUtZZHUvOHRxQ3lZU0M5bU95QS9QWXJpVDNPVngzOXVHSm9x?=
 =?utf-8?B?THhVOStyNjlNSEZQYWhYMlc4eXFWTm9zY1RtMjc4NCtkYUZWL2ZFQWNnWUNO?=
 =?utf-8?B?MnRZTXgxam1iaTFPQlo3VGVaZmtraDFYSnhjaG9ETGEwKzJQZFlJYk1mNjkx?=
 =?utf-8?B?U1BPZUlsM3pTcmJaRVdKR3RmSUdBWTN0ZXV4V3VzaVc1dGhBOWR5VzdlNTNU?=
 =?utf-8?B?VFdRTDZHclZOcmozV1FycFowVENFY3JsYnBSUHQ1c2dxK3Z0UHhZZEZxOGpX?=
 =?utf-8?B?cVlFQkVZeHhRd2o1ZzN5S1dhZXppTkZoZ2xyNnFOb05sNW04WGluaDNvT0tj?=
 =?utf-8?B?dlBWRjRwQ0ZmVDQvWmc3Uy9oZFY2bmhlMjdYaGx0T0RKeHZ1U3k0ZmIyM0Va?=
 =?utf-8?B?d1p2cTVZWk03QUdxcXlLN0NoTkFZWjRwbW1lUmdDM014bzZWcWQyeElnMjRM?=
 =?utf-8?B?dWZYWnZTOFpmbnlNYTZsY1ZRZU1rSDV4YmpNMU84d1Fkd3FBSHJQWkd0UDMx?=
 =?utf-8?B?cmt1RFNIYnJmU0xiUlR0ZEpEa0pqKysxdWk0bnBLK1JlUWI4TElsM0VYZkM1?=
 =?utf-8?B?c1VlT0t4QjAxYTZKT1BWNmNkbTRMNGpUWnFxWW4wMkl4TXJwU09zakhZZXNU?=
 =?utf-8?B?WWQ3bzJWUnNLTDd3dXcwckVGUXFBMTB5cE9INGtlUHo2OWtZd0hyMVBPL0RK?=
 =?utf-8?B?K3hhSzZvWnRmMkdGVEsyOHV4bGNlQ0VsRHNIaHJFdFc4Q3FEbmFnK1lpZmlh?=
 =?utf-8?B?cWczTG9XQlFhd2xSME11cU9JeWRkUGtqSTQ5YTY1Mnkyb2RseXpYZ0xWcFRB?=
 =?utf-8?B?czd2RkVhSTJBSzNRNHAxeCt5NWVvUzlGbmMwVTVxQ2pyTm1sVjlxSVcyZlpY?=
 =?utf-8?B?R25oT25MandLdDh4Skk3Sitsdmx2cmFnRUF0MGEzV0h2SlVOQVNZaXhmbzdB?=
 =?utf-8?Q?WRlREcSQ4s1BDtHPEv7dLmszjA93duZAhoVIT8U?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e808f3-7713-4248-a00d-08d981d01731
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 16:01:39.5382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VURkydOIh5h0Gg6kS9PVCGFJ+b8vm4yNWHuzyo444v+XK14GYFPEt7e8m1fokbPCQlhYQ9XcFPnrw3v9Twq44Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Boris,

I agreed with all of your comment, responding to your specific questions.

On 9/24/21 4:49 AM, Borislav Petkov wrote:
...

>> +}
>> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
> 
> This export is for kvm, I presume?

yes, both KVM and CCP (i.e PSP) driver will need to lookup RMP entries.

> 
>> diff --git a/include/linux/sev.h b/include/linux/sev.h
>> new file mode 100644
>> index 000000000000..1a68842789e1
>> --- /dev/null
>> +++ b/include/linux/sev.h
>> @@ -0,0 +1,30 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * AMD Secure Encrypted Virtualization
>> + *
>> + * Author: Brijesh Singh <brijesh.singh@amd.com>
>> + */
>> +
>> +#ifndef __LINUX_SEV_H
>> +#define __LINUX_SEV_H
>> +
>> +/* RMUPDATE detected 4K page and 2MB page overlap. */
>> +#define RMPUPDATE_FAIL_OVERLAP		7
>> +
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +int snp_lookup_rmpentry(u64 pfn, int *level);
>> +int psmash(u64 pfn);
>> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>> +int rmp_make_shared(u64 pfn, enum pg_level level);
>> +#else
>> +static inline int snp_lookup_rmpentry(u64 pfn, int *level) { return 0; }
>> +static inline int psmash(u64 pfn) { return -ENXIO; }
>> +static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,
>> +				   bool immutable)
>> +{
>> +	return -ENODEV;
>> +}
>> +static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>> +
>> +#endif /* CONFIG_AMD_MEM_ENCRYPT */
>> +#endif /* __LINUX_SEV_H */
>> -- 
> 
> What is going to use this linux/ namespace header?
> 

The kvm and ccp drivers.
