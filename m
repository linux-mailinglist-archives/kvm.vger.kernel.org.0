Return-Path: <kvm+bounces-25905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB1196C801
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 21:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCF871F239B1
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAF71E6DFF;
	Wed,  4 Sep 2024 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dLG8Wdiy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8D91E00A3;
	Wed,  4 Sep 2024 19:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479670; cv=fail; b=b3YorKmg+MI56gsrXJQD7k4ghKXKZ96u/jG4lVY6d0U8GQYpyiruF1DfVA7WrI7lUCjEF9rLwpyqN6Jkmsy+DS+qE6O9WXgMXngLLjSxi3OPLNgZSQNeApIdPcdLr2UJw0GSYZR4MlNxCpPd23SCyqDkB8TOtVnqvhBQBk2Nex4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479670; c=relaxed/simple;
	bh=PPW5+uG1LL9Sj0TVl3hfEVlm+CYevC0Vic5bMhXi8kA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiEYS00770mQamh+VCduW2ZJQ8treTvQYCYJ4aIFbeHHjUrS/ya1AsFilDl1HUSWdO4ko9lfP/MiLy8Vhm94ClJXYfbdcLIi/3k3C4b7qUa2+cEIR0o1LyXAyROKhvjPGxfz/Wo29dnK2elGmNHbwOvjlcST9xNhKvuLH1M2SWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dLG8Wdiy reason="signature verification failed"; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=flkDS8B3goj3dXPAjgasdYyqCj0lnzr6vgJgAoCHVX1VYuDHMhBp87wolOAFat+VKCQQ2vkb6eezWdRJ4ltqat2s9GeDydOaLrad7pSwltF8sAeYuM0sOIy0iC7CmtR1w6ZE7PsMxf9C4JIsdVRBoLQxsfENEAfUPIzakxS/8XFP7hH9klAwNiIuc9FCUm/Y2QJ5Mu2YChIdDYUpL6+n93PTWbS5QLYguhtaqQMIq//hQj6krpeF9YQHJ6uXTGGX4N++f53MwzTnpWfEMS/2SXGnyYlomfJj/xf/HIbfGDpqao4+NemFIU+h4EmehQfCmFf+Ql1OX1gRZ8x2DggPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlmM40QNbT3cxXF+3cYIczlcwlAUdqPeGyetevigcJ8=;
 b=GuT9v1G2KfCHb1CARc4FhOmhupB940cKeL3WGrw7lg8aC+StucP27RbRbMiefPX2iaRnw/nM9tEQcFSYzA82FjiedbwtwGBzXb0KJtMsnaDEKRivIVszR7PID/B0VP30FYch3ja45OD3HcDc5MXU9lWK4pDu9ukH2BR3UT+dxo/uwA1qixKoeKzEfqLU3/OC1P5fdlp3wVEmEnf0enR6jNN04U1X+YgE7tKYOlMO9bL2i6BmgjQkMWP4dAAvXazNLGr8Gcz+mqPat2NutCi9S2ZcQfU+f4ufSk/QBqoTx99ngUgP1dm//NCsHHogTw1FcneIEEAPVOucfpJOunrfJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlmM40QNbT3cxXF+3cYIczlcwlAUdqPeGyetevigcJ8=;
 b=dLG8WdiyFR+1eJeVBEmLt2B3CdFHRVV5XfGGeRZLazmvokzn8BGnioReOdGoZBZxOE0s9lLZ9/Bbx3QoxvljpFXjOxyxphPUVLjX3BhoMGLVTU/CbfJYAnBtlyeiQ3+DQbaHs7Df+ST2fJK4r/6vZOCKlUGPNAbEItmpBv46wks=
