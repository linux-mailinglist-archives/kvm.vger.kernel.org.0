Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46142FC504
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 00:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbhASXqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 18:46:52 -0500
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:45638
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731022AbhASXqa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 18:46:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kR0Qw0v9ln3rhc7kp0aEq/q8sa2N09lJ8padbLtbIEvWZ3+2mUb73Zt+YtDVOlQdpdBMYBo9289ijs1MQVkcLqVguLY3Br+sn1qNgKhZKhrkV37MbYfKdzG4hSpigo2t6nIZkOWJgxKYLV317S5Wsl3YS0of+3l5Q5fsHOnUXcvjR/9DknHFolSeWh/TMVaJzvt0NaB2fXdhA2R9dDHtE6R5P9i8xB8z4q5eKR2YwZE4rUEySJI1WcEjOPYXFAEgDH9qqvDEb9hcJLJQP5/qLa/m9EnhSiHZD8NqWNKnsGcGsqI+4k3ot5Rqefrwa349MTlxJjJm53N8brnfith8/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94pgvnFH6snZe4YYEFLBPbPjfRA5MYj/GeXe5lqYWBY=;
 b=IieJSL7l45tSqgljEcUrZx/4GST2Vnr9KpW64A3UoHjmlLaFeSZn8nnt7azj+uRFWZoA6CtKCI697ckYb2OfdOSdHQcJAvArQxxwHSigXwp9tSg+d1M1h1eGBJaOSSOpc2ydT3a3asshZm5h4GcGhNApUW5I4guXd9SUwhNzu7Cd6mv6ptT+ER1ePcyvwg4XuwnhbOjRD7tuUwca2yT6XFHx5W6sTQWXOJaDiM9jV7RwNt3dB5rRO+nnqbVDUHlTi1ya3P/a0v6Zf/kFABKB4+Qx56nit4LwXGVD3ePa/5DX81B42v5lfp6YYXTR6JwFXF/BxpKhE1V6JWYnNRxFkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94pgvnFH6snZe4YYEFLBPbPjfRA5MYj/GeXe5lqYWBY=;
 b=lib6cifSmLZG/HTiqjC5bhikU/sn2VIu32a6872Z0XXmwI9hZx+ulIH78wJKZUQPke4VI88Ofe8Mnq/h12SwbpptUVtYP54+z0MnfYKIJTiYh1q2Urn86diYH0vrVOSDbkBdQ+xBgRQ09lCXabtNLkr3TZur2mfDmXL5k/3JQ28=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 19 Jan
 2021 23:45:42 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 23:45:42 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
