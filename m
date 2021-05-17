Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5303834B8
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbhEQPLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 11:11:34 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:15489
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243198AbhEQPJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 11:09:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pbyn5CiQwBzcPTC7k/xIs2Pt8jLbblWtLvlPNodYL+sBUuAcOSRgQ3bir7TRmzpG7VBfZq0BU76IIdYOxzAEqTb5jIMmmdkzAhXBCFnnbnVWILE/Al7/fUQM4UmLpl5hvhVf8uY8xnoQo5nwk4sC5rOWMI+MN8frbzgK2Aq05cHfv3PjXtEV0Ot0zaP0TE2U47Y8X6hVqYRcHkfKGJbkq95NPpuOlOtiMhNxcvIrA780M5y3pXgVhvxi7alVQ7Kb2jCroATmEH+xF8yXaa77KDJhuOl5+mJ3J63ick9CuG4WpX9VVACswhP0MI1h3jROD1SwVzoBWGAMhhMg2oj9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y85aETXXlAsd0ivxnjLoQzt3e9H9LmzYixT6Yma/htg=;
 b=gXWBQq78kSVxx9ZixtDHHUPQxXPZjQ5QBXhTfhsPBCEEJCQ3rVeyGmGU+4sLtWhf6CIx7hymoiumGI3JzgJzBq5QpZHhjsl0kSq0wBOpaQ/FearFLva6LPDQ76f3g1tIOaQom9Se9dVcWfHUatxAxQlewGebOZWC5Tsj1P1Ml29kadu+Hqptn4NUUWCb37YEtuAwiGMymMCUMmLQYf8hArkQwRYkY21ZI/krjll5t3h1PwH5ESdspl+LdEH8JuoYHkjIly16qdYpmi71ZOaEl0mnrhh8gnElhKXd44EW5SSzXmcnu//17e8tIXBbdJaS09YcyS/NGOJR1wW5mwDNIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y85aETXXlAsd0ivxnjLoQzt3e9H9LmzYixT6Yma/htg=;
 b=ZJQKFqR8GioZRp0veTxTJSZPOk1h76846ACKVZVyNXY22mGNzIR09T70nKavUa6Wxx+MkXDlZOjjncDo9QluhNcZhW4bLpU6XK22qEX36Hu30PYx9oJmzzLMRVqwlSrv1cWsR86wZZ5Gpb+4ScxPGDlEuA10akqd5hiCUyG3mI0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3178.namprd12.prod.outlook.com (2603:10b6:5:18d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 15:08:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.031; Mon, 17 May
 2021 15:08:06 +0000
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
Date:   Mon, 17 May 2021 10:08:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:806:a7::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR10CA0009.namprd10.prod.outlook.com (2603:10b6:806:a7::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 15:08:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7274f2c-dd09-45e0-5a73-08d919459312
X-MS-TrafficTypeDiagnostic: DM6PR12MB3178:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB31786CB7F24A6B490BEF64A2EC2D9@DM6PR12MB3178.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmRq7F1/5WxhlR3PPc+GbDs7kAnS/qVVjQr3c7pLXQRbhOHe3NahziPt6NPkpOQbuTMfqqJaxA5OExWySUFPK+uV5fG/VbYdoHDwr0PVcBe2tzke2CoZyoG1yzimuA+m6zKwvS1HVGYTiN0+rsbqM+tkEzB+Yh17XVAuBZqE1CG0HelHFewRrnKhBjb6hndPZmiJQRf3iI12fZA7j4lvUNQcNkXiktxFjzEFqRTfyBlKILs8Of2e0yOKXYWvM2P8OCAlmgKZkCqaaa4FwlS+BuP8GTH/3vSQQum8Nskc8/HIzsUFXpfcqB9CAmaKx28N6hC/q/W8OzuPMcRnd9sgAkdljJCOtRlLdgZWi0FrKdp9ZAUgFazQDmbtt4gBDsbkTsgOlmBGbQGhrTZ+GdfFFgXqHRJNd+/sEke+XnlRCnYBJNPRUwE+JiMLHyFo63eIXjwn+V8X9BEM3mkp5AWSbvGq0nLl+jTLX89XSNshADXqiEA1IcT+2w5MsXhfbt6B/JdV1mMWvMmygsAIWn+KRdojP0GTLPuujTA/pE8D0eWcI9TsG2iOk0sTfgx6lKQ5Q6nvht3Klg7x04MCIYu4P1XQNq2f0PYWjqbbSrUbCA4LWp/R+N82zyEpSTAhQq8vac4mECM2Sg6B+5DVG1mqzEnCKkSUpgy97p0WhXFlLzkW5dKRrTJHH1kk7djlZ234
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(136003)(346002)(396003)(5660300002)(316002)(31696002)(956004)(186003)(2616005)(31686004)(16526019)(6506007)(54906003)(86362001)(4326008)(53546011)(4744005)(7416002)(38100700002)(6916009)(6486002)(66556008)(66476007)(83380400001)(8936002)(8676002)(6512007)(26005)(66946007)(36756003)(2906002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Qlc2VzhWRkYwU0NnMkZkSUhZK3VzcGYyUVNsL3hmTFVLTVJoVThHTkNqNE9r?=
 =?utf-8?B?L1RTLzZrODU1NnloS1Y4b0RKaEJTY0hxOS9ZTzliM0VEZFBFdDV0dVFBOUJH?=
 =?utf-8?B?TVlQS2RWSE4rL1FHSElsOFIzR0g3K29JZUF3WW1LSngzdisyckpvQ1Mrdkoz?=
 =?utf-8?B?ZnlqZzNicklzTmlMQ0Iremc2M1p1WnVxK2QxMTQ1Q2NpZHgwNGlDOHg0TlY3?=
 =?utf-8?B?T2ZoU0hFTzBZbnFIcVhNU2dRWWtSWVh3SHR4ak1rM2picVZkcmtPVUV6bGVR?=
 =?utf-8?B?OEJpVllZd283djVGLzV4cVhJMlhBYVErOTVONUNTMXBiS2dHR0w1bGJ5d1Jo?=
 =?utf-8?B?ZEpEZXk0bytpMmRDcjQ0dUd3b3dHL3BTa28wYmNDYmpzaU1TZ0t5bXN5R1hI?=
 =?utf-8?B?YjZiNnBXcDFUdzUwUFVTeUI1bXk4elIyUkRSZHFCUElxK0E2clBnQkdHT1Nw?=
 =?utf-8?B?SDNtc01RRmgxQVBQZHVhWU5MVWVaczk0ZXI3MzVWR1JLMHE1OTNLeFQrSXpn?=
 =?utf-8?B?MVdueGJvQ05UMU9lM21FNlpxRWQ2UTdHV3hpTElqdzh5S2xQTFFObkJjWEJG?=
 =?utf-8?B?UXZiSlBwc09nK0FXY3B0NmxOaElxSFFkSVoyMmtEbzRlMjBWekVZUWMvSjZa?=
 =?utf-8?B?c3VBN21HZ3hoYzl3MGEwVHI2WGs0ZTkydE5UUHM3RWltb2RQYUV1M1F1RXdH?=
 =?utf-8?B?TmNVdmxxK1dRVmQ5VDdSZmF1UDYxMHJWc0krd25xYy91Q3BYUEczUTdHRXJM?=
 =?utf-8?B?b1F3NVVMZ2l1ZElKZmlRdHRFNG1nc0Y3TmZZazhlMjRwZU1naDFWTTNYRjBV?=
 =?utf-8?B?ckM3MDNERXA5VTZkMmpmckNncndhUmZJMld6ZXRxOTBMSnd3dzVSTlBkRU9U?=
 =?utf-8?B?K05qT0l5QjMvblhOakxqYjBtV0dudWNoQW1YdEVvTm1yUzgzNDIxRU84aHRO?=
 =?utf-8?B?eXcwSmsveEpkMFBhazZiclhvd2QwUlNKYWtLcW8yUzAyRm83S1k1QUZUTytW?=
 =?utf-8?B?bUNUNUl4YnZySklVREhpQVQ0bmRsbVVuajdIN0R2aEJCcW9xaXR3blJWbVM4?=
 =?utf-8?B?aW5Zci83Rm5rOWVPeTBKZ2RvaUZQVFREMm44OWZZRWdja3N1OXJDNlc1SXlO?=
 =?utf-8?B?UU0wQ0NrbU5ZN0FrV1JlSVJZWVRjTGF6M1JXSjg0OUVxMjVJRS9GeGF5M29y?=
 =?utf-8?B?czNZSEVFcnZMWTVnbVF4R1JTd3NEUkFlMWZsODMzK29DY3VzbnlSUkoxUnds?=
 =?utf-8?B?YmNRRnVXeG9EaWt4cGFzcjNkMWZHNm5oSitwN1RFYXRYUzBrMk5NU2ZPdGMv?=
 =?utf-8?B?ajNiM3VTSUdybnNBMmJNSm5LVFNVK2FKcWZCMjRUdXk1bWdGUkEzSVd2QUxL?=
 =?utf-8?B?anE5cncrV3E3T2d3SmRTcW52K2VMbE9iR0lCS2YvN20reGx5L3dtaVRYR0xr?=
 =?utf-8?B?RDROSThvblQvcmViMGYvN3oxcDdZbUFhakVjRVZocDg2UVVhUHgxYTN2TXpN?=
 =?utf-8?B?d0pTdjVpZDhtM0VxRFNyd0VYRjJkN0JPZi9lV3FhVWp3WDlkRG82QTBpa085?=
 =?utf-8?B?SlFqYUpmek9SZ0NBVTVaNTBvLzFxSXFxemxVQ2FucldmbThrS3JrUUVxUmhB?=
 =?utf-8?B?cVhESWxEWHJEUS9Na1k2bVRHeFpkR2FMTGxoeXRZKzhsOXVQU09kdDJHSXEx?=
 =?utf-8?B?Sjd2dWViWVJFYlRSWUhWbTBLSWRUS2pzSkc3NDltdnQ1bVdlVEV0MHF3dXZv?=
 =?utf-8?Q?2Xk78V0bZ0LCO/icSLXkzPwVZTpWNVoui5DUjNV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7274f2c-dd09-45e0-5a73-08d919459312
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 15:08:06.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U//hAQxKERGBjAnM/y7rhT28xvsRbynjVBhGNVE8J9d11k6pppUlopIaLer/9ZE+IvPR76xm9BDYVqEcTpZudA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3178
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/14/21 6:06 PM, Peter Gonda wrote:
> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
>> from userspace, even though userspace (likely) can't update the GHCB,
>> don't allow userspace to be able to kill the guest.
>>
>> Return a #GP request through the GHCB when validation fails, rather than
>> terminating the guest.
> 
> Is this a gap in the spec? I don't see anything that details what
> should happen if the correct fields for NAE are not set in the first
> couple paragraphs of section 4 'GHCB Protocol'.

No, I don't think the spec needs to spell out everything like this. The
hypervisor is free to determine its course of action in this case.

I suppose the spec could suggest a course of action, but I don't think the
spec should require a specific course of action.

Thanks,
Tom

> 
