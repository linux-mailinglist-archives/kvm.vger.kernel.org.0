Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A7F366A84
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhDUMMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 08:12:54 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:10688
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233947AbhDUMMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 08:12:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biFMXHj7yXfmVwupsYDmmynpGwvlZxZX+Ey//iRNDIaTxvfXsFiG5Ya3vls6eOXwS6tagFIFihq09Wmg+ahbUIQLD/ft5Jyx2Z8N74h7CU1fQsUD5tRzkR7eV3C27msl5m1rmfUWtKkawwa7jrbUkATNCKdz2s6C9QW+3xEa7SfpJApdnNvdZxe3SRDdTYuphzzPCHAHJO63XqZyy6VGoms6PPzENwjFEzBbzVbu3S9eGkFgUuBoPxs95bxnyuD2uou5GRlJ/aPEPsZFVqeZ2Us2OHOvpceCOfPHHv7saX4xjLFsM7r7LenJmOzt374NFASXUgOQ8wBqghdLlJAyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cEPxyevFf/5eOiVpVXD+9/j86jOc8hChf42E7g0NzY=;
 b=TbSyFqhpoQSyRH5467oBDRfbDSSjD2JU4TikDbWjJzI4qGNsiWXc0gKGG32sU1ekEMnR3FUKtaTv37HmDyhtIR+Z0ixVJZtNO87LYRhGwDTqQHyN9GlgZLhUKzWw1ZQ+RKdfIHGfisPC/TqcxQqSl7lVWX4+VCRcv2glJKKqX8WIsmNjRVwRW0e7lA/soAJRQRMUgs5S52gmC0lruCls0GmoHpm/8JG4GKVdciHFHJeUWWVOJmG6bFLRGHsiLgJVpZAimEXicSFX8VC54Xpf5UzIffpDKC5HqiYnInzf3g5N3I8bvCdNIVYDL+he4VWFu0hyLevmudR+nCJ53hvDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cEPxyevFf/5eOiVpVXD+9/j86jOc8hChf42E7g0NzY=;
 b=Au2cXK9oAKQrsPFCaoq3fB/1WG/QRR1XZuv36619uGSKhiYn6y0OkNtLSOS4es3xkXXV8NLjBvA4pOXCmTmsomDTC1j7bvFSgKgGRtDqyC94z8cuD6MF88VKdNO3xcPvbuWxuvFVsZBmBRdjNLbFXfer17MHY8uDaLu9eAseV6A=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4525.namprd12.prod.outlook.com (2603:10b6:806:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 12:12:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Wed, 21 Apr 2021
 12:12:18 +0000
Date:   Wed, 21 Apr 2021 12:12:13 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210421121213.GA14004@ashkalra_ubuntu_server>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
 <20210421100508.GA11234@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421100508.GA11234@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0116.namprd13.prod.outlook.com
 (2603:10b6:806:24::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0116.namprd13.prod.outlook.com (2603:10b6:806:24::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.7 via Frontend Transport; Wed, 21 Apr 2021 12:12:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 750fa54e-36cb-44ae-6de3-08d904beb587
X-MS-TrafficTypeDiagnostic: SA0PR12MB4525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4525BF8F24B8B44EB64E1ED98E479@SA0PR12MB4525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HnBwAfiyLK0IL57XvhOFTdOuMB+XvADJTIUQ90eDtq1SpCRNRfLZfy4Onjo7IuYXqFlAb6LNrJrx2ii1skvqNFLUj1ahNpEz2nh67Zs2QzM/ROjMs/8iROeTGu9RaOFmkVZeT++pJmU/Y6GxokZjbYuZmyp6RMJFZ3IG91MddZIs+x2YI4oQh8mCDGqxbJh6Bes65D9aSndgDMbmAhtZYmCJo/cs2UXIDCjf+xEcXvvzVu8GSAFv9IwEh+4xMDX6W7uaVopv1OP1Hnmba0FkEjGWEU9z+TnwOycQbBnoGQW1CjzlrI6Hk1PHoogrRHTiFd1o3M4LxxI4SOM4AWiAZ7g7dxAT/Ed7UV96lF7KWZ7PqoB1woodbzBgHPaLG1qmjdVlVNAMZ2DebECWoKRHP2D8m94REj8Dk/Gk/6cY20mssrDf71L0OzxqdqtLb6AhugMgJliAy9J+bl/nO12erDznDcGerzi+HvEUlLyGyv2+bvHOahx+UtUu1bZWkBPkEOEQ6UTIYSZE9NIJPPwU9Noo1tHbr+VK1hFoJgKARFhTjkf0hWnnkE23YdH9ghhS28tJISErZvY9Y4G8UDgZBEXcMQGtbfPHRvWlQUfMV13TRbDtynmUXYZJXL9MeSn/pfVYZyBQAR+Fexew/DtskpCDMMB/9HIx6/ric0mo4MTMK/nmE/5/JeKaSYMYnASqdMGnYL5wuHOaZ4eI1I1nMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(16526019)(186003)(38350700002)(956004)(8676002)(44832011)(38100700002)(26005)(9686003)(52116002)(5660300002)(86362001)(33656002)(2906002)(8936002)(966005)(478600001)(45080400002)(33716001)(1076003)(83380400001)(7416002)(6916009)(55016002)(66946007)(316002)(66476007)(6496006)(6666004)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1WmiKiKNrMRPsEAwil5zK7yOX7zt7xurHjnWLLhSh8+axaeIX7IIPyQ4/8ie?=
 =?us-ascii?Q?MVv3sdqEEkKIcAQhj0eQ3GG1i/AIOhu1ksv0lXXllcrCi2yISX8W4O+cr79b?=
 =?us-ascii?Q?LWP11NXgLwkIQOH7GD2aWQ5dwzhoYFwmTAKOJXIuV/XxuPxvFsDpB7RkIy51?=
 =?us-ascii?Q?nZyZF9ETDVhzObaM4VRn4KdSlZ1NyNDjzcG/Wh60Pe+HoMRdgr94+WhXqdvp?=
 =?us-ascii?Q?Vfvv9VRT5WAhMMAEa19YA3y7Ideyc3SXYNgX9YePBPu1L4rwKvmVk/fduhnN?=
 =?us-ascii?Q?TlP9dhi9vUvqvloaGiOtSVdXMN6SzMkLuNw3brZVIJEKrY2XzduhpgVNPUHH?=
 =?us-ascii?Q?+noaBqugRHKfR8dXPAj2qA51MvW8DXQU9TxVKAZ3/tymm9oLpJCuNnN+bc8U?=
 =?us-ascii?Q?LbNB4+kumyCJCDk+00P90L1tUGeXgq4TTUAUHq6SWoXZlDeVcv3QAuJHzzbk?=
 =?us-ascii?Q?2PlHt8ziqhY20CcCNv4x/ggb+pgsxT4nYpmmwdXXpH8JRONti0KjnsSTlE9l?=
 =?us-ascii?Q?CfupBOro7vIFZsRhpG2682ZpILWB9WWryQ61xu9X2gtOakopa0qli35r1w/d?=
 =?us-ascii?Q?vOaRvljqTjDV18KK8wyV/300VHKOOTH+qNVX9TNrQaL/NbkvYlSFIfYb0MQQ?=
 =?us-ascii?Q?nCz7rMx2wvPJ1TSHHAg7KMD6QAG/gYJ6rwNlVK1xtp8Nw5CSIRcvTOOf3XiH?=
 =?us-ascii?Q?zyNS6rIxSFwguS6XEpmgqzWJbbnYPxQ1qxAtgGWrAU84wihnJL3LTevKqEIs?=
 =?us-ascii?Q?wcWAi/HWzIzcdWrfxun2/C1ffb1dShGTL9qVSIPy6r9A1/YKkGdVfFsPDP08?=
 =?us-ascii?Q?CDEvulIQeagZmiAtP2ll5784LcNcd+4YbZUnAvO1vPocTT1NmVcyPaRkjjAq?=
 =?us-ascii?Q?AnhHGplMUA4aH/L0/utbynVKKDRj6IiH0iANt0T4UWlIjFL2lb6H+KiJn8id?=
 =?us-ascii?Q?IrHB8xy7AHU3Xft2ASUO6XPlA8PKkzPxL3Lg4QPEbdzMCa7cbk9bxBxJTstR?=
 =?us-ascii?Q?s3vzzx7Hzqxzf3/j9vnrVE1zIavvDb7UuKhk8f2IkE1SUjz8mSNuVR8+WVHi?=
 =?us-ascii?Q?SZwSNYfdiIGIBvITHTvc/PP9G9VgdXFelm3bnmd8bKAIZr/YIP3LXSuE5exW?=
 =?us-ascii?Q?rE75nEGmkJTobiuOOlvWtR+xaOHCNWBmPpVgM4J1UDJZkh24q8E8yD85CXbY?=
 =?us-ascii?Q?gkIAaZ6Df6HOePfPDIgmTyM0sUOjBV9wi/yK9dvXnFyaPAxDVSICsonhdpMj?=
 =?us-ascii?Q?GBmu7HyMphRn9ii2TFZ2gTRkFe1TD6+8eev9waVdjDxcvAoyGJcT6Y1qJ4YL?=
 =?us-ascii?Q?ssurvLHqCZ6TG8AiP1adUTqv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 750fa54e-36cb-44ae-6de3-08d904beb587
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 12:12:18.7783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gghid7ZXgawoYjShZXgxCOPeDfF8XwFtMgMIAtoBa6CBRxEZkIGDQJ9VtEtngQ5Nrfrh+LaejYNYG0KR4Omug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4525
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 12:05:08PM +0200, Borislav Petkov wrote:
> On Thu, Apr 15, 2021 at 03:57:26PM +0000, Ashish Kalra wrote:
> > +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> > +						bool enc)
> 
> When you see a function name "page_encryption_changed", what does that
> tell you about what that function does?
> 
> Dunno but it doesn't tell me a whole lot.
> 
> Now look at the other function names in struct pv_mmu_ops.
> 
> See the difference?
> 
> > +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> 
> If I had to guess what that function does just by reading its name, it
> sets a memory encryption/decryption hypercall.
> 
> Am I close?
> 
> > +					bool enc)
> > +{
> > +	unsigned long sz = npages << PAGE_SHIFT;
> > +	unsigned long vaddr_end, vaddr_next;
> > +
> > +	vaddr_end = vaddr + sz;
> > +
> > +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> > +		int psize, pmask, level;
> > +		unsigned long pfn;
> > +		pte_t *kpte;
> > +
> > +		kpte = lookup_address(vaddr, &level);
> > +		if (!kpte || pte_none(*kpte))
> > +			return;
> > +
> > +		switch (level) {
> > +		case PG_LEVEL_4K:
> > +			pfn = pte_pfn(*kpte);
> > +			break;
> > +		case PG_LEVEL_2M:
> > +			pfn = pmd_pfn(*(pmd_t *)kpte);
> > +			break;
> > +		case PG_LEVEL_1G:
> > +			pfn = pud_pfn(*(pud_t *)kpte);
> > +			break;
> > +		default:
> > +			return;
> > +		}
> 
> Pretty much that same thing is in __set_clr_pte_enc(). Make a helper
> function pls.
> 

Yes, both have some common code, but it is only this page level/size
check, and they pretty much do different things with page size
evaluation, i think it will be cleaner to keep the code separately for
both these functions.

> > +
> > +		psize = page_level_size(level);
> > +		pmask = page_level_mask(level);
> > +
> > +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> > +
> > +		vaddr_next = (vaddr & pmask) + psize;
> > +	}
> 
> As with other patches from Brijesh, that should be a while loop. :)
>

