Return-Path: <kvm+bounces-23233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADBC947E56
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 17:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBBDA1F24859
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 15:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9F01591F0;
	Mon,  5 Aug 2024 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lw6ZrP1V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA702E3E5;
	Mon,  5 Aug 2024 15:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722872390; cv=fail; b=o0Mv5H0kIxolCqfLWDfb1rRjcZGEt3mdl6jDUcbcE4m6RKaPUR27tDp/15iPmk/kbFHxSxb/vPvfcMIdrMm+X7Th+4h7VvXIjapKxkgso2AosMDd4IGpBLl+mfQysC8X3Kdg5kkaLdKWhMcw75SXGA/LswB5DJ38lcN0mXrYJmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722872390; c=relaxed/simple;
	bh=M1BM7kmA4LjL7nwiuDN+ZsnnipnM8LVpNoMAUS3xWsI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJ5ARLeU7YNY1VrEiBRoprqxqI13rtenWfvcLlH6TSj33OGt+/5b8qeNkbqfZ+NFeRs5i80IzwjssU++DgS54QIpa1XlpUNTW/dO/soyy2lp7sIqB45QWP9ycey+MUotB+OkhJ/ansi/NbOr18xR6vCVxpdV4WqEGzs44PT9oZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lw6ZrP1V; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOgjCUx9kNmIEBOPatZFxAEipxzyUGygaVW6OMr7r/lw0duvyt43YeUsq2aPXjxq9ZiucnXIhEPHFZH3OMLsboPfQvqyWlFOwe7Y4KQtsifV+lAItQUrlou78Gk3I76btazsUXWUdrEf/v6UNWQPWJt/J3KTCGa347RoTKGL4n7BJA20H/KzCSDrfOyd9Yy1gu2UQFADtuEvJZLbo/cb+QUXWUZbWQWEXWlOXwvRpdX0lKe9Ywci/Jw7cmGt/W9hFZ/C/TP8XIX21FmykPhe9VKRBesZTM7rC5LjER/SSOlzgF6ukzpHfamHwy0VZDLiHXk76iYuY9kzrlV5JhcwTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/07jbdRsthOZuxzj39Um7z8A8G/j6dN2IFrdAcDWvXY=;
 b=YJJHbgjxB6jA6AFX0EO/a6ffW7n3p7clyajzECz/E0pWWh2FX7V4mumj9HZOrmLbsCi8WJDJPkeNJqrkNygpAKrtEHeLIOgWGuOeBOoom5M98CrKx7gC9orP9MRqwfTmrrTJaycKB1o33lpr4KU11JkGfsjY/Lzo9p8RWhFsOfCiswqzMNyFTHTEtqM+A7Vj2nqf8Ci3uJslZowugsYdIIqp8TW1+TFqu3o+TkNq2RYMfyJhNius4zxuKQSWIlAgyPBHrcDTDoo4kU7FAQBjPv/2VykeYUXWKkc20JdhQh88MjOeHimsZ2S9ka97gAdFoX1yRCtYAe6lie0iD7WrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/07jbdRsthOZuxzj39Um7z8A8G/j6dN2IFrdAcDWvXY=;
 b=lw6ZrP1VPQ5dMoRjtewOya/o7++w2ysVC895uqOjA6wzwt2v+oCdN0Cc2uHHA2i9hYEryirZVJXu+qj43E3ufBIujG0ZayTMSfDZg72FqVV7mpPLSGd3EWobQoDDDff79vwamSSRE8x3zUM2gUQ2LTC3rQ+6kclZL32irc7o4LQ=
