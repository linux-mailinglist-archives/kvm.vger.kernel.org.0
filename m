Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8895EED6E
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 07:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiI2F71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 01:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiI2F7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 01:59:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEFA12C1D1;
        Wed, 28 Sep 2022 22:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664431164; x=1695967164;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cdGQWGUEA+u5/put2EruHtG9aPsaU4daIzvArZhFYeE=;
  b=DzHSDkcJTwzpjLJO0bj/+CGyR4vaOXf5o1qZvhLxwMN2kiml7VHgs2U6
   EK4CP3QmWW3uDKWNFC95No0waQ0DPdb4LH2ZWVwC/EiEqvcwojHJp9GNz
   7qSzIVdCJbxz1YI/i14hPMEwMwuqkfhqsRY2eLrUR3PiQcGHiw1ZDzRfb
   s4nHTis5qseobTfVjQvH4j9UN7fV0n5llKO+RlJFH323FoQinSv3G2LKZ
   MX4y54sIVnuvqhUlF4K8NvdCO08bO34ZFsO0K4M0o57zidRdGxBNQNEe7
   CRePE0ucgrsI5UkaV0SXr1TZxj/tELKjutNEOP0+cNVGlsEBiDnh9hSjM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="388084034"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="388084034"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 22:59:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="573329789"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="573329789"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2022 22:59:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 22:59:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 22:59:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 22:59:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 22:59:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXr1DyoOQbN9euMEtZX+Vx5g/ndoaq29K9pHrfXq5Z4abUp323lh20a9JUr6I17vIIUZg6vvRzCDV6cjMDsibFzanL63WInxKW4nrFI94nB7ar34rE070+eV1McmTW8dQzoM8z3AYQB7RSIusfz6nxLeKTt3bmeyDYvIATE9MAOyj2FNhChQAtg2jqhHnXhBbqdRiOg5jCMgRTe0i9d2lzLhEq5LOq7ECXGw1I7E7x4KFGy6opNBLEkPTPtZs3sgsj3Uafhk5mxsxo8bdSO7A3gicjXkfbKZNyiESLRlIWeirWl77scLX2fwbp9l1DoyEWUhOaHfxF7fTEIU+G481g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Grr6vdypZZjTkQIvm+wBUv/cbPaPJNyPYeAJLag4nyM=;
 b=UlvzDQthH+J67IoXmi3WZHRlx8r+e420UESuVteMXZ9G4vIh78YPUJaKo9xqJt5H2xSyiRTN/Wz0IC6mqe8dcQbCPiKK5qix5Y3vbcHIyv7ivgnIK6PxPor78Ry0wfpK6UyZCIF3rsBok5PBKYp7/EoIYeRXz2d4WSeveGJ2o2B3GwZChp+ORseX6EK9ngVBswwn+9QfV7JwdCc5avJWEY7CYOa297xN6Jafo0M24HDu6+rgfUN0wyEClEa5jKCu9cnya927fw+5v7mV3A/+aLwiSBDcaOUM6GysHZe3feBerBVppH700kqbGUPt+ITUAbueR46ZeEKFOYfDsKsW2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by CH0PR11MB5539.namprd11.prod.outlook.com
 (2603:10b6:610:d6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 05:59:09 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b%6]) with mapi id 15.20.5676.017; Thu, 29 Sep 2022
 05:59:08 +0000
