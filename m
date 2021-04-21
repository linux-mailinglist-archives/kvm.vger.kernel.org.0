Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD03672D3
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245286AbhDUStS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 14:49:18 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:22054
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235269AbhDUStQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 14:49:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZgn3KQn5dd+R4AYJ8wY8K4NC33BcYql66s6WXCULQrdg5vIFfvDP9opr18X8Larzf0Ktm2Y2hw91O7BVoJsau9E9gfz5DgHGMTZN4sjIAWKA4U3/umWgPm+dY0Z4ICOpqOI7V2jZjL0CXCebFTeAQ8FOwFe1SYh8CoHZ0mWA9SmsvY7+Dt95OCkTl917l0vOJkuf7uQ+oNddXKAPeWbXv3yyXF1slk6VzyFcCCWOv57plZBWbnslePnYjkoqhyT3pPZYYf45uFCtrDbiN5PTB+Hmz/wTDtonpAp6dEX6UADrHkkEhUWAEkWKU17MkqS7U3/yDVUq7cmIvD9vkoEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH2uO/RJt0mN4H25N/JyyfdI0Mj205+wcieWzNmCnCQ=;
 b=Wi39dPDJedlWltW475ffAcX6tElUP/RNEWUrnTPstUf8ZOfu5A81aOV22d9F58cUBcS426TwGIhD2TAB9oL2uDqSdDGPbrMFC63HBWZZ/Cojas0tFQ653Wc1awvUPWS0SIFYk24CJhJUrl0aYHw28oAReuruBQX+v4MzW1oeE93s9uv6OFF4AOqBlvddHsDAUd8CoFwp9y5cq/8mlPXlp8P3Ttp4dDiN0ILmo4VERhjbDbKjk9jVSkBnC/fEgMhiyF6jn9Zse34+4bH01Sywn79msZLlzRkjrTzumx4304lpmn6paIRVIEnuRyodJZ+Zn6nPeqzqr6osYgyux2B/mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH2uO/RJt0mN4H25N/JyyfdI0Mj205+wcieWzNmCnCQ=;
 b=KxcM/braLyacf4HbkS1LuXdjnQN9/1bOFnkyIv3vz/7bAoLfCKyXBBEZv+wXk4HtlHuPtc/CdYW1HDdf8DNEaRwxop8B2MNZNgMK0bbtzBSLzVonZGUrxWVIX9Of3BmVt/hMjKTvKdvm/E97BByuM0VBK8NPb+efumfwv/Gbuqg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 21 Apr
 2021 18:48:39 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::b0a3:bc2c:80ec:e791]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::b0a3:bc2c:80ec:e791%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 18:48:39 +0000
