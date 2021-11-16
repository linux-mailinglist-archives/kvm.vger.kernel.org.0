Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29937453180
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 12:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhKPL5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 06:57:33 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:54753
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233159AbhKPL51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 06:57:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B65Oxv5h7OBYexujbO6NoTqLtyi5qrNk+MvHu4D4wC8Ec2DG6OVHiYuSxuHqgM/vz/23emz9bqtpV+XUKNXdW6l8wkmVE90kNxXO+VBkp0Uuuov3hzjjIFNnUkco3akB0MTYVDp643b2iEw7zwU6JTZTQMMx9o3Ckoh6hbxuKfbgDfVDLbwtTzAmYFoQC5FHnGKitV6rTmbJToTbrxUZA/dvHHruXb4Vmyu54rHTihsoynXwC63bpunzdCLGUf+jjdVxBXM1PaPfH2JtvAwZtDNdPg6BR87qo3takzNeBGrUABOrzlmlZVOz1rnqb22wCdbBVJMp3bxV9NEuDQ0vTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg95QxEyVOYUZeU0C0kuUQE6o7arvGUc3bTlVTF8BVg=;
 b=fKee1cFDQg+W7/kfJ30NfNOVqfSOUqgTSQP+UD3HjuvG6UeywO8ZNRaalcRZ38Z/C+NxhOeaewU3w3fRuNVNGTLqLE7rM1uaHL39VMIMpvA7OGGAbLJOSEriPBeQ7B0MNPfoTa749EWrcpclnHiAiVxRoiVoLe3zxRv3/MgvPfgv1wmQrCDnW5kcR9DD3Mws8eoLjpKWKP/jM1xUzAvfq4wEtYFtNX3xNda1PJLHg0ztvHyraGc0oK1qi6mmgrbAQrbr+QoliNAKlARPnSzZjQqvqyyUodwkqUdS6sPUynjrsmq+3p93LAzbqAshsghCwNhR1krVaWNTVpsWEQ+PJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg95QxEyVOYUZeU0C0kuUQE6o7arvGUc3bTlVTF8BVg=;
 b=J/30OJdB03gSq0tkOxSwjXTjvNz/QopNGoSPOLL8ns6jZZZAc+nMqSCAeEKVXOwlhleZwr94AiOs5dEDQWjJXXspOMr6DFhBZ9olg9tCPy4jgLs5Osu25J1X6QMHNndo/j2XRl/aaJHUjDq4Tl0djQsDGBqKfPDcDSU/6oJmcBk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 11:54:28 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 11:54:27 +0000
