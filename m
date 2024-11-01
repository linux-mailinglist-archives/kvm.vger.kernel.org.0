Return-Path: <kvm+bounces-30384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 538D69B9A92
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 23:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E2828284E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 22:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E663A1E7C2D;
	Fri,  1 Nov 2024 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N4EC9PKW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543261E7657;
	Fri,  1 Nov 2024 22:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730498651; cv=fail; b=HQmD19LVeA/GBx5fuzO8xa5M4zAGCSG9tLXsKwSvcSHn3/WnHlpnh6nuZvMwjTw5+reYUEw5OcXulyO1IZDQiHmNzJDF8UuGO1B1fXEsA1CmXNlEdmlS7HpUzj/w4fIXr3Ip8zF4xdlpR/brbYv670s26tdV2ds+585P2NDop3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730498651; c=relaxed/simple;
	bh=5Pb1OgZPWdI8sXR1G42cYLLvV4nPrYT5wQQ4nNLdFRk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0c+DY9EuhAQNSt70xofoX59aIMqbj2Msz1zXf02MVd1xylW2Rc6ZgBLWRFqtgBdHA/m3V3ws6cG8264o2mo5zlxoMt6ECmYxSk6Wlrity7AnVOLnGBeMCwSAZiWcQyhwL4piZh7DjXeYehal8ldRiOFSTqAFqo5OafTlfDvcxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N4EC9PKW; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPGFf+GSNaoM271lAUsJdzGX14Eh1pQLdDhkY/TajTxtQLzuGJ7ToxqRaJt4Kam8SoGZvtGEqgcQkmLiHw4PwiBVfwJkcZ5YgIe4T4/9Iaf2C4ehp5Yhk7z7tE2EpeWA0ipcgKxrJldWvgGwVe3yppZXc1dXUEzL+sQv/Mhc9sFPP4rXCkfP8MQppaDrPRi/ofhfkmljqTfgjIwxyDu5tpeG25Zo4/jfnzB3ctqjmIWdib65cHsM4SyE5NJGWu2Mln0qtX+VV+2bOrCpYElLE0/Dpk94sZLe1ndn5eVjZoxWLrVIuGOV7doQacp7YBy5nndGN1kLaRzUHfSuyynntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bx7INFOT16T57kDXTq838Ud3yX+9K0BVUrcCwayLfQM=;
 b=RkwM+n+Ji7TAMMQVxou3kFcWzXVwobNuKYer6NqG/P/KG/WrAyoCJQtEMtrmt/t5z3r6cZFSa1zKvYQmt/5aNx0vCKqdb1ISQ2RjWzCW++Wasd8XM/m1c4uV3YogSFLz5ctARdyYuV317bB6qhori+/QioR01wrczrWxWAfQVfmlNzNPQIvZiGniEf2jyyxTX8VUS3V0dPB3vIhE9bOIGqqb8g5GcMdERQPcivLse3z+Pb6Sw30hqeO7eaDRZmRZ3m1qpcVdKWgR90KO/hPTS8Ge9RgIymGkEnD3FOfW6BNBFpf8+raaF6ps9RiBm0XFqIJ7YZT39J7q8mjztCiLag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx7INFOT16T57kDXTq838Ud3yX+9K0BVUrcCwayLfQM=;
 b=N4EC9PKWMXHg1mufnCopdKmogsYUikvsjHM06S0UHycRNWOMDXyMZKKgNH+dOYeQVSlBO/96i+p97yNHET17L53vMZoqrtaVdkjs/u8/j2sY1kmsj4WDiNdNGiBB/t2nFWJpVDVgToavYyHcY/uQt9bTok2Dk9IXUTRu0d0Kwu0=
