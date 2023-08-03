Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2076E6BA
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 13:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbjHCLVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 07:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbjHCLV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 07:21:29 -0400
Received: from mgamail.intel.com (unknown [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEA613D;
        Thu,  3 Aug 2023 04:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691061688; x=1722597688;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VpE4E5YMg1uGa6D9RK5R1495Y8PRG6w6blXWgzTQXuc=;
  b=OKV198UW+l3gKA4On0LqYcwQwvN1pKeTqWZMxiIVUhCR9y713f9aYz4C
   Y1klYx1v6Xn4gFxJSQDJNwp9lG6xhSZY4Saal9zmYtEl8vgi2aGC5SxdT
   wFdjBpFTE3ZC3v4NtI4PDaJ292xkEnlzviyMhV6Ffg8ZY+OT7t93EbxNc
   pnK945X9hdG8WySK6+34RfVGeZnxzsp83pBuGB1kAUqjqAMufn7r8eV8J
   fHtZzNER3dhyMZPTlrMTj17C2GZfxU/rj8YkQsGNQkStqEKajtTeQEib1
   th807U3FnTcwZK6BjKKrmG6Wr2NLNIubuJtNjZHMWtYpd1ZfTuJoDDkJl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="350140089"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="350140089"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 04:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="1060220911"
X-IronPort-AV: E=Sophos;i="6.01,252,1684825200"; 
   d="scan'208";a="1060220911"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2023 04:21:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 04:21:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 04:15:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 04:15:23 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 04:15:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar7HT/zPOo17Nc94diQc1a/ojLSk9KlIwOQVKC9Iyru9dL/oDleq+rilq27bP8ffsRmxkVLnemdADCrp583w+GpXk9HbiWFNy0AEJLDDyGHkHKqv0pwl3VrjLDFzYu/g475mrvxmXKUUqqoBgpJNamxSkRpu0CZoQF67BJ+RsB4idJhg/AYZWtK95fi0lsoHOFH6tZLOwXuWTkd9r9Yb1W6mo7M2CkLYmG6k3H4K3kr2wBqzQ9x8BzNmBJwLz29UT+ZHKBIgbcFGKPkTg6vc3prYWBaABfDrQTG/Wc1kTjniYg4oHgzRQMk2B+mM83hjwR0mh0qADZ7aXWBDov3i3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNzKFaybSgjOdjfaB4Wwh95DLO6+N0u58W45ydo2q/Q=;
 b=VUzlFl3iff/jYLBFGdoziMigDYO8meAJgbCQy+MQRSRyJ5iWEIx8icRSEis2z2vxvc0iJUVfPqefY1L1Kwd5EMYw7+mq5F5ETV+ACm0sHuykCFb6u6avrT+LZCx5hsY0zJ9weinkf7/OIqfpjC7t5drc0gbRKMys7Ydxd2gNNYJbfS1jCaG2j48p5MFO6gT/X+PA8npOxfYhekfG7BsfG3sYme33nEj9EgRjm6v5X/NnnvHKd1paWSZ7RXzNmtRfFTuRGkwEzEc0/WNfDFsOAufCAdzHD5Gk3aX7TZS2uar4lceJ4PJaXAnjnpk+R+4ndi9VLFy0Ugh+7TwJwLooIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH7PR11MB6354.namprd11.prod.outlook.com (2603:10b6:510:1fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 11:15:16 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 11:15:15 +0000
Date:   Thu, 3 Aug 2023 19:15:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
Message-ID: <ZMuMN/8Qa1sjJR/n@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-10-weijiang.yang@intel.com>
X-ClientProxiedBy: KL1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:820:d::23) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH7PR11MB6354:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bda988f-64a2-4764-c93d-08db9412e99c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzQWXXF1dnaQUdmY6UlvoT061jvfnLz0i79RtO8wl+XRiyvYDK7AMwVcp8+xPdc/vUHucHjI2zeRUnf3+2gQPovWWTopbAIBLYi2SokNvXtDCdxAS457+8DK1P/+iFaSjTN/Y7soxCnppoF46Xya9kjzhxucvNFXIPPh3EPLrUShsfCiQ/LX5LSobZD7dtKDVjGG4ta579pxSoDQoARuc3/Kfv9A8GOXOPuCTcsbmVPkBRnVUZMuXXWL+QhNeATNOp9r/q88q1TKG8/HikA2OP9ZvDDCmav5W5M6yG/4GeRcOcVTh1tPmDcxJ/z1CLflI0Iqa1dvOpWhmOIkPMZMp7Up4ll5Cg7RUYlYgQ61aYOpsC5pcV8xahbmNDWOAp0c0Mb5x/sVrGb7SUMjMXv5DL1o4I3uiz9jfNDZHcAftZcrDKCAR+i9jtN6DHIVYsBCVLMsuEa9q3zFWOIqKV25Wr4IkKU79IVXOY1hE2f+vqLJ8XVJtIpWx4ns6dSiSNimx9iE4L6vwLa0vITkHlooHG24bw/XN/9qYgve3WB+ePk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199021)(8676002)(6862004)(5660300002)(84970400001)(33716001)(83380400001)(82960400001)(41300700001)(38100700002)(186003)(316002)(8936002)(26005)(6506007)(6636002)(4326008)(66556008)(66946007)(86362001)(66476007)(6512007)(9686003)(2906002)(6666004)(6486002)(478600001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MIgtz+SU/E6K/upi0ZoEZ22C3ayV6mOROVKs7WtIu91r6QZXObnvazwB2djA?=
 =?us-ascii?Q?2ryMnKaRvS5sUs67JQmuIosJSFTPfTj/A132hX9sIRKB5qbTC94qzXfF2m7K?=
 =?us-ascii?Q?ov5h2fORZuDcssw3D5ap14YNJEqTH82psmJEsxdlPUiXVFDZAk8zNTSnQVOg?=
 =?us-ascii?Q?QIDKlP933VxkaoSNPlQ+djSMzV3B7DKng9Qr6l5+ncrMXXkEgs1Jxgw5XRIr?=
 =?us-ascii?Q?7PEchRbjFJEJtMfBF2uvfKfp3SVOmTwfo0h98VtgG01cm0tFrdJ/wbjRMffu?=
 =?us-ascii?Q?pqTNiwU5XIWqfgUe4vtRwn0oaKp7T4owC6SK7Uk9Gv5Lh8UAh0jT92agtC73?=
 =?us-ascii?Q?nR4Wk+3lfuapMDwTDneY5cCMrEgXt/VtVDWiouAhOaNVZAPsrrogEnszs87J?=
 =?us-ascii?Q?qquFXKsPkkrp92GLened+7BJNljcS4BNSxYSNvZNW2ddynD4DXwepROlpTXu?=
 =?us-ascii?Q?5tcwYRWeZXpVfXFLkJPu9++XZm7KedU6AnMdkcfkLYa3fM0UD564hSGKgxjH?=
 =?us-ascii?Q?jk0RmgPx1mYqyOc61Z6vmU63+OvamUDMydD7XGsxPbjOCoZftjyhKr+rSFcj?=
 =?us-ascii?Q?BVl/NyCseWVUT8QRYcsXFp0z70aidq354qmhz9MTj8j8bDapDMRPuWjZCzVL?=
 =?us-ascii?Q?quZGZn0XJCU1xXMHpuaD3JfUrGAQFAx6dBBQ4U9K6Twqu/xyoqa8vlTXFQsY?=
 =?us-ascii?Q?96HKBUIVjNmdkHDifaxEbcodlOF1yVlKGndasJMUDtlPw5NWHpXWURuhrZTq?=
 =?us-ascii?Q?cNcO6TA0KZlWLrDub9++amJ/9/SISV5S5pxzpo+f5pywHpaUhxXHa/1h5Osn?=
 =?us-ascii?Q?tzoQlhheepN2PQvKSfBmfhCgoDclmVHTLTY6rLy1dBbIzz5UyOfdNr8zyGv9?=
 =?us-ascii?Q?eTI59J1VgxYfdfGocL3wleU9jdkM64RmLoXJ84tUe4eeXARVd+Rm8hmailal?=
 =?us-ascii?Q?oTNKCLjiP/sxfz0/r/fcAvUkAYbwdiniveE9/mdBqvSg/uuPe8uS2w9xyL0U?=
 =?us-ascii?Q?qxuF1QTJlvna8g8JW05Bx3pbksr9Tdn+Htc7X6dvSjzgKiZwMaLgLcz4wrlE?=
 =?us-ascii?Q?eB+4YxwP5akeH8OY03UrgsklgKRcUPPN29NZfZUDWKYYFKlohhPe5rFL9fNi?=
 =?us-ascii?Q?TkgWW13cAVk2Uuq4RGlEkwT6rAYOo581yiYjymdQ0BdlT39bXIm0b2ue6RwN?=
 =?us-ascii?Q?81wsWqmlB40qgdNjb3FDtZRiPPUjShDZ+IiauiDwan0lzrQtHvrskbIZdFzh?=
 =?us-ascii?Q?1hIiMYUGpjE2x1oWIJKpQq2lNsfdvdoDnNxbG5YHOU833XcJfzTdCFjWNBsm?=
 =?us-ascii?Q?ABaNBDRSUtaiOjLYDAbyvhn8eqvuUHeYrdlRkI7KLgTGATYZVhV8G2dPc8EZ?=
 =?us-ascii?Q?IpHwz3OZofZkJel5vIczpGwnVRHv4paeu+Oi7CmxdAASYapPZukXLi0PA0gG?=
 =?us-ascii?Q?jWofBDlUTCqDEtho+H7wxTkvmXHaz5gV6nYsmj/W2bRRm/zA4pZk/c4lW95K?=
 =?us-ascii?Q?41g92gFf+k0C+kNLr+ErcsHRRr/rWdjpR2Ot3ddqAqqOoTOgaJ6LCSXg0hVj?=
 =?us-ascii?Q?XuC+laYfOo03d9WHBBI1qM6YiNzDfRIClnqus152?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bda988f-64a2-4764-c93d-08db9412e99c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 11:15:15.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSyAbm6JUkJDeT7suGFNl4n01+IOr+Le21goZvPEuVtxrj+XWIbcMxDVT5go55C1Bsmg9r3KQ+yjx4ODvQ+AsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:22AM -0400, Yang Weijiang wrote:
>+void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>+{
>+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>+		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>+		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>+		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);

>+		/*
>+		 * Omit reset to host PL{1,2}_SSP because Linux will never use
>+		 * these MSRs.
>+		 */
>+		wrmsrl(MSR_IA32_PL0_SSP, 0);

This wrmsrl() can be dropped because host doesn't support SSS yet.

>+	}
>+}
>+EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
>+
>+void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>+{
>+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {

ditto

>+		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>+		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>+		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>+	}
>+}
>+EXPORT_SYMBOL_GPL(reload_cet_supervisor_ssp);
>+
> int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>@@ -12133,6 +12158,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
> 	vcpu->arch.cr3 = 0;
> 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
>+	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
> 
> 	/*
> 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
>@@ -12313,6 +12339,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
> 		pmu->need_cleanup = true;
> 		kvm_make_request(KVM_REQ_PMU, vcpu);
> 	}
>+

remove the stray newline.

> 	static_call(kvm_x86_sched_in)(vcpu, cpu);
> }
> 
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 6e6292915f8c..c69fc027f5ec 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -501,6 +501,9 @@ static inline void kvm_machine_check(void)
> 
> void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
> void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>+void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu);
>+void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu);

nit: please add kvm_ prefix to the function names because they are exposed to
other modules. "cet" in the names is a little redundant. I slightly prefer
kvm_save/load_guest_supervisor_ssp()

Overall, this patch looks good to me. Hence,

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+
> int kvm_spec_ctrl_test_value(u64 value);
> bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
> int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>-- 
>2.27.0
>
