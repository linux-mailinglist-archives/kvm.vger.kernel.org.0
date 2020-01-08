Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDF5A134460
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 14:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgAHN5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 08:57:24 -0500
Received: from mail-mw2nam10on2081.outbound.protection.outlook.com ([40.107.94.81]:19564
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726411AbgAHN5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 08:57:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNwEf1fZ50n4GlkvpABul6brPwXojtYD+p9omDtNgG4C0RRPGQPQxEZTMCqPc+zSIOkaUH+Uh/679L9sb0wxWTo1EgHUAHj6vywO1EyUrwSxAmwOAFEZ/Gwwa4xpTDFYc4V4AO01uEsVraHeE14lwIvC3Bk6hS/KrrqpiWAu6dGm3HgaxZSJRbybu0PClHAGuGTbgPL6PzwtWX2rWdTTc4cpDdtWRSIsdmrLRSu+aGuXFxBn2DNcy3RTVWFTdaI3VjFw5AD+UqL69SMMwQB6nHu76BFUIFHMo2OrqXhLdmh9PdycdR47rCoJqUralk4BoQ1YWpeStbjU/UP91/dIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T83LAauHoeOdzAcUhrtlU61Xls3P2KIPGz6kr7asEUA=;
 b=cgQAP7Rl220Nu8FqZ/QaZvJ+VvBK4XoK473kGlfAC0ZUTzShQOFTIJudDnv5j59pm2n9eHvSmXbLp4d9PeTrIkKUn569oXVGAJAVOH7StMLQWuzBHcljXGDbOCqWwa/CYZ0cKweEcBT2mOV8G5uPbYW8hdk8jUsc5QZMpSl4H5Ov9FNwBzR9HALrwotQiDPkv+MX5sx0JTLkEF11ksEwfAICq08r96bodXror5cP4slMwKMMkmZJjGMlcIg25+FYF1nI9bw2p0a/dYw6AJ2ZLIoBgRbYLHL6dgbRtQcz/dMkz+2Y6P+BuGELywmfojS/sltlmisKyHAYSsw8dwVH3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T83LAauHoeOdzAcUhrtlU61Xls3P2KIPGz6kr7asEUA=;
 b=mqUzBXXoZV8Yw9si5VkKfGS1YgpSVvL6+aMsiD4jgwru1vckf1nlRPn0PwkJe5BhhEADeQ8n6p+ytpMxCbwC3i21n2uxV5oXcI1pJ8blAR+3YpytcJXjIfQYTLNOw7ik69NUj6p9JoaE2O7TUBPrN+iAbTRb2JPoyawM5NK7tlI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3449.namprd12.prod.outlook.com (20.178.198.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 8 Jan 2020 13:57:21 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::a0cd:463:f444:c270%7]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 13:57:20 +0000
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
 <298352c6-7670-2929-9621-1124775bfaed@amd.com>
 <20200107233102.GC16987@linux.intel.com>
 <c60d15f2-ca10-678c-30aa-5369cf3864c7@amd.com>
 <20200108000412.GE16987@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e2b183a8-ffea-2df4-2929-a7f67cba8a81@amd.com>
Date:   Wed, 8 Jan 2020 07:57:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200108000412.GE16987@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0102.namprd05.prod.outlook.com
 (2603:10b6:803:42::19) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
Received: from [10.236.30.74] (165.204.77.1) by SN4PR0501CA0102.namprd05.prod.outlook.com (2603:10b6:803:42::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.7 via Frontend Transport; Wed, 8 Jan 2020 13:57:19 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7da248c7-6de5-47ed-f407-08d79442adf2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3449:|DM6PR12MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3449609A5EE49241BD940430EC3E0@DM6PR12MB3449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(199004)(189003)(81156014)(478600001)(31686004)(86362001)(5660300002)(2906002)(6486002)(16576012)(81166006)(316002)(8676002)(54906003)(36756003)(8936002)(66476007)(66556008)(66946007)(26005)(2616005)(956004)(52116002)(53546011)(31696002)(16526019)(4326008)(6916009)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3449;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJCthGWL77v1fGhN1ue64hvdLLuTzcoihxpgtWc70FV9tX3+WckgvCG4J7HLCJllGHU7D8H7dS94HrM/KhnXFCHhna/0qYRhtn6l+Dom0F+VdrdOcoRc6uYQwVZrgc5uY9Uy2HduUMRU5pLAFYVuTpD9csL6mDR8qOg90o4M7eCBB2M2DwU7uz1S8ueMaPBi7B0sVe16eQtHjC0qNWBuvnMW2fjax3rBMqebagQraBg2iIqulxTRyV9bDU3TCeYqvJgu/nqU0N6/ql3r4K4BnI5DkykKmTiy2jrAbMQqsQBWeY5wrAMrvHZCO75iHVsQV1JeH1Ze5LEiwuYbLvwKp8sbHWDuwn+Mh6JB69gsTYW4hli+gsWfc7tvUz8EQZy3Ti/qhQZBUPNOwds49U1S800iJPiGSNvTpujyURgkP+jxujTMbRbj7AmErdOXgJVQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da248c7-6de5-47ed-f407-08d79442adf2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 13:57:20.6665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wWcqpoS0OvMNSoHQkrHDdoMsOj9zi9NE2XG06b+uLCt3bVK6rcolBMfGChjbwe3RYcAnv1JRk0kZ4X4aqdfsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3449
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/20 6:04 PM, Sean Christopherson wrote:
> On Tue, Jan 07, 2020 at 05:51:51PM -0600, Tom Lendacky wrote:
>> On 1/7/20 5:31 PM, Sean Christopherson wrote:
>>> AIUI, using phys_bits=48, then the standard scenario is Cbit=47 and some
>>> additional bits 46:M are reserved.  Applying that logic to phys_bits=52,
>>> then Cbit=51 and bits 50:M are reserved, so there's a collision but it's
>>
>> There's no requirement that the C-bit correspond to phys_bits. So, for
>> example, you can have C-bit=51 and phys_bits=48 and so 47:M are reserved.
> 
> But then using blindly using x86_phys_bits would break if the PA bits
> aren't reduced, e.g. C-bit=47 and phys_bits=47. AFAICT, there's no
> requirement that there be reduced PA bits when there is a C-bit.  I'm
> guessing there aren't plans to ship such CPUs, but I don't see anything
> in the APM to prevent such a scenario.

I can add in extra checks to see if C-bit == phys_bits, etc. and adjust
with appropriate limit checking. It's in the init path, so the extra
checks aren't a big deal.

Thanks,
Tom

> 
> Maybe the least painful approach would be to go with a version of this
> patch and add a check that there are indeeded reserved/reduced bits?
> Probably with a WARN_ON_ONCE if the check fails.
> 
