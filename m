Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A7C18E110
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 13:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCUMQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 08:16:45 -0400
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:6079
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727224AbgCUMQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 08:16:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdzP7xhwvXJekNkVrWQNSHyaF6rsuvQoUBJ4ucUmQ5/Fi0afvsQ+X/diIAeJKdiY61pLcTNZAMF6o9Qd6FIGrSa8auxx5UWHsAkI9SkqJ36CxFvfPMwWldCDvxnYOhspnyh2INcFitxfVZxW9tucibo4kHEaD2MdazUBugmfs1BbhigWCGG7Mnsq2YUvtBXfpI9SvbkaH6PEWgaHv2qV4lgPV2ks5CQ6fQozvF9cgEp/Sg0Gd9jT/NAyFChY9EtIxekX4Ul6xjDgXVS8IN75kyDuELd5LqCwL16MNffTcFHkXQg24W+Fh01vn5sc4LpvJX6h6lX76+O8scYb9IH7Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJct5OFf/OlKumSDt9/5HWwIFVt2vXgj/eFksJFrGWs=;
 b=Zow1P1Ygfs4zKa5c6fddHgmzmignpMpCDAeyn1AO4cec/r5sQuRxjjgecq1/orcbzFPmZ134nH8UEh1c5e8P1dNrCP4YI8x1qJ2N0moyEbQ61wXEf/GDN3afSQwSKCR08uVFxVSGrLxqfV9CKnir14E7IxKBSL3ICiUK/jGBopGxUrshcxrnSoOCiPhOdThjOuFmN9zkZEZXT8xxm59aFt4Fmt9xt8h2kFlxX6X3BSrRE11WrM/msV/qB+91NIIqR8x/NSwHKVD9YaTESed1J/+qbAlquTs0318b5a8tSXKXsekcnRKoja5r9cteib5+MdARdwEweWv6KSwiSDnwKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJct5OFf/OlKumSDt9/5HWwIFVt2vXgj/eFksJFrGWs=;
 b=mblfNr0C/2AQvKALW5oazF9q6PyC6Lo4kQ0fFamTHeACo8s4hgbCuNNA9wH0V6m2yczEKIylMd1MtVglPyK6hZErrkPNRL4sSd35BSZ/7P6CEpp50VM0UiaEoZuVt883dES67SB6ssuQ2NAOcErHtf655oZrskf9FpBnc6K6P/8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 21 Mar
 2020 12:16:41 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2814.025; Sat, 21 Mar 2020
 12:16:40 +0000
Subject: Re: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
To:     Greg KH <greg@kroah.com>
Cc:     David Rientjes <rientjes@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
 <alpine.DEB.2.21.2003201333510.205664@chino.kir.corp.google.com>
 <7b8d0c8c-d685-627b-676c-01c3d194fc82@amd.com>
 <20200321090030.GA884290@kroah.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <fd8fccbb-2221-dcef-fd88-931a9c6b1b85@amd.com>
