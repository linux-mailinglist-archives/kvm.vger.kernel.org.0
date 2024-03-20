Return-Path: <kvm+bounces-12337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF27881974
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:33:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFDAF1F22E5E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF9B224D7;
	Wed, 20 Mar 2024 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0GpkH1ql"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F170712E52
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710973986; cv=fail; b=lFZrry/bAcBZf06pQMDp743KtmC7HO5wDFgLEGIzqmLeoQffZ6mbqoj7qnbjeShX6QgCcFw1lUycvcuXblDaIZEauNV91X6/lMAD3TiWsm8eLevxJBQ1nKs/KNQS5DCSka05rL64oh/li2cMqi1Q/wWj//zv0iXOwM2iUlcA5F8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710973986; c=relaxed/simple;
	bh=Qw9f9akCP4xHHYhppFaXesoK9PbEuAvKmDLmVkFVk5k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH6NVXtvcwIAQ0p24jElDiImJRy2JYDtzOYf2GBxA50YKInIYJbFPGhPinrrgpOTRJU/yTmCfjyX3TQGENT9VEFoaHpbnQng1l7gSvqvssBPZTJTzWhUAQljacqT3AubBmhVN2HeDiwbz/Vo1Cj+XK+QSP23L7fbxZxbAVmszoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0GpkH1ql; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTJLE+qYG0En/TbdqjIV1jmE7cHd+7Lo9YzWE1ec2d7NSQQ3Vf3DyJObi7lBJF/Gd2C0LwsYhPXchpd4BBCiqM/DA0pV/YtJeUw0E34dGBJPP+N2d39IxSESA1TH9wnoMPsDqfguesT7nYtgSstrK/AFPMV2ufXozIHRu0r/dPEpAIjoZGJHjBsvyj0Pq36DDREuQ5jiLDt5zkQEGxjYcU8uGaE1g2//ZONcy56+ClfgchBbhDgy0Osk0VmTohSw/iiiHbhgwZ9zn4LjxJIhoNVp7tUE22T02diNu7bbFqzf8zhmT0BPYshN/1Aj//vVms+OVaqpwoiINHJfwAYKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UppUIdAOFx0Viz0/HWQ5mdjEx8xCAbThMCG58c8GLXc=;
 b=V4nVoRJbs2LQ0fSb0ibKb4UIbKJ9L2lDAc4Ot7awTmfvssD/TM8DWLMTnbVOJ6BoKc5dbZE/WVmzAWvIXYjDrEhMkfAjtxphiIn1/JjHSJo5Gta9OEb9cMSZorhBEWN3CPnv4wzUsUw+ddJjJpWyjd3usKV5ri9Zm58b/pcz68gCcDm5RqvU6P2TQmfGViluh9qVjoPea7YvwFEAmeRxdIfF2Nb+IJTjuGzpzC6EGtOD2Rhoo3XsMb4hYZSqS+PqfrmjVJuNM73ecsK0HGnNLNP5B3hZIkvy69l634wnR5LqPkGMTtYNfRGyTejgLIDI9Qap1UFbVOsN4C1npRXzfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UppUIdAOFx0Viz0/HWQ5mdjEx8xCAbThMCG58c8GLXc=;
 b=0GpkH1qlBBIfwvzgQtVwGxl3YNIjN17ULCvnfslDS69O11aYvY14+LSdJncZvxU2ssQUDCmL9+zwtAapI/D4uXzuXrgD3rGRTFWbRzsFvXFkBFUoWkvF+xOS29g+CEJJ8wIZRZEwbUU4MPsgVwr6t2+A9u7l+2f9tk717iFsjUc=
Received: from MN2PR02CA0026.namprd02.prod.outlook.com (2603:10b6:208:fc::39)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 22:32:59 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:fc:cafe::f1) by MN2PR02CA0026.outlook.office365.com
 (2603:10b6:208:fc::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 22:32:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:32:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:32:56 -0500
Date: Wed, 20 Mar 2024 17:32:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v3 37/49] i386/sev: Add the SNP launch start context
Message-ID: <20240320223244.5i7xufnc6u5wyvox@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-38-michael.roth@amd.com>
 <366370f2-3d2d-4d14-81db-11fddadc2f24@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <366370f2-3d2d-4d14-81db-11fddadc2f24@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ee24cd-5ec2-420a-e36b-08dc492db12d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+WJnpy7vIlOoPiEjSLgf1CpylOhlnDY715nC4cVs+NHKBsycw0/S1AGpDiDc9X379Uoq3woyDoYLNExkJEw30WDoKq7JJE2SSvPWtwmbePfpnZDTApQn8seCHv63fFS1uC/FXay3giVLQs3Km3AR5Rnw4AlMxcdDSBtz4tyDpJ7kXoV6inMwEqjsIHoOnuWBokaQL+pg144AJbAucgS8dyMRleBprLiMk47MmwFwDlRxvN1u5pMEAftwSHcTc466hpdkr9dvJfKSdOp0B1P1aKt05wt8LD9sNVfQHDlIyi9zZkFflo4IxfFx48DeRleI7CxYQ1wVEsUYvEkcmNfC9WJixyZ0uLuXfBlKXSN1jLBcsIBI7OPt3sZGh4x+moY5AxwAiW0SUYZx8lqif68E20qhqwwqsANPtEkm+H5XwWvMeo02+kOKUYkJN6iQDJT671SUIBs4ct/Yj3EB+6VqeIjKcnew1o123eID+4xP/TIczKzM6pEs8cFBJuGvbziDPM4aPzWFpYI903rDgrPjtcp76AXywpOyjAg0mg8rHg2IeHz4qHuHwbL/OAdPo5XhDaoxxoLDDQcYMaHuFDqFx/0Rj3lE780T1eA/pKwYquLwGqktlPhbUWqzmUJshOang977v4P3rBssQ2fEiqPboABqBEbQVuHw5SG0+WB8YmQtQjcQrpwDFlRWn2aXn3WKrw5M/iaJkOGYosgXSyHWBOFw3X3oMLK4Siek9e/WzkAQRzYG9LLjm0l8b4Bpn0pn
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:32:57.4229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ee24cd-5ec2-420a-e36b-08dc492db12d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321

