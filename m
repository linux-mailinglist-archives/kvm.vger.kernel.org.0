Return-Path: <kvm+bounces-20921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D74A926CA1
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 02:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FB361F233E8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 00:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87DD611E;
	Thu,  4 Jul 2024 00:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FkspFnYt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067B04C6E
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720051625; cv=fail; b=pid7Ju/j1/kCFdetcK/dd4wSIxHbsn+cDGQ7+h1TZ007qmUyzvd63O7rsN2bZ0OAD/ckvlP//tnEDumQxndMyKYyIyRVbD2rZoKzeCKgRvXqOvjS/DE/gD9FKFy/w4x+9kJVlZ8lQd5+8Ql1YT4Zfd+svFuEaItOhxTVXPOFXG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720051625; c=relaxed/simple;
	bh=k8p2CfV+c8d5VrlOQLikAVAujp0Tc8lcLUXBeThMNRI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wc16ZzcX1B9oUdSmRMzLCWWR3u1y1idfHvUinV114r+0vsBdDfFL/EZxWBwlJDPqEoGv9IiEFPMg0CVZYjojFXX28516K8+WZfaiumPHQqEWxRqNncs1Tb82RfGcICWei+zvJp2iofS6N6hm3edKSy5P9aQSerH8Ju0YhcUcY6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FkspFnYt reason="signature verification failed"; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oz5ClmK8TmMbimCyBMk+r1LSSeLAym/5Jl8JbA5bk0MHyuvmzZCAlbbseYt3MhdXPiuEjoLOT5nYOy716aMMU+Q7d80shZBOJSWgF/xUH8Jov+E5T7G0Xc03jIIjeKszG0ZnJ+zlFhvrXRnr5BEU9zRQ1+291N1onvhhljdjXVj24bWgBggHiF7k28Ta574EKivmxWpaCQ3yvLAGQ9+wmCNr5tzNr/vnUWcxiasDEZ0lOEhtpEgsX4LimTs2uSac/cN5A50CXPJi+pnA/ItkLul7LA7BgdlJEdiZ5pa87U9x/7P3IVKet+jefoPJPJijpObNHUwH2vEmYwuVfM6XYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZctsOphgTvd88qmI91zduhzKIj1UitdRIu9kI4UKGDo=;
 b=MncxrV4bgoL7odd4YLIilrvvMgpox2SFNZbdcGgBHYF4NO92Is4EPVi1XtZ1Fg2w8TAOSkJkG+hLl2L+aJoLSzg4iR0vTN/f1fD9wKhjx6IVljTH3ZntevH0KuhBs6/liKfzTEfNmbb93aGVEpyvxnl091sAH32rVVULbtCozfipORGAFIqei59Bg/gXN+cMdquY5733aZPU9m5aepSm1ru7D9BNZYG2l6jtstUh6ETpTi/bzDA5TWxH0sXMSSFtA+pdEUUrdiZ2QB2heiKsSrlXGuuwE5voRMRliLOBdE2KaSjuN1nQBat3IXIia4MysOWi0m7yCedECxqgorXZSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZctsOphgTvd88qmI91zduhzKIj1UitdRIu9kI4UKGDo=;
 b=FkspFnYtMx6z946UdPQEBFnJvAIPFvY7p82lsa6Dd9/eLmsbREnJhKLFisof1pRUn1I4QznuIYKYeNrxg4pLu/6CZGVaWLY/Y21XiyTmIAAQWwtqjhVX3GLAE/kAvtMW20Dr0ItAog7Cc01fNoZ6VhTYSVUoGFhde5UN3l5Qm7g=
