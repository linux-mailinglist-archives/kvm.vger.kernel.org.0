Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3262469D278
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjBTSB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBTSBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:01:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9651E206B8;
        Mon, 20 Feb 2023 10:01:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAbVC8rWmNT21/q2TKLAoaVJ3M32Gjfz09SElSI0YsV5kEsY6vWMqQGsePK98iJMwiIctdS8wc2lsWBNwn4uj59vqR3lwhih7kkXnMKntHYkWNWU6ASJL6eKWUtIaLxNuOA8d2vofHohzrA8OxhB3m/+O13jDAfLeWFeJflqq0HBrbGRKVrdtWIqDH5OoH/dCiB4XzrT0EBaHUSu9G3AT41RXl1BtZLIpukbsCfJZLs1nJcDmyQ4jmXabzcpE1Pscqb6MyVbH6tdVJnZpeTZqnew9e2PzFVRT5fV97tqiGucCkB/V/UjRI6QyI2BCA0XUoPw0PvDIf9sDWN/t3wFwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QzvVHs84NeXNdnhtMvLTtCIdp+kJwxEzfAfUtSq8JcQ=;
 b=L5MkxlTgsX0WhqlIW1MzTmbO2dXnXIdhbymCtNANQFWpwZzNUwvHZduurKpm3Xa+9qpKJwOdxcQNEo9HrMMhWIQzEhAcr6nM3qBsGngrMA0EGsiiiFNqwj4S0kN3FD46cISaPXCIVU38KbKdQwAB/hAAIyZaRzPe29PqSa35eQgZbI2bm2mLKMthqXXCOcXAtzOgSjxCDMTSHZBTuiodCwAisuRCdFCIlw3lBbmq82aUqf60Pal9eZ1zQetZdo9nROJx0sLoOPJHp/0bjsWM/YBzjxVG6Caqjtzm1ktI4yomonufqtIqGn9i4CZWhObnhBX1XzVoQL0f7vkBccs3+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QzvVHs84NeXNdnhtMvLTtCIdp+kJwxEzfAfUtSq8JcQ=;
 b=yW5hhV+yVpkDzuTx5vwnVg/SUNs/Vp3dyJTMZ6J75Wi5jS6M+kZgrciF2OF7mNoV5tVDc31Btyw2wqCFLGVFUbhWog8Zyv6OS6VZa2nHqXJ5JIcYCfmjWWiaPBPXEnKFizcvvBkUcm2s/MA5LkVL02qH33iq1En8hjWKdY+84OM=
Received: from DS7PR05CA0104.namprd05.prod.outlook.com (2603:10b6:8:56::16) by
 DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.20; Mon, 20 Feb 2023 18:01:14 +0000
Received: from DS1PEPF0000E64D.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::63) by DS7PR05CA0104.outlook.office365.com
 (2603:10b6:8:56::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16 via Frontend
 Transport; Mon, 20 Feb 2023 18:01:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E64D.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:01:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:01:13 -0600
Date:   Mon, 20 Feb 2023 11:54:54 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
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
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v7 10/64] KVM: SEV: Populate private memory fd during
 LAUNCH_UPDATE_DATA