Message-ID: <64efe8e8-9731-b906-ac3f-08846c7b0342@amd.com>
Date:   Tue, 16 Nov 2021 05:54:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 00/12] Add AMD Secure Nested Paging (SEV-SNP)
 support
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Michael Roth <michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <YZN4kBG4A/Sr1kIq@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <YZN4kBG4A/Sr1kIq@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:806:6f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SA0PR12CA0012.namprd12.prod.outlook.com (2603:10b6:806:6f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 11:54:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef4fa061-c0f5-4665-84d8-08d9a8f7d74f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2768B80028596A4D458566DFE5999@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8v8aDxFdUGpxRciKLMwbMk0bx10Ifz4S+jmLi13KWGdscuZIpdwMlN/kvfbBacTsJCdOxN+ihbxdP9AkktteL/RvifMgXr85f5W/PxHBg+4HMVbFLkO6udUMZ2vUFVYKfvqd7AHxszN/WdyZG8y0I/x2AfwAtSndoje9+wmyJ2L4mUHFpM+QTfsJBN59+bdFoouR0fEg4HNCcIT0W5J6v+STHukEMdMPnBCdPlIekUottkLJ/fdzL//pZq0G5MqHhCxXdzP8fHWl4w94SPwflRg4WxRf3Lw+KCv/Xp/9q0PJeoKY4Zt3nROQk+kW/IBv5JDaBsDVei1StKri9oyGOKTARuFwn1OlmzIPBHHSQKkWTt5v41piD8WiwJaVOEGpiHNGm0mOgVHeOslH50D495tF5Jkk7Donv0MN0+DPsgX9sDE0Roalk+fqVN7DVJNBTXmxXpe1WSG/kOxpKaLvwGFq1tSmwxJo0H9/E1s/XAan3f2D928iIpvwo3HpmBnxwIJqa4i15UjEuVTKGWbHxUU4tem3ntFxxQ0K7TS2yxdaxaKzBJxxSMbTnsguKV1wWw/TrCpbreL9ULB/Dxb1tHhoSfTSVceDgRBzlwLUVVg7xnleFdHQea/XZ+TOy0itq+ccKS6Ajfyp76FgnNmVZMhujdV3NsZSb0t5BKfI0e3A8LRVyk1jFrWmRSoELuJfnVs6pg7+tcQBdOMMwbUZbaO2b3ll31IE0p35pLoa/YtvfZDtddY70lK+uZsUksATk7ML+PNP8YCd/3Vzmq6nN6kTqqzcciRTxtCzTWoIdE9CtXs1r14VsQ++f7eiXOh1vBlFhVt5zIqJXBMGQIUwtG1B8S0gaiwI7kd5E1+qy44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(31686004)(66476007)(6486002)(2906002)(66556008)(956004)(26005)(66946007)(53546011)(7416002)(5660300002)(6636002)(38100700002)(966005)(4326008)(316002)(31696002)(8676002)(54906003)(83380400001)(110136005)(16576012)(2616005)(8936002)(508600001)(45080400002)(186003)(44832011)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE03ZDlZTnVJaXpIcUJ5RVBuZTIvc2daTlp6cnJ5b2tYYWxETVdCMjNhdGhM?=
 =?utf-8?B?Z1c2YndRSkRtZFhtbW1yTW9hbWdXekdCeHZaTjJmdU4zYXdhdVd6RUxUWm5J?=
 =?utf-8?B?Wkh0eXBjNDNEWlU1VGxhbUVleUptMUt3NjkyL2xURy9NK1J0OXE5VTU5Qy8v?=
 =?utf-8?B?dHVLQm5FdnpWdFRLWGxPcGVkMEc2MGhZZHo2am93RHJpZXVZZk1ZTzZCZTIx?=
 =?utf-8?B?cXdIQ0d5OTY1eXRFSlA5Y09VUDBVOGdJRFNUOVJKOC92Z1VXc2VZUUVrSWQx?=
 =?utf-8?B?QWFEeFdWYVp5RGsrNmVOeGdvOUFOOVJ2UnV3ZWNFd3lodFBrU1N6b3pJNStp?=
 =?utf-8?B?dEJZbnQ5N0tVVlVQUEJQeUtPMTNFVEYvaWxPTy9iQ095a1pGQmF4dHJxRE1w?=
 =?utf-8?B?RXVSVFhEamVCT04rYTZCOFFpVkVQTDNRaVVXV2J3UGVzMWFUbXNsODgvRkxD?=
 =?utf-8?B?V0E1OXlRUHFDT1BYZCtWVlF4SmpoKzZWQVdXMEtic2ptQWpFUUJvVVY2Z0R3?=
 =?utf-8?B?TXhWRkNNN3BleS9Kb0lOWXFuWS9FVnczUjdCL2I1TGNyUTFocEhrZ0NtQnZp?=
 =?utf-8?B?SC9UaEJoaGxlU0NZOW9vWElDZjNHdXlsQUZMdlVsSnNNcWlOZ2t5SEFwdU8w?=
 =?utf-8?B?czk3RHF6NmtUWXo5YWJwbXFpeXN3M2xqdXNDdFRRWHBzY2Q5S3lzTXFBdkRE?=
 =?utf-8?B?N3J4QmVXczNXdlQ3U2RJNGVyTnE4cWhnTG9vc25lOXFSTHk5WkJES2pQREFt?=
 =?utf-8?B?aWdkQkZWWHRyeWM3Znk5Mm5vSUZBZ3kreUhwSFFhcjFGcEdKN1hDbVNtclJ6?=
 =?utf-8?B?VmZQeVVPWDJsS1JLY1kyd29QY0NnV2N1RVBHaGRMQ3YyZXI5L1hEM3hTelc5?=
 =?utf-8?B?czhNaklURE11LzYvc0NYWnEvUDYvOStlYS8yNjFkSWFFTVA2dFZsMGN3bmd5?=
 =?utf-8?B?aURqT1hYQk96STJFWlkzT2wvNXUvdFRXMkVPS1ZoMkhPWGNNbDRnZVdrZ2xX?=
 =?utf-8?B?QTZXbFkrSm1BNEZpTERBd0dNeEF3VkZHOTZMRXhZc0U5VzNXaGgyeGNFTFB5?=
 =?utf-8?B?QkhTcmdVSTkxdGMvVFNWTm9HNzhyaDUxb2NQOTVQK25aTEhTa09jMWdVY0U0?=
 =?utf-8?B?azdmVDhxWmFwaEVEVzNxOTVnS25BSDE2em9oK3krZkFIRnlOTGt1OWI0cUEz?=
 =?utf-8?B?ckZxTy9peTRXTFRxSlpoMnpXSGZDdFJtUHhHeGhWaURiYzBHcTZjVGViTm5S?=
 =?utf-8?B?YldwTFRiTjVkTmZJeGtHWXRKOGV6UERnbmZka09VOVVVbDNMWXFVTEEyRlYy?=
 =?utf-8?B?UWMvN0RqYUtmMnFEQ3BmTE9WazZiZllYaThpNWlsRmZqL0ZtNHkySlc5UDNo?=
 =?utf-8?B?RC9yL3VoOVYrUlhzK29xWmFud2lPdVZ4T1owZStkTFR6dFZpL1NkRFdjdnFU?=
 =?utf-8?B?eDIxd1VuRHlVNVJnR3ZsemdnT0pFQzl1N0FCMXBGbUVVZVM1QnNGRXp5VmxW?=
 =?utf-8?B?a2hwYzRWWVRYUzJkM3MwMVp1akdDaEtlQmNBWkViUHV5amlxR3J3OXNpSG9h?=
 =?utf-8?B?TlpzL0JBK2RCVk5iQjBIQ3FtNjZoK3BRaHYzV055N05kNTl6cFc2ZDgrV2lz?=
 =?utf-8?B?c21xcGs0dnI4SmVieEJBQUpQdUo0eDJBYVZRdHVMVjU5MFZPaUhpRmRiVTky?=
 =?utf-8?B?RlhBYlZvdXI3KytIRS9PdllZeEhicHdHNTlJSWJaam9sOXNXVFJtUkRycGdr?=
 =?utf-8?B?WXRJRlNYNDlBTnNUejNJQVNVNXlLTlMrWnFyWm81QitXY0JzR3hWd3ZBbndS?=
 =?utf-8?B?aWlINFNDU1FWUWxFZDUvckFadUUwZkNPR2YwVWNuNTdjK3A5NUJsT1MvRzd0?=
 =?utf-8?B?YUpQQ3F1Yy8xR2F6YWcvNmhVY0FSS0ZadEk5cG5KRHZPRzVWazdHMWdLWHR3?=
 =?utf-8?B?eXhnN0ZZRitETnIxUjBHZFRHWTN6elpJSjBLMjgzUGZMQmRqM2RZdS9Ja2pL?=
 =?utf-8?B?cDZETk5sQ05WNDVqV3RFY2RYVUNGSkNyOVRnWFgyeHdWZWw5YUZYZHllOUhQ?=
 =?utf-8?B?SVMyUFVNNjNGNCsyMVZqbVZRNHBqbXF2NzBXNFM4Y0ZJcGdoU1J4L2lOZ3Vw?=
 =?utf-8?B?a0NSK3BlUGs4NzU3Y3pqR3FUQWx0WU9DNjNiYkEyYnZMNzVsa1REc1o5TVFa?=
 =?utf-8?Q?yun+WJhg+DR723dRjEY5ERw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4fa061-c0f5-4665-84d8-08d9a8f7d74f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 11:54:27.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeZ/uCxqCVXrCOA8JBewf85BNYilKXrtFXf9ZpoKKfJwgGcF9EQCKmiHQhAPjAFP4fWvY3oHjd+y6jmFktoYvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/16/21 3:23 AM, Daniel P. Berrangé wrote:
> On Thu, Aug 26, 2021 at 05:26:15PM -0500, Michael Roth wrote:
>> These patches implement SEV-SNP along with CPUID enforcement support for QEMU,
>> and are also available at:
>>
>>   https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fmdroth%2Fqemu%2Fcommits%2Fsnp-rfc-v2-upstream&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C3506c40b7121401945b108d9a8e2c8d0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637726514264887241%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=HXdG4TmNY157Gz6qLXhAL8FufCTxe9VzSiTaQICGawo%3D&amp;reserved=0
>>
>> They are based on the initial RFC submitted by Brijesh:
>>
>>   https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fqemu-devel%2F20210722000259.ykepl7t6ptua7im5%40amd.com%2FT%2F&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C3506c40b7121401945b108d9a8e2c8d0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637726514264887241%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=AhOI%2FoQFq4k%2B6uOqYQqos6FlxE4AD1FFYfIPPiSHioI%3D&amp;reserved=0
> What's the status of these patches ?  Is there going to be any non-RFC
> version posted in the near future ?


I am waiting for the KVM interface to be finalized before spinning the
qemu patch. With the recent discussion on KVM patch we may see some
change in the interfaces. I am hoping to post updated series after
posting the newer KVM series.

thanls


>
> Regards,
> Daniel