Date:   Wed, 21 Apr 2021 18:48:32 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com, kexec@lists.infradead.org
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210421184832.GA14208@ashkalra_ubuntu_server>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
 <20210421144402.GB5004@zn.tnic>
 <2d3170ae-470a-089d-bdec-a43f8190cce7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d3170ae-470a-089d-bdec-a43f8190cce7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:806:f2::23) To BYAPR12MB2759.namprd12.prod.outlook.com
 (2603:10b6:a03:61::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0018.namprd04.prod.outlook.com (2603:10b6:806:f2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Wed, 21 Apr 2021 18:48:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68899b8c-8d4f-432f-340a-08d904f613cc
X-MS-TrafficTypeDiagnostic: BY5PR12MB4936:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB4936C1A43AA4267A13A34CEF8E479@BY5PR12MB4936.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2bWpvfwrmpsgG5ssz1UgPFTJjdHCzhD2B16SVjq+VsExell7JRvkBpEDXkHINk5xmUyiRGaoC7a2c4F64QCjG+NE0clDwFzllfVkvu7H5YQQEkvGXPAmXamlrl+9i5hgaFzosBwT5qbStTMGA8y0HSRPq4WNHhlaMJR7q9bP2LBGC3SBgWjeYaeLuQnHt/YuV/toyPenHHgdrnO3hgnaNO0gQUcYk4s6alq5mpiyuiLiEyULIkZxJfRqmJS5Je5qWCr4aT/Dsr8LF54TD/38VSA+8coWmHAGN6NpvMEh+PTf3pLydhMjiUDod7X5dQO7gssWaIu5vqDr4KOkM+2PrEhrfZaPeCa+BliL4dR37kVMwwHK16ItM+vkatqRy+PxZ8NM61CRYstVGDQlqgwsKJYuWNH9y+mPmB0sb6wgg8Lp1cudlc8WqD4MHac2WTVkzeA3rHaiDApaT1sAYu5XuBi8cU/BD4b5ONf6m7NHPxUrxgiylEIHlxOIe3tyLcgTNckT64uZXGr8i4EuQB+nxzTTnX3NedWXgZlPnzfJSBGSE7Bq6WLnpToxPVvmy8T/mr62/VISj2VRuTtJuVT0ABG/ZuiFgqS2bzg5KE3Py4nP1DGVM6e4ixqqSdBnj5CvEIn+ZYksIqb1xPwRI2SnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(136003)(376002)(366004)(7416002)(86362001)(33716001)(33656002)(6916009)(8676002)(1076003)(6496006)(44832011)(83380400001)(186003)(16526019)(956004)(478600001)(2906002)(26005)(316002)(6666004)(38100700002)(38350700002)(66946007)(66556008)(66476007)(9686003)(4326008)(55016002)(52116002)(8936002)(53546011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?R8lRUGgS2y/WzrMmHqvAJoyu9a4SWRaqXD8U4Nxb2EepDPldwngvpiLpZJJ2?=
 =?us-ascii?Q?nNc8gMD6ypM3aYvyUPlAxoeBlyxlUmo0vojcfyR6ng1/fCNFXuL+eMuAGVM9?=
 =?us-ascii?Q?Y6aQLg4W6OGk2Epdy3mIwn96uYysnCJb92oONRmF0ZNMtQIK5BDXBKhhZC3Q?=
 =?us-ascii?Q?vbK58q+M6tXbCWT6I7I2qLkkoPlKN8j/XnD0aa4mEOLcuwEla1t2C+i06sLd?=
 =?us-ascii?Q?JoP8SLA4tYdHqFJYyFMmRa5VLsDuxU6JFXSybTkOs5TUBqt+uNJyH+GMt2JD?=
 =?us-ascii?Q?htH7roa3dIazXswWJUyjUzMBi3YJINlMXyL1ljuceqBSZBQpvBh9NSohbG49?=
 =?us-ascii?Q?MJffknJ+GAfa7u17QzvdkvVHwz76tWeOhSbyDK20N+sbNUNyZvzSxPD6j4A0?=
 =?us-ascii?Q?9efdYaPECJVH0959zsBclGkJo2OBTbK17sSMJo6SF2DrxdTuoGs9Ic0+I/lP?=
 =?us-ascii?Q?CfCs9iwShMm1Nee7+6cdHeqwogFjbnChB6W8Fw/7tvBhGskfwbDL1EOnhU3q?=
 =?us-ascii?Q?E+De4FQlDbiFF8p7sfoEvKQCNhId0TQFdQHB5hndW/pGluldmGYVNej5jvoE?=
 =?us-ascii?Q?Ec0DJK3aqMVKLQv4ga+irda643F7OwrJycyWw4wgsCmXmAxeOSfo8x4ulMRG?=
 =?us-ascii?Q?Pe6f63Oexmptn4jhO0mJlKCBF+yROxBZP5RcYVkQ2Avu2Z1i1p26kB3/ETPG?=
 =?us-ascii?Q?dLQ47qsdt+5gdebYAZa3Dr0tVM3GPgGftmD1OOuUZkzJOLiU1vuvNQwiaPlC?=
 =?us-ascii?Q?XQRa+OQdTOyHc2bn/hLPTpGYpjw3qLegONwx/0uW9oxMvv8IGd05fFrPWtDb?=
 =?us-ascii?Q?Jg9+oJcZtEn6++hsLh5MQpKzA93Ev5Y8VEBcF0Jusqhk08BQs0GmjJjcmjcM?=
 =?us-ascii?Q?q7Ryz7qgdMwab1Tar0QCe4cyoLdJqdpSkodom1o+lkS0Uq11PiLXrDSkj6OB?=
 =?us-ascii?Q?KeieMZSTFfYdibOhSKc1MsH7XSE7VETLc9uQcbW76MXWv7rk5uDgxFD7thn9?=
 =?us-ascii?Q?IJ80XhMcRv1LxTzWRQROOeAmAHeHc4MwIr/fp132+0J3w0I7Ybx7YdDSfdvG?=
 =?us-ascii?Q?uQmBn5j627ll3FGyY4UE8IYk7va95PHWrvXEwK0rV0LOy7+bI4eWLNm8B11U?=
 =?us-ascii?Q?uAbdTGpSXZD0UaCqi5rdmt9Mi63RDLAufPvbah7DYq8Da6RqQ6TaY8y5oYSH?=
 =?us-ascii?Q?fCzxgphfkWRwNasQcfxKXm8K5Jm3/ASyHeM+5O1KHM8y2S7vlhNq1U8I8zg1?=
 =?us-ascii?Q?xlfyJMfMrQO5rz7FTDHoq9wGeJw1W98xbj9lL3cif6C6UNQ1HjpyMFJpuBdw?=
 =?us-ascii?Q?vW1dh/QeTK4rxe3JI+gXG05Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68899b8c-8d4f-432f-340a-08d904f613cc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 18:48:39.2580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8tgXLphWMH4wCzlzQxGIBkAmPjXneCfdZkAlOdv2VHcqwEAR9t74DYOdsGdMRCFFt/smgYbi9lQlmHxgTRY4hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

The earlier patch#10 of SEV live migration patches which is now part of
the guest interface patches used to define
KVM_FEATURE_SEV_LIVE_MIGRATION. 

So now, will the guest patches need to define this feature ?

Thanks,
Ashish

On Wed, Apr 21, 2021 at 05:38:45PM +0200, Paolo Bonzini wrote:
> On 21/04/21 16:44, Borislav Petkov wrote:
> > On Thu, Apr 15, 2021 at 04:01:16PM +0000, Ashish Kalra wrote:
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > 
> > > The guest support for detecting and enabling SEV Live migration
> > > feature uses the following logic :
> > > 
> > >   - kvm_init_plaform() invokes check_kvm_sev_migration() which
> > >     checks if its booted under the EFI
> > > 
> > >     - If not EFI,
> > > 
> > >       i) check for the KVM_FEATURE_CPUID
> > 
> > Where do you do that?
> > 
> > $ git grep KVM_FEATURE_CPUID
> > $
> > 
> > Do you mean
> > 
> > 	kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)
> > 
> > per chance?
> 
> Yep.  Or KVM_CPUID_FEATURES perhaps.
> 
> > 
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 78bb0fae3982..94ef16d263a7 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -26,6 +26,7 @@
> > >   #include <linux/kprobes.h>
> > >   #include <linux/nmi.h>
> > >   #include <linux/swait.h>
> > > +#include <linux/efi.h>
> > >   #include <asm/timer.h>
> > >   #include <asm/cpu.h>
> > >   #include <asm/traps.h>
> > > @@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
> > >   	early_set_memory_decrypted((unsigned long) ptr, size);
> > >   }
> > > +static int __init setup_kvm_sev_migration(void)
> > 
> > kvm_init_sev_migration() or so.
> > 
> > ...
> > 
> > > @@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
> > >   bool sev_enabled __section(".data");
> > > +bool sev_live_migration_enabled __section(".data");
> > 
> > Pls add a function called something like:
> > 
> > bool sev_feature_enabled(enum sev_feature)
> > 
> > and gets SEV_FEATURE_LIVE_MIGRATION and then use it instead of adding
> > yet another boolean which contains whether some aspect of SEV has been
> > enabled or not.
> > 
> > Then add a
> > 
> > static enum sev_feature sev_features;
> > 
> > in mem_encrypt.c and that function above will query that sev_features
> > enum for set flags.
> 
> Even better: let's stop callings things SEV/SEV_ES.  Long term we want
> anyway to use things like mem_encrypt_enabled (SEV),
> guest_instruction_trap_enabled (SEV/ES), etc.
> 
> For this one we don't need a bool at all, we can simply check whether the
> pvop points to paravirt_nop.  Also keep everything but the BSS handling in
> arch/x86/kernel/kvm.c.  Only the BSS handling should be in
> arch/x86/mm/mem_encrypt.c.  This way all KVM paravirt hypercalls and MSRs
> are in kvm.c.
> 
> That is:
> 
> void kvm_init_platform(void)
> {
> 	if (sev_active() &&
> 	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> 		pv_ops.mmu.notify_page_enc_status_changed =
> 			kvm_sev_hc_page_enc_status;
> 		/* this takes care of bss_decrypted */
> 		early_set_page_enc_status();
> 		if (!efi_enabled(EFI_BOOT))
> 			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> 			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> 	}
> 	/* existing kvm_init_platform code goes here */
> }
> 
> // the pvop is changed to take the pfn, so that the vaddr loop
> // is not KVM specific
> static inline void notify_page_enc_status_changed(unsigned long pfn,
> 				int npages, bool enc)
> {
> 	PVOP_VCALL3(mmu.page_encryption_changed, pfn, npages, enc);
> }
> 
> static void notify_addr_enc_status_changed(unsigned long addr,
> 					   int numpages, bool enc)
> {
> #ifdef CONFIG_PARAVIRT
> 	if (pv_ops.mmu.notify_page_enc_status_changed == paravirt_nop)
> 		return;
> 
> 	/* the body of set_memory_enc_dec_hypercall goes here */
> 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> 		...
> 		notify_page_enc_status_changed(pfn, psize >> PAGE_SHIFT,
> 					       enc);
> 		vaddr_next = (vaddr & pmask) + psize;
> 	}
> #endif
> }
> 
> static int __set_memory_enc_dec(unsigned long addr,
> 				int numpages, bool enc)
> {
> 	...
>  	cpa_flush(&cpa, 0);
> 	notify_addr_enc_status_changed(addr, numpages, enc);
>  	return ret;
> }
> 
> 
> > +static int __init setup_kvm_sev_migration(void)
> 
> Please rename this to include efi in the function name.
> 
> > 
> > +		 */
> > +		if (!efi_enabled(EFI_BOOT))
> > +			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> > +			       KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +		} else {
> > +			pr_info("KVM enable live migration feature unsupported\n");
> > +		}
> > +}
> 
> I think this pr_info is incorrect, because it can still be enabled in the
> late_initcall.  Just remove it as in the sketch above.
> 
> Paolo
> 
