Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE069D275
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjBTSBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBTSA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:00:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0C01EBDC;
        Mon, 20 Feb 2023 10:00:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2t0cSkFTaKraxp7LQk2+/9KVm5c3cW3TdDhu9ooCxkB8U16R4po53u+yV85gA7+bYEa53ZeXi2q8s6l96ZSugXslVun8I0cFk26EWIxdeFtGyxdf3++O9Qt6H+D3mO0NS5gHsgKZfNpR7toKuMEvKFT6/evSKz4jM2wIp6p27KW4kl91lPaVBRHBUJ9RxZKe9j2DPF3WWRhk6e3IylsgjrjatmRzy5s/pwOrfJe/SQ6UMvLTHJRoQvs6mOaAQe8USIIvDekLCyF51tnb/HhMxTESJi4prQrMm/nnrTUf6vjbaNO7axR9uAARMCRomc989t3qB/NkrUd7joKXU3oQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uk+LWUxY6+CTC9e6M3h1dBX3qjS69sBQa4Z/Xa+IYiU=;
 b=jH3G+ba10TXy4Op7kFJUX90HH3SH4OGu6rUvp7EATLVgFCofPCDL5dAcWqOVQr0R9Hb7VLN90A/wmP1suHpgLXoxTVZg6eHH1Glmf2IpG/rVyWmgLJ04nxMQ9GKvj0zHSFTNn2nmPTw6unei50iH80uiqgMF3qGhMSvqx/9hJLZjdPlqmncuiD+fZOVZf387e7UJnteNBiIg1aQCwph5kdDyyzZYCHe30URyHmh+XpVN2Xto4l4g3YY7iOsO4QvIfh6d5vzUQesiSd/BbIYLIgGoD9D40c9QtsskDKYnGce54Nz4CcmOUI2if7fK/VVAobfzpwznScK5fLd5lom4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uk+LWUxY6+CTC9e6M3h1dBX3qjS69sBQa4Z/Xa+IYiU=;
 b=OWbq2No/Drnb+ADMVMVSHw3MWhiTO9FkNy8G5boBueOxUkhanVdTNfIr5tm7JXwtInMEt0Rb2MzO0FW3sq0su7X3C2IBqpq1WjybDhczWGGiMvTvFaQR6lGzpvLEMGRbqSfqBjxTCAUXn6M9OpNr+HAWe7TUq39UIjcvp8NxYHw=
Received: from DM5PR07CA0051.namprd07.prod.outlook.com (2603:10b6:4:ad::16) by
 BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:00:53 +0000
Received: from DS1PEPF0000E64A.namprd02.prod.outlook.com
 (2603:10b6:4:ad:cafe::f3) by DM5PR07CA0051.outlook.office365.com
 (2603:10b6:4:ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:00:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E64A.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:00:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:00:52 -0600
Date:   Mon, 20 Feb 2023 11:49:44 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v7 10/64] KVM: SEV: Populate private memory fd during
 LAUNCH_UPDATE_DATA
