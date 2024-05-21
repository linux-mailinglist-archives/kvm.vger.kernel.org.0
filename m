Return-Path: <kvm+bounces-17820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8EB8CA60B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 04:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98737B21C87
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9017FC11;
	Tue, 21 May 2024 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uBik8sJM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613CC18040;
	Tue, 21 May 2024 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716256894; cv=fail; b=rvh/7CqryaZK9A7z8S7v0YQ+WwGuL5TqWGPuBPigdROF+GG97gmnZ6t9NnErIix5W8rlR8GJ0ftJmeQAZ6QJcngdxLrcfY6vlpWlVs/VrJUqRnrQqeq1qV2YzO+iu8InWrntjlTEoH4WkpD8g0MR6Oxe6VwaorfPoQXKmODqP0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716256894; c=relaxed/simple;
	bh=p86Lo+K8z/srQPuxLwdG3Hoh8cSK5IXA9J7oFpNKNvE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rvlenh3tkwD70bv1Q6PiG5XxZrKdoXfE2OybcoSdfXcgfYmVIteis4l4wFGqgy3rlmLTaUD3kDeUzGm4vV2aY2X7poRTeja0ebAN88PSb0cqsSLD6wR6E2NKmhjrs3DQV5Rf98FWBVbN3Ta96r3eO5qayhbbv2LMYvm4FUnZwso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uBik8sJM; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0qUC6yKHcV0TfC+4TiDOniOmJVcd/v31GsNrkitc9VmtRCQWSWyuMoBb5YipM5BO949iX9RBM5XtCGOtUqGiEHqrllaNLtnF8rzazrsDeGgcPyABs6Ba6SkfHhop3DKHvEAeYswjxE/eLOPhkDCIljbhBVRWGVEshcQhHeBy8JCdF4+poGGLNIStuWV6oqxg0EgLZ00UyjNdYHWJLz9YsIkP7u9SN2nrMM1IQJx5tqSXxCzvtHdUxznhTHOUM5NgfVkA6mNgfpMhhYTjYI+eRtjWiY2TO0UvgY8FcZAsojKj+kT1myJ7IGBw2M5rBzdCYtaAlKITIvlij75mTnXtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuFcU2GymcFExsmzBzESm3AmK/ZW646xmluJUyuF248=;
 b=m11uCq/fsJFeMzqe4rThGU1tYEEz46Je3aVFxHhFulIaVeYmB+HAuoYJkFrHHMhSve/vd/kq0+2bDPFo0VMJplmHDWEHiDu0TPnbuLw5Im1LqwEVWNZFEReen0fRd5ETj/fdLIhhacAshSFsXiTSGYMLjVZL9W0Pi8Pk3+WZ10Sh9yjEuR4qVWd1BXmGptrT9lN+E/AdpkxPNlSm0H3c2qrJbugvAYJcbCwi3Dl2XnblLiZdQpHzKhkmhMZX15kUqHwZML9wcwEM4D51tj9Q7n9CrLn+vShhVJuPCl0vObu3ip65G/PlLpoPBit2LVnhHxTZhmSqhmeDe5T+4Qj9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuFcU2GymcFExsmzBzESm3AmK/ZW646xmluJUyuF248=;
 b=uBik8sJMIENiO1D9Jatw6VdZEQEsObBN1VLhtjPmap+Afg4kP6BRKob8HYpUUuQR9Ig4PzMAVVRaYdXvjgkLFZWQ0weVFKXRjGFzOWvk0DMkm6ROGijicFHDilScQtqS0zRxFUgWR6Qyyuh5XwqD0fMN9xGJoHFVsXmKPUu2myI=
