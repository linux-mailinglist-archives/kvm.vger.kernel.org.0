Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1569D2336E8
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgG3Qeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 12:34:46 -0400
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:65408
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727072AbgG3Qeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 12:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xgf6D4ex/KrpmOuWBaQM5v80ukTsn0ss5nhuSAsHonQ6CVZcM4N0wBlRAPFB+KF/ofD8Xu8cBZ9NV7NJGKWxfNroca3sDSMVr87vHgDY8zE3LBLbiKmRbRbHNEGMhjjj7yIcLLzoI7DJPDP/50uGxWT57ydFL07eNUKvWpwFhzcVQijlWDlnt34qodRJQ16uSXloWArNyR4UZD0541feI96TXP76qXkzT3JvApzbW+V66SO/dsraSOQlPHEVwpGvGyIGoAo22hOW6v5MmylauG49c8dbWAbiep2bdYEMZHzQM3OusFz3wQnRerlAD4w0xAbplWV+TPAWCfBG0l4coA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeWYqdp+3olr21tIq8tKQNYR/Q0Dh6Wx61fjK8jIYxY=;
 b=Lr0DwMvv9w+RRgZtHWRmp6jZfG1/5px0lRdxOWspSWeX/G1GNu5jQRVL8Xou5WNNy6QdmkcVD5nO6tUoX1iu0spG/oO7Tf32MPttXl8Xl8loSf43819WDU53+zHD4h9McrOPR6qibFEVEvYMynUi6sGXKVrE34wdzZv2zjrg5F7et2rIfwmYUiR0vBr3jt7DB19+ml9djP86YJTi7XMU4C9Cj633QHdp0EvFZUSTUDXxAgwYgJPEdJSneMoUDRfUY1UYOHEuOiYFHhNwPChN69n1tXNLS7SDMLXkkoFBQOCDgndBCyEoANFgyKtEun0G95K31DTYR3PxoojpSBNZXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeWYqdp+3olr21tIq8tKQNYR/Q0Dh6Wx61fjK8jIYxY=;
 b=memBXMild/rGohNWziwK2EeF3buE8dWwEvAl9u0UU6LcjDzbtu1L4MSu451JuNWtkPPoiASh98DpY1Kt0wOqzcwVH4DMsitr88SmzqojhH+XT9hMJlkigW179cdAyp90uVnwtRYGyglYY7zwnEohr6aMaK8B6v6I8P9HKf21+L8=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2735.namprd12.prod.outlook.com (2603:10b6:805:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.19; Thu, 30 Jul
 2020 16:34:42 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::691c:c75:7cc2:7f2c%6]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 16:34:42 +0000
Subject: RE: [PATCH v3 01/11] KVM: SVM: Introduce __set_intercept,
 __clr_intercept and __is_intercept
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "jmattson@google.com" <jmattson@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu>
 <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
 <7c6c66d0-85cd-e558-f43e-a2d5d57e8913@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <28a9c51f-4d72-9e33-d184-6c7c830260fc@amd.com>
