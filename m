Return-Path: <kvm+bounces-8824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAF4856EBD
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 21:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A0D41F28A43
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840E613B2A7;
	Thu, 15 Feb 2024 20:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ebjrGlFZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C307132461;
	Thu, 15 Feb 2024 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708029865; cv=fail; b=efWXTeFSNbEodSBebOLBKUwOdyK5dToF2PrljaizqTjIWg5hgCESgLWx8Kw8eSGF5gXMH0URe/lNHgWaKaBW5rSTJNhrNwzDlDtRWvGN32L3bAcZ8jZQ0BhjWK5d7bzSFQ3VK22OyVaEi7h/Z7JGx4BKGwSIyWYMv8/PnscE0vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708029865; c=relaxed/simple;
	bh=5BZdltKvKXTjNqo3fnFc8k5zsmubx/h7ubbE1+L/mis=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNE+rNrpV01ZjERP2GTsNa9xtVyTREVQ6/720Ftx2zGmeOxxnyk9bb22S05xFRSOPdMxVgXndLSJoaCy+c5hAY1mRyyKm8AxuHFSREK5NL3Oiu4wiQM2MZI7fUeIdMn9iDP9dnn4jOABWww/pkZby4rYOmzOj+ODlvA4mVFg4AA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ebjrGlFZ; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eATmGDpCERJSF6JBXDqHfzqK6YHjWj8f+JHj5S8XZ/t/R/Fi4VaJ71GYZK73HTGAbWmsQGYCrwUJjBEXrbzIcNxy2cF4wyKZ1b6FjMvIHDgUTJZiflj4q21IQR9s6tG78kj8hnktobl0YtkQ9M3/lx+MJ9TJzMg7qIvsclj0m5llKZhsoAPgoU/vsWMDL3T8QMDOSyGNG1fBo7vPdXaSfN+0kW8ID3q0o7T6w38qyMzWk0U6FJ2P+outOShtskE7odJyPbJLeHR+fjo26Vf5uoMpuaPJSFE/CiQrfnS8Q23LN68f4ZMUjB4Bg9Mr8TEtxxbsRX+CFcYiRV73qOfOpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KslAoD7x8nbJOpdz1fEVgQWtR94WfutxOv4uSu2GbFA=;
 b=CltfGO09JQDmbMFf24LnxUhgaUIVx+pBfSak5SdXXgKqPFbokvoBiYtkwcVCGyQrFQqW8nUz9xlU3Xy6zJ+yJjyx5UgjYZfOdxRF6a6QWV5bNn2r0bK96C6eVihgPegPTDkT31utfHxkmFHXrHEYr7KtJjMyViVyD1X32a3vpzDQbMy0skmm7dsgFtkbbfslXwMGEed2AUHdZ1El07n0P7KzDjGKCBRAteE0qSuIoWGk0ZFvKiKHb7l2Bd3wp3KXMobH33wym+t3eunOeKjQFD9vRtSF7TeTD5cpqpyQwJVcZnSUu9rk5LR3KRZv+NS+kJ7HiVeW0RiqFYVAJ7gk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KslAoD7x8nbJOpdz1fEVgQWtR94WfutxOv4uSu2GbFA=;
 b=ebjrGlFZrOI2r1+ztSP+IfpIVxmA0wBw0oyqYDeKe3/OjQHcYlmMpNP8QCbWwNbQtd7iLii3ZgQRF2dHoaN7LP4oU12jCc8OBd+SRHPjE76W1GO78Vx/i/fJC72dbPEy/jDdPt7kWjQ2ElxyfcLC3I8DmsvZUfEbnvz6UTLK5H4=
