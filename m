Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5995A78C546
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjH2N2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 09:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbjH2N14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 09:27:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255D01B1;
        Tue, 29 Aug 2023 06:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idZ7R4ao+saj6J59KwHSZxybab/cpepFu0IwWRbj/BRTNeUYMOpg/rtWzTtd1IXG8kmNcydjWIsw6lMijeoaPYhtGdS81ZoMAMnHSOcK/ysqXui1CBxeGtjZt+XWvozl5s8KJTbC6OfQskp/ExZjqSP4M25zkaDODkVRLAegcgUYx25/ry0EJ5kcmRKr0SBuAqWV2hwPQQxlLq8WmTEFb4f4akEsYFM2iE8l3Tau4L4Dfa4rc2iDDSks9rk7mqbOBUqmp636KCI+3wW/wBKo8dk5k4xMxkopvoYN0ayF84R2tanIo+6/ADEvQWgGUpVAPuIIWNBEF79sTaXFaJD4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+YxQhsq7uavrhKbMGzW08VIgXiItwTmtZqMBv6LwJg=;
 b=lqJTyJ6aj1xWsCnyDI8zyzYet1mfiv0mD6t4v5vMNgvFeDCMH10IxmkPHjmeAh996LQGaBNjAKJ6bEseBE1DWFZq6TIhHwOI7NUT7g8+hjKw9CMg3WHDXXSHBfYMw67HZhsTim6myI6yKW48m3Tmxn8eLvwggrHLaQq1x5InP4dEKDN5NiLnAsrrEfH91YJXzkEasoR7FbPXLyrZeGOqqpD4XVeacxY1kGnsjYxRZhFh/e8Y+YFKM/TLT+7zFp35+vQgL3e+P+ZJJarNA2hDpTJwGUPmYT7S04EfBA9XDkULLpkvek5e+twGe8jlvjdfkLZV5IdIvjP4BiKSkqgR1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+YxQhsq7uavrhKbMGzW08VIgXiItwTmtZqMBv6LwJg=;
 b=De3gGTifCSxCk+AIPz8HjbH4nMlpIYOw9rTLEg8qh6xVvXPJAWwSMtT9QL87ADTxeatjnnmbxe8u8UeQQEA7cHOqy1LrR+tlpa3zY4qEjtt/2EMS84PlxzvYggunQKT8tK5qzGgnP1YMNs8ZWV7zlVrXNbthkQjAt4ssLNzBr2I=
