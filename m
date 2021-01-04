Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40A2E9D31
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 19:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbhADSiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 13:38:09 -0500
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:43265
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbhADSiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 13:38:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUN0cItygBikG8/sHQQaHBW8Pi407qlTDQhhDuP0byn8DtZ8b0hQbW7m9Xn+jPh15f7gV0Zd/2T7j9+2x68ChNUtpu9gWAFnyju84e0cUCKUDvAYsDSFb5XcUT9syHv8nsiqrfL1cnWOtZ2eUhV+4PNNvYtbKmtDDJHR0ohbcC/rIe9nhpkoTrxcbQEL0vcteb7psb3vXgBWuw4Vbx8ZC2vnlrD4HfygFTuDtPT/fOqVaesjyACV+szwHPbUgnA9voQuRqj9QUKVEEcLwknEGp6kvXdLuiooUKrGvyWpMkQDjLpt33fIL2SuMFVM8oAh4Oo3fZCVFFOt5JTBGeMmoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFPNBmh7H+GW99A/6FFYEUMexOY/4j3dkXMP1mhBuU8=;
 b=AMQ365RP+xVtFjJPbkqbwCHMbocGraGFu2Z8te9JtTaWMc+Zitu938n7V8doiMucSojIuBubblzsc5nUnKT3eLrgps27TI0JM8ILI/y1ML6j7cbm6yZ8V1lwpq5ZMDcf8oSool5ydeNuuZ1m9hD6VcX6sxs8qRMbYwNb1vJ8sgS6b1zttFws6dLhEmahPekTWJXY2KqUL/YSa+QvNACxrieCY5Q4on15JYBlW/QLa9TVUWcDFanPYWhjqo8xM3AWZskxlsuhJsljKwcXbAntal8U9DLXAMKrw9qfNTG+jQZqSAEb9kIC7TcNAf39e3NbsxyH0bwoqOsmCDVPqQt7eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFPNBmh7H+GW99A/6FFYEUMexOY/4j3dkXMP1mhBuU8=;
 b=JNVeaw9OqCSj3G/azsTZJKWNYb6AIQwajpYQBkxNtjfT/rBOliN8rVrc0eKNW+pXhJ15rjiKKyuVLzxI7uIQ5Pp7N8Gex49iuhgY9RcAeqkfbh4BKP0B4mjuw59GWraU1h9AYbkWXCCYMJO3ba2uR8lLN9AVC0cAUf7sgAa1CFw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2382.namprd12.prod.outlook.com (2603:10b6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Mon, 4 Jan
 2021 18:37:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 18:37:14 +0000
Subject: RE: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kyung.min.park@intel.com" <kyung.min.park@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>,
        "jmattson@google.com" <jmattson@google.com>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
 <20201230071501.GB22022@zn.tnic> <X+yl57S8vuU2pRil@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <8a392a10-9367-31ee-1a63-bc57a40ab82d@amd.com>
Date:   Mon, 4 Jan 2021 12:37:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <X+yl57S8vuU2pRil@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0024.namprd02.prod.outlook.com
 (2603:10b6:803:2b::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0201CA0024.namprd02.prod.outlook.com (2603:10b6:803:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Mon, 4 Jan 2021 18:37:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 442a9bcf-5c71-48db-e14d-08d8b0dfc1c3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23823711FB98D3E29BFF204B95D20@SN1PR12MB2382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuAC3RPtPcV/iW/z72Hmi1EST+9DJfZ+/ypx96ahge4C25LD22BjATWANsWlrhJ4pvdMk3pYFCKM0eMpLYQLkvCiLwPGHtcAGHVGUyjvoaClwacmTlZrBakvCoIBCnmkjfI3u0eYldwyx1OMu2oE9RMTcfNSdrs0ayzY319PUUvXx+MkT0hA7N8jVRXDQ5mvdR1sMcMgJVW8C1p6mZXVmqZH0z50qnG6KZIMngiix5Ucg8xtnDDVoe4sBZQEscN+Nsxzm2RTm3VQJBaTUZ077CXK6zAK/9LtnEaOpbAL8zVBY+SwM4Ouq2/gD4xrgigFGlzrEaUUvlbXUZIQ42XFlHNei3kt+vKTRCEqqa1g6n0JAAlqJ+XCoj+0kYqLVHiWeisGQW4aknZav6dIgkzhuox2JhLYfTNp5PS2TD6xInoi10eV0/QHCCx4zSBUg88JijhzPHcGm7eu0pNqIMDMFVjAeC4GW5H8wxNCKWdBT9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(44832011)(66556008)(31686004)(16526019)(478600001)(956004)(54906003)(2616005)(5660300002)(52116002)(186003)(66476007)(66946007)(16576012)(110136005)(83380400001)(36756003)(53546011)(8676002)(316002)(6486002)(8936002)(7416002)(31696002)(4326008)(86362001)(2906002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?QIzfxxzq+5c5Z1ORSsgT9DKSJA39HYbNb6EUb2pScC6ui9i3ME+Rd6lk?=
 =?Windows-1252?Q?sQU2iY2qsBPpCbqBuf+cn53I/ZuFz302oGeRpNVao7cf284rT8XBG9t9?=
 =?Windows-1252?Q?R3nIXYo1YsOPi45+rO0vAP4dJ7DwApGI8Lq5CwTMj7CMl5EY2OwEzJWT?=
 =?Windows-1252?Q?aGJcbDvX0ymFytQDB3ggGVNxdGfUbb1gp07m/GsJfEoqLILAQ+iSKt3F?=
 =?Windows-1252?Q?gZDSgRTrIJWuOkZ6IE1+jm3aSVj3GEw8aKTuKPocS8FlNU3kCfDwDHvD?=
 =?Windows-1252?Q?IKf+dU4WLb+L+PIDEaFfs6AamiyPOk8+/1Jvd+x0YDE/SFHpyg+HRKSK?=
 =?Windows-1252?Q?jnZCSOdQqs42smbNfKWUZNTBBFKBPUicp5/Jvl7d5R5VP9spau7iq4+K?=
 =?Windows-1252?Q?xhWj5YZvDzofVcAX+i2zkSLa2znCt3UUeEVz6uGKjA5iTNctaV938Sic?=
 =?Windows-1252?Q?mHw7i/xbOkR9kMvD7A1340UKgXU/EOxe5qfxsrxelcq4/O2Baj88JQ+r?=
 =?Windows-1252?Q?ph6Oa7ZNW5PkowWyEDMXUWkgDUWd91IE6U3iNA1MLaKdF7Jv2DmIzyw/?=
 =?Windows-1252?Q?6mHhLnL8nNf327O7lhpsxjL/SyU4hi55gymo/gMqGZTSt1uE1b+4j3uX?=
 =?Windows-1252?Q?nIU4zPGXOzjjPoeAT93f60TxbFtlexmtrd4GwEbix0ski4PBzEZ7jfyH?=
 =?Windows-1252?Q?RkX65dFhND5DtwRn/2OdFSGMDb+WQ5HPZhp6tC8zv5nEOmjx7Zdz0RaG?=
 =?Windows-1252?Q?E2pl1Tu6b1xipBbUknuRiRKLhG6rk7CbyJPwX4dvsn3aLhsW7NZuq+Ej?=
 =?Windows-1252?Q?eqVuhA6BtPMRa1vcdOvkntVIY1Rc3mvp1OV3skimCgw+RxbJhTcMX1zd?=
 =?Windows-1252?Q?UkdMT/zcU+/e3GUUSZZohjN5hM02ltTC2O/2W5SvY6Z7NpGDiIJriFl9?=
 =?Windows-1252?Q?iUf+pcO8WrmDzkHxEOZfzsamnNRZ5zmQNosFhLH/O0QcW8XCVJDtSo+P?=
 =?Windows-1252?Q?0whmOOn5URgRN+cpU9XD+rv1Ty59XDaQN+KxUctXjY3NsfxLwrMrlXIV?=
 =?Windows-1252?Q?Yr6NWxN/QPZORiUx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 18:37:14.6811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 442a9bcf-5c71-48db-e14d-08d8b0dfc1c3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MaZ6C3voWLRDBhC0UWB4RSYI7s2P/T2XOO+UjoNV1jCtoPYQSErVJ4daJlyFdkk4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, December 30, 2020 10:08 AM
> To: Borislav Petkov <bp@alien8.de>
> Cc: Moger, Babu <Babu.Moger@amd.com>; pbonzini@redhat.com;
> tglx@linutronix.de; mingo@redhat.com; fenghua.yu@intel.com;
> tony.luck@intel.com; wanpengli@tencent.com; kvm@vger.kernel.org;
> Lendacky, Thomas <Thomas.Lendacky@amd.com>; peterz@infradead.org;
> joro@8bytes.org; x86@kernel.org; kyung.min.park@intel.com; linux-
> kernel@vger.kernel.org; krish.sadhukhan@oracle.com; hpa@zytor.com;
> mgross@linux.intel.com; vkuznets@redhat.com; Phillips, Kim
> <kim.phillips@amd.com>; Huang2, Wei <Wei.Huang2@amd.com>;
> jmattson@google.com
> Subject: Re: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
> 
> On Wed, Dec 30, 2020, Borislav Petkov wrote:
> > On Tue, Dec 22, 2020 at 04:31:55PM -0600, Babu Moger wrote:
> > > @@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu,
> struct msr_data *msr_info)
> > >  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
> > >  			return 1;
> > >
> > > -		msr_info->data = svm->spec_ctrl;
> > > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > > +			msr_info->data = svm->vmcb->save.spec_ctrl;
> > > +		else
> > > +			msr_info->data = svm->spec_ctrl;
> > >  		break;
> > >  	case MSR_AMD64_VIRT_SPEC_CTRL:
> > >  		if (!msr_info->host_initiated &&
> > > @@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu,
> struct msr_data *msr)
> > >  			return 1;
> > >
> > >  		svm->spec_ctrl = data;
> > > +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> > > +			svm->vmcb->save.spec_ctrl = data;
> > >  		if (!data)
> > >  			break;
> > >
> >
> > Are the get/set_msr() accessors such a fast path that they need
> > static_cpu_has() ?
> 
> Nope, they can definitely use boot_cpu_has().

With Tom's latest comment, this change may not be required.
I will remove these changes.
Thanks
Babu
