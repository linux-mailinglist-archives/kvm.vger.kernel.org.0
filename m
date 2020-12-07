Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD7D2D1C9B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 23:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgLGWBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 17:01:24 -0500
Received: from mail-dm6nam08on2059.outbound.protection.outlook.com ([40.107.102.59]:33309
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727366AbgLGWBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 17:01:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6BBWsuIlvMtSDoAc/g+2QK9qxA6Eprye5eMN0TUUBOYUQNfYsgDTIjTpTQhW9dEjcZR9hRfOV68DBaCuh1xgQOf20L3SNmAlILJJI6srT9mfk7gKDERPSdGUgpcmL9TrdLfmBn849REURWQ9kTMVhb2SQYpOtneHAh8BXtQm4nwKnW9yDL0Equ7EygsZP6lANciK3dyXaGxe1Yeomnm5X8Bf/VJclStW7m95IBYvSj5keIX0IiilO5s01+9HiBqQtRlUV0Ttai1Yn3qf+bueq3ykQT/BT1GpBDodaAiKVCcZOT1gdhzqMBD/gKqM0HGvMaYlq1/QDMmX+Z9B9sd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW2rDl9okBh9KQg6JobOfJGtVPq6ji+BbaBGEUvhnWs=;
 b=bZUfZlrq6HU90donmc1nDSX8T2LzOAWMTb0rRfCUaAFZwwlWqG/P7z7mdlW8GMvn7PJa0i8mEyXXtl5NR809FLVoyFAMvRvzeJiDWNiE/QgE8ltM2aVB0NxD70dZZUitHhOF+S9kyXedR0UrCWQxEFgm3p3zYrzdoUvGpSjrGpfIffTs9HwiW6sC1iCj/sQlbLaIUchH6DnUNdrUHkPWqmGLDV3jzS8nAVMwInUDM339nwcI/AFHqPGSVqUjLRxTSGdsPb1BMe5fAfn0NKGRyIDQcPn8YaXy2esb3gpHcpOrSQ/LQSO4wNVtYP1AOZhCHmAjfztbWeQUgxW6oJLqRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW2rDl9okBh9KQg6JobOfJGtVPq6ji+BbaBGEUvhnWs=;
 b=IuE58UTTCUQGJtEme3aBxl5o596QcPQ8pEAFkrUXTpmBDRG0aaWLD8JJDO9Tqs4k3Az6Ilc8ndRgcB+iouDPXbPRYxZWQfQsKlxpHzjNOyy8gTFtsj2uVFjcBrgM2iyZ1MCcBSBAKNBUr818Uyk3lpQTnpGkyXf2OmyQOttdL5Y=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 22:00:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 22:00:25 +0000
Date:   Mon, 7 Dec 2020 22:00:01 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Dov Murik <dovmurik@linux.vnet.ibm.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v2 3/9] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP ioctl
Message-ID: <20201207220000.GA6855@ashkalra_ubuntu_server>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <9b9f786817ed2aaf77d44f257e468df800b999d0.1606782580.git.ashish.kalra@amd.com>
 <b10e6d9e-74cc-a096-fdb1-983cbd128f7e@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b10e6d9e-74cc-a096-fdb1-983cbd128f7e@linux.vnet.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:5:120::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR06CA0006.namprd06.prod.outlook.com (2603:10b6:5:120::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 22:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f7199742-f36f-4647-a990-08d89afb803e
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB236841991340B963F073D0488ECE0@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtpmsvFbLXdGeMG90l1qGGdyKoA3irOmgEnm1i06WXUs6dFubMEUkHalI6lEfpgpdzRWVR7cZVxaFovQFlEiF0hrKpcGBwVlEUWUQnXxREFRNNY+mY+RKlGT8YntXIihABOldjwKzrTmsTBHYn9ykgfONxho5uUIW9YC4bKPSsMpB6P8bnqtY3jMwtOIBRGVd3Bi7OAeB0p11sZxO+iUDQKNawALyWmtS8DrSnNGEnzgJxfNLIX0zP4oliz3RZ5G6CODusUCRVnaffNh3Nu0v1rmfm0vJGQVsIW4MaIsFEfCrD3b2ynvTaAhzdeXXsgTv5Ph6Y7wHkw54h2PGsbqOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(66476007)(44832011)(8936002)(6496006)(8676002)(16526019)(66556008)(66574015)(66946007)(1076003)(956004)(6666004)(186003)(6916009)(33656002)(5660300002)(33716001)(7416002)(53546011)(2906002)(26005)(86362001)(83380400001)(4326008)(478600001)(316002)(55016002)(9686003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZW5PVE5NNXNoYkgzWkpHYW1nVlZ3LzQya0JSVXFmb2JTUHVzU3JsOFFVbCts?=
 =?utf-8?B?NmlTcUdBMzFvM3VNMFk2S0pqd3B2V1FGNDduREtvc0RmSjZ1RnZWbk9Cb3hi?=
 =?utf-8?B?Wkw5OWM1b2RmT01Ccm5vL2NEMkZuUjI3c1BYMkllSTRGa3hJaUt5M2x1RWc4?=
 =?utf-8?B?OUlBMENrejdLTjdvTmJRWlRJNkV0YzErd1NQc3lPcXpyUTV2eVpNR1d5LzF5?=
 =?utf-8?B?WVRyWGhwbDhLU0NFZi9NbFc0bVJBS2VpV0RyTzBOZGFSRDlaYmcxRVBpZFZV?=
 =?utf-8?B?Uk8zL2V6dWlkZ0ljeHMwR1VEdWtYdGYyclJwSVRoK0k4cFRnWnBQOTBmQTZO?=
 =?utf-8?B?cGZvUFlOZzRFbm9WbU51YWVZVDZML1dLeHdLYmhtWlNIZVRtdEp4aktJbmZm?=
 =?utf-8?B?WE45VkltdVJ3dHh1SDlaQ1hjUmZCRmwxS3VHUCszK0xVbEJHV3I0VW9ESFRq?=
 =?utf-8?B?VFNrRTZ1SDFHYm5mSit6dU45RnFUQW4vY21zSnpaeU5RS1djSHk1bWVuRGxM?=
 =?utf-8?B?dnFpMURmQ0IwY3czaHNFakdXNmY0Q2FxdnpXSkJmY2plNGVjL3loUHk4UlJ6?=
 =?utf-8?B?MUFaT1d4amNDRk1LN1o3TUc0bTVRNE1DbTU1c1gwbGx6bnQ1Qy9RY0VNVFNQ?=
 =?utf-8?B?UjRVS2V1VWxCMG9PajhuMUwvcFMwSmoyTkg4dGZHQjdIRXlKRTdUZG1ac2lp?=
 =?utf-8?B?eDl3UFNIeFFZanEyYjFHbWlmaEdvcXlFMVR3dkJUQkxuUEZzdS9TSGpWbEx6?=
 =?utf-8?B?dTR0clBUV2Q3NGRhNFZKdjVMYzhHOFE1UU5wZEtDMWVNRWgyYStMQmhzYUFU?=
 =?utf-8?B?emFjd1dpeTFmRHpNcnQwTy9NTmJ5MkZHbjRRbzFEVld6Vng2TC8yeSsxZWUw?=
 =?utf-8?B?clMyc2xXMHBLUUlVbkg5b1RjVEJ0NlJ3eVlnb3VhZmdlcE5KOXdGMUpSSGU4?=
 =?utf-8?B?MjJmZTVTQ2h1TElQS3dUblBOOEp0UU45M1A0a0JVU0xaUGxCSUJEOTNDWjdk?=
 =?utf-8?B?L2tKM0VTck9sTTVtT01PZmM0MGVBQlgzL210dmlhKzcwYmI2K1lKSndIU1VP?=
 =?utf-8?B?RzNKUlIyOWJzakgrdm9YSjBFd1BNMWZoeDV6cUJ0STlKby9nM1RxK3lSRlVE?=
 =?utf-8?B?Z3VqUE5rb29rUDZkZUxZUHF1N1B1bGRVSEtJOTNGOGlEUmpOWUEwbVdEdkJx?=
 =?utf-8?B?UjBZeWY1NUFoT3hVVGhHbWd5QWtJZm05VEoyZ2lzQXpvUEZsWW9QNEZKL1NS?=
 =?utf-8?B?d1VQenFTbHVZMklsbmhRZmVZRm5Rem1yN2V2dGxlR0JqbHZRVU9najVnMnpG?=
 =?utf-8?Q?mhd/2eDunxAFc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 22:00:25.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f7199742-f36f-4647-a990-08d89afb803e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghomS9XBACwYpuiiACTlW/yfzTHEN8xeT45OIQcaoL0QGGtc0ZFVqkxvVPxAcVVD0srTUbpOaO60tTBZuU3dnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Dov,

On Sun, Dec 06, 2020 at 01:02:47PM +0200, Dov Murik wrote:
> 
> 
> On 01/12/2020 2:47, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The ioctl can be used to retrieve page encryption bitmap for a given
> > gfn range.
> > 
> > Return the correct bitmap as per the number of pages being requested
> > by the user. Ensure that we only copy bmap->num_pages bytes in the
> > userspace buffer, if bmap->num_pages is not byte aligned we read
> > the trailing bits from the userspace and copy those bits as is.
> 
> I think you meant to say "Ensure that we only copy bmap->num_pages *bits* in
> the userspace buffer".  But maybe I'm missed something.
>

Yes, that is correct. It should read bmap->num_pages *bits* instead of
*bytes*, i will fix the comments.

> 
> > 
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
> >   Documentation/virt/kvm/api.rst  | 27 +++++++++++++
> >   arch/x86/include/asm/kvm_host.h |  2 +
> >   arch/x86/kvm/svm/sev.c          | 70 +++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/svm/svm.c          |  1 +
> >   arch/x86/kvm/svm/svm.h          |  1 +
> >   arch/x86/kvm/x86.c              | 12 ++++++
> >   include/uapi/linux/kvm.h        | 12 ++++++
> >   7 files changed, 125 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 70254eaa5229..ae410f4332ab 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4671,6 +4671,33 @@ This ioctl resets VCPU registers and control structures according to
> >   the clear cpu reset definition in the POP. However, the cpu is not put
> >   into ESA mode. This reset is a superset of the initial reset.
> > 
> > +4.125 KVM_GET_PAGE_ENC_BITMAP (vm ioctl)
> > +---------------------------------------
> > +
> > +:Capability: basic
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > +:Returns: 0 on success, -1 on error
> > +
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> > +The encrypted VMs have the concept of private and shared pages. The private
> > +pages are encrypted with the guest-specific key, while the shared pages may
> > +be encrypted with the hypervisor key. The KVM_GET_PAGE_ENC_BITMAP can
> > +be used to get the bitmap indicating whether the guest page is private
> > +or shared. The bitmap can be used during the guest migration. If the page
> > +is private then the userspace need to use SEV migration commands to transmit
> > +the page.
> > +
> > 
> >   4.125 KVM_S390_PV_COMMAND
> >   -------------------------
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d035dc983a7a..8c2e40199ecb 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1284,6 +1284,8 @@ struct kvm_x86_ops {
> >   	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> >   	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> >   				  unsigned long sz, unsigned long mode);
> > +	int (*get_page_enc_bitmap)(struct kvm *kvm,
> > +				struct kvm_page_enc_bitmap *bmap);
> >   };
> > 
> >   struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 6b8bc1297f9c..a6586dd29767 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1014,6 +1014,76 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >   	return 0;
> >   }
> > 
> > +int svm_get_page_enc_bitmap(struct kvm *kvm,
> > +				   struct kvm_page_enc_bitmap *bmap)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	unsigned long gfn_start, gfn_end;
> > +	unsigned long sz, i, sz_bytes;
> > +	unsigned long *bitmap;
> > +	int ret, n;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	gfn_start = bmap->start_gfn;
> > +	gfn_end = gfn_start + bmap->num_pages;
> > +
> > +	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / BITS_PER_BYTE;
> > +	bitmap = kmalloc(sz, GFP_KERNEL);
> 
> Maybe use bitmap_alloc which accepts size in bits (and corresponding
> bitmap_free)?
>

