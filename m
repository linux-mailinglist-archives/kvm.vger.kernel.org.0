Return-Path: <kvm+bounces-11868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7DB987C696
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89B17283616
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7168212E67;
	Thu, 14 Mar 2024 23:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dubo+MGr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878D211185;
	Thu, 14 Mar 2024 23:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710460154; cv=fail; b=kmDGbtI0D0ZtD/ow2aWWv6ywkIHDtFGlgAKgBDyPC9nOXjUugJp9uT8SenTOhMANveTYMmxxnF06u36PEaJ6R7oEFhGBkxKLTs6CI0h3wRaL19SrMhnMSsxRyTj1WCZswLsQWTTjLGARKNKkUGBCX3E3euocVlDS9HyXg0kODcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710460154; c=relaxed/simple;
	bh=MT3pDohdMywv4yu9/72JDMMO1S0PM+5unJMyKE2+AJo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJjvX1DX5db1qCeIclK7gb22xTFltICJ18SXTiZEndROu6zCqvisrYuguaZKQkwxcKZVCZlY+geOMMzK+NVSz326jEUDmKcs+jOvWXtd/id64zjm7JmM+oVuaH/J48rY/GtuppFGwXnWgWkfw0tId1gkwEa11+LvnJOmXr3gi2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dubo+MGr; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FN787zg8VI91svvjN+ouZYjQDeeBYSZjl/itBc+Yc6EhbfgX8twViO+o3wdqrYyXpx7iZ/ZjK6mw65dnxT6jdB0R4qN+YkXc9c/62vcN+/xs6+dky+SAxnKZZfLjPrcBeP1M/BlG5dkOkwGoHB/o053MJbtVayu/tpRF7tWnhkM33IjyAYwYr1TQpfEtBXu9wvz7U2giH6yxmeWtmEc6jSV0oDGoRv4Db3MtaG5FL6wVrk7z1WjVnI4YRgw6VvnJPv+7xdb1266hcqQquYDu4UkREjXUllsDlvz/QLbJOS/iI3ERX/dUeAv5Opit4eEkXaukldklnugq7fCHcrNIAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnqdK+dDPMl5pZovYRFPQUAOVtPmrPUnnNccN4wfdX0=;
 b=HYMqftf7XDd3TngX5Y+PpTPeQS9gf/qXhQS1V8/Ij6YYL0scztRaFyoQWhLQ3DWK6IZvKIzZVausb+QMWSkehdT7Ce1YoK/33D3g6HMF/qhMY7iIwLGwXVXgxm3EdOWObQP9kCzhApqG+Df6uuQVIQr1i97/KdWarq7psLonlQW6px9ZjPuRHk5joTMepU+OKaUPEdaQ3fBOelFXmCosz1ah7bd1Q/zzrvhK8oFVzZuBsOA8KivW4c7j+7VHWj1qXKMe3eGGnl/x9om2/BMj6+VWX/gxOz3ITrAzuDT25l8FBIY0cYQKUcDNLbHCvoCitR4WQ8L9zAVnHYH3nC2OLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnqdK+dDPMl5pZovYRFPQUAOVtPmrPUnnNccN4wfdX0=;
 b=Dubo+MGr+gFMVdoI2qylZfPsoCRGgFvyTVDkG3PGBruM0gEFCPQi7Vmuslzb9Wn2kCEeW73xdZAQ0ce31zI96S/M+bfjs3UmDS640Jbg888WTJyvamjRVQKcBw0zilhHrctqLc9rjv0bJhyc0tJCA5ffFMfnrBPKqMVSlvXkvak=