Received: from BYAPR06CA0052.namprd06.prod.outlook.com (2603:10b6:a03:14b::29)
 by SJ0PR12MB6805.namprd12.prod.outlook.com (2603:10b6:a03:44f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 20:44:21 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:14b:cafe::de) by BYAPR06CA0052.outlook.office365.com
 (2603:10b6:a03:14b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.40 via Frontend
 Transport; Thu, 15 Feb 2024 20:44:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 20:44:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 14:44:20 -0600
Date: Thu, 15 Feb 2024 14:44:02 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>, <Larry.Dewey@amd.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Message-ID: <20240215204402.7crlvwa7rjy2k7zn@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
 <20240215013415.bmlsmt7tmebmgtkh@amd.com>
 <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
 <20240215144422.st2md65quv34d4tk@amd.com>
 <CABgObfb1YSa0KrxsFJmCoCSEDZ7OGgSyDuCpn1Bpo__My-ZxAg@mail.gmail.com>
 <20240215175456.yg3rck76t2k77ttg@amd.com>
 <CABgObfa_ktGybPcai=OgBbYMMvm4jS_Hehc-cdLdFoev68z-GQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa_ktGybPcai=OgBbYMMvm4jS_Hehc-cdLdFoev68z-GQ@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|SJ0PR12MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c60733-9ac7-4891-8ffc-08dc2e66e324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qD9A3HjcFRqHMX03LtHed/TKVtA6EqfAj+xSW2Ud3d9gM8f04j5Pw8rEc6Ietg3qL8Jif6HYBeXbWOiFME1skXVVA1lB5vIftZBXPLPoWH+1i8Ton7lDhAkO454gl08/TZXfV9ZjF3gBunwnAON6wASP6v/gyfqHhVlFMA1dPhOAu71+s9kCE1pnrakFobYaZRy+H9XguMy4hP+KwspZq/UWeu6K3g1XlpmScdYygFSc1oKhLSyqqm5DO91kwBrLiC1k/u682Fb04AqUXcZyRvKCZ1bahux5GaB8u7sck3T7N4olIJjCb9rUpVcbb7S1q6Dt0xRN5TfBZf24N2NyEK3Say+jUVy/CSalSLIZkTM5AGo1LZ5z+52mz00M2Hog6FrwbrOusIESmSJoSmgFbZ+MOcffMq79m++VEDDcpdvljR7Udp6kb0vq9t+24PiwkEBOFJnyqQhfxmM3taEwgp2W9uYrdhjzNw+iWh3pdt2zUIqyudNMwCAKmonhAeEypoTx+3A1p+UGS2C0kdQUt0ZqktGWEk6mCqYVcTD1SkvqSjfquTRyRt7bXJ/INTA/h7jw957tZ2Ge6K5is7MYUB+tcw5S1wCp7dY9NmeKKwLwG4fk1dYT0KkuA6omQLsN8UZOkjKv+JfslSHULMYjqfkqb3GxUj6IelCanWzGulw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(39860400002)(396003)(230922051799003)(230273577357003)(82310400011)(451199024)(1800799012)(64100799003)(36860700004)(186009)(40470700004)(46966006)(6916009)(478600001)(1076003)(53546011)(8936002)(8676002)(5660300002)(336012)(83380400001)(16526019)(26005)(4326008)(70206006)(70586007)(426003)(54906003)(316002)(6666004)(356005)(82740400003)(81166007)(41300700001)(86362001)(2906002)(36756003)(2616005)(44832011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 20:44:21.0883
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c60733-9ac7-4891-8ffc-08dc2e66e324
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6805

On Thu, Feb 15, 2024 at 07:08:06PM +0100, Paolo Bonzini wrote:
> On Thu, Feb 15, 2024 at 6:55 PM Michael Roth <michael.roth@amd.com> wrote:
> > > The fallout was caused by old kernels not supporting debug-swap and
> > > now by failing measurements. As far as I know there is no downside of
> > > leaving it disabled by default, and it will fix booting old guest
> > > kernels.
> >
> > Yah, agreed on older guest kernels, but it's the measurement side of things
> > where we'd expect some additional fallout. The guidance was essentially that
> > if you run a newer host kernel with debug-swap support, you need either need
> > to:
> >
> >   a) update your measurements to account for the additional VMSA feature
> >   b) disable debug-swap param to maintain previous behavior/measurement
> 
> Out of curiosity, where was this documented? While debug-swap was a
> pretty obvious culprit of the failed measurement, I didn't see any
> mention to it anywhere (and also didn't see any mention that old
> kernels would fail to boot in the KVM patches---which would have been
> a pretty clear indication that something like these patches was
> needed).

Yes, this was reactive rather than proactive guidance unfortunately,
resulting from various internal/external bug reports where we needed to
suggest the above-mentioned options.

In retrospect, I think we would've handled things differently as well.
Which is why I'm hoping it's possible to ease the pain of another
potential measurement change for those who've since incorporated
debug-swap into their measurement workflow. But maybe it's not
realistic...

> 
> > So those who'd taken approach a) would see another unexpected measurement
> > change when they eventually update to a newer kernel.
> 
> But they'd see it anyway if userspace starts disabling it by default.

My thinking was that this wording would be specific to KVM_SEV_INIT, as
opposed to KVM_SEV_INIT2 where disabling all features by default should
absolutely be the way to go.

But realistically, it's not easy for a user to tell whether their VMM is
using KVM_SEV_INIT vs KVM_SEV_INIT2, and it does seem possible that
having the defaults be different between the 2 would also cause some
pain down the road since even in looking at the documentation it
wouldn't be immediately clear whether or not debug-swap would be enabled.

So maybe your approach of always disabling by default and requiring
userspace to opt-in would be better in the long-run since this behavior
is fairly new from a distro perspective and it's likely only
developers/early adopters that we'd be sticking the genie back in the
bottle for.

-Mike

> In general, enabling _anything_ by default is a mistake in either KVM
> or userspace if you care about guest ABI (which you obviously do in
> the case of confidential computing).
> 
> Paolo
> 