I see that early_set_memory_enc_dec() is also using a for loop, so which
patches are you referring to ?

> > +}
> > +
> >  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
> >  {
> >  	pgprot_t old_prot, new_prot;
> > @@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
> >  static int __init early_set_memory_enc_dec(unsigned long vaddr,
> >  					   unsigned long size, bool enc)
> >  {
> > -	unsigned long vaddr_end, vaddr_next;
> > +	unsigned long vaddr_end, vaddr_next, start;
> >  	unsigned long psize, pmask;
> >  	int split_page_size_mask;
> >  	int level, ret;
> >  	pte_t *kpte;
> >  
> > +	start = vaddr;
> >  	vaddr_next = vaddr;
> >  	vaddr_end = vaddr + size;
> >  
> > @@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
> >  
> >  	ret = 0;
> >  
> > +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> > +					enc);
> >  out:
> >  	__flush_tlb_all();
> >  	return ret;
> > @@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
> >  	if (sev_active() && !sev_es_active())
> >  		static_branch_enable(&sev_enable_key);
> >  
> > +#ifdef CONFIG_PARAVIRT
> > +	/*
> > +	 * With SEV, we need to make a hypercall when page encryption state is
> > +	 * changed.
> > +	 */
> > +	if (sev_active())
> > +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> > +#endif
> 
> There's already a sev_active() check above it. Merge the two pls.
>

Ok. 

> > +
> >  	print_mem_encrypt_feature_info();
> >  }
> >  
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 16f878c26667..3576b583ac65 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -27,6 +27,7 @@
> >  #include <asm/proto.h>
> >  #include <asm/memtype.h>
> >  #include <asm/set_memory.h>
> > +#include <asm/paravirt.h>
> >  
> >  #include "../mm_internal.h"
> >  
> > @@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
> >  	 */
> >  	cpa_flush(&cpa, 0);
> >  
> > +	/* Notify hypervisor that a given memory range is mapped encrypted
> > +	 * or decrypted. The hypervisor will use this information during the
> > +	 * VM migration.
> > +	 */
> 
> Kernel comments style is:
> 
> 	/*
> 	 * A sentence ending with a full-stop.
> 	 * Another sentence. ...
> 	 * More sentences. ...
> 	 */

Ok.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7Cf953299226ec42b5077308d904ad427c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637545964477197662%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=XS9tvx%2BlDPCKGFgsv7jruSrF6kUzAMIqUhBke7rtO5k%3D&amp;reserved=0
