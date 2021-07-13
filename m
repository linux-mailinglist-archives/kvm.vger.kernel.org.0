Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D513A3C719A
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 15:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhGMN77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 09:59:59 -0400
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:41889
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236354AbhGMN74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 09:59:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIYDbgivzurld21FUWA9gxTLtMpFsK76EIeoxTN43Z8WQ2cf2N5sbRE5yfH4B9Npc2WdnNB+w6sIzCbQ5c4eweUYZ5InNhkoKxH0fimGKstcZCDy63rSEwHCUNsXgwAU1AcD644Fk7Q0WA1CCmTEWJkW8AMFNTEvUz5L9fqGuUNS/QK/SDG/hJml6s4rzeAzXrFfcV0DrWkCo1MA87rgQlVwHVRCnxYyLpE44ccOwqBANOrgQZGLaB+wZW1QGDeiYb5r9ox7wP4ZjBudvYF6wXTc2bDJvMgJaaHOLohMv9i3Oab3so8sbST7FvoLGJJbfJrpcqpmGWgTR4SnJbBaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1g0DYTJz/5UqbyrxVC/vmS7uLkzEnfqJUoyD2Snc4A=;
 b=C9cQmkNZly5fTkHQX0kUw7zdmDwDaXHk7UNBv0UMiQC6s6Xk7RkNscUlIf+B/dOLfdTb1Oha87P7anu96jpthDnQBj4I+QSuchk+iZq9QL0Pe5HMYCDm1APYtuGcsmGWGlxh5EF5tyxIshPeuxdu15r5UVdyEpqPE0TARaHwhD+hAl8PB0FDrnQYA9WZFxvzt4KFQRc1cWqI3uZuhU8Rt57KcjZcJVUPl372fX1QO5OhY+DY5BQj7yjkPymWEb7l2QoKPhzVBIOlBZm7n/KnXskxCkSKHycIx3fzrGEP7ec0FABRO3+nn+q9ydnt4CS+Izk/j1Dw4tBBUS/3CJ7PGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1g0DYTJz/5UqbyrxVC/vmS7uLkzEnfqJUoyD2Snc4A=;
 b=KG85FoKdt/p9iVcnbwbbYwSa17JTSHK1G3VIRHusjesdE/HunUWXDE02l4St2/iyj1myo4BvfFgeI+bfi58cSCfjWTezAqwlHc3BysPqeFzMlD8iLMNehqMo2c73kdZfvSY+TpbuzDpGIDuJnPmiVz9reDPH1xQL+jj1Jk1NTBo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 13:57:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 13:57:04 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
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
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
 <YO1PbIPXem0E0Bgd@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <31b1e40a-53f0-c2fd-bb90-9234892d2dac@amd.com>
