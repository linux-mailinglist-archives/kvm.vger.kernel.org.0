Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100A33C860C
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 16:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhGNO0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 10:26:30 -0400
Received: from mail-mw2nam08on2088.outbound.protection.outlook.com ([40.107.101.88]:46689
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232129AbhGNO03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 10:26:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT+4r63NYtl6wS6Eg6TGixl8oCICPOTUO8NWiylWstAp5B1Qfu9tP1xap+YYfdWHcrHK7FpvPyVldNwG493zlPpJ6N+7T+rrouxTEDMKuIXMyYU+4eBbekgbJmWq6INZNBIofFbCjoGxHTgX+bG89YW7MP7HY8gd71G3LeZS9sk92L0zOp7c9ckS6azCUZSHtnduDIRcnfFiwviEl71NXC7CQpe1MApbiwAU9D+AN3Ij7kRPjQGmJGB9oModq2EYCPMfvNgNWbTTFoGoT7/GhGbsL4g0qOniJ7/aF4x+GhyQsFhI9Xj9jNcHKmUFwMQB04XjZ/DBldreUsHdYEva4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vne52yJLTv5XL3YxMoJGZS6HFOUrHQRb0cigRGsStRw=;
 b=bKefcMGZAiXXo/3fP7hq6ki4qP1K4tBqTpXdfrGrVcoKvdLfILDJ6dZFsCihQivBh0WxiHM+HIUctQcxs8oGVBvmkM9yTMlD/buZe8rELIgAvKH/qhJxqmTOiLjXqs7hEZYc29jVXb1IleeSW9GPA2C5z2NPpWSOFRZcHTY/uCVPH1QEkw5M7gVm5BubSLBG0GMg1O0navSMb1KOBNzaHuiZU6yOUMvKQNII19SWlOaXd+EtBeZS4Vy3ehWF5CNNSrzBcSCcFL1beRFKPwompq0k3VtV0byRPq9CCr9MCpUfyg0vYkfctO/vOibO4Th2xnfm4u/WZz2lL6HmsvfWXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vne52yJLTv5XL3YxMoJGZS6HFOUrHQRb0cigRGsStRw=;
 b=IFBg9qU7zFmD8GFRbNWynFrr3cN8t7LAKqK4i1coDlWjP4Whm/yQVq4rY9vl5xrZf44x9R5KMzDUDD9FuGLMMvTHDj00sD1bYUdMT46EgHNuca9SqcGUvZKmDBEoIr0D2EYgfIGmWIN/fVKEh6Gn/afYpcTaFIosgl6LXGrQfCY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 14:23:36 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 14:23:36 +0000
Cc:     brijesh.singh@amd.com, Dov Murik <dovmurik@linux.ibm.com>,
        qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
 <80b92ee9-97d8-76f2-8859-06e61fe10f71@amd.com> <YO6z1dJxuT5cNz6T@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8c91c7ab-2d9c-26af-8402-dee7996fd7fe@amd.com>
Date:   Wed, 14 Jul 2021 09:23:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YO6z1dJxuT5cNz6T@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0201CA0071.namprd02.prod.outlook.com
 (2603:10b6:803:20::33) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (2607:fb90:f221:2aa6:5ca5:4e98:9569:a37d) by SN4PR0201CA0071.namprd02.prod.outlook.com (2603:10b6:803:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 14:23:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c5c4c50-5c95-4dad-f458-08d946d2f807
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43492976EDD470BE32F86B81E5139@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzQDFqXXdiLSS164FVd5e98E0hGikMDxZPcWM/UgB+BQa0VJKRmTrEypeABLREgJCfrNRoxXoS079ED1pVcItKvMcTmVS3DVqBPtTTNoW3XVTDM0TyBSE0ZDYA9CefkseTYKZ5Dya5zxFmMvEmucCibAibVGDf1HvMX5lq9eNWYNOIpKUuhmBSw2k5t1I1LFCimoaJ8aFoiG1UoVxRqHtBMylkSEKSfLa/Z8uH/5v2JnWeM7yAhmk7upMJqZh2UYGBGtUrpWZNMiPWSr83UMGRjlQPcPHRHyCbdqMNiSy+QAv/nKRCCi3sb/mJw8bHyU/1fK3v9+x1J9HD88n3KsFVqRmSWCvGXtzZKRFVWvutje7FABJQUb0yUm70fnb57M7GsOdz5zGeWddZ/54NBxLxwSEFxuTf8DclRnJYESHu5Py+ZsjFVNuqfTeqYK5tFMIDC74DFME53h62Aul9ngP486X+ItzqvW2cor5WshgLlAYqcL/xJub8g26EUUqNDoLwEcifnQC69ehV1lps6jy69HbovYN884RctjJcAhrOXvQSpxdvZyzAz3hFRHTNm4mYDVTuy9A3pOZCsy2EtnffRPr3vVmqbYV3+HRDOh/uco77vVdTjEdwQhL2OM+HDOIvzEm+H7ynDDuxmLJdD5UsIOdZMG45vu+tTyBtOSVtSsATRNxn+e2Od0mt7/LK0/YmWISl8U4hqMLL+yReTiShigrXestovW7dzxC8gQZ5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(66556008)(2616005)(66946007)(66476007)(52116002)(38100700002)(54906003)(478600001)(36756003)(6512007)(8676002)(4326008)(5660300002)(316002)(8936002)(7416002)(31686004)(2906002)(6916009)(186003)(86362001)(44832011)(6486002)(6506007)(53546011)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDU2WUNuaEpyc1h3QnY5bmJEL2dUcUxtaVVoRHpXbDJZbjF5b3ZNQUZJUE0w?=
 =?utf-8?B?WUhWM1FCekpISWZ5bjhGU0JLaStUUjNURzBtNUtRQzBqVGpZUVVkS3gwRDl5?=
 =?utf-8?B?ZDdGOG05aTY0aFBHOWFISWtDaElFdlBZbDBrT1Q4eXpxNGJ1ZEh5LzRjTE0v?=
 =?utf-8?B?cXpaQWFrZGl0WmtWOTAwaHVCaWlCTTVQdm44b3BGRWRoTDhnWVZ2anE1TmI4?=
 =?utf-8?B?by9ES0hoTktCTlYzdzVTWE5zTzI0YUlyZ3lPdjVHZjhZY3FocTVZb29IeEpU?=
 =?utf-8?B?QkdpK0dmRXllSVd5M3AxUUZDYUcwcDJ1QlVQK0RWbHVSMmhWMWFvZktneTM4?=
 =?utf-8?B?ZEF5YVNNbCtjVGNQMXhidXVQVndJWFpzcy9TbS9ETi9lL3FtaVlvOStvSHRi?=
 =?utf-8?B?MTgrRXNDYzFOUnY3LzgrUXVOcjgwQjQ3eXl6N0swZUxoN04zdWRoRWsrRG9i?=
 =?utf-8?B?enM5NE54Ym16UGRBUThsUmdOL2NHSXA1My9sMVlFM3NENzJTdll5c2ZYeng5?=
 =?utf-8?B?QW1KVjNPcFZOWGlkbm1kREJFc2JXbmFhbldVOHpKNVNSYnczZWhzMHVtWGta?=
 =?utf-8?B?TTNtWTdzTDNvZFZmVy9DVmd4TDRMWkltQ0x6cW5Ba25mOG10dDZmTlhxc25W?=
 =?utf-8?B?bm11UmIzUkZWSy9YQWFuU0xLUko5QjZueWFwWFRkSzNKT0F5OEIrcU5HbVM4?=
 =?utf-8?B?U3pnV0tERDJ3bDE2SjVMOVAxbkRqNFQyeldFUFN2WWtpV0w1a2lPSkJURUZG?=
 =?utf-8?B?QndpMVI1NVNwUkIvWHVudzNVWmo5VWdaeis1SWlFZ1ZYSVd5ZGZGR3ZocTlq?=
 =?utf-8?B?cTh3VWk0MlJmellvUWhUK0VPL0FXYUNqY0VjWTFLSE5wY1FHMThpbHJjMERw?=
 =?utf-8?B?ZjloYUFCdVRhVUgzdlkzSTNkUVN2NlY3R1UzRkEzTFJDcE9rRy9LMmtTSkEy?=
 =?utf-8?B?RUV5SWdpRWRBL2ZFU1ZoYW1UcERWN1BRSE1QMGEwcDRici9hS3JLZUR0RFdP?=
 =?utf-8?B?Q3d1ZlhZdzA1dVR5SWNlZXdlbGZLL0pWTG9ua21FYUQ5SSt0dDE1a042cURr?=
 =?utf-8?B?OGE0N1VmMnJ5T25Fa0x1YjBSY1BVUkZxeUgwb1NqcjR2VnNXUms4UkJ0bUxh?=
 =?utf-8?B?VjZ0RWFiN0h2M1dBY244d2QvV1FqbDZrMDl6Tm0yNUFDcTFsWTAzTzNwTEx4?=
 =?utf-8?B?TDlLclNWdFdHSDRQTkN1Vy9kWndFalovaERxWlh0OFk0YkhqUTNZY2syU3Nz?=
 =?utf-8?B?ZmhvR2FtbHFuSVRFY3hjVTNObnJwRXJUaE5SeDN2ZmViK3hza0ZidUNGWWFk?=
 =?utf-8?B?S0RuWWQ3NjVSVTBGTGp1NUZjYTJKaG5kc21tbVBRbEQvQ2t2d0ttT3N0YzN5?=
 =?utf-8?B?V1dGUnBSWjVTRjdyUEd6NHBSRVpFa2dKTkJEWHZSWEhXOURlSHduZjBDNVU0?=
 =?utf-8?B?R2F0SmpkKzRqcERWUytDUHRzWnZIRFltRlFBaVNPcFdUZStKaGg2TE1YMVU4?=
 =?utf-8?B?SnB3R1lBNlhNZUlrZ1dGSWJRWWtCaWdJRGoyeUxpdHQ3QitBa0kzUUdXaGhw?=
 =?utf-8?B?dGdPaWY5YXFxOEszMG5iaVROdzlBRENtVnVlWnpjVnB0NllHd3owY2gyS2Zl?=
 =?utf-8?B?VFB4ZFBCVjc2YmR5cG9OYW1WRFlCbjFPZ1FFUTBreXVPWnRXeStqeG1oU3FW?=
 =?utf-8?B?Q2lZaFg3UHhsSE4wdHNnUVVzY3VxTzV2b3UwRkhuZnZHMmVIQkJJbFRKemg0?=
 =?utf-8?B?WDJhVXZUOGRUMjZyWXN4Z3Q5WFBrb29zZG55NlI5N25wQ0l1c1pJeVRoVjlx?=
 =?utf-8?B?YzBMSGMyNnpER3M2RlAvMFlDbHN1YWs3ZHJ3aUVuWW9ldG4vdHE4QmZzYlRX?=
 =?utf-8?Q?3j4dcmho/o6u1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5c4c50-5c95-4dad-f458-08d946d2f807
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 14:23:36.9302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJAs3iWbfzItnWGYu3eM1wc2Rl4fhTT6JWOIlXQ3UGGpjmRlvEQwWXDumeYJ21Nh+5oqmmQseuSAkliagGHsAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/14/21 4:52 AM, Dr. David Alan Gilbert wrote:
> * Brijesh Singh (brijesh.singh@amd.com) wrote:
>>
>> On 7/13/21 3:05 AM, Dov Murik wrote:>
>>> Particularly confusing is the `policy` attribute which is only relevant
>>> for SEV / SEV-ES, while there's a new `snp.policy` attribute for SNP...
>>> Maybe the irrelevant attributes should not be added to the tree when not
>>> in SNP.
>> The policy fields are also applicable to the SNP. The main difference are:
>>
>> - in SEV/SEV-ES the policy is 32-bit compare to 64-bit value in SEV-SNP.
>> However, for SEV-SNP spec uses lower 32-bit value and higher bits are marked
>> reserved.
>>
>> - the bit field meaning are different
> Ah, I see that from the SNP ABI spec (section 4.3).
>
> That's a bit subtle; in that at the moment we select SEV or SEV-ES based
> on the existing guest policy flags; I think you're saying that SEV-SNP
> is enabled by the user explicitly.

Correct. This is one of the reason that I added the "snp" property.


>
>> Based on this, we can introduce a new filed 'snp-policy'.
> Yes, people are bound to confuse them if they're not clearly separated;
> although I guess whatever comes after SNP will probably share that
> longer field?


I am keeping my finger crossed on it. I hope that in future they will
share it.

-Brijesh