I will look at this. 

> 
> > +	if (!bitmap)
> > +		return -ENOMEM;
> > +
> > +	/* by default all pages are marked encrypted */
> > +	memset(bitmap, 0xff, sz);
> 
> Maybe use bitmap_fill to clarify the intent?
>

Again, i will look at this. 
> 
> > +
> > +	mutex_lock(&kvm->lock);
> > +	if (sev->page_enc_bmap) {
> > +		i = gfn_start;
> > +		for_each_clear_bit_from(i, sev->page_enc_bmap,
> > +				      min(sev->page_enc_bmap_size, gfn_end))
> > +			clear_bit(i - gfn_start, bitmap);
> > +	}
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	ret = -EFAULT;
> > +
> > +	n = bmap->num_pages % BITS_PER_BYTE;
> > +	sz_bytes = ALIGN(bmap->num_pages, BITS_PER_BYTE) / BITS_PER_BYTE;
> 
> Maybe clearer:
> 
> 	sz_bytes = BITS_TO_BYTES(bmap->num_pages);
> 
> 
> 
> > +
> > +	/*
> > +	 * Return the correct bitmap as per the number of pages being
> > +	 * requested by the user. Ensure that we only copy bmap->num_pages
> > +	 * bytes in the userspace buffer, if bmap->num_pages is not byte
> > +	 * aligned we read the trailing bits from the userspace and copy
> > +	 * those bits as is.
> > +	 */
> 
> (see my comment on the commit message above.)
> 
Yes, as i mentioned above, this need to be bmap->num pages *bits* and 
not *bytes*. 

