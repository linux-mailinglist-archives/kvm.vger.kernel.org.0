Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011F25843C8
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiG1QGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiG1QGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 12:06:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0F26E2CC;
        Thu, 28 Jul 2022 09:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqUjV5XStr/G7S1i4uPEuw6GX45pmWP76hyRN6LimyP5X4a6ILamLFMay5PlJSO9X1CfgKNkyJCmMGjWX7sDYfixCGIapPimznOTGKC7Lh9BT2QZ90h/maq+nejQPtfNSw+3CNjuzcmEzKUANjxaOubVbsagXZK410EyTjyg0UA02WwwYQyxUeThRDoPZGPUKTaDaZmnQbGshpDNiVWGkDzXJ92W3kidIF8G6WkXgWb+6bmfcG61HsY0hlTfOG0MjyayJY6zMP66NyxEIwtRXFwUsXIS+YoEM8T51dvU9lXt3T436WTvPRKG7MvS2rGfYHdpPJ9lxZRiWbENg5ME4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmhhD5GnstIgIem51n2kn76lSD3i56dhVwrpTMo2CPY=;
 b=HEM8s+zkP/5jJN8RlJCgnhSsK1ismEQjxLC4KK5sa0qld4yIdQ78dJ9yNBmVD2A7MbJEC7tTQZOgibBNlnFz1K5/qQHJ+jMSIbWPSUlzy/Y6aALu0abTuaaOCfxNxjTZs/T05k/dsTynrASchBqTHzVjYbFvUzr7WJaHE4gQ3Mp+xW3Ph3mDCFAlqIHMCXp/qtma5SXDdcKlybNxj2kSbT39GaueUHEtpYvmKQhCiWtywFL01rbfDeDLJBlUswNxO36T61vxfpG42mo44UnzD34fng/aEyY2NGkPO6X8r+sGnebw1krU1+2QUrwzQJeHFa8FVnk7zY+QKlkY+tMXKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmhhD5GnstIgIem51n2kn76lSD3i56dhVwrpTMo2CPY=;
 b=dRtLeqMCIYpmSHnMnW8Ttk0gwmTCRWtCscwBPBg+p6HyIJ1dkoJlLqmuAEGcpDKS0EK3gOIXt4kfOSrThMC2B+cGjtLFhO3rOabvJT9pIG/wFW2F9J+Z/6q7SyWmGJYilCe99L3jm+rHl8SJu931PGNpmtG6k4dF8nC8G+C1rho=
