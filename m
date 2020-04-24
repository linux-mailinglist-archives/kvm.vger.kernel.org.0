Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB91B81A2
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 23:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgDXV1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 17:27:38 -0400
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:34180
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbgDXV1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 17:27:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IF/LoJB2mYZllic4z+nkUSvnAIJFQdA7EgGf0cH8Ox3O8Gs2glfYZX0wx0j/vUl0Appb2qHUx1wWwLsAmUUGdp3evby5GnAVLSfMVpNoEVLYssSkIBNQTsE8LS38odik8reZ8xsgG1RwLCnVkaSoHbUg+9WW2IsR/LcT8yrWG+t1qTAfJ6uCs8r27AAKK8HPfyEXmk6keQUqb4THs285CFyvw5GQePrMYmogUFY8nEsrsFmDHYZuPfs5yQcIcXwyZNU/TiO05EHbpEnbcrz+kR5u0wJGrpYcX8VSiR6Ze5aSscqmzKPsQH9br8uYUk4BUIqopp/HFFJPvj2hk1e2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXPwJEHMUd1Pb8WSoTwVTlGPBsQhkZh2PuV0ssteSI0=;
 b=Ui7iZuFeEQ8k02ANy/SMOTiOUrl7L3IEZjELiBa+pz4PYk1ZmhFjN+JqWpiGKrvLVZk5OlCS1kEz0QvmT6PWy8/J8z43oWvApH9UoxaadOF0VRqBJp51sPG3XDLtxOkjXyzkRZZgQ7kn9FEQiFMaQiRN2pQo4Z0Jl1Lr9qdgmM58UYoAjc9yxRT45OUpZNMhKnHU/2Py/MJE47xevC0z9zr9np3WYChfA6yYfvJQdpiSbQFGVqIC4kuALCZo15bkAHRz/jcxitjzGFaVwOWsvdyOxSDAC519eb1oxoavW9HNbWEZypxwEYWPGwCQZJLgAwoFfNZO4Gq7/D+V0KzAqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXPwJEHMUd1Pb8WSoTwVTlGPBsQhkZh2PuV0ssteSI0=;
 b=S1kokANAn1gzMJ0ZWXiSSpny6W4HtRgQp51Z8tMBNYU3HCrH5/1/EV+K1vpDUeUzAOwXuHfAFNkJxfQN/odM8ohkGNbInwNPxY4Z4tDrxuSlM2ETvN//RMamoNHojZemC3kYGez9wC0jQW+o7FGtH6i98tY4uOvlaGZRNd3qBqU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3562.namprd12.prod.outlook.com (2603:10b6:5:3c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 24 Apr
 2020 21:27:35 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::9ae:cb95:c925:d5bf%4]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 21:27:35 +0000
Subject: Re: [PATCH] Allow RDTSC and RDTSCP from userspace
To:     Dave Hansen <dave.hansen@intel.com>,
        Mike Stunes <mstunes@vmware.com>, joro@8bytes.org
Cc:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, jgross@suse.com, jroedel@suse.de, jslaby@suse.cz,
        keescook@chromium.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        peterz@infradead.org, thellstrom@vmware.com,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200319091407.1481-56-joro@8bytes.org>
 <20200424210316.848878-1-mstunes@vmware.com>
 <2c49061d-eb84-032e-8dcb-dd36a891ce90@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <ead88d04-1756-1190-2b37-b24f86422595@amd.com>
Date:   Fri, 24 Apr 2020 16:27:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <2c49061d-eb84-032e-8dcb-dd36a891ce90@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48)
 To DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 21:27:33 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd7ab3d7-0a07-41bc-b92e-08d7e8964e35
