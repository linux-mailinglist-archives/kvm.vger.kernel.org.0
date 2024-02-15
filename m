Return-Path: <kvm+bounces-8809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CE3856B43
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D999D1C2341E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA55137C32;
	Thu, 15 Feb 2024 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jtv9GqAU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC30136674;
	Thu, 15 Feb 2024 17:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708018771; cv=fail; b=VgM487cb9hElu8W8BAuTn4+wZz8lyb41egb1eQPI3xX/Vq3BDlrBv3E87M5QFdA2SOOrPAa8MosxXXPfHBBKoLuSVweuuY/8aB9XcgY3OqWpElBGjTDX2Q7XyYZnrPM5p82EkFxepaYWtBKv5pKNc3EdHCpqYCNthWfRQ/Irplg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708018771; c=relaxed/simple;
	bh=YCUPWGMfrzAz3a/96tP0XvrQzwEx3sgTMSIi7MxvEnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uDLA42JQDSZyOgke12gNKLuKo5q36zcWadGdYVJlx7mjgPj5lxbsJhL8Ek7690vjpPGEFcwgK3pHueOeRNaEpKOfLjbzsBPGJ93BZ45Twleeky0UmPb0aSyetejigvZikE7xpY4Z/YcGfMzB+3Pnh/qJcxLM0rwhIjKihbMAk8E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jtv9GqAU; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RU8MkQAuLuqFWLaFgcPP+jpmphe+vja4CBmHSiwg/GUsIKTq0l9oMEUvP2uZQdT9ZYhAY7Ic9ObNobMfllrVc50A9wxnu8XOUgrBf6//q+DWgnMlEyZ0nLFvloFDG3O6hv/Z85A9xOgRDuapphon6saD7kOobhXmvrS1pqwu/Ips1MAk//MI/4grmiaY8rbNku9wjaPSBdqPnrHFv/BxsxZERNdKSBYbg6hjNmwzVaz1bBltUJLCtKgQrDL8PeQwYyPybELNLA1OQ7mSWGaqLTuu0cibVMgjWKCph1sqCCcDZn9IsCPI7lI9q9lyOo7ugf9Dl1S07T/i/vBGPgIBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ntp//jo/0MbG3rXkwxbw3+RYBvfkZFtSX9kDqOZmQDI=;
 b=H1ywVliSndf1hWCtuXIIl/YEtnq5TLJ/ld+xeXdUm2Hu25nHfX+jM6pKJFHvG7XVzt356ilgC9YiupiNGbqMNsx0ZIAOOkvkcuWbIv9K21lbzM1yvk7xS/I3QBJiQM7cJzCGEHelLnF9cmakFyKuRcHxo7QAd5hJLiWP0MPrFbpDB9NniwQYu0WJzZDPPBcAHXSu6/3BA6uqLVS1EjM7xFBU3LtCCfkp0ZAM1od0GikUjj8/81F7cMxI9+UC90thWLLWOPV2iBgfBiklvohsbLmWw33+YV0Qe1VPH1sffyzo/oTqJF8iGjDzfOvg019nfXVVhqjJ25Va++fdHlc3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntp//jo/0MbG3rXkwxbw3+RYBvfkZFtSX9kDqOZmQDI=;
 b=Jtv9GqAUpNOnE5pZQc0C3NElvuA4I1MACNC/Y1Sv4+sqxxMPXTr/3RTfgurGajOOc/DQz4fFNbkbFbXx5McfwktyMGMGref8LeL28Sn5XWvNNNZiEmUhldP7jc5HJeDdqIg+6XWxMSlLoQDkDMU25pR8h4feJTdrSDPAPhq/S+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by MN2PR12MB4239.namprd12.prod.outlook.com (2603:10b6:208:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.27; Thu, 15 Feb
 2024 17:39:27 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a6e6:9792:57ce:1df9]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::a6e6:9792:57ce:1df9%7]) with mapi id 15.20.7292.022; Thu, 15 Feb 2024
 17:39:27 +0000
Date: Thu, 15 Feb 2024 11:39:18 -0600
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>, mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	thomas.lendacky@amd.com, bp@alien8.de
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
Message-ID: <Zc5MRqmspThUoB+n@AUS-L1-JOHALLEN.amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-7-john.allen@amd.com>
 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
 <ZUQvNIE9iU5TqJfw@google.com>
 <c077e005c64aa82c7eaf4252f322c4ca29a2d0af.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c077e005c64aa82c7eaf4252f322c4ca29a2d0af.camel@redhat.com>