Date:   Sat, 21 Mar 2020 07:16:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200321090030.GA884290@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (165.204.84.11) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.21 via Frontend Transport; Sat, 21 Mar 2020 12:16:38 +0000
X-Originating-IP: [165.204.84.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c035d341-a271-414e-b0ef-08d7cd91b60c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4044:|DM6PR12MB4044:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4044E0CD6D042C4644E962E9ECF20@DM6PR12MB4044.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 034902F5BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(199004)(6506007)(6666004)(2906002)(186003)(16526019)(31696002)(6916009)(2616005)(7416002)(66476007)(81156014)(54906003)(66946007)(956004)(81166006)(66556008)(86362001)(52116002)(8936002)(8676002)(316002)(6512007)(478600001)(31686004)(45080400002)(53546011)(4326008)(6486002)(5660300002)(36756003)(26005)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4044;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4zJjXJRiBNTZUVA2ZBK15LdgYWbSSGMRDxOrMOUvRjNuuiVluLtdPA0tfLm8q3drgd+3EiSKgUcqMEseEiG8sWWXqs7AR0hwEx8b0vK/waLgeDmFRoEpo90sd81vO/939lK232asSuBokXHwU5hggae9XxAReHP0WPZc7sw61uWTEi3tmK2VTWSvTEyKQbqtz7w0SQOUFC6Agcs8rJPGDphiueaOalBoRuj78hNboC9i+5lF4iDvTSvd4bxSkudThP2aGO87xfcwRcKFkF1kFQGk8N6ywC8dwZLowHDd2dpT8CiADxCUZeLuGZ8Nf3vvRzRsXF7hpKAAAp/cpFkrZ/FGicDcXn1wQv8n9jbQEtRlubJHZNoD4WPNJs5wPhZilmO/hGsx0OCsM57Kr1XblxJvkuq+h05rk4TDIshvmBggDhjYJXbmLJz1Xmkyy52d8zo/T2Arb4X0B97NEXKYAle860dX53kb4Mn/lRO8fZjkhPnXq2fIslzLWwe97mLH1669ZdhHfnu0UXd4cLVi/Q==
X-MS-Exchange-AntiSpam-MessageData: yC1FBXueg8UwKOkBRX9GzIjhiNGHtxflqWsbFtQ2bQ4aMX2+04+Z7XGJ+zp4Q4hQh0+SB2rYLLx9dgvHEV6GEb5aBA3Wz928PFbsn0mKoZh0ydoZQUKNnEqj+Jf4Puk9Aaobz1N/um+ycZQhB+E8jQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c035d341-a271-414e-b0ef-08d7cd91b60c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2020 12:16:40.6740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+XUoiAsf8KLafCGElMbxAAxPpZp/2GrRe6QfT2JPos/jez7eKSbYvwq5Sn/FMRzU7dBzjxQMyItXFwVXImKLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/20 4:00 AM, Greg KH wrote:
> On Fri, Mar 20, 2020 at 03:37:23PM -0500, Tom Lendacky wrote:
>> On 3/20/20 3:34 PM, David Rientjes wrote:
>>> On Fri, 20 Mar 2020, Tom Lendacky wrote:
>>>
>>>> Currently, CLFLUSH is used to flush SEV guest memory before the guest is
>>>> terminated (or a memory hotplug region is removed). However, CLFLUSH is
>>>> not enough to ensure that SEV guest tagged data is flushed from the cache.
>>>>
>>>> With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
>>>> original WBINVD was removed. This then exposed crashes at random times
>>>> because of a cache flush race with a page that had both a hypervisor and
>>>> a guest tag in the cache.
>>>>
>>>> Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
>>>> svm_unregister_enc_region() function to ensure hotplug memory is flushed
>>>> when removed. The DF_FLUSH can still be avoided at this point.
>>>>
>>>> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> Acked-by: David Rientjes <rientjes@google.com>
>>>
>>> Should this be marked for stable?
>>
>> The Fixes tag should take care of that.
> 
> No it does not.
> Please read:
>      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.kernel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fstable-kernel-rules.html&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C197f666080144732040108d7cd765107%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637203780365719535&amp;sdata=NKgNt6Hd7y6BGBdpI52ckCxZvIsCRuEf9FJ7GW2PqPw%3D&amp;reserved=0
> for how to do this properly.
> 
> Yes, I have had to go around and clean up after maintainers who don't
> seem to realize this, but for KVM patches I have been explicitly told to
> NOT take any patch unless it has a cc: stable on it, due to issues that
> have happened in the past.
> 
> So for this subsystem, what you suggested guaranteed it would NOT get
> picked up, please do not do that.

Thanks for clarifying that, Greg.

Then, yes, it should have the Cc: to stable that David mentioned. If it
gets applied without that, I'll follow the process to send an email to
stable to get it included in 5.5-stable.

Thanks,
Tom

> 
> greg k-h
> 
