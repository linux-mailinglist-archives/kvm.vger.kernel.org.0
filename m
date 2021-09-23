Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3AD4166DC
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbhIWUqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 16:46:06 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:2816
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229753AbhIWUqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 16:46:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEm9D7tDcB5GUgYJd1fYjJwg7FtDE9GMlewMASv/BnaN83jCzTsRnFPMOT/JovPgXAMv0dED5XsqON55OljAgj1jIB3DYCR1pSNBEy4nuPvU1mli/n+iQu3w1tnPl5/5CmoEeypIPl2XowH3qrrMomFTUEFC4IrLGDnoeGfMLOMBD33/LV9/swxrNqvq3kgGhvL0Q54eWOorQU2cf9LhNYgjvo3b3QlWj1fp3KWl+dcLAh6lelXsgt73nyOYmAUifeiivY+y9glLAuWp5tWYxYiWaPeaZCMcNNvEOXFzFaw4MyL7ml3AzDmvxKwEfjSU4vGFUe7wmcP57j+1tYZd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xqgKJ2XSJxqhMiPcgCpS7n/zTcUc3NJvDQCQTNuoKG0=;
 b=Jcp383MKi6eSO96M9AMsLt7onl+jnPhrrhOjzmUZgX4GgVh0LWtmw5FJjP3yv3cQGRFNRUq2ud0Z9ppCNfLqVNqL/Zi4tQfoZWGr1b2AqYrORthzkil2/LUtpg3jPTQdfMZKyNgJRLXuadtSlCtuVxFh3HmCYc9RARAMe4XlIqKbFm185jMg7y4XEvE4EWlk5E+yCr+aFK7OrNbXMLNbC4rKceWJVXnjWJ2XAdRI+uiI1u+6GUMD+ruse3LeMdfNPZmX5QbX61T3XdjzARm4o8BRi/7ikF/itX3J5lYLOsYsc4fGGslk+m6DphOYRCQdWFdpU2mLJn/vg+NwX44k+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqgKJ2XSJxqhMiPcgCpS7n/zTcUc3NJvDQCQTNuoKG0=;
 b=JHyWk9p8Lr+9Xbk7XSYDUXmuMtMF4hR1gASLlNs/hD/Lto2/b8QJPLSslcwse4bLmzDcpgYiht7dujmZ6vOAYWK7EPRFNeMUuWs6aux5jkYS3LxpJWR4Cr7dmTEZKiQ40VXnpFngiR34rQ6PwKTdr7evfitDXKfd035DIxIINZE=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Thu, 23 Sep
 2021 20:44:31 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 20:44:31 +0000
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     Marc Orr <marcorr@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com> <YUt8KOiwTwwa6xZK@work-vm>
 <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
 <CAA03e5FTpmCXqsB9OZfkxVY4TQb8n5KfRiFAsmd6jjvbb1DdCQ@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9f89fce8-421a-2219-91d0-73147aca4689@amd.com>