X-MS-TrafficTypeDiagnostic: DM6PR12MB3562:
X-Microsoft-Antispam-PRVS: <DM6PR12MB356267AFF979E5B474114EAAECD00@DM6PR12MB3562.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(478600001)(2616005)(956004)(52116002)(4744005)(7416002)(2906002)(26005)(53546011)(31686004)(81156014)(6506007)(8936002)(8676002)(186003)(16526019)(4326008)(5660300002)(6512007)(66556008)(86362001)(66946007)(66476007)(31696002)(36756003)(6486002)(316002)(110136005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 467goDWZkBEpkhxfDCvcgqEtMW+Lim/F49AB/25Xqk/MsCPCyh+eNLBZGw8qn2J4p1GGXovUvNCflRpjhTwJaFdztA/1m6BbF8N0gLbhs3U3yv1AIt8lXWRY5DZhy0a/W/nW2PMN32OaoGdKrjsv6gCAoAqBsePjUQNG/FJbJkxEKsJfnRyU2D9MWGa98Tt7thgg3xrVg4ZFPedq7RaR2Mg8rHOTPSc4VIyAHTsfjnRZNzoPC+g/DNbtgOHqs3e/aqELCZk87+2S957dR9seNnZvPxf0bAh8BMprnYFMGsbUtgjSrxjxwxOka+lyp0ZweVwlWAxL3ZlIWKDvJhjISOQE02YOh8DZ/Rjn/aRsSafzaJN5yi6dRXsw0RDndh0aUy2xhlGGz7+5NKLOPmcgVDKraSa5yLtBLzRa9gSSGBT7TQQnvr1y6TlCqjRQ4fY+
X-MS-Exchange-AntiSpam-MessageData: zBUyL3Gl7tEpnK9HD3KtpImY9QLwB48p5d3nbMSGELqJeiAWUpVBKOJmT6KKu6k9IosXG3mXfybmK3hzom/yP7JJBjtqXGA3nhye/QV6uHUeYvbhQVcbjpM5oQB0qzl+Nh+BiE8rFzLzKWffDLo+5/8Y9ZaCUVnAW+Q1IlfwZSco8uLzJVJN2E+PNm6kDp8BtyPqNmyrEQ90PUmxfLpguQY+amIf2SWhXBA76KFevjOGB7AainOXC7FwTUwAXg1SdQWjOdz0Fis+ylJqSfn3+mbjUxEMYpIhRul/9Aql1eI5Ms3BgKELTLiWRAb3tC64Ek1llicsI60l/KoaK+vkMmj1RMU8V3FyLUH5DedmTAul1ZIfa5jLY+CMZtJxd9eha1qSIiW0zjWD8KwjpgTkg070yQyQmtK2+muAL1w/8CKQio9kDquIp7e3Dl3cIN31DAGVMb9J//hn9IXM6ZYgVR9DJLY5S41FKv53zD/akX5Ww7zEkkCD4b9xYEP5WPtHyfJv7XbejOUFuw/02tK+pLeUZ0tquY5/V4L3X14X5lQ4e4HrgCKLaGQ2m0rlNPIhMl+s8TPeiqWp+5qRLpCxr+VKbusxut+1GHLpX/UosrnxqspP3rSoc3eTAysJBCxHJhFYkZJ2PfGK3MXUmLsFRbEYJ0hjSt76qHKXKGTC7ZOag9HU6BCAFgGPvPjtOzm7RtrpsKwBrDG4AsA3Ut2A4+R7po6lDwlOFNYppoionsl98yZPzabDA2bke+wf+Y3mfqwTKry/1rPHy1rUjFmJ6Qy8rz9TSOlDtez/dRcdFjM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7ab3d7-0a07-41bc-b92e-08d7e8964e35
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 21:27:35.2595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9RXoA/3AHh87XPc4HN4aYawXMIxeB/Dbz3DJ/H5rJI0aZiNqtWaU6bviMUqO91ugEJUoULYKTPZNpxvVfdLRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3562
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/24/20 4:24 PM, Dave Hansen wrote:
> On 4/24/20 2:03 PM, Mike Stunes wrote:
>> I needed to allow RDTSC(P) from userspace and in early boot in order to
>> get userspace started properly. Patch below.
>>
>> ---
>> SEV-ES guests will need to execute rdtsc and rdtscp from userspace and
>> during early boot. Move the rdtsc(p) #VC handler into common code and
>> extend the #VC handlers.
> 
> Do SEV-ES guests _always_ #VC on rdtsc(p)?

Only if the hypervisor is intercepting those instructions.

Thanks,
Tom

> 
