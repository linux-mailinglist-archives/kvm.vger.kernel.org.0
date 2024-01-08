Return-Path: <kvm+bounces-5854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BC5827BB7
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 00:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6C881F22E0E
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 23:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4875674B;
	Mon,  8 Jan 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CRG1cjwL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA4A5645E;
	Mon,  8 Jan 2024 23:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCEzJaShu1Z3GI+aSvcgT2qJ6gb2PQIeBvJlM58Q6tg8akC+z4H2TbMh6ytwHKyRQc1xvKvHbZSXxUuTn6UiZAEShTU5alx95t4fzMNKtRt3PemfheqE3A9gYoZlz1yeE+jIWcGRLG5YRCxuuTaF2CjO246S4DAwolFr4toc03+Hea6CyX0qU6LJjYzNRaFXbZiGoBCHlfzVRt+UBFXisVmaL516OpixWgAiTK4slwabCEYfoGNkM9Q4Xqvc7Ono2OrD6Iir/5D3An1PaUtZLVNw//rRTCFxoZHfrU3brTOFGYaLEaZPsDk42A3KGIoUX7tXi3V9VhsbhJep0jHLng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZyWLLs8jbJbR+rLeYXVyLs+FlPBh40GYmb1rYwYC2TE=;
 b=ME1kJ2JoqSY8mfM1mKWUCiVJvBFrGLMnmp6f2lEN655kWLzPvZZB11YMIB032LN5ArbI847Tgd2xPr65Nq77C9Z2c64i+AkBoAYrf8tjfMSKaaErebGyqabtFCCJYnPD1Iq/bUp7COvamHzv987Q/NBZFhA4yicjQYRemF/c2vSz06QxjF7ovBbWDyUMEx+JWInz/3LCTiijfhm3wr9FWMYXgXwSvhFzP5ye2d0MB5DjI1IiHo4lXOtZ5Vv2gFuE0wkBBPraJc/VGuAiLLur6ECEc0zoxtX9MFWJEoop3mi5FeXo/qI8qZdj1riuSNrl4t2ID5bUv0t0eNugLORwlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZyWLLs8jbJbR+rLeYXVyLs+FlPBh40GYmb1rYwYC2TE=;
 b=CRG1cjwLunccynfuPQ9i9VuxCgk3aTCYtzaJrDNqnW6Sfk812PK/107ukSJXz0wXyEdPze5fkbpXpF5TJGHhvNSzgZYBMzts0dxeF3mCMJvTtPHo4telSl/5NYcyBN0iyndATJrD9Uh4cQ5D/Tyb49iwpkxPTDTeFmQdPedTYjM=