Message-ID: <20230220175454.baoc7o6agcouavkz@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-11-michael.roth@amd.com>
 <Y8cydYUfTUFwCh4K@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8cydYUfTUFwCh4K@kernel.org>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64D:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 2133662d-7120-4180-0d7d-08db136c74d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBPtTTqgmbqVTCPrvTEHU2RJTuiAehPYOShAya+Ug4p6ZoOSbk1KNU5kRilBGE2lMq/vz88bySvQqe7Du4tHy5MVA9GC5nmW/SmpkVjO+0IkmRQDp1n9mtkoAdjWcFn1VOxvxyKGR0RK8DMf87ke2UL5v2fQQwyQSVi11RXtmTlZRnj4t3PwNCDMxkxLCaZbZdmd2ldXpOTsw1YofMNWiiAdnVwrVSGRJoFlx2SY5SqrNJPK1bejU15fAy+lwt4Oj6T+V+ZkQBs0BQmwoPLiaAZPgyN7m1FNZluuJFkfhM668mmLFf7UBe7jmSJU61914rRufAKVARkFAvKQwruAZWzSshOG0JQfGA/pLnSCKhMfBKuutrRq1S90WIc3VS1YjMipjSghzzFLEVoql6VxIBGkZ+7Lc34HPxI2L//K9udzzNeBS8GYJ0yICM83+fZae18dlp79eNx5oTc/m/IForwR94YqTTQmKz/mFhwRP724/j5KR33l7Vj7IxAsIiYwKjQ4bZlaOV+qq48YoEa88NsxCVY7DCR4ftdmuWrzbfR4Wxo6Fnpznh55DcYgy9NrGmDf4I1dTtgx4+gDVqzZmkrmOqiJTnUdNcuyI9njTIiO5YDVkteq1G82Ua9jcBSsvfTN1iiQRA/y87RnPXYwlUjt/BeKK+jHQespmaAxNlW/Q3Flz15Ra0lEeLyzNlKLVWYj9qB47FGAJJWgqvPsKiOyBZoYBIkxLMRIv2UEmHY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(66899018)(2906002)(44832011)(7406005)(7416002)(5660300002)(47076005)(36860700001)(426003)(83380400001)(8936002)(36756003)(6666004)(186003)(16526019)(2616005)(1076003)(26005)(70206006)(81166007)(356005)(40480700001)(86362001)(40460700003)(82740400003)(41300700001)(8676002)(70586007)(6916009)(4326008)(478600001)(336012)(316002)(54906003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:01:13.9544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2133662d-7120-4180-0d7d-08db136c74d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 01:42:45AM +0200, Jarkko Sakkinen wrote:
