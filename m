Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513A569598D
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjBNHAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjBNHAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:00:34 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D8559C7
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 23:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676358033; x=1707894033;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sAidSazllAMso/FXpRpcBqg8uI/bhsGC8j+QmU0dIL4=;
  b=DX0VVrh++PvmJQ0zK41IqvJWT8cmK5zGxzjFU0PiYdaHIU+0UH9hCmDi
   bCSACi80Scsugwzb3yZtUB6KC/Eqdir9abTM115/2+L1aujhfeCF0KHNU
   9sob1PlS4pU0oCrnqQs9yL/j7rW49si5G8IWcVuVDYYSCU3DP+ZC6HcGI
   FSs5e8jMSnxgJD5dJWkZptTHCLTVNX2djIFR+Xh8cvHarpWfDjZmjkETX
   lFkdNqSUtllvU2D/dwXNw54l8WoTcmSZlhpXm2H3WXIjcWUQoqbiWvjlw
   PenCK3IDLR7O/ReVqfna6nwGRXyKxZgFM3cOCJbqPn4y9Irrd+IHtDSfO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="358506750"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="358506750"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 23:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="778198426"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="778198426"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 13 Feb 2023 23:00:32 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 23:00:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 23:00:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 23:00:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 23:00:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLnXUWmh96fYYnO20jZz9lkxbJdQQQhl5LaMbhBvZZqx8zJYsf7CBf5X4IieOkvpcAWs6B9FNuXdCLNA3JQOAKucuFANGfAFJrpG6rrdh3sME2BQSCgMtcOZcStAnV+rHKrNwKqa3eONAvHUOOX6Q3JzT6Zc/mfXxtEpZXWE6le42en+ZB/nZt26/wpoezZ338Oh4x8ISn1gygwoLSv2kAOe0XIlp+TiJpi8F+jEDzhC5XdiLEl+Loz/BWljRydz2YXQRfPv5IRvJ9T7D0OibwYNEdOwkS21f8hMNHhe5oWaIOzZVA3lI6eNDVoQOHupCLq+y8FsUrxokAm2yC0F5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMJZqg46lWay54iQhq6b/RcCig/XiRtDgd4n6xxF0Z8=;
 b=SLPAfl+Ar3n6a3mC2lkRYhyR/vxp2fEYVVckIaDZdna9zio2wyvsBmnoGIJ2wl5W4/+JLkz//FYUSGOmBlATPGqj8sTYlbxYz1HoeiMQlyEhxgbIh47SYbu/wdnMzWdYqqACp13ZazsfXKLtqoyCAcSAYIc4CdvuCwbrSqoH2xJhqPqKXPl9/Ka6wSUmD27d8STc4RzwSn/PKAVz2pEmsyKn/rA72QT52J1lEikFdp8F1drsspQjFdjImYd7qhhhqSLBr51V+G3HhUgSFGcn91MXju14xAmpNm4KiGpyfG1K2ylWfP0CdAziyzB7Msseb79ZQcfBBU+bd8xnY5kw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4917.namprd11.prod.outlook.com (2603:10b6:510:32::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 07:00:28 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Tue, 14 Feb 2023
 07:00:28 +0000
Date:   Tue, 14 Feb 2023 15:00:46 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not,
 consider LAM bits
Message-ID: <Y+sxniz6PBQTrVKy@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-7-robert.hu@linux.intel.com>
 <Y+mZ/ja1bt5L9jfl@gao-cwp>
 <cd11d9bd2ab1560f0adce5da32190739f7550b06.camel@linux.intel.com>
 <Y+sn09U4wTIxoDKN@gao-cwp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+sn09U4wTIxoDKN@gao-cwp>
