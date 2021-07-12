Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9262A3C6151
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhGLRDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:03:14 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:15968
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232710AbhGLRDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:03:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SddVApZePdy47TCZi+c+q7IIxGRZTDAEWqckO8LeVURiOUm7BoJnU5611REXgRNj49O2tAt7JMu71LTOUWbJBfJxgh+tX6+TAJLn546k1xUXOP8VlIqdbcl2tgBktDm9pLLg238qW0ahvmuDe3s5ll49LnT10qqWv/N/5InCQrFoMtN+1JyGXHDjUTmm1+xlON2qZVekn4c1uRIFe7B1VDh1IuPpYPOYP/DP4TFAbLe4x9QVJRDXlXHl26I0kt6xFk6Fv4rwrziw/zld8FL6h3GrEBkVdqlGPcMdK9AAibXBUU7BWD5zmaM9p4EUhoTsGG72G86o+S4PfdZqSrCW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IFcNVltQIYH2BGw7I7yaJhWGFAgmMNMj0fO9Ffwmyw=;
 b=ST8qD7iPDIEZClcLKUStA+S3uX7U8k9B58HGnVgXYb9teCVhDdLbuGZZcR2lCSPYXPWbIQy+VcbTYDAy6cOL0Q/NcT7oqAM2yOQrU7M1U9aARtvVqsf+BRfYjBNwPtIwKxUt+RGgEMfV7c3NBv+iAyjlx9p5+tvm0BKC2rSN42j2MEETixNdmd0UDtFi0ow2CeTReH5pyvorErL6X2h6pnNL6BneC/gXbALD1mOAmEUu11XLL8MB0L28p53Sas1iCSOdUfNMjdwo5K8Q85DQxzQR6X0vL0VFXD61fumjwaxs7Tii0Y14hpCKsGC6Ez0W5N1sl4q521ZixaJdF1nOAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5IFcNVltQIYH2BGw7I7yaJhWGFAgmMNMj0fO9Ffwmyw=;
 b=bBkYRJj9qEycVgyL6UmGwaWDovaenyPNjUANN7bsPssv8o1RaiJ+b7n6H+OuzYgmyOaocdaOUXS2yO1ozycmJ8PKGWBjIX613f3NcRNtwkOKmN1W7LWqGBApu+l/nZ4G+JM/q8aQv1Ijum9tvKtYYfz3J0LzhXK/I+Fey1i4xLQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5167.namprd12.prod.outlook.com (2603:10b6:5:396::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 17:00:24 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::73:2581:970b:3208%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 17:00:24 +0000
Subject: Re: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <532930b2-2a43-f4d0-8214-ea8b10c37448@amd.com>
Date:   Mon, 12 Jul 2021 12:00:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0025.namprd21.prod.outlook.com
 (2603:10b6:805:106::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR2101CA0025.namprd21.prod.outlook.com (2603:10b6:805:106::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.3 via Frontend Transport; Mon, 12 Jul 2021 17:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fd285a9-d757-4a88-9c8e-08d945568a2c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5167910C1C74ADEFC39A9CADEC159@DM4PR12MB5167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUFAdlMtkDI6sZe+R/M6lmV+FOVju+ew3QoMV18xTZ5yrou8VS4K+Kkx/FaCbGSZNxNSmsKY9MaLbCB3OP3t/3VAKkQ2GBsc10/QGC97E4ofsAE4PKXI+d7q24bsT6LVlRS3qauxfMXsQB1DiOSdGqnqpgMZbc/lsvK+Lp+wxi++hejwAG9w++IhG2rbcgG0HFVF0vJ6A1cpernq3u7xC8BWd1ba67AG1eIHuDOWsFgT0CxdTqhjFQTWsPCi9Cdnhp14VWz8EolsVXLQdiYy5jLNW7nN3B5XjhaVoz/PnF3w6DeVweHJersMlE7O/4soWhiI2JitwU8Z0kPEthXJ0vmxlEkT1AXlLgXTU/zxkYORprowlJXmIrkXSPDfjejKwjIAOpfGeA8m47lgIblRQx33t7qmIW896P6uWYh6BecdVxQU+ppai1OizK3Tv0GfGT/flrrHzjAlZQlvfUm6v63tOewpjfBwbWXaJ4IJbkGPsqQdmhY+M29WIVIQJC2H88sO1uJCgnxXTV1YmlvwAV2f+FZVlhgg93lDRqgNyzKJrWrYWGnt3InkbPVCGrpcYYJ5nMKSUznPgcRGjDBxWqf8aIkkFzMGOudGLV1Ne+owdSF/GfNVf8NIXLfIjOTbBkqI/g393RJjL6ZXsVFiW7BG3ORL2WkOVxpWFEhN6z3bNmGXhApa1iGNvfqA5ksrFnzCKx8HYORYHaw3H4XatviZisgVTWKzkZYiETdekIbpIQ2D55u/ifJP6KK2L8HqGfHaBuQg6k+i7tG/2mxN8ptjHWlhmt+7UVPQliQ73fTYv8IQxiscNiBZqn6qQCLSQvJNdA1RhvJ/rxCYjklve43VonqiVRR5hIuDD87KsxA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(53546011)(186003)(36756003)(16576012)(31686004)(26005)(83380400001)(54906003)(6486002)(7416002)(86362001)(966005)(4326008)(8676002)(31696002)(316002)(478600001)(5660300002)(2906002)(66476007)(66946007)(38100700002)(956004)(66556008)(8936002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amNucEY3cmpvNE51bTVPUU5KY0RZQkxiSVh6TjRCc0hDbGZwREJoelJZZVQz?=
 =?utf-8?B?QWhpV2NCK0VuZDdPMWpkbEtSbi9LNTc1NFlkVTR1enB0TWFMQWxtSmFXTldT?=
 =?utf-8?B?VEJzTUp5L1BsdldHQVZsNDA0RGRaUUhQTWRrNkhaQkRzRkE2K0NHanB6THZR?=
 =?utf-8?B?enFSV29UZjFJNm5YU05VcEtkbFhIWFRzTkdRaitLeXl4Y0pJYVAwQlQrYXFj?=
 =?utf-8?B?R3VRZUNwSGtFU0VLd2hVTm04NW5aK1RuLytFNXA5amdlYWJyMkIyT1JzVkcy?=
 =?utf-8?B?THF3TWFQOFZ5L2RhL1NBbzJQZnhmMU1SUjM0dzFsaExFRDZIWi9JL01tb3RR?=
 =?utf-8?B?d0xuWkUydkR5Q3QzZnR3TDZZTGNvRC9FcGUvMnRzdlpkVVRrd0QzL0JjdWlN?=
 =?utf-8?B?T1ovWHliL0RteEM4cDAxNFVJU0RUaHVoMWFpN1ZNWGtUSGI3S0JOQ3RJNlZM?=
 =?utf-8?B?OFFxdGdMQ0xUNnlVWldKSUpGMU84Vm5ybUhSTGJNN2NQa1FMdTNYaGpMUWVQ?=
 =?utf-8?B?OFl6bzRTRTdaRGdaa0s3dnpHVVZESDNYOFg5ME84U0EyU2VtR3ZTdE9sZHFM?=
 =?utf-8?B?RWJ3WlJnOEFLSW5TZUVnWllBb2JzN3FVRE1HM3ZBNUUzaThaYUtndmovQjY3?=
 =?utf-8?B?OU9qTklOaHUzSjd6ck4wemRjZHMvUGY2bkJqL1IrN1JrYTdJZDNwa01WUitC?=
 =?utf-8?B?YVd6V2ZmeHJXQUhOcEJpYlVseFRjUmVmQ28rc21lNkd0a2kzeXFLT01Kbzh1?=
 =?utf-8?B?aWZ6ZW5ZR3l1K1ZtSTVmSWF5aFVyeERwUWtBYytWaWtJWkxZVEM4bGdVNTRY?=
 =?utf-8?B?UGlyV0YwbzZJR3IwRkYxL0VJS3BvN2YzQVVVbE0yWU5LM3VzTk92RW1WaFl2?=
 =?utf-8?B?b1hUK3BoY0RDTWMxb25WNG9EVEZhbEViR0JoYUlzRk1HcW4xbEhvQWVENEdN?=
 =?utf-8?B?a3oxTVk0M3R5UlJIN010a0NjbEJRbTBuL1pPd2FyWVgxbmNvdndzM0NzZ0hB?=
 =?utf-8?B?Y0IzY1YwUjl4NlV3MmJCM2MzWE9ta1dTb0VJWVhmT05UalU1OVdOSnh2bW5N?=
 =?utf-8?B?bmhiNU1IY2ZFT3VaUW1iQlZkdkpsYVFJK2V4U1czLzJ2S1Vjcld2bWhRL2Zo?=
 =?utf-8?B?Tmplbkg2R2JQYUdpQXozSlNma3l4UlJSL0dWVEN5Q2RQOUFJRDgwcjhTQmwr?=
 =?utf-8?B?T3Jwd2VrRDhzVVlJbHJvL1pwbml5N3BhQ2pyR1JmTGVwWjBJZ2ErRk9JM1FT?=
 =?utf-8?B?K1FsMnZzdkJUaUdLNm1rT0RaU0hNR0JnanJYTlJTVVRidFZLRTVjSWE5VFR1?=
 =?utf-8?B?MmJSTkRHWHFodXhEbCtQTE9seUF6SjNYSHZoZUEvWm1qTlhPL2dlT1JLYWR6?=
 =?utf-8?B?WUthWFhXTFYrNWVtODlBbHJjSW5JV3RPaW5Hci9Cd2YzSld1eWxqZDQwRzdY?=
 =?utf-8?B?RVBrY1ZVS0dPUXBqUyt5VkgvT2tIem5jV080UTFBQXBGTzkvT1N5NlRBRnZ5?=
 =?utf-8?B?OUtNRFpxVmJpRGFTRG9oaFM4TityeE4vaStvYWYrOXkvR3lmb1hBQ0E4R1Yz?=
 =?utf-8?B?Y3N4bVdmTk4yVTZlME1Zd3ArMUwvbzM0Nkc1U3dKSUtPN3YzTGRIak9tRjEw?=
 =?utf-8?B?YmhWOURZZzB4U0VDR3FnVkczUVN1bzhtbUZYbWNnQ2xkMXUvWkFHYzdOWm5D?=
 =?utf-8?B?ZC9NTExmby9lb3RpMm9xOXU0bS9Fd096aXpIa1VFLzBoUVk3MUtGSk9CeExp?=
 =?utf-8?Q?k6vv/MbCPzBJjxXezigkiEZh26dnDntJF1hUge2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd285a9-d757-4a88-9c8e-08d945568a2c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 17:00:24.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SkwOEqvK5gHTU3JaNYum1CEsYWeqirnFdS2t+6V79f9qw1gTAjtwonsYwLdrrSUzWa/aQR4bW+rplYZ0CB3KDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5167
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/21 4:55 PM, Brijesh Singh wrote:
> SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
> new hardware-based memory protections. SEV-SNP adds strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like data
> replay, memory re-mapping and more in order to create an isolated memory
> encryption environment.
> 
> The patches to support the SEV-SNP in Linux kernel and OVMF are available:
> https://lore.kernel.org/kvm/20210707181506.30489-1-brijesh.singh@amd.com/
> https://lore.kernel.org/kvm/20210707183616.5620-1-brijesh.singh@amd.com/
> https://edk2.groups.io/g/devel/message/77335?p=,,,20,0,0,0::Created,,posterid%3A5969970,20,2,20,83891508
> 
> The Qemu patches uses the command id added by the SEV-SNP hypervisor
> patches to bootstrap the SEV-SNP VMs.
> 
> TODO:
>  * Add support to filter CPUID values through the PSP.
> 
> Additional resources
> ---------------------
> SEV-SNP whitepaper
> https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
> 
> APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf (section 15.36)
> 
> GHCB spec:
> https://developer.amd.com/wp-content/resources/56421.pdf
> 
> SEV-SNP firmware specification:
> https://www.amd.com/system/files/TechDocs/56860.pdf
> 
> Brijesh Singh (6):
>   linux-header: add the SNP specific command
>   i386/sev: extend sev-guest property to include SEV-SNP
>   i386/sev: initialize SNP context
>   i386/sev: add the SNP launch start context
>   i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
>   i386/sev: populate secrets and cpuid page and finalize the SNP launch
> 
>  docs/amd-memory-encryption.txt |  81 +++++-
>  linux-headers/linux/kvm.h      |  47 ++++
>  qapi/qom.json                  |   6 +
>  target/i386/sev.c              | 498 ++++++++++++++++++++++++++++++++-
>  target/i386/sev_i386.h         |   1 +
>  target/i386/trace-events       |   4 +
>  6 files changed, 628 insertions(+), 9 deletions(-)

Don't forget to update target/i386/sev-stub.c as appropriate, too.

Thanks,
Tom

> 
