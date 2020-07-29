Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F58232787
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 00:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgG2WTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 18:19:38 -0400
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:11909
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbgG2WTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 18:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHifw+mcAUODeZqVlOVbSoJV14z3y8Rk7yUbjVurHu4QtK49JFQcCFRyFAkm1BGjPACDlgEdjUERwQChgEvX4NINjayb1ETwlT8wNjh7TwyftrciMmF0b7ybK8VutZ6u+IOMAlAe9YlxnxO+J1NGw2STq3q0AAAWIXJojJttAtYtPZhkn94Gi8Asv2G6US4JVrfjXBPR0OmP9pAxLvNrbfxnVXP9DF8WCaDXscQd297yS/dWTcnLH53jtBKcZj6nAuiKo8aGo392YxdXbv8Ts/FYL2zLN/NbdPXG3UoZwwyUNmtvJRcoT0A21Mk0cx52H+3VlzOfpPhUc2T5y1ip2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBDauOyWJ9r2qe4WqgHTPQTk61ZVzyOrp3Usj40RPTI=;
 b=PDkanROfHNeaXwXF2513P+/pCDduHhV9UAjp7TbaMRHdNveHMNMUscDWGoqSfmq2MC/qVwSSz/kHupSwxY6vLK82ogFjQ9+hRWA3qQe9SIJFsE+gyd+A0p70LOyT2vSkzYCCokodnoFm3QjmWE/WmB+XnSIczdtANXkh6fnlIU5xIJ7RJwAIcMqoe5W3T75F2w4xu0HDQxG70Vidqw4uiFUHEdNspOGAppgJaMlP18djy25gCMnt98aoySMAHUqkAaYDrDQB42wUlapDGL1JUgo40cRQbbjEmUn+n986YLc49JzJM4JtJTOfkndK0uH2k1gt/2OoIl0lo0hYWNuEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBDauOyWJ9r2qe4WqgHTPQTk61ZVzyOrp3Usj40RPTI=;
 b=ROVm9Gq0ubTo9TfmQiHzo+e6Y6jb9+htuCGgvgQHeRANhYBR3UjovIzFdQOkX3/jXgpwhxXHHjjZC+LvuUcPcPuV2oURKjDTsjjrNXF5PC8JhFXvbLmua5yaGbKbZyIp9vvKu9l6PFEchy5v5DTl+ITzT0K/IZzRXNsN9I621UQ=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 29 Jul
 2020 22:19:34 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 22:19:34 +0000
Subject: RE: [PATCH v3 06/11] KVM: SVM: Add new intercept vector in
 vmcb_control_area
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597950612.12744.7213388116029286561.stgit@bmoger-ubuntu>
 <CALMp9eQUNLXgveya3TpyCH7L8EbEUEdPy+_ee_wSXwxqsKPDwQ@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <98faf088-757c-dff1-1bdb-755224ce7d37@amd.com>