Received: from SJ0PR03CA0242.namprd03.prod.outlook.com (2603:10b6:a03:3a0::7)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Thu, 14 Mar
 2024 23:49:09 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::fe) by SJ0PR03CA0242.outlook.office365.com
 (2603:10b6:a03:3a0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21 via Frontend
 Transport; Thu, 14 Mar 2024 23:49:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Thu, 14 Mar 2024 23:49:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 14 Mar
 2024 18:49:08 -0500
Date: Thu, 14 Mar 2024 18:48:50 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <aik@amd.com>, <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Message-ID: <20240314234850.js4gvwv7wh43v3y5@amd.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com>
 <20240314220923.htmb4qix4ct5m5om@amd.com>
 <ZfOAm8HtAaazpc5O@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZfOAm8HtAaazpc5O@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|MW6PR12MB8898:EE_
X-MS-Office365-Filtering-Correlation-Id: a5cc90ab-e396-4c0f-88c3-08dc44815795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XNjSQ2C6CbYI3CPtbDaJTNKF8QHOUMbx6qZk5t2ZJJASJMp6knzHh6qd/vqpdi8FgSBmg2001YmqErcsNQniZOMKtfxmL7TG6m1nJm3mPzBm5NNlAzHsDe6uw2wVhw4rt+eIsWpUgsvBMgJVkCt4foBpKECvmyMqh8jTSzHOQ1B1XueUz1ZoF9gRGVgsEXG3PN/9ldWBQuf5XZ7zrUxRywlTqoCmE+RyNhfvcPftwxawjdZ0gcL3IPWRIN2OKt32RKSUlzjmlUf1FITkF8WUfwTAdcsI/6uo1t0P7JkJuD/eRpRc6T1LNcPXTtQK25trkKKQa0G5hL5sOu6//2nOKCX/dAWclQC73A5sLZgXqxPUx1eYKxQj4AqmVzZl/HfhmSNTHfAUsZa/Xv4RDRUgYG5qfLy6WCtYz4QsQu+rWRs3Nua3a8Y/NwhjSK9jHVENN1ifqnJVdFrKyuKefpnoSKNLD73kuNboqs/SOn3Fqt29aZlUJaPfgcS5UcLObQKN+Uzs3I6Yh8erTODs6FjNMpT/8M/c5QjtOrzOnrwmjocsJpgv6FO1cuwDwY/YK62E/oxUza3tOut41YYjTUXXt4WayHuco7RaJhWsRsapjmwWqb6Ka7cH4fmsM/ZKPommvUwnKikyt35ZAt8RwnBj5j8hiGaw3s/Ah+nP+IozTPR9YD0ix/60ipRYoH2CkkqVyt5++qs7Xhn9FrCBmzTnKnOwouae6k/GruBXgxszM46TH57uZCIw2tpn2ZPipVGC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 23:49:08.9249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5cc90ab-e396-4c0f-88c3-08dc44815795
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898

On Thu, Mar 14, 2024 at 03:56:27PM -0700, Sean Christopherson wrote:
> On Thu, Mar 14, 2024, Michael Roth wrote:
> > On Wed, Mar 13, 2024 at 09:49:52PM -0500, Michael Roth wrote:
> > > I've been trying to get SNP running on top of these patches and hit and
> > > issue with these due to fpstate_set_confidential() being done during
> > > svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
> > > SNP_LAUNCH_FINISH it errors out. I think the same would happen with
> > > SEV-ES as well.
> > > 
> > > Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
> > > site as part of these patches?
> > 
> > Talked to Tom a bit about this and that might not make much sense unless
> > we actually want to add some code to sync that FPU state into the VMSA
> > prior to encryption/measurement. Otherwise, it might as well be set to
> > confidential as soon as vCPU is created.
> > 
> > And if userspace wants to write FPU register state that will not actually
> > become part of the guest state, it probably does make sense to return an
> > error for new VM types and leave it to userspace to deal with
> > special-casing that vs. the other ioctls like SET_REGS/SREGS/etc.
> 
> Won't regs and sregs suffer the same fate?  That might not matter _today_ for
> "real" VMs, but it would be a blocking issue for selftests, which need to stuff
> state to jumpstart vCPUs.

SET_REGS/SREGS and the others only throw an error when
vcpu->arch.guest_state_protected gets set, which doesn't happen until
sev_launch_update_vmsa(). So in those cases userspace is still able to sync
additional/non-reset state prior initial launch. It's just XSAVE/XSAVE2 that
are a bit more restrictive because they check fpstate_is_confidential()
instead, which gets set during vCPU creation.

Somewhat related, but just noticed that KVM_SET_FPU also relies on
fpstate_is_confidential() but still silently returns 0 with this series.
Seems like it should be handled the same way as XSAVE/XSAVE2, whatever we
end up doing.

-Mike

> 
> And maybe someday real VMs will catch up to the times and stop starting at the
> RESET vector...
> 

