Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53A6FDA33
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbjEJI7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbjEJI7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:59:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF7512E;
        Wed, 10 May 2023 01:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683709136; x=1715245136;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A0NIuerCq0gLJtnC3v7EccsXWqdrS67Qhp+BqPNFavc=;
  b=KRxhOGynZwyC79kolQnS0932EFPE/S8pLU3OI0ijrrXviXGYXvAIZeFK
   pFEAsKNtrLp4oPP5qK4lSFhC/oelstlUmMoiXDLrX5lqlpoM5AGsC6vyL
   JoyCpJGcKN7oXeKbNWPjF0ogvi+SOTarHuRuoec/F0NHMR9v45zncnz4r
   z+xiDSnUwMMPYoxCiZYTDJu3rnkzmLjBRRy4CgDoNwLadoUzJRGwQ8VTV
   FuLrEJhGeDRyDnHCysGhwPJ6sKnacddg2EM2R7qMVW5awzX0q0w5ZAZip
   IFJFGOSqsztsdM7hC17E32/1Lv1buRsgnKAyzWvxxi9YybLEINeWOCEMq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378262689"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="378262689"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 01:58:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="699214230"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="699214230"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2023 01:58:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:58:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 01:58:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 01:58:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 01:58:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdFMp49d+Ldeb+j45ZKYbNZpppB4Tsi+oJbRR/M0kjgVcW4AAeSZxUBNH+PD4fcnh9m6hIgqv8XdDXhQXGQf/DlRBkCzi2eSYdza3MgC1uQ1W+Mll4rvRjjMgHeAGb8h6PPdUMhOB6BUqoAB7eTKVgnTw4R6OdUMERTB9YxCLzUG7C0pZMFBQOt8He7mzfWY76AjJZ4cJx9QOxo54hbtBH8cUWZaToYoi2aLrznQM25iqYVwEPjQQfV0K2UmNzwTGTq3S4xJBGLS7ey/Ou38pvcqPhu1RvcBtf1CvLa4vhXWq2SJ/DqiZVeVagMfaKH2SJ1N7glYcr0NRFfjrpeoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1fQrRzMFLbwotZe7DFCiDftUAZTTmlW+mN/gMSyDOE=;
 b=XqnGUpDAIU7N70ehloKPb7JTVvnIZwtuvEYM9Oxxy+hqx1CDpl3adqgxACcoGrHQWygsC2wowlJexPSbdYGt0NT5jKhCXBuVAuaYXk848TyMTj/VR10G+PMafAbSnnZWihqqqXbHzWD0Avc2c4xbqbR7H7WXtDQCNc7fRSZYdAmou1ykgDZM/FUgfaWaifTuKQEYfoM4mrbtwXfUV2Hl+1nzjypf/QrFwySnD4bDjmPGBKK/pF8mqcYPVBxza27/OOKc59XQYi/VgTEVUiggHauSGF/uVYj9DKsdOVy/8E7w1HmSLI+NkIzfr+mrxHlX0xBJyhoS1Q1p/ixkiJkdtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 08:58:51 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Wed, 10 May 2023
 08:58:51 +0000