Received: from CH0PR03CA0097.namprd03.prod.outlook.com (2603:10b6:610:cd::12)
 by LV3PR12MB9094.namprd12.prod.outlook.com (2603:10b6:408:19e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Wed, 4 Sep
 2024 19:54:24 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::9) by CH0PR03CA0097.outlook.office365.com
 (2603:10b6:610:cd::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Wed, 4 Sep 2024 19:54:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Wed, 4 Sep 2024 19:54:24 +0000
Received: from localhost (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 4 Sep
 2024 14:54:23 -0500
Date: Wed, 4 Sep 2024 14:54:08 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, <dave.hansen@linux.intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<kexec@lists.infradead.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Message-ID: <20240904195408.wfaukcphpw5iwjcg@amd.com>
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
 <ZtdpDwT8S_llR9Zn@google.com>
 <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
 <25ca73c9-e4ba-4a95-82c8-0d6cf8d0ff78@redhat.com>
 <14b0bc83-f645-408f-b8af-13f49fe6155d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14b0bc83-f645-408f-b8af-13f49fe6155d@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|LV3PR12MB9094:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8c7df3-fa27-4c3a-0aed-08dccd1b608c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?nMBzkm46r0gYcwFLXv+q3MDOVa3lOZLocJagB+DwUwlLs4UIVCT9a+slZq?=
 =?iso-8859-1?Q?QMhgM57GDLclzRXjN27sCC7vFbdH13roD0g5sj+2/7lgAStT4bqXdOASnZ?=
 =?iso-8859-1?Q?qP8CtrB0bPK/MuUaIbQL4oeiLukW1UxN0tpd60OA21x8CZcO0reIFXZzqo?=
 =?iso-8859-1?Q?hZ6MOHAkSfhQFWeuEch9voiercdlfnYiyr9Age6UvfhmbhZaea8Rb1ZOe5?=
 =?iso-8859-1?Q?sNyiUBfXqv8G5YtQnEVHo7gwcTSswVA2ULh4llEtTYHP0T4LTB0W9xoxke?=
 =?iso-8859-1?Q?D2V82WSvHNFMJEQjmvw1opefhwrftcWyTDYuPyanGLHxg5Z6XAu06IubYO?=
 =?iso-8859-1?Q?IwcIDVNxbfAoxUq5RoYsgFfoP+/ci+i4ggdzKnFyhAPnclZH0gv5S34mlL?=
 =?iso-8859-1?Q?Gq+gXUGHGRkiQpoo4UY5uOqBT6966mvB+itk+2BudC26Cgd70Nt+0h/3Jk?=
 =?iso-8859-1?Q?WUwnRZejc5V44NQRKoiU6Z/6eb9TUUmUxOijHlFjatBGTNBeSKD2wzbadb?=
 =?iso-8859-1?Q?XFzNxLA/VF+E8if/tKX+XzudnBsWJ5tu4YFfUi4Ld75Ok3wz+tEDl59LHb?=
 =?iso-8859-1?Q?w0CSPIUPdtpcTAiTkVJ3Y0XMb9RDyhJPhz/RVnacJNz8wlrN02sKouDrFI?=
 =?iso-8859-1?Q?Ioz6niTCO+O6ODXtCF/LcpK2LAH0TtRpYIHq4l7ZOpdl0fI5u8RNBVS3Cw?=
 =?iso-8859-1?Q?ATGNypZa8rsRyHwHmGhqNOx5S15j8v0kY1qB+eurk8WSlkxiSdAlQDFznJ?=
 =?iso-8859-1?Q?5EYIWLrTCyptaR++qCdB9EHjiM+hDY+Lkhh3BqKi5XKFpnSBD4B2VUGEdm?=
 =?iso-8859-1?Q?1OJXvTyZ1zZWQQaeesafyGbCOh7KVxyzZS3TsiH5FEMn2NAhC3FI21Ktkv?=
 =?iso-8859-1?Q?jPmiyqHQ1mfe28EZnADjrpaoWzbA0LQHuVz1Cg3rCuohTdOTqj+lAdksOU?=
 =?iso-8859-1?Q?u4rAtV23EQs81Oz5D8e4L4f41Gp2ydmCTLmbsCf1JAV6Q6sL+j64YBWlh8?=
 =?iso-8859-1?Q?9dWiyM2d3Xm8+Asim8tHbFyhaehwZGkXuSZAcC2cb4A/rriK6WTgyIBpsx?=
 =?iso-8859-1?Q?uQyLlsZtXc6n/h25/T840ZXVhOfIwHt/8D04VJSjn06a8/rm+93sfOHZG+?=
 =?iso-8859-1?Q?5dz94H+h7jlIfbrjY1VBJeXaMKQQhah0sLlAcqw3x1+2nV+cq1BXXttZq1?=
 =?iso-8859-1?Q?68kbnDCyF2lCbp0VLKm+NxqfJNVf2b0KxxHgBZRWS+R9W86TOr3YhdYzUg?=
 =?iso-8859-1?Q?/mIMeT0q6lGMldAyIPKAO5VbUfCdV3MpSbmyLhP9ouujfFCC4iZf2SPMuD?=
 =?iso-8859-1?Q?7fc4y491d3evo1PKEruLNRAoVc+Ccn7045DkxbQ8xfRLDs/zp23fpPa6Sb?=
 =?iso-8859-1?Q?hKeosT08VF4sNOtXLv+8uRacEA4hS1zjoUEIGbT2CsmCDnXFGN2Zl0NR1n?=
 =?iso-8859-1?Q?A6yOPnx1ynPoOxXZZOcO+0XH75P5PjADlf4VdiMZc1y1RAUVlpt4F+HZyx?=
 =?iso-8859-1?Q?tNVjaolYe+7frK2CF1HK44?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 19:54:24.6588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8c7df3-fa27-4c3a-0aed-08dccd1b608c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9094

On Wed, Sep 04, 2024 at 12:37:17PM -0500, Kalra, Ashish wrote:
> Hello Paolo,
> 
> On 9/4/2024 5:29 AM, Paolo Bonzini wrote:
> > On 9/4/24 00:58, Kalra, Ashish wrote:
> >> The issue here is that panic path will ensure that all (other) CPUs
> >> have been shutdown via NMI by checking that they have executed the
> >> NMI shutdown callback.
> >>
> >> But the above synchronization is specifically required for SNP case,
> >> as we don't want to execute the SNP_DECOMMISSION command (to destroy
> >> SNP guest context) while one or more CPUs are still in the NMI VMEXIT
> >> path and still in the process of saving the vCPU state (and still
> >> modifying SNP guest context?) during this VMEXIT path. Therefore, we
> >> ensure that all the CPUs have saved the vCPU state and entered NMI
> >> context before issuing SNP_DECOMMISSION. The point is that this is a
> >> specific SNP requirement (and that's why this specific handling in
> >> sev_emergency_disable()) and i don't know how we will be able to
> >> enforce it in the generic panic path ?
> >
> > I think a simple way to do this is to _first_ kick out other
> > CPUs through NMI, and then the one that is executing
> > emergency_reboot_disable_virtualization().  This also makes
> > emergency_reboot_disable_virtualization() and
> > native_machine_crash_shutdown() more similar, in that
> > the latter already stops other CPUs before disabling
> > virtualization on the one that orchestrates the shutdown.
> >
> > Something like (incomplete, it has to also add the bool argument
> > to cpu_emergency_virt_callback and the actual callbacks):
> >
> > diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> > index 340af8155658..3df25fbe969d 100644
> > --- a/arch/x86/kernel/crash.c
> > +++ b/arch/x86/kernel/crash.c
> > @@ -111,7 +111,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
> >  
> >      crash_smp_send_stop();
> >  
> > -    cpu_emergency_disable_virtualization();
> > +    cpu_emergency_disable_virtualization(true);
> >  
> >      /*
> >       * Disable Intel PT to stop its logging
> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 0e0a4cf6b5eb..7a86ec786987 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -558,7 +558,7 @@ EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
> >   * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
> >   * GIF=0, i.e. if the crash occurred between CLGI and STGI.
> >   */
> > -void cpu_emergency_disable_virtualization(void)
> > +void cpu_emergency_disable_virtualization(bool last)
> >  {
> >      cpu_emergency_virt_cb *callback;
> >  
> > @@ -572,7 +572,7 @@ void cpu_emergency_disable_virtualization(void)
> >      rcu_read_lock();
> >      callback = rcu_dereference(cpu_emergency_virt_callback);
> >      if (callback)
> > -        callback();
> > +        callback(last);
> >      rcu_read_unlock();
> >  }
> >  
> > @@ -591,11 +591,11 @@ static void emergency_reboot_disable_virtualization(void)
> >       * other CPUs may have virtualization enabled.
> >       */
> >      if (rcu_access_pointer(cpu_emergency_virt_callback)) {
> > -        /* Safely force _this_ CPU out of VMX/SVM operation. */
> > -        cpu_emergency_disable_virtualization();
> > -
> >          /* Disable VMX/SVM and halt on other CPUs. */
> >          nmi_shootdown_cpus_on_restart();
> > +
> > +        /* Safely force _this_ CPU out of VMX/SVM operation. */
> > +        cpu_emergency_disable_virtualization(true);
> >      }
> >  }
> >  #else
> > @@ -877,7 +877,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
> >       * Prepare the CPU for reboot _after_ invoking the callback so that the
> >       * callback can safely use virtualization instructions, e.g. VMCLEAR.
> >       */
> > -    cpu_emergency_disable_virtualization();
> > +    cpu_emergency_disable_virtualization(false);
> >  
> >      atomic_dec(&waiting_for_crash_ipi);
> >  
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index 18266cc3d98c..9a863348d1a7 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -124,7 +124,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
> >      if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
> >          return NMI_HANDLED;
> >  
> > -    cpu_emergency_disable_virtualization();
> > +    cpu_emergency_disable_virtualization(false);
> >      stop_this_cpu(NULL);
> >  
> >      return NMI_HANDLED;
> > @@ -136,7 +136,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
> >  DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
> >  {
> >      apic_eoi();
> > -    cpu_emergency_disable_virtualization();
> > +    cpu_emergency_disable_virtualization(false);
> >      stop_this_cpu(NULL);
> >  }
> >  
> >
> > And then a second patch adds sev_emergency_disable() and only
> > executes it if last == true.
> >
> This implementation will not work as we need to do wbinvd on all other CPUs after SNP_DECOMMISSION has been issued.
> 
> When the last CPU executes sev_emergency_disable() and issues SNP_DECOMMISSION, by that time all other CPUs have entered the NMI halt loop and then they won't be able to do a wbinvd and hence SNP_SHUTDOWN will eventually fail.
> 
> One way this can work is if all other CPUs can still execute sev_emergency_disable() and in case of last == false, do a spin busy till the last cpu kicks them out of the spin loop and then they do a wbinvd after exiting the spin busy, but then cpu_emergency_disable_virtualization() is/has to be called before atomic_dec(&waiting_for_crash_ipi) in crash_nmi_callback(), so this spin busy in other CPUs will force the last CPU to wait forever (or till it times out waiting for all other CPUs to execute the NMI callback) which makes all of this looks quite fragile.

