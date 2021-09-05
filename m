Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1D8401014
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 16:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhIEOGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 10:06:15 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:15617
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229566AbhIEOGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 10:06:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbU10Dw6OtrWhChz4tsDmj7qoNa8JfxjTBfSWcHikC6B4tyUzwqFsPU4GtLu63zKcImkJYF2gCIkvcBiXEMEI4IIjvnufvcxhRw9x0iuhd8Bqjkze6j+2nsX39gtSvC0QStfxqn6UXgFq8xCEAVkWdiLOBxG/qS0Q8od82qcZZgGVHqBvm32y4j1U3H45aQxs4nh2mA1ryAHBozoKgI7JYoYRZgIFYi3TNj5ofi5xlY+cKvgxHC9J69T4vyCB2I3oDl38FeoXVqRZLW2ld5FxrPg5jTmXfYIGXHAGge1FtkhcLkoOsgzQa71+j6e4dF1NH1Asjh3H7ZL557/y/o0lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IsCAe7KGAJHO66n18qZlHUxNzvVtyDG8pgp4xaABFwc=;
 b=dnHsnq0kimqwvlyZ27Jo+M1RVYX69YYlTHnEPzYXDBORPWPIOGbBJDLQ9RZEWcLJ0jrTCDLimg6wTCjyiC/6BxqtqYjzTCOb1uvn/aC8+mUESsGFy/66iKEoVeT5n9fCZwiLXYmpL2VxVXgVwaZ0mREFtgMlFSysXTjhlykceiqSsC8fVIOWr9kSOX13oMkS2A9GSKAw9zAiXdYPtgb1ACd68TwuXXzQJRI6RRGQiQ87lGc7JnTJUsEpTdrl6AyJU7ahyjh2wu8q+XHakOwvvh9asKTuZX924tDa3SkKAkUzLFSiBeH4qDQhj0velKGJrW3xVqNVDKrg6MPNCM5CUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsCAe7KGAJHO66n18qZlHUxNzvVtyDG8pgp4xaABFwc=;
 b=lY2hr9AZTgcyV8vUmY9nc1SuuRUSjccbQ8mi1bxnPckLv8V4Q94CHUqR1RyA3cVAt9aEnRgSs7jqPUrHnhWt9vcS7ZsazT92Z/8gPXbbn9uvHLSPJELaSV1ETATj4fMrQ3cFpyqERe68sUVnJdXXzGmKAo1pXMLDlraRDLqpgMQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Sun, 5 Sep
 2021 14:05:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.025; Sun, 5 Sep 2021
 14:05:09 +0000
Subject: Re: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
To:     Dov Murik <dovmurik@linux.ibm.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-5-michael.roth@amd.com>
 <7a35c637-eecc-7897-048d-994aeb128549@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <7590b96e-49ec-849e-93cc-fc0346a3bada@amd.com>