Date:   Wed, 10 May 2023 16:58:40 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <kai.huang@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v8 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZFtcwACy/1rn2Py1@chao-email>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510060611.12950-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4665:EE_
X-MS-Office365-Filtering-Correlation-Id: 98fb0285-749c-4885-407a-08db5134c5ca
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m7T7pBGJCyUg8uMSeWj3CvHrXZ7M3mNHscTGsunyVM9KxUEdJn6uSJPZXidRlUN4JoPKjLxe4rFkgeBRkMboZhgvl62aMZeJGSsQebU2Ugsqo30moPVucJQ6gJG7pSjMOZ/KU7ydw6gh1W/NE7Zx7aJ42ZVHAGCQ5WfzoZuS2W0PMvhMF99n+utFGDkrbaNOjEsQqE2o3wScV4qQ1GiudNq/J83PCkmHTxPRaCGAcUAB7gH1TrxgDgA3IsHNOclCS9Z4tvoRG6NkWriMzIFfudUDemCfIkajvAsuAR74RWFSHeFSRswIywrPznZrIdNbjDNAOGXlvkRE1jBkVfNdqPFCrZbcZIrZ3yo+sES+72AZ4Ze3blLa2YzUOsJRAdV2/JtbD79MY4ZH+flvaC/IUHu0kjLSuILtEshQNIaoEoI2G2zfHPti5Peb2e5/W8YzeSf3B1yV+5r+LwWfJlOmHxrP8PtXX+fNpju/mkZlC4ccPs/RJlXLkghcuLpVLhEpTjD0JnjRS9GQASwPCQO5M2Pm5anSsGQk2oC49PEF4qfoP3ZmzgLaygORyjPbE8T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(38100700002)(6486002)(44832011)(8676002)(8936002)(33716001)(5660300002)(478600001)(82960400001)(316002)(6666004)(41300700001)(4326008)(6916009)(66476007)(66946007)(66556008)(86362001)(186003)(9686003)(6512007)(2906002)(6506007)(26005)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eTAVUiWPSlAQR/TG/2B4l6im+3/z3XfZI/cPdqUsDWtCJFR/yUTLGla/xo2c?=
 =?us-ascii?Q?J/0J8j25d5Ld6yauYG/GKVpOv+LTXf2sQ/egVov8REgZyv3rU+fM26bBW9+Z?=
 =?us-ascii?Q?d7LfhJ0hs1HLRfGRCljGvyS0oxtYODStq0T8GnIcsA8p6vKK/MMHmvLAzGIq?=
 =?us-ascii?Q?R9MW3f2AXOkJVUmcv3KnQ+XJTX7rkc2OMG/XpaoFCtJYnS7LdFkU4n8KxuaM?=
 =?us-ascii?Q?ySFxNqjt0APxodoUj0EXOOAVnMuFz0/jmTxhuEn8uGsidsmaXXJiDjEJCgB4?=
 =?us-ascii?Q?Af+pjPfQElADGuEFeJugdBQXlkqOXFW6xLZRSATOsrh1x2J6WCo3ZYKB68uc?=
 =?us-ascii?Q?wC99f5FOr4w4Su9awEYCYur+eiQF9T3E34y6xVsLSehBOcf7WRUFtp6Io0EN?=
 =?us-ascii?Q?MuIzWSrjS2fRaCCWsTlAmQIzfe9/M3mqECRHcP2S1FdvXfKxUZDS0n7exeyA?=
 =?us-ascii?Q?qfyh/ZvvV0dTp+qvBbQfJalxbxq5HKdUaPGr1YooSwHU6DJqFeUVB5BoRDnF?=
 =?us-ascii?Q?XI45kNju8726ocnhbqQGqrpESKTaI2ZjOK2IEInpOVwc8hdf0YAhkuJr/qzK?=
 =?us-ascii?Q?qfVDV/aJo3Nt+IEhvMzT0OVf94EKCE88Yp01+rkww5z9oHMceur9pCk3T1gU?=
 =?us-ascii?Q?gx04Vxh81keBp0h7AdDBcDRGBpegz8Rvkp93kb1dG6t9aa+8e0ix5BrSVI12?=
 =?us-ascii?Q?dEk24K/bmPY/C0eFL5EWVtRi7r7/VVTDCfQYmcQ6z0I3P/Jo1wG2nR+WBHD9?=
 =?us-ascii?Q?lKofJJMxEGYFq2oqR98/r8ly5z1jPSGgEJtJ4b97yUwEvPiZxEYwwk8t8Y37?=
 =?us-ascii?Q?taOtFHsyk0+EgxQHyx1uZ0p2uNUB8cwUw9Ss41VOAMIRz58osHYHbfAnEiBH?=
 =?us-ascii?Q?lhRM9fUwzDBft46bZjPimyGsDWwROwYkBQ/O8sTZJoamm8v89n8rBrxS7pZO?=
 =?us-ascii?Q?W5HSnSzZjoyigQjEAFf+PhujPTtVne5lIRaZIhlCeDajiDdZKJyb9T7DqcI0?=
 =?us-ascii?Q?UfLKuPeqpDqRQfRVkueZw+bFwb0n+z2GcTbxqoPVvAZdZV/L9s/P7MfWXDP0?=
 =?us-ascii?Q?1BRWnQTjfgo9hMV1aDuvtcxEnZdXSKPxslzcYiWorh9JW8zNymSmt8di0Rna?=
 =?us-ascii?Q?E36brz7l15NcU8ymM1gPOPBRMkux/abSpQXx8FKN6o71m+V4PPLdiIuoz0BW?=
 =?us-ascii?Q?rhjWtHP2PcBChTiOx59hAo/mxfnbKY/nsAS2SVXipTcdZ1c/HN4LShE2OqVS?=
 =?us-ascii?Q?gpjKWgBUHrlYyVporKj2gYTobfkEX4B9SvYvJQnNhJiFdo8Y5/05H9cATPtH?=
 =?us-ascii?Q?q4tEBr/xv1GvFUWniGR7HDeSkWBxp4sbHU38EYjUFbawtzO9jnYSQcLlCEGu?=
 =?us-ascii?Q?F+zR3pPQ1NyLuLiRYzIZwNwJOTsd60tC8h/7SJ+CmWdLa7aocj9FyeKK827a?=
 =?us-ascii?Q?8HNyGFl8gOQbcsTUfdHKNj+o43uMLwZZ1+nNYnglo72kYBBwGUJPQlCUZRUt?=
 =?us-ascii?Q?v/EXEz7sVa+AgJ5S8SzfsFZ016ItuAuE/nNtAMDVqSNpnrGVTrHMqZFN+9Wx?=
 =?us-ascii?Q?TheJUliFJwQIlGbTtcOlvUeo0hCuKKGMGHxhQBXt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98fb0285-749c-4885-407a-08db5134c5ca
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:58:50.8022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K05bQMporHX5LP6pukIQpQXzNZnjmjpygdn5ZAtIKraor0WUKoJHGZkyWPjKuKShCVL3thxyuog2+R1U+O2DWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>@@ -7743,6 +7744,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 		vmx->msr_ia32_feature_control_valid_bits &=
> 			~FEAT_CTL_SGX_LC_ENABLED;
> 
>+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
>+		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;

This function can be called multiple times. We need to clear LAM bits if LAM
isn't exposed to the guest, i.e.,

	else
		vcpu->arch.cr3_ctrl_bits &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);

With this fixed,

Reviewed-by: Chao Gao <chao.gao@intel.com>
