Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37DD3F4C7E
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 16:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhHWOhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 10:37:10 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:48992
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230032AbhHWOhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 10:37:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCVsZ28sC5EuS58plWuZvvXrI3pBJpC5AkV52Mb/fadEtHo5hOvI0awtEhXgC+oA+tRXRlaWOUjOyAQWsIBPW7/rqWYYAW8DJ7nd9wBnOv6D0WEoK/lM3ChJtwZG+gXYHH8SpxlMs/h6B01xA32S0vRrBPHWKApv8ZRgZ0gC/2HyhSnFPHbaPy2ynu8WjCb1LDxKBq28MtBw/YkPTZzt8lCM/Bvh1/4G5Ayw8pmCAMlv71fuzpBh8tCZ7u2acNRNi4bEtwQonoK8OnXuhf55Pm4n69Jo845yyEcuIc1n04qpg+POj5iuh+dL1Z1ZF/jHrbxZZcNH2azewHj2rmR4FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csZ/6QSEtKzviHKaiDT18m4sYlDubrPQnxm8g+pIHyI=;
 b=OTRlNnH2B/k/Mh2CvEs2ioz1R33AYFUmNzpB/sVwSLXP+9DFlktT1Q0kWfBxftAa8Gl71ozS2L3WvgqtCDojbUG0lV6ixP17/UNfzxbmPDeXm9L7ug2TmWqS3IsLmwXynj+oJ/qPkAiYknZgoScJpy+sKXP/5g7a+yIn42yfeIJk2JRfixzu0FbV6MN/9enzKEcIp4EKI8N95FodXukT3+9BZH4vB/Sm9aN7GSwGfA7z3x3N7uWZ6zG/f24PuNVcYdY99h1JV3kj/Zz2UjV0ghz6M6ZTlRJd1zMyMzdWXmFqIHt20yxk2FA+muR3mhMjpznnjgc4JJDnPC6fw72IXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csZ/6QSEtKzviHKaiDT18m4sYlDubrPQnxm8g+pIHyI=;
 b=IJy4YWMOa73yZJkKNezxEoHtdDMc9So2EtT/XMhJDovZOd7YC2giodnupKqDDkVZG7VYZYPKrPJKYq2xHofYS/ewzaac1ZrRGBrQcC2sbkl02HbgQQnFDCsvZAmS8+s7kWGaSP8MWyJ2AvXgiA2hw8fwvE/KRQK4cUQMFsNsQFU=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 14:36:24 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 14:36:24 +0000
Cc:     brijesh.singh@amd.com, Thomas Gleixner <tglx@linutronix.de>,
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
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP
 fault for user address
To:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-9-brijesh.singh@amd.com>
 <f6d778a0-840d-8c9c-392d-5c9ffcc0bdc6@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <19599ede-9fc5-25e1-dcb3-98aafd8b7e87@amd.com>