X-ClientProxiedBy: SGBP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::18)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4917:EE_
X-MS-Office365-Filtering-Correlation-Id: ac69c68a-2b21-4c77-c60a-08db0e592750
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvgZb293e5azzUqyvY871RXNEOGlgVCAQQInF1Hg9F1u2zClr2zV1r5tNyaulHA0ZP0M4wJcT71FsdOTS/xubJ8ERI1PjrNsrk6+di7+F5fd980FOyNqPPEDkoc+kH16fAp9LQ65ekEjiHnvxqoRQuVAMOsXucmrwd/8Z3U9d9VqBdPX+/4AnkA/WKKNhEgUjVyZK7i5jDck+tKNJOsphGNFHj3ZozltuOnfsVHa1VwUZGhlAkQH8TJuHoVIfeQcyo8Cw3xiZWCIZjtzpuKMTJdg+4zEOTriOvZCPD82x71PNB3m0VxjTLuJdkv1VkwBPLpeOd+PA4lrLFoqDh3p+pgDvBsfBIaD+l1a77pTWgXASmYOb6xNnAzIPgD0lcZbVe/6de9/IKRoJcXwhNlcrrH6gKinjnSj85VM6uoceQgzutKazEbhA47gwPFrKLYTblIMDi0kKxNOU60xFSgzdI+iU84Cu1vLZ5ShWRvVKuGG2PkOVeDXdyNvs/YOANZ8EBkIYjirH13mq1hOgZ4DmTc19Am/KSxcgtmBl/c0ccu+U99Xm8n4L4Qgug6ZGnDqkfJOUKjJ/GIZhnaIeIVk0hHpRyHHhIN7IfClUznbshFQh1l9Qro4n+eLq7GUIrcWk9gDPGPW+r/rZc7k/H916SVen1RPUeJJ7RWCwJ5q7c0YpfiNByEkBhlFpGS41tCI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(38100700002)(41300700001)(83380400001)(33716001)(2906002)(6666004)(6506007)(9686003)(186003)(86362001)(82960400001)(26005)(6512007)(5660300002)(6486002)(8936002)(478600001)(4326008)(316002)(44832011)(6916009)(66946007)(8676002)(66476007)(66556008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?45wMQ6JAAd/xm3FYpbGEG4u3m8mYNa3sJj8TJvYPNskCkYrasTPqjN00S4Jo?=
 =?us-ascii?Q?6dbNl+ry6xF/XcoutaHEW2zwvfok3l/vYLExxcceKPliYM9t0OpchNTVLm7W?=
 =?us-ascii?Q?/44c6p3oQkuWPM6GWyW9hVjmrZKZk3UcvjXtYToWzI/YPXTMqMuDBoopZSUD?=
 =?us-ascii?Q?z1PYVEuPfQxRiolXyG5VpuNow840WWXo2cBjQ8HS7iMEhjSEnJ5y8axGnD4Q?=
 =?us-ascii?Q?SWDVO8vAKpBcEKLZ99K/ENy4ubVLGjx+78K4PGYtTQoEpN3YPL9FW1+t+X5K?=
 =?us-ascii?Q?EtM9Hja3S/NmzM9IHXg/v/xlopIaCZS4X1UA6jfIzZuOBwtY9dT19tJy+TGn?=
 =?us-ascii?Q?ivcG4mXpiZtcNbMTKZm9tFwxyuIK+gJUw9/aSWx8MHnPtyrrgUtc97xxV0G0?=
 =?us-ascii?Q?WCFfgrYy2lCjT1ffCVfxTaNjetMApzj91lqRMsYEo+BoQZSxS1CYDOOvizmL?=
 =?us-ascii?Q?5DgyMQaTt68HtvcsLe0e95kb5ZT8YpCNmRC3j4s6aRk7Qr+NFeroCqCFoKax?=
 =?us-ascii?Q?37YCNLh7HRNp9jiYEDkc3qSDqwnHmsemmmTYt0Rh6j55dMP2irU+nP+C8EyB?=
 =?us-ascii?Q?MEarz2IJ6Gwkse/CV23WCqEb7DiUoYOsrOlb+uN7hsOY9civN+0d47e00vmz?=
 =?us-ascii?Q?1kbuEs19x8auChzmjO5mcML05y2HDB5n+fCpTJe0M5HxuDvvgh8+L++ZVnyP?=
 =?us-ascii?Q?/qGit2DsWmDoFV/qHJ2gWzcnqZQkgZoYkhmcEgAr6httZL88nu3edfrribkJ?=
 =?us-ascii?Q?baJ4lOQ04GeXd1Ok42Xg2/Ex61QnmPTB/5+zV0JX98gzw/nnM4JCVlsZimbh?=
 =?us-ascii?Q?beTh3Wv2mROjZYgdWgdk2PiMY6f4jYX02HdP4p2xTKe74twrY78nW5EjiSfB?=
 =?us-ascii?Q?i6VHvdNvcks3BYzibyIoeVHwA6X1AakO7/k97JZh5uAWIjOd1otaysMP/RRn?=
 =?us-ascii?Q?LWqGw1MY1nd7qrIeiGIpTlSsAC0eKAabcykPgkIG9KBXYboTaY0GUHcMK5Du?=
 =?us-ascii?Q?R0mOPoAjx/EpihmBzXtGNXoSwKAvDT/t+ENE/m3mZtjqkwxTi/ZRK/FPGl+3?=
 =?us-ascii?Q?WNaqV7B7Mqa/yod1SKJvgHrjLdWe33Or98YyzLgobzkiM5gJtZb9r0eEOWcS?=
 =?us-ascii?Q?ldw0J2KdkilaOxHJ6KYZj//1VN3M8K5pvf2SCnMlOmivmPGsaN/3l36booCw?=
 =?us-ascii?Q?pOUU30t/vg6lQ/Eb8bihOWBIFmd+Efu+bvLsYSgACmTEf/WULp6/7ql1g0l2?=
 =?us-ascii?Q?rpz23gHDyU9J1iUs9JGT+ij+OH61ybx+t1Iv7jCln5aioGewNlLyXu1sYOUc?=
 =?us-ascii?Q?jJieRdPBu3uYBrC7qBEwPCbOAUUIT+R0FMBlSDYBuyT2lHRHWxo5MHzd+bEg?=
 =?us-ascii?Q?7qBL7pjpKftsqVnuu1ghVlr0YX7mCAIf4JsbUcsIhReITbPHir5QYX9UVpyK?=
 =?us-ascii?Q?rO5lvzpTO7e1ueKQTafhApNh92eArOqwtU9Z+BG3CgnYWTcQyaw+0zj4thpL?=
 =?us-ascii?Q?nd/CLrL5bSG1hgzs/1N5MvM9L+G/7JFup2ljD3YSscnheto/q9yTbXu3wzXV?=
 =?us-ascii?Q?iPjA2j9ffrk6fwH8F7X8BbbqoBliJBQ6LcZkwtki?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac69c68a-2b21-4c77-c60a-08db0e592750
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 07:00:27.9258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxYWGkOHyol0s6GrFJyQ3t6IM6NwznJlYTVgiQ3QlSHQ4n1aPs9X9nTu4tEtEYrpXsXzoG4taQ1bwV1gaUAv4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4917
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 02:18:59PM +0800, Chao Gao wrote:
>>> > 	bool skip_tlb_flush = false;
>>> > @@ -1254,7 +1262,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
>>> > unsigned long cr3)
>>> > 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
>>> > that
>>> > 	 * the current vCPU mode is accurate.
>>> > 	 */
>>> > -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>>> > +	if (!kvm_is_valid_cr3(vcpu, cr3))
>>> 
>>> There are other call sites of kvm_vcpu_is_illegal_gpa() to validate
>>> cr3.
>>> Do you need to modify them?
>>
>>I don't think so. Others are for gpa validation, no need to change.
>>Here is for CR3.
>
>how about the call in kvm_is_valid_sregs()? if you don't change it, when
>user space VMM tries to set a CR3 with any LAM bits, KVM thinks the CR3
>is illegal and returns an error. To me it means live migration probably
>is broken.
>
>And the call in nested_vmx_check_host_state()? L1 VMM should be allowed to
>program a CR3 with LAM bits set to VMCS's HOST_CR3 field. Actually, it
>is exactly what this patch 6 is doing.

Please disregard "Actually, it is exactly what this patch 6 is doing".
My brain just disconnected.