On Wed, Mar 20, 2024 at 10:58:30AM +0100, Paolo Bonzini wrote:
> On 3/20/24 09:39, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The SNP_LAUNCH_START is called first to create a cryptographic launch
> > context within the firmware.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >   target/i386/sev.c        | 42 +++++++++++++++++++++++++++++++++++++++-
> >   target/i386/trace-events |  1 +
> >   2 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 3b4dbc63b1..9f63a41f08 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -39,6 +39,7 @@
> >   #include "confidential-guest.h"
> >   #include "hw/i386/pc.h"
> >   #include "exec/address-spaces.h"
> > +#include "qemu/queue.h"
> >   OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> >   OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> > @@ -106,6 +107,16 @@ struct SevSnpGuestState {
> >   #define DEFAULT_SEV_DEVICE      "/dev/sev"
> >   #define DEFAULT_SEV_SNP_POLICY  0x30000
> > +typedef struct SevLaunchUpdateData {
> > +    QTAILQ_ENTRY(SevLaunchUpdateData) next;
> > +    hwaddr gpa;
> > +    void *hva;
> > +    uint64_t len;
> > +    int type;
> > +} SevLaunchUpdateData;
> > +
> > +static QTAILQ_HEAD(, SevLaunchUpdateData) launch_update;
> > +
> >   #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
> >   typedef struct __attribute__((__packed__)) SevInfoBlock {
> >       /* SEV-ES Reset Vector Address */
> > @@ -668,6 +679,30 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
> >       return 0;
> >   }
> > +static int
> > +sev_snp_launch_start(SevSnpGuestState *sev_snp_guest)
> > +{
> > +    int fw_error, rc;
> > +    SevCommonState *sev_common = SEV_COMMON(sev_snp_guest);
> > +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> > +
> > +    trace_kvm_sev_snp_launch_start(start->policy, sev_snp_guest->guest_visible_workarounds);
> > +
> > +    rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
> > +                   start, &fw_error);
> > +    if (rc < 0) {
> > +        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
> > +                __func__, rc, fw_error, fw_error_to_str(fw_error));
> > +        return 1;
> > +    }
> > +
> > +    QTAILQ_INIT(&launch_update);
> > +
> > +    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_UPDATE);
> > +
> > +    return 0;
> > +}
> > +
> >   static int
> >   sev_launch_start(SevGuestState *sev_guest)
> >   {
> > @@ -1007,7 +1042,12 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> >           goto err;
> >       }
> > -    ret = sev_launch_start(SEV_GUEST(sev_common));
> > +    if (sev_snp_enabled()) {
> > +        ret = sev_snp_launch_start(SEV_SNP_GUEST(sev_common));
> > +    } else {
> > +        ret = sev_launch_start(SEV_GUEST(sev_common));
> > +    }
> 
> Instead of an "if", this should be a method in sev-common.  Likewise for
> launch_finish in the next patch.

Makes sense.

> 
> Also, patch 47 should introduce an "int (*launch_update_data)(hwaddr gpa,
> uint8_t *ptr, uint64_t len)" method whose implementation is either the
> existing sev_launch_update_data() for sev-guest, or a wrapper around
> snp_launch_update_data() (to add KVM_SEV_SNP_PAGE_TYPE_NORMAL) for
> sev-snp-guest.

I suppose if we end up introducing an unused 'gpa' parameter in the case
of sev_launch_update_data() that's still worth the change? Seems
reasonable to me.

> 
> In general, the only uses of sev_snp_enabled() should be in
> sev_add_kernel_loader_hashes() and kvm_handle_vmgexit_ext_req().  I would
> not be that strict for the QMP and HMP functions, but if you want to make
> those methods of sev-common I wouldn't complain.

There's a good bit of duplication in those cases which is a little
awkward to break out into a common helper. Will consider these as well
though.

Thanks,

Mike

> 
> Paolo
> 
> >       if (ret) {
> >           error_setg(errp, "%s: failed to create encryption context", __func__);
> >           goto err;
> > diff --git a/target/i386/trace-events b/target/i386/trace-events
> > index 2cd8726eeb..cb26d8a925 100644
> > --- a/target/i386/trace-events
> > +++ b/target/i386/trace-events
> > @@ -11,3 +11,4 @@ kvm_sev_launch_measurement(const char *value) "data %s"
> >   kvm_sev_launch_finish(void) ""
> >   kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
> >   kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
> > +kvm_sev_snp_launch_start(uint64_t policy, char *gosvw) "policy 0x%" PRIx64 " gosvw %s"
> 