Date:   Tue, 13 Jul 2021 08:57:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YO1PbIPXem0E0Bgd@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0042.namprd04.prod.outlook.com
 (2603:10b6:803:2a::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0401CA0042.namprd04.prod.outlook.com (2603:10b6:803:2a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 13:57:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1525b0be-4541-45cc-a2bb-08d946061894
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574DD21A56040712BFBE440E5149@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2b9qvlvgmsX8Bxb8Y0N1da1u9Hbc4L2RGYHtBX0fA06qJzT+ke+lpIqY6x/GV+ib69ffDtk9huHcr9pzotLxae2t4kEkS2fEabWHJRm5oemZVPLlSnjcXr3vQoKbVr+06PLNR7G0ouBtfp3zmgCxQ4PCqUkvHXnjFOU7LNWn8NyiRgzwVGhpVeFZHFUWHhhxBJ8kbNhdxEsb4lgYm58LQFTWG+xAyB67halm+Qnv0x97HZ36XpKi+wHyl6FeLtg5LiZheVg3OR3UUYH0spsDcCBxNU9+t2SpZTGtWXZ7I++PpAVrEOlGeib8eMrdcJ8E6FJ7sGzhOepggzE5W26m52ertp5Me17FTKOScHG5vxQMPwwzT1kgwrUJD5s8i/RDwhdIuf+wlFZCwD7rHuU3ofEN13popPYfFmm2/G+2VtSQBecrgcwdTis9bBEItwOtlo/SHbiOJj+xi7BSYgJGMlj3+Q+3w62VzcMwizDOc5QnVcOlPDS9xEeKxjiRomNx8rMTmnLeI7wgrjB/XXqA10oRQw76t2U4Fbjkr5Ot4mieXUNGMvWPF0uLrDuyJV5bcXbJjCEx8UsOieMbtgiS/ntJv511f5qYRTrouTSRUubmsbmyI0RsvIJwYSHteKj12Lv0+z6ZiL4aFjwOor8QDUDHX6RUZ0aVeCT41dLAkKQx2bItdZDnvvtesNd49g2bNaKZTZb6ug8jO+Z0RjIFxJUB2rwDrF9Shyg3Q0vqPtpKXsK1z+OJJmgHCYc8w129NwPpVe0uJzbyKOdIjA5BA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(8676002)(66556008)(558084003)(2616005)(86362001)(2906002)(4326008)(66476007)(44832011)(478600001)(54906003)(53546011)(38100700002)(26005)(956004)(7416002)(110136005)(31696002)(38350700002)(6486002)(52116002)(8936002)(31686004)(316002)(16576012)(186003)(5660300002)(66946007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFZYVUwwYW40UXlza3IwSE1JYjBhM0E1ekZWU0x1UkV4VEUrOFpxYWtEK0JC?=
 =?utf-8?B?WFNJUWwyMUMxaUowM3lXWUFKMEhudUNPaFVYMDhjVDBKT2IzYmtHUU5NNklN?=
 =?utf-8?B?NHA5MlR5cTRkSWZpYlJhREZFTk8xSWlIRnlyQ1c3aDRsT1BYOUhocGFiaXlZ?=
 =?utf-8?B?NTJoYVAvRmdCd3REdEJTU0cyWVU5dVo1bjJTS3dmZnJHdjdsdnV4bzBlbGdk?=
 =?utf-8?B?VnZpZXhVdmQ1L0huRkNITTMvOWpaRW00YkJ4cWp3dzN2Y1grOFlwd2p3dDVS?=
 =?utf-8?B?QSt5d1d3VnpxK1puU2dHNzBwRmNkVzU4NXdPbEJhb3BzZXdkOVR4QmlQcXpM?=
 =?utf-8?B?LzdNbFczWUdkd0lXTjFoSEZ4VU9VdlZ1OUR6SmlwVHRaYlRJWXZzSis4R2ZK?=
 =?utf-8?B?R0YrRE9tbFFMQlptTnlHVUp6T01tS3d3QndISEljSlRMVWFNdW5xSDF6cjJK?=
 =?utf-8?B?Y2J5a3pEUGRmSzZwbnkzWFBERENHWm9kYngyVTdBRDY5WlNtbWR0MlVZd3lK?=
 =?utf-8?B?Z2dKM25GTlFpT08vZlV5dGhaeXRSSjVrSzhnVzVpUmdzOVlEZXlucnNCZ05Z?=
 =?utf-8?B?TnlYRUhHaHZSaTJNSnIyTFQvUUhJdFZhL3RtU0JxN3hmVm5rU3ZCNE4vK3Fx?=
 =?utf-8?B?aTV5MENpcGhqUmthVjNwanhUeWNGSlpHUE9HY3ZBenBhOSsxYXl5NEY5V2FL?=
 =?utf-8?B?Q1JhN1NmSHA1SGpMK1JwVUY4K00zeDNsSW45VDg5MWVESmdrQjh5aVhpOU1n?=
 =?utf-8?B?b1VxRlJZVCt3OGlTWU5ZZ1NubXZlb3VDTmtvY29RVnd6K0pIVVY0VUhLV0ly?=
 =?utf-8?B?eFMxRGQwMmNzYndUdzcwdUtoSEVkRWxDcE5YYlNIay9TYmYyNGcxblgxdXAy?=
 =?utf-8?B?U3lLM3lqaFM3QWFJVW5CK213RTVZWVJWb0k0K05Bb2hnMFV5YXZjQUh2Ymdz?=
 =?utf-8?B?ejFUN1hPaDNnYjYvbWxnY004U0h2ZTNjL1FMbDN2eklQWkM3WEN3UTVicDcr?=
 =?utf-8?B?Z1pyMjIrbUM1bU5oVmUzSWVVVjRvN3lXblcxUmU1LzN3K3cybG5DMVdRZ3FV?=
 =?utf-8?B?dWwrcTZORlpiV1M2dmpTSmxieXhGSkV0YXdrL2xXU1hJUTBHNUlSeHc2WmZG?=
 =?utf-8?B?bmhYU3JBa1BKUjBwSWU2dk1TZWlhTk9VQnlDYmJyOXJHbjRaYzFUQUlzdFc3?=
 =?utf-8?B?b0NjV1ZORnpVSXFtZ2hsOGt0bmhFcmZDNGkwR1dKd3NUUTk2NHl4YUdBZVRn?=
 =?utf-8?B?bTcxZXRBaElCUEVyTVJGUjhlVWdsa1ZwZU04bUsxNzU0UXhOOVlMTGJEN2ZR?=
 =?utf-8?B?ZE5CN3V4VTdNbmVhRVZDNHIvYktSQm03d2NHQm5nb0xIYnFtd3hvY2lHNnlT?=
 =?utf-8?B?Qkp2QzZCUWdrYkpsemJVdzk4VmVmTXNTaDFsblB3TmVrYlpLem9BVTdtaVBR?=
 =?utf-8?B?dWlZMUtiZ3NJdXNJZjl6Z3AyL2lhc013dDhwK2F0N00vc1JiWWtycWtqa04v?=
 =?utf-8?B?WHZCL0N0WlhPRGEwTXpuODRWRS9ON0tMY1JmVytuWU5CUndtaWlSQmFqUmsy?=
 =?utf-8?B?QUF2SWFGejMwYlUwUUQ5cXIvZ0ZidGU1MTNLSXNsNnlKaDVZQ095enE4SU1X?=
 =?utf-8?B?cjBPajNkQy9memVkckxjTmFSbThtdnFFeWoyS3lKZ3hCaXNNYXhrazNkeVFq?=
 =?utf-8?B?Qll0WG1tK0JwbHdkd1djbUFVaGpKU28yaUtYQnpLenBHZ2luWDgyeStjNUEr?=
 =?utf-8?Q?MDl0xhmGzZdRcpRp8bWW3J1/UjAN3nSRgkI2VPJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1525b0be-4541-45cc-a2bb-08d946061894
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 13:57:04.7716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hvdyrhHQQtNhwXpUfDWVW5FaU9NSXeAxeVEjP5WmutJAzuHIcEXh3sX+SciAjEgwPI02tSg9MUJFiwVmjcpkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/21 3:31 AM, Dr. David Alan Gilbert wrote:
> adding it to QMP as well (unles sit's purely for debug and may change).

We have query-sev QMP, I will extend to add a new 'snp: bool' field.

thanks
