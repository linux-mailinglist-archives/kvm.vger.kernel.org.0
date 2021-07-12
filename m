Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498773C5FF4
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhGLQCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:02:02 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:44000
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235280AbhGLQCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 12:02:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bg8I/6LDdfVlDMV6bmRwtonSWbDixeSBdR7kXjnUk9PfOH4VhIDLBVNWsYe8ijqKH+USJLhhvE6ceTQMySF9HREdA4qnwFTVwJogNWx3b2NnyzCtZZS/aobegukqRnzldeY7JwQefx5dBn4MEUJoiqF+pK9vMsYudPs3pYIY2/5PjkrGgutFbD51TbpUVQloSX2Te0j3oTFtwR+s/rSevlM36J5XyH19c1j2TS3oWxjEHUMd8r5dVjVqCYe/vPgNbHKw1BCS4mO7OU0UQ6ZYPSWlw0s/2Wso0dIoGULUKkUifNel8uSIHp7Q46K2Lcyud5IZv/NmZCojJ8ozPXePJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0u3RTqVUM4fqypxrMYZlx0qdQheit0LNqjGQPKJrgI=;
 b=FNl+5gsQ/Y5I82M/eRcNY7EroCX0z9IfYJxfhUVj8kG+IHhsg5OvaryifoG4MYSUw2HLH4GrFAJ36H1Ss/9dpesfw5STakPqE310LdMwxQL7O/3AwE/Dwvu1BMwzQGc/grJfveM9PRNPajBfvRmgneggZyc8e81gcGR3BPritv9IXMvRxRtJZfzHT9brIanTFkI0OQcnOFbq4spHz3vgFQ1FwmaXn+BZZvPk9vUsYAiFh0fVf0KHtoZNdk5n0mH85I43gAb21p7M7FqMuwufhG6NWUZ+p6G5VByJyCG8/qGnvdWp7L8v6X4Nc1bhgQinuP4RaNVW0d8RXicIjOog6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0u3RTqVUM4fqypxrMYZlx0qdQheit0LNqjGQPKJrgI=;
 b=Zn9OSuyigDT2kZMCBA8lWuJbfVc7HUJ+p+up+BqJ/04jZMTkyD4KgC+LZjkh2t1SMgDKi4GxJNuZJ16TwY+ZXmapgJ+QvS+D7V1lGfDQs/IgWJ1oYbgo7q2Pp5y5hoSKqQ5Gr5642Y5v0uaZ8PfuIQ+yitVSL+lUpsFfzF/n/Yc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:59:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:59:10 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>, armbru@redhat.com
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com> <YOxS6R5NADizMui2@work-vm>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <14ebb720-1aee-fb3f-bd49-e41139e64b14@amd.com>
Date:   Mon, 12 Jul 2021 10:59:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YOxS6R5NADizMui2@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:806:121::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN7PR04CA0072.namprd04.prod.outlook.com (2603:10b6:806:121::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:59:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d0c7b40-c087-439d-e5b9-08d9454dfcd8
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2446828F3D79F4E8DBBD4974E5159@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DHqhhhJPrqbPF8C/nHMh8CdIottVHCm3bPVc7c7vQK7AwHagiKYelEj0t9Ah99VH5YANaGXKRrWPn3XgLyDYxgmVFU5nXO7kvGQZBCBe4imYslI5iHcw+IAQ3OCSp//NJqSUsN0jl64I4Vxw3Uf0y4YzRK5aDl2tkNU2X5Y176TSEITdwpdPR5UbsoBErH4OwR5gKm1BxIT4I8FX0B+LQJW9EYJZ4am7WSmgoygTfZaeG6lYy0VJHqidbbEnuu03azKg/bnEOekc3Ko90R0lVgbdtiNcfrAgw92mzD84mW4dBIAeL5bsbACW4HLcJ6AT1o+OcE10CPI7nj8nOoPwslDNi+hAXnNHaMlnhYNUrvsX2e53P21hTY4vWJLiVfbNKp9CnUPioypiSBobgbS69WEzVNtC7nNi5QSShZwQ53FRvvrKQcRpZ7vTwyQy+Iq/FOMdSOP6Rrd5nPnp/JeT9N2WfYzqCAojwQwMjvU1q4dR0shO0jJGjpvkHqrIW3ruzbKOQlMCMEbAxaPQEWXBt+3whHIPMEDp6pBNgbVGGJqt6vWG+NKisTDFQ3QbVPDfCdCaqYBLyvz1AOasuMxwKZY3RTI3qFeYtM8pjgOQTmznpHwJe3LvIeeHHJ1fn6SSc2hdO2wWX94x3m6ddGiPQr/VzNHPkK0KtwuwY71nhyMnWXeZbRvzksEUCmcSE8hL6QfT+x9eIQjYsXxtZN0vAQvi7vGSJQ3d/8sZiNPGbpX++w+ImIXueCGeUyzDhMLbIUaQuSigaya5Lj8A9e+MJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(4326008)(52116002)(2906002)(31696002)(31686004)(7416002)(53546011)(8676002)(478600001)(8936002)(38350700002)(26005)(38100700002)(36756003)(6486002)(86362001)(186003)(16576012)(66946007)(66556008)(54906003)(2616005)(4744005)(956004)(66476007)(83380400001)(44832011)(316002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUxSTTF2b2NGNkh5UlpRaTEydXFCVld2R05sOHluMWJxN3FmOVpWMWJ2eU4w?=
 =?utf-8?B?N2JrTDEwTUpCT2xGV1puMVNFSjQyMW1LU3N6MldCQ2JPajU0dEF4djBqRmNO?=
 =?utf-8?B?aWJwbmp0OFNTS3RJMUZVcDRMVldVcE9nejdwYnFqdFV2MTFKUHFWVmlNS3M0?=
 =?utf-8?B?ZUFjVzUwMlZqaFVqL2N1cm5QeFY3T0NlZFhoTFRJLzNCOTRhMUQ5cmpORXg5?=
 =?utf-8?B?MkR5alNNNkplazlyUXRMT0ZDSkdEUVR4ckQwUmVxbjFISHIzL2F3RmxRVXc1?=
 =?utf-8?B?U21aUnIzZnFPMm9iQWRDK0w5VUJPa1AzNlk0MVRjaXprWnE0S3RLUlhFRWxP?=
 =?utf-8?B?WHNOeG9iYUJ3cmF3U25Ja1dDS1A4NUVGWG41bkNBTXN6L1VYaFBUcWZOdUox?=
 =?utf-8?B?TWlIREU1cUdrd0dlN0tIaHFyMW02a2xiS2k0RE5RT0N3U2VpS3NVZlA2Z3lt?=
 =?utf-8?B?Wm0zR1F6c05WNXdmQlJobytNNktBbmt4NU1XTkFKdTgxM1J6ckVFQ0QyZjlk?=
 =?utf-8?B?NHJEMXY1S1dtYkRFeXdzNzR4bkNrV2JGZ0x5ZlN5dXdvNGZ1RENLRGdOQVkx?=
 =?utf-8?B?L25WK0d3ZkFPb05SV2hVczBiTGRPZnpFSU96Z1IwY2dUSVRvSmtXb2YrcHpI?=
 =?utf-8?B?eDd4YWpYbmJCUEpwWnE2VzNzYjduR09GejFjY0VsR1BmUVV6eUlMRnBLMkxL?=
 =?utf-8?B?THhKUVRrRHFYcUFZTGJsVG5YOTJiWVlJcENxayt2ZFcyU1RHMERKRFdNSWYx?=
 =?utf-8?B?Mks2bHh5WU44bUZOK3ZRcFFFOEE0QisvNTd3MTROSVBiTzFiSWVDc1BYeVg3?=
 =?utf-8?B?MnliZStiRjNtRnl0emlXNXR1ZFBtNHVvbmhIMU9hcU4rUnhPcjY1SEZNeVIz?=
 =?utf-8?B?dmNpRnRFd0pYcHFBYksvQXBWMXVSdDhDdi8rQlJ4VzZtcHNOeUxRd2hxeVlm?=
 =?utf-8?B?MURDUEZDZTRydVY4cmhNNyt2aUtVN3NKY1c4ZmwxNy93bGQvMWlsVEx6bE5I?=
 =?utf-8?B?OGIrNXZ0OEpyeUJIVitBRktHaEEzUkRIUEJjTW9aVDNTcWVKbkZ6b2grWjR4?=
 =?utf-8?B?L1A3THRnQThobWY3K2FUUXR1a3lFalU4YkE4K1JSWDk4NytDQUYwVkFJZ0hi?=
 =?utf-8?B?NlZTUzg5WnFOY2dDMjlFL3V2MGtNRi9VU0FFc3VjaFlFZDhLY3Zvc24weGdp?=
 =?utf-8?B?dmdJWHJDUGs5WVoydnpyRjZNVlNzbjBINGJQc1krYTB0V0ptUGRkS2Z2Ulk1?=
 =?utf-8?B?MVEvK3pFMnMxS1hWQUw5a2lMeHp3K3hMQ3JHdHczRzhKNTdZS3RVd1RPV2s1?=
 =?utf-8?B?K2VnL3MrWUpISGpVOXZ3cjgxQ0w2U09OcFJrbE5tc1FobW5nTXlZM29SdDFU?=
 =?utf-8?B?alVXQXNoMDZPWmpUcVlKbHAvRy84Szl5d09IVzVzV1pwTXNBTml0ZlEyNFVq?=
 =?utf-8?B?enRyTEZxV1hXSTNKS1RBY3ZjUEZZVFJCdWJKcklpR0M2QUptZlZzUmpjQll0?=
 =?utf-8?B?UXZ3dTRyNmxvNkVtTHp2RWh4SHZ6TTRtVnhqVjM4cXpiM0JqNEIrakIxQ1pk?=
 =?utf-8?B?dEU3NjJ1dzM3Y0tBczRiTGRKVEtacWNiZUFDSjI5cElyZlRqdzlnU0RJQ0c2?=
 =?utf-8?B?a3JFL01Pb3V4U1VDRlJyYmMycmVlTExmcEJKUlZ2eWU2QkhlTXpRM2FLdHNS?=
 =?utf-8?B?YTR6VHhESFJ6MDhDWVFLRDYySmhRRGZxaUhiSjNTVlY1L1FDOU1hd3hFU1V0?=
 =?utf-8?Q?3G6pomA/jW+YFBdQPPcs+Cz3pvU3eGISoQfLio6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0c7b40-c087-439d-e5b9-08d9454dfcd8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:59:10.7776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UoqQJmwLcXV38rPh8l5jYRD57D1RtRxiH3LPwo90bOv9Wd8GFzNsEuM5rg4qvkK1b14HVudfsACWUPrdlsM6Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/21 9:34 AM, Dr. David Alan Gilbert wrote:
>>
>> $ cat snp-launch.init
>>
>> # SNP launch parameters
>> [SEV-SNP]
>> init_flags = 0
>> policy = 0x1000
>> id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> 
> Wouldn't the 'gosvw' and 'hostdata' also be in there?
> 

I did not included all the 8 parameters in the commit messages, mainly 
because some of them are big. I just picked 3 smaller ones.

-Brijesh
