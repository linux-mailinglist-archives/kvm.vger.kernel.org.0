Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B957366D30
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbhDUNvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:51:13 -0400
Received: from mail-eopbgr760057.outbound.protection.outlook.com ([40.107.76.57]:13882
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235322AbhDUNvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:51:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDeC1O2Hh6/t51bX7Nial0FvxT0WRk4FMBjmjB6sb8XvN1Z3E9aBe20oNuENfjXJ0PjSsRqHH8OW3xtOAowWOie1Hxd2KYfB9UMUiKxku21GIRE5NR912vzSoW4pzPaC8JdzFO3jd5NrflDYalXZBHixJzVP2pAqooRTCBfC75AWUhZP6n8iIqcgECaKES+LcsEDJFF99Dtoyz42jUV9mAVtU6reuiFsqgoyQS07hMtPVY+RroixixkK4F3An1axNnP5QQSaS4CAtrdqIS02uBJqyYCyqDEBDIxEqQQM3ldeRV36Tm1nJpMrupU4LifUxAgHywSX4K4LZtkEGcOgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n/rCkvyULJSzdukD6EjZGmBZHSFlEA0G6bHsrpKjlg=;
 b=TTiKs1V3Itf67gwsWsFu6VrqvTz1lnH37i0jfFgHPCYbJJgtnOIYm2c1FNZpBUhHSIAQ1pWQ3rXQl+htx35jdfFX7gS51T19sMMAHut3QdPKgkVb2Xboo/GoyU+QvkOWdD5oIVu3V238O3SsefMw90rWk9dzkSvhvqnp2UxyU9g7UmQGu6Bb1lX4abd1JgTNtvZKFSb8sdfusYIwqjWLMrCVFI3XMnYZTVjsfsnmLkHET8iza9HuckUTK7TCVw7lVW7JTrcHQghgL+lYhaWp6fxK6/Euhf0TqpSokuw2eO78xvDypt4aOyAvHpx4JKRrKsJ6Eeh5eM50wfcp0iYbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n/rCkvyULJSzdukD6EjZGmBZHSFlEA0G6bHsrpKjlg=;
 b=l8vgfQzhgwv5vLf7oA9D81eXnDLPIeI9MHK7eA7TbMpCMLWU62GtQiGK8DYWlgfvjzzii78zhL85y73lm1aKEwpJz7RP8BXNOMsVg3UZf5HCgVkkl7+w1H6f237GuWPTNt7da8TYsSzgSczWD4VtTAiX+2KAgIIqU6kikJX4UNA=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 13:50:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 13:50:37 +0000
Cc:     brijesh.singh@amd.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <ashish.kalra@amd.com>, Borislav Petkov <bp@alien8.de>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
 <20210421100508.GA11234@zn.tnic>
 <20210421121213.GA14004@ashkalra_ubuntu_server>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <ea57b774-1368-5340-2777-767188c47e6b@amd.com>
Date:   Wed, 21 Apr 2021 08:50:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210421121213.GA14004@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SN4PR0201CA0003.namprd02.prod.outlook.com
 (2603:10b6:803:2b::13) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0201CA0003.namprd02.prod.outlook.com (2603:10b6:803:2b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 13:50:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcb2a916-d354-41d5-791e-08d904cc7132
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44152ACD9D3546902A2C9837E5479@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFdCg/CvcZxcamlYikyVZxzDK3pRGDplyS0yNORFTX0O5d0JeqKEj0sZWNvnZNKaXdnx3u3Xsb6RmP6sh9hwF0c4nvZyRW1wX3ObJQX8AGtJwPt8aGVmg+v5/BNTnjm4meSpdkNxnzAIE1WRdLtv7jZ4EHgwntA/XxQHs58EFFJC/hlgEPyj7b/yJzBLrwJJ0ZWko/lCvQfLdvCGA2aFjxPmIOPfcyfVsqY9y2Pp/xHjvHBdU1QzcUHyn3EvE5mLOmIZAFTNxqW5MowaoagDibKwtSGKTL3E/pif9cOWsE7b6hnEvmnkzmawvHaGdDuRnIGyMSy2IkTO9esrLaaDTJ2qORDWZUuYo7FJqBpTHsbzn1+KXglI0QRyu3a9NERqyHjCBo2hOweQljlxYXKtIjamRlkBc/TjX7+E0Iip+FDXy3xum4di57v2DI8JFQFHuMzqRpiWUNWm2c+DBDGsKiiAjcKsGLzuvz43JUXX2tnlDkb+4Nm1EmZpb771ivYuUQ79Et2QuprEm/OhoiigLTsPcXhUGnm86a4hpqU7MqohY3Sqbt12zoUpc2xmdqYby0nMSdzPKc+HWsQZqQW04dpoDOdKwBGnC7R1/UNUiZrOSoxYNwCEjuzWLGgwMpyW4/jXDlJJGZ3h4SpF4RCT6BaAkkW9DsJxXftSxrKz9hXNJ2hvVuBPR452LHKVv3UF3QELSEO/W5v6h1V6XUCilihRoHn1E5A6sZMVU2ku3W4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(366004)(376002)(346002)(52116002)(26005)(4744005)(4326008)(186003)(53546011)(16526019)(6506007)(8676002)(6512007)(38350700002)(2616005)(316002)(956004)(31686004)(38100700002)(2906002)(110136005)(6486002)(44832011)(31696002)(86362001)(8936002)(478600001)(7416002)(36756003)(5660300002)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?anI0cFpNWk5nNDMzbzNERUgxN2lmRkZYYnVjSy9oRGxLd2hzZ3lYR3ZONWJz?=
 =?utf-8?B?dlVVWHcwNkc2U2huelVCdUJkVjN3eUQzcDNoaE96WWx4Y2kvR1BwOEs1TXlG?=
 =?utf-8?B?OHBObjJObDJhTDRZc3o1MWlJdFpKRjFNYy9yd0c3S3c0WkgyOGdYbVZBNkJX?=
 =?utf-8?B?UW5ESEF0d2NIc1JManN6L1lkdFIyU3pGUDZTRGdCMlYzQ25oWVZrb1pMTVh6?=
 =?utf-8?B?UitnNm9LdjNHTG8wS2hGNVI3bVRBUEY1TklkU29WQUQrUGVNVnZUcjJobWxk?=
 =?utf-8?B?WmZEUE85TVl3TGo2U2tuYnQxTWZ3NURMSEI4U3lraEJJWnhvY3J3SDBpSDdM?=
 =?utf-8?B?d1pLWTRCQkFQSWZaaHlTbU51TFNKS2QzaW1vTDhIajV2a0Q5MjV3aUNMc1dC?=
 =?utf-8?B?a1VVNGRMNStseXJGZWZBblFYa2lMZG9UWDFKeW5Kdlg5L21tbjlqVGpDRlMy?=
 =?utf-8?B?WjFidkVkT2hLeVpzUDNwWE4rN0lOczdZVERYRklEMWlZTEhFbkdEOVVOcWJD?=
 =?utf-8?B?MUduK2hneHZLcXFhUzdwTGoydjFjS3R4OU5lZUhXZ0I2b3NyYUhkbzc4RGNm?=
 =?utf-8?B?d090MFJsbk55THpvOGdtYmgxWXlHUUNlYlpIRWg2b1VMSXE3eTQwRnJBT2xE?=
 =?utf-8?B?SkRoYjh5blZybUppRCt3RjYrSTdUZWVYaWI4Z2kyUThpbVhNM2haTTYyZnB2?=
 =?utf-8?B?bENKZjZjUkVYTWQ1RHowL0o3WEZGYmh4NEpGU292VG1OZ2pvYjNPS0RLc3RY?=
 =?utf-8?B?SWk4ZUFnUnpudExFaC9Sd1YzcWZSUmJNRUxMbkpKWWp6VEZ5YjhPVnlJWnkx?=
 =?utf-8?B?bUdac3VvUUhTb2hSZXhwRVlNS1dHbDhFajZNV0Vnd3psRGNNOGsrNnUyaFZY?=
 =?utf-8?B?WEJOVGxHUGlTTU1ZWmpnbjNZWmNuOU02KzJSc2lmOUxhbDl3R2hpOUxrakhi?=
 =?utf-8?B?S1pabzM1Y0xoTjVUMUxVMldEUFZHYWZIemlueEZpTDJWR1hwYll5ck0zWmtT?=
 =?utf-8?B?SXBaRlRkSTA1NHhSZUc1RkJDUFJiaWJ2U2FOekxjZlMxTCtwTWg0TmR5bU42?=
 =?utf-8?B?aWJaQVZJQ1B3MnpINXZrWWN6SXNPL25aV29tb0JlMUk1WkdudjI4Uk9PbHJm?=
 =?utf-8?B?VEs4bzdZYlQ4aEVSVHZaWEpKTUxyWXZFRHpQdXQ3OXYzMXVNcktFQmhxT3Jz?=
 =?utf-8?B?SU1WN1pGVng5K25Ec1JBWXBpVW1pb1BqSmJTTXJHYjBjTXE3Ri9QQ0t0QkdM?=
 =?utf-8?B?WUJBYU55MmlYd1ZVTzZoNXFIU1hSQUkwNi9FMHV6ekVVbkYvK0hTTk5URlNw?=
 =?utf-8?B?bFpTRGxNQWZ4NVZVNVJHZVkzVW5CUTYxbDJibFA5L0pUTnVFYXhIU2J0aU5G?=
 =?utf-8?B?c2s1dzlENFRDbDlad0x2QTFzd2t3Y1V1b1ZjYkFIUWZsaGVvRm9HWGFNamhU?=
 =?utf-8?B?K1lnNnFDald5Kzg1N0xIWDk0cFBaWUZaSVkyK3BrdUN0aThJQm9NSmlDTTNv?=
 =?utf-8?B?bjNZdFZPS3A0dTY3UStXc0ZaSDRZdUZXR0pxaE1vcFY5eFp2cnB0VkdycU4x?=
 =?utf-8?B?OHlERkpjSFRsRWI1WnRsazFqOXlXVm50dHJSZGxMQVlMa3BKNkZxb0lVSTVm?=
 =?utf-8?B?dXNEeUZBdTl6WGR6dkRrbEVyU1ptZGtKM2J5WlAzeHM2cGZ2aFQzRVQ3c1VT?=
 =?utf-8?B?ZUlNbGRTcWs1dk54MlRzaXlwbE9vOTV3YlJVR2FJeGdKanYzVFJFeE5YSW5Y?=
 =?utf-8?Q?80rzyo8GYOxiOTT57ZmbHr1U+/mAvwtQ5G5kcsj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb2a916-d354-41d5-791e-08d904cc7132
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 13:50:37.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfKs7qPjkMN1JW4FlJiWGwDHoYlSlmzyuNvYB0rqkWs3DQnnBOia8mUBvpOnW/fgItz9tKV0yX2gkQA+o/9uoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/21 7:12 AM, Ashish Kalra wrote:
>>> +
>>> +		psize = page_level_size(level);
>>> +		pmask = page_level_mask(level);
>>> +
>>> +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
>>> +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
>>> +
>>> +		vaddr_next = (vaddr & pmask) + psize;
>>> +	}
>> As with other patches from Brijesh, that should be a while loop. :)
>>
> I see that early_set_memory_enc_dec() is also using a for loop, so which
> patches are you referring to ?
>
I guess Boris is referring to my SNP patches. Please go ahead and use
the while loop as recommended by Boris.

-Brijesh

