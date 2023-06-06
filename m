Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B06E72352F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbjFFCUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbjFFCT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:19:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478211A;
        Mon,  5 Jun 2023 19:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJsRmLoWTzyfyQOvxoidjA9b4XqfvkPrAdvZL4zgGyDkJjJ2YOOtwZtqaQyISwIgrYZnSWGILQLWca21nudnAA3hno8i602L+FCsufKuSqIEc/RxM8mO6bRkwfYzka7KCm0Lsccuh3+2oG72A2YmjesH2jpfnqkeZngROV+fpKHsnEtXWy90rTtwMwPWLz/nOxror3sOb1vj+gAowbcEmFn4l8xzSJnfQXjOOGKjvPZBrCE3Gc3+PjSo5TiDQo2G0Wuth2n79nIQuvWIyoPKUIbY2OqYarAjqaalulB93oke+I5Sn44U9SP+jNMlZ2lR3T5cIw57aCugFlJZESx5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJwv2v470PeNonAAOMaNkMFUuU4Mj6me9SwmYHqNkW4=;
 b=Gd94j1bqQw81+Eg2liBu2Mb1xQe0YmpygXAadlZMIJu0lE034AvcDJXB+jG1mzaaLgQeAy53zb3qcbFwWwRhFIVLhkwIX9lzF6Cq/svtxZjZsxVm/84QKNuSTr8Q4SvZb8DoQOYwTP4zEArAd7nMZGT82uRC2tlRSFRxROVBV6K7juFJMok0KS7qep6h2oeGfoYFl9g3nAh1p4dxA95Q+omNmIKGYsWr+ypmCVm8POXGQe001EtBb7wJHOH0mzK0451lY9S5d5w8NIJ1Z17CGOwIXGvufFzMUqB6jElD3UAUhRW/TnGo7DZBmw7xustDKJhe6Ds6B6Zs8AkLibslIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJwv2v470PeNonAAOMaNkMFUuU4Mj6me9SwmYHqNkW4=;
 b=OeR448F7RUgpJwT/cXTbtjB9gcMPao6k4Gtn7+y6JJ+L1z02KKLtjcAX9kyMl+Obs/PE8UmQT6RgOaAMcwscadt29XQvws2/z0qXtkdljPQ2Wj7Zb0kq+Kpvbjv7t/nfJ7C6rnI+RalXOY+mHZ+8O3Kszdl782uiBQKeV1i3yHyvdgMrg5PamlOlTHIHwiEIRQw7O870EWpVxxG4jJOYRF/mC0kSNeYRqlBTEdznEEd+N4d4GQq4BE/KSJSC42tj9ffqlSeAgwMmLx5r2gvrXr0s3hnbscePz/czE+4uSZFJyrmPvZbsIzKxBVsPQIgL/KXbGak8MlOMQFeqiP6nvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 02:19:52 +0000