Date:   Thu, 23 Sep 2021 15:44:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <CAA03e5FTpmCXqsB9OZfkxVY4TQb8n5KfRiFAsmd6jjvbb1DdCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0001.namprd05.prod.outlook.com
 (2603:10b6:803:40::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0001.namprd05.prod.outlook.com (2603:10b6:803:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Thu, 23 Sep 2021 20:44:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b88850f9-9331-43ce-3789-08d97ed2f170
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509D91D62E717B89F987B7EE5A39@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tO9ldR/w3q8X8N2TC7AfldD35c8W4RsySyqg6kJ/OE4N1EIr53+tdQICTwMgTaSBkcczpLD8vHk8A5bEaWFHSU5eN7AZ0lDqKIooX2tJF75FIdxADdf9199kXVo8Luq33zo0L6Hu3zGurRTMLLv/w/te7aNn7u/xtnX2xq8hG27Q3j61PGeJ1NH55Axwfe6JxiLrcJ6ePL1Fhz8gHnnpnfU6viLLOjJ4AezrY8NCBev2RZcwCCTJJZpVzF/pnIaN6/Wwsva4peaRwHpiWipUXao5JnY1nM6k6jDFs73eTK/zrsI2QM4YznhZy/YVT8M0qYAhdtNuPA8DZdd6IT7U9jBzw+IkKraD7whnSSu/+20ADqjkHNWBm1usohzNXGGNSVtfjBfeV+M6c/36eRHTgvnfsOej2rdpm8CL6PdH+LGwYUlSQxojXgQXKh+DtHceJH9dsdHnerFlFUzw62945uCmpuZRmVyvCQPuYpMtpk+9sJ1HMTCIDyAVP1Ne6ormZGSixOReFQiKbmCeaBnRMfLXrp6jLiiJwQ4MjFh4P/zh4blgO4Piy9pIrtMebEN7DgBbTf2cA1QOM8xlz0oRwwOiF8phKu1GLOqM6pJks7XQPrVLM8tBRLNMO6/jV6dfxKNw5qfllUauxqu4WnVUq5/KTLN6zEH5cTK7gYCiy7Tw1eFPTL9KTVnYl/GfPchL6AjrxCs5HIAb70GcyodFDislPC7KBNBGKlgOB+ugTB9vDwFTC3UKrvQNgzIv8kzBZbcFv95DO+wRSRFN8D2ryZbnM7fxp89akMy4VcRgVMOPoQogGSi2djHA1dtY2A3gMibjDmxBSd1BYBL5NnsHlYR+khVx9Sf/mnTQpDj5AR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(966005)(5660300002)(66556008)(6916009)(6512007)(508600001)(66476007)(7406005)(66946007)(38350700002)(38100700002)(83380400001)(316002)(7416002)(54906003)(8676002)(26005)(44832011)(52116002)(31686004)(36756003)(31696002)(4744005)(4326008)(8936002)(86362001)(956004)(53546011)(6486002)(6506007)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZjb0VHUis1NUhzM3B6Ri9DcmYrV2J5QzRXOVkzdk1IWm4veXg4UWVMeHB5?=
 =?utf-8?B?Wi9zSGllbGExY05DT3lBWjNDSGpjMWNrOEFHWXd5S2xjQmM3dXYyYUlvNXpK?=
 =?utf-8?B?L2pqbXFUdkhmV3JTc25DUnFvNFRVME0yc3ZoNHAwWDkrOStpVFMvNUlhb2g3?=
 =?utf-8?B?ZWY2UXhNTlpqZEYrZFRCTm1yaXBFWmtjWUFWd3BVc05qcnladXZ1SlBVaTg0?=
 =?utf-8?B?SGxKTThZb1lHM09CbXQyRUYvWS91UXp6dG1zalV2c1RKbGxWK2NmNHhFcHpO?=
 =?utf-8?B?QkZsNjJPVlMxR3NxRDcrcUFDVEhXOG5OZEtEYlR2MmJlaGM2V3lHa3Vjd0o5?=
 =?utf-8?B?OVZwT0tSRklFdGtrL2crU3V2b3lUVVhCcHI1bW5oUTlJUU9LQ3g0OHNtU3dP?=
 =?utf-8?B?a05HMnZiSlhkN3ZrM3dIb2FQVnFpRkxkdFZ2NllReVBVeXVTSVpvT1V6NGUx?=
 =?utf-8?B?S1p3RkFORlNkWmlRbmpYWkdWZW5kME91Z2srRVB0OTlZTjFJZVpRUXducUlm?=
 =?utf-8?B?MjNEeWxFckJzVytVVjNhcmtQeWlQckg3dzNaaGJxZ016cEh0MkF1dlFLYjVD?=
 =?utf-8?B?TlRuSnBWL2NZTTc0eGlJUEJNMW54a3Z5TnJDTXhrKzBPRVZrSnplVCtaTWRR?=
 =?utf-8?B?Y3ZHRE8yeUhUUm5MRm8vZHBUWGFTR3dRY3FWOXZKdFk3QnVxMjROUFIrd0tj?=
 =?utf-8?B?VlR3NlNFU21uelZqYS9sNTE2UGErUHhxM1JyYnNhdE5SUWtobkRGazhMekpX?=
 =?utf-8?B?M2RlUzI1WkNEbXlva3dnenhoTEM5cjNkRk1YM1czTGdIU0laY2wyYks5VUVR?=
 =?utf-8?B?NWw5NmlLcjhWYkNybEZqZGtEaDFoVnd0VE04K252dmM2eFB6eFIzRGlwTlNl?=
 =?utf-8?B?dFFabHYwTUYzaW41UGtZL3VRbGZMVitsSkp0QllaQzJHdWx1QkoxaXA1ZzU1?=
 =?utf-8?B?dWdyRG9MOTNTY202SVJnc1ZHQ29KWVMyanVWZjQ3cmhzNWxUWHFDU1hSMUY2?=
 =?utf-8?B?LzdTYVdmY2E3ZGNiK1BOclB0Y0NBK1BZNVU3M0d3QzB0eWNtQWZza3pIeWVE?=
 =?utf-8?B?WUFYajZCZThFbkxaeU1uTjhXMmVkL2NYa2Y4M3RGdFdYOWhEZE93VCszMVd2?=
 =?utf-8?B?V2VvKzZ3WUorM053UlluaDdKMGl2UklIU29IWTFvNUhvRXRHb3RxOGhtSUN4?=
 =?utf-8?B?dEVIT0JvSkpUTlhwY2RVdDRYODhEalp3ZWJkaEpDZW5TdjFoOEw1WkI3bGlX?=
 =?utf-8?B?WGdYVTZ5ZVhpYUlHcDVRc2ZaanEwTUNpVnBzdmhrYzNPOHZjSkcrcWhGeDJV?=
 =?utf-8?B?M2I3czNremh6cTIzaVJWd1ZHQzM2WGRsNmhBd3dBdW9CazR3S243dVpXbFEw?=
 =?utf-8?B?N3JGdXF1dVRPZFlZc1JJSStteTNNZ3huWlhYWXRwb2M4YnE3NVJqOTIwNDRY?=
 =?utf-8?B?SUZhaDFiSWFsbWhyeGw4MXdtUjE1V2xDSjlPM0VJME95NTFRdDJjMzVGRjJK?=
 =?utf-8?B?RUpOQjhtQ05wNjRWVmdxZCt0VEpPMTJZYzduV1VvdUFQZUZyT2RWSkRocGFN?=
 =?utf-8?B?eUVGdXhzRHJPWDlYVWdLZlFjY29ZcnJRN2dEeWFYRUJWWjVaZldMMXkvenVQ?=
 =?utf-8?B?aXB5Z2M3b2I5ZGYzSExSMWZFNDFmMFEyN2I0bDRFRUx5bmE2ZzlFNTh6czc3?=
 =?utf-8?B?ZWpNanlVajVDNTlsUGxVQXh6V2tpZm9ZekNYU0ZEY3A0a0hFRWx4VHZiVGVP?=
 =?utf-8?Q?I+YmHeZw8FQ97sdg9EbNSw2FT9Vs68Zx0EyCj6+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b88850f9-9331-43ce-3789-08d97ed2f170
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 20:44:31.2218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fi+D/f7ObtP0zzzefi/6/+fmqp/wVNN18a1FHT/+l3qtDYztwET+5SG4VQqcC/jkmw7n1U3QUMlaxQEJbNXMGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/23/21 2:17 PM, Marc Orr wrote:

>>>> +
>>>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    unsigned long pfn;
>>>> +    struct page *p;
>>>> +
>>>> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>>>> +            return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> Continuing my other comment, above: if we introduce a
> `snp_globally_enabled` var, we could use that here, rather than
> `cpu_feature_enabled(X86_FEATURE_SEV_SNP)`.


Maybe I am missing something, what is wrong with
cpu_feature_enabled(...) check ? It's same as creating a global
variable. The feature enabled bit is not set if the said is not
enabled.  See the patch #3 [1] in this series.

[1]
https://lore.kernel.org/linux-mm/YUN+L0dlFMbC3bd4@zn.tnic/T/#m2ac1242b33abfcd0d9fb22a89f4c103eacf67ea7

thanks