Date:   Tue, 19 Jan 2021 17:45:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:610:54::36) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by CH2PR11CA0026.namprd11.prod.outlook.com (2603:10b6:610:54::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 19 Jan 2021 23:45:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b9038c2a-c049-4dd0-22fe-08d8bcd4550d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4528:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4528517F61F8717BDCD09B2C95A39@SA0PR12MB4528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c46r0s23+58nAfVnX6Fy/VvQXYQLZlqijumzVNhQtJuGIoXLqg4BVWRmgNWr+goCTjmDigNwEERqyoeujCGW2WEwtPimy9x9VifwFhnlaIPsFYkDYgzjbrKGMYQ8OeV2/fzZwf+5BLD/WhzKJPDRjaexhW+hyK8uTmYKQmPvbpMvPVIWoPswrZxr0HVKe5o+O04ywvbX6KGlTASzuupFwA8MlsZppJutNUtvmBpxq4CX1KrL7sM9UoIVOCI3X4Hs6WjROPIzJ7Dym0oxeQnYtDJ6LQtTotcGzUtMqlfeZb0JFuZ6aNiqu737RAgy9ZfpoWW/ijpdlu7DkmFKVdOBcLq2uJ8R67yhNjaHfuV0xKQbR9UYf3w48ERm6xvE4V4uWV2aoV/JMv1GGe5Udw/7Tlii1VYD5BxTyB9csp7GmwlQU7KjRzGGmtBA98jBbwer8fSnXPi7BI3+NkaV7UPFTD1XjFMpSKN/BlOr6Gm5VGzcyB26lwvBzwYNOTKay0Xv2wE7amyEBfe48rFd+KX8B+Z8PVyihlW7FHAFVL9ePyF345fM1y4ue8cIeB9Ofidh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(136003)(346002)(396003)(26005)(66946007)(66556008)(956004)(2616005)(83380400001)(16526019)(66476007)(53546011)(36756003)(186003)(8936002)(86362001)(16576012)(44832011)(7416002)(54906003)(316002)(4744005)(2906002)(6916009)(52116002)(6486002)(31696002)(966005)(4326008)(8676002)(31686004)(5660300002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NzM2QzFaWXB3UDdlK2Zzc1B3VDRMdExOZGdhbVpvaGZ3R2pneWxjYVVodTRp?=
 =?utf-8?B?YitWSmR6dUlWdDJuZ1ZVdnk5S1VDNE9MSUNsMGhKRXpwSDZOUHNGWHBjeW9J?=
 =?utf-8?B?REFtcXpFT2xoUk1wQzVLdVZKVGhYalBXZXVnZUQ3S3lJVyswVUNUNzhFTHQv?=
 =?utf-8?B?cXRsZjh2ZWN2OEZoc0pzd1F2Uko2YTZTK1JMdDdDR1NuaDJJRFF0SnFGdHZq?=
 =?utf-8?B?VXpRK0I1bS9KQWVkczZTR2toUVV4NjVqYjJZMSt4ZnRmU09oei8vcVo4MUdh?=
 =?utf-8?B?blJoek5lQThCd0xuWlN2U0YwK2VPVGFSdThXdGdTem9QRHRTUFJCQVZnTVZE?=
 =?utf-8?B?NlhmWVNKYzgweTVBMEIrS0ZPN3IwVHpOMlVBbzJMSUNRTXlRbW1GQ3Q4V2Rt?=
 =?utf-8?B?eFpLdkRFclJ1VDB4N2JWZm96ZDN2dlZKcUw1cFVTZkxYcTJrdzh5QUFyaDUy?=
 =?utf-8?B?YTh5MUhXL29rQ1RvcThhUVFjRWFCYjQvOEZjanBVWWFlbzdsZjFCbHN4RXJ5?=
 =?utf-8?B?eXBBWWJ0Y2hsR0pVYnNTVWl0MHRjZXNBZjIvZ1ZvWk53T212aUdKOWdXZzR5?=
 =?utf-8?B?NXFkVExvNzd4NlN6c0FLbWxUN0t1UDB2OTNMNE43V010ZzdCUUIvbFdEOUZj?=
 =?utf-8?B?eWVHNFpReGJyRER6ZDc0aXRZYmZXdXNxWW9EMnpVU3FxdWxrWjFVYzV6VEFX?=
 =?utf-8?B?TDhZNmxkSTRmVFlyTU9BWVh2RDJQWkpHek1uRDFtMzJjcSszZzc1R08rQlBq?=
 =?utf-8?B?TXptQm96V2dZYk1XWVdITXU4L3F5YTNSUTZTOThIYS94YSsyTVhYeWJhdkZW?=
 =?utf-8?B?RkJwVUZRRVg2ZDJXbGQwcjAxeEFpdDgxdnJDOFVicFBFTFBuWjZlekkrT3c0?=
 =?utf-8?B?Q1dQZWZIVnNaVDYrS05PT1c5cU9ZeDVoYmd2UUdnRXZSeG1vaER1VXZMVU9w?=
 =?utf-8?B?cEVuampZMW1yYWVTUlhsVUN4QnA4NTlKTW04S3BEUkFRR0NWRkNFanJLbjFp?=
 =?utf-8?B?Zno3bHlpZmp3U0w1elJ6T2NuVFFYNDRISU5FcnRra0ZZTDd5TlAzQ2t3VkVF?=
 =?utf-8?B?cmdDVGJrTC9adm8xUnRsaTdGbjFBZ3FHNUx1ZmVzUkpQTVFUSUJDLzRqTExu?=
 =?utf-8?B?SnRBNEsyVzE3SWR1MjR4dWQzSzdJUnBTTGFNZkZPVEpiU2NoSFVjakhuNkFv?=
 =?utf-8?B?dThZKzlBdmhnY1o3VU1sSnRubkR4cjkyRllEdE5SbmZ5REdGR2R3ekhrZlh6?=
 =?utf-8?B?Tm93Nis4R2N1c2VrMHFka0plZXFTR3JGeDBCN29MSWZjWWVsZkRLNDJ6R0Ny?=
 =?utf-8?Q?RVBMNWuofIaWqrQLx7StJzo4Iro99Iv99W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9038c2a-c049-4dd0-22fe-08d8bcd4550d
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 23:45:42.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lX9Y+LsdBDGSD94Dj4Z7L50Q5qrJHyYW+2/5pHRNR6HA5nNMZOwfrVq+X22RP0+4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 5:01 PM, Jim Mattson wrote:
> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
> 
>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
>> as expected.
> 
> Debian 9 does not like this patch set. As a kvm guest, it panics on a
> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
> please see the attached kernel log snippet. Debian 10 is fine, so I
> assume this is a guest bug.
> 

We had an issue with PCID feature earlier. This was showing only with SEV
guests. It is resolved recently. Do you think it is not related that?
Here are the patch set.
https://lore.kernel.org/kvm/160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu/

