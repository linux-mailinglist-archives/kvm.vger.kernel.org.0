Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA06A9B37
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 16:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCCPxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 10:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCCPxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 10:53:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A8B211D
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 07:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677858780; x=1709394780;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1fSj9A/Omrx5yXPpbs5GBB4wDI62TWDIAj8Vh0lVAfI=;
  b=CNBpm5aF1YkzmIWTO+X/zwTSC8RuiTfQ7qXLWsygxqH0tsQ/dTrEEKCn
   dC23xRFuTcvjNrGDe+DOpFY1T+N4kL/zgAA+bpnzgMIAtTJxtxz3SN+oJ
   vRjUOtY0Y0WHQ2FQ8lz7ad2jmpwXcrNvRmTcry5ubns5+YhQdu4Y2Mn8Y
   tl2mTbCWmxkUUwKsqaGRY23c7yYFxiesNUGXNTIXmMtLcAQaYNXY/iA1J
   EdVavKOx+VsdxAH85UTTaIr1nI25maU6tMn0FYU3y819IrOYDIDQSBObF
   AI0dSFmj2fQiSb8+N+uSJ0dvzs1nYbPBErOYEs1jRA9of18sW/HEqwCfd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="333795412"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="333795412"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 07:52:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="652831233"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="652831233"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 03 Mar 2023 07:52:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 07:52:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 07:52:57 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 3 Mar 2023 07:52:57 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 3 Mar 2023 07:52:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsMdvPtnNJhk1D3Jv7qeVBlm1FRocrCVtV6F8s6CCKQWoPYpdA8nR1iUKZxxBoVW538QqPbUYQqZ/n2hnmeaCQhZHAs2/B7/94zm9JAP3GSHYBr8yBiYUD8MDF1dAad8ZSzOpnYO33OqiVPmL2PvP8ISryJHzFwkI0Z2A5CrM927Z2IeVUXGTRwmc7BGYT18wAE/LI5aBW01o7wzwvqcacE7cINkaF40v58CnG8+tDLhgZp2Jd0triN0vgBQ7LgcqcA7nbMp6nIktFe+nX8be2GEgZVdXq8dD8TS+Y7Olsx53E/11wI/fak/kSMnjdPDc8nkCQRR4gmBP7LRQgGZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzJFCEPJoRtwVnUQ/NkKRiMK65Bs+m9lUsOfQRzCruw=;
 b=M/xN0ua3vg+i8TpUVyeA00KNQkus1TLpL36IEZPYCwsj5VkEqtoDUhRgpg8HpjE9SOaHL9h3a9zVWNQESUqnKgzlYpMZH95dY0jNtD6KQWMu9+HfXio9NFXTHob6QtPpIQxJiu+0wIPGvBcx1OjHzFo/LHBSW2J2RIb7iUCQT5GhY54eQZYx2NbWNzuTGXdVW4XEjD04QG97+bU+D6aBngTr24GfZHKHw8TArHV1+uW513RbqDnc4GzZmkzz7HglLgw88dI0Fo0h+jBA7ODiI3JqdMIHgW823cjWDXOA+MCjBb3iXKBB5DNaxPVTr/yBmSBuedlPdqxoJmrVg0GTwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB7278.namprd11.prod.outlook.com (2603:10b6:8:10a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 15:52:55 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6156.022; Fri, 3 Mar 2023
 15:52:54 +0000
Date:   Fri, 3 Mar 2023 23:53:18 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <binbin.wu@linux.intel.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZAIX7m177/rQEl22@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-4-robert.hu@linux.intel.com>
 <ZAGR1qG2ehb8iXDL@gao-cwp>
 <580137f7c866c7caadb3ff92d50169cd9a12dae2.camel@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <580137f7c866c7caadb3ff92d50169cd9a12dae2.camel@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0139.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::19) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: 60cc3168-05e4-4e66-eb2b-08db1bff5a06
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LTODToxZdcStN3Tjd+81EeRH1TL+N8eTx49ftpzHbWVxEwKtpg/wrCojBuSadsG77agkPSs4HTLvF2mmJ+rFA0yX2AAW4+IKEADe+HQpDRwsknxTdp/sCi0MkMbV/UzpGz4ouvRc3gjC3SjJuJqW4oybaY5u0Xz5DcYFSEvZhQy2ZWK5wS8XmTMbdELl6lq88BTCoW2wf4Aijni5PTeetBBH56AKlu0Ob60hvAkU8p+j3ejk9f/q0USc8rGZDcgyCmyofUfx2t0l7eBHiQyDLza3Jy/Q47OtDimIfEFKYv7RRZrgu1cHYL7VevOzq4U2OOR+eF7Jb7FZCCMNmYbuOJQZeoDCzE0iX+b2hiSH49hAzU0UfgmCT40JxN8d5hDpC5w5uSi6lqZh9Wp5jQkycA2wEkiOUfBEn3Fi1DIOjrCOSED5NDB9F1RA+9b44EEAObFM0IICZjV2mzF/jFbsijrAAlzN7qVnL4cXc8ou9L4riZjBnEY2ChdpYvajFKfm8pzPG65LGfPMvatufHUcIlxC/jVrd1pzi5F0D+kpxk9S+bEyEr5RzUirB58QKnUxCSf0eEp9B3sT/lirZAFvGr7oxcNNJBRFqmG7rfH9+i/oh/cDkGCvpKuMJzrCcYKZ+eR0MT9mxFb/mj+jLTr+Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199018)(6666004)(86362001)(66476007)(6506007)(9686003)(6512007)(6486002)(26005)(186003)(316002)(41300700001)(4326008)(6916009)(66556008)(66946007)(2906002)(8676002)(44832011)(478600001)(82960400001)(33716001)(38100700002)(5660300002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8d5eSwbdCWBLF7rwBkq08JZh2HutaUyq9YeUix1HanQwv8rg4GG6DkaDyNI4?=
 =?us-ascii?Q?punQs88GGyS6oIURlXHHlHInfNHRHfj134EkqvzFNWU/vcXTHBt7i7wXibiY?=
 =?us-ascii?Q?/3CGP+ODczDGjXrej/+oXnIb0wvR71Zcl+1NDekWUQr0LOmawlnk6Qfe61yx?=
 =?us-ascii?Q?LvTzUCdYvo/YQelnRVSpHRAr1OpviMOHbyVptR648EmVD1hIAcXRTMHXpGUP?=
 =?us-ascii?Q?3AgnZhQ/OsHOrKCfBNB8E5WPEFavLaHAV6xEnq88HfKsfUj1zNyeHIwFFwcb?=
 =?us-ascii?Q?9SbXnZlIP4Nlyr6Upy3xZPNhQusSZIwLISLz+eDA3zQgLCufMuV8RA14ISn5?=
 =?us-ascii?Q?uLHMIFz2JTVIiSDT4jXki+Bv1cndV7jqkHBN+pN+hWfXbHqnEIzchdTDSyuh?=
 =?us-ascii?Q?2Q8DG8Gg8/wqr/Y3ul7ALtzvs89ct7azD0MNavzDlWUHltyQkw7u01iFyESE?=
 =?us-ascii?Q?AdO+Vbg/r5LOe4TOt6lebk2N6Idvt5pWcnT7ds6FnrrmfeW3NsM3dlyoV8Oq?=
 =?us-ascii?Q?cCzZ21Wfw3TpF3M0NoVaWyL27y82H0FeG8Z+o1lCee/mTeaWDwZhJz7nabai?=
 =?us-ascii?Q?XLblRVOXQPjxyFmsG2uJw3/9EeJClm1g/RM9Pb12/Hr1vu3shoQGn0S/DQcK?=
 =?us-ascii?Q?DVzNSdmjZ1NYiIyomGWsvuVOyRwUH6dL2s0PLCNwsT5CDXBa1bElSNW9Tkv1?=
 =?us-ascii?Q?YXyBLxRNxoF/vkjWzA96AhRiEYwoa8dhP3AwSHICfLNChGnT0POUy2zdkIOq?=
 =?us-ascii?Q?Awau/QAuztOycpXCTdIsr7uA7SgbzTJJ0/ZdS5Bm4INdYIZj8GUd9aw/TcUX?=
 =?us-ascii?Q?htMs7CxIh9O/YgT4Dfarw8HdqKXFikUbBP0msXofosff+//HESxwiF3ZDdZM?=
 =?us-ascii?Q?hl2XWka+m7d4xqSBsvkkKGmABsKRo4Ge3MeldHjzlSS2X3l3ORqVwORZb2Pd?=
 =?us-ascii?Q?SFxtkPGijR13O7eco+HJoefUt8lijvN5WPRyelEL/4N8RKVuktbKdCIPQhA1?=
 =?us-ascii?Q?ByYG3EZUZqpGQyZTAo4Yz85R/xC1Vz5nNxeJ1OC5Vqd4jsi1BlR7R1fZXVSZ?=
 =?us-ascii?Q?LJ8AMSMsBnzGUm2nsJeam2pg3oK1hpRYr2eeaeu+fWVsMt5zD0G5uBkveMhb?=
 =?us-ascii?Q?NFscnX1sJGR29/PQg5Y8uYZcq15PtikX4L+7uD3N2bGpZXeSM5ureTveVYoQ?=
 =?us-ascii?Q?i5EWBR4WqCNH7N3+oJef4zIpUM0qQKTGpl3pmOj5PHT7b3h9woFFdXZKQDdf?=
 =?us-ascii?Q?f1H1mVUv+apHa25j7/uusnMveLwWQqCm7ZJMXezcXudo9e8fHDTKha20Jr9X?=
 =?us-ascii?Q?+sUKUtqTgXuKqOeHP0lf+1ZpLGN10AoN0IZcpcGHEQalxemJXtEKJZaUjWEE?=
 =?us-ascii?Q?h3/TW0bKJ9bZaq7i6hiBhfNbE87g0B6rF02Pz02DX58hSohr3uHDZ5ad/oOR?=
 =?us-ascii?Q?D/0DLspTY3S5VJ5UyOWeJEGl4s/AYDnT6ohcl/M6uMWafNekwr1bC003HUL5?=
 =?us-ascii?Q?DG5P7XC6hmbjIbuf42WhMT2J1UIZGeC1nXnYY3pPFeYIosMX8qV+YKeR8+21?=
 =?us-ascii?Q?2n/8UITZk66xH2VgHg6oh1BjE7GVbwKiUvpPAeKn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cc3168-05e4-4e66-eb2b-08db1bff5a06
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 15:52:54.5476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAbUOiAwTkGy/q3zJNwmcKR1GlS+IBTgiLArHqXD9cStVhbTlVa4+UtsIYmQ2xtedF0Ho4sKcHjzVhzji5avOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7278
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 10:23:50PM +0800, Robert Hoo wrote:
>On Fri, 2023-03-03 at 14:21 +0800, Chao Gao wrote:
>> On Mon, Feb 27, 2023 at 04:45:45PM +0800, Robert Hoo wrote:
>> > LAM feature uses 2 high bits in CR3 (bit 62 for LAM_U48 and bit 61
>> > for
>> > LAM_U57) to enable/config LAM feature for user mode addresses. The
>> > LAM
>> > masking is done before legacy canonical checks.
>> > 
>> > To virtualize LAM CR3 bits usage, this patch:
>> > 1. Don't reserve these 2 bits when LAM is enable on the vCPU.
>> > Previously
>> > when validate CR3, kvm uses kvm_vcpu_is_legal_gpa(), now define
>> > kvm_vcpu_is_valid_cr3() which is actually kvm_vcpu_is_legal_gpa()
>> > + CR3.LAM bits validation. Substitutes
>> > kvm_vcpu_is_legal/illegal_gpa()
>> > with kvm_vcpu_is_valid_cr3() in call sites where is validating CR3
>> > rather
>> > than pure GPA.
>> > 2. mmu::get_guest_pgd(), its implementation is get_cr3() which
>> > returns
>> > whole guest CR3 value. Strip LAM bits in those call sites that need
>> > pure
>> > PGD value, e.g. mmu_alloc_shadow_roots(),
>> > FNAME(walk_addr_generic)().
>> > 3. When form a new guest CR3 (vmx_load_mmu_pgd()), melt in LAM bit
>> > (kvm_get_active_lam()).
>> > 4. When guest sets CR3, identify ONLY-LAM-bits-toggling cases,
>> > where it is
>> > unnecessary to make new pgd, but just make request of load pgd,
>> > then new
>> > CR3.LAM bits configuration will be melt in (above point 3). To be
>> > conservative, this case still do TLB flush.
>> > 5. For nested VM entry, allow the 2 CR3 bits set in corresponding
>> > VMCS host/guest fields.
>> 
>> isn't this already covered by item #1 above?
>
>Ah, it is to address your comments on last version. To repeat/emphasize
>again, doesn't harm, does it?;) 

It is confusing. Trying to merge #5 to #1:

If LAM is supported, bits 62:61 (LAM_U48 and LAM_U57) are not reserved
in CR3. VM entry also allows the two bits to be set in CR3 field in
guest-state and host-state area of the VMCS. Previously ...

>> 
>(...)
>> > 
>> > +static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
>> > +{
>> > +	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 |
>> > X86_CR3_LAM_U57);
>> > +}
>> 
>> I think it is better to define a mask (like reserved_gpa_bits):
>> 
>> kvm_vcpu_arch {
>> 	...
>> 
>> 	/*
>> 	 * Bits in CR3 used to enable certain features. These bits
>> don't
>> 	 * participate in page table walking. They should be masked to
>> 	 * get the base address of page table. When shadow paging is
>> 	 * used, these bits should be kept as is in the shadow CR3.
>> 	 */
>> 	u64 cr3_control_bits;
>> 
>
>I don't strongly object this. But per SDM, CR3.bit[63:MAXPHYADDR] are
>reserved; and MAXPHYADDR is at most 52 [1]. So can we assert and simply
>define the MASK bit[63:52]? (I did this in v3 and prior)

No. Setting any bit in 60:52 should be rejected. And setting bit 62 or
61 should be allowed if LAM is supported by the vCPU. I don't see how
your proposal can distinguish these two cases.