X-ClientProxiedBy: BYAPR07CA0108.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::49) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|MN2PR12MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: 384b7ce5-aec6-4c32-1c4a-08dc2e4d0e80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rqMw4CmDZrZ56g4m4SROs1aJBd2pAsqq0hJE92uP9jNvIJtZueKyD67FBjUFBclyFof/0z+HfQWogOSnJjX01ORxCNkuckSIvHGeDQCLhted/djSfZW2tORqiV1jmszfJ56PUEAPW91hUn5SQEfthxTQ1yZXo0qx0WRuOy5vtcqEp/LrvDd66tC3k2p61IPJcliJV7TMSO9BqOdHawq6B/P1ij8fanmMGBlawZ5e8C6CBJXNon0lVKqghJYQ/Wtaxe2WHELUw3/pAd89ShxLiZJ60mTrTVAscrTtp9XH6lN7CBrJDOhR6xjVUbAzto3tLrhHTZMgHDZeVB4lI/74Ijf8jdGS01fCj41cK5IHgGxZP5WW5rtvyMmyrwtNDFPvdjTx+0YlDFloA3Z6KH8sK7P0OZIsm9ct4WorjiRjkPtUt4/TUbnKxyusi5v9FsUudBBvFDfK20yHErhfzpK9cFT3Q+eCLgjqfBBRHmp8hJiSXXavz2lBSyz+r/vBdMYDBA/wKcmq5o+Z3GNFVwieq+gW/Y0Uauy5oxeLaw+jeRW7XkfqRqAFIcryGjxaoXYt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(376002)(396003)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(6486002)(478600001)(41300700001)(2906002)(66556008)(4326008)(44832011)(5660300002)(4001150100001)(8936002)(8676002)(66946007)(66476007)(6666004)(6506007)(6512007)(316002)(83380400001)(86362001)(38100700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZV9pD9C9ZZi/0tXbI8rVlT8ciWrTP+3RyWBK9K57U0X6d5GS2KA2Z98LpWya?=
 =?us-ascii?Q?GcvJafnLWsnxjHD+wiLRqay4gFSp1igbvdgzP/alc74BEGSm68GvC+6wzmRY?=
 =?us-ascii?Q?NYF0iYCG5CBqL6SAkxl/jybYy51jiC9ee4YN0MLrGI/p4NXNEUq74PqtY5bu?=
 =?us-ascii?Q?nudHISTWei+NiYndz8uJ9OAEw1KAh99tYaEXbdFJCuzs6zdVa3ncGZhnDQZz?=
 =?us-ascii?Q?prMKBNKursLnOT9ejsBUEybaZ36vcKoF0RQuSvYyAQqtchTERY1+qy3DBdRd?=
 =?us-ascii?Q?0vo3AxtkZ1C5pdYT0I5R6uZuKsh3v8pPoGDP7TCVoo+YXhEi/m8WrTBfoomU?=
 =?us-ascii?Q?JpT1EwZJ4nvvgEZR2XlBlBqNXXu9jpvsLbQ+EJ090tVolqeoCVreAuT7B691?=
 =?us-ascii?Q?4+5nkaIjgYTHz+2E1VkpT2s39mcQ2KFwGvyfjJ+OyNhfa/4H+ODoiUx/A+i1?=
 =?us-ascii?Q?r463NCGKxP39UQaK+6tkBihieNNHMBLCR0DHH7OsjMhn37L4j9j7Apo02ORE?=
 =?us-ascii?Q?UA9TE3KPpW59I2ZHRJb3r+AT8fbxr4urvPtuwG6v4iisks7EhwwPSnq9qQ4G?=
 =?us-ascii?Q?7in+GsrBugqzKamWd3HbQ/wOz9xPs6XwcJ+JOuluE2lNSaa2Ayj9lpic3ZnZ?=
 =?us-ascii?Q?wJ5D5V4q/iWHCIHN8hanw10sx+6UeZ+SimOcHNSYv76oMJtWP0TPE0ucsB7S?=
 =?us-ascii?Q?zX7QhE/9ODM7bfTvH3qmjMYXWO55GQuWSu/bjqEvgGGZmE38gUFdjMXRakBE?=
 =?us-ascii?Q?SNb/8TPhxwFFQ/LYXrNLwDd+FBTAEi2C+2nzPhaVaOjjSTqBJX/nnHVrRBqA?=
 =?us-ascii?Q?6B2R+8FYX71sVXlPKUX7NtzF1TJZQEGg5CpMyoQsj/Dy+lTEohEM5OoUyVer?=
 =?us-ascii?Q?k1o2HrOOTep8Ahr1/2ykrbHo9y5Bs+dP3/PuWNqdptqlNqRnl4YorrX/UFjB?=
 =?us-ascii?Q?/zdGCggtXOcmrtCWPrO7GWjKCb0wMRy2vr7lDdAzMqC+UZTbw6LhcdbdbimZ?=
 =?us-ascii?Q?i/odmBAaKjdk3WQPOflx/IPFNmr8xVfAXnkCFQDwfPQmmK46ZUkQjepvigJC?=
 =?us-ascii?Q?wFxSGWu18KDPw6VIaRV721/yIpQqiIEGwun0wdM2TwD/25R6colvvJmSzzm5?=
 =?us-ascii?Q?ixPweXb7EYJ3rMnJm/s//Q0EFWu/3PirqGi0b3gBmXta/DQLyoPGvfel7CUu?=
 =?us-ascii?Q?QucVEhPg6Y3W6fyW7lOrfXavzeB1hymLpdx9dxpkQeDjT2bTLqDB7qmNCxd/?=
 =?us-ascii?Q?Mwxjz3UEXV5UHbDq8tFQ9E1zldQvGy+2Kh+UmA9a6+Ar19xwPMxtgtytCgHJ?=
 =?us-ascii?Q?ggIN9d97DpBPpbcS5HoALz9ogQMchrG0BYCf047wRKs2c75C2NuHsT0h9yEz?=
 =?us-ascii?Q?2kiCNqSaKiYuvI5fRQO+1x+4BTCmRdGEpcaqSvse4es2OVhC79JQPHPpDaju?=
 =?us-ascii?Q?XDViznjqo5gYX/mwGlBjeYIkzCFgspXLW+NidrNDBItKIs9YufdXkQn7BmKj?=
 =?us-ascii?Q?VtLZbRLmfTJ0ki7PhqApYRmOo8me/rCpHffOj7CzeT1eBs+Wy6Uhe+3S1rvs?=
 =?us-ascii?Q?YNeuOLdh1Nu2DKUodiMez7Uueh9o1eynm4MKiqsp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 384b7ce5-aec6-4c32-1c4a-08dc2e4d0e80
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 17:39:27.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lTYm3b5K7ftp2LTwJZlFUVVFTDjOMjKqve8N2uGHbwgDCC44bN9Qq2b6KdgD5LMUvoxM2Md4m/Q8cN7Aq/cWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4239

On Tue, Nov 07, 2023 at 08:20:52PM +0200, Maxim Levitsky wrote:
> On Thu, 2023-11-02 at 16:22 -0700, Sean Christopherson wrote:
> > On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > > On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > > > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> > > >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> > > >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> > > >  	}
> > > > +
> > > > +	if (kvm_caps.supported_xss)
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> > > 
> > > This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> > > to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> > > that guest must not be able to access.
> > > 
> > > AMD might not yet have such msrs, but on Intel side I do see various components
> > > like 'HDC State', 'HWP state' and such.
> > 
> > The approach AMD has taken with SEV-ES+ is to have ucode context switch everything
> > that the guest can access.  So, in theory, if/when AMD adds more XCR0/XSS-based
> > features, that state will also be context switched.
> > 
> > Don't get me wrong, I hate this with a passion, but it's not *quite* fatally unsafe,
> > just horrific.
> > 
> > > I understand that this is needed so that #VC handler could read this msr, and
> > > trying to read it will cause another #VC which is probably not allowed (I
> > > don't know this detail of SEV-ES)
> > > 
> > > I guess #VC handler should instead use a kernel cached value of this msr
> > > instead, or at least KVM should only allow reads and not writes to it.
> > 
> > Nope, doesn't work.  In addition to automatically context switching state, SEV-ES
> > also encrypts the guest state, i.e. KVM *can't* correctly virtualize XSS (or XCR0)
> > for the guest, because KVM *can't* load the guest's desired value into hardware.
> > 
> > The guest can do #VMGEXIT (a.k.a. VMMCALL) all it wants to request a certain XSS
> > or XCR0, and there's not a damn thing KVM can do to service the request.
> > 
> 
> Ah, I understand now. Everything makes sense, and yes, this is really ugly.

Hi Maxim and Sean,

It looks as though there are some broad changes that will need to happen
over the long term WRT to SEV-ES/SEV-SNP. In the short term, how would
you suggest I proceed with the SVM shstk series? Can we omit the SEV-ES
changes for now with an additional patch that disallows guest shstk when
SEV-ES is enabled? Subsequently, when we have a proper solution for the
concerns discussed here, we could submit another series for SEV-ES
support.

Thanks,
John

