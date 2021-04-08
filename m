Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477EC358981
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhDHQS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:18:59 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:30112
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231785AbhDHQS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:18:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyGpv8+P5HlN12SIRrP/SyzZCAqk4ihCYRkz9+qu1qbnsAjEyLGlJ8sjICQ3FAkgHFTSlIvp6dY/L6gyve0YxiVRJaNoDI8kQgdncGzdL+xBaFCA6k7VPkKPjjHfFgaDMWqV3s0t00xa61XYSiJg0ESwhabR5sF/NP8G+1ZeW0rJ8p//xVFZ9eZEpWFQbsGUb2WtLAnwktBesArNgtU5xOxAlAJGDQKjpdxuz57QKt0ofx/WpyUprBWnIfjZK7Rhx+G78VXOyiw7c8vpukbjDxQ9RSN896zsDc+ZfiKKwO3soume3Wl8TRFQlfM1Gd5pTlMV7SNHrbBROhKDAhuMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4NKDvLuJrhRG4zyLeoC6FuTvPGjaemZCkr4aDgkGe0=;
 b=fGU8YY+UNsLuLKL/rFnXs1KRGo0xwv6Fg5D8NrBdbcj/u8IHEjKm+766YG6iQNcshT360gq+lZHLiNt6wFWVlV5Rdvnv0ES/sivhvd4KHqM9Eunvo+dDKWzYWRYSKU1vy+P1KpevtvtGA4IhbV74Zvl1ekOKb3qPBmtTyETa+IOr6h8FiLJ8OoSIoNuPx638Pz2+YY16ZXENbC//vsWLHkQ1HawzPAHVzXFi0/nLszOmnQD5gDvG/5mobTJAOHEeCfWhFwrTz6iPGbkzY5NsChWdBZl+fKD5Lh0qd0hgtD6n4fMwGt/U7NO0Gd+pKnGXbQXGRETlbQCf7OJZYf6tyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4NKDvLuJrhRG4zyLeoC6FuTvPGjaemZCkr4aDgkGe0=;
 b=y9S98+e+GLtqusyWmRc2NM035jSH9qqdJCkYd+unGaIl7xNMudR1gZP+P+xvsf8t6rGz7X+gZ8TufkPWlI4yNnEvBU1PoTE7mAPZb9o4f7D0ZpLQ7OAUywJalLVf9Zr+cZlxMEyKioK/+1u4bTsgQYf7kTSQqM8nKKZE+D3tfL8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1353.namprd12.prod.outlook.com (2603:10b6:3:76::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 8 Apr 2021 16:18:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 16:18:46 +0000
Subject: Re: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
 <YG4RSl88TSPccRfj@google.com> <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
 <YG4fAeaTy0HdHCsT@google.com> <b1a6dddd-9485-c6f6-8af9-79f6e3505206@amd.com>
 <2b282772-afaa-2fd4-0794-4449eda6fd02@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8654d5eb-e6d0-af94-db46-7a4fce8caa0d@amd.com>
Date:   Thu, 8 Apr 2021 11:18:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <2b282772-afaa-2fd4-0794-4449eda6fd02@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:806:28::6) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0151.namprd13.prod.outlook.com (2603:10b6:806:28::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Thu, 8 Apr 2021 16:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2d5fb0-5ef2-42cd-4d35-08d8faa9fc23
X-MS-TrafficTypeDiagnostic: DM5PR12MB1353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13539B530A4F878140D488DFEC749@DM5PR12MB1353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqkqC8LrwS9RJf+KlplfyBKkDmeB1Bh8Zb9ptyly/bF3vXvTVpEp1YDpQL0dBIXA3gBhekKZM3WzNr1t1CvC+FrvXOAwKhZEYpv+TOHzbmCeJhO6VUEaVB431I+37jSZ3SBAWErb+M7E57soE3QwtFqQQ53coKgECxjRmlWRj1g8Jg7mnTuTbL7FcHE5rk9IrszTtX1rpDCyY9fddF9oq13uGfKs1TOH34mMQKIQumUXEpKAKF8/kJ3qGKak3z7EfRsj7MFvx7sy1Jky0juEUVkBQ8b6qvT4sp1g3fqF2wJVCTEWuwUS16z3zRQlt4xKdNOHDT6MRt4iORghQHvYPWnl9vvKch7FyOAPnCINu3xiMxJm6LPQoVloDhy0VU2kGRfxsJX9T0RQGbM9uLTopEKAqL0UVU43vnpGisQT0LBJHe0c9kN1EwYh8I2dGnarY+y/NOKnFMAOzOQzBOTEKhvZ026OkRy7YkcC6ASP3JLLfHgb8fSbE9+lXsFE8nW0ylKA2SBs6yyBjj2i9TVvZ92oO58CmhEoi+KPzHIO2NQKr267FKoSxkNnsRT149gjpIBJkUten8258N5MxM2xYSbTvCYrB2X2GKp/oV9j73aFzj2rE1tYnYOk8xLt3XaZYfroz1oWYhqVvjhPbyhF8a7DBwXFadfXlHXwWi+SpcUUs9hVf5n/kEJyIiFgGCGBbXv8y31QvkyMU9+6obSy176x7F30/D6UM/26MFaubks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(31696002)(186003)(66946007)(6506007)(66476007)(53546011)(5660300002)(83380400001)(66556008)(956004)(316002)(110136005)(36756003)(86362001)(478600001)(4744005)(4326008)(8676002)(26005)(6512007)(7416002)(38100700001)(2906002)(31686004)(6486002)(16526019)(8936002)(54906003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d00weDFwd2tFVmNkYi92S0FVSXFpQUc3bGxrVHhHWjUrK2dtRUY0SHI5V2ph?=
 =?utf-8?B?UW0zdzQveHhOQmRUbnQwMnJob2NGb3UrN3VKUXJYUnFlOTg1ak84U2RIS1dR?=
 =?utf-8?B?NW9TMW4vZlI2c1B5ZXZ5QkNLMERjbkhHdDE4ZC9MK0xBVGRmcHhXaFR4UG9L?=
 =?utf-8?B?cTF4UFhaRFhzTmk0S2dLb3ZoUFdHK2doQ1AvUzUrQ051aTdTTElkZWc0aDYy?=
 =?utf-8?B?NjdReUQxeTBVS0s4NUVrWG55UnFnRTBLNUtLL0NFcjF3SlNqbnQyT28yMlVN?=
 =?utf-8?B?MC9ZdG0wZWxXbVI1NlBlRlFCdkc2bkZuaWR3SFJHTWVYdEtPa1lDY21BbGo3?=
 =?utf-8?B?SFlKNjdpeUhUVlNLcjFOSFVWMGVCelNpUXpFcnJETGJWLzFTOE9kS3Fqbkhv?=
 =?utf-8?B?RkFiMm9nVmF5Ymt4NUFQOFFOUVI0SG5Wcno5SlExWURKNkFuOVkybWJKYnp5?=
 =?utf-8?B?NStJWnhsQTlnQjFzMDNjdlFoWDhsRWNSb2V4TU9PL2JuQ3Q3a3NWRjk1MVNZ?=
 =?utf-8?B?RW5VWkc4NE55dWo3R3RKdVpPS3VqclRGYzkwNDhzWnFwbGJFbythY2JiUmxx?=
 =?utf-8?B?NjF0SWJNMkZ0c2ZJb0oxSmFheG1QSHZNTmUrNzV0TjA2YXNyRnNpZXhCMjJx?=
 =?utf-8?B?Qlc1dXkwZC9wN0xoeUZRZ2xYeUkyVFJDbHdFV1ZhRHpuTWtKcEsvcHJxQk94?=
 =?utf-8?B?bzRTU3N0QmlCbDIzMDN2Z1JTMFJzMGNkcGhmcGJkUUcvVi9LbmZJWm9Pd2Q1?=
 =?utf-8?B?ZG4wSW1pbFB6Zmp3blRMU0JwRUN2QSs3UHdNUzh2NTBub2wrTklheGl3bnR2?=
 =?utf-8?B?elZvSHowTTJFaUVvV3J6TEJsSklsQ3dlNXFRKzV2SEFNSWh5aXhUKzNzeGd1?=
 =?utf-8?B?V1V1ZXNTbDNNbW1KQkVsM3N6bG12ajc5TzJGMklHdlhUV0RvQ2pMOXd3ZHFW?=
 =?utf-8?B?U2FZa0pCc0MzUWs0YWQ0cDkxcndnUlYwN3BkZ3NXWkU1ZTFzdCsxaXdnakcv?=
 =?utf-8?B?VEN1VVVHa0VXc2hsOTdzcjZ1eHIydFIvNXhPWm9Xa0lhS1c4VERNRWJkcVBo?=
 =?utf-8?B?UE1wMGoyZTA3TnZHcXcwRjZQTENOb3h3NFdyandkTGN6dzFDdHZkTjZ4VCt4?=
 =?utf-8?B?TE1FbDFwWFl3Q1pLd2M2ckFnYS9UN1QvUEpHR1FhaU53Z1VETEY5U2VSWU53?=
 =?utf-8?B?Wlhlckh5QmQrcnBpcEJSK0ZDMTJ2VHZKSHRBaDRaWUZrT04yMldSbGh4RTRG?=
 =?utf-8?B?SmdBOW5vQ09LaFF6b3RlY01QY0Y5SVZHOWpKWWprM0gzV3Z3MW9qd1VtY2p4?=
 =?utf-8?B?UGE2YmJlbkFwTjIvTjZUSDVEYmhIN2xsVzdZN29zUXNMWHBaSEhTZEJ2LzZS?=
 =?utf-8?B?aGVXbnJGWmo0Y2xhczY1SnpuMGIrK0xncm1nWTg3Yy93OFhJWnNoRkNBN1VM?=
 =?utf-8?B?TTdsaFA1NWc4N0I1TnRveHF5bG9WUXZhd1A3b3F5OFJKeGVqMUtMTXh3OUoy?=
 =?utf-8?B?aWZpbWduWjdVUWJCSzZSazRlYjZwcndIa3M0QkQ2QTQ1cElORXVEaThwQm10?=
 =?utf-8?B?aE5Fd2lZYllCeVd3eUt5NkhWRnBDL1lwVTRlV29QUlpDTS9PV0ZxWlpidXR6?=
 =?utf-8?B?cHRQbHRxN0g0c2dQN1JONFZTMXptbzFVa3Y2bHpsM1JlQi9BZ1JxUTJaN1U2?=
 =?utf-8?B?UFBDUnRYNGI2a0JmVVFDVXV3b3B2RjZ2a3hXb3VPajFCZnBRQUNWNTk2VE84?=
 =?utf-8?Q?ME7DxSOGKhODLqvmVwKZ9q+YoZw4WYtyi36ihgL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2d5fb0-5ef2-42cd-4d35-08d8faa9fc23
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 16:18:46.0763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: clScLNtym4VC5J5Ccb0QnvyhX/Z+wBOVwNJnNUm8nhvBfRzW4nBbWNBkWL+RWpz6Bttidx0esylYEIUcOiLveg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/21 11:14 AM, Paolo Bonzini wrote:
> On 08/04/21 18:04, Tom Lendacky wrote:
>>>>> +       if (!err || !sev_es_guest(vcpu->kvm) ||
>>>>> !WARN_ON_ONCE(svm->ghcb))
>>>> This should be WARN_ON_ONCE(!svm->ghcb), otherwise you'll get the right
>>>> result, but get a stack trace immediately.
>>> Doh, yep.
>> Actually, because of the "or's", this needs to be:
>>
>> if (!err || !sev_es_guest(vcpu->kvm) || (sev_es_guest(vcpu->kvm) &&
>> WARN_ON_ONCE(!svm->ghcb)))
> 
> No, || cuts the right-hand side if the left-hand side is true.  So:
> 
> - if err == 0, the rest is not evaluated
> 
> - if !sev_es_guest(vcpu->kvm), WARN_ON_ONCE(!svm->ghcb) is not evaluated

That's what I was doing in my head, but I guess I need more coffee... :)

Thanks,
Tom

> 
> Paolo
> 