Received: from DM6PR07CA0113.namprd07.prod.outlook.com (2603:10b6:5:330::16)
 by PH8PR12MB7301.namprd12.prod.outlook.com (2603:10b6:510:222::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Fri, 1 Nov
 2024 22:04:05 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:5:330:cafe::6d) by DM6PR07CA0113.outlook.office365.com
 (2603:10b6:5:330::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.23 via Frontend
 Transport; Fri, 1 Nov 2024 22:04:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Fri, 1 Nov 2024 22:04:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 1 Nov
 2024 17:04:03 -0500
Date: Fri, 1 Nov 2024 16:52:16 -0500
From: Michael Roth <michael.roth@amd.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
CC: Sean Christopherson <seanjc@google.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <ashish.kalra@amd.com>,
	<bp@alien8.de>, <pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Chao
 P Peng" <chao.p.peng@intel.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
Message-ID: <20241101215216.qzexyzahj63vfw4d@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com>
 <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com>
 <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
 <CAAH4kHZ-9ajaLH8C1N2MKzFuBKjx+BVk9-t24xhyEL3AKEeMQQ@mail.gmail.com>
 <Zx_V5SHwzDAl8ZQR@google.com>
 <CAAH4kHaOy0s93vp96-ZeX3PykCv_XsGM3z36=Fr1dEADsctMrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH4kHaOy0s93vp96-ZeX3PykCv_XsGM3z36=Fr1dEADsctMrg@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH8PR12MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2926f9-7de7-4167-433a-08dcfac11a49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXl6d1pISnJpcjNuRDAvdXNXRjQ2RjlNUEZMUU5Wd2ZDMzBFVzBLMXJCNHJz?=
 =?utf-8?B?QVlKK2dRZ21uRWg5b3JvMDBJaXYzTDVWU3ZTaG45STRZQzFFYW94VHYzNmpm?=
 =?utf-8?B?cVJLY1ByMFdxeDUrQjRZYzFtd3VxSnRtM08wYngwLzdlWEtjVFExUGc1SkJT?=
 =?utf-8?B?UjlWQW0rVnFXUzcxVFpzMVQzOElTdnNOcXNBTDZ6STlON2s5SXJtdG5YL1JO?=
 =?utf-8?B?QTJmUUNXcDUyOFlHbXkzeXVKd1Y0bGxVN2NMTzlRMnFNOU1MTTZBM1dWb1RG?=
 =?utf-8?B?UU9WZHNZVkVFeGpwWDJwU2ZTa0N5SUkxcVZIVUVybXZhVGphcFI3Ky9pM0oz?=
 =?utf-8?B?ZEFWcFZXNjZkbzBUOGhRK0lzR2I3SGltOGNyVlBCU2toL01rSVdMNytUMFJv?=
 =?utf-8?B?Ym13Nk1tem5HT1BWRUY1M25wbUtRalhhSjdGenkxLzRRdHlHTVkyeU9SRGxr?=
 =?utf-8?B?d1Q1amhDNFA2TzY1ekVZY1cxd05zcFh4ZXRzMWRtamkvRThVcjhrbjdRRUpp?=
 =?utf-8?B?STlYd0tYRlFXT3d3NFRtM0IvYUk3YzhCZEFnbUxNTlFFUzRRanBlTk95VUVE?=
 =?utf-8?B?M0RNMmJYV3ByanZOdzJMemFqTGJwWUpCNlVMTG5Ic0swR3dwQTg5MkM4bnk0?=
 =?utf-8?B?eFA2MExET2VUenlmOGgvNmFvWlN2Yzk2MGd4OHQrZUlTZVNrekVXQWlZK2xz?=
 =?utf-8?B?RElkUHpGbFFqVFhxNkJpdC82SUJ1NUl3YUowVFBXdm56Zm9CVTNJbURUSFNR?=
 =?utf-8?B?b3g4S05jV0txQno0ZmZVYTM5dDFBWUtSdlhKZ1NDY0M2ZFBkZ05TeGZrc2J6?=
 =?utf-8?B?THpUeG9rdVhGajdJQTFlcVRZbThxY1J3ZndGV0M0VldWVEhiUkFFcVhrSjNN?=
 =?utf-8?B?MHdGbTR4U2lxWkgzUStpaXBTVEg5VU5scUZidEFxcGZhVC8zT2hzQjl1eGcx?=
 =?utf-8?B?eStGNWhGREQrMjZiSlBjTHN6QmJQelhvR1hnbVB6TCtMVUx6ZDFwUUUxeWpq?=
 =?utf-8?B?R3BrSmtnQzNwVlpldGMvdlR3aGNuZTJpRTRVMkkwSmNTYzB3WlRiYWZRN2pZ?=
 =?utf-8?B?K2d4dHdjcE9mZmc5NHdQWVRmbENicWJSOHo0NFlCanhzZ3hjWEhMTDlVN214?=
 =?utf-8?B?M0Z6K1lqTWFESFQyK25ReTZISVBQZXBnYUhBMFl5TnYwVEQvRmFJNzlpZzdE?=
 =?utf-8?B?SUl0bFFHb0dLQUYyZUN4RjJOczM3MGFINlM1V05JYndEMFExQkp0VzNBbm15?=
 =?utf-8?B?aDJoSzhVcVhwWE00ZC95dWV1NjhlSUFQcHlSbUJPMmk5YWVhM1oxclRON1k0?=
 =?utf-8?B?T0ZYb3pyUmgxdVNYNUxTZEVUWWxrbG54aVl5SnV1d2xxekF2TTNaRlg3Q3do?=
 =?utf-8?B?b2JzWXpiNHAxKzBzallsTmE3Y3VNRTFzN0QyYlRwTWZZTXJBRzBOaXdvSEdF?=
 =?utf-8?B?bHZvSnB2L0dVRGxvSzBYSE5GZ2lhSlJkNEsrNW9Sakc3c1hyS3FDam1sNUpu?=
 =?utf-8?B?aVJVblhGM2tENllkQjA2QUJqcU8vYmNQaEpxSFp0a1FNSEJ3OVZvQzV3dG1w?=
 =?utf-8?B?aWltVXNoR01XS1c1REpCbllKUU5HNmRJN01FMXJtZG51QWJ3UVEvZXNKdnFw?=
 =?utf-8?B?RjZSUDhYOE0yajJieGdXVnIyS25jb1hiWVYwZVg1eVJRZTJvSUlUeHRPVXpq?=
 =?utf-8?B?eVlUQy92RStYSk9jOWdja0liZEdubWhrWmtTMTlsWGsyUkRiRGsxR3N4d1FN?=
 =?utf-8?B?YTZERzdZWWpwZ1JXMStRL01oSHh0cDlCSXNIQ2Jra0ZST3drKzBXbERjeHJE?=
 =?utf-8?B?YWFCVUF5TVBQT3FXRjM1cTZGUWVQVFVDamQzK20wVXJlYnRkS3I3NkxBSFNH?=
 =?utf-8?B?MFNRdXJ3N0NQdVhkMnI1VVZ5ekIrajBTdkV3TEF4bklZZ3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 22:04:05.4846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2926f9-7de7-4167-433a-08dcfac11a49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7301

On Fri, Nov 01, 2024 at 01:53:26PM -0700, Dionna Amalie Glaze wrote:
> On Mon, Oct 28, 2024 at 11:20 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Sep 13, 2024, Dionna Amalie Glaze wrote:
> > > We can extend the ccp driver to, on extended guest request, lock the
> > > command buffer, get the REPORTED_TCB, complete the request, unlock the
> > > command buffer, and return both the response and the REPORTED_TCB at
> > > the time of the request.
> >
> > Holding a lock across an exit to userspace seems wildly unsafe.
> 
> I wasn't suggesting this. I was suggesting adding a special ccp symbol
> that would perform two sev commands under the same lock to ensure we
> know the REPORTED_TCB that was used to derive the VCEK that signs an
> attestation report in the MSG_REPORT_REQ guest request. We use that
> atomicity to be sure that when we exit to user space to request
> certificates that we're getting the right version certificates.
> 
> >
> > Can you explain the race that you are trying to close, with the exact "bad" sequence
> > of events laid out in chronological order, and an explanation of why the race can't
> > be sovled in userspace?  I read through your previous comment[*] (which I assume
> > is the race you want to close?), but I couldn't quite piece together exactly what's
> > broken.

Hi Dionna,

> 
> 1. the control plane delivers a firmware update. Current TCB version
> goes up. The machine signals that it needs new certificates before it
> can commit.
> 2. VM performs an extended guest request.
> 3. KVM exits to user space to get certificates before getting the
> report from firmware.
> 4. [what I understand Michael Roth was suggesting] User space grabs a
> file lock to see if it can read the cached certificates. It reads the
> certificates and releases the lock before returning to KVM.
> 5. the control plane delivers the certificates to the machine and
> tells it to commit. The machine grabs the certificate file lock, runs
> SNP_COMMIT, and releases the file lock. This command updates both
> COMMITTED_TCB and REPORTED_TCB.
> 6. KVM asks firmware to complete the MSG_REPORT_REQ request, but it's
> a different REPORTED_TCB.
> 7. Guest receives the wrong certificates for certifying the report it
> just received.
> 
> The fact that 4 has to release the lock before getting the attestation
> report is the problem.

We wouldn't actually release the lock before getting the attestation
report. There's more specifics on the suggested flow in the documentation
update accompanying this patch:

+    NOTE: In the case of SEV-SNP, the endorsement key used by firmware may
+    change as a result of management activities like updating SEV-SNP firmware
+    or loading new endorsement keys, so some care should be taken to keep the
+    returned certificate data in sync with the actual endorsement key in use by
+    firmware at the time the attestation request is sent to SNP firmware. The
+    recommended scheme to do this is:
+
+      - The VMM should obtain a shared or exclusive lock on the path the
+        certificate blob file resides at before reading it and returning it to
+        KVM, and continue to hold the lock until the attestation request is
+        actually sent to firmware. To facilitate this, the VMM can set the
+        ``immediate_exit`` flag of kvm_run just after supplying the certificate
+        data, and just before and resuming the vCPU. This will ensure the vCPU
+        will exit again to userspace with ``-EINTR`` after it finishes fetching
+        the attestation request from firmware, at which point the VMM can
+        safely drop the file lock.
+
+      - Tools/libraries that perform updates to SNP firmware TCB values or
+        endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+        ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+        Documentation/virt/coco/sev-guest.rst for more details) in such a way
+        that the certificate blob needs to be updated, should similarly take an
+        exclusive lock on the certificate blob for the duration of any updates
+        to endorsement keys or the certificate blob contents to ensure that
+        VMMs using the above scheme will not return certificate blob data that
+        is out of sync with the endorsement key used by firmware.

So #5 would not be able to obtain an exclusive file lock until userspace
receives confirmation that the attestation request was processed by
firmware. At that point it will be an accurate reflection of the
attestation state associated with that particular version of the
certificates that was fetched from userspace. So at that point the,
transaction is done at that point and userspace can safely release the lock.

-Mike

> If we instead get the report and know what the REPORTED_TCB was when
> serving that request, then we can exit to user space requesting the
> certificates for the report in hand.
> A concurrent update can update the reported_tcb like in the above
> scenario, but it won't interfere with certificates since the machine
> should have certificates for both TCB_VERSIONs to provide until the
> commit is complete.
> 
> I don't think it's workable to have 1 grab the file lock and for 5 to
> release it. Waiting for a service to update stale certificates should
> not block user attestation requests. It would make 4's failure to get
> the lock return VMM_BUSY and eventually cause attestations to time out
> in sev-guest.
> 
> >
> > [*] https://lore.kernel.org/all/CAAH4kHb03Una2kcvyC3W=1ZfANBWF_7a7zsSmWhr_r9g3rCDZw@mail.gmail.com
> 
> 
> 
> -- 
> -Dionna Glaze, PhD, CISSP, CCSP (she/her)