> 
> > +
> > +	if (n) {
> > +		unsigned char *bitmap_kernel = (unsigned char *)bitmap;
> > +		unsigned char bitmap_user;
> > +		unsigned long offset, mask;
> > +
> > +		offset = bmap->num_pages / BITS_PER_BYTE;
> > +		if (copy_from_user(&bitmap_user, bmap->enc_bitmap + offset,
> > +				sizeof(unsigned char)))
> > +			goto out;
> > +
> > +		mask = GENMASK(n - 1, 0);
> > +		bitmap_user &= ~mask;
> > +		bitmap_kernel[offset] &= mask;
> > +		bitmap_kernel[offset] |= bitmap_user;
> > +	}
> > +
> > +	if (copy_to_user(bmap->enc_bitmap, bitmap, sz_bytes))
> > +		goto out;
> > +
> > +	ret = 0;
> > +out:
> > +	kfree(bitmap);
> > +	return ret;
> > +}
> > +
> >   int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_sev_cmd sev_cmd;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 7122ea5f7c47..bff89cab3ed0 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4314,6 +4314,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >   	.msr_filter_changed = svm_msr_filter_changed,
> > 
> >   	.page_enc_status_hc = svm_page_enc_status_hc,
> > +	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >   };
> > 
> >   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 0103a23ca174..4ce73f1034b9 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -413,6 +413,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
> >   void sync_nested_vmcb_control(struct vcpu_svm *svm);
> >   int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
> >                              unsigned long npages, unsigned long enc);
> > +int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
> > 
> >   extern struct kvm_x86_nested_ops svm_nested_ops;
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3afc78f18f69..d3cb95a4dd55 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5695,6 +5695,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   	case KVM_X86_SET_MSR_FILTER:
> >   		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
> >   		break;
> > +	case KVM_GET_PAGE_ENC_BITMAP: {
> > +		struct kvm_page_enc_bitmap bitmap;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> > +			goto out;
> > +
> > +		r = -ENOTTY;
> > +		if (kvm_x86_ops.get_page_enc_bitmap)
> > +			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
> > +		break;
> > +	}
> >   	default:
> >   		r = -ENOTTY;
> >   	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 886802b8ffba..d0b9171bdb03 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -532,6 +532,16 @@ struct kvm_dirty_log {
> >   	};
> >   };
> > 
> > +/* for KVM_GET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +	__u64 start_gfn;
> > +	__u64 num_pages;
> > +	union {
> > +		void __user *enc_bitmap; /* one bit per page */
> > +		__u64 padding2;
> > +	};
> > +};
> > +
> >   /* for KVM_CLEAR_DIRTY_LOG */
> >   struct kvm_clear_dirty_log {
> >   	__u32 slot;
> > @@ -1563,6 +1573,8 @@ struct kvm_pv_cmd {
> >   /* Available with KVM_CAP_DIRTY_LOG_RING */
> >   #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
> > 
> > +#define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> 
> I see that kvm/next already defines ioctls numbered 0xc6 and 0xc7. Wouldn't
> these new ioctls (KVM_GET_PAGE_ENC_BITMAP, KVM_SET_PAGE_ENC_BITMAP) collide?
>

Yes, but they will be fixed for the next version of the patch-set i am
going to post. 

Thanks for your feedback.
Ashish

> 
> > +
> >   /* Secure Encrypted Virtualization command */
> >   enum sev_cmd_id {
> >   	/* Guest initialization commands */
> > 
> 
> -Dov
