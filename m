Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5CC3C5FB6
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhGLPvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 11:51:11 -0400
Received: from mail-dm3nam07on2087.outbound.protection.outlook.com ([40.107.95.87]:35169
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230228AbhGLPvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 11:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhUv52O5FAgN53c5BZmbx2PpaAhostKcK8H/hepxz/DH7wl/aBTVyNOLRWvgsZi/wn3TSfSmkRfrttjUf6xsL11q61h4e3uwEoTpVt+fkscl9rKaND1Hcin+i5CBriFOu0nIdPKsMENl6ospLFhOzEGL8bUpkXiwlxBD5dT/lWD8GsAiz2bP11MPLm1NthvCsS7OWsD46cWxPgrYsYJX4QhDdhV6tSQyAowOOyJFcPXWlRTowxXwYLRu5Kkffj0uWEntk0ojnEkOET9heblHiR8POScQNt93pmFICD2qVq/a+L8ocQIRTxw28VVA4iKiZpMz6ftKmps+i+41uY5kYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HxPd7YYwRyWGSsqNdxtVGw9JZbG/plmbRVX+Rnf+NI=;
 b=RBbtPHnQ0xAyPv8gOg+HYUK3hWvSUOuULOjPcH9Q6Le2m295tRKKp4CwwDwuh5HaYzj6eyq0G8VWM8hV6BGrM4EEAp61QtXNyWW9IBCYcMG+jcEs3YIA9fp84yZ8VVec4dJ3YH70wxAm8VSqnKlznpcSdaswUpEUC7oPUD5LDLC+h8IhFB3D6HTGeF9F8Ab7W5mVZTjpIN1DBasIBHXFpW9YcBzI47gSqd/LGiA3zN/iQvq6NY+JvAjdgvn6iA296c5zxVWqF+GQyjdT0ETL2QkokYjuJll4yy2ZLUkWfMwVoJKjoQuWf+ey4vStpngo9gz45NjFEDn370kJ12ZAZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HxPd7YYwRyWGSsqNdxtVGw9JZbG/plmbRVX+Rnf+NI=;
 b=W5CI1pwpi4SrVM9xnqcIEzhOEJc44UKcwe6Xf6cN4TEJOSDu0hLAmljAN20DS8iom8hfoIqkIViXd2gz2XZuKIxpOm0HTrtBpbfe+xtifSUirvxfNU2ari7eaK49uRDIbaugZExrmn++YqdcOTY0KS3ozLV1iApK9mFRP7pv+CQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Mon, 12 Jul
 2021 15:48:20 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:48:20 +0000
Cc:     brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 1/6] linux-header: add the SNP specific command
To:     "Michael S. Tsirkin" <mst@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-2-brijesh.singh@amd.com>
 <20210710163148-mutt-send-email-mst@kernel.org>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d2b21e47-8737-97d2-0e79-2a7ed054e5fa@amd.com>