Received: from MW2PR2101CA0022.namprd21.prod.outlook.com (2603:10b6:302:1::35)
 by CH2PR12MB3719.namprd12.prod.outlook.com (2603:10b6:610:2c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Thu, 28 Jul
 2022 16:06:36 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::b5) by MW2PR2101CA0022.outlook.office365.com
 (2603:10b6:302:1::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.10 via Frontend
 Transport; Thu, 28 Jul 2022 16:06:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 16:06:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:06:29 -0500
Date:   Thu, 28 Jul 2022 11:06:13 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Possible 5.19 regression for systems with 52-bit physical
 address support
Message-ID: <20220728160613.uwewpxdqdygmqlqh@amd.com>
References: <20220728134430.ulykdplp6fxgkyiw@amd.com>
 <20220728135320.6u7rmejkuqhy4mhr@amd.com>
 <YuKjsuyM7+Gbr2nw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YuKjsuyM7+Gbr2nw@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01a6de37-86a9-4c95-5f69-08da70b325e4
X-MS-TrafficTypeDiagnostic: CH2PR12MB3719:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFyH2cji3oLmeMl4axMtcpxM6plGsV/AetqpiSdfm+1aM2+7HFl0Qh40CYFkVHbyYeodOkuIgSnbLA7tsqbiPBMKqveI1OlJsnKQ36QRJq5qPsYZ/wSvQ06zMy757vOjueTpn+CuuyUqw3WhewQ0TdnLJbP0ejd5muUQiryDu7V6uh85zGzpmBsV1BSChqXxtRZBsfYkkh1xqhACKSOFow7zz5tJEViD9F9EwHR03AypkSTzCLt6+QVIq+SB29obOToQ8ngzLBn/NhU4pYjJEUBSuxF4tiSxLg1pSRtOJstDUG9JTn8i7I25RS+VEQqTwfpm2ycUofxZpigv+JNCdJcUlsLg5JQFrwswcUanf7y1bfiy+c8IBXPvBzRBgzgRLvjYCnPEwmDRPwbPVbA/aXPaKFyapP9tn2priSE0QSsUF3Dbb0OFpAxo4Qwy134gqx/ZOd95Tv2A52IegqWyCsmQ/nmC3cM5c0LuM1qG79toDVXNIoUAteMM12dccmbzvVHbcUEioI8/pg4YDuAn/7aR2rtEIiKOcvN9VVA7FWrsVohJvmUQz3WzNWR921phI67DHivIgZxnN7FGxYRXIVhldCw+BgNG33N5/Wz97rQAsXYSYRE1C2ZZuLLuepYBU3W40vlyUC93NH/AvEn1WpLKVJgnVI0lRDj08KkLiYvr/S5ntXeZaZ4+UNBlwio+uww+I3LX76xkX6XHuvfvjTPY4vQQNyNY0NFiLCt6HKnZTlwu7a6kduxvRYcJGjxjS7Sw4/iIMe7mPnVdjD0sRcniKilDzc648EBUphM65gHqcQyZry33iqhwh2rd/V5cB8aeEvfmXpgwLaCJ8fXFkUennTMw8ju7tukiFtBUGQ0qKEURyXRRZE4rAtk2bESB
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(40470700004)(46966006)(81166007)(426003)(2616005)(47076005)(186003)(356005)(70586007)(36860700001)(336012)(45080400002)(36756003)(1076003)(40460700003)(2906002)(5660300002)(16526019)(3716004)(83380400001)(82310400005)(6916009)(54906003)(966005)(70206006)(4326008)(8936002)(8676002)(40480700001)(82740400003)(41300700001)(478600001)(6666004)(44832011)(86362001)(316002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 16:06:36.1808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a6de37-86a9-4c95-5f69-08da70b325e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3719
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 02:56:50PM +0000, Sean Christopherson wrote:
> On Thu, Jul 28, 2022, Michael Roth wrote:
> > On Thu, Jul 28, 2022 at 08:44:30AM -0500, Michael Roth wrote:
> > > Hi Sean,
> > > 
> > > With this patch applied, AMD processors that support 52-bit physical
> > 
> > Sorry, threading got messed up. This is in reference to:
> > 
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F20220420002747.3287931-1-seanjc%40google.com%2F%23r&amp;data=05%7C01%7Cmichael.roth%40amd.com%7Cb0cbbc83a88e4aca870008da70a96a80%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637946170190371699%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=KUBKPThOGMP36SpN3OCkJKeymkpkh5tK%2BJJv7ExUI6w%3D&amp;reserved=0
> > 
> > commit 8b9e74bfbf8c7020498a9ea600bd4c0f1915134d
> > Author: Sean Christopherson <seanjc@google.com>
> > Date:   Wed Apr 20 00:27:47 2022 +0000
> > 
> >     KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled
> 
> Oh crud.  I suspect I also broke EPT with MAXPHYADDR=52; the initial
> kvm_mmu_reset_all_pte_masks() will clear the flag, and it won't get set back to
> true even though EPT can generate a reserved bit fault.
> 
> > > address will result in MMIO caching being disabled. This ends up
> > > breaking SEV-ES and SNP, since they rely on the MMIO reserved bit to
> > > generate the appropriate NAE MMIO exit event.
> > >
> > > This failure can also be reproduced on Milan by disabling mmio_caching
> > > via KVM module parameter.
> 
> Hrm, this is a separate bug of sorts.  SEV-ES (and later) needs to have an explicit
> check the MMIO caching is enabled, e.g. my bug aside, if KVM can't use MMIO caching
> due to the location of the C-bit, then SEV-ES must be disabled.

Ok, make sense.

> 
> Speaking of which, what prevents hardware (firmware?) from configuring the C-bit
> position to be bit 51 and thus preventing KVM from generating the reserved #NPF?

I'm not sure if there's a way to change this: the related PPR documents
the CPUID 0x8000001F as read-only along with the expected value, but
it's not documented as 'fixed' so maybe there is some way.

However in this case, just like with Milan the C-bit position actually
already is 51, but since for guests we rely on the value from
boot_cpu_data.x86_phys_bits, which is less than 51, any bits in-between
can be used to generate the RSVD bit in the exit field.

So more problematic would be if boot_cpu_data.x86_phys_bits could be set
to 51+, in which case we would silently break SEV-ES/SNP in a similar
manner. That should probably just print an error and disable SEV-ES,
similar to what should be done if mmio_caching is disabled in KVM
module.

> 
> > > In the case of AMD, guests use a separate physical address range that
> > > and so there are still reserved bits available to make use of the MMIO
> > > caching. This adjustment happens in svm_adjust_mmio_mask(), but since
> > > mmio_caching_enabled flag is 0, any attempts to update masks get
> > > ignored by kvm_mmu_set_mmio_spte_mask().
> > > 
> > > Would adding 'force' parameter to kvm_mmu_set_mmio_spte_mask() that
> > > svm_adjust_mmio_mask() can set to ignore enable_mmio_caching be
> > > reasonable fix, or should we take a different approach?
> 
> Different approach.  To fix the bug with enable_mmio_caching not being set back to
> true when a vendor-specific mask allows caching, I believe the below will do the
> trick.
> 
> The SEV-ES dependency is easy to solve, but will require a few patches in order
> to get the necessary ordering; svm_adjust_mmio_mask() is currently called _after_
> SEV-ES is configured.
> 
> I'll test (as much as I can, I don't think we have platforms with MAXPHYADDR=52)
> and get a series sent out later today.

Will make sure to give this a test on my system as soon as it goes out.

Thanks!

-Mike