Date:   Thu, 30 Jul 2020 11:34:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7c6c66d0-85cd-e558-f43e-a2d5d57e8913@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:805:66::42) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN6PR08CA0029.namprd08.prod.outlook.com (2603:10b6:805:66::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Thu, 30 Jul 2020 16:34:41 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9308b89e-fe55-4638-3f57-08d834a67622
X-MS-TrafficTypeDiagnostic: SN6PR12MB2735:
X-Microsoft-Antispam-PRVS: <SN6PR12MB27358DE1EC812F3BE3E4594F95710@SN6PR12MB2735.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0F4o2SGfexBFaDCMkqqt28x44vcPn6t5+47oneoz2CMQWUTIahG5ikHiV71rOjrX5dkmy2as956XQjQXRif8Y4JCMJyHfqjyge7moETYNK6rijaadYkeBwKiHTFQ1VFAMOS0epEBd0Uvv9oGDwPeNkhYT9kCw0s6X8vBBrqnPCKHuR5uVlTKtHQ0lbbstMbpgmsU7QI1LtNvFXbpJaOwsFTpa6+r1CKGTqjGQQBEKe7n8WhTbSRfiroPzXWIGDpabTkVYB2pw7s4qzBVD7uPih3JYFSiWqsr/6UYnXYr8f2jwrn0Zn/cUUgFJXpC0GCy6lZ6JGAzEZxkYC3dUaHGx/RLdU7y/8DQK2/YaDSeDPdc4aC+M49zL8uBDWX105DJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(54906003)(110136005)(478600001)(316002)(36756003)(16576012)(5660300002)(7416002)(31686004)(956004)(2616005)(44832011)(52116002)(6486002)(53546011)(86362001)(2906002)(31696002)(83380400001)(8676002)(4326008)(66946007)(186003)(66556008)(26005)(8936002)(16526019)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WiuA0mZQz5IH5P++Q7ODYgeMKAhiTtQ03nuupRroyzl6N9Wb60a2mC9tgDysm1zG/ZEQPal2IDYcC0w5wGXvnMnmnainpcK+zz8vHFr7F3PKNmemn8wx2ij2HiH8j0DhdZsH+idyDfSDjEDZfnCVskZ04cVZTqd6HzdOryqr3xDHWiXXYsQzmp1FDJ4ECE1OCXU779Jiap/HUFOEH9YSJ6OP11CdoSK2SV3g5MTfG/ryRADyM6K6gLEpCbSge/67I3ZFyDLAgXvMO8YrcwSg13bXFQEX8/9JAj+4uXAk8PQm36O1+rQfr9ITILENdd9ybGslaZP6HLQE6c5TdYg+5tccDLBRNuo1ziQQFsi/S/hkv7UeozerMzrWnYzdAJzmpZ1UgOhQfzfJuQyjDZnMpAJrO49gIm6ZZ1LrqoqvRMDtO1bgkCtvBn4mszZynlX51fvHpk0eFu38CHoMeAn22Z2nXT8eIM3WnNcVSnn1WvcD21vR05bLlN35WnloAOOeuoj5K6ZmPaAfNTcNgay3cgd80hLjlw+3d+xLv4lK4GWXEdlzgmLtZRfDjaR8vzUhZMaAloYANgVTPyncCrsVEIp6Agdd2m19AYfhx9eeuFKsi9bxWx7GwA1lgyNYPjsycmz8L0i4vDlBHxk5yF4XLA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9308b89e-fe55-4638-3f57-08d834a67622
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 16:34:42.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moMmZwN6oYClJspHQ1rkV9xv5XteWuV7gWTYBEfDR5/9g/eUtm3Gw9y5lr6gfpkN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2735
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> Of Paolo Bonzini
> Sent: Wednesday, July 29, 2020 6:09 PM
> To: Moger, Babu <Babu.Moger@amd.com>; vkuznets@redhat.com;
> wanpengli@tencent.com; sean.j.christopherson@intel.com;
> jmattson@google.com
> Cc: kvm@vger.kernel.org; joro@8bytes.org; x86@kernel.org; linux-
> kernel@vger.kernel.org; mingo@redhat.com; bp@alien8.de; hpa@zytor.com;
> tglx@linutronix.de
> Subject: Re: [PATCH v3 01/11] KVM: SVM: Introduce __set_intercept,
> __clr_intercept and __is_intercept
> 
> On 29/07/20 01:37, Babu Moger wrote:
> > This is in preparation for the future intercept vector additions.
> >
> > Add new functions __set_intercept, __clr_intercept and __is_intercept
> > using kernel APIs __set_bit, __clear_bit and test_bit espectively.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > ---
> >  arch/x86/kvm/svm/svm.h |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h index
> > 6ac4c00a5d82..3b669718190a 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -217,6 +217,21 @@ static inline struct vmcb *get_host_vmcb(struct
> vcpu_svm *svm)
> >  		return svm->vmcb;
> >  }
> >
> > +static inline void __set_intercept(void *addr, int bit) {
> > +	__set_bit(bit, (unsigned long *)addr); }
> > +
> > +static inline void __clr_intercept(void *addr, int bit) {
> > +	__clear_bit(bit, (unsigned long *)addr); }
> > +
> > +static inline bool __is_intercept(void *addr, int bit) {
> > +	return test_bit(bit, (unsigned long *)addr); }
> > +
> 
> Probably worth adding a range check?

Paolo,
Not sure. It is only called with intercept bits like __set_intercept(addr,
INTERCEPT_ xx). All these intercept bits are already accounted for.
Thanks


> 
> >  static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)  {
> >  	struct vmcb *vmcb = get_host_vmcb(svm);
> >

