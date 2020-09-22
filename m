Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213C72748DE
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 21:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgIVTLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 15:11:42 -0400
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:30497
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726686AbgIVTLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 15:11:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fvv5pD5nnnpW05xHbQ6ktouPfPDBmjtTXftKb0LZuJXAdziyftc4grty8fLG+HCQqxfry+QRAN7nnkewE469s2hVdVKh11cmTqMfQsA7ghSQqn2YUPyouYzzQz4JkYls/EYngOiNASnvI8utqjqd5f7Q7+a6Qg3CVketYugQtbBce/xoIkPB7m7/4R4fFcTDRW7ugYwV7sop9knsq1+H2iboNxqKND75wox1Klgm3/B/KEU1i8hQp41H2tUmZwz6uRCnSGZrR3y2mn9QsT9lERDWBgyDzhJPUC5zFPZerGCLEYeOLtS4duAVECs/s7nL2wx2gbFyld6IoOq7ELsNrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f44pyRG8L/bJgLT3leUrhaOaXV7kwQkNGW+U3jpesOE=;
 b=J6lXr4eIp0FqYiyniW1wwIYwfvq6dW4RCzbYfzc0a5fUQjuXeJDetGSrje5VNKViHKBAknKJHWUK0DadiupKi5RZp/zVPSxHtJxESeuo926SoluYyuJfuuu37arFT2ss1be1rTXeSvSKOGY6Fwu5QwOL27KhbB7v58gv12Djy+y5+/RK90OhreEo8aaV0T4gNF5KYPuoDgxED09CUFQvXWw7bSrswNEjC+Jrza86fCqwjsYsrl/EVxCpEx2CagY2YxacUOFS1y3o4Y31gmOdwEAtwTspcw0a53BDqaj6uiZHP8toNyX5I9XiXdA+QlWdDvKpl6kBnrzj9cZV4wXmFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f44pyRG8L/bJgLT3leUrhaOaXV7kwQkNGW+U3jpesOE=;
 b=KUZYBlVe+QM8nyQF9De4j/fnZRF7mny6WDFwAHUmvCwWP/Q6+4l3txyvxv4zqQIiQ+v8Rzpbss4H1L6gO3JJspGm/lT4B6RUkptkNm2NWNoQW1pf5P96M5zxgXCGTCtFVWLtWszzSG/RNEhFBrxaIBCYxb9QW7OGEo/3hhS7j8U=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2606.namprd12.prod.outlook.com (2603:10b6:805:6e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Tue, 22 Sep
 2020 19:11:39 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::ccd9:728:9577:200d%4]) with mapi id 15.20.3391.026; Tue, 22 Sep 2020
 19:11:39 +0000
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
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <408c7b65-11a5-29af-9b9f-ca8ccfcc0126@amd.com>
Date:   Tue, 22 Sep 2020 14:11:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e74fd79c-c3d0-5f9d-c01d-5d6f2c660927@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR18CA0087.namprd18.prod.outlook.com (2603:10b6:3:3::25)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by DM5PR18CA0087.namprd18.prod.outlook.com (2603:10b6:3:3::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Tue, 22 Sep 2020 19:11:37 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd4668d5-291e-4d35-77ea-08d85f2b5514
X-MS-TrafficTypeDiagnostic: SN6PR12MB2606:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26061CAFCC89F29A64765FC0953B0@SN6PR12MB2606.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qF7D7flmhkczvYzL9ED0iijVip8Jwwb2BTLpLxxbcSdDBTMXWFHb0bbCy16drze+6RXR0ZmHZ8qtL+kuDA63IyRn44xo/YGsrjXYilLMMP1Zk+AeOzZKdthlmyir7/lDCpyUrRZ8r4Qg0SD4rBOL56UvS5GpTg6s8wm6umcjbNS2242j3FkTxs7G2Txgnq6TiJjSbNnr2EazogMIKuXvCUb2Up8oXUJxdOq4Et9iq/kpW+aNlScvbOhM4AbJ81xNS4tgepEwSA+GEW+R5ojNY7RHHHpKhCgWGahrTSw7+rivpsog2qbfQTDXa8fcgg2TZvMchenz6NIhJ4JxTDS5tcW7nhXs/mJJlXwUOQZfrQzAgZnjqymbaYvzqwSg/wFMCWdT2gLdNBG4i9LF46wvgc4ej/LNikHLTVEu87ZV/LxEffFJoKPwiHCOHIlABBTriSfDikg0PpzbgTMA3fEFHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(66556008)(316002)(66946007)(7416002)(110136005)(8936002)(16576012)(8676002)(478600001)(4326008)(956004)(186003)(6486002)(16526019)(83380400001)(31696002)(86362001)(36756003)(54906003)(2906002)(26005)(66476007)(52116002)(2616005)(44832011)(31686004)(53546011)(5660300002)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z0ff0G+6FeOMeC0vzfVRs5WvTvlUKimUlY/QWkhzLXeJgcDUW5wND0aWAfrjmpC6M8vu10L7V/ysLhRoQLaR5OdVtBjPHxitaUdqoDl1+YT0dZLto+Rqp6l6ay/SE5lLA5COTU0Y5ITLu7cyBBjtS29PVDKPwAOX5sMi5+ObtfLlAf9Z9qqNYh9IE14e2qlRYbkUtP5tciw32w0F+dPUYi67673HqYMeLAHivTZTu0GLiensXY8ZQk612obWGE80Wi/YyiFfKM3wXPby9UNYrLK/3qeJ/78mukzcoyfrXAK/Y47J+HZwXiet5vLafa+oEbCnlCvwEHdN+eztsMrPefg04vgVP8PkpgwNNjKu0itTSMFPKVE7dqp6hORIvXAwzgZuYD5Ga+Jd7Niu+gb1ddc6iy5igIlTr69GsTLw6qOKiNh1v7BO9VmPI2cp9A9M0YtgMI4egEsKSH04oB0qsUhs5z1LeK/z5lJr2Le3MznJyivWdmBjrgGvmSC6g/c4j8ronzevqRsg3xgiWTz+gS+3ptOiVeta7GwbCCmvNShgdRO3iyS2Q99E6wc8jOH4pYNkp0bsFEWaWjqojmur5PWwMJQpJAD6W5KueOh22Vq3Nr9rVw80nFI35/aRwoGWh1Pm9m5++my21DOZmLPm0w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4668d5-291e-4d35-77ea-08d85f2b5514
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 19:11:39.2879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GuAAId4coCazDi2RIeHf4bt/fzM1rXl06kJmC1nWkgL67wr+p8lILutVTP1W/KIJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2606
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Tuesday, September 22, 2020 8:39 AM
> To: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Moger, Babu <Babu.Moger@amd.com>; vkuznets@redhat.com;
> jmattson@google.com; wanpengli@tencent.com; kvm@vger.kernel.org;
> joro@8bytes.org; x86@kernel.org; linux-kernel@vger.kernel.org;
> mingo@redhat.com; bp@alien8.de; hpa@zytor.com; tglx@linutronix.de
> Subject: Re: [PATCH v6 04/12] KVM: SVM: Modify intercept_exceptions to
> generic intercepts
> 
> On 14/09/20 17:06, Sean Christopherson wrote:
> >> I think these should take a vector instead, and add 64 in the functions.
> >
> > And "s/int bit/u32 vector" + BUILD_BUG_ON(vector > 32)?
> 
> Not sure if we can assume it to be constant, but WARN_ON_ONCE is good
> enough as far as performance is concerned.  The same int->u32 +
> WARN_ON_ONCE should be done in patch 1.

Paolo, Ok sure. Will change "int bit" to "u32 vector". I will send a new
patch to address this. This needs to be addressed in all these functions,
vmcb_set_intercept, vmcb_clr_intercept, vmcb_is_intercept,
set_exception_intercept, clr_exception_intercept, svm_set_intercept,
svm_clr_intercept, svm_is_intercept.

Also will add WARN_ON_ONCE(vector > 32); on set_exception_intercept,
clr_exception_intercept.  Does that sound good?

> 
> Thanks for the review!
> 
> Paolo