Received: from SN6PR04CA0080.namprd04.prod.outlook.com (2603:10b6:805:f2::21)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Tue, 29 Aug
 2023 13:27:46 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:805:f2:cafe::ff) by SN6PR04CA0080.outlook.office365.com
 (2603:10b6:805:f2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18 via Frontend
 Transport; Tue, 29 Aug 2023 13:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6745.17 via Frontend Transport; Tue, 29 Aug 2023 13:27:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 29 Aug
 2023 08:27:43 -0500
Date:   Tue, 29 Aug 2023 08:27:27 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <erdemaktas@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, <chen.bo@intel.com>,
        <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        "Vishal Annapurve" <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>, <David.Kaplan@amd.com>
Subject: Re: [RFC PATCH v4 07/10] KVM: x86: Add gmem hook for initializing
 private memory
Message-ID: <20230829132727.ne5xzb7uv2wnrjif@amd.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
 <21e488b6ced77c08d9e6718fcf57e100af409c64.1689893403.git.isaku.yamahata@intel.com>
 <ZLqVdvsF11Ddo7Dq@google.com>
 <20230722003449.664x3xcu6ydi2vrz@amd.com>
 <ZN/wY53TF2aOZtLu@google.com>
 <20230826005941.c7gtsootdaod7ek3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230826005941.c7gtsootdaod7ek3@amd.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: b338a12e-06d5-49f2-6d36-08dba893bb22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNV/d9RULShN19rFJyW9wPgnmNhvINmCli9921olOULc7/+oRHp5BYyUFovNR7//r1xz/qm/dxeQr+5b48rowQ3rnyCZaZUNlCZoMueIKL66zNPnSnLF2f5t49AGC9VyeCZvBDEc6FW4bEtSaf9GNAv8lEjFgB3+7QA268vMEuS8Oh3URQ2Ql8xxW9n3ELgnwnKVQeMH4nJUlJUCpr+imWmpqMEtcAfjEy4msa87ZVWZE5wFWiQAIUsQpVbFOKqrgzSQode7ntr7mvvJBUe+Dg+k2q6nchW7ebfIAEZJVhSxphuPIF8JDh7fxFMMWauKJO8VgmbpneFvO6UkOIzSUCRXX5Iudg1G0CgEzBj9F4cAOOrEdgVaSo1ab88R5NqPar+PWUzG37ZBnSCQPJiy6TZKCMKdElC3zulMG4gqHNt/MMnq8w+wNMePsUR15zBvK0Der7lUb8XYZ2KvvGjektPVwVRchnjosM1bOA7sI1n8uwleXpJ+aAJV4da7cmaKsI/cstpMAVNNAVXQcV+lOj6UQYt+W/ZUis6iaqNcBeddciRXVI6ouLLBhYSZdwE4m9N3Prft+btOImfUFZVTbdH4L5geW8+c9mQOsIc+z8N/BdIEkCJE0QoQI0xyeujs+V3H735VVdMoi0SbjQ3p6XvZZCVLflRBy0SeRCoDoCYlNyohm2wZDnO1JKyf/SSEiu0B0ZZO63GFYQNlNslblkC0LMCt3OAqsbHZABOCzqli9Ii/fFYyYbQbgHRGfHwskT07Uf7ONhtgMTBi54kJAw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(396003)(39860400002)(186009)(1800799009)(82310400011)(451199024)(36840700001)(46966006)(40470700004)(36860700001)(41300700001)(40460700003)(66899024)(7416002)(16526019)(356005)(81166007)(82740400003)(6666004)(86362001)(83380400001)(478600001)(47076005)(426003)(26005)(2616005)(336012)(1076003)(40480700001)(70586007)(70206006)(54906003)(6916009)(2906002)(36756003)(316002)(5660300002)(4326008)(8676002)(8936002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 13:27:45.5686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b338a12e-06d5-49f2-6d36-08dba893bb22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 07:59:41PM -0500, Michael Roth wrote:
> On Fri, Aug 18, 2023 at 03:27:47PM -0700, Sean Christopherson wrote:
> > This seems like a bug in the SNP code.  (a) why would KVM/SNP PSMASH in that
> > scenario and (b) why can't it zap/split the NPT before PSMASH?
> 
> a) A PSMASH will be needed at some point, since, as detailed above, the 4K
>    NPT mapping requires the RMP entries for the pages it maps to be
>    limited to 4K RMP entries, but...
> b) What would happen normally[1] is the guest would issue PVALIDATE to
>    *rescind* the validated status of that 4K GPA before issuing the GHCB
>    request to convert it to shared. This would cause an
>    #NPF(RMP+SIZE_MISMATCH) and handle_rmp_page_fault() would PSMASH the RMP
>    entry so the PVALIDATE can succeed.
> 
>    So KVM doesn't even really have the option of deferring the PSMASH, it
>    happens before the SET_MEMORY_ATTRIBUTES is even issued to zap the 2MB
>    NPT mapping and switch the 2M range to 'mixed'. Because of that, we also
>    need a hook in the KVM MMU code to clamp the max mapping level based
>    on RMP entry size. Currently the kvm_gmem_prepare() in this patch
>    doubles for handling that clamping, so we would still need a similar
>    hook for that if we move the RMP initialization stuff to allocation
>    time.
> 
> [1] This handling is recommended for 'well-behaved' guests according to
> GHCB, but I don't see it documented as a hard requirement anywhere, so there
> is a possibility that that we have to deal with a guest that doesn't do this.
> What would happen then is the PVALIDATE wouldn't trigger the #NPF(RMP+SIZEM),
> and instead the SET_MEMORY_ATTRIBUTES would zap the 2MB mapping, install
> 4K entries on next #NPF(NOT_PRESENT), and at *that* point we would get
> an #NPF(RMP) without the SIZEM bit set, due to the behavior described in
> the beginning of this email.
> 
> handle_rmp_page_fault() can do the corresponding PSMASH to deal with that,
> but it is a little unfortunate since we can't differentiate that case from a
> spurious/unexpected RMP faults, so would need to attempt a PSMASH in all
> cases, sometimes failing.

The spurious case here is when the guest is accessing a private page
that's just been PSMASH'd by another thread. I thought these might still
occur before the PSMASH has completed so we'd still potentially see the
page-size bit set in the RMP entry, but the RMP faults only happen after
the PSMASH has finished, so the spurious cases can be filtered out by
just checking if the page-size bit is set before attempting a PSMASH.

> 
> gmem itself could also trigger this case if the lpage_info_slot() tracking
> ever became more granular than what the guest was expected (which I don't
> think would happen normally, but I may have hit one case where it does, but
> haven't had a chance to debug if that's on the lpage_info_slot() side or
> something else on the SNP end.

Turns out that was for a case where the shared/private attributes for the
2M range really were mixed at the time of access. In this case it is
when OVMF converts some shared memory to private during early boot: the
end address is not 2MB-aligned, so it is in a mixed region, and the NPT
mapping is 4K, but the RMP entry is initialized as 2MB. In this case the
PVALIDATE and NPT agree on the 4K mapping size so the SIZEM bit isn't set,
just the #NPF(RMP).

So we need to be able to deal with that even for 'well-behaved' guests.
With RMP-init-during-mapping-time approach I had some checks that avoided
creating the 2MB RMP entry in this mixed case which is why I didn't need
handling for this previously. But it's just one extra #NPF(RMP) and can
be handled cleanly since it can be distinguished from spurious cases.

-Mike