Date:   Mon, 12 Jul 2021 10:48:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210710163148-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0009.namprd08.prod.outlook.com
 (2603:10b6:803:29::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0801CA0009.namprd08.prod.outlook.com (2603:10b6:803:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:48:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3ceb698-478c-40be-1e39-08d9454c7960
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457458D4CDD053052103644FE5159@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e952aVO48pL9ALUGol0Wn2u/oz5jRKNNaizn9auGHGKrMVqvwDJ9tNuWvtjn65kc1/2fsGvDE1kIZfYGklV1SsPnwBwEvLVOdlvdIsIS6v2tggeZSTpQi4YrW9Qctr+y7cNAv03PI31G9l0dSONGXzvIKVPHVCvYc5EuVuWBTa544d4UP+Hh7HDKRIcZUXSiW9keVLMzXlMQxtPpbJvbprl0AHQ71jnYU9R6FkHLsMxnqvXSkkS0PhG1ieyvxcmuEa+uEODS3ogGa1dPHGb7TV2VSkGOzSgxk7drLivoauBXYtABpsv5prVtBaNjTI78aNW+9R7PIo4D/Dh7ZaCksT+dg0f0N84ayfON3wXfRHlfeN9JvqLFVR9xYSSXp42XxGKFdeWa1LOzwJglyN0CM4zG7gB28oo5S56qgQdJ00yoUdvcpB7z/Yg+k2c6SbsvMp3CQqG4l5XTmOPLe1d5Hb5UM88VdOJ/ZG6k6ZUKVIiKnVtFh6aV1yyc4hcQNv7TPoUp2Ihp1lnXYa+z7X2zpV3L90+ch48SijG4WQeR6FHWeZ/IRmW97whHL1cW+fqXJ01jWI3e27dJQVW9RFOd/aSf7qKhJUOUzxqS+0I2NvQmYU0dVAQORqSV954MBGum5o62BB2f/UqmoQnLN3zdADL40mTYH9O7+sBVxmJEhT9Qy4n9XEFM0VFddJdmOjQeYp4O+pdb7Pk64pZrkPa91Cwo0SYiO+3B9szJNDPHsGdt0iDVt0BeFk4nXluLPIhcHDktgDFcdIyeLmUr69ntvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(31686004)(38350700002)(2906002)(66946007)(66556008)(36756003)(186003)(478600001)(66476007)(31696002)(26005)(6916009)(7416002)(54906003)(5660300002)(4326008)(52116002)(8676002)(316002)(53546011)(6486002)(8936002)(956004)(38100700002)(2616005)(16576012)(4744005)(86362001)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG14cWJuaHdmRmNHRUpVTnNPa0Q1Q0dvZ2I4SEpJOWgreHM1ZjYrc2xJeE9P?=
 =?utf-8?B?UzZKdGRmNENSVGNvZkJLUEtFZlhkL2NSZzNocCtvNVFQbU95aXB0S1ZCZUJM?=
 =?utf-8?B?ZlVCZjdWaFBLMGdZVk9KYVYrdy9GdTRBN3dwb2I3Z3N1bzB2MWJ2ZFVTMWxk?=
 =?utf-8?B?aUcweWVaNjJSeGg3ZWs5a05ucHBteGlaUExyZGVldEt4VEN0T3loN0g3Ykdx?=
 =?utf-8?B?OXd3d2M3UnNyYmkwSHJGdUV3NldNaHR3SzROcDVwTWZSU3g3Q3gzcU93S0hw?=
 =?utf-8?B?Z1BBUDZ4bHZQTXRvWFpabUtjbjRlcHNDUlZxL2d2cmlpUmJXMHRrQTgzRnZw?=
 =?utf-8?B?VmVyMFFWdXpLSmcycko2ZEtDaHl0MWhTWFNwbTg4STJEd3NZNTU5NXBFd0M4?=
 =?utf-8?B?bEVSQkh3aHlocmtFdmpkbWNYQkk0UmtxblJOYWI5eG5DZGUxL1lkbEhLaHg1?=
 =?utf-8?B?ZTlWYkhiNEJ4VHhYcUlablEwZk1OR0NsQVdaSFlJK1VQUWw0NFQrZTRFZFBi?=
 =?utf-8?B?ODRKd3BKRStQZWxtYjU5UklxcGdlMjZybFU4L0VzZ2xZZlVXZmRxWEJRbDht?=
 =?utf-8?B?Rm1LcnYvZHd2SjVLMkRCVHdhUTF6TDBnM1RNaktZRjRiSDNxNTI3OHBQNGhN?=
 =?utf-8?B?YndwZUdQc2Y0bnJLV3NTaVlKVS92Nk5zUmZiYU8vMHExNnVkUDNTYTBzVDds?=
 =?utf-8?B?Z2VKRXhLejk3WjBvQ0NYZ3kxZTV4aUtZUWlIZkk2OUFsL1VUaE50N2oxclF5?=
 =?utf-8?B?L2xWbDZmWDIvMkZYS0FqU213YWNPQThHdUNuTmN5NGgxbk92ZlpWVTZBeTI4?=
 =?utf-8?B?bHdhQ0xFaGRQbzM4cTF3SzdHSDUvdldoaVVWSHBEc2ZFaXRCZklad1JGdE5Z?=
 =?utf-8?B?b2ljUTZJRk5xUHY5MmlrUmtiTjQ1MEVCTHdTeHAycDEwMW1uZGtkYnBlV2pk?=
 =?utf-8?B?NlkyUGN3RUlXankweXQxTlZCMjl2aXJyRjA1RWx5Y1M1eVBjd1VMU3N0YTdh?=
 =?utf-8?B?K21KUzBYU2lMR3M1SkhmMklZMjFGd1h3VUtqZzNINnlUZVppZ2VDRFY0eGNu?=
 =?utf-8?B?OFFDdURTQ3JOeHdrL1FzbTEvblpZN1J4T2Zqell2NFBmM1hQcElzQlY4U25h?=
 =?utf-8?B?Z3Ztc0ZTSmU4eHY4dmVZN2hLa0I5Y3FIaHRENXZYVnh4a1VXc1hmQVB4RzBj?=
 =?utf-8?B?TVdkemU0Y1hnRGsveElhTTkwSXVlK05JVjBqOHVCVlZCaWU5RVdzU1YyN00y?=
 =?utf-8?B?NkxqQ0k3dTE3MVpGTGJrd3pLbHBNN2liNC8yWVh4c1NCRzl3N1F1QjFmQmRu?=
 =?utf-8?B?WFFlTUgzTlMrWm1qZDhPcit1R0lGdjNwYXE3OXhPZE1VbHY2bFNUMk9TaXVX?=
 =?utf-8?B?NC9YV0Rid0pwTStjOGJlbUdISlg0VTJ5Z2pZVW05RU9iK2xmMjVUdTZBeUkx?=
 =?utf-8?B?SFhVby9TVnU3WG03bUk1TTRyOXllc2lVV1NlbEVyMDVVQ3Y0UEhRQzhXMTVz?=
 =?utf-8?B?RENEQjNCOFkxSXFVQ0dYaU9lelNlblJhZ1lNY3ZxZHR4Y24vdVhSZFZ4M2tm?=
 =?utf-8?B?VDZmZXJ2KzlwRHZjTGFIZnVaRnRHVW1RckJlb1JoNHd4bHZ6YlJXZkhvQXVv?=
 =?utf-8?B?cmhIdVYvWTMrT0lJMFdyNGRZZ0dqM21rVkJISE1Ta1pGSGt1ZmU5TkR4OUM1?=
 =?utf-8?B?bFBuSmlqbmVBNDB1Rk5VbUxVMmRLUHd3VXM1d3lhZklrdy94SGppYkNHZksr?=
 =?utf-8?Q?rJfogBfjgzQ2hbrjQ8yE8OwWcyZcSoQdSe6HAMf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ceb698-478c-40be-1e39-08d9454c7960
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:48:20.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hSsS31WlLXTQxG5uJIlV5Gh7dUMKQl86SnJfYmOmmxvHr4tZGKEB/MUM3vPwtgt64Zy6KmjCY5KEJeOl/y7p6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/21 3:32 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 09, 2021 at 04:55:45PM -0500, Brijesh Singh wrote:
>> Sync the kvm.h with the kernel to include the SNP specific commands.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> 
> Pls specify which kernel version you used for the sync.
> 

This sync is based on the my guest kernel rfc patches (5.13-rc6). After 
the guest patches are accepted then will include the exact linux kernel 
version.
