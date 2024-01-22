Return-Path: <kvm+bounces-6571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AB28372B2
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 20:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2EB1C26F05
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 19:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA613F8EE;
	Mon, 22 Jan 2024 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VuewseJL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417D3EA8E;
	Mon, 22 Jan 2024 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952188; cv=fail; b=s3jm/7mPDJ3Uri0pjElKzPQ/KPkcaLXsgSi7GPlIeXJ/nXtdptyo80m/4PJQmqBJ6ZJ16vXaM1xB4jLkLQ2twrPTqyBjCU0o0v48Svtkzmr+RQDSnfu2gSlxKN5wPbpVTlzGazINVEgmZJEww/Vx1ggagUcPVO+vf/arT5T8ZUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952188; c=relaxed/simple;
	bh=EiwLJiONOjICkONn6vC6zd+LFeXkuIinHMZuV4Xz9/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvdYBk+Jicx2f8l/Epv65CfrL9VHigQyVZm3+Aahm+ewgh3usC0IEjF5hu/f4euTBgnWU1GFSv6YY+c8hpHIQzxOcFs7M/jZdD7Y5lLwbfYWN1IdDmYjGitpekptdZgOskueXF45bNVLxK4OwEn4nYFoQD0aOjk1QwIdlVuMxug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VuewseJL; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkZLJbXCrIDNJ+BgRjeylsM4SfKTmRjwf8H45Fff7w5nXK1BPYNws6asRKi/NXLIjMv/WxZMAFTTBVh5r+Q8CLljUdDsJourCuk8ah3eK3bZy4ywzZxkozyC7xPuAlUoo/JIPwHzwEL776ZDTZOXpOqWwAqpf3qDTK9os8zwMCUCqdfzV1dVNkxyJJz38rVFNtPJg26I0tgeQaKp/dvKdohiiLLdNh3F/fDloH3qfGC9px3FbfF0OBTW4wbs947RKsDIzrRaBrqTc6ucms2GXv0RUdiIaISnYHe7hUnv30+5bgKY1qN3ut3xqqBs+ICf/PHW/RadkQzCFgQRYZySZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9J67aKMrNnialZKW5vkCL4VA8MOc58CJ1I61ltEVCCw=;
 b=CIXN9uCfiOLuWgNhmtgKHJZGW21SKpQZ5I7C1KYhLpH8QW7plG3xyfdpZjh9UGmQDGZQ4SuNTuBw1Z+04MJYOm4yqgjPfQkm7alI5letSIK3khSRd03xeqYGupZuL4y8ORyisrAr0x55tA3pamsEYZVauSpuGk5+NmhnPjXBE2euou/6v55A9oQ75NeKNj/UxW8XCsWJ1Xef4v+SYR8tVjActmezUp/2ZJUSGl2ZoplxwD/Cj4ia/iFI2I9XqF9YdCDMocEvZTNJNgzwku7+Lh2z1X7s8iYeBi+6lPh5A+Xk7RKEOZUROCbqMDvJK6SZ8TWASI7j5Ph81cdL6nEa1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9J67aKMrNnialZKW5vkCL4VA8MOc58CJ1I61ltEVCCw=;
 b=VuewseJL6qwwskg0YUIun7Ze81kEoIiBv189XpIOyaw4S2lU44l+9GbjS8G3kQB2xdwfqrxGHMPFDNodh/Yv2K8Nmxe2Np6RsFTsjUSTq8XeLzu2HoMQAdKfyIcE144q0M/5L7ji2mmSom4b8PSghs1K14Mai58pm5zwLDYalDI=
