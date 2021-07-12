Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420503C5FDA
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhGLP7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:59:33 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:43105
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230394AbhGLP7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 11:59:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJUi3Ggm/r6WR+WZ4kL2cji5G2BLgoDrbivwYqXpC2RnkDq5K2GoKDTpVAVdKPqWq6Z+R43UAzlJgSYN+oWEqSFKJokPMLSQgSxtQHv+2UkgsU3No/Vfr+G6olRUcl/hAWiOYMDUkSFfpeXoVlHntFZjDP5dQOxVByNnm2vw/IczmJYuK+FWs42QBSGO1Ult058OgpZj0eIgVwmkI/LYjolTooYlSlqTFQ0l9P4k19gTR3eNCXjATpF058nvFEKRcgP/HoQa/pIXEXkjd3A8+mzEPLYrElg6oQBRQmQbSpaelxwXQ4rTPlFIEbDnPpWmof2IlDTTfc0n0P+m517cIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXQuCxC0yocQbPXY7Pl/p/P4Fsaeo/luRhzWiB48UEQ=;
 b=JHMEODBAmFoWB89yy9T3eQf+7Z/DYKgOuZaGPsgusARJyl5jsOeFrqBVkNfLK2bJEtXuLsv+AHsA17FMYWqtMadcmGha0UiSofyN/ckf5qEsv7v9SuHwA4cZwT7vbJfPZB3Q8qKnzIgzXEOvz0f0OHc8Be4PYMPHM2feij4T73vEt1xr6zJ051YFXSxEtEBHZdP9XvUiXlev7r4IGVHGV5OlXvng216/F3rLGIy1r94hPFDX4PWQkHYT0ZoDhNLxUr2kajNfRLsnIaYzpYOUlF0skoQXAUUgLpU2h3APtGEDvqhHD+4XH90SU7gS7HBLdHCZAmzTxgAx7/lHLkt2Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXQuCxC0yocQbPXY7Pl/p/P4Fsaeo/luRhzWiB48UEQ=;
 b=qYz7fFexRuuBn/eaukuold/bQ+0GPMS8eoUkQGbDHbvR/XJog+OM666qfrppDBpr0msancJEFgvmIY3EiQSZBMd+EL/9/X7CpKzHAbLcz3nbT6kMJtYMI9mBhFAwW3tUa0D3v3G1RrwuikapIVJxzHUhyTKK1fiIBIkOlknOENo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:56:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:56:42 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com> <YOxVIjuQnQnO9ytT@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <cd63ed13-ba05-84de-ecba-6e497cf7874d@amd.com>
