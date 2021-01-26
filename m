Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B93043C5
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392865AbhAZQZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:25:55 -0500
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:8416
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392842AbhAZQZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 11:25:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P04wtbJhTa+2mK0Mme7GsZtLF1IhxMYxzyFOX0RX3Pn8yZV5YX1f+z5IrmGCY6A2HNI0katt0GEKlFCKFRVv6UNID7Y+rNTOxj9UFiRMC5OOiRqJRXeb3jhNUh/7E96NJacOtbRMzWC2/pn2dDNdnefH/gQGiOe5uhuHf0weSdSHuqh6YeXpZWCNzBFfCyoKknJIykFpGVe6XVwbkLKT3cj+xnOHCTcHDVxmCK51mdV1CZ/JFShKcRa2RRachxBS2JcnPz+3tAhiJL6qWqKtE+Z4O3PZayAHOKIk+oOn4lqArPoe6nIuNH7iXlZ4WYwOcdVj7h5QraAWGNwiegwDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5eurLtR7HqhhU6xxUP0xAw08AUagPLqbvdKUeu+3bQ=;
 b=kcT+VGBYjFznyqXdV2G95OnDTcF953fAIWJg2bGZG6mI+2QVpAN4Q0p2uieeD7gC5MaqZw0KYtqgtqCGiFSBCeZsK/0O9wmR38MscmFxy6qQphCfnEIRmQG/n53+y4EDqDa/5zc35acG8p8W5VIKOZVDEkKCrz4kNfkLuaBmEuaHhlB0ZC8HHfAukRqtRgG8jiZjd7kLFNT26r3TsAeGvJZUwB6XsPq/uCrp81eYYjN46rk4pyBcvB6DRIOdzMLJHWwvEuV21Mqk1mu/hilBQjTIJ1piDYEhRKdXriyOxOo7IMJGUJx+4aO2Xt3X05hVYnsNMNkjEmRSzZfA8Yr9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5eurLtR7HqhhU6xxUP0xAw08AUagPLqbvdKUeu+3bQ=;
 b=Rta3ytfyCaWwakHSNFeMM/qUE4pBoXAguhfUec8YNwTwW2yrxRu0L0dGOz9SZf7UuFbk/siEfHfiLa59kudE0FzlvTO4nOA4rI1j+E2dmR3u8iZ5KXh8CHCmUq1dNiDLXiX1Y4kta+mJ8Iwc5dQa6u8vgoXUAHZpz/+mvT/VbXE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2504.namprd12.prod.outlook.com (2603:10b6:4:b5::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Tue, 26 Jan 2021 16:24:54 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 16:24:54 +0000
Subject: Re: [PATCH v4 4/6] sev/i386: Don't allow a system reset under an
 SEV-ES guest
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
 <c40de4c1bf4d14d60942fba86b2827543c19374a.1601060620.git.thomas.lendacky@amd.com>
 <66a57543-a98a-d62e-5213-e203efda5dce@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7f7e0ac9-8a11-7c36-1e1c-568f6ea2035c@amd.com>
Date:   Tue, 26 Jan 2021 10:24:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <66a57543-a98a-d62e-5213-e203efda5dce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0250.namprd04.prod.outlook.com
 (2603:10b6:806:f3::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN7PR04CA0250.namprd04.prod.outlook.com (2603:10b6:806:f3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 16:24:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80c2be43-115d-4302-7893-08d8c216e9d2
X-MS-TrafficTypeDiagnostic: DM5PR12MB2504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25042E2AA05FB1A3DE347F73ECBC9@DM5PR12MB2504.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2Ar94F++0DFaTcqk6BwjyQpn8JxUfY+3DKxoZcYJdUP6BiwgiQR4ISmuIjE+Vy0TMg2MiCB9RqpTyeMQ7LiIOC4YCHrHR2Kcf6QKJ0bbEINeBS8Qmwr1m1X6v8nYNEuu888uYKZZo860DMSNDzArn3pByUFTFbEDk2XNfGtpD/n2RvLEsIUf1pKY3dNYOFIXIX6eWysBweGp7wSR0v9yZjjHeuSa+9B2cula8oUNCfMQAILIELgmHi3f1cndD2oRWYTKJ1Xtq6bRf8W1RgOyK8Smq7Wb6jvOXef/5b1d/80WMUXxUgqvwGUiK2/wuO0WLHNUNoI3fDnZ045BQVjKZc4CSUTAdq2UpjoSGrpvrO5o/rT6lpVgippz9AHWhiuoBka4IUPArje5dClyE3vpn4qzvZIxLRJ1NdgHuAg0ryXkUXparT7k09zXdIIjx3AFG9gqhXtZ7kY4PbRjt/0VXjdnbOPmkUHCgwGV0hgBHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(5660300002)(6666004)(186003)(16526019)(26005)(83380400001)(66476007)(31686004)(31696002)(36756003)(86362001)(66556008)(4744005)(66946007)(2616005)(4326008)(16576012)(53546011)(478600001)(316002)(2906002)(8676002)(54906003)(956004)(8936002)(52116002)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NWxKYlliSklGNFVRbUkxZGFJd0pEenpDbHZYUVAwMW1EbFJCa1R6YzlsSy95?=
 =?utf-8?B?OGRtVFJtUFp3SDBsbjBVRDlUQS8rUmp4RmlUaDRYdGNSajZXdlE1d2N5WEQ4?=
 =?utf-8?B?NXU5ZURDR20rbzhsR2ZGcGpEdm1PbWl4ZHhJWWhvTVpLT1h6YmZWL3NtUGJY?=
 =?utf-8?B?WmhGVEFHWUdEMWlXTHBzd2V0eXY3a0NyVVRKZjhlNVdLY2RjU3VXTXVlS0RU?=
 =?utf-8?B?clJDZEpwOCtnWHJseXdJK2lCNzhtZzRXblFvU3JvbEYzU2xWcHh3S1Z3ci9U?=
 =?utf-8?B?eWpUdC9QdjlqSy8yUW9QRkpram9SWkVqRlRDRnlkdjFtZHJjTU8ydlEzbVVH?=
 =?utf-8?B?UUhreDRkNE1qb0ZNSWdDVnYxQWN1enh3WWJ6SThsWXdUbnk4eGVVVHRkLyt2?=
 =?utf-8?B?V2E1Rk9xRkdhNnJiQkRKaitBb2VaRmErb1ZobGRsbTQ0Rk1yQVNlbG5ybnhQ?=
 =?utf-8?B?Tk8wVm5Mb01iUXQxd3diQTlVaHRySldaT2pOQ0hlUjVlUFhIaGY4SEF0SHFW?=
 =?utf-8?B?UmwxM0ZVbjBBMXN2NTdaRGQ5UXFtMXlqWkVNSTl5MG9EVzF0YXNiSU9KWDhj?=
 =?utf-8?B?WnZoS1BvZU0zR3o3RTNXVVBhN3pCcjBhNjdtWXFsVHpQS1RUUEVhbHU5dGhw?=
 =?utf-8?B?cjhlcmk0TVZkYTBKUmxKWmhIL1pnN2tpY0cwVytvV042cmxMMmFwUU5aZlRU?=
 =?utf-8?B?QXRlcVplYWk4NDBOMUJzV3ZGT0cxN1E4L0crN2R0aFBteXV0NS91S1lyNjdr?=
 =?utf-8?B?cGZJRTI3K25hdjRIYUlUVzNJSjVZWnUvdUdzRFhKUzNDSnFJaDdiNTZab2hr?=
 =?utf-8?B?NnNCS1NpTUc0SVA1WEgrZkg3OHc2THZrZzlpMUhobFVBKzZGTlU1Y0tkSFhq?=
 =?utf-8?B?MzYwTWVYSDRkQnVxNnp2dW03aWxNWjcvUyt3ZmNIdHllelVmaEZSL0dSaXpL?=
 =?utf-8?B?b3ZoODhVK0pPOFJLSzBLQldwYlgrdU5XcHM2cVpnekJqL3pQY05PeWF2SHVY?=
 =?utf-8?B?L0hUK1dUTURiekNicGZ4eUZNSmNWVlNJQ1B6Y1JwLzRVU3pvR2JLUU90YmZN?=
 =?utf-8?B?cG1reFJLQXp6MVIrS2tiSDR1RHh3eDR2YVJsWGl4eG55SUl6Q2d5SXFGeUh2?=
 =?utf-8?B?anB5Z2g3aENxOVFzQ1B0SXh4Vy9YRWNVK0g4aHpZV05XUmVqZysxTEJiNEtH?=
 =?utf-8?B?T1ppUnBRY0M2MW5YZDk5Vkk5UWprbXdnQkYwV29WdmYyU0FVVFR0Vm1Eclcr?=
 =?utf-8?B?Umhpb2VYbzhKYTNhL0t5U0lBUEdaNG5UcW9EZldBencva1NDaTBDUVNsQlVp?=
 =?utf-8?B?VU9qY0pyZWNXUTJ4aHE1aEFVZ0I3dlJYQU9mMjhjRWdHZ3hNUWZjUkRVRVhn?=
 =?utf-8?B?UlVPbENFY3BZbzJlNGVRK29KRzVxN3d5RkxaODFXM0dDQVlWdVgyNnRiSk9m?=
 =?utf-8?Q?ASFrlp2v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c2be43-115d-4302-7893-08d8c216e9d2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 16:24:54.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQqYGcC1P90zpmsRHquqhCl9OrK/+1cs5NQ7XKc9utzPjCnyQIQFPw9o2jLzzSJDwFSe7SsVVteQC+iBF/HcPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2504
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 10:16 AM, Paolo Bonzini wrote:
> On 25/09/20 21:03, Tom Lendacky wrote:
>>
>>  {
>> -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>> +    if (!cpus_are_resettable()) {
>> +        error_report("cpus are not resettable, terminating");
>> +        shutdown_requested = reason;
>> +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> 
> The error should not be emitted if "no_reboot && reason !=
> SHUTDOWN_CAUSE_SUBSYSTEM_RESET" (the condition has changed a bit in latest
> QEMU but the idea is the same).
> 
> This is because whoever invoked QEMU could already know about this SEV-ES
> limitation, and use -no-reboot (aka -action reset=shutdown in 6.0) in
> order to change the forbidden warm reset into a shutdown+restart cold reset.

Ah, right. Let me re-work this to not emit the message when it is not
warranted.

Thanks,
Tom

> 
> Paolo
> 