Received: from BN9PR03CA0757.namprd03.prod.outlook.com (2603:10b6:408:13a::12)
 by IA1PR12MB8191.namprd12.prod.outlook.com (2603:10b6:208:3f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 5 Aug
 2024 15:39:44 +0000
Received: from BN1PEPF00006001.namprd05.prod.outlook.com
 (2603:10b6:408:13a:cafe::f7) by BN9PR03CA0757.outlook.office365.com
 (2603:10b6:408:13a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27 via Frontend
 Transport; Mon, 5 Aug 2024 15:39:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006001.mail.protection.outlook.com (10.167.243.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Mon, 5 Aug 2024 15:39:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 5 Aug
 2024 10:39:43 -0500
Date: Mon, 5 Aug 2024 10:39:27 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: allow KVM_SEV_GET_ATTESTATION_REPORT for SNP
 guests
Message-ID: <20240805153927.fxqyxoritwguquyd@amd.com>
References: <20240801235333.357075-1-pbonzini@redhat.com>
 <20240802203608.3sds2wauu37cgebw@amd.com>
 <CABgObfbhB9AaoEONr+zPuG4YBZr2nd-BDA4Sqou-NKe-Y2Ch+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbhB9AaoEONr+zPuG4YBZr2nd-BDA4Sqou-NKe-Y2Ch+Q@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006001:EE_|IA1PR12MB8191:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cc671ae-815b-4757-8a3a-08dcb564d403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmR6Kzk1VmlMK0VsenVoMDdVVkYxVVZHV3czZnY1VXVPOGFhYjIrM2RGREJj?=
 =?utf-8?B?SEkxNWtKOEtyaUZNbkU0Z1lnUndKeUdpL2o3eHFqbmMvL1ZFcFhCN3ZuK2VW?=
 =?utf-8?B?Nk9Jd2dCOXViYVp5UHNvNmIvSEp1ckFzeFl0WnJJb1lyajdBZVBXNWwyZDNi?=
 =?utf-8?B?UVg3L0xkUWN2TWlhTDNGdk4raWc1VS9DZWk0S0ZtQVY0cWUwVWlrVWd3NnBs?=
 =?utf-8?B?S3BNdmZMb1BvNnB2K2M2clJLdW8xWDBzc2REQm1hbWZvZzlMOVJkcml4b0Ry?=
 =?utf-8?B?U2d2ekJMUDNnS2FDZDZhYllKdndHZUF3blBUNHUwSzh2dHp6UkNzVGk5bjFN?=
 =?utf-8?B?aGcreHNyRE93MEkzWHRsTHgxSFFoRlUyL3R1NjZjQXEzTDhtNEZndlpXRitL?=
 =?utf-8?B?Rll0YWZoenhuR09LZ243dENMUUYyK3hheURraGJjdG5zcjBRT1NSM3Y3bjVB?=
 =?utf-8?B?dUlFeU5VOXBycEVqd0Z3SlpxTno4eFJHSUVxSmVkUlI1RXBhNFhiNTJFRnZN?=
 =?utf-8?B?MUcvLzJ5eUZtUzhUd0gzY1I0bjdzMDkzckJZMngza2FwVFJCNC9Sa0JGSUlU?=
 =?utf-8?B?ZzRsN2lwRDJwZzkvOVpnUytJb1U2dFMzazhHMmR5UEZRUVpwcmxDU3N4SlRK?=
 =?utf-8?B?emROM3BPSjErclA3YitaQjJPNElqZGFOb2p6M1BKZXY1VUFrZVI5bVhDZXFB?=
 =?utf-8?B?RHBTWU5lQWx5N2tzK0F0TEUreU0rb1NOSnYxZGRoSzhZM2tlU1pXa3RJUXU5?=
 =?utf-8?B?amZ2d3dENlE2UkpJb3pSWmVVY3VDZGg0RkZBVE5hVlZlQVlaTEx1QzR3bWFM?=
 =?utf-8?B?ZGhXK1pNRmtRZUNWMTAyVEpHdW10WGd5QzZwL2JDaVd4bkN2YnlKc2hXU3M4?=
 =?utf-8?B?RXpnZUtFQ2laMDYyYnVyRlVrUlc3WFlFRVg4c0tKci9maWJCd1RQRzhhU3lX?=
 =?utf-8?B?ODlhZncrdU51ZGxEd1V2UU5RQThDSWI4Z2lkN0ZYb2Vzc2NwQTEzNFl2OGFN?=
 =?utf-8?B?aDkvQ2gyY2RvSUV2K3VwaldraUNsV1hGSm1qMUFLaWxqZ2Ribk45b2NGYnIv?=
 =?utf-8?B?SFpuek12cGIrQUNYU2dtWlpDdXp0NCsvSTYzd3MxUjRpeDc5N0FNTWEvM3l2?=
 =?utf-8?B?a2ZsR1pxV29LeGIrVVpaK0ZjLzQxUFRwRmRsenpiM2hzcEJXczRZS2xIcEZ5?=
 =?utf-8?B?V1k4RklnejBWV0gwL1RwT1NYTXd1blB5UUs2ZGwzT1kraHlCUUkxeVhZNGkz?=
 =?utf-8?B?SnIrSUpMTnJwelU5VFFSRGJ4K0RBZnRzb3I5ZkpvbTVvVE9IUTVUN3dOSXN4?=
 =?utf-8?B?MUpJak5WTmFHTEV3cFE3cGMxditXV2hWc0NWaUFvZ3BvMSthVDhnS2drS3VO?=
 =?utf-8?B?VWxuMGtDUkUwbUNELzc2b1I5MDlxRnRaeTBBb2tZcTNiaTl2bzlBYTkvVkYz?=
 =?utf-8?B?Y09DeFl1SHZxclNFcHowekkrT0QyUzdiZXlEaFNTSnZlM2xRNHFmWDJLTmZB?=
 =?utf-8?B?b1dYZFcxTjlaVmlBVG1ZbXd0WnZlUzBBVjNqdnVCNnhHMGNieVBIR1djbjgw?=
 =?utf-8?B?S0tlVUM4WS9GRlQ2ckF5L3R3MzI5dTQ0OWt0WnQxMm4wV3cxZG1McC9jRzda?=
 =?utf-8?B?NUowOHBhbmxlYlhDQ2VVMGJtZytsTitpQU5JRThKRUkvSkkzVmt4NGoyM3NR?=
 =?utf-8?B?eWNiYzRiWnNZYmlFbzVIV2Z2VEhMNUh1RkdMazkyMi8yVVVmc1JlRG04RUF2?=
 =?utf-8?B?TzNaSko1K1lHb1R6TXJ5K0MzTjFLUmxQLzRXMHNSTStRcHR1NTI1aVpmdi9z?=
 =?utf-8?B?WnZCOFRBUkdsdEZYOU1iQnRsT1FteGt5OGQ3UVVTdWJmcmNtRDF6VWY4aTVi?=
 =?utf-8?B?aVQzTi9aR0ZCNzZnSzlyS0NJNkFQYWkwTFhNTVJ0eXBpSXFCR0RRU0lyb1pn?=
 =?utf-8?Q?Asw9+x8zMRaePetN0vNspn89ad7hv8Kq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 15:39:43.7501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc671ae-815b-4757-8a3a-08dcb564d403
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006001.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8191

On Mon, Aug 05, 2024 at 04:32:16PM +0200, Paolo Bonzini wrote:
> On Fri, Aug 2, 2024 at 10:41 PM Michael Roth <michael.roth@amd.com> wrote:
> > On Fri, Aug 02, 2024 at 01:53:33AM +0200, Paolo Bonzini wrote:
> > > Even though KVM_SEV_GET_ATTESTATION_REPORT is not one of the commands
> > > that were added for SEV-SNP guests, it can be applied to them.  Filtering
> >
> > Is the command actually succeeding for an SNP-enabled guest? When I
> > test this, I get a fw_err code of 1 (INVALID_PLATFORM_STATE), and
> > after speaking with some firmware folks that seems to be the expected
> > behavior.
> 
> So is there no equivalent of QEMU's query-sev-attestation-report for
> SEV-SNP?

No, but all the attestation support is via the guest request interface.

It would be possible for KVM to provide the measurement by logging the
digest values

> (And is there any user of query-sev-attestation-report for
> non-SNP?)

No, this would have always returned error, either via KVM, or via
firmware failure.

But maybe QEMU should do the error handling a bit more directly in this
case. I can send a patch for QEMU 9.1 that results in an error when
issued for an SNP guest.

-Mike

> 
> Paolo
> 
> > There's also some other things that aren't going to work as expected,
> > e.g. KVM uses sev->handle as the handle for the guest it wants to fetch
> > the attestation report for, but in the case of SNP, sev->handle will be
> > uninitialized since that only happens via KVM_SEV_LAUNCH_UPDATE_DATA,
> > which isn't usable for SNP guests.
> >
> > As I understand it, the only firmware commands allowed for SNP guests are
> > those listed in the SNP firmware ABI, section "Command Reference", and
> > in any instance where a legacy command from the legacy SEV/SEV-ES firmware
> > ABI is also applicable for SNP, the legacy command will be defined again
> > in the "Command Reference" section of the SNP spec.  E.g., GET_ID is
> > specifically documented in both the SEV/SEV-ES firmware ABI, as well as
> > the SNP firmware ABI spec. But ATTESTATION (and the similar LAUNCH_MEASURE)
> > are only mentioned in the SEV/SEV-ES Firmware ABI, so I think it makes
> > sense that KVM also only allows them for SEV/SEV-ES.
> 