Hi Ashish,

Your patch (and Paolo's suggested rework) came up in the PUCK call this
morning and I mentioned this point. I was asked to raise some of the
points here so we can continue the discussion on-list:

Have we confirmed that WBINVD actually has to happen after the
SNP_DECOMISSION call? Or do we just need to ensure that the WBINVD was
issued after the last VMEXIT, and that the guest will never VMENTER
again after the WBINVD?

Because if WBINVD can be done prior to SNP_DECOMISSION, then Paolo was
suggesting we could just have:

  kvm_cpu_svm_disable() {
    ...
    WBINVD
  }

  cpu_emergency_disable_virtualization() {
    kvm_cpu_svm_disable()
  }

  smp_stop_nmi_callback() {
    if (raw_smp_processor_id() == atomic_read(&stopping_cpu)) {
      return NMI_HANDLED;
    }
    cpu_emergency_disable_virtualization()
    return NMI_HANDLED
  }


The panic'ing CPU can then:

  1) WBINVD itself (e.g. via cpu_emergency_disable_virtualization())
  2) issue SNP_DECOMMISSION for all ASIDs

That would avoid much of the additional synchronization handling since it
fits more cleanly into existing panic flow. But it's contingent on
whether WBINVD can happen before SNP_DECOMMISION or not so need to
confirm that.

Sean and Paolo also raised some other points (feel free to add if I
missed anything):

  - Since there's a lot of high-level design aspects that need to be
    accounted for, it would be good to have the patch have some sort of
    pseudocode/graph/etc so it's easier to reason about different
    approaches. It would also be good to include this in the commit
    message (generally it's encouraged to describe "why" rather than "how",
    but this is an exceptional case where both are useful to reader).

  - Sean inquired about making the target kdump kernel more agnostic to
    whether or not SNP_SHUTDOWN was done properly, since that might
    allow for capturing state even for edge cases where we can't go
    through the normal cleanup path. I mentioned we'd tried this to some
    degree but hit issues with the IOMMU, and when working around that
    there was another issue but I don't quite recall the specifics.
    Can you post a quick recap of what the issues are with that approach
    so we can determine whether or not this is still an option?

-Mike

> 
> Thanks, Ashish
> 

