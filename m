Return-Path: <kvm+bounces-3703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFF880738E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E598CB2117F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5BC3FE38;
	Wed,  6 Dec 2023 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hs85gJCk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32D2D4B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:16:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWIsrZpDs2sqfX51kbJn6FLzQsrjJi5koOTerCi8qAn3i50fwW8KffYA/dn0CXCRCaZTjRZiNwRLjonSnMAifsGlReOz2w2PT81bJ4DuU7rmJbkLlFGb4nqnc+unmB/gMmQrQznA68fRBnsUJjA1JfvLVl6U1Yf1g089DR1k1h7DuXWT31/bLkXvpKRwllM9wjmVNhEAaBp7HAVOnQ5OPTxhk3Iox8mk/t3/qkRJgYWKtvCX6wzMMXpAb3KUEZIolnPpnM/eriwVqRoRMZynb/sLMupU7xdTFjPmtYbn/ah7xjDf6DboXL+0QMKV2zQuqlzp6YCPIyFm6oozuqxv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8jZmILvQXNqOKv08St3gFunr4/amTDE7+l9oZXDl3k=;
 b=gONAEYdwTZ93Ol3dd6VI9cHb3KeexxkP7eNvZmXZ4IyIr4cyz6XrvWoyQfYbytlXNi96/kPklw6aQb7DGYE++cVcFtp2vbYai0omDzRHwde4d25+gaWdVAeUdgo2KKnPb9fLOtnSClC5FBE1h0IbKr0hNbYtAWs1u2NlwAbiD4iZu2DA08uQIGojRJsMiQKQnpvnEdn6oPAiHvebvpjsgU8Tw8Jv0Zxmm7U+7goJZMaE+ihlQyQp0NHfnVABDOtBlQRmJ3SLQVxeeMtRsWF41PbwgY/I9GhvHQKMiLLxwRzrbrbe60mOcZgQk2FjnHyD2WV83oc3XKY7oowuZdDHkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8jZmILvQXNqOKv08St3gFunr4/amTDE7+l9oZXDl3k=;
 b=hs85gJCkpKHuV/785IQftHSuXH1nEPWrVoi//AWj1X2z9E4x3/8HtGsFkwGjDNRhB/QUQb1U3MCMDLedJiy0FfdWM+XHvo88k8P7LLgsiFudK+YZOmhYC/2DO5qCTNgF3E7wiUXRE0wtkvzQ3l4H1ZO107IHBcBiuFTHTnLJew8=