Received: from DS7PR06CA0006.namprd06.prod.outlook.com (2603:10b6:8:2a::7) by
 SJ1PR12MB6148.namprd12.prod.outlook.com (2603:10b6:a03:459::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7202.31; Mon, 22 Jan 2024 19:36:23 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:8:2a:cafe::b2) by DS7PR06CA0006.outlook.office365.com
 (2603:10b6:8:2a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32 via Frontend
 Transport; Mon, 22 Jan 2024 19:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7202.16 via Frontend Transport; Mon, 22 Jan 2024 19:36:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 22 Jan
 2024 13:36:22 -0600
Date: Mon, 22 Jan 2024 13:36:05 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>, Yan Zhao <yan.y.zhao@intel.com>, David Matlack
	<dmatlack@google.com>, <pbonzini@redhat.com>, <isaku.yamahata@intel.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.01.17 - TDP MMU for IOMMU
Message-ID: <20240122193605.7riyd7q5rs2i4xez@amd.com>
References: <20240117010644.1534332-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240117010644.1534332-1-seanjc@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|SJ1PR12MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c5c9863-af1e-4a13-f14e-08dc1b816aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g0SzN631iC5F1hX9DTd6JfqacufXRkD/bSrtiY/t0T1anYkUbfOXQbVxtCGCe9ZarTt/tZkWSYt3M530XD8LrVlCtoe0Yofrl8VtnpjKG1RYOAW/cVb5dLXD3SmiRVf+1g6dO4NNtbA4C9VhOsQy5Qu1UfMjPMbX8fM38asMLx6pkepcjd5YJ70A2wXVh3CownzUJ8+owebi5GqfCVpB1MLrLngVVbw+85pXNwyDa7qYYlfyxmeSM8a8hTNdEEsr6sUeE1iSSv3w24Hjg9URhQRdcyToBGp7Dm7GtFdZszmAgr+Av7gN95omysM1xXu4sJ5JN8wVbk3a0ytKWH+gZ0Ybmos1R+7D4/p+IBTCPR0alic0tH1YPEy8Hszk405uH5pO3sG1pASUVfIicA+8uI/YijG8oOwQ3LCP8NThChFMPNmsC3TabAatjyn4Xy0K82QwyxT5mZqJjelp/0PK7IU+ea060ze+xyjK64qfdwrkrzEBijx3/EL8DLjaqnU+nqlDbI1rLNCVYhGjSqrLLjsOBxyQVpmYtL4PDRP1Ra6p9pgKPdlUiua5VRAwZ+FclcaT1H6/ZIZhKX3qCCNdUR28dHvbpJ4vMXbQ/2EKO7/Aw/lXrexGcBnZMbkMlVVt2veGIIIE/OE/Si5b62+5e5+Kc+MV3nypqpXcPaNxsUvaMRzJrmxRTnDcNiNv3d1cKjEqJu7CxU/vU0YGBo0gvdkQP9QlTzXvKYOfBFuaUSlVMchK0epbjb7scA7Cgqoa90kR6RUPvInPfusGQ3+BW9vwc/BoMHMT518VI1hO8/H47Wdy0Djl5mBINIBJBDsyAJqW3rfZ26Bj/pRrRt1sYA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(186009)(64100799003)(1800799012)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(5930299018)(26005)(1076003)(36860700001)(66574015)(2616005)(426003)(336012)(16526019)(81166007)(356005)(36756003)(82740400003)(83380400001)(86362001)(6666004)(8676002)(4326008)(5660300002)(8936002)(2906002)(47076005)(966005)(316002)(41300700001)(44832011)(478600001)(6916009)(70586007)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2024 19:36:23.2811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5c9863-af1e-4a13-f14e-08dc1b816aac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6148

On Tue, Jan 16, 2024 at 05:06:44PM -0800, Sean Christopherson wrote:
> Tomorrow's PUCK topic is utilizing KVM's TDP MMU for IOMMU page tables.
> 
> FYI, I am currently without my normal internet (hooray tethering), and we're
> supposed to get a healthy dose of freezing rain tonight, i.e. I might lose power
> too.  I expect to be able to join even if that happens, but I apologize in
> advance if I end up being a no-show.
> 
> https://lore.kernel.org/all/20231202091211.13376-1-yan.y.zhao@intel.com
> 
> Time:     6am PDT
> Video:    https://meet.google.com/vdb-aeqo-knk
> Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656
> 
> Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
> Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link
> 
> Future Schedule:
> January 24th - Memtypes for non-coherent DMA
> January 31st - Available!

Hi Sean,

I'd like to propose the following topic for the next available slot:

  "Finalizing internal guest_memfd APIs needed for SNP (TDX?) upstreaming"

There's 2 existing interfaces, gmem_prepare, gmem_invalidate, that are
needed by the current SNP patches, and there's some additional background
about the design decisions here:

  https://lore.kernel.org/kvm/20231016115028.996656-1-michael.roth@amd.com/

There's also another gmem interface that you recently proposed for handling
setting up the initial launch image of SNP guests here that seems like it
would have a lot of potential overlap with how gmem_prepare is implemented:

  https://lore.kernel.org/lkml/ZZ67oJwzAsSvui5U@google.com/

I'd like to try to get some clarity on what these should look like in order
to be considered acceptable for upstreaming of SNP, and potentially any
considerations that need to be taken into account for other users like
TDX/pKVM/etc.

Thanks,

Mike

> February     - Available!
> 

