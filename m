Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB72CC8DF
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 22:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgLBVXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 16:23:33 -0500
Received: from mail-bn8nam08on2065.outbound.protection.outlook.com ([40.107.100.65]:37089
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729366AbgLBVXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 16:23:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaiBZlbf+/Wl0v2rRp0I8l2aLlAwUqpJTPFe+/MV1K6rfgaygfUYt+GAzpa9UbPD6Cbihc5ICG10b+CoGYu0JbbnTaMUGYmTftIh5AesZfBMetYGobAFFT3vLwzCXN4YZkZB/ZWuH4dtYiX1WAShd2fkftopWAmLstqkdN3rcJ7YVrltCvIELu+b/jiiBVPPvJfuQDoHicWzJNR6XeShSvvQLnH1OZpZtN/e43AseTVpXs1xerz5uEd43kTY7l3fz9qIuhgjdifT4E4Savf3onQ9vBnpRWh8rZqzDfdpoFqApkv6HNYMyXRdys14eKLzCQLGmu0BCtq42gXq5RUe5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4eklavDKEPq5aHWR8NvXs76fnTri0eQF7jX66F2KZ8=;
 b=lLkIaX/DrRIGHC7Z7ejTWOgGmtUGpbvoV8z19kUbg4OdAKQiEunqTpKOFz9J6rcSBzQnRyw4jJPmWE+9yZsvwRUUv77JL5v9W3smzzT926PiEa/oew7chd4IsuF7L/S6Xx78OWGgvb2KaMK+AHmCNMlV7XsKaqJ/bl1c2bAK/PPqN7CYNfRmCoOYwtLnlGyRIRIB1iD/pQ/VLr0w9i02k5mtbDS5IsANKb1F0BzTkK/vuJLdUWdJ7QdhkLAjvm9kXw+jkkR+OD8dJLnLwQk5pBPw5cwwpMrIMZNr4Rbg2/XxaAsbv0ePRYhepLGvPGgvm1fS2xt2B6P6ZJbeWa22wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4eklavDKEPq5aHWR8NvXs76fnTri0eQF7jX66F2KZ8=;
 b=MZp9i00dTa5zfIWu8jrfE4FIslhCDBCNRfUruPKw4Ch3eyw1JSaMVXeDwko/2OlOzje2m0jw5nZ/8rt+ccnpF8VtwcEoboPgUETs1kEGYHWlY4Kvql1bFaaio6xZY9I69WFj9a0CVUAM/FbIDLek0d3WkvPZdYDZsy1DaVpR0/k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Wed, 2 Dec
 2020 21:22:36 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Wed, 2 Dec 2020
 21:22:36 +0000
Date:   Wed, 2 Dec 2020 21:22:32 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com
Subject: Re: [PATCH v2 2/9] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20201202212232.GB14672@ashkalra_ubuntu_server>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <40acca4b49cd904ea73038309908151508fb555c.1606782580.git.ashish.kalra@amd.com>
 <20201202165420.GI3226@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201202165420.GI3226@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0042.prod.exchangelabs.com (2603:10b6:804:2::52)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0042.prod.exchangelabs.com (2603:10b6:804:2::52) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Wed, 2 Dec 2020 21:22:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 506da874-4d16-439d-86f4-08d89708635d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2511EA5AEF9EB40113C6F9C98EF30@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xljueehWqD8ReAY4NuL6iVhfsc/OitUHkxre0qe6UsXjeZ9l1xgJiOVC+MC4UprS2j/u3bgk3BcvsDzEupL6gazDDuHqflvmgijzzi/XRzwskmg4mM5XPvdlGHvi7krZRGidRPZWZSpIHGQun9V/7gfs7Ds+L8HiA9XGqgUpkBIQ+dmbO6TegCpEDAFIEkXe2wCwumfNo5nPMcMpGNIogPTr8hIAQE6LJg1D0eARoaOsFaj7jfMpgci5NKZgrSyUYFyOcjft+A5qF44/rE0CjrvPoBFIYlkEp3SDB9yPs7HHlqnj4UFtdIeJCqPygdfxpldfB5rIFDyLClEK67OzkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(478600001)(316002)(2906002)(44832011)(16526019)(8936002)(1076003)(6666004)(9686003)(186003)(5660300002)(8676002)(956004)(26005)(66476007)(66946007)(52116002)(6496006)(7416002)(66556008)(86362001)(55016002)(33656002)(6916009)(33716001)(4326008)(66574015)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDRWU0FSejNQWjF1TXlBTTFabXBDNVhYcGNPZmZJd2h5TFB5d1J1M3NKMXp1?=
 =?utf-8?B?d3hRaUM4d3NsYktxaXFQcXUwaU15K2dRWllCMWhvNWN2TzR6ZmtwZnd2UTFO?=
 =?utf-8?B?NUpGQTJPZWhPSDRxL2hyZEM2RTY1RnI3UkNtZzg2VTRjTGtyK0ZUNXJXOTZJ?=
 =?utf-8?B?SDQ5V0ZwUDNXUFpWOEd5QTFhbWJ0OW1lRkVYT0haWVFER1pRdTkxWDdTTTlH?=
 =?utf-8?B?cFAremJrMTdYak1YZkdSc0JNekhDTUV2N1o5TlVwOWgrYnJYTVAvbkNTT2FY?=
 =?utf-8?B?WXQza21RakozSDVPakg0THZIK1VUWDNiWXRWa28xbGFnaEkyb054NUdCRUFy?=
 =?utf-8?B?SnozVmowN3lNRlIvaUgwWlROVGg4SVIybnBjcTA2aC9BcnFoRk1ZQVV2MHJq?=
 =?utf-8?B?aERxelM4VUJCVUNiK1J1MG9iRHRkWks1VHhlaHR2ejVqN0lDbEhmSW9CT1hq?=
 =?utf-8?B?SHg5VkEwT3lCaWFIRmduNy9xWnVyaE5ucXNDbThSRHVPd1JUN3FMVnN1YlBO?=
 =?utf-8?B?d2FiUEJycGZjdm5ocS81dmVsM0lWM2kxdTRxS2lJUkdMVGVpT1BHV1BUc2V4?=
 =?utf-8?B?Ym1McVJqdmhoeWpOTzEzQnQ5anFUcVFFUC96dUpxcmVqUE83czFRQXI1UW52?=
 =?utf-8?B?bUJBK0JQUHd1UmM0VUU2TGFuaFVoU3BBYTNTS3l3b29ra2RXYWYwNjYrZTZE?=
 =?utf-8?B?Ryt6NS9ISUJwdlZvQ25IRk1VckZ4cHM5aVdLWTNHUUlHbmNuTWdHSW9SNTVo?=
 =?utf-8?B?Y2twYlRqTVZFL3NSZ3J4aEpQY0lMaExqekRHSkpBTkl0UG4xVjlURlVkZ2ly?=
 =?utf-8?B?U1orSGFhRUNWUjV1NmRIMHlHTEJZUVQ0eVZwaWp4RWt1bVEwYVQwRnNYU1Bh?=
 =?utf-8?B?VnpYcnVMVW9tTnlCb1hpc0RraWVFTW9TOWt0UWtQbDVSSmJDeExTZzNVUFZq?=
 =?utf-8?B?V2x3ZHNhQ2pwbU5jSjFBOFRiZ2d3UTY2K3FKZEYvZmdRR0Vkc3F3NVE4ODVm?=
 =?utf-8?B?R1VLcmhBNUJuSmhuU1Zkc1NwMXFPMTdGanJLRkphRUdQRjRHZU8xMW1CVFRD?=
 =?utf-8?B?bGx3YU8vTTlLS3hUcEtVRFYwUGVLRHhWd1Y5UjU2aE1GNzBPeFlKYzRpMHlV?=
 =?utf-8?B?Mnluc3IzQkJ0TktyTlRESVdoK1dDNUJxNkg2eGVWM2EwdTJlWk0rZHFXOUZx?=
 =?utf-8?B?azk0SWFQem5ZTXk3Vmd0Ukd5R1BqNDFQQTArN1AvNXRTRDhRRFRtVkxvbWFR?=
 =?utf-8?B?a2xDUmhtREc4OGN1TmhyWUY1c3B3VTF4Q1I4cmJyOER6SzNlN0lLT2V3S01E?=
 =?utf-8?Q?pSWLGsPsZpoO8u+xMbIjc1hBC65WcyiItL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506da874-4d16-439d-86f4-08d89708635d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 21:22:35.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUJKRo5cagWZGlx6lXEZhzyWhBFNRfiSURAN1G0mIYN+dhIPlUe9vLZ5FosLJdGfgVOq4V3amAFebP/qhhW02Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dave,

On Wed, Dec 02, 2020 at 04:54:20PM +0000, Dr. David Alan Gilbert wrote:
> * Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> 
> Is it defined whether these are supposed to be called before or after
> the the page type has been changed; is it change the type and then
> notify or the other way around?
> 

There is nothing really specified as such, the guest makes the hypercall
immediately after modifying the page tables. There is surely going to be
some latency before the VMM knows about this and the guest page table
update.

Thanks,
Ashish

> 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/hypercalls.rst | 15 +++++
> >  arch/x86/include/asm/kvm_host.h       |  2 +
> >  arch/x86/kvm/svm/sev.c                | 90 +++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c                |  2 +
> >  arch/x86/kvm/svm/svm.h                |  4 ++
> >  arch/x86/kvm/vmx/vmx.c                |  1 +
> >  arch/x86/kvm/x86.c                    |  6 ++
> >  include/uapi/linux/kvm_para.h         |  1 +
> >  8 files changed, 121 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > index ed4fddd364ea..7aff0cebab7c 100644
> > --- a/Documentation/virt/kvm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/hypercalls.rst
> > @@ -169,3 +169,18 @@ a0: destination APIC ID
> >  
> >  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> >  	        any of the IPI target vCPUs was preempted.
> > +
> > +
> > +8. KVM_HC_PAGE_ENC_STATUS
> > +-------------------------
> > +:Architecture: x86
> > +:Status: active
> > +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > +
> > +a0: the guest physical address of the start page
> > +a1: the number of pages
> > +a2: encryption attribute
> > +
> > +   Where:
> > +	* 1: Encryption attribute is set
> > +	* 0: Encryption attribute is cleared
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f002cdb13a0b..d035dc983a7a 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1282,6 +1282,8 @@ struct kvm_x86_ops {
> >  
> >  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
> >  	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> > +	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > +				  unsigned long sz, unsigned long mode);
> >  };
> >  
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c0b14106258a..6b8bc1297f9c 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -927,6 +927,93 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return ret;
> >  }
> >  
> > +static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	unsigned long *map;
> > +	unsigned long sz;
> > +
> > +	if (sev->page_enc_bmap_size >= new_size)
> > +		return 0;
> > +
> > +	sz = ALIGN(new_size, BITS_PER_LONG) / 8;
> > +
> > +	map = vmalloc(sz);
> > +	if (!map) {
> > +		pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
> > +				sz);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* mark the page encrypted (by default) */
> > +	memset(map, 0xff, sz);
> > +
> > +	bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
> > +	kvfree(sev->page_enc_bmap);
> > +
> > +	sev->page_enc_bmap = map;
> > +	sev->page_enc_bmap_size = new_size;
> > +
> > +	return 0;
> > +}
> > +
> > +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > +				  unsigned long npages, unsigned long enc)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	kvm_pfn_t pfn_start, pfn_end;
> > +	gfn_t gfn_start, gfn_end;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -EINVAL;
> > +
> > +	if (!npages)
> > +		return 0;
> > +
> > +	gfn_start = gpa_to_gfn(gpa);
> > +	gfn_end = gfn_start + npages;
> > +
> > +	/* out of bound access error check */
> > +	if (gfn_end <= gfn_start)
> > +		return -EINVAL;
> > +
> > +	/* lets make sure that gpa exist in our memslot */
> > +	pfn_start = gfn_to_pfn(kvm, gfn_start);
> > +	pfn_end = gfn_to_pfn(kvm, gfn_end);
> > +
> > +	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the page encryption bitmap.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
> > +		/*
> > +		 * Allow guest MMIO range(s) to be added
> > +		 * to the page encryption bitmap.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	mutex_lock(&kvm->lock);
> > +
> > +	if (sev->page_enc_bmap_size < gfn_end)
> > +		goto unlock;
> > +
> > +	if (enc)
> > +		__bitmap_set(sev->page_enc_bmap, gfn_start,
> > +				gfn_end - gfn_start);
> > +	else
> > +		__bitmap_clear(sev->page_enc_bmap, gfn_start,
> > +				gfn_end - gfn_start);
> > +
> > +unlock:
> > +	mutex_unlock(&kvm->lock);
> > +	return 0;
> > +}
> > +
> >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >  	struct kvm_sev_cmd sev_cmd;
> > @@ -1123,6 +1210,9 @@ void sev_vm_destroy(struct kvm *kvm)
> >  
> >  	sev_unbind_asid(kvm, sev->handle);
> >  	sev_asid_free(sev->asid);
> > +
> > +	kvfree(sev->page_enc_bmap);
> > +	sev->page_enc_bmap = NULL;
> >  }
> >  
> >  int __init sev_hardware_setup(void)
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 6dc337b9c231..7122ea5f7c47 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4312,6 +4312,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> >  
> >  	.msr_filter_changed = svm_msr_filter_changed,
> > +
> > +	.page_enc_status_hc = svm_page_enc_status_hc,
> >  };
> >  
> >  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index fdff76eb6ceb..0103a23ca174 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -66,6 +66,8 @@ struct kvm_sev_info {
> >  	int fd;			/* SEV device fd */
> >  	unsigned long pages_locked; /* Number of pages locked */
> >  	struct list_head regions_list;  /* List of registered regions */
> > +	unsigned long *page_enc_bmap;
> > +	unsigned long page_enc_bmap_size;
> >  };
> >  
> >  struct kvm_svm {
> > @@ -409,6 +411,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
> >  			       bool has_error_code, u32 error_code);
> >  int nested_svm_exit_special(struct vcpu_svm *svm);
> >  void sync_nested_vmcb_control(struct vcpu_svm *svm);
> > +int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> > +                           unsigned long npages, unsigned long enc);
> >  
> >  extern struct kvm_x86_nested_ops svm_nested_ops;
> >  
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c3441e7e5a87..5bc37a38e6be 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7722,6 +7722,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> >  
> >  	.msr_filter_changed = vmx_msr_filter_changed,
> >  	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
> > +	.page_enc_status_hc = NULL,
> >  };
> >  
> >  static __init int hardware_setup(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a3fdc16cfd6f..3afc78f18f69 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8125,6 +8125,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_PAGE_ENC_STATUS:
> > +		ret = -KVM_ENOSYS;
> > +		if (kvm_x86_ops.page_enc_status_hc)
> > +			ret = kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
> > +					a0, a1, a2);
> > +		break;
> >  	default:
> >  		ret = -KVM_ENOSYS;
> >  		break;
> > diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> > index 8b86609849b9..847b83b75dc8 100644
> > --- a/include/uapi/linux/kvm_para.h
> > +++ b/include/uapi/linux/kvm_para.h
> > @@ -29,6 +29,7 @@
> >  #define KVM_HC_CLOCK_PAIRING		9
> >  #define KVM_HC_SEND_IPI		10
> >  #define KVM_HC_SCHED_YIELD		11
> > +#define KVM_HC_PAGE_ENC_STATUS		12
> >  
> >  /*
> >   * hypercalls use architecture specific
> > -- 
> > 2.17.1
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
