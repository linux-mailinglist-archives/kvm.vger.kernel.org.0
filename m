Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D02F6DF9
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 23:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbhANWQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 17:16:20 -0500
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:21834
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729729AbhANWQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 17:16:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyoKX0V8hkw6+FXMX7S7PnN4wyp87igMZvnqEISTvBABR0TOEp96VeDMlDVSgxrLrrC8RpbLRcP0CNmG7yk4n1aYa95psbalK9eTVqkfV13cYDJU5bb9B58M01M/t35UMfudL0iQWz+4NzWp0V9DA8eJinG8QYpgT9tZC1Zpm1Lexj4UnzxHO6S47sfDpSOkzJjwHWdfbm9wS4KWBus0XqPKLxm5xf6uZmCjYMiQk76W8GhYiQGKOx5BDggryTJa6OhKhx+raUjhFHjHgi9TNvTep5V+TZKM8iW8qLzxKaWgiFVHcEu9erHknKvhkii5IyNF7FRYcReVbowM6xsLaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7miwXdoUN3qoXsIDzGxM2Qg4QwYT51CnHSOQm5RmC/s=;
 b=ID1lXitu40K1LIG5Q10FJ+Os6uyV4Sqw+nvQKAgR6nUTYHwUPmHfyoeqrBhseNUV0VCaJEVZsnE+2YlTkHdBzYeb7LaLudVfBYQqStXgFwL+84G1u3B+udKEbrsY7xHxa1lJHaHGxy9JLqVqedXW52nXotvynXBC6Zbt0lniDNHuZGDAGYex5P1Qw1kSKE5tQ1O6DHSVf84rrfEOQxWEe72EhM37RX0q8UXjvtJy16T2vsyWbHbgiqwPmbfCp1S8GyRNr2Ipe614nHC5rhHuiLb0XqlF3s0+Jp/KYw/5V03Z36CjaeF8o2R+kIxc7LbRjwbMqKNzUyNgWor8JeMZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7miwXdoUN3qoXsIDzGxM2Qg4QwYT51CnHSOQm5RmC/s=;
 b=Dqn4EBbf6iKtOgP1KtDjzrLJb6tvjLHvEnm9g+Zp2CIGUGH5aa0DC5C86I5WBcK6/gQlASorbhHpuyuYZ3bPpCL/6B6rumO+fJffhPTLOfdB1xGtHpHwqPJsdm/fm5ICZrFhOEckNU7vtLUPMWIv2/wrY+jqsNvaErUqq8rqNgo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3866.namprd12.prod.outlook.com (2603:10b6:5:1c6::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Thu, 14 Jan 2021 22:15:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 22:15:25 +0000
Subject: Re: [PATCH v2 11/14] KVM: SVM: Move SEV VMCB tracking allocation to
 sev.c
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-12-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d615bc9d-d23f-9224-353f-96a8001d0394@amd.com>
Date:   Thu, 14 Jan 2021 16:15:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:806:28::7) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0152.namprd13.prod.outlook.com (2603:10b6:806:28::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 22:15:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ec763f46-0554-4514-7812-08d8b8d9e446
X-MS-TrafficTypeDiagnostic: DM6PR12MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB38663CC67EDB36B02B2CCB41ECA80@DM6PR12MB3866.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zhSZ5OdD19O2VWLf4wnEqojW4Qqj+DfWJLkdNApW4tQYjiRg+1zMS80RFjpPlyaNI2GL8o5Nf0egdDgDxLzttkq3QYakN45Pk8JoPHY8gQBRUkarIhCWNBo7iajx1MY7spYwl9OXBSXKruDKRrhulwvT1sH05HxbYXr0epCkeAj948WTgSRgejfcHG37OePw2V157Y/wYb4DdZ61VepQ22i78Lcj6VDs/yifVpGctQJB/bYDg33u8MIvnwYWH4gfAriUv/J7jzwiOjnm7I8g7K4unf491F/kMsRnFlwcumTVDf9fIpD1B8RG39Ldhpm0uIF6AoqhU9iRn5xB/aX6YisZB/QAIvSEIe9exYqqfuq5fTxlnCRNTGou5KVEc7LTqZ7A7toGpHeUhlboMMm/ZWsFEVxk57Ewzkk1NqRaMa8dLZz5k1mPveshFHPM3JPY3VA+6Mr5ZgKnX/NgiFVmXhbxZ8LLy+iuAViu8JeauA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(31696002)(6506007)(2906002)(8936002)(86362001)(5660300002)(4744005)(478600001)(7416002)(16526019)(8676002)(66556008)(53546011)(6486002)(2616005)(52116002)(66946007)(66476007)(83380400001)(186003)(956004)(6512007)(26005)(316002)(31686004)(36756003)(54906003)(110136005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TURHZjNLTEE5VkhJcGIweFlKdVRtbXpadjh1Y0xmU3pROHhPdDVrbmthT2Zi?=
 =?utf-8?B?UkNHM0ErdFRMbnlEWGRxM2J6bkVQTzc1MjlBUDNEN0gxTzZSZzFiQmxhWG05?=
 =?utf-8?B?eC80b0o5d0tzQlk3RDdMMmd6YTFXYnJOMzljanpYSXNtZDFldDdvY3lnbEJ0?=
 =?utf-8?B?T3hNOEt2YTlDbVZRcnhMK0FpWkx1c0xLMWorOXlURmhvTEVydUphc1JDU2Vl?=
 =?utf-8?B?V3JHMjlnOVpOdHJYd1FzSHNjZG93U0FFWGF5bVZJcE5oOE1pTWtNbEV5QXUz?=
 =?utf-8?B?VXlrME5od0ZEdHZMSVRpMGRzTlI4bzl3MXFUQ2lkSGRhUlIwMDBLa1FEeFMz?=
 =?utf-8?B?aUxpdlVtazJSbDl5cXU5V2pjanc0dS9iemZrUDJYZE1rV1pibFMveHo0UzZq?=
 =?utf-8?B?dWp1bWp1aDMrb3RwcTZSR0JPZVVvQ2ppcXJjZWFqajVJTXBoUDhjR2FjRGpl?=
 =?utf-8?B?SXlCQzg0VDVuUXlTZVErVGs1VWh1TG9yQS9PTHhwR2lhWXVOdWV6Y1BSS2Fz?=
 =?utf-8?B?VTVJN1RvQVNIYWVkdHB6dmtYc3I5N0V4T1hBYU1LT2ZiR3pOUGR1aDd0TWRH?=
 =?utf-8?B?bEVxckQ4SmtjZnhNQXRtbVBQSjhtU1R2SUNvMExSaUswYUtKcTViQUhjUGVB?=
 =?utf-8?B?ejVjanJ0aGNaL2RmT0t5UFYzeUhVYU1BQWx4OXhqaWwvWCtzUG9ZdGpTdDVF?=
 =?utf-8?B?VkxSOFhWNkxRVXU4NVhwR1JEOW1LSXZUWW1hSTBlTjRONXVJRmJtZzQ4NjAx?=
 =?utf-8?B?QlhpRldpUVZFYVhEWmNYUHhMbkVZSUdYNGhkTVZaWjlnbitiRnhRWTh6N0xN?=
 =?utf-8?B?TXdUVFg3TGR6ZUZwQnVmd1B6WUxOWHBFdHZEQmwzMmI0T0hzRjFERzhkWW9F?=
 =?utf-8?B?ck1tRUtmQWZwa2xVWWIvYnhhd3J2czJYY1NkNno4cXhPSVA5akpIbWJHVXV1?=
 =?utf-8?B?RUYwU1VmeE95ZTVsZ3dSV3Jmc3J1Wi9iTVVJdldVd05OR0Y1RkIvV3pidUxH?=
 =?utf-8?B?RDBBOFFkWUk1aVhRNU1OMG5Oc0FaRzRwZUpIakNuYytKUHhEZmorQnJIVzhV?=
 =?utf-8?B?dGd5anZuUlNUb0poazNWNHJneVFXdGNsVmZaU1RkL0hzVWFYeU1wd3lUWWpF?=
 =?utf-8?B?a3JlcEc4UUs2UzdpV28vTWRNczg3c3BTcVRtaGhzRHc0R2FXQjRBbEJiVS9i?=
 =?utf-8?B?SFBvL0xyc3pReTY3ZnI5Y24xYXdmV3pQVkRHdEVFSGNtdFRYNTZ5YUo4TUt0?=
 =?utf-8?B?a2IwQVZsOWRRMHArbDM0SDBjWWpEMHdwYWJXQkxrb1VpTkVtMFZKRXEwTFhM?=
 =?utf-8?Q?j/BSN70Msi/ivNr1ni+xLUKcxIXZBfLHDC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 22:15:24.9003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: ec763f46-0554-4514-7812-08d8b8d9e446
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +E8iQtmDIsmiljtXVw4xAEO02Rss9s/LfO4BoSSKlm6B6sJ3vkY2x2jjir4H+Vv+jasPWjKVZJZThKUaH7jjbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Move the allocation of the SEV VMCB array to sev.c to help pave the way
> toward encapsulating SEV enabling wholly within sev.c.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 13 +++++++++++++
>   arch/x86/kvm/svm/svm.c | 17 ++++++++---------
>   arch/x86/kvm/svm/svm.h |  1 +
>   3 files changed, 22 insertions(+), 9 deletions(-)
> 
