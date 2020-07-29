Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7672326C5
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgG2Vbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 17:31:34 -0400
Received: from mail-eopbgr770050.outbound.protection.outlook.com ([40.107.77.50]:38726
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgG2Vbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 17:31:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEE6MCgNatdk7baZnlvCx/8lZL6Nw/0dnWImsFmmhRciYfAHhmg5Jkuw0+82sKi/EhIluasJhAwls50N4YGQcpINVA5vS1ib+SSVCaMrnV4qJCr5HPlaS6csBNJzZ/TDz3tUdc+w2cAvFlu6RrtFfMb3z6EkZbC4Wc9cTTn+ob3T17trPFLoC6yrNU7Po/0yYNHBKkNMx0ELY03stuFTA7oETouU62pGmMELWWbAQl9uPqTu/mSo02M3xo7H8hIn8y0Ba9jF5HlM+qYA7P7yAJD3qm+BlOcvAK4VRfGx5+Lz1ex0T+tQe2hXEh/e+a8MZ2dRH+A0exeiPki/qOpdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JylNYsEy0+76bXeB9tohxrQodealJBhLizIK9MARats=;
 b=KzQHqYCfNMasKAqfC9/Dma6j32sgib4ZdSJ2vfZAs0c/K9v2SQCG5LIJikaeKlcUpaDmhPXcVtySxgydne+8JOvKDt+mLI4JbiQvWOmuukoUJREWnEnAhNfzMVJmD2J1Hl54SQ9xx4pKao6ANeQZ3jlTtZqf8+wdZ4Dcs/xeJRGai5s2v913+BMxwPlOEfbp8LBjpps03iEQdjJJfuEKZiuy4R/RB523OFr6tv7gLb0z53uzpT40KUITlNegh86/z1KRgfIUDcKocxe4NdhzDXk5ZiurFZuYW+9pHpfBlQqMyPFHrnAgclJ3FvOfjvEFXuFxpn+NSoHgkR64TahmTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JylNYsEy0+76bXeB9tohxrQodealJBhLizIK9MARats=;
 b=G3pcezfiVkM+PEPq+0W+HKSdY7cFTc9v3WA4pogqEmHktIEVTfT6ISu07rWLFHUtJb4vwR55i4MJcC+3paRi+tRkEuWnfC/+l6BwouNtl6AbCFotavaOybQsPVqK1P3mzmIZmPBNKthSUdiyOORtnvKWipyEpdn8t4AT6scbB5Q=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 21:31:29 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 21:31:29 +0000
Subject: RE: [PATCH v3 04/11] KVM: SVM: Modify intercept_exceptions to generic
 intercepts
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
 <159597949343.12744.9555364824745485311.stgit@bmoger-ubuntu>
 <CALMp9eTO-Det6u3Fa2Lrzkgw7SRj=Jbf2kJ1YuokZRmCEpj=EA@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <e23cfddd-e910-09a5-bdb0-6fcc14f59209@amd.com>
Date:   Wed, 29 Jul 2020 16:31:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eTO-Det6u3Fa2Lrzkgw7SRj=Jbf2kJ1YuokZRmCEpj=EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0029.prod.exchangelabs.com (2603:10b6:805:b6::42)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN6PR01CA0029.prod.exchangelabs.com (2603:10b6:805:b6::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 21:31:28 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59cf47a9-d706-4633-ac26-08d83406c162
X-MS-TrafficTypeDiagnostic: SA0PR12MB4352:
X-Microsoft-Antispam-PRVS: <SA0PR12MB43523C6461E7D9F73858A9B095700@SA0PR12MB4352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9kWI9KdCl53nkxkFMDWWX/GNQq9fU9K/+KDSagsj2zXr5ssh1yz+xjelz8WiVlAyGd3yZlCh1lhZvpnN2EBhMY3iTRXyplfg8h1LM6pMVMECBvm4U5+wuHtN7VkWokqTE0xIW9NBSZK/2bJg3abx5JgeL1WGshB2mEnliYW8lqkvYH3J6crgK6MeDFQXSIbDftsYIRzxEjfS+682xOTIe/a+Sc6dwHhNrqihvyaRK6+4mzLm1N2zQ7C1f0LyELuePSATuAtwuEHvdCb/6+GMd5a9bqLgJS31CWzbvmKCMN/uWfjIPOc3xNp2A5BmSd80tXTLCkcN3d2eVPQdJ/4BQUEyIK9VANd2n/s2b/htd3HfoOttKE/MsmMNeXsMQezbKAIdbAbKVZhrhMSF3gk9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(6916009)(26005)(52116002)(66946007)(83380400001)(8676002)(2906002)(186003)(16526019)(54906003)(6486002)(31686004)(31696002)(956004)(478600001)(4326008)(5660300002)(86362001)(2616005)(8936002)(44832011)(66476007)(66556008)(7416002)(36756003)(53546011)(16576012)(316002)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1VdxXxcRXDPM07wKstZeE0cjQoKhHTn3F/1woYFKPwRSaKX3tHIdwlSZCxq54VmmKuo9/LCQnbqdyaEnliW6PqfRYr6HcGrPLW048n2LmrXTG/QrtbOHUVVzHpvIavOYmoYYQTrLDhd3b+9mKzjp9RvVPl7jHmG1XPhPxLw8dcDJspETR5nxBba9VnDnO0RhxmqCTYfF8gPmnLE+JwN4xXiau62TrcJouhZOzOSZ75dLzhpU6p6kqM27Ff9xyl8YSgC0ZLhadr+RM7wHJhsbk0wLqVUeCayi9EQaxbp+iAHJYkNWCD75v+jJ2aeOlYmv7lejVMZBLyk1PHgrhGYOwI4dhvcsDe/WHXggD24U/YDNlTmDv0jOU21lH5bONf2nO4Cvv3hDSlDsc3haDSfAcGJc8BH9xSGRL+e19HAislcL8b2igvBYiutf1vSiTzTeVSbBXbz5YWFI0FTx6ob8qZfZWUlV8BPpiZMs4RVaBhOS+iFj/xuz2UJaIfDR5bJ1XAD71pT2HZ8rmGkOepLdJKZcpoWx5YuNfbrlc0WwRho9cK8ww+sygybCshgnO6o4YiX4cXE+1YOII51v3Cd4vqaY7hTyGjcmL40jZMtLg2QnnQdesKnmnq/kxWTq2jXWf++6epxj38P+7u7vn6VYJA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cf47a9-d706-4633-ac26-08d83406c162
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 21:31:29.3161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcUYSxLGXmXAUv66DSWOSKGiFnDp9K9O4WVXHLhNS1ux/rY5gNsCFXciKaQDP+gP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Wednesday, July 29, 2020 3:48 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; Sean
> Christopherson <sean.j.christopherson@intel.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [PATCH v3 04/11] KVM: SVM: Modify intercept_exceptions to
> generic intercepts
> 
> On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> > Modify intercept_exceptions to generic intercepts in vmcb_control_area.
> > Use the generic __set_intercept, __clr_intercept and __is_intercept to
> > set the intercept_exceptions bits.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> 
> > @@ -52,6 +54,25 @@ enum {
> >         INTERCEPT_DR5_WRITE,
> >         INTERCEPT_DR6_WRITE,
> >         INTERCEPT_DR7_WRITE,
> > +       /* Byte offset 008h (Vector 2) */
> > +       INTERCEPT_DE_VECTOR = 64 + DE_VECTOR,
> > +       INTERCEPT_DB_VECTOR,
> > +       INTERCEPT_BP_VECTOR = 64 + BP_VECTOR,
> > +       INTERCEPT_OF_VECTOR,
> > +       INTERCEPT_BR_VECTOR,
> > +       INTERCEPT_UD_VECTOR,
> > +       INTERCEPT_NM_VECTOR,
> > +       INTERCEPT_DF_VECTOR,
> > +       INTERCEPT_TS_VECTOR = 64 + TS_VECTOR,
> > +       INTERCEPT_NP_VECTOR,
> > +       INTERCEPT_SS_VECTOR,
> > +       INTERCEPT_GP_VECTOR,
> > +       INTERCEPT_PF_VECTOR,
> > +       INTERCEPT_MF_VECTOR = 64 + MF_VECTOR,
> > +       INTERCEPT_AC_VECTOR,
> > +       INTERCEPT_MC_VECTOR,
> > +       INTERCEPT_XM_VECTOR,
> > +       INTERCEPT_VE_VECTOR,
> >  };
> 
> I think it's demanding a lot of the reader to know where there are and are not
> gaps in the allocated hardware exception vectors. Perhaps all of the above
> enumeration definitions could have initializers? Either way...

Sure. Will add all the initializers here. Thanks

> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
