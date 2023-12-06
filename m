Return-Path: <kvm+bounces-3692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E228070A5
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A349E1C20A54
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49BF374E9;
	Wed,  6 Dec 2023 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xkuFapuf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D3D4B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 05:13:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmFK/CBzt8RBuZmUWWqnrmjwF0bmBRmNrqCPtXDlDUdbHjAXIO5F2Kd4SpYTL6jakOYYfbdFB1ZuxbeZmm3Sr/gYBdYiahnPR5qSkUi5jCCibqMsAu7nkFRTiMSIV0RN7dqeikdzAM3dA1pvm1EZq0oM+EOcBdz7qxiN24cm0tqwbvcSXfs4GP2irdjIaqVL7rxfCiEQwO41D08t9Pui0GUBf9SMlmzeZr8AH6GSxWmPRbctxOjPNTqhPWRuSCRl4j9+3FUE6DnunpTvW59anulfaLucZFXg73nMa6nxr2Nxkm+UxDChgVaTH4JrhMaVWcrvpYhF9GH81+I7MOd+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izrpnY9xboN00V4Yxi4UM63qCSKWZLZYL4kZX2oa2ZI=;
 b=Fl0Ta1VeY8r2xvoijbKQuY3BqCO0YqcvqnGK8uVkWjqe2QJ8fQz2W1DZi7f9EevSRFh3g5HM+naCb7rVKMpogB75YVF7PQDc1gautKDBbtqiV7qd3ZCUAC3Tw6YNMfHtJzXLRm71AwLo9AniVddltGq0pr2iicSMBwtgAa9KDKUGidhMWS0yxfcuSqL9ew9+S+whXRAlCoW+pXSS9juVREdweJ+LVjTHHWExQxnLApEdPE858Vpbw6favQG1dab4/K1ZXjS4QM1aIeodeWNjGKOaafg54xJbay2vF1QzGKFFzlg9mLRPA9o48+RnatOiVb8CbP4qPTdcpXr4LaW6ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linaro.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izrpnY9xboN00V4Yxi4UM63qCSKWZLZYL4kZX2oa2ZI=;
 b=xkuFapufc9cc95BUt4rLY5k6BB9AwC+fUK8GTHDt5cGf4jdRwb2j/GnkXdZYzW21gMbRFjKIG4qcmyi46odBvLGWzg9eESAyi1P+zzs9SXoUY3zxA7Vh0nyveDf5qT6Ixf8kNWyi50N3dZyKAGGNoylfErlKEc1xZOmalO4YOd0=