Received: from BY3PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:39a::24)
 by PH8PR12MB7027.namprd12.prod.outlook.com (2603:10b6:510:1be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.26; Thu, 4 Jul
 2024 00:07:00 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:a03:39a:cafe::66) by BY3PR03CA0019.outlook.office365.com
 (2603:10b6:a03:39a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25 via Frontend
 Transport; Thu, 4 Jul 2024 00:07:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.1 via Frontend Transport; Thu, 4 Jul 2024 00:06:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 3 Jul
 2024 19:06:58 -0500
Date: Wed, 3 Jul 2024 19:06:39 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Richard Henderson
	<richard.henderson@linaro.org>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	<kvm@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>, Eric Blake
	<eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <20240704000639.rkjtag6npugg6pnr@amd.com>
References: <20240614103924.1420121-1-berrange@redhat.com>
 <za7dwgyz2yfspsivg67qkzkf4cz3eeiclavdznskap6zcip66s@7iqpll2pzax4>
 <ZnqTL4oQCSiuTd6n@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnqTL4oQCSiuTd6n@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|PH8PR12MB7027:EE_
X-MS-Office365-Filtering-Correlation-Id: 6747f538-dcbb-4187-58f5-08dc9bbd3965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?U10N97yiElyxuCIpQAEk+D5vqwwYKN/JhumlvwErMLYgKfPifbidk7CF9v?=
 =?iso-8859-1?Q?kqO87tzKsZxZUnF8h5DBGEhoO9mNMvxUzCLAWmbMOIPAOVNLbQrR2M1DXN?=
 =?iso-8859-1?Q?v9/R1siR5hxyMLw5EJZneIP8hq4xKnEevAqjy7Yva3QeSlM4RUvqEZPHZ0?=
 =?iso-8859-1?Q?RI5SQ6dWaqvyop0YkeFsSKlAmn3MiFqgY2uCs3erebEzZBxQYkmqKfEr1A?=
 =?iso-8859-1?Q?SKb2dTPbBE/UXtEMJuHPR1wifWTdk0aqzLRKN/WkaSzsAb1xrruo9A3G6C?=
 =?iso-8859-1?Q?akw6SFjP+Gdw/+sLFdaqw1hyHGDIzrWXksvRq/dTM6n1tfL8obailxr90Q?=
 =?iso-8859-1?Q?p+Q3WbS/if4GvN1CTFQT2+iAzkuDE8M14AiWKlpMvwRevDbTacYp7QEScA?=
 =?iso-8859-1?Q?s08ouD6hxvLXuaCP52ZNRCubh2F2mU7wJOaslklntoGM5PvBbrr5iY36kp?=
 =?iso-8859-1?Q?5GOIkw25I30ZKoG6irtSbogRQ1V0FrUYx4lHVbUL0Z0hBCCRtprHiOMM0F?=
 =?iso-8859-1?Q?fk2mQfkGkMOK7Ifu3G3Tndk8UXb4DOYtXpHTCmfpqvIM8UrEQc53sVGJE1?=
 =?iso-8859-1?Q?ahXXK81xZsPM9upJJ3TJ4bFlBws2MrMwIp4kMvKN32ptDQjUMXnRhP1JFp?=
 =?iso-8859-1?Q?EDjUEqdyGt3tnFXi7tjxGJXTW1RoS1z2nLc0Iqb9hapqV8FzJO2QLvu/he?=
 =?iso-8859-1?Q?lKF3JvJkOPow6qVarxiVT11mcMvjrYO/HjuThDJvvjG7zsXSkYyqdaU7eJ?=
 =?iso-8859-1?Q?3N/GATbs6Zg/q3uqQAeEkmiQMw2Sz4ZKzCKbE/7BUWDQsLLRrLRZIyPD9b?=
 =?iso-8859-1?Q?mbxlPqGj9d61gDlj1swsZMdMWSRqx5rDNRuDK6X1ELZ2RGndC20Blh/yze?=
 =?iso-8859-1?Q?Xt/LHcCwfNoRJdbAt+WC4ICn0bYOxXw90YWcRoRNFQqrIF9AE89Q7M3A0d?=
 =?iso-8859-1?Q?ptuj/MpZ7HSUUwXxQ3ie+QM8dCGwaVHfmdCRsWY9+eLTqMjQmtKmk4CuGH?=
 =?iso-8859-1?Q?DdpIDct+A84VMRqz4BY6hqNThuljL1b6uG0deWRJh0uMILOgy2N1a8vHZU?=
 =?iso-8859-1?Q?8sAwc/icoIbT1hHQkVF/ULI71Ak0qUgmewDc5xh2OJ94pbLLHSFk1y/+zg?=
 =?iso-8859-1?Q?fZbsn1A3DMUUjM7az9kw5CWI/Refv+puNZ2Wjymb0qNVgtYlI3szI+VWth?=
 =?iso-8859-1?Q?007Zge1Of5KBAqXK2fuXorVdj49sywqny3knhNmyc4+OeODOefzoa8h1xI?=
 =?iso-8859-1?Q?Rb3vVLh5ukqlXnUvBpfs9mT5XYNG0mGiJpWzXAe7P0K772orJRiIm2KBRF?=
 =?iso-8859-1?Q?y/HfOih/KaC0akjHJkyQ35w6YpbUyY8B15cl8t1QKwUCUpn5R8cdh1t6+Q?=
 =?iso-8859-1?Q?ZoswI+aDa1XjxUMX/vcbVhln+EUova0MURzIps7sHuKWgzZ7Hk/aB5gpje?=
 =?iso-8859-1?Q?ql3JT1Lfr2yUyFdcoPG7RHz2O3+G7ES3S5qVJw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 00:06:59.1960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6747f538-dcbb-4187-58f5-08dc9bbd3965
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7027

On Tue, Jun 25, 2024 at 10:51:43AM +0100, Daniel P. Berrangé wrote:
> On Mon, Jun 24, 2024 at 08:19:19PM -0500, Michael Roth wrote:
> > On Fri, Jun 14, 2024 at 11:39:24AM +0100, Daniel P. Berrangé wrote:
> > > The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
> > > only have been released for a bit over a month when QEMU 9.1 is
> > > released.
> > > 
> > > The SEV(-ES) support in QEMU has been present since 2.12 dating back
> > > to 2018. With this in mind, the overwhealming majority of users of
> > > SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
> > > forseeable future.
> > > 
> > > IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
> > > machine types will be broken out of the box for most SEV(-ES) users.
> > > Even if the kernel is new enough, it also affects the guest measurement,
> > > which means that their existing tools for validating measurements will
> > > also be broken by the new default.
> > > 
> > > This is not a sensible default choice at this point in time. Revert to
> > > the historical behaviour which is compatible with what most users are
> > > currently running.
> > 
> > Part of the reason for the change is that SEV-ES measurements are
> > already affected by some short-comings of the legacy KVM_SEV_ES_INIT
> > API. Namely, if the kvm_amd.debug-swap module param is used to enable
> > that SEV-ES feature, then that feature will get enabled on the KVM side
> > and change the initial guest measurement (due to VMSA_FEATURES field
> > of the vCPU's VMSA changing), and userspace has no way to control that
> > on a per-VM basis, so measurement for any particular invocation will
> > be somewhat random depending on the system configuration and kernel
> > level.
> 
> The debug-swap feature was set to disabled by default. So that
> could be just a docs problem to say if you want to use that
> feature, then you must set the legacy-vm=false property. IOW
> an opt-in to incompatible behaviour.

debug-swap defaulted to true for KVM_SEV*_INIT guests unfortunately, so
the ship sailed on preparing users for the change in advance and instead
over time legacy guests users will gradually see the measurement change
when they upgrade to new kernels and then need to take steps to either
adjust their measurement calculation or disable debug-swap via module
parameters.

debug-swap is fairly recent as well however, so there's a fair chance
users hitting the above issue will have the option of switching over to
KVM_SEV_INIT2 where it's not much additional work to update
measurements, and in turn they'll benefit from better control over what
ends up in the VMSA as well. If they do plan to eventually switch to SNP,
these steps will bring them closer toward that end as well since there's
a lot of common handling/infrastructure in that regard.

> 
> 
> > I think that's why users of newer QEMU machine types are highly
> > encouraged to switch to the new KVM_SEV_INIT2 interface. I do see this
> > causing issues for older QEMU machine types that previously relied on
> > the legacy interface, since we do want to avoid measurement changing
> > for an existing guest that was previously working on an older kernel,
> > which is why this flag defaults to true for pre-9.1 machine types.
> 
> This justification mis-understands how machine types are actually
> used in practice though. There is *zero* correlation between use
> of the new machine types, and availabilty of the new kernel
> interface. 
> 
> 99% of usage of QEMU, will just ask for the unversioned "q35"
> / "pc" machines. They will be expanded to the very latest machine
> type version, either internally by QEMU, or by libvirt prior to
> launching the VM.

In my experience that's how many VMs start off until they start breaking
on newer kernels/QEMUs, then everyone scrambles to revert to the old
behavior. Quite often that ends up involving just tacking on an explicit
machine-type to maintain migration/behavioral compatibility with what
QEMU originally defaulted to when the VM was created.

But when first creating the VM, there is less expectation about what
should/shouldn't work. If they see failures because KVM_SEV_INIT2 isn't
available, it seems worthwhile that they need to make a decision on
whether to upgrade kernel or adopt the legacy behavior and be stuck on
a reduced featureset for the life of the guest. "Just works" is nice,
but "just working" in the case of KVM_SEV*_INIT comes with potential
headaches down the road and ideally users would be aware of what they
are signing up for.

If failing is too heavy-handed, maybe some type of warning that gets
printed by QEMU any time KVM_SEV*_INIT set? Then maybe down the road
if we decide to finally default KVM_SEV_INIT2, there's a better chance
that users have taken the hint and have already made the transiton?

I'll also defer to the maintainers on this point though since there are
clearly merits to both approaches.

> 
> Either way, you can expect essentially everything to be running on
> the latest machine type versions, regardless of kernel version.
> 
> So making the latest machine types dependent on a kernel version
> that is brand new is just not a sensible default. Latest QEMU
> machines types need to work on kernel releases years old, without
> expecting the user to set magic flags to avoid incompatibility.
> 
> > I was actually planning to go the other direction on this because
> > currently for 9.1+, QEMU will try to use KVM_SEV_INIT2 if
> > KVM_CAP_VM_TYPES advertises its availability, but otherwise fall back to
> > the above KVM_SEV_ES_INIT interface and potential inherit the issues
> > noted above. So I was planning on getting rid of the fallback, and
> > basically only allowing legacy KVM_SEV_ES_INIT for 9.1+ if the user
> > manually sets sev_guest->legacy_vm_type via cmdline.
> 
> Dynamic detection of SEV_INIT vs SEV-INIT2 is a bad idea as that
> breaks migration when someone is moving from a host with new
> kernel to an older kernel, while keeping the QEMU machine type
> unchanged. The behaviour of what kernel feature to use must be
> controllable with an explicit choice.

Totally agreed on this point. I've sent a patch that does this, and
adopted the QAPI wording you used in this patch so there is less churn
if they are both applied:

  https://lore.kernel.org/kvm/20240704000019.3928862-1-michael.roth@amd.com/T/#u

Thanks,

Mike

> 
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 
> 

