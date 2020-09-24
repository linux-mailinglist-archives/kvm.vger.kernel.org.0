Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCC1277268
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgIXNdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 09:33:19 -0400
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:45152
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727685AbgIXNdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 09:33:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rfbvkww2g76i/x0ui01hyJtPkmmYXcZkXx/p8l8hi1CRg3qYe3pSDUs1KDZRQp3fMYq7QU2TmhGfbyFYy73Knrf5NzpKwqQ4pSDffZKJnI9dCZK65iF7NVas18AlYgp7+IOajzr+1FQIa+hklx7PfjhQzFRqtO7Se3vg18OCha7xAVSSXOSzob0DUL5OCjK1HV+mlX/SnkDs1wpDEp2TcPayZ6Up25ISCA+YkJwwur2Wy1+hGcvLRqB+v736UtYX0rIU+Xl7Mb94t1LHW4JPoC5czmicUwGz8a93M84SweKgyn3lt2iCTrIJZUEQrH5hWHO1jGVRgyC74goYrMMtpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93Z09eJAEouNEKwIV685wR/Eabybv8Vy7zf1VfNXe9M=;
 b=SEN5EjBlZq/qd3E6kfz0HG4p7syPo0jdEuCXPuEmK4PC+f/itA43xvhJsqQD6IOZx7LCQ5oirAh1DIkHT1l04zjLxPFONb2Mnm5GLmu4QvYAmqc2ovi2kkBlxrQTsbGYkNhJSnNd4GguUlxrp2/lZRZSwZHKXeBnqiKweaELwbMxVQlOjQGm96/J6V1/A2oA3IiHz9KUdSgTdQHobGJKUNl3F4CGfbvmjOyJy0a1ZWjoIX/RQRPwr/OjnMuBYCN2eFRpWJSQbCgoP2BUjeP+TpaWvA2g7vD796kfQ5bLZNdNQN1iItT6WNFsxyOe8igEzvwgkVvdgXF0ckgjUmHAxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93Z09eJAEouNEKwIV685wR/Eabybv8Vy7zf1VfNXe9M=;
 b=SNXq6FzNJQw7FaqPBUFDclGtPtxKoHRTaVqIS3dEBXicJy8KeAoW785NYhyH6Va20fc4Vhz96ZTIlWvvr9elpFHGDBFRIDaDLqoqx7KVi8d6t+1wVzRgPGov7ASnp/zRPy3a+ATLql0/8KiAmeXYK9/7wgEhCmnRSE5UfLuhPcI=