Received: from DS0PR17CA0002.namprd17.prod.outlook.com (2603:10b6:8:191::25)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Mon, 8 Jan
 2024 23:54:58 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:8:191:cafe::1e) by DS0PR17CA0002.outlook.office365.com
 (2603:10b6:8:191::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23 via Frontend
 Transport; Mon, 8 Jan 2024 23:54:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7181.13 via Frontend Transport; Mon, 8 Jan 2024 23:54:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 8 Jan
 2024 17:54:57 -0600
Date: Mon, 8 Jan 2024 17:54:39 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, Peter Xu
	<peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, Oliver Upton
	<oliver.upton@linux.dev>, Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Matlack <dmatlack@google.com>, Yan Zhao <yan.y.zhao@intel.com>, Marc
 Zyngier <maz@kernel.org>, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
Message-ID: <20240108235439.ecb5x2eef2mbccby@amd.com>
References: <20231214001753.779022-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231214001753.779022-1-seanjc@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4722cc-b5ad-4077-1d6d-08dc10a53874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UwbO0Vz1cUMhOLRd2k8FZ8BWDSd8qQDkFpScRTRkJ+jJ4HHK08bKleEUR6nZbt0zDdd5JBvtmI0YUYQ85oOQmsLigra86CeCd3jCagYbrtYxfskQjkGEWQHHcZgeDWSsPe7Xu0W3vVyst+RGQeeqWC0CdtAxvvzlgM7zoheHBWyZBuyTlWh2SAyFa7XAeebJuWo0MkPjVXZqrmscGJsCre3My19sZ9ElQ+kt0DPxqOi/kpquMXvpVq7Hu83Y/jAq4frhE2wvTh5HpthYMkE4+Me3OtQ6nM7iOiprKjb0ogZqpNaFdT0s2gCYY4V5FfLjOjmKAoHjBy93JAQFFLSWr92K69IsewImUE48ofaMXN7cIrFf29k78dqSHKTE/J1pV7YngBMuny+F2AGivbOxrhbrRVcSd7GAkjPaF5LXvrpgOxpR7Sxme2LS5u9C/pHQSFNerLKUADps70MYK5JXEY8gwHj7hHYdLfRPem5SpqbQqFlXSPKu4wmGQ2OSVFQ04O7sz7/s1r6eBWBeL6zsN11fg9QHg20u6qWA/S1Hlt5YbwXJ8sMKtzuEuzSdE4/ekWXcLLQppcZwmpJQVjItqeE2R5nzrMnehikk0S1FSyIFpoS/N4/WnbncNQWqVzctHp+ddQP2gOm0426TSZnXTc7nTGURdZ4m+XRQSvascIDSu7C2LT1SIgFKp3AW6gGeEOhZ/B0bNlNR0OqI3jZ3zNWppvgZk5ri7i1o4bEAxWW7+u4r8e6NVTHaPDLytZPvd92OJkcAuil+i1gRBvhBpKIB35kwZB155rg7LiRCVEAcETgNTrq3UytrStFSjKuEFPC6u0/WwFABY7JzHqiI96NR6CRyjuVSVkaWcCQRgQkCkiW+a1ucCtWHkEd6UruU
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230173577357003)(230273577357003)(230922051799003)(186009)(451199024)(82310400011)(64100799003)(1800799012)(40470700004)(46966006)(36840700001)(70206006)(70586007)(47076005)(8936002)(8676002)(1076003)(26005)(478600001)(16526019)(426003)(336012)(2616005)(83380400001)(5930299018)(966005)(316002)(2906002)(6916009)(5660300002)(82740400003)(7416002)(81166007)(41300700001)(4326008)(40480700001)(356005)(86362001)(36860700001)(6666004)(36756003)(54906003)(40460700003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 23:54:58.1612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4722cc-b5ad-4077-1d6d-08dc10a53874
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223

On Wed, Dec 13, 2023 at 04:17:53PM -0800, Sean Christopherson wrote:
> Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> would like your help/input in confirming attendance to ensure we reach critical
> mass.
> 
> If you are on the Cc, please confirm that you are willing and able to attend
> PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> if you simply don't want to attend, I suppose that's a valid answer too. :-)
> 
> If you are not on the Cc but want to ensure that you can be present for a given
> topic, please speak up asap if you have a conflict.  I will do my best to
> accomodate everyone's schedules, and the more warning I get the easier that will
> be.
> 
> Note, the proposed schedule is largely arbitrary, I am not wedded to any
> particular order.  The only known conflict at this time is the guest_memfd()
> post-copy discussion can't land on Jan 10th.
> 
> Thanks!
> 
> 
> 2024.01.03 - Post-copy for guest_memfd()
>     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> 
> 2024.01.10 - Unified uAPI for protected VMs
>     Needs: Paolo, Isaku, Mike R

Hi Sean,

I'll be present for this one. Not sure what the specific agenda is, but
hoping we can cover some of the hooks that were proposed in this RFC
series and are now part of SNP hypervisor v11 patchset:

  https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/

-Mike

> 
> 2024.01.17 - Memtypes for non-coherent MDA
>     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?
> 
> 2024.01.24 - TDP MMU for IOMMU
>     Needs: Paolo, Yan, Jason, ???
> 
> 
> P.S. if you're wondering, what the puck is PUCK?
> 
>   Time:  6am PDT
>   Video: https://meet.google.com/vdb-aeqo-knk
>   Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> 
>   Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
>   Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link
> 
>   https://lore.kernel.org/all/20230512231026.799267-1-seanjc@google.com