Date:   Wed, 29 Jul 2020 17:19:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eQUNLXgveya3TpyCH7L8EbEUEdPy+_ee_wSXwxqsKPDwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:5:134::42) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by DM6PR13CA0065.namprd13.prod.outlook.com (2603:10b6:5:134::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Wed, 29 Jul 2020 22:19:33 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cb57f31-fb8e-473d-23fd-08d8340d7917
X-MS-TrafficTypeDiagnostic: SA0PR12MB4558:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4558DA99BC7D66B3EF8CEE2495700@SA0PR12MB4558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/JgIhugzMV/WyrDabZu5W942T2AZSHrJkIl3JO9iuvmK+xnFqnyza/NG7b1N/lf29E2rh3jNDsS85Y9YVMqZcaINS/Y2AXr4I9x461mdjxra7KQhjxNDPjcm6Ukqfr//DbKkYN2l4GEeR3Ff7PXVw8ByftcPKQuE+5kblM5G23W+MRJBXLhgskr1BBJcI32vb1wwftsK5t4bPJv0DCDF7ngAB7AhneDhb/Un6XCUumVqqOEhUfft9zYuBHprUCbyBBGoSo5UhjjWIL1j4WH1U8RseXK3Iv/sCpsnNxzWSfzhRxNhssvkVvqf1Q78AGywuo8eQAhMbI7fkuuE58MvDnsuUD+e98XOdykOxCaghfI/24o6XZJ2vtjx/PpzMpNNwmQrLkFWirlPCJs7eSQffo3h+EGD19ryklTMeTMYyk1YREVN/NgPXAIAXR5UGnROmSNtG/9SYNeIR9bLKV7fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(7416002)(36756003)(54906003)(6916009)(316002)(4326008)(31686004)(83380400001)(16576012)(31696002)(45080400002)(86362001)(83080400001)(52116002)(6486002)(2906002)(8676002)(966005)(66946007)(66556008)(66476007)(16526019)(186003)(478600001)(53546011)(44832011)(5660300002)(956004)(2616005)(8936002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zaWpcf+yHNWJls3AxnBA3HWSNQSu9YVToQ4PZqoq6Qv/JetHzpUzg4iA5a99u9Od4cElgSvf8WJEwjSlqNFZp9nlBomASEKoPegBund2PDwOKSxPUHTAk+5f28xH8ezOJ0IXJe/2M+01H7vMxQZt8/QzX5byiNLIrCR6P8dKMyp5w2W7C9WBlujjNEWEnyKpTIuN5AdadU13KZC7ojV2R/wHLGwJ+2nfekWeibSxM+NeGrUVvhK/GBtc2pWY+IgGpzTA4INH8TBvaEmrRmWq8QpFsd3LgK9AA/kVKnNgjqX+9eT5qIvmU5I2dM4sQbfbQZx2HhpKlq1b0ZwzrwS72SJc4LQk+WQc42elC0kHNigKxrvOirsLJQtlwuhcu80Iyo4rFjIAqnESEUfUsBpRlIPA287iNPRVdPEt1Dd5eiIGox3vn4VDjF81x9jhXweR2BLdLWqnInHNhlUt16z+o/AVJJqssPQCri0/z4D6VTr0wvGtdDnQh4AcDlD2K1ROFFQYF/ZYX3M/baRTLzD9JXy2KZOvDYE1J9UYqUd4/bo+NzMaavavyKzmxbDOCCTDeyGrJr1i01F5DVITQG2zg1KdzncsjrLUednS/dUGKZkmiv7Tl1egiPQRf97Pf5ElumUQXVnW2C5SHIujrlqnAg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb57f31-fb8e-473d-23fd-08d8340d7917
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 22:19:34.5662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpI0vbDtSRTMQBM2sV6t8X/yaLEDxJyiUqzZiseuPWPoDtRZ/XKc3xTP7lXMpzPL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Wednesday, July 29, 2020 4:24 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 06/11] KVM: SVM: Add new intercept vector in
> vmcb_control_area
> 
> On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > The new intercept bits have been added in vmcb control area to support
> > few more interceptions. Here are the some of them.
> >  - INTERCEPT_INVLPGB,
> >  - INTERCEPT_INVLPGB_ILLEGAL,
> >  - INTERCEPT_INVPCID,
> >  - INTERCEPT_MCOMMIT,
> >  - INTERCEPT_TLBSYNC,
> >
> > Add new intercept vector in vmcb_control_area to support these instructions.
> > Also update kvm_nested_vmrun trace function to support the new addition.
> >
> > AMD documentation for these instructions is available at "AMD64
> > Architecture Programmer’s Manual Volume 2: System Programming, Pub.
> > 24593 Rev. 3.34(or later)"
> >
> > The documentation can be obtained at the links below:
> > Link:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.
> >
> amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%
> 7Cbab
> >
> u.moger%40amd.com%7C04dafd87052d4ed59f9808d83405b0a4%7C3dd8961fe
> 4884e6
> >
> 08e11a82d994e183d%7C0%7C0%7C637316547054108593&amp;sdata=2ncYK2
> NY1J3xL
> > 9ZXSdb24zq0M0ZkF0iy%2FIW7SUDoFeg%3D&amp;reserved=0
> > Link:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugz
> >
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D206537&amp;data=02%7C01%7Cbab
> u.m
> >
> oger%40amd.com%7C04dafd87052d4ed59f9808d83405b0a4%7C3dd8961fe488
> 4e608e
> >
> 11a82d994e183d%7C0%7C0%7C637316547054108593&amp;sdata=Trw3tJE1Z6
> dOTXi0
> > DbPhOUAh4Ulr7HxxoJNpM2IjbvM%3D&amp;reserved=0
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> 
> > @@ -16,6 +16,7 @@ enum vector_offset {
> >         EXCEPTION_VECTOR,
> >         INTERCEPT_VECTOR_3,
> >         INTERCEPT_VECTOR_4,
> > +       INTERCEPT_VECTOR_5,
> >         MAX_VECTORS,
> >  };
> 
> Is this enumeration actually adding any value?

Yea. It is not much of a value add. It helps readability a little bit.
That’s why I kept that way. Thanks

> vmcb->control.intercepts[INTERCEPT_VECTOR_5] doesn't seem in any way
> "better" than just vmcb->control.intercepts[5].
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