Received: from DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718]) by DM6PR12MB3179.namprd12.prod.outlook.com
 ([fe80::dc79:d410:23d3:f718%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 02:19:52 +0000
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Date:   Tue, 06 Jun 2023 12:11:37 +1000
In-reply-to: <20230602011518.787006-2-seanjc@google.com>
Message-ID: <87wn0hnxh7.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To DM6PR12MB3179.namprd12.prod.outlook.com
 (2603:10b6:5:183::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3179:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4ef857-a9d2-4a06-e74d-08db663482ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62M009CQ0zz07fWvZVhCuT73GGP4ON4E5Q4ws4vtpMo8prOnxNY8Ln1ZilhVyQm1f10tiV2Gjr0Eke7sWrWxN3gTYHDY8F84I3/eyRzTwh1bgkuP7pjs/CbhT4/cdRXdh7KytHZ3idKPwUgcObdpBfmddZqGajA1PrbcYjLeMNPLXJJoh2cAvAqukfHNPfnAPu9kKAwRCNmWsBx2GCRd9X822wbx0NSZpbVfFUqzaPS1roVx0wgzh36altBxGHt6aat4T6CjFPHqJjrWx/enfY8gAY41CpdsxRy4KDLqyzmA4MrbVw/hn4DoI3NRZGwYzwZVtCq4MRqotHNOkZ78MeytTaFBBLrGlQ+dHqbQtlRKS+uTbKkbzItUHL3BkphR87448Xj/7dHI/n5ebzuIjk2KbuFA/D5sYiWLWlyoPIdtP4iCbIjwjFQr16ipZW2dUYC8krckHzRNfAUOoXZpub8yEfcsgSYgXuQL7Km4gqO98M5KASHpCgY9twxwXD86zfQvUv02qCc9/rSh8vN/619DvUYo+HseT1Vq6QsbsqucesiZMT9f2bVP4+qj/kZ7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(478600001)(2906002)(6486002)(36756003)(6666004)(2616005)(83380400001)(6506007)(26005)(86362001)(186003)(6512007)(38100700002)(5660300002)(316002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L53KD4w3UhpcPFV1ctZl+oGOdnIfU63AUbZu4LfaVlbURU+/LWRwEOQQotQQ?=
 =?us-ascii?Q?v1OVcx3QKlEDmlIvt9VDRM78XwvkM4u7yDOYKT6crUobCkFGTypHLoWorFpk?=
 =?us-ascii?Q?MCpok5/rneE5GZQIo2wfr7+aeGBqo8VPlTQuHtIW3xJzfPfbqNh+Kb0gp9WQ?=
 =?us-ascii?Q?jkK289Dm8Wp5vEOK/brMhnkZol1PQXu3NfPlEqkNGzNksDfnWVHtZkmgSCEe?=
 =?us-ascii?Q?+5t2hZjX5rBg1YiKuY6p2KPgW/zCxEldhxeztpc5cfbM7cJAtyMQdP5iQEBr?=
 =?us-ascii?Q?qUkEWc4MoVApwm561Dhe+RKC8ID4V9+g55LEpkpwfzwsiZ2rxCwttBTsFJq/?=
 =?us-ascii?Q?zQw5QoTBUjWgKHewAxbLntWPSZWgSNm/vZe49yl33ArltnlAVKk+dzwmDOnq?=
 =?us-ascii?Q?vC5p5GscTUb4QPTJoH+odKs0ZqILtwEF3TKY4tJzN3fEaF1bppDVWHHEWlZX?=
 =?us-ascii?Q?pKhi+Fw6kZz2eULP/zTvlKWL1Yev5NX0Hux9KK4mlQUq+N+Z8wGVLJkkOxZh?=
 =?us-ascii?Q?ZVImnUM1w13PzfupQM5Z0IOW10y1/D8cCc8KnC0oJUZEY8UInvdNN6UbiO/Q?=
 =?us-ascii?Q?y4rOJbol3abEu2dg/va1Liv0rQYCseKNpXVG3erXshDcumC+0qpryMqwdkL+?=
 =?us-ascii?Q?ozQ082Eyc3eOeB0ethiqr6UP4XKcNDXzrED2N4LhnR1oQbuZeqzNLACLXUr/?=
 =?us-ascii?Q?VcL7Wob3Gaxu34CIIp+0RAY6okVIPdLR4/A5/70wgypok6gTGammOLlWuvSw?=
 =?us-ascii?Q?IRrvWg5yYPu6Zt9WMSykLVsYjCmt2GgG2a/8M5sB9Had7TRf6rwZDIdpa2hB?=
 =?us-ascii?Q?8Akwdk3EXJRdK184x3PE4LY+/s8XLj04sxY+4+BKnV8yEDBShcfnyS7q0kTt?=
 =?us-ascii?Q?93punsRtA0WFia0g5Ahqr/tCWLNewsBUmhDjquxJuo3uAgdoy0yJNev/GRDX?=
 =?us-ascii?Q?mxqgU1GE+ftrUewfSBrwIQjfrlxRb3UNpcQNc5T9ur5vLyApLwX8Oh/QX5Zb?=
 =?us-ascii?Q?glamjKq41etzLo1/+1mcnYUfKCeGxuzFSj8MbtkLfv/ZZzN/peTAkGSfWrgR?=
 =?us-ascii?Q?gW/bRyFgNZVhoKi39QBGtuyKAreMjF5UbobEqpmFXBLcaA3fT7l2ICeDfukc?=
 =?us-ascii?Q?fUqvdtoFoDj/acw6wKaISFtY93I0/B7LXGFrfMlJ0oE2Nrw7ygdTMhMu3oBN?=
 =?us-ascii?Q?zNCnW6LwjVTQIaE/pmzaCEBG8i5K6UTIUDWFQvXcVVeypdJXdnwSQbbmou5l?=
 =?us-ascii?Q?ciwPPkWhrxSCPMKiPxDUz3zr0jle9cIyF88fhYrKOgyw8auKclT+V17Y7NEI?=
 =?us-ascii?Q?Jv4cMEoGoRq4pcMJlp7CMZDwTWMNG9E3Ia+1IiMZ0MsmSmy8C7Py/FrHFxdT?=
 =?us-ascii?Q?IBs/oa3al/+Ux5IWLLxdwIGPuayXAYO+at8tHDvyLbB15/38iTfpafvzZqo5?=
 =?us-ascii?Q?xoYTiOZK8TqQLFiOG2emXRXcJ8G8xauhuTtYRkGbV0kRIE6Q1a15XdXkXX8x?=
 =?us-ascii?Q?XB849oNWzK7Y6VPem30IHLc3JSyPL7Oyc6eWOVpd+JnZcnadbAGTnZxRuIsC?=
 =?us-ascii?Q?gOaY00N59wqcHOhEL36iYhQz0ns9HB/VGcEfjMYw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4ef857-a9d2-4a06-e74d-08db663482ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 02:19:52.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXmo6n5fqq6dvb9/l6PRuu7MFxWNRHPN+2GiSo9gcEoQpts71nEXYhcA6O+Gp6npHRK4KlNJ73rT5P3Vteymog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Thanks for doing this. I'm not overly familiar with KVM implementation
but am familiar with mmu notifiers so read through the KVM usage. Looks
like KVM is sort of doing something similar to what mmu_interval_notifiers
do and I wonder if some of that could be shared. Anyway I didn't spot
anything wrong here so feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

Sean Christopherson <seanjc@google.com> writes:

> Re-request an APIC-access page reload if there is a relevant mmu_notifier
> invalidation in-progress when KVM retrieves the backing pfn, i.e. stall
> vCPUs until the backing pfn for the APIC-access page is "officially"
> stable.  Relying on the primary MMU to not make changes after invoking
> ->invalidate_range() works, e.g. any additional changes to a PRESENT PTE
> would also trigger an ->invalidate_range(), but using ->invalidate_range()
> to fudge around KVM not honoring past and in-progress invalidations is a
> bit hacky.
>
> Honoring invalidations will allow using KVM's standard mmu_notifier hooks
> to detect APIC-access page reloads, which will in turn allow removing
> KVM's implementation of ->invalidate_range() (the APIC-access page case is
> a true one-off).
>
> Opportunistically add a comment to explain why doing nothing if a memslot
> isn't found is functionally correct.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 45 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..59195f0dc7a5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6708,7 +6708,12 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  
>  static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  {
> -	struct page *page;
> +	const gfn_t gfn = APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *slot;
> +	unsigned long mmu_seq;
> +	kvm_pfn_t pfn;
>  
>  	/* Defer reload until vmcs01 is the current VMCS. */
>  	if (is_guest_mode(vcpu)) {
> @@ -6720,18 +6725,53 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  	    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>  		return;
>  
> -	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (is_error_page(page))
> +	/*
> +	 * Grab the memslot so that the hva lookup for the mmu_notifier retry
> +	 * is guaranteed to use the same memslot as the pfn lookup, i.e. rely
> +	 * on the pfn lookup's validation of the memslot to ensure a valid hva
> +	 * is used for the retry check.
> +	 */
> +	slot = id_to_memslot(slots, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
>  		return;
>  
> -	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
> +	/*
> +	 * Ensure that the mmu_notifier sequence count is read before KVM
> +	 * retrieves the pfn from the primary MMU.  Note, the memslot is
> +	 * protected by SRCU, not the mmu_notifier.  Pairs with the smp_wmb()
> +	 * in kvm_mmu_invalidate_end().
> +	 */
> +	mmu_seq = kvm->mmu_invalidate_seq;
> +	smp_rmb();
> +
> +	/*
> +	 * No need to retry if the memslot does not exist or is invalid.  KVM
> +	 * controls the APIC-access page memslot, and only deletes the memslot
> +	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
> +	 */
> +	pfn = gfn_to_pfn_memslot(slot, gfn);
> +	if (is_error_noslot_pfn(pfn))
> +		return;
> +
> +	read_lock(&vcpu->kvm->mmu_lock);
> +	if (mmu_invalidate_retry_hva(kvm, mmu_seq,
> +				     gfn_to_hva_memslot(slot, gfn))) {
> +		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
> +		read_unlock(&vcpu->kvm->mmu_lock);
> +		goto out;
> +	}
> +
> +	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
> +	read_unlock(&vcpu->kvm->mmu_lock);
> +
>  	vmx_flush_tlb_current(vcpu);
>  
> +out:
>  	/*
>  	 * Do not pin apic access page in memory, the MMU notifier
>  	 * will call us again if it is migrated or swapped out.
>  	 */
> -	put_page(page);
> +	kvm_release_pfn_clean(pfn);
>  }
>  
>  static void vmx_hwapic_isr_update(int max_isr)