Message-ID: <20230220174944.upvvaepvb4h6sat7@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-11-michael.roth@amd.com>
 <Y8Gs0l1k4L96dP5V@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8Gs0l1k4L96dP5V@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64A:EE_|BL1PR12MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: 1edee287-ad2d-4d04-8cee-08db136c6841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwcVXbfkwnJZxpx6ImoZc9T3d2xRTSlzPhw+lqvmRU4LQcEhpA1yOB9JYFAGviPwdlmLhguWQ4v6esPR8jzW/TTbjjTmP6NCi0ED7gPPLZI23uC0/e3MqruigfSbUeuiIHl86WQDYQwAs+B76cHYeU8sMccrh0bHj/P9L/40EWSfYk6dh81LF6HcDqpdWKcqrZ4GEt+4BB4ZkMfp6hMC97XJPgeErUSd3fVgBwgAlBWubCh2rfcX513idTy0rKHVGmpJ20hMf23oPtpf+ycria3XzBBU+g8hnyNXyodg/4t5caISEJBn5U/2cgl/XOdWzzUWS4VrhctrCmybzsXKmpgwRIcKbDldzgmhuFvtxc09fI/KYIiMtKxMOOqzoGl0OIC/2fiN77Q1YzvpDo9R4ScOmB3CYDpBDVjOTQdDFDNulBMKoyIze7j10qRNNoPbjIKXmKDb4YKFCy5mOE1Y/0vwW+DtGoIHY4yCjRAtEDf8By2b0by025BeoFtJsRd+N36wGVwOfV9IHoS5F3sltxl97o6UVgET3EzNa7zb2HAGuIc64tkYpDazHLyM0J+vrHVEKnjgSw2ddtgNX21evIpUAXM8AwTbD6bXRwib8EqTsdz9Rca8Q2GISstrYjgbLKHS6Vgvsr6ceDWSqmcYASkWFG445o/Qv0DUG5gStdATr+T8/oPOMX+uEuRdvwH5kfcbfCx90ahVqa3zui6YFOuJFKiSoE/3PTcEYB0h+J/9zlw2MtEjWQWrNuQn9LaRc6NJZtaIxr6fJ/MMBFN6/w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(16526019)(40460700003)(5660300002)(83380400001)(8936002)(7406005)(7416002)(41300700001)(426003)(47076005)(86362001)(44832011)(70206006)(4326008)(966005)(70586007)(6666004)(186003)(26005)(1076003)(2906002)(316002)(8676002)(6916009)(336012)(54906003)(2616005)(478600001)(356005)(36860700001)(82310400005)(36756003)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:00:52.8485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edee287-ad2d-4d04-8cee-08db136c6841
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 08:11:14PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:40:02PM -0600, Michael Roth wrote:
> > From: Vishal Annapurve <vannapurve@google.com>
> > 
> > This change adds handling of HVA ranges to copy contents
> 
> s/This change adds handling of/Handle/
> 
> > +static int sev_launch_update_priv_gfn_handler(struct kvm *kvm,
> > +					      struct kvm_gfn_range *range,
> > +					      struct kvm_sev_cmd *argp)
> > +{
> > +	struct sev_data_launch_update_data data;
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	gfn_t gfn;
> > +	kvm_pfn_t pfn;
> > +	struct kvm_memory_slot *memslot = range->slot;
> > +	int ret = 0;
> > +
> > +	data.reserved = 0;
> > +	data.handle = sev->handle;
> > +
> > +	for (gfn = range->start; gfn < range->end; gfn++) {
> > +		int order;
> > +		void *kvaddr;
> > +
> > +		ret = kvm_restricted_mem_get_pfn(memslot, gfn, &pfn, &order);
> > +		if (ret)
> > +			return ret;
> > +
> > +		kvaddr = pfn_to_kaddr(pfn);
> > +		if (!virt_addr_valid(kvaddr)) {
> > +			pr_err("Invalid kvaddr 0x%llx\n", (uint64_t)kvaddr);
> 
> Is that some debugging help leftover or what is that printk issued for?

A mix of error-reporting and debugging I think. I think the error message
isn't needed since the error value will get plumbed straight to
userspace and anything beyond that is kernel debugging, so I added some
context and switched this to pr_debug().

> > +			ret = -EINVAL;
> > +			goto e_ret;
> > +		}
> > +
> > +		ret = kvm_read_guest_page(kvm, gfn, kvaddr, 0, PAGE_SIZE);
> > +		if (ret) {
> > +			pr_err("guest read failed 0x%x\n", ret);
> > +			goto e_ret;
> > +		}
> > +
> > +		if (!this_cpu_has(X86_FEATURE_SME_COHERENT))
> 
> check_for_deprecated_apis: WARNING: arch/x86/kvm/svm/sev.c:602: Do not use this_cpu_has() - use cpu_feature_enabled() instead.
> 
> > +			clflush_cache_range(kvaddr, PAGE_SIZE);
> > +
> > +		data.len = PAGE_SIZE;
> > +		data.address = __sme_set(pfn << PAGE_SHIFT);
> > +		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_DATA, &data, &argp->error);
> > +		if (ret)
> > +			goto e_ret;
> > +		kvm_release_pfn_clean(pfn);
> > +	}
> > +	kvm_vm_set_region_attr(kvm, range->start, range->end,
> > +		true /* priv_attr */);
> 
> No need to break that line.
> 
> > +
> > +e_ret:
> > +	return ret;
> > +}
> > +
> > +static int sev_launch_update_gfn_handler(struct kvm *kvm, struct kvm_gfn_range *range,
> > +					 void *data)
> > +{
> > +	struct kvm_sev_cmd *argp = (struct kvm_sev_cmd *)data;
> > +
> > +	if (kvm_slot_can_be_private(range->slot))
> > +		return sev_launch_update_priv_gfn_handler(kvm, range, argp);
> > +
> > +	return sev_launch_update_shared_gfn_handler(kvm, range, argp);
> > +}
> > +
> > +static int sev_launch_update_data(struct kvm *kvm,
> > +		struct kvm_sev_cmd *argp)
> > +{
> > +	struct kvm_sev_launch_update_data params;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> > +		return -EFAULT;
> 
> Not gonna check those user-supplied values for sanity?
> 
> Or is this check
> 
>         if (WARN_ON_ONCE(hva_end <= hva_start))
>                 return -EINVAL;
> 
> in kvm_vm_do_hva_range_op() enough?

Only partially, but kvm_vm_do_hva_range_op() should sanitize the address
range and only call sev_launch_update_gfn_handler() on valid GFNs within
the range, so if userspace provides a bogus HVA range that doesn't
actually correspond to a valid memslot it'll simply be treated as a
no-op.

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