Date:   Sun, 5 Sep 2021 09:05:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <7a35c637-eecc-7897-048d-994aeb128549@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0204.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0204.namprd11.prod.outlook.com (2603:10b6:806:1bc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Sun, 5 Sep 2021 14:05:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33ea11b-24c6-42a2-27f6-08d970762bf5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB442960C5661653BE779B7F77E5D19@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOPj2jKsXHByCoK4hLn20j5amr5c/g6byY/2Lhd5Pw0TkdI+OPjov6Ev5KQjnLvmr1Cxd7ebefgNi6zUOM+gWxCPeLGusxYyrqUIW/wgpj5app7zAc46KQ7cEqyTF00FrExWs7XQM4Mf10hcvhbfIKfbyb4rtfzrtTJV6Utz31NwZ5vD+S/onbzTkm25BKxdSneQ4ZEpSoCK7+TuAVn8tplfSCJSVy5g8uaFN5wyVRlG6jqyZ3Ebv5sRx6kWgEwMQjo+81hhS9MW3j+JUz145Yq3mG9nnDfMg2F1rjV8v4gEWTxAi5F+zQUa/G2zT/51lbVX1jb7xTOOpzlkE+wlDOGdc1ZOSC9NUBW+wjQ9xvMYYsOgoov+e3mM56H+EPpDk22GsWWPGf8fl0iTWGVY7BJFSZv3JeurfoJXAC4o1M2rCupAMPnShhVHxlBcrlZe24HXOk23PCqgWQdKIhElG57u0MVXv4U/rU/v+r/7ZXQCA5lvFpKSY4mQmzo3+96tFoDqksPkb2A7JkWlP60SqE4v6Unw641shl/jfUh4vfJoSc5ygN7ZSqTU88FmgCJAklfQu2iKve/CFarfVdDzqt1n44AyS2SWdcrZRkoe9mSWL7/fCV1XuLuDN18XM4QzyWSc8OvxzsntvdmzXuc7m6psMw5hcT+6PAANSF/04Z+htNY+KXlNjRkBOIDKjtAYi6OvcSGtV9C29f2vGsihtPQoa8zWiTsRXxTXKJ0mVYCf477TsbnpBAHuF39tnNOJt/xIC6pYxeWI4TgWnSvutrSTh6yG1DcjXvs+vek3UjiR1kjYw1tfeoH3gZ4oyKag6SFROQS/yTXkFXmsJUMncebYTXHoJrP9YBeixpnyUXY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(36756003)(478600001)(86362001)(31696002)(4326008)(8936002)(316002)(8676002)(54906003)(110136005)(956004)(6506007)(186003)(53546011)(6512007)(26005)(5660300002)(66946007)(66476007)(6486002)(7416002)(2616005)(66556008)(31686004)(966005)(52116002)(4744005)(38100700002)(44832011)(38350700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R05ydFhvanRWREJhOWpGUnFIODhZSzVlSnB4NWdXNUJjd1RuUU45QnhaU3Zy?=
 =?utf-8?B?NE96ckdEeWV2cWFiMEduYU9hUTRzNzQxSHRxWDFXeTVNbnZDS0lpWEFMb1hP?=
 =?utf-8?B?M0lsR29YVE1NRThJSGhDc1pEeHF1cWtZNEpuN1pYMkw0S3k4M1FIS3BFbUcy?=
 =?utf-8?B?ek1oRnBacVNlTXh2YWdwSWtXT3g1VUZYZW9vTmpkamZBN2dDaEJiSFdWLzZN?=
 =?utf-8?B?UTR1TmhYWVBoT2dlbk5KMUo2eEtHQXg4MVRaUlN0LzVUVmtjZDZNUXlLZnRI?=
 =?utf-8?B?WEF4SVBFZzBxbG8yNHFEZWhHMm16eWRxUlZZTXVIQ3h1QmhYaVVvOEV0YU1Y?=
 =?utf-8?B?a0wyaHRxYXpOeDJIY05QS205dGhFNGNvYjg2a2JUOUc5MVc3ZHpudXd5UE1U?=
 =?utf-8?B?TEhFeTdaYlBUcnFma3ZiTDVuQW9EVFFQWnlHSUdYMm1wSVlWRjRhNmxTYXRS?=
 =?utf-8?B?ZlBmUFI2a2ZkRGNQcW95ZkZ4WXBDaXdsSSs1bGUrVWswaFNKSHNEaWkwcVZF?=
 =?utf-8?B?V2pTcFNNWC9KQTNtWHVUOHV5NlUybU9jMVBrcndZYVZ1UTBXMjYyU2JuVXow?=
 =?utf-8?B?emxvV1V2VnJjOTZuN1VPSWJKeHZQeDBUSnlOYkpDTTluYW92ZVl5cUxRMzJz?=
 =?utf-8?B?amkvckROUWg2U1dJWHNtUVpZci8zQjJCVGxVUUc0VXkwTmRwYUtQZ2txNWZu?=
 =?utf-8?B?MnBpVHlTc2RpZzlGdm52OC8rVHZSTkhsZlh0MXlDbHlwcmtJOXErcXJkUGM1?=
 =?utf-8?B?TjBUVFpPZDUwZ2c2ejllT2VueCtDSzV5NmQzTE5GRWZZVTdMSDBRcVVlYXRn?=
 =?utf-8?B?RTZtWW1hWExZNCs5RlZkbUR3eGFXM0JmaFBpWFU2T0RXdituRFEwT09BSGVF?=
 =?utf-8?B?VTdGVVhGUzZwUHJhTkFTRHYvUDM0Q29SdFgwT1QrMVhGY2ttTklvZE1CWU9G?=
 =?utf-8?B?bkRHQVRhamt3WWpXSmJuRFhMc0xvdzR4anVQckdueGdCenJJWnowY0xleHcw?=
 =?utf-8?B?bTYyTVJQZE5MOVJqYTF5Y0Rrd3dMdHJrUFMvTnA5N2MyVlV5dFFaZjZ2THFT?=
 =?utf-8?B?YkpYOHV6WC82TUJneU9ITVBxN2w5dG9KK21nOUE3SWwyV3BVTUxGdlg2UjVW?=
 =?utf-8?B?UUpxaklWbDFod2p0L3J1eUZHejIvTytRR1NJWWxISWJONzZ3cGhLand3Q2xh?=
 =?utf-8?B?Zmkwbmg0MVRKR0Q1a2QxblE2Z0xJWEFBcVlQM08yeHpFaGJ2OGJ2NzhKd253?=
 =?utf-8?B?WGJwdmZEdnp5cnVEZkJ4eC9Cb0Uyb2M1NHJIeEJoNnQrUGdNamErOExrdFg2?=
 =?utf-8?B?N0x0ekg0YmtMb0w2c3dWRWRoZk9pSzhZRitXaE1tbG9PS1EvT3RNcUsyTzU1?=
 =?utf-8?B?aXVIQUJETUtWa3o0RGh4ek9rTUpYMmlKeDFlZmo5VUZnUEdUdW9KenZ5OGFo?=
 =?utf-8?B?WGNLS3Y5Qk9RMEN4QTd4b2hYMXZ0b0lmUTFUd1h0Wm1XeGNFZCtETzVRczFI?=
 =?utf-8?B?dUphdm04UEZ2dCtFMnl3TC9kU3ZVeHEzd2MvVUgyUFdNdG9VMVQ3UmlhOXdm?=
 =?utf-8?B?RkJPWE00cGVNUzJjTTVPMURlR2JZeVgzTkgybzBhZDZMMTUzTlNQTTV6RXFJ?=
 =?utf-8?B?WW14VzhxK3NJcElzdkcyR0t1WEdWYXNVMFBFRlZidlBKU3RVVDk1ZWNzTFl2?=
 =?utf-8?B?a1ZRdDlYREU5SDYxOE9Wb09vM1hlLzgxOGNwc2RrUjQ5am14dmJnRFduOVZ6?=
 =?utf-8?Q?ivI2RgdJLrzcbiKwZ2qNj5v7ZbdFEyiwrZAEpGL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33ea11b-24c6-42a2-27f6-08d970762bf5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 14:05:09.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qd4zk4n7vTZXCrfDT6T7DTJ5Iuz8+QoPGXkeFgs0YihwcZ+ofg7R4OqglQ3r7RtZJGmT4vHffiFq+b9TV203g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/5/21 4:19 AM, Dov Murik wrote:
>
> On 27/08/2021 1:26, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
>> the platform. The command checks whether SNP is enabled in the KVM, if
>> enabled then it allocates a new ASID from the SNP pool and calls the
>> firmware to initialize the all the resources.
>>
>
> From the KVM code ("[PATCH Part2 v5 24/45] KVM: SVM: Add
> KVM_SEV_SNP_LAUNCH_START command") it seems that KVM_SNP_INIT does *not*
> allocate the ASID; actually this is done in KVM_SEV_SNP_LAUNCH_START.

Actually, the KVM_SNP_INIT does allocate the ASID. If you look at the
driver code then in switch state, the SNP_INIT fallthrough to SEV_INIT
which will call sev_guest_init(). The sev_guest_init() allocates a new
ASID.
https://github.com/AMDESE/linux/blob/bb9ba49cd9b749d5551aae295c091d8757153dd7/arch/x86/kvm/svm/sev.c#L255

The LAUNCH_START simply binds the ASID to a guest.

thanks
