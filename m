Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404BD2758D1
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgIWNfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:35:46 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:33377
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIWNfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 09:35:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wsinrl1mW4HBys1pL3R3UXBfiN6+Ut4qc/h1wV/lRDWtRbDzvCEXUCmLFWHTRDJcv92VTf5DstbEQn+7wPIcx1G+RgPBXWWTjQpw+GTR8+3pmBFzFxMWbzSp3Fnq398r6PVpmou5Asn+I0EDxUsqB4MXo/+XCfWNzOAeKYCDjFam6XTO6zeOA9Xp/6sWRiqhtKAhYwMcVJndErPxMtrAEAbWrziFjGEkyiBEIJQJeaWHjroxlu/MDYW1tMDnepCB2aMq5ENypbPJDSzQGqzEucr+0PKyknQ2tqub78CZhi9F89Dh07hC8fdI4BLnEb7XiUd8UbAaIt73OndZU2QB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQyQYyn3GWKUaaOvopUzhfH/3fxoT8su7vnP+fyMt4s=;
 b=UBkDfV6+OyUYZhygepE9llgZ0sBuFHqnre2qCgOCVBu/n1hTed2c/AUaFYpH9J584W/L8THa5LhG1UJ3qcGqQoneq7HUcnlpj9vqnVqSFyYXmXvjM4RlvmcCdCrmVQTkguWhN6v8D2KjkkvX3SOkjwKWM0eV7FKd6UACyu/CBSyk9Mf6s6mVs4+1c23KmmswFhv2QIvU3nFZPQhp8tL4/T3P015+rWHyp5DUq4LlQNb32P+Z+rKYC4u0N83dMbLrg1VieRTJkpy0ydV6L8+lJPtEvS/lHRLEHSbxQ4rrGvF9oorU3jtpG6payvzjSv6NbwJa73FqvRxE4nC7uutb7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQyQYyn3GWKUaaOvopUzhfH/3fxoT8su7vnP+fyMt4s=;
 b=o2vd4cf+EAQQfXgS1Q1sVDMXqcxyvn0MZVH5qFsXG/kC9hd2a5hErEf8EOiuRlcbapZMeoII8RbKUF8AGdFHnZajd9+OfyjT+O9Zd1wFagb/KYrNAKnyCUOpeJDcX+oHpPdRggbsLOOzsUPx1JL95KiGFM55Dx6aCbi78tKMEFA=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4560.namprd12.prod.outlook.com (2603:10b6:806:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.23; Wed, 23 Sep
 2020 13:35:43 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 13:35:42 +0000
Subject: RE: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <159985250037.11252.1361972528657052410.stgit@bmoger-ubuntu>
 <1654dd89-2f15-62b6-d3a7-53f3ec422dd0@redhat.com>
 <20200914150627.GB6855@sjchrist-ice>
 <e74fd79c-c3d0-5f9d-c01d-5d6f2c660927@redhat.com>
 <408c7b65-11a5-29af-9b9f-ca8ccfcc0126@amd.com>
 <4fea8c91-8991-2449-b8b7-180cdc8786ca@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <ac52cf99-b49f-e1a9-634a-adaefeadb5e0@amd.com>
Date:   Wed, 23 Sep 2020 08:35:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <4fea8c91-8991-2449-b8b7-180cdc8786ca@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0092.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::33) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM6PR02CA0092.namprd02.prod.outlook.com (2603:10b6:5:1f4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 23 Sep 2020 13:35:40 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: decbf1f4-acf7-4191-7db3-08d85fc59111
X-MS-TrafficTypeDiagnostic: SA0PR12MB4560:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4560BE6509BEB4FE40B61E1A95380@SA0PR12MB4560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zYklUXHExaNfeQcrKWlG0FbknyhM2PporDMSS37fgjmhZa6B7j9ZDKchFVrEjDcdlt5+TsosDbQQ2CLChI571nFgWRkzbMXmvcax6XHd0xqLc93ubOcpDZPeJ5/Fzjc/HUwkSC69/AFRJ7PQrVm+tEGsKt+CZjCbT4UsJJmFDW7AxiOOatdjIYhKHEVw6FFRKOvvggSTtKIf84P07z7z2SlQ0/HlnLztoZ3XUwKqPFSxc5mXYuNP3lE1VwY62moVBb0MnjGUQOgXZZkPOXfE4FJEn/X6DmNMv4gASGoDeyiK8pdAKyapEzhDdzXp++q962ripSZZJAXSVAlAv9qlQWaT2kXDyMo5KfJE2NNV47aPIq4s2iDm/noxeMH3sdAG5Zqd9yHDEcoGO9EghQ1emw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(5660300002)(4326008)(6486002)(7416002)(956004)(66946007)(66476007)(44832011)(66556008)(83380400001)(86362001)(31696002)(36756003)(2616005)(2906002)(110136005)(53546011)(54906003)(8936002)(316002)(16526019)(26005)(16576012)(8676002)(52116002)(31686004)(186003)(478600001)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ItUSMwfOEvxClaEg45OqjLA4ngXccV9u598GXngkaiBANjghcl8ZEkkW/WOp9Fwc3x0TJo8c8V5yVL5vveRCzcdKowwpuaNPLra9jwvjILogLtfGlp8XlTtxFaNrbquiPcWSiWvMHp3raF3KMWvSeGjsMxBdnnoGSTLsPhv9HXTMB2opLhg+txSE44+x2eklKRudz9J3RDB2qXh1pTjVr9M+4s+kNTFFEdp5VWDxZ311ONkGQNAoucUVHPy7Rox92f8mBaHmxu/8ruoLwb0pA4+m7EQvB22/mzNnMT7Rw/l8m4RK7RZHRp67gFhzBXw0YXzIMRTOnx6WnnnXspfbH3K4dcM7AHFVwHz2rXwPVNLSxUy1ncw6IEtPdrSBSv3yG1FIJGjDmhkaqKP7sbl20VYSYFpk0uw3vqiU+6PTzK1cYa83MKgZhg7e1M7uSmMX/QReEb+pXWr+/+tLmfZYvl1J1aXMkC3pVFh3Mk30dlgVW+kqtBG+LShJ/aKidu87F4pW/WhlRE9ZIw1qQ0akTk5UwJN82wOhJMDlHWOntYUdvpT+QrLXBExkOKeCUzh+TyfSUgegNXDPdq921DBdwmjtbq6ma79gr8sUW1qk0Fu5WHBFP3VA5yHsOU9q/2C9Jwayk9BDLWrwg7HmtjPmGw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: decbf1f4-acf7-4191-7db3-08d85fc59111
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 13:35:42.6290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F52A7NEBTKQN3U3uJj9F0KIrQmIwUm4EfAVZYXCciEwp7l6s58DWl82cZ3AYstjD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Tuesday, September 22, 2020 9:44 PM
> To: Moger, Babu <Babu.Moger@amd.com>; Sean Christopherson
> <sean.j.christopherson@intel.com>
> Cc: vkuznets@redhat.com; jmattson@google.com; wanpengli@tencent.com;
> kvm@vger.kernel.org; joro@8bytes.org; x86@kernel.org; linux-
> kernel@vger.kernel.org; mingo@redhat.com; bp@alien8.de; hpa@zytor.com;
> tglx@linutronix.de
> Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to
> generic intercepts
> 
> On 22/09/20 21:11, Babu Moger wrote:
> >
> >
> >> -----Original Message-----
> >> From: Paolo Bonzini <pbonzini@redhat.com>
> >> Sent: Tuesday, September 22, 2020 8:39 AM
> >> To: Sean Christopherson <sean.j.christopherson@intel.com>
> >> Cc: Moger, Babu <Babu.Moger@amd.com>; vkuznets@redhat.com;
> >> jmattson@google.com; wanpengli@tencent.com; kvm@vger.kernel.org;
> >> joro@8bytes.org; x86@kernel.org; linux-kernel@vger.kernel.org;
> >> mingo@redhat.com; bp@alien8.de; hpa@zytor.com; tglx@linutronix.de
> >> Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions
> >> to generic intercepts
> >>
> >> On 14/09/20 17:06, Sean Christopherson wrote:
> >>>> I think these should take a vector instead, and add 64 in the functions.
> >>>
> >>> And "s/int bit/u32 vector" + BUILD_BUG_ON(vector > 32)?
> >>
> >> Not sure if we can assume it to be constant, but WARN_ON_ONCE is good
> >> enough as far as performance is concerned.  The same int->u32 +
> >> WARN_ON_ONCE should be done in patch 1.
> >
> > Paolo, Ok sure. Will change "int bit" to "u32 vector". I will send a
> > new patch to address this. This needs to be addressed in all these
> > functions, vmcb_set_intercept, vmcb_clr_intercept, vmcb_is_intercept,
> > set_exception_intercept, clr_exception_intercept, svm_set_intercept,
> > svm_clr_intercept, svm_is_intercept.
> >
> > Also will add WARN_ON_ONCE(vector > 32); on set_exception_intercept,
> > clr_exception_intercept.  Does that sound good?
> 
> I can do the fixes myself, no worries.  It should get to kvm/next this week.
Ok. Thanks
Babu
