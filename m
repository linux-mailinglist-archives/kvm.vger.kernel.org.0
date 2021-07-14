Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B22C3C85EC
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 16:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhGNOVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 10:21:06 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:47713
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231817AbhGNOVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 10:21:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it025ZpL8K0m95t0HWNAVi7ALncRGeVbMyvZ2K9ajpCbhT7kw6w0AEU8IaP3aLNALbh/1iqqJXgq2sibj9/aknGYgdfbvtgjXoGkENpQbS55pGK1xgjB5jD+8tYcccT99u5fGURIxiCCjTAKY4OvE1rreaXEE8lnTw+fyDxSBWCox/Tz3UOJIeWQBu6VTBQ9N6QuAdsenbZzVxua/1CPa8L4hwPki4mb8cqO767/SSfIxVm9mMbqs7KTBrFd+j0FmpIMWqqwWHEtZY3W4PY73MjmFYU7G1EUbzkeG2NvcQfNxwrdAUp+UV2qvvoybdtQb9EWRmr7K4MXtp15tidhTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=We0hAltPWuTiM1Ps80dso2MNdYG5l/N00m4Hx77CwCA=;
 b=dEynwfJMR3Qq5yXiO0dTVxDzFDH2cZujTLqK0kvBwIH8MJYUS/wLbZ3Ek2ysoLmiJXkn5SjPuEPs/cGU+fv9QrmQzYERP+4fkhT9xxKGWp4h204ZhBzzsXlenBzGEy8nRZ0QAismbtD/6LgRMhkYtWYjuRpKgni5tYlhTzpF3gWduD26qabLWouS7ukqR/25AubaS7p8wsFOFcgIDjh4DIGaVSMtFZO7RhzjkugCq2NAj9I7ZVs5G292lx0SwcSckpaYyFIfEXbEP9IqR1h+syf2/IaU5rQ2jz5rrXk87ImbNklcL26SxEsqpwhBKgtCaiDv+0rq3aum1ar/3RM/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=We0hAltPWuTiM1Ps80dso2MNdYG5l/N00m4Hx77CwCA=;
 b=SCYKso73F3SkSEnk5SuJRiGNz/whnbQmKmPhhYd5u9pQEAuw9M76/wOLdeziyW50xBUawcIDSNOqbFIdNbTp/BYM8Elr7jYX9kvw0XW9Q01kgl1x1jEOFXbujbuz/WSKFj0wifbivxXsXiWdqFocnD5flzFyLuZ9rtletPT5cJM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 14:18:12 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 14:18:12 +0000
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
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
To:     Markus Armbruster <armbru@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
 <87h7gy4990.fsf@dusky.pond.sub.org>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <5017886b-c075-8997-2c21-c04ddbd5e95e@amd.com>
