Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474762B4F2F
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgKPSZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:25:18 -0500
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:36641
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729555AbgKPSZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:25:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/8YXRL9CEbHU3e4p79OouZzZo+09oZdDWbcz3dqFbS8EIAbVd+Q6tp/0gB684i3Jeq+2oy9HI79RmmE622n8XkK96fNdGKUlJvcxa46XWsGrSgrR1WI+IX3hYcZsXwHpS4vkrwZMkPwrlGVi9xfppSXzrBIi0O4J4bvej6IV8Q21/hqcGvhzgsnBKF8PNXLRpqVs0uRX8d6H79SsRxZLb2imBEQ69Gpr0Rjhx8+H23kbtx4y0pZ/pjsnMb5swHrF5gHFwJW+5Ej6voULfjsWwaTGHwJ4o+1F7t1icpraY+oADGbkWMS5ShSA9zPBzsnXkGF9gm0hoHlXoaWQ7JkbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVHSJfFVpBs6Puj9AswYrqHKBGNF+EdJ8zTextYHY50=;
 b=QKCnqlB5L5h95tFEQl4ulsl199tXED5jOiKPxGGqtd9+FnI5nxruIJf7DHkhAb6FZXsQ9Mo2eSixUrkJFN/e8LtaBi1uTmuRH25faRSIzUuBBcR9GmTGkFOQY1gugUOYvt3cEtPYM64hV/vNkUTjI4R8XrHAwoA1LpKssbTtqhHuFjyh28HaBPVHb+4MOfX0FJEiX3xOwowhRWCmcknE4ukuRJ4vW60cpET4M2+OoXYnbRT3hsGsJLVjeOMpcsS9ebgCI1qc32JKgRjo3/VpDuKwNJFzYXHKG9fb5nwwamgGEBU8ST6ahR0B/KkICmAYlClLvH/he2jIOElFDWwRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVHSJfFVpBs6Puj9AswYrqHKBGNF+EdJ8zTextYHY50=;
 b=UGQBarf6A0g7kWJJzikxkmumGJp4fmJ7Ji9ugeU7Qa8UQauwQzgi+gIpHAQ44EonUsO75YV6mKLqIFfvveOrOUw9F+x5MIsO8ZQjjtsOt3dFA9HUVKxXbQQYaPqq3fFHsBTP9OE7vjXbUfS4TovpKezQuq3l4joh9Iny1GL0UPw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1771.namprd12.prod.outlook.com (2603:10b6:3:110::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.24; Mon, 16 Nov 2020 18:25:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Mon, 16 Nov
 2020 18:25:15 +0000
Subject: Re: [PATCH] kvm/i386: Set proper nested state format for SVM
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <fe53d00fe0d884e812960781284cd48ae9206acc.1605546140.git.thomas.lendacky@amd.com>
 <a29c92be-d32b-f7c3-ed00-4c3823f8c9a5@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f58c08c7-0c80-efe8-b976-ffb85b488723@amd.com>
Date:   Mon, 16 Nov 2020 12:25:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <a29c92be-d32b-f7c3-ed00-4c3823f8c9a5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:5:335::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR05CA0059.namprd05.prod.outlook.com (2603:10b6:5:335::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Mon, 16 Nov 2020 18:25:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 806aa8aa-eeed-439c-1d4f-08d88a5cf640
X-MS-TrafficTypeDiagnostic: DM5PR12MB1771:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1771440F480C560DB161ED44ECE30@DM5PR12MB1771.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /PHqeTn7FRITProNeKHUoB8qgvvYavqPHxaRTpOPEhthUE2zch1UVYpi3WZEdFW6V/9+Lo6AJ+2QKOdWdl1TZFONMucyMZ4bYxrGBCboDPNt4fGrFeWSiVC6suGfaV5yCYmQ+EU5IRAkkQyA3jaJIaK6fLInK/X/Z95Y2ise4AovSCtypg6y8o5EnoXKnAztpYRjZJUjUW8nwp5fLfna/XvjqVAt2dtJts1ZXs7aT7eHQd7NQJtSzUQXbISz8y0Bnn2ohoVWP/IKkYuglehx1/a0Rdsy5eFKifH2Ny/7q9Yp6Uo9u8TuWCDUBKcmQWLDZTvIiT2fqyU0D54aQycPzajwj19Knv6xDbQPxhPC1Sa+5TzoPe15kceeM+sFF4F4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(186003)(66556008)(4326008)(66476007)(6486002)(66946007)(31686004)(956004)(2906002)(31696002)(478600001)(16526019)(83380400001)(16576012)(26005)(8936002)(8676002)(36756003)(2616005)(52116002)(5660300002)(54906003)(53546011)(86362001)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /SE77x5e2SvspcJzpyEXQ0hVOB/yxOBJ5XVrY4BZKzOVdDYpptPYdg0IzuseDn14sVfldvWHlM6Vd5wmam6WJKW/WNs4z6PT9LJLE5hMzdRD5XfpUQwva8NiRLUjH3yHQv90Fmzc/fAEFHdQBRgIPfzh+/qgttG0FFiOZ3eVida1e7F8SuUKWppwadvjiH4ojlP/zs47s0xx3F9OXBEF9qxhwXQN0PCGGfEZJav4wtUWU8x2M3QjQCEK/iSR4RsdyEwpOCK+eGofaYpcr+ZFkwIMCIdAv6nRfbR6EeSIrmxsG/gqLcSUjOZNKN0iMarD8JP8sHUicbn2vIE/kV7I+bTpMoG+RJRgM+lVIMbjZAxs5wWOvxM6CGT4IuUr/t72QkuGUoupup5BEVq1nwmbLKt0qeFr2yOemXpYiFJZaxj2TfoOL4Rge+qNQRFLPXGu9HHAK6W6PquGHCschx4UUwIRGxhs0qU7qAMzaalQ6eXJqLjldK7XZvEYiJLCpKalErTEllqS3UgA+O+uA/XEZePUUAbe5HCiDA9BfJ+NFCi1+v20ze9QF7tn2WwDhz4iTqDEmnYd1Zr0YPt+Tk8VDqI0mt+QEcfQfnOJ5+c5XkuLj2BhTsTmfrSReSszKgPudDH+jTG3PSjQCVgTZ4M2TQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806aa8aa-eeed-439c-1d4f-08d88a5cf640
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:25:14.9404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65cce/489fQ/7s+8csLK+sTYt9aR4ZHonCjM446Y4antRlRiFoL8owtcv2xsrxRVgOnXtb8uuzECzuhDG8QIuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1771
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/20 12:09 PM, Paolo Bonzini wrote:
> On 16/11/20 18:02, Tom Lendacky wrote:
>> From: Tom Lendacky<thomas.lendacky@amd.com>
>>
>> Currently, the nested state format is hardcoded to VMX. This will result
>> in kvm_put_nested_state() returning an error because the KVM SVM support
>> checks for the nested state to be KVM_STATE_NESTED_FORMAT_SVM. As a
>> result, kvm_arch_put_registers() errors out early.
>>
>> Update the setting of the format based on the virtualization feature:
>>    VMX - KVM_STATE_NESTED_FORMAT_VMX
>>    SVM - KVM_STATE_NESTED_FORMAT_SVM
> 
> Looks good, but what are the symptoms of this in practice?

I discovered this while testing my SEV-ES patches. When I specified the
'+svm' feature, the new SEV-ES reset address for the APs wasn't getting
set because kvm_arch_put_registers() erred out before it could call
kvm_getput_regs(). This resulted in the guest crashing when OVMF tried to
start the APs.

For a non-SEV-ES guest, I'm not sure if other updates could be missed,
potentially.

Thanks,
Tom

> 
> Paolo
> 