Received: from CY5PR19CA0022.namprd19.prod.outlook.com (2603:10b6:930:15::33)
 by PH7PR12MB6538.namprd12.prod.outlook.com (2603:10b6:510:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 15:16:26 +0000
Received: from CY4PEPF0000E9CF.namprd03.prod.outlook.com
 (2603:10b6:930:15:cafe::c0) by CY5PR19CA0022.outlook.office365.com
 (2603:10b6:930:15::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 15:16:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CF.mail.protection.outlook.com (10.167.241.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.26 via Frontend Transport; Wed, 6 Dec 2023 15:16:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 6 Dec
 2023 09:16:23 -0600
Date: Wed, 6 Dec 2023 09:15:15 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, Marcelo Tosatti <mtosatti@redhat.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, Akihiko Odaki
	<akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Message-ID: <20231206151515.njyp3pwso6m5lkyx@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <CABgObfb0YmHuw6v9AGK6FpsYA1F3eV2=4RKaxkmVrp97QCDM3A@mail.gmail.com>
 <20231206144605.mwphsaggqumiqh3k@amd.com>
 <CABgObfaF=rJL-V0vBTnNMGFreRD2cJCjkYHxYBFjZktyd+dH8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaF=rJL-V0vBTnNMGFreRD2cJCjkYHxYBFjZktyd+dH8A@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CF:EE_|PH7PR12MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: 83885ad8-4af7-4c29-120d-08dbf66e4f9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bDRWZomav9f1LKyRZvFWmp6lnk7ZY81KCdE2ZOE5kU8XRH6rzudroQ8SKjdMXcrQ0MS8Zc1xS92y28Eq/vDfIX6hmbtgVTqSOV3fAC3ZFsd1QjtelVRgik2uh/KFlGa/5JF5ijpuxUG+tLHQ45aEyMF/GazUkhs/VGAPrewxFLssLqCkHwQqviBSnd5dCXuloeu2cAJ5MXFcRo5rsUj6Cm/dcTqOxsc6XgYUPk6KwAX8IxwpOIot8+ffZmKDt0EpBmf14g+jSzN9T3u5JXc1XejRd/ETaGTOORXgX1XMBjpu23Zchibiw+5qJhe8sd76Jrkq+vVNJHpqqcmOji+9PJvyqny7Ucrx1Z7WMTdvBB7oTdHZWwJ2ujx6llfXlAEqdDFkfl83LpufA29Kw4ayQc+YjFjs5NhDG/vB4+q1KT6t0g6VuHb5w3nBU0S3EoCcUONR9H9X/EFnxrtZD51TAcRr6OkxC9Aki87L8tvzIMjfr+q2/bcbOI6+2aeWDx4DTCDk+Q8TeLNm820u4BEyA0LQkIKmjhyL0pHG+KdMzzQuAxwGJ4H/Rq+frjBT4xw48FM2FTJsnPS5limk0tkwmi/PTBZTKW6VTKSTTgNRcb/zq252/9FVll9qt/JQk+uYf3aOILbfZLlox1zCPSerkcdJGniNfrJoC3fulN9apuW+fz8lErtGBNZK8l7PmaSNCjasVcojjrHSFw1V76HhuhwP2VaPo/E253Q2pSpWWni5lxk17DZHFQen+xd06/YAxqXpXsd9lUUyDpR2GYYPpQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(396003)(346002)(136003)(230922051799003)(82310400011)(186009)(1800799012)(64100799003)(451199024)(36840700001)(40470700004)(46966006)(2906002)(5660300002)(44832011)(36756003)(41300700001)(86362001)(4326008)(8936002)(8676002)(316002)(70586007)(6916009)(54906003)(70206006)(40480700001)(36860700001)(47076005)(82740400003)(356005)(81166007)(478600001)(1076003)(40460700003)(426003)(83380400001)(6666004)(53546011)(16526019)(336012)(26005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 15:16:24.4492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83885ad8-4af7-4c29-120d-08dbf66e4f9d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6538

On Wed, Dec 06, 2023 at 04:04:43PM +0100, Paolo Bonzini wrote:
> On Wed, Dec 6, 2023 at 3:46 PM Michael Roth <michael.roth@amd.com> wrote:
> > > There is no need to check cr0_old or sev_es_enabled(); EFER.LMA is
> > > simply EFER.LME && CR0.PG.
> >
> > Yah, I originally had it like that, but svm_set_cr0() in the kernel only
> > sets it in vcpu->arch.efer it when setting CR0.PG, so I thought it might
> > be safer to be more selective and mirror that handling on the QEMU side
> > so we can leave as much of any other sanity checks on kernel/QEMU side
> > intact as possible. E.g., if some other bug in the kernel ends up
> > unsetting EFER.LMA while paging is still enabled, we'd still notice that
> > when passing it back in via KVM_SET_SREGS*.
> >
> > But agree it's simpler to just always set it based on CR0.PG and EFER.LMA
> > and can send a v3 if that's preferred.
> 
> Yeah, in this case I think the chance of something breaking is really,
> really small.
> 
> The behavior of svm_set_cr0() is more due to how the surrounding code
> looks like, than anything else.

Ok, seems reasonable. I'll plan to send a v3 with the old_cr0 stuff
dropped.

> 
> > > Alternatively, sev_es_enabled() could be an assertion, that is:
> > >
> > >     if ((env->efer & MSR_EFER_LME) && (env->cr[0] & CR0_PG_MASK) &&
> > >        !(env->efer & MSR_EFER_LMA)) {
> > >         /* Workaround for... */
> > >         assert(sev_es_enabled());
> > >         env->efer |= MSR_EFER_LMA;
> > >     }
> > >
> > > What do you think?
> >
> > I'm a little apprehensive about this approach for similar reasons as
> > above
> 
> I agree on this. I think it's worth in general to have clear
> expectations, though. If you think it's worrisome, we can commit it
> without assertion now and add it in 9.0.

I think that seems like a good approach. That would give us more time to
discuss the fix/handling on the kernel side, and then as a follow-up we
can tighten down the QEMU handling/expectations based on that.

Thanks,

Mike

> 
> Paolo
> 
> 