Date:   Mon, 23 Aug 2021 09:36:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <f6d778a0-840d-8c9c-392d-5c9ffcc0bdc6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0034.prod.exchangelabs.com (2603:10b6:805:b6::47)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN6PR01CA0034.prod.exchangelabs.com (2603:10b6:805:b6::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 14:36:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cebc2e20-9933-486e-b348-08d96643620a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557625081A5DEEA4622CDB7E5C49@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PDF6PHpT+wEl/JzUaU/xi8aOM4BLCtQuhtDbyags7azi9xXHbY+Qusuk1uy+4Rynx4XzHcx/XxLB/j5QBT3ir571MQfltYqoUYZQjeNcebx+ZpPJ3JdIuTpyEXdSnZylPbc7F1mZPtm61F04xDBhpLX/j8a8681pNr6E7rh8J+nD8YcwDrcKQziy4TMMsQr1T5g8/eyCLzIHD/fz7plUVir4yZsKWtYjO20u5qBTkysfgJPX/mTuyD2kJGDCFFXz76Ex9fLlzvFrwUDM/HkBRbFU3UX9wGnBtybSuo21rpcflhja4WNZaU8yBUCznJ0pn+uw9CU0OK2XiwyrSvONQm+f35PiKdal53ZFvKYGr7wO7k/o8mNc6cp0r4VlxkOGN1zINg75OUD5p8eL7DO6+PsdMKblpE0rfKb2AQttBYRNwCQpjiJ3LoR3iwRq4AhRxolEstPZlrzb63VLu4NK5lT8hN0fNZxnXaJ5dynNGAEGJnobhtE/GJPG9MaYDWQJg052N0j7OElwSu4jWB/vdZa2A6YZ+PXUOnDWTh7MYFXP8aChTQ6i7qqbNtOW7lnzqhBek1FQQSc4mDuLB8SkcHDqC2fMG9anBtsoW2ewNbkPxrbleji50aNrsgMmkZ0gArL+LsT7IqJZihzlwJf3xfm+SQaafgEgPfeIns1dv7E4cw+qCd18KSSl5wVKwkHc82hC9ar6pH8cT+smG/APwv8IqXmuyitFS2Z8kpaKN8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(478600001)(31686004)(66946007)(66476007)(66556008)(6486002)(86362001)(7406005)(6666004)(7416002)(54906003)(38100700002)(5660300002)(38350700002)(16576012)(316002)(44832011)(8676002)(2616005)(956004)(186003)(8936002)(26005)(53546011)(36756003)(83380400001)(52116002)(2906002)(31696002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVl2RVZpWjJUUjB2RE9RRGNpVUxKUG5QWlZGK3RYbXgrRHh3ZUw0MzNDNDBs?=
 =?utf-8?B?TnZuVmFzVWF4ZHpYYlJidlFmSVIyeTllN1BBaUZocldMUTZjRDZETWFndDRt?=
 =?utf-8?B?MkExd3NEQ1hDRHZ0ZEZvd2c2MFdSckxpNXl0RXZyRkptMnBnK0YxRXg3QXl3?=
 =?utf-8?B?dCtLT0FBZDgwM2hWR2N1RFY0S2pxZFNzbkVqOWFtM3NrMm1wTkFLc2ptRjhz?=
 =?utf-8?B?SElsWUtyMkhZM212bXdzdVl4amhwakZRKzBmUldXTVdXTXI0TnZXOGFKSVJF?=
 =?utf-8?B?cEhkV3VSVHh0SWZlRW14OFJkbFR2UXl5WmdBMTdEaTB2bEE1elRrZ2pLcmxY?=
 =?utf-8?B?M010MmhubjI5bTdZWmlKdkRFcURvSklzSWNKcDdSK0pTaEpmNTNabkV5akpE?=
 =?utf-8?B?aFBzbVdHVlVxSmNpcXhnNFpvM3dyUXhYL01mZFJTTVhUUk4rYzNVZndCVkQr?=
 =?utf-8?B?ZDhNMFhkZk12b2FBN0RGTHNYTlVKc1dwZmxOSFY5cmVpdGVIcTR2OHF1cC9x?=
 =?utf-8?B?YmpBbFlYdy8wZFVFakU4U0txV056MTZGU3RSazkzYkxzbDNUdkxIQ3Jtdlpp?=
 =?utf-8?B?dUFhcys1ME1hSnI3VmJQYXM2aVBhWGRveUIzUTkvSHpMcVNSMzViWndBUGUw?=
 =?utf-8?B?c0dhTHNoeGRlbFBOZFZBY3FLa1F2Z1hxVUVUMkdTcWZReGtndUIzWTluTjBK?=
 =?utf-8?B?bFpvVWFXcG14Vmd4M2N3TmNvU0ppSDlOZkhDOHRua0JwQUFweTU2L2gvSU14?=
 =?utf-8?B?VE5tclBhQ0s1M1RYWGFiMHZLM1hiUDZ0RnUwcDF1Y1lqdmIwbWpzSlhLSmJz?=
 =?utf-8?B?b04yckVPaVJwWnJsOGtMaXlRTnI0RG9yaTU1b090U0dJQjZQTTZWcHQ3YUpM?=
 =?utf-8?B?Nmo3bEFtVXZjMHNuSjdOYk83MU96WURpUnhKTmhwNWJhQUhNNitqU1V2UURs?=
 =?utf-8?B?Z3czYzVzMDBFeFdSQXo0VnZlcHJuSjVEZzJIeVU2MlhmVzFPMjlkbmZORkJT?=
 =?utf-8?B?SDdkcU9CS2ZSNTJvSktQZnIwRUZoMU1aVmhsQ2NjeHU5OGhVdHVBVTF6V2x4?=
 =?utf-8?B?UEJhRXVkdzRRZ1ovaXVlcnpEZTA4MVU5Umtyc2gydm9mcUNDdENDQXlTamh6?=
 =?utf-8?B?QXBNd2lINWxGZzV1RzIrSlYwZ2J1MlByajF4MDc4QXArNlc4VmRkaXZMQjBC?=
 =?utf-8?B?Z3l5bm1BOFIxQWpVcWdkVldCMVFiMXJKR3d3SENHTGRyMDVoVitOdjJ4V0x4?=
 =?utf-8?B?aHI4bWozZlJobGUrTTVNVXFkRTdaZFdqbi9DbExCSjRnQjFZemxlTmY0dk1s?=
 =?utf-8?B?VlJFSzBDdmgwVm5KODlVOFh2aVljYlVuK3gxRzcvYWJuVi85c3NhbmNIaUF2?=
 =?utf-8?B?ZllUZDR1emgwYnQ0MlprdTZDZUw2VXY0VjlVQ2pHR2RjVmI2M1VTV1FIR0hm?=
 =?utf-8?B?TTUxSGtRcTdlM2NjMzRJZ2lrdHFEbnJDWWpodWdzemd0dmYybEhIRkl5VkRG?=
 =?utf-8?B?VkxWamxsRzdrWmVwcHhiWUlhSk1wLzgyczlKd2RHenNNZ2E0OFRCR05CdEp2?=
 =?utf-8?B?RlFzTFZSVzRScHorMERpOXJWb3BWOG93MzJaQmgwL3hGclFRdzNob0NlUVlM?=
 =?utf-8?B?UDY2bkRSRmFzbWh5bXB5T1g5SzNHVmJHNUVYMHQ4Q0pHdjE0ZitiT0pmajFa?=
 =?utf-8?B?WW41c0NSTVdPemw0dklId1JBTXZqZU80UE8vajhnbGdFSFpCVWxaWUk5endM?=
 =?utf-8?Q?YIkRFSAXytJFnYW7Fl0DO1b24IAitv4WXpTcfYX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebc2e20-9933-486e-b348-08d96643620a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 14:36:24.6514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qokHg1Rcn6yONHl0VBUPExCGEeMRgz/w8c+YjcKoXLSE1jLO7g9JNqV7sPanbrFb16N5/xKDlPw3PNEUoxxBTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On 8/23/21 9:20 AM, Dave Hansen wrote:
> On 8/20/21 8:58 AM, Brijesh Singh wrote:
>> +static int handle_split_page_fault(struct vm_fault *vmf)
>> +{
>> +	if (!IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))
>> +		return VM_FAULT_SIGBUS;
>> +
>> +	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
>> +	return 0;
>> +}
> 
> We had a whole conversation the last time this was posted about huge
> page types *other* than THP.  I don't see any comprehension of those
> types or what would happen if one of those was used with SEV-SNP.
> 
> What was the result of those review comments?
> 

Based on previous review comments Sean was not keen on KVM having 
perform this detection and abort the guest SEV-SNP VM launch. So, I 
didn't implemented the check and waiting for more discussion before 
going at it.

SEV-SNP guest requires the VMM to register the guest backing pages 
before the VM launch. Personally, I would prefer KVM to check the 
backing page type during the registration and fail to register if its 
hugetlbfs (and others) to avoid us get into situation where we could not 
split the hugepage.

thanks

> I'm still worried that hugetlbfs (and others) are not properly handled
> by this series.
> 