Received: from BYAPR02CA0052.namprd02.prod.outlook.com (2603:10b6:a03:54::29)
 by DS7PR12MB5720.namprd12.prod.outlook.com (2603:10b6:8:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 02:01:30 +0000
Received: from SJ1PEPF00001CE4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::31) by BYAPR02CA0052.outlook.office365.com
 (2603:10b6:a03:54::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.37 via Frontend
 Transport; Tue, 21 May 2024 02:01:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE4.mail.protection.outlook.com (10.167.242.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Tue, 21 May 2024 02:01:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 20 May
 2024 21:01:27 -0500
Date: Mon, 20 May 2024 21:00:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <mdroth@utexas.edu>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: SEV: Fix guest memory leak when handling guest
 requests
Message-ID: <20240521020049.tm3pa2jdi2pg4agh@amd.com>
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
 <20240518150457.1033295-1-michael.roth@amd.com>
 <ZktbBRLXeOp9X6aH@google.com>
 <iqzde53xfkcpqpjvrpyetklutgqpepy3pzykwpdwyjdo7rth3m@taolptudb62c>
 <ZkvddEe3lnAlYQbQ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkvddEe3lnAlYQbQ@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE4:EE_|DS7PR12MB5720:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e9a6f1-9d66-4a2b-6020-08dc7939ee6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kg1Fff8hO7TuFBA4CXpGkjCwJiLHxJt6rVOhPTkGTcm1eTtHwIG2z+A+vfWk?=
 =?us-ascii?Q?rFSdJqib80qq8NOpEB7Y+x5CBTDAvGDnwO27zRcCg/s5Zsi4Yocn9mNbxc1D?=
 =?us-ascii?Q?CRpDIUhu2+4+9caNElQyhXOJv0YHsOMdK4hXu0xPGi8YyBLTMpRHFMxOhDxS?=
 =?us-ascii?Q?hitJ3UuRYKjFXf7MaQinMHYvmKJKNzJpYzUmZI8gTP/dog1PB+tIUACL2ibl?=
 =?us-ascii?Q?jSgwaKcP8pILLYUckmUBzMV9zpL5+XGkpNNwlcITX52LavVxNWyR4Qhnco4O?=
 =?us-ascii?Q?nng3dK9wyw63R0i4ZfVJmKirTtrik+Uy2LNrjAoMAQw2p2BOUpQRxfBJ49ez?=
 =?us-ascii?Q?gYBUSRJ+ll10FqWerVV9BXwRJHlZWB1hem66OhmYmpMcM8M96QygHXAB0iaR?=
 =?us-ascii?Q?AVHUawuKAS0lPUybUiOs7YBl2NzyLmrc/EAz0TrW/C2jjpJqFwTAggU+LmB/?=
 =?us-ascii?Q?Um+/2aguK9/E474/izuB8oSQI4TPfzvkmR6uRfjdhmNF2bsjrJd3tbYeFHZu?=
 =?us-ascii?Q?aX0YbfICOalu7JjWndGcBy5hxAZLawXsHHViE5Mwna438Xj5+TNSdPgf6VNx?=
 =?us-ascii?Q?b3Xi0g62Cepyv/Z5KbDrpDNOzeojRCQC5P0Ka6l7CbruwgT5u+hrlp2+DxtN?=
 =?us-ascii?Q?F+EG6Bm8fM/pi2U+ANQKRcN/xBsfu+MfYKY+RERD1jpxBg2TLikHF6+Dvkf8?=
 =?us-ascii?Q?nPxLCWzAtoyJ3dkh6nK5Be8wShL7iY9tmTQ3/CMVZzddDOA0b/VcigJDFobP?=
 =?us-ascii?Q?AdckThhvF9RyTDs2hHSZEMspnkCt9+qJbTI1c10/+yl5GZw04S35oxpw4Ss4?=
 =?us-ascii?Q?CgQh1ppZLdNEDjAFl3tL6p5xdSRh4UBBFnfPYd5iTO7W0GSw/pe67p1vKrWM?=
 =?us-ascii?Q?Ap8I7ztP8UTLp5ZKA9p3o5gD0glJB9AeHiDy2yrllgIrizqVX5KBeXJaXNKy?=
 =?us-ascii?Q?AkaUk2huQtCpPtkwCXDvYbGpN2LqUY0NrF4m46uz1PA4WX0khXmhsuuhABnP?=
 =?us-ascii?Q?GrfdtelqrUVD/3BDhDYWEfapgAanRny7zCHewHZphEAgebElDL75L4uETCkK?=
 =?us-ascii?Q?rfJ7FKl6ULe9foxNuSWMH/TKpa7CotulaWdSTF9SNk/PVkEORJ/bUa2b+I6D?=
 =?us-ascii?Q?kOlupCCc1xGlU5sj301GF3IpRG8PSVbWgo9r+2KdAnFzkQ0ys9CTNJARH8JS?=
 =?us-ascii?Q?1e/vR8uvkigwrNi3Nh19mqzSt9y9P7Bg4Eemf70E+4ghJZsYwUNZOkwQ9siU?=
 =?us-ascii?Q?Rq8ZPjHSehj/W+VGtrd2VHTxUWUnD/e6c4sJuwZ2GKuZHkEm2ETWMz/nR0uk?=
 =?us-ascii?Q?5v996vJHt7yRsopvTiDTGINf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 02:01:29.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e9a6f1-9d66-4a2b-6020-08dc7939ee6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5720

On Mon, May 20, 2024 at 04:32:04PM -0700, Sean Christopherson wrote:
> On Mon, May 20, 2024, Michael Roth wrote:
> > On Mon, May 20, 2024 at 07:17:13AM -0700, Sean Christopherson wrote:
> > > On Sat, May 18, 2024, Michael Roth wrote:
> > > > Before forwarding guest requests to firmware, KVM takes a reference on
> > > > the 2 pages the guest uses for its request/response buffers. Make sure
> > > > to release these when cleaning up after the request is completed.
> > > > 
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > ---
> > > 
> > > ...
> > > 
> > > > @@ -3970,14 +3980,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa
> > > >  		return ret;
> > > >  
> > > >  	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
> > > > -	if (ret)
> > > > -		return ret;
> > > >  
> > > > -	ret = snp_cleanup_guest_buf(&data);
> > > > -	if (ret)
> > > > -		return ret;
> > > > +	if (snp_cleanup_guest_buf(&data))
> > > > +		return -EINVAL;
> > > 
> > > EINVAL feels wrong.  The input was completely valid.  Also, forwarding the error
> > 
> > Yah, EIO seems more suitable here.
> > 
> > > to the guest doesn't seem like the right thing to do if KVM can't reclaim the
> > > response PFN.  Shouldn't that be fatal to the VM?
> > 
> > The thinking here is that pretty much all guest request failures will be
> > fatal to the guest being able to continue. At least, that's definitely
> > true for attestation. So reporting the error to the guest would allow that
> > failure to be propagated along by handling in the guest where it would
> > presumably be reported a little more clearly to the guest owner, at
> > which point the guest would most likely terminate itself anyway.
> 
> But failure to convert a pfn back to shared is a _host_ issue, not a guest issue.
> E.g. it most likely indicates a bug in the host software stack, or perhaps a bad
> CPU or firmware bug.

No disagreement there, I think it's more correct to not propagate
any errors resulting from reclaim failure. Was just explaining why the
original code had propensity for propagating errors to guest, and why it
still needs to be done for firmware errors.

> 
> > But there is a possibility that the guest will attempt access the response
> > PFN before/during that reporting and spin on an #NPF instead though. So
> > maybe the safer more repeatable approach is to handle the error directly
> > from KVM and propagate it to userspace.
> 
> I was thinking more along the lines of KVM marking the VM as dead/bugged.  

In practice userspace will get an unhandled exit and kill the vcpu/guest,
but we could additionally flag the guest as dead. Is there a existing
mechanism for this?

> 
> > But the GHCB spec does require that the firmware response code for
> > SNP_GUEST_REQUEST be passed directly to the guest via lower 32-bits of
> > SW_EXITINFO2, so we'd still want handling to pass that error on to the
> > guest, so I made some changes to retain that behavior.
> 
> If and only the hypervisor completes the event.
> 
>   The hypervisor must save the SNP_GUEST_REQUEST return code in the lower 32-bits
>   of the SW_EXITINFO2 field before completing the Guest Request NAE event.
> 
> If KVM terminates the VM, there's obviously no need to fill SW_EXITINFO2.

Yah, the v2 patch will only propagate the firmware error if reclaim was
successful.

> 
> Side topic, is there a plan to ratelimit Guest Requests?
> 
>   To avoid the possibility of a guest creating a denial of service attack against
>   the SNP firmware, it is recommended that some form of rate limiting be implemented
>   should it be detected that a high number of Guest Request NAE events are being
>   issued.

The guest side is upstream, and Dionna submitted HV patches last year. I think
these are the latest ones:

  https://www.spinics.net/lists/kvm/msg301438.html

I think it probably makes sense to try to get the throttling support in
for 6.11

-Mike

