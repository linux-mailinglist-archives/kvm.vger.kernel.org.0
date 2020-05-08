Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37C1CBA61
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgEHWDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 18:03:04 -0400
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:62016
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727095AbgEHWDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 18:03:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBV6WMzxtybTlrOATbcrIrSq+yqfK9LFB8DiZKlWv1IThvCBwVIHffasszbMZ84opv1W8gqpvMJLUn1y50OaAF+C3ApIgrNb97a65kgCYw7fgPuzDhthWcFcl7J+NHDNbpTrBBWdrJoN6XJfJpxQgOU3bhVZ/vLj+LnawaklX22DXRD2uDHTgDuq9yqEjV0ioS5f/o4B4ogr24zEX3/EE0q+v3j2qxqHosEqCV9igSKGlb5oiK1A65BZr+W0JowQeiC5roRR38GIhQoW//7HxmX49Bb9NASrZ6/eyvsZd2ElO21joGH9rch6N1qU8CzR8sZYLGX3cg6ynFzEIXGx3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91PaI/OphjNQGZXeKxT2UVHu4PV4AMr9IQdowg9dluY=;
 b=BJNSikDMivaNCPA2HWPNV3yBOXCDbP5nvio7o2f0L/PlO4abpKgsX0iZBCkq2UoaGdY/+a5wjLCGdi6Og5zuOmv3gO0hzZ8AcukVfD9tfUiSJ+uwM1eGlLBB9WtQznR1F60stoBseUYbdsZ4btOShRQuxI63qaVxOcaqjpTeogL+vLmDC/dK4MFfNDiorKLcByJGUyX6JyBehHlAElmUIFpNguDM5NQS+7U3UuL2hhenVku7GGI3krkOQ/2GsH3gaIlwYUILjvOuRzcgPO3+yS5GDCkJKGZJZDQ+KlpdCtiF+BQPu+pbVUSryI9yFg0c6/Dq4QnqSEmmb6JZEtWnuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91PaI/OphjNQGZXeKxT2UVHu4PV4AMr9IQdowg9dluY=;
 b=YUkuwILmGaz9yb1LzQZNAwpXNza91wGecDQHv1kebCbnJz2QgDWGXkcAI3lLwlZ4EIFw5qjAmHBpfmSOTLaUYUbaZeLQuC6gmicEuNjV4b6iQlUv9ofi+rBJbe3Qj14rNGeUJkA67Qvm66Q8qsnRxNk/yaXK+VB9Yps+LYJV0C4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2429.namprd12.prod.outlook.com (2603:10b6:802:26::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Fri, 8 May
 2020 22:02:58 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 22:02:58 +0000
Subject: Re: [PATCH v2 3/3] KVM: SVM: Add support for MPK feature on AMD
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
 <158897220354.22378.8514752740721214658.stgit@naples-babu.amd.com>
 <20200508215554.GT27052@linux.intel.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2f4126c1-3c6f-b2d0-2ebb-80dc8f86304c@amd.com>
Date:   Fri, 8 May 2020 17:02:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200508215554.GT27052@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0015.namprd08.prod.outlook.com
 (2603:10b6:803:29::25) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN4PR0801CA0015.namprd08.prod.outlook.com (2603:10b6:803:29::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Fri, 8 May 2020 22:02:56 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73cd85ef-be49-4c17-7efb-08d7f39b915a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2429:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2429C40405D21FE43088594A95A20@SN1PR12MB2429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvtZC543HcQuQ0ZIBmNmWT/3JVYrMoXA8gCOdmEWkbcSXD6Axsz1XouVS/eGlWE/96ZWP1cPpv0mCEOupargmW7VQfJnlQlMTQQd7glnqlmOLRqipkBAZ9S5Dq376hh/SissOFpStWa6aEsJ4lmseWXH1AIOwCHHuml4/npJAH5sSpHPVkRqzdVlYbckoxLygZJ0Ke2Sp5ofuyvII0s/GZTrDQHFwi4hkGgIBGrAAViWP3HWsnPT34PrRq3uS0ZOUyg4qnrbaDWEqjg0TIjh42Fh1kCjx3GWQiQAYIrfcn4HIGHk1+QkwE2A6RBqlNOBGfeLcp+/j+3qHVk73YcecrR4w0GMkELmwyDaHx5WPP6h88WYx+vjxXtgBd5eHTR7jyNptScSWgG/I+QqiEm4RvEmPMnSOgwdrA17LZns6IGCaa4A9Uyfk+pMeJoLo0tOBbUajy8CSga38U44wFbApln01HyHMG5fnirlU/ly/ihV1h4hsihTKd027fPzzWyo3BUUujHMZT1UqE5Y4NrITsuZ4IsuSzkF8WUYaJFCyd2u3pQYUNUZeRItu9Ud+W7ClDEAYPNAGKh9/lUJXjiQUaHxPOCZIgnu+G4oVmrnMoIQINRoheJVWhQvMioN1F5myTEOMpkoTPDELWYSqHP52w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(33430700001)(2906002)(16576012)(7406005)(66946007)(31696002)(31686004)(6916009)(966005)(45080400002)(478600001)(26005)(53546011)(186003)(16526019)(52116002)(316002)(6486002)(4326008)(66556008)(66476007)(86362001)(7416002)(44832011)(36756003)(8936002)(2616005)(956004)(5660300002)(8676002)(33440700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8ptMWkRla/5MBt2wMvk+cwGpkui3Tn67szx6RvZptAwcrk3/1W7ob27cEoXT7SXj8u0PLcfHmQjg5rvigPO9um84+J7FOJRvbCEchwptyXEOwp98HfkDI9g7SVCUTjc/kb8TwkzQhtmcQU6jJlZo9GLISkzA52c7VzczKM6/bMqeoQyPv+XUJN0PRnl13IMJULY5wk2CaHYK8I94D1u+U3uhAHZLbYk97eHhq/FfsWdSiXSsKoodLVfCuWcf5Lt2Y43BFB3pzXz6HVRzeQWlSB9Dja2gdwBf0emit3OrtvcamAxFePEzfpMOTk0Rh5irymGiNIaY1Y/9xamT7M77f/gDHEf65Md8+aG5uePQAazOQd75eSQoMoqvbGme+i82qt40Xw2GUhtItRfDdnqFxvQCwllbD2ajPYknd6UCDJW8qg1BahRCuw3N+VM1Pux2WTnZNsy1Yy4wMCl1N3IELvO+QV2miANhVorI9ggaXSU=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73cd85ef-be49-4c17-7efb-08d7f39b915a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 22:02:58.4009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rD6hmgg4X7uJ7dATucZjpd2NMYin3QTf/Z139DQjeUcqgtcpNvGBBF8XoTjWhGa0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2429
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/20 4:55 PM, Sean Christopherson wrote:
> On Fri, May 08, 2020 at 04:10:03PM -0500, Babu Moger wrote:
>> The Memory Protection Key (MPK) feature provides a way for applications
>> to impose page-based data access protections (read/write, read-only or
>> no access), without requiring modification of page tables and subsequent
>> TLB invalidations when the application changes protection domains.
>>
>> This feature is already available in Intel platforms. Now enable the
>> feature on AMD platforms.
>>
>> AMD documentation for MPK feature is available at "AMD64 Architecture
>> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
>> Section 5.6.6 Memory Protection Keys (MPK) Bit". Documentation can be
>> obtained at the link below.
>>
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbabu.moger%40amd.com%7Ceca826ce565e450edc0b08d7f39a95f1%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637245717572330988&amp;sdata=IaZXO8LLyXMqP0pZBYKzkXY4cInzpjBbSyzcnIcj%2BoA%3D&amp;reserved=0
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 2f379bacbb26..37fb41ad9149 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -818,6 +818,10 @@ static __init void svm_set_cpu_caps(void)
>>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>> +
>> +	/* PKU is not yet implemented for shadow paging. */
>> +	if (npt_enabled && boot_cpu_has(X86_FEATURE_OSPKE))
>> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
> 
> This can actually be done in common code as well since both VMX and SVM
> call kvm_set_cpu_caps() after kvm_configure_mmu(), i.e. key off of
> tdp_enabled.

Ok. Sure. Will change it in next revision. Thanks.
> 
>>  }
>>  
>>  static __init int svm_hardware_setup(void)
>>