Authentication-Results: zytor.com; dkim=none (message not signed)
 header.d=none;zytor.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1162.namprd12.prod.outlook.com (2603:10b6:3:72::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Thu, 24 Sep 2020 13:33:17 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Thu, 24 Sep 2020
 13:33:17 +0000
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
 <20200923203241.GB15101@linux.intel.com>
 <12be5ce2-2caf-ce8a-01f1-9254ca698849@amd.com>
 <d260b1e1-1a53-a7ee-e613-a806395582f6@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <185c1a30-0028-03c5-6c74-6a4c7ef7f257@amd.com>
Date:   Thu, 24 Sep 2020 08:33:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <d260b1e1-1a53-a7ee-e613-a806395582f6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0033.namprd04.prod.outlook.com
 (2603:10b6:803:2a::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0033.namprd04.prod.outlook.com (2603:10b6:803:2a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Thu, 24 Sep 2020 13:33:15 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93cb7ef5-7dd9-473a-9c6b-08d8608e64e3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1162:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11620051F3C7854B8062C91BEC390@DM5PR12MB1162.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3ED5HKlCG5A4GaAd0ata3zeYJiE1zz2LdNVzQMQpP6cfBtUvCQtUhN+cceGABD+kkY7X08BWUIZYNVMbiCbXcKqg98a+W02hKkw+sDNXeRS5aUbnppOrsqPsRIWi6rtmzzoP85/UQwfYDMj65UUBKQzWVzAX8QamKSLG8H+h4O3EICTO4mKxtkpp68r6YlUsl8Zp3LDHQyQyUa/2vhhavdW7OGKgsEiHnPdpgsyCvMJd93quGADCmbkiKA77VLxzmqLbuiAkORIbdB1qfV1hLkUt+tC6X4NBp/bdv8rUrRQkmDH9QqN5JXurCdqbJVmu04/cWu35Fb0aqlhbJdTC0cxdNnEkzJDzTq6wtiN3zVnSsIsxvMnl6LdMDe75QHS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(4326008)(5660300002)(53546011)(6486002)(26005)(6506007)(52116002)(8936002)(8676002)(86362001)(31686004)(31696002)(66476007)(66556008)(54906003)(2906002)(66946007)(2616005)(186003)(16526019)(316002)(36756003)(6512007)(7416002)(110136005)(956004)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: K6oPb/p2+EQG5s+QAENBeddys1zDAgK4ujxDoiP7Pts8CqeEFfI5WtC84Q6AbatB4ALZzKYv9TVf99iuSk9mGwj4CtuKh4hQ6UcsO6vpcjyBkh14IjCrb4+7lQyUIu72bic20pRWMUyuChsKTUEa5lG4tf8h5fooJp9N4mjuyL0TZjOygRaph1OkVl26GQ9ee4gcrBq/vo99UacDT/6hnoeYNBx/FKrvAwyJc60ISTLeX9lrG5sxi5uEQ4v/ITI9hQ9DaOs0yE/Qmj68cGjyjMrV2T/PJ14RI9Q7FHt1cAT61EFv2G4Bj8Wk6Q/plgPQIDxq8dHzMAhVNUIla+eeHkOHiOIEfkSFwt0lDFtwSVlxALhfAPzVqPJO7A4rEjXJEzOELmjS2hmpx3/mOMXnzfHB4nhY2/PiAOy0ztrkn+MeI5lLz4RIz2Ld9lGftTYrGvbl6zYwOQHiFvBMfG2JOSxtuvPNm+DrdoxQpcPtKy4IFBtbzmCp+HfKl7RTTU/Avax5lpwcLZVjZmZBy0F0Gf/YMdVBU7a/1pqz+uX3Dd9ug6SCbp9EgnS1yrOpJdPcc+yUv39pcJnCQ9xRyKE4rq8Os/w4rbZ+ZPJr9vnm4hoaHdE/h/jb0rElFnp0ptm7d9XxpKfeqdIVdDh5P45OwQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cb7ef5-7dd9-473a-9c6b-08d8608e64e3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 13:33:16.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLmzT4ygfaNK8aji9vJWh+jHXGk2/No/GwQTpRI+W9EzK3Yk3GNVO0abIjCClXlE/rztQNsazfQ5uKjl7Zaxrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1162
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/24/20 1:51 AM, Paolo Bonzini wrote:
> On 23/09/20 22:40, Tom Lendacky wrote:
>>>> +static int invd_interception(struct vcpu_svm *svm)
>>>> +{
>>>> +	/*
>>>> +	 * Can't do emulation on an SEV guest and INVD is emulated
>>>> +	 * as a NOP, so just skip the instruction.
>>>> +	 */
>>>> +	return (sev_guest(svm->vcpu.kvm))
>>>> +		? kvm_skip_emulated_instruction(&svm->vcpu)
>>>> +		: kvm_emulate_instruction(&svm->vcpu, 0);
>>>
>>> Is there any reason not to do kvm_skip_emulated_instruction() for both SEV
>>> and legacy?  VMX has the same odd kvm_emulate_instruction() call, but AFAICT
>>> that's completely unecessary, i.e. VMX can also convert to a straight skip.
>>
>> You could, I just figured I'd leave the legacy behavior just in case. Not
>> that I can think of a reason that behavior would ever change.
> 
> Yeah, let's do skip for both SVM and VMX.

Ok, I'll submit a two patch series to change SVM and VMX. I'll do two 
patches because of the fixes tag to get the SVM fix back to stable. But, 
if you would prefer a single patch, let me know.

Thanks,
Tom

> 
> Paolo
> 