Date:   Thu, 29 Sep 2022 13:59:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jon@nutanix.com>, <kevin.tian@intel.com>, <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzU0KyTx2SPRadTm@gao-cwp>
References: <20220928111604.180284-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220928111604.180284-1-chao.gao@intel.com>
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|CH0PR11MB5539:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a0fe6eb-f1e3-4df5-bbe4-08daa1dfb8df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grLjUzCHI4ObAVf7gSUFfUWYPmVlW3/+9sZ7lEC7QKlHy5cAOfpI3ybm3/RdA7o8VSPaCB2iHgUqrQM1dVeW9Jbun00Ak+ybOUG+wVr4xCN0Vl/pC/punUnWhzcyYg8hFvZoGxXVVMWv4/VNYT2cDFKRISIVo/yM4XhnXFyO/BK1RwofcB/zSrhiW5eQoygfUtbmmADtjrNvM5AAr128E4HQN61R5EKrrlFfP7lBUXPpMl+18fpTmDIH7cDxYBKDVe2CJBTGhXugF8LNgvUvbzjX2MXezklRNNdXi5VqBOKlZGup3uYqpK+VNY9LWUmKIvQbprwue/oc2t9Xcfzeof3S1SSOx8jqf2apiEKVXKX+ga7Mn03gehV7+26NYFUkfFJUe9exBHHBQvMVEmNAYFsq8fyl9XdUsysk8T/TB0D9gmA/R47sCpywKIuO8VOixHve4Vj3ZVMNAleeAW9viEZQSK+gf2S7ENKQcR54ptYx4Nt3qcaiSGRxOCV+LEH86Iuw8+B9OaOq68GdgqYPRY/InSeGXuGPXNDox/6/tb4RwmDmnqbOGbM/Lop/OclUWmFu8O4xXOwvVM2hn59BgXUcA+3MdfLrgCTp/qSPSv95dHEczlSe5WFjmp4MNChN6Z9JQzcStniZuC5R49BB9ZBQSoEpOnHnpaFpg6PapbrCRW9P/h51BYusYdj0MNp80n0klbG5HnnFS0NMBLtBMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(54906003)(186003)(86362001)(41300700001)(316002)(44832011)(82960400001)(4744005)(26005)(6512007)(38100700002)(33716001)(7416002)(6486002)(9686003)(15650500001)(6506007)(478600001)(5660300002)(8936002)(2906002)(83380400001)(66946007)(8676002)(66476007)(66556008)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zq2e6N/Lf2FciTN4SzL1DRmro/nQCHLRLZgT+/pTeQfewAobbGtu9KoO9ZHp?=
 =?us-ascii?Q?LD43+4VRv86KioTD9DxjvRgHs5i9HVzJ/7gy6/AW9Dv9YkhFFegfJy0kR2EK?=
 =?us-ascii?Q?Djbw8umlaUaSwXkH9Equ3/0htkZzOFSGlQQpUqeR6IfKRBP9y7Wx47AQfUhk?=
 =?us-ascii?Q?iEnZm8tCNRrJxb4GZS2kOYdAyicq2Nnx5W28sLRM4qi/ZkA90biTIUKCeVHo?=
 =?us-ascii?Q?8pr0DXdD9KXMKa9Fa1+V28/MKbLFblQhlbNRWT4zPk792EgRD+H4VMJHo5FW?=
 =?us-ascii?Q?qUL4zTIf4WCzsYgRLN/20LJ4PAKxgQHrsZHgeXoy5JCevDNYqXIJDWw4FgUO?=
 =?us-ascii?Q?8cKzJ2I7xVpBOODac6HGmwjSv36ARc1Nbj1zU3jhHvokCYEcwXXWtQyrz9fT?=
 =?us-ascii?Q?5Ain/BM8t7kCrj+FUedLcNrtcjiFiitIoPHlhWSBX3d5NmK1p05sAmU9dLqv?=
 =?us-ascii?Q?6qGfjuEWes5Bk3xRvzpcV1w18eUUElv2f4BSW1ZvoLZKGO1wevwMaOvSv3Yy?=
 =?us-ascii?Q?JMnMA/sBVtf/3NKjCJJ0V7uIzVsVJgBNIE7RRBYI5s3iEYkHLLzhQKF+bIY0?=
 =?us-ascii?Q?G6MgnzS17Bi5oOZEb2ulHmx0zvcRF/Odml4jxYI7R5M6nTE2XPOGuWAL9eGI?=
 =?us-ascii?Q?0fzf4Pg47lrG58EYI1EDid57fbkL6AcOlYy+zvis6jj6ITtbkr5B+sl+D60d?=
 =?us-ascii?Q?AVmKxlFzakdbrDCy+rDmXYRTMO4uqJPtjCmZ1I7JISl+rayg/zBdFiipZyiN?=
 =?us-ascii?Q?LM/vUvz0EeNOL/B/vBbS9aRIdcNU9yIQcU2qT0zsHblp1/IYjU5bNXv5vX1M?=
 =?us-ascii?Q?R86Pf9OjNUC1ME5PT7bHTq5mbgJehNwZWlJzxAjfzUeFEZ89EaEPJ3UC7J/m?=
 =?us-ascii?Q?+i64TbTP1CZ8KT1RYdiQ5fx3zR4auB3vK7mGDpmO7nDIaTjekIo2Lsrugr57?=
 =?us-ascii?Q?sLu3V+EI5PJhPjl67G5msUEHRRKaNoq6+zrssaDYJKO5jdnGvVYeYSvt9y1Y?=
 =?us-ascii?Q?F+vm/586QEQ7RLml2wETlE3o72AIb/bW362n/G3BJIS1xLlIryxhU97gpEZS?=
 =?us-ascii?Q?gp+ZWjOTjnI5+/xdpH+kDQJXqVElUpJPCp3gPpSHGiuMqpiCk+zQVPe0B+2t?=
 =?us-ascii?Q?oNy0IC0Fzn/uy6PRmdhMNlpVstl5JrhdRHcrkxjjjZ3vj2BRNfuSno0cErww?=
 =?us-ascii?Q?2l3/5nae/vPcXtdacaR3YQ0Mj3nCZE2A3sVanf1ZkF4eDA8COU74+8HpnEsK?=
 =?us-ascii?Q?5oubG1jaP4GiInRc5K3k3ujl8cIOfweLT3lQk9FqeUdT28rO0N5FbS9nbmDX?=
 =?us-ascii?Q?qVkl9ylH3uIl38JnPVxcW/0tqz0hNK0+TRjBSxa6eduechdBVrfG5ZbRFJf8?=
 =?us-ascii?Q?tZ3spOA3V3z3Xo/7j9FgPUAw0W5ejhJXnONuEhhHoBcBWivdIlM/JCdn7sJw?=
 =?us-ascii?Q?vSkhrYcN2TW9HQH5+P+47H+Oaw0EGfwEpbUc/nN8423QRMwAPCmAGUhfXK/M?=
 =?us-ascii?Q?MwGRV6PyU9oOpW/a+kgDe74xV9HVi1xZwN9/OcUzpe76/2X3i0b6Xc3L/gxI?=
 =?us-ascii?Q?X0EKsF2txsm+G2+39a/7AntKo8rHaN3qz7Z36FJW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0fe6eb-f1e3-4df5-bbe4-08daa1dfb8df
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 05:59:08.3264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKxcBjKKuXPRMBvt3S5jSLBxOY+Salzewcs7oB8lMPaWFw38kEMeBeJiMs7PARpe4e+PFormH36NvAUICMogxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5539
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 07:16:03PM +0800, Chao Gao wrote:
>@@ -10538,6 +10547,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 
> 	vcpu->mode = OUTSIDE_GUEST_MODE;
> 	smp_wmb();
>+	/*
>+	 * Suppress notification when CPU is OUTSIDE_GUEST_MODE to avoid
>+	 * wasting time on handling interrupts. A notification to host/kvm
>+	 * just indicates some interrupts are posted for a vCPU. Since KVM
>+	 * always syncs pending interrupts in PIR to vAPIC IRR before guest
>+	 * entry (in ->sync_pir_to_irr()), notification isn't needed.
>+	 *
>+	 * Do this even if apicv is disabled for simplicity.
>+	 */
>+	if (kvm_lapic_enabled(vcpu))
>+		static_call_cond(kvm_x86_pi_suppress_notification)(vcpu, true);

I missed the other kvm's setting vcpu->mode to OUTSIDE_GUEST_MODE in
this function (a few lines above). Will fix it in v4.

> 
> 	/*
> 	 * Sync xfd before calling handle_exit_irqoff() which may
>
>base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
>-- 
>2.25.1
>