> On Wed, Dec 14, 2022 at 01:40:02PM -0600, Michael Roth wrote:
> > From: Vishal Annapurve <vannapurve@google.com>
> > 
> > This change adds handling of HVA ranges to copy contents
> > to private memory while doing sev launch update data.
> > 
> > mem_attr array is updated during LAUNCH_UPDATE_DATA to ensure
> > that encrypted memory is marked as private.
> > 
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > [mdr: use gfn_to_hva_memslot_prot() for shared GFN handler to deal with
> >       read-only slots for ROMs]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c   | 99 ++++++++++++++++++++++++++++++++++++----
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/kvm_main.c      | 27 ++++++++---
> >  3 files changed, 111 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 69dbf17f0d6a..a7e4e3005786 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -493,23 +493,26 @@ static unsigned long get_num_contig_pages(unsigned long idx,
> >  	return pages;
> >  }
> >  
> > -static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > +static int sev_launch_update_shared_gfn_handler(struct kvm *kvm,
> > +						struct kvm_gfn_range *range,
> > +						struct kvm_sev_cmd *argp)
> >  {
> >  	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> >  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > -	struct kvm_sev_launch_update_data params;
> >  	struct sev_data_launch_update_data data;
> >  	struct page **inpages;
> >  	int ret;
> >  
> > -	if (!sev_guest(kvm))
> > -		return -ENOTTY;
> > -
> > -	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> > -		return -EFAULT;
> > +	vaddr = gfn_to_hva_memslot_prot(range->slot, range->start, NULL);
> > +	pr_debug("%s: shared GFN: %llx, slot.id: %d, slot.base_gfn: %llx, slot.userspace_addr: %lx, slot.flags: %x, vaddr: %lx\n",
> > +		 __func__, range->start, range->slot->id, range->slot->base_gfn,
> > +		 range->slot->userspace_addr, range->slot->flags, vaddr);
> > +	if (kvm_is_error_hva(vaddr)) {
> > +		pr_err("vaddr is erroneous 0x%lx\n", vaddr);
> > +		return -EINVAL;
> > +	}
> >  
> > -	vaddr = params.uaddr;
> > -	size = params.len;
> > +	size = (range->end - range->start) << PAGE_SHIFT;
> >  	vaddr_end = vaddr + size;
> >  
> >  	/* Lock the user memory. */
> > @@ -561,6 +564,84 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return ret;
> >  }
> >  
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
> > +
> > +	return kvm_vm_do_hva_range_op(kvm, params.uaddr, params.uaddr + params.len,
> > +		sev_launch_update_gfn_handler, argp);
> > +}
> > +
> >  static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> >  {
> >  	struct sev_es_save_area *save = svm->sev_es.vmsa;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 21a539ab17f6..33fa0b1435d3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -973,6 +973,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> >  void kvm_exit(void);
> >  
> >  void kvm_get_kvm(struct kvm *kvm);
> > +int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end, u64 attributes);
> >  bool kvm_get_kvm_safe(struct kvm *kvm);
> >  void kvm_put_kvm(struct kvm *kvm);
> >  bool file_is_kvm(struct file *file);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 4ff7adaf6c56..1343070657d1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -747,6 +747,7 @@ int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> >  
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_vm_do_hva_range_op);
> >  
> >  static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
> >  						unsigned long start,
> > @@ -2595,12 +2596,28 @@ static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end,
> >  		kvm_flush_remote_tlbs(kvm);
> >  }
> >  
> > +int kvm_vm_set_region_attr(struct kvm *kvm, gfn_t start, gfn_t end,
> > +			   u64 attributes)
> > +{
> > +	gfn_t index;
> > +	void *entry;
> > +
> > +	entry = attributes ? xa_mk_value(attributes) : NULL;
> > +
> > +	for (index = start; index < end; index++)
> > +		if (xa_err(xa_store(&kvm->mem_attr_array, index, entry,
> > +				    GFP_KERNEL_ACCOUNT)))
> > +			break;
> > +
> > +	return index;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_vm_set_region_attr);
> > +
> >  static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  					   struct kvm_memory_attributes *attrs)
> >  {
> >  	gfn_t start, end;
> >  	unsigned long i;
> > -	void *entry;
> >  	int idx;
> >  	u64 supported_attrs = kvm_supported_mem_attributes(kvm);
> >  
> > @@ -2617,8 +2634,6 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  	start = attrs->address >> PAGE_SHIFT;
> >  	end = (attrs->address + attrs->size - 1 + PAGE_SIZE) >> PAGE_SHIFT;
> >  
> > -	entry = attrs->attributes ? xa_mk_value(attrs->attributes) : NULL;
> > -
> >  	if (kvm_arch_has_private_mem(kvm)) {
> >  		KVM_MMU_LOCK(kvm);
> >  		kvm_mmu_invalidate_begin(kvm);
> > @@ -2627,10 +2642,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> >  	}
> >  
> >  	mutex_lock(&kvm->lock);
> > -	for (i = start; i < end; i++)
> > -		if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > -				    GFP_KERNEL_ACCOUNT)))
> > -			break;
> > +	i = kvm_vm_set_region_attr(kvm, start, end, attrs->attributes);
> >  	mutex_unlock(&kvm->lock);
> >  
> >  	if (kvm_arch_has_private_mem(kvm)) {
> > @@ -2793,6 +2805,7 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot,
> >  
> >  	return hva;
> >  }
> > +EXPORT_SYMBOL_GPL(gfn_to_hva_memslot_prot);
> >  
> >  unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable)
> >  {
> > -- 
> > 2.25.1
> > 
> 
> Hmm.. but user space is still allowed to call KVM_SET_MEMORY_ATTRIBUTES
> with KVM_MEMORY_ATTRIBUTE_PRIVATE set? How do these behaviours complement
> each other?

In the current series it's allowed. It reduces some headaches since an
SNP guest can issue duplicate page-state changes without violating the
spec, and it would complicate things further if kernel/userspace
attempted to enforce something stricter.

> 
> SEV specific changes and kvm_vm_set_region_attr() definition should really
> be separate patches.

Done.

-Mike

> 
> BR, Jarkko
