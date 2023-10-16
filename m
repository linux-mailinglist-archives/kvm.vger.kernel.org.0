Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AABD7CAC83
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbjJPOzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbjJPOzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:55:47 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89ABEA;
        Mon, 16 Oct 2023 07:55:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJw91vbBA4nVVDqeXRU+H2HpZcXSwYpwkbYzf+0PeiCv9cemEqstq1TBe8/mPWyUCT87c9urmZw/Q+Gz9/X10AP/NQDkORiAzu98PNrDgoYNVb1DYhph+QR4tvHmGOHNXQIYjb8NI8I+RjKlNIyzOLtLTkUkbW80FDUsTqebiDKga2mpf+dh40eyjhmZFw6VpcDg+kqnN/YUSgBdGwfRSs+rr6ZZx8amvQHxRAfdMzs54DW7ShMXbJ2qqQSXWoMAr1R8teYc6M40t2qMzcYgEkPh44traim9cDuOOXQ4JOs0e4MKmz5BxB03ZXjHy8WTYl9kzVVrIZr5E9V1VG1moA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBRF+yaHlkQdPZYDrNYvy8tbtuS7WfnC5aXllUVOfoA=;
 b=BrYnm/+2K4mk9B1G8mbcyobrvGaioZzexhnO/RhT5FQM3lPt50UhGwVcyfJpmDFVZexltbi6qFH9qRnhgAhxJV+IwH6Ztt2M9l9bD0fQTNjVTdg00TQJKIlBnPTpkH7H6hNHil8ECYYYB6X19+bAwNNU+Nt1SiV4M8Gx4iLNm7GJzTSM0wqKjLp7Vj4zk1mWz2+nkI+Oyh3HdcSST27fOQki/oec6RWAPdIsJR9KGNGhcJe2GItgxzEHueAnw/aYuT7PwkF9jam89uVzA8fEF4SW+2z6jp+MgIHN6G57BdImSaXYYzm3t+Cqwl/fFPdRK4DzFT5VU4vO6Y7aFQh9zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBRF+yaHlkQdPZYDrNYvy8tbtuS7WfnC5aXllUVOfoA=;
 b=c2WWQISvN9nIRd/BMft01V+18WWROI0H5iZqbx6eB2xu36vX4vWJlExZ+shrqeToz+TBSQ2wlF7fJ/Nm4yPM6o788zcV/AJ6uRnro4CtAPOYdyKi9Jb3j+i+hnZ++sHgmWVdgvABZK8bV+GBWQfiahZFyojsUKWX3uUqD4iv5Uw=
Received: from CH0PR03CA0247.namprd03.prod.outlook.com (2603:10b6:610:e5::12)
 by DM4PR12MB5038.namprd12.prod.outlook.com (2603:10b6:5:389::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 14:55:37 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::dc) by CH0PR03CA0247.outlook.office365.com
 (2603:10b6:610:e5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 14:55:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 14:55:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 09:55:37 -0500
Date:   Mon, 16 Oct 2023 09:55:18 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 09/50] x86/traps: Define RMP violation #PF error code
Message-ID: <20231016145518.6vlhsbh5cr2wfzuw@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-10-michael.roth@amd.com>
 <1976018d-7173-49b3-9285-38cfa570d573@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1976018d-7173-49b3-9285-38cfa570d573@intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|DM4PR12MB5038:EE_
X-MS-Office365-Filtering-Correlation-Id: 165e2bc5-b573-412e-2f49-08dbce57f553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: doAsCouF/lvybte70wjqPEZJTmcmjKOe1oGgdT9KsndiwUdp3Ytn8IimglThwrS58RyPDAlqHdOZUO6bMVyQIdW7MZj7vP8ccv2N9h1O7+FjVHCgeniSjUXzEFfeXTQOM1NKrzFPXvcGvzvHtok1Llg3I2u/okBX9OyJY3Zb1VJgfROul4dpwMVU8Podw2NNM4/uIHzQaYmelyGqd3KhsOwijUpBU9xlh/WJO39Rjgr21RneFLu7xLYAUWVeOhpailBYcB7Zfn1aI3r7vszSaOpvYnGNeyiFBz0EARf7Y2gUiO7vezEgNfM904rfxIC+6vqCamhI+F8n63ymgrU2N6FqgWuKkXozmRslcUK7nQgAaGgxHgZHIZj2IjQ/zejIRDHdSu1t2UKSqCqBKly8o+S2PUJYPmL9XG8mrRHsDTKYYJiAthkhsy61BFDnf51ZhfQFdHXUG/kB6plqeXFZCjZdBomkeKgziUI+1OR8ZJ8Md3GSsl6jN4db/P4XklbFnQX1+E7UrRmR28QoKngq/gh3Zd9iAXwDxHBM8tyZUgNLvct4PY7GVYXZh0O4pkUG9CBGXjFKFBZnvm3IGSG/IA/Rw3+fbI2NSdoklYJDMKB7NWXjx+rDBKD44xWbofB9noRG8Auqn81l6wylN0BNLq/bPNcTqXkmppXtEzJPhvxj9jNzG4wFsM4HEsxvPA2hSZj2RW6V0AqOB0qSkv71w4fgvj2NxamIZXT/0LxwqT5I3zcOcMtWp0qsiYmDK4HsRQ5L6YY5W7AZGoljqqFT8A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(1800799009)(451199024)(82310400011)(186009)(64100799003)(40470700004)(46966006)(36840700001)(47076005)(40460700003)(36860700001)(6916009)(316002)(53546011)(54906003)(70206006)(70586007)(478600001)(5660300002)(8676002)(8936002)(4326008)(86362001)(6666004)(2616005)(7416002)(7406005)(4744005)(41300700001)(44832011)(2906002)(40480700001)(16526019)(82740400003)(81166007)(1076003)(26005)(426003)(336012)(356005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 14:55:37.5623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 165e2bc5-b573-412e-2f49-08dbce57f553
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 07:14:07AM -0700, Dave Hansen wrote:
> On 10/16/23 06:27, Michael Roth wrote:
> > Bit 31 in the page fault-error bit will be set when processor encounters
> > an RMP violation. While at it, use the BIT() macro.
> 
> Any idea where the BIT() use went?  I remember seeing it in earlier
> versions.

Yah... this patch used to convert all the previous definitions over to
using BIT() as part of introducing the new RMP bit. I'm not sure what
happened, but a likely possibility is I hit a merge conflict at some
point due to upstream commit fd5439e0c9, which introduced this change:

  X86_PF_SHSTK    =               1 << 6,

and my brain probably defaulted to using the existing pattern to
resolve it. I'll get this fixed up.

-Mike