Date:   Mon, 12 Jul 2021 10:56:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YOxVIjuQnQnO9ytT@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0002.namprd06.prod.outlook.com
 (2603:10b6:803:2f::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0601CA0002.namprd06.prod.outlook.com (2603:10b6:803:2f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:56:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f50f62e-128f-42af-ef93-08d9454da479
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2782C5C8E325FD43910F2B17E5159@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cHTn/7XTBc9WZqE6Mk1xdi74N5aRt/1pZZXUjcKdf2/cc7pEOM1OTT4VMTyLXDc6fUHKNFFu79kaxIOngoAYZCI9kWKEZH4jZKhQutyNJ0AHlsf7SoCUtdzjoWBRwoAePTIQuSNy1Ac1nretz/epabOM9GyTYjiRcpz0xmo4as4Np844SWMTF+Vd5Uy2Mi9Q4n0pZE8FilWGKoqDGkiAs+H5mpdN19HXjtaCWbgm0ys6TYuRru1hGHaga+2BhBOTdvfcegkirT5+WCf09+XpQO6T7CcxvWOttHrT1riYSCHVb/X31sb+gZYOJXMS4YY94jneRKOBsovR270FWBzmWwon9H+MZ+K6/LSSqLH0EAEsHK1qxjFWjj3Ja3SUa4UUMt3piBHzW+I4ebErGOgANcRxPkOuqU7+bLo6TTRRHbUZw0QVcQDYhkT8ZdWUbzTweJXKqJL/bQxxUqBHACtbj/DrfdwvVUph2wF5vhTkArbYI1ezzaCmTZ6lem3yLHSa2XdN9DZ88W56afNvcqxnK2sSH8Lk0TSR2csQLzQ574MCmzU8y/qs738wYYP8RPjVzMgHhE47Jm3B8THzQRFLs6kDTBTNAZsbBsCLshJmn7QwoLUFygp3dioHx8x+2j2qYB1X/xMcbpVxMmFurY9PsweWYP93OT3q2+OR/Pl4T59BRpNUsdh+N5uoem2FTIBmkKVE7kCK1jbyZmmXxl4WgS5BNEgGZkLwl8HmrRpngwjZYmztt4SatUKNYRGyt57JtxjDiIdGzXe4TQoALOHZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(86362001)(5660300002)(186003)(66556008)(66476007)(26005)(52116002)(66946007)(31696002)(31686004)(36756003)(53546011)(478600001)(83380400001)(6916009)(6486002)(38350700002)(16576012)(44832011)(8676002)(4326008)(2616005)(38100700002)(956004)(8936002)(2906002)(316002)(7416002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXppbC9sTUl3QlJZNFRsbDBtTEhuSC96YXl1WENGa3JBcnExZlZ1dEUzK1Ir?=
 =?utf-8?B?STdrYjRLeGQ0VHo4cFlyaEMzZytiNEF0c05Yd0F6cmVQbmhKZ01HKzlZV3pn?=
 =?utf-8?B?UXVSdHJqcW45NjJOeEs5UE5CbllxckVZb1dYTkwxdWIwNjVYQ3JubjBvQ0M2?=
 =?utf-8?B?SGtoYS81aXI5TXN3YjFxVVVNWGdxTHlsaW5LNnNxd1VDQVhCK1E0N1BKeUVL?=
 =?utf-8?B?T2dzaW9UeHV2T2h4alIybmw0VWFaNDhqY2pLN29LZHROSS9kK21tVXlSTldh?=
 =?utf-8?B?RjVvWFpwT1dibDBHZldJeithZXZpTDNSdTVjaFhxckxnOGQzU0FiTC9Eb1Ba?=
 =?utf-8?B?cUhKSUhyR2psU21lY2ZYeTNkK0xXYnJqdE5pR0FjRjBMcDYxQTIxakRieGpD?=
 =?utf-8?B?TDlPSFVTYnBRbVlyU0MrUWZ6UmZOODBWcVB4aDFoUUlKVG9WVlhwYTBXSDFL?=
 =?utf-8?B?a1JwNUJCWS9rOEx0VjhyNnFnYUdEajA5K1VSNGcybXBPcG02MisyMjY1eDlM?=
 =?utf-8?B?MHFscmJ1akNhVlNzNVYwT1JYUHA0V0RFSVBaekZXY0JvOCtyZXg0U1J1T1NF?=
 =?utf-8?B?UzhSN0dScXVFeE1PTnRsZUFiRzBRa1VzQUYwaldwV2pMUTFmVnVySEcvQk1o?=
 =?utf-8?B?UmNRVWZFYjBJSnh5Y01vWWlPTXM1c3hXcGEvekdlaU41bThxRkhpRXhMWVpx?=
 =?utf-8?B?Z1hzZHJJOFdvb05UcW1zWFdTZkUwemhPZ2dIYnRHZlgwS3RKTVY0Q0Z5WE5H?=
 =?utf-8?B?ZVZHNHNpdkdkZEhYQ3dqaGpUM0FpRHZ4cXVQSmhQODJWcVB6NjRQbmZ0Tjdi?=
 =?utf-8?B?bFF4REIvaXlUZXY1b1Q5MDRyQlBGbDFiTDIwdmJlVmp2b01OZ0VUb2xSaE0r?=
 =?utf-8?B?dSt0WFNoRlR0WTl6ckhjWk9XWHRWVlFjU1BFOXhJZWtSRmRZYmdjQ3pCNmJX?=
 =?utf-8?B?QitZMGVrL3NZbXZEZ3ducmZ3c2hjODFzZlJNandQaGo5cjZhSnNQRm9OQ0xp?=
 =?utf-8?B?azRMc1JTWlNOU2FvTjd2V3pYYWVTdW5sOStXcHlzUk5uV3F6d3o4UVZWd3NS?=
 =?utf-8?B?TGYzbUNUZVZiMENRRzRJRmhaMGhyd09wbXptTk8zUjAydVVsZHlweFI5ZTJT?=
 =?utf-8?B?bFBoa3R3UWRXdEdJNXJyOXlNbnliYVM0dWduc0t6ZkF6cHBaQitDMDYwSzhs?=
 =?utf-8?B?eDA2WnNteVAwb3pBN2ZpSHU2eENxbU1UdG1mSVAveS85VHhMMWZ6L2wwUXdF?=
 =?utf-8?B?Tis3amVkcXgveW5paVNMM0huZVpDaDVVTGg4L1JGZEtKM3NjT0FqNXorUTVu?=
 =?utf-8?B?bWlEejV4b0ZvYWg3T0s1STh5MDl6a3RVd1JDb2pPUmZBQzMwZ2dVVnBldFZW?=
 =?utf-8?B?b3E0b1V2RHUrZFIwcThCNlVyY3BuUXZ3V1ZYK1NMQVNVd1FhcFozaksrQUVV?=
 =?utf-8?B?RGpEb004elFabTRpWVQ3ZXFIYmtGMHFXTkhEc2RkdTdqL2FzWjdoWWdQU1ps?=
 =?utf-8?B?YWtUcS9LaGhub0NSZk5ZNXlHWkM2MDBwUmRmNUJVaVBoUVNvaVgrTHU5dGtJ?=
 =?utf-8?B?OEFYbTE3VnRXdGFIVzhnajNIQWdoZ1lwTXpYMlRqcFllUTRQLy9RTURuZkhZ?=
 =?utf-8?B?ajNjeGtUTzJOdXpJcG1xNFQ0a3NvOVJTbnc0MkZBTXNacDBTR0NlR3pndVJD?=
 =?utf-8?B?andIaW1kUHQ0azhqalZUalVpME94OXp4RlpQbzBBblR1SUQ1RHU1eUtIMGlZ?=
 =?utf-8?Q?FZIQUGqeTxE+I8TWkwBQZjrl1lPaAGXDpHbPBJ+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f50f62e-128f-42af-ef93-08d9454da479
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:56:42.5028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkLi7z4aUvQcSF8CrM8Z3G78TnuRQRrK2ObeR/xK9yI8s9Htu/sN2oycEhNsn6TTkQjq5xoa+IFlx+z9rxBVyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/21 9:43 AM, Daniel P. Berrangé wrote:
> On Fri, Jul 09, 2021 at 04:55:46PM -0500, Brijesh Singh wrote:
>> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
>> Passing all parameters through command line can be difficult.
> 
> This sentence applies to pretty much everything in QEMU and the
> SEV-SNP example is nowhere near an extreme example IMHO.
> 
>>                                                               To simplify
>> the launch parameter passing, introduce a .ini-like config file that can be
>> used for passing the parameters to the launch flow.
> 
> Inventing a new config file format for usage by just one specific
> niche feature in QEMU is something I'd say we do not want.
> 
> Our long term goal in QEMU is to move to a world where 100% of
> QEMU configuration is provided in JSON format, using the QAPI
> schema to define the accepted input set.
> 

I am open to all suggestions. I was trying to avoid passing all these 
parameters through the command line because some of them can be huge (up 
to a page size)


>>
>> The contents of the config file will look like this:
>>
>> $ cat snp-launch.init
>>
>> # SNP launch parameters
>> [SEV-SNP]
>> init_flags = 0
>> policy = 0x1000
>> id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> 
> These parameters are really tiny and trivial to provide on the command
> line, so I'm not finding this config file compelling.
> 

I have only included 3 small parameters. Other parameters can be up to a 
page size. The breakdown looks like this:

policy: 8 bytes
flags: 8 bytes
id_block: 96 bytes
id_auth: 4096 bytes
host_data: 32 bytes
gosvw: 16 bytes



>>
>>
>> Add 'snp' property that can be used to indicate that SEV guest launch
>> should enable the SNP support.
>>
>> SEV-SNP guest launch examples:
>>
>> 1) launch without additional parameters
>>
>>    $(QEMU_CLI) \
>>      -object sev-guest,id=sev0,snp=on
>>
>> 2) launch with optional parameters
>>    $(QEMU_CLI) \
>>      -object sev-guest,id=sev0,snp=on,launch-config=<file>
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   docs/amd-memory-encryption.txt |  81 +++++++++++-
>>   qapi/qom.json                  |   6 +
>>   target/i386/sev.c              | 227 +++++++++++++++++++++++++++++++++
>>   3 files changed, 312 insertions(+), 2 deletions(-)
> 
> Regards,
> Daniel
> 