Date:   Wed, 14 Jul 2021 09:18:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <87h7gy4990.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:d3::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (2607:fb90:f221:2aa6:5ca5:4e98:9569:a37d) by SA0PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:d3::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 14:18:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d16f25b-83f6-4a42-1b9f-08d946d236b6
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2446F32055C8E28B571E7819E5139@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u0oM1ftWF5Z9CSLs4aRBIZJbpeb1rWKR9X/B2Bu+kZ21h19yQJcUE8BV0UrsbDP0m9RAB0u7FxGtV7xiIpOOMArx+rCSlqrq6T7aWEGsZ7Ea1Vi/cMHDwrFAXyjiHUaTroS9emsOzZi6+ZHhSVI9EvFs/5IYhKzv4GxMWYLQne1kAFHaGxJtuHx/QSxzbbH8l3gpeiDggvhIRqMlVKiXv2IiXkS7hOx1rfLxnEHOBk39PQIsdzUVLljzV4E15Rus/yljCxk018fqGV+aZdQ5ZT2MiS3LSm86efk6UE43m3+bq3/3ZZbPkg85Dg20DA4w1h6YTp7/qhrIan7dFgO+8yKxOGZr9BGFeBCT0zsJbwk6WpyDB5ttVUecT2IGMKcD56JOTTA2AfytbweAqVs3UUa032hVi5Jc0Z2xi0nE1cFOKWYoCoquCHwettO2z/VZAFOcPFDnpEfH0gPXw5j3NX4ykOnmM5OGseQngwmwlzbwVW897/mgc1aenIVsZMP2z6muqqHmZzSUF1ugrSGW0b7pDy1EieLqm+a58R4pVKONxujMJx7P/ezowpvU2zyF3Zm2QAJJ9XMOkpdJ+2S10SjIH+D0lIOh1IQYXVmIvUFdJDI4akGawE0REYnHe4/Fc44LMTIoT40cGc9z15FFtPQ3sjqtHK5dpFOjIqlLUzIDHGH3gshiaVIEjQ/X6Z3xXuxsDStFt5X/ArEa9nKl66leywTxHBWx3ZSLEURAR/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39850400004)(136003)(396003)(6506007)(53546011)(36756003)(316002)(66556008)(8936002)(66946007)(2906002)(66476007)(31686004)(478600001)(4326008)(52116002)(54906003)(5660300002)(6512007)(7416002)(44832011)(2616005)(86362001)(6916009)(31696002)(38100700002)(6486002)(186003)(8676002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjFOTEtsQnpmL3JmSmtDV2dtMG50MFpEV1FNSFZtSUhGNkVaVTNlcUF4bDk3?=
 =?utf-8?B?SlJBYlVaQ1JoZ2NoZ2V0TkU4ZWVsYWxLTDQ0MDExRVptNzducGhiNFFCdU1G?=
 =?utf-8?B?U3ZxdWtRaXl0TE40K24vd0dXdE1LTGx0T3JUa25ZWm9qZ054UXJ1VTZSVVY3?=
 =?utf-8?B?TFc5TW43M01RQmx0Zzg5Y1ZrcFNpRHk5ODk2RWlZR1JWbWMzdVhOT0Fia3Zx?=
 =?utf-8?B?U09rdWZaZmpTQ0JsMlRhU0JHV0dBYXkzN0NOS0dRNzByOHVZME0ra1EreGo4?=
 =?utf-8?B?STE1aWV6NHFQbWc5ZnI0UWNIaTlDSmptRGI4eVZCYk45WU42Y0FNZjdQaVJm?=
 =?utf-8?B?ZXcxU09pOWc0UFQ5WEtVMGhzMDdJS3hkbTlrdndBT0VuUGJucksrVCs5SGNt?=
 =?utf-8?B?TXlsRDZ6aVd3N0I5bDFmRHp4U1NaQVZBd0NLUzFjTktGL1pRUG9NWktDaHF5?=
 =?utf-8?B?amhnVTlHWXhzb3FzaGhCL2lneC95dUw5QkFTSGViYlRkdGpYNHFiMGdVdkR3?=
 =?utf-8?B?bmdqNXh5TWJHY1c5QjNPSVRxSDJyK01iNVNtZ05iRTBoVm90OWFwUm5hMTJM?=
 =?utf-8?B?WlRSSGJDeDdVcUVzM0QrSGIvK280WEZ3NlpwSjlxT0wrby9VUFg5cTA4bWQ0?=
 =?utf-8?B?WWlEWk5TdDlxY1RRdlF5eW9HdFRNWnNxWW1jMzhNWkZncUQrc29NK29qRWtk?=
 =?utf-8?B?cGR1ZnhlWUFHQWlJVko2b2YrSUhwY1lqUFVsZGQ3ZGppdEFqalBiWStoTVpS?=
 =?utf-8?B?WEttMm10eVNVU0xDYWp1STNoQW9HSUQ4azM4MEJ6TCtjSXpUR3lSNmJBeld6?=
 =?utf-8?B?NHozV3RGNE5DN081cTZlQnF1eUcydDdad2FoUVFjWHhleGVUZnFtdkI0MVVY?=
 =?utf-8?B?bmlNd1dSeHJHN2VDdlVrdjZJdWwzUWJGai9LNzEwZHNZenBVZGR1a1NCckRI?=
 =?utf-8?B?S2JXbWszdHNnaWhVcnVyZmFicHNycC8wY1ZOWTJJMWgvTlJvYmdYaldOSkJz?=
 =?utf-8?B?VWV5Z2NXMTNYVGRBUFdFbTFIdjJTT0VXV1kydmV4NzJydWNRYkozTXBIVmtt?=
 =?utf-8?B?VTZWb1k1bHMxaEJXT1RSazF2ZGlFbVArcnFPRWhMMVBwWjAzTjdRczlMZTVN?=
 =?utf-8?B?RUtoSmp0bHBYS3VHdXNneGRtYVhmdjFjRzY1VmFzWlIybFFXZDR0KytQWUZH?=
 =?utf-8?B?Q0h6UHhxRHhudCtsRDBZbTNMOUl4K0treE94Tmo5WHo4TDNzbHp6dmpzeExV?=
 =?utf-8?B?SDRYVmlFQ2VhOFNuaW1HYSsxSHlXREQvNlZobTFsdEJsMHU0SXlmcmdhU0M5?=
 =?utf-8?B?WHJjZEY2TGdCdjlralRpOTh1RWZNU3BCZXg3ZklYSVN3WUxVbnRVcjEwblZ5?=
 =?utf-8?B?UFp2U0NORG5laEE3cGw5Z1pBcHNhYk1IcnVwRHZmVGZ5c1pwK0l5ZVZ4enps?=
 =?utf-8?B?Y1JNSlVVR3crbVNlMTNUTHdralQydXIvcDRaK09HaEp4Yk4rLytSSTI4QVNw?=
 =?utf-8?B?ZXUrWG1JNXUxZ1huMWUxRGFaNDR4NGNZcDZneFI5OUpuNjRuVGI5N1YzMzR6?=
 =?utf-8?B?elpWcWhaR0ZaRnRlNmQwajlVUTBpSCsrTmJLS3liakM5ZjY2M3Z5WHFYajM3?=
 =?utf-8?B?MzBocVFMNjFLYTUrMlMwUTVQRGlwdjY0TmNoQytoR0V0VDNBZ1RIR3RKSVR5?=
 =?utf-8?B?QVdFWlpsdmsyekdQanpnQkoyNFdtSks0bk8zVGF4TmpXRm1CTzk2NSt1OEZN?=
 =?utf-8?B?WkNYVk5NYjZoVkdiNW56OTZpb2pqLzNVd1hkUmpiLzFZbU1tRExiRng5bWZo?=
 =?utf-8?B?ZDdta1BhTWVJUUE0QnJxQW9lMHJWY3Y1Y0RlYk9XWWlTRTc4dTBXTDFHdTVQ?=
 =?utf-8?Q?DuGhLZDN/oYvF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d16f25b-83f6-4a42-1b9f-08d946d236b6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 14:18:12.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyzp9H/cZIGFWg871NynXQTdwVC3cYlCH2tp7/cqAvUwdIqwS8S92QldJXs0TgshbDqdTXljollTJ93CfRIaLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/13/21 8:46 AM, Markus Armbruster wrote:
> Brijesh Singh <brijesh.singh@amd.com> writes:
>
>> To launch the SEV-SNP guest, a user can specify up to 8 parameters.
>> Passing all parameters through command line can be difficult. To simplify
>> the launch parameter passing, introduce a .ini-like config file that can be
>> used for passing the parameters to the launch flow.
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
>>
>>
>> Add 'snp' property that can be used to indicate that SEV guest launch
>> should enable the SNP support.
>>
>> SEV-SNP guest launch examples:
>>
>> 1) launch without additional parameters
>>
>>   $(QEMU_CLI) \
>>     -object sev-guest,id=sev0,snp=on
>>
>> 2) launch with optional parameters
>>   $(QEMU_CLI) \
>>     -object sev-guest,id=sev0,snp=on,launch-config=<file>
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> I acknowledge doing complex configuration on the command line can be
> awkward.  But if we added a separate configuration file for every
> configurable thing where that's the case, we'd have too many already,
> and we'd constantly grow more.  I don't think this is a viable solution.
>
> In my opinion, much of what we do on the command line should be done in
> configuration files instead.  Not in several different configuration
> languages, mind, but using one common language for all our configuration
> needs.
>
> Some of us argue this language already exists: QMP.  It can't do
> everything the command line can do, but that's a matter of putting in
> the work.  However, JSON isn't a good configuration language[1].  To get
> a decent one, we'd have to to extend JSON[2], or wrap another concrete
> syntax around QMP's abstract syntax.
>
> But this doesn't help you at all *now*.
>
> I recommend to do exactly what we've done before for complex
> configuration: define it in the QAPI schema, so we can use both dotted
> keys and JSON on the command line, and can have QMP, too.  Examples:
> -blockdev, -display, -compat.
>
> Questions?


I will take a look at the blockdev and try modeling after that. if I run
into any questions then I will ask. thanks for the pointer Markus.

-Brijesh
