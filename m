Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECEC253842
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHZTZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:25:30 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:24640
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726820AbgHZTZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 15:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZVCeB6tFEZA1Zw8dNGssAc+cJQjDyJFYLy4qhn1+zvpQNZT+ityYyAvspLz1Hs9aAySN+ngLvEsTcBtC4yMO7Bl7tUGhUERGoNlRQzc9tAA3NAxqCKMeSvVy326dtBNy/02zMh2pneU6yKLU0AHLYKV9IppwCynFLU3V2bQPvW1zrZ1JvkzUxNp/EAC0KLPBQB+tTwxYNKiJ2FAX3cDM+uVndNQhalQrGYMTZzq8zTqq92TcK5ERhtfpOxZKi8GFHyQmzsdqgxl/aVkdXcNDvHdXM6ZtGOl2nbLgt1i/5eEbAmndaSUmsjpz5qHqWRGb5YjXVGT1IUH9dGCK/SmXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoR+XJXnLl+x2xJM+WZfy0JX2FPXYVM5GxN5tlAA6yk=;
 b=UL27eG8VIrkw/PUBStpOnUlsU0YITUmDCM/YW+yLdByXta2o4RRosLkJNoG+Mes36VpC2Y2pNWUKOag/kn7mxeeWatqp0Kv0MswMzmr8y/B1s9W/jUFXlGi8li06bf/JwHHmTe5kzUZ1jVOD3OyBUGPG4pRLg+AGCwX0I5B75HG+Q+pXWRIdfGVE431cDw3b+/zUfrg/rN9Xpg+lEILTJ7XMA5ES3wYNc3LTmORJoQWwLHIXzSue9emUyuHkBwoCUmQMNHICG/5UZbShBUurP4APOEMkBRmMiqf/QH1mlPKMQT2pzGfDTsmAwhJTbvy8L1FLhKNEeCMa7xcF9Ij+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoR+XJXnLl+x2xJM+WZfy0JX2FPXYVM5GxN5tlAA6yk=;
 b=R/ZkaRCGMzX7bT3rrPIJ4qUW6FudzakS6Ny8BBYuJtF4+z9caJ7XloWGsTVwq99XhcfZL9aYz9ixzRiREJRCxfONd/vcwoTsEwjrtwF9tFWfonjj1ZIzceFWbMqeTj/gzP+2kXg3TbBhEuKQ/+cUP3kpsx6e+Pb2owdWFhKEqg8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2985.namprd12.prod.outlook.com (2603:10b6:5:116::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Wed, 26 Aug 2020 19:25:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.032; Wed, 26 Aug 2020
 19:25:25 +0000
Subject: Re: [PATCH 2/4] sev/i386: Allow AP booting under SEV-ES
To:     Connor Kuehl <ckuehl@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <a3fc1bfb697a85865710fa99a3e1169e7d355a18.1598382343.git.thomas.lendacky@amd.com>
 <93275d7f-1bfd-c115-be4b-3d20952bf376@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <aedbb207-d2de-54f8-b3f3-13f9b8d3dcea@amd.com>
Date:   Wed, 26 Aug 2020 14:25:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <93275d7f-1bfd-c115-be4b-3d20952bf376@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0701CA0035.namprd07.prod.outlook.com
 (2603:10b6:803:2d::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN4PR0701CA0035.namprd07.prod.outlook.com (2603:10b6:803:2d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 19:25:24 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e92e1d8-b262-436d-57e9-08d849f5c8a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2985:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2985D003D6E23D7FEC119541EC540@DM6PR12MB2985.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qL3SpFUgA7QQl0eg8lklMI6oXEpxj8X0ewNice2XMXxXy3mtgBwzQmQKXf5peT/eu+uzQTu5S8q0suRk4CRO9brxQTo3diSpk4GD5PrZs0XdJ5XWPi1b6PnbXfhcTuq8MHynv2pUSmkIftdrl5K6WbrjQxQ1rM5P6wrCZAgQbwGWRzC+Pj8VnXGqYJF6kS/iJlTlvtUTkaq8RWsjrWlj+Xc+X80NGcQo57o6cd1BR8oY9G1/LslKRV9xKyuoDoCXv3yJurJod4jPcGS0B434hZBWZe13vNQ+aCTra13sqbaubSegnGXB4oOLcejA/VREGds+4AzGW3GlF3dyTlwO1/rlufCluTQHGOb4mIV3KJvufjaA2uIJxHs64w2Qp1NJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(31696002)(478600001)(66556008)(86362001)(66946007)(2906002)(66476007)(5660300002)(316002)(31686004)(36756003)(16576012)(6486002)(4326008)(186003)(7416002)(2616005)(54906003)(53546011)(8936002)(26005)(956004)(52116002)(8676002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Esa0Vf2vq/yVX7M6a/m1Hj577ipXklKWYDtaY6nv0LC408ftsDlislPGnJLI805SVzYcRsTu/w/lLDtS+ao47TKleeb9H2TZhCK4Z4moxwbbwqGIwn+M4jlsuG1Is8Rx3dnRP773I8aT/Y/iJf9AkYk6C6akYx5WuJZTOBBk2VcTs9C6bGkyHOMu/o9rte20IlwwJVEQtzgF8+r7aHBdSFxN65JUavFoRnGjsH68/V7jqpTos6e8gXHkzVPY0Hum+e1ohSyhQLtMpIJM3OfPWvuR4Vbcw7lNE0+ynsrXP60GmxzgMBv1qewW8mHl96oSXfD8ihuTVDeHRUUG2+UiRuKitDDRzBpiZuKXPTm/eOcvRvoujDocbl9RJVarCL+Bn58t4K4MYy8zoHMAts5LdOA9FJppgWCocModKFbt4Izi+XyQgr5bsnuE6ajiVxhrdbVTAPSzfY9mzp8dDCLPzTmhhKz1mUwlcnLeIfP3YnnUlzP0O/im4vcDuZqmhjVriUjJ2UwOuR6OYHR2fLj2LlzjhBIYMs7fFpETtcxw2PAo6g75mDRTEYVQrg3rU1RxOtcZsodPvt9QE/WwMXQcrlpNYxP55u3Ou24HAI0UAX97z2KglrRtTE3FHDjQMDJoyXMDNjbRv6qTZQJiE2kfDQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e92e1d8-b262-436d-57e9-08d849f5c8a3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 19:25:25.6997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOJeYAXVfrrTyp6BRXmDQn6Z537eZfc/2ViLHoHf8JXvP4LYrH9fQzyJykFQ2E1xdH1piW9S9kGTC3otoLVCGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2985
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/20 2:07 PM, Connor Kuehl wrote:
> On 8/25/20 2:05 PM, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When SEV-ES is enabled, it is not possible modify the guests register
>> state after it has been initially created, encrypted and measured.
>>
>> Normally, an INIT-SIPI-SIPI request is used to boot the AP. However, the
>> hypervisor cannot emulate this because it cannot update the AP register
>> state. For the very first boot by an AP, the reset vector CS segment
>> value and the EIP value must be programmed before the register has been
>> encrypted and measured.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   accel/kvm/kvm-all.c    | 60 ++++++++++++++++++++++++++++++++++++++++++
>>   accel/stubs/kvm-stub.c |  5 ++++
>>   hw/i386/pc_sysfw.c     | 10 ++++++-
>>   include/sysemu/kvm.h   | 16 +++++++++++
>>   include/sysemu/sev.h   |  2 ++
>>   target/i386/kvm.c      |  2 ++
>>   target/i386/sev.c      | 47 +++++++++++++++++++++++++++++++++
>>   7 files changed, 141 insertions(+), 1 deletion(-)
> 
> Just a heads-up: ./scripts/checkpatch.pl does report a couple of style 
> errors. I've seen other series go by where maintainers didn't mind the 
> line length errors, but there are a couple that have to do with braces 
> around if-statement contents that may need to be addressed.

Yup, I'll run checkpatch and make the necessary changes.

Thanks,
Tom

> 