Received: from BLAPR03CA0172.namprd03.prod.outlook.com (2603:10b6:208:32f::12)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 13:13:11 +0000
Received: from BL6PEPF0001AB56.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::7a) by BLAPR03CA0172.outlook.office365.com
 (2603:10b6:208:32f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 13:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB56.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 13:13:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 6 Dec
 2023 07:13:10 -0600
Date: Wed, 6 Dec 2023 07:12:48 -0600
From: Michael Roth <michael.roth@amd.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
CC: <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "Marcelo
 Tosatti" <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>, <kvm@vger.kernel.org>, Lara Lazier
	<laramglazier@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Message-ID: <20231206131248.q2yfrrfpfga7zfie@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <4e78f214-43ee-4c3a-ba49-d3b54aff8737@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e78f214-43ee-4c3a-ba49-d3b54aff8737@linaro.org>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB56:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf95262-8d92-489a-aca8-08dbf65d186e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5MxkazrhMjvIdQBb91211t7MnLDO1OPk+HgxpWD+2YirLvxvRD/6UZEnWrzIiJe8Tt4l0I7IRtBn9jTuaR0EATWTrxJarUSOC6MbvVEujxe+OcQUag4DWYftxUhSdEUiOHeCayou1FbiqrB2zAiTE6SwaDI8FwyCAaFl1b3K+n0CszW+BZ3QUjH2KBiDsmqLvyG/mSsoECxyvyUDWdF6fh5d/GKaO8V9/ADfe+/i8havGB7wjy2MJXEgG1lcNCJaa+fRC75KZ2wMVJNB/evmiQdsfuwGLt16L+6zoQZIWxwFT+axoN1QMoM67ZJMhnGSP370DSn+iWSihqgz6rgfqwfcgHjQ4V0Fa4Jj9tre1voDq3dWnxamxipAiRFPkwlvKocrQhdmXDgycPCv1dpZhp7Uuw5Zic1Vp4W2eheW/XZCslTOu2poqcgB5Heh0vTH4atXrt4YMnmiFMx/y0BJn6fxo4TfRS9sIv75O0V6gP2NbXzvmY/dDQqQhdFOUqU9RGLIfKlwAbPHFDSL60mzcfbh/Se7aRBBHfXaQ8hp0tlHbhMyKH7Z3jUZh1o4V70dCqGgutG0s/i9FvQzaGiG7GJQW16kS3m6K1BrCOwUBLkNE1pmAvBI/War+LbUBp/g7rBf9+PI7DclELZsL3fRNi4IrwVociXZyVOPQQmHs9h06voDgwb20Kwc5/317ACohuc+v9NbHAfTIq3rx3XKs0GXBN79juiIqHVx2yADytRG/wULvINZUNujRvFW98dhhnDgDtjUNBOv23kSb8n2WQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(36840700001)(40470700004)(46966006)(8676002)(8936002)(4326008)(316002)(6916009)(54906003)(40460700003)(83380400001)(36860700001)(5660300002)(47076005)(44832011)(478600001)(966005)(36756003)(40480700001)(2616005)(41300700001)(81166007)(356005)(16526019)(26005)(86362001)(1076003)(82740400003)(53546011)(6666004)(426003)(336012)(70206006)(70586007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 13:13:10.5042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf95262-8d92-489a-aca8-08dbf65d186e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB56.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770

On Wed, Dec 06, 2023 at 12:48:35PM +0100, Philippe Mathieu-Daudé wrote:
> Hi Michael,
> 
> (Cc'ing Lara, Vitaly and Maxim)
> 
> On 5/12/23 23:28, Michael Roth wrote:
> > Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> > exposed a long-running bug in current KVM support for SEV-ES where the
> > kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> > kernel, in which case EFER write traps would result in KVM eventually
> > seeing MSR_EFER_LMA get set and recording it in such a way that it would
> > be subsequently visible when accessing it via KVM_GET_SREGS/etc.
> > 
> > However, guests kernels currently rely on MSR_EFER_LMA getting set
> > automatically when MSR_EFER_LME is set and paging is enabled via
> > CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> > MSR_EFER_LMA even though it is set internally, and when QEMU
> > subsequently tries to pass this EFER value back to KVM via
> > KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> > which is now considered fatal due to the aforementioned QEMU commit.
> > 
> > This can be addressed by inferring the MSR_EFER_LMA bit being set when
> > paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> > the expected bits are all present in subsequent handling on the host
> > side.
> > 
> > Ultimately, this handling will be implemented in the host kernel, but to
> > avoid breaking QEMU's SEV-ES support when using older host kernels, the
> > same handling can be done in QEMU just after fetching the register
> > values via KVM_GET_SREGS*. Implement that here.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> > Cc: kvm@vger.kernel.org
> > Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> 

Hi Philippe,

> This 'Fixes:' tag is misleading, since as you mentioned this commit
> only exposes the issue.

That's true, a "Workaround-for: " tag or something like that might be more
appropriate. I just wanted to make it clear that SEV-ES support is no longer
working with that patch applied, so I used Fixes: and elaborated on the
commit message. I can change it if there's a better way to convey this
though.

> 
> Commit d499f196fe ("target/i386: Added consistency checks for EFER")
> or around it seems more appropriate.

Those checks seem to be more for TCG. The actual bug is in the host
kernel, and it seems to have been there basically since the original
SEV-ES host support went in in 2020. I've also sent a patch to address
this in KVM:

  https://lore.kernel.org/lkml/20231205234956.1156210-1-michael.roth@amd.com/T/#u

but in the meantime it means that QEMU 8.2+ SEV-ES support would no
longer work for any current/older host kernels, so I'm hoping a targeted
workaround is warranted to cover that gap.

> 
> Is this feature easily testable on our CI, on a x86 runner with KVM
> access?

SEV-ES support was introduced with EPYC Zen2 architecture (EPYC 7002
series processors, aka "Rome"). If there are any systems in the test pool
that are Zen2 or greater, then a simple boot of a SEV-ES linux guest would
be enough to trigger the QEMU crash. I'm not sure if there are any systems
of that sort in the pool though.

Thanks,

Mike

