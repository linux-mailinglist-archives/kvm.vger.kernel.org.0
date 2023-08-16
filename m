Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF4E77DB57
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbjHPHpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242536AbjHPHp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:45:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69E0212A;
        Wed, 16 Aug 2023 00:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692171926; x=1723707926;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=K9iROdff5j1bWpzN/1sYpMcs7db8UupU2BQzH8dZAOA=;
  b=PT/mes2F2wz3/E+QG7dgbouozQsjmVgKB5RYjp8yscLOrknt04IZ61XY
   OC95EPAbHg3YqK9MEdP2ed0/znPQbZ8t0GcQuJxL90JinzLPHyseIf/yh
   puNZ8IPb1Q5e+WjEyTX1EHQ1I0Cv9JzGpomjrQ1+G4ry65pBcG5YQcLmD
   X4Eu3Hf+GNUb2dFzh2z2/NYRvG487OJAaXIhBjzR3BKMLBnsGwBG0QRYk
   0ivyx/dBZkBIhOib4mfiKf2MqVY73lQOwFXwMAETHuemsgtNcaBhDn4KM
   uniV32syi0wWwdKvCooUsblsIbb+kqiU4dPKoCVyp/3k0gji9Nz7ssMKj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357442153"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="357442153"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:45:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="769092087"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="769092087"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2023 00:45:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 00:45:25 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 16 Aug 2023 00:45:25 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 16 Aug 2023 00:45:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 16 Aug 2023 00:45:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDRY0X+D9TREznlLcVWBHldcAhAELYP8syTOEGxYAvGFeoJeH0Zi72x0Rzd5Caue1uLSvTSEb+aQs0dQv4Qyqj/pg/f6knXprfrwmnuyxYf+7BtVrPMVhXT0Q0J7btCZ0m50zJ5IzBqXKzuOb3eN6lfXXK5RrNMBN6Hs7s3Botj1ncJWtI0tCUdWnY5CeAqLR0Pyn0PraN6vyviqT8cUNz87BGexYHwcZLIOCm+TQ1KmDK7wW4OsBDVurPWzZmMff8vDVqjMJctYc8EniXz2CqD3LjawlT1ypjh86stm9wblekO6ywceRMV0Lb9KrjXOjd8zka8wuV14cZrwIQMxsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K9iROdff5j1bWpzN/1sYpMcs7db8UupU2BQzH8dZAOA=;
 b=EsXaqRa6eQgpWcaLVpTSk2iViX2vXWqd3p/XLMrIWwGSjuZidz91nLKkLUl0dMBzvFD33pqsC0aI3+HU2qsENTkWQ/4ruuUAKY04EF59QMSwypmytn2piIyJ7ysIM35syyb4vA7rNGhgbTs2pQf5/T84l2yTLiaDSWNxjIk/jep7P9Q62kva2GIhXMeeRnVSlBqdfViK+ofs2lz0mO9p0mRgltN2n5lkbJiPyDcbeBgGJHVw88zTfQ9v1qt/sMMrmWkqhYtQdnignJxAIwXawzecVObwzrfZmA0PyVocIE4fX6+bLHFMJHUeIebeyLAE+egyC6mPZve5c/HBXJaalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7552.namprd11.prod.outlook.com (2603:10b6:510:26a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Wed, 16 Aug
 2023 07:45:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Wed, 16 Aug 2023
 07:45:22 +0000
Date:   Wed, 16 Aug 2023 15:18:18 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     bibo mao <maobibo@loongson.cn>
CC:     Sean Christopherson <seanjc@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <jgg@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNx4OoRQvyh3A0BL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
 <ZNpZDH9//vk8Rqvo@google.com>
 <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
 <ZNuQ0grC44Dbh5hS@google.com>
 <107cdaaf-237f-16b9-ebe2-7eefd2b21f8f@loongson.cn>
 <c8ccc8f1-300a-09be-db6b-df2a1dedd4cf@loongson.cn>
 <ZNxbLPG8qbs1FjhM@yzhao56-desk.sh.intel.com>
 <42ff33c7-ec50-1310-3e57-37e8283b9b16@loongson.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <42ff33c7-ec50-1310-3e57-37e8283b9b16@loongson.cn>
X-ClientProxiedBy: KU1PR03CA0043.apcprd03.prod.outlook.com
 (2603:1096:802:19::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7552:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e2ac78e-13d1-4925-99b4-08db9e2cbef6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qyRCFlCrhvZEBqiq1KZOeiXWf/fQV5OShgIgWfgDWSCazfakbm1z4TJXwj7IuUlkuu2oXapxpgGvaLNPQFhmzzBhZsvDNIY8Oba/SG9EhFqx10lNY7oIABQMKpvHmjEEw72VC/hn+D8N0DYBVelVObT11KwKXdbC23r/yTw+bWdBmTfJV6+m3hMIBc+Qk3DtRi9tlpIEceWtGb0+t+P0nLlLomyw2qa4CVvWsixEueLv3xu2E8n0elW/exkE6+SZ9uPAt5iyAc7nJwk+MHjL+/cJXzYKSCKJe8lwbCVL8mmzl40AfyTNLs/GdR5vopBpI0nnig2UA+yysRutNkPn9yI+/iUpWmbEkygwfDLfLzVn9KGMCvtZwhRMYpV1aKYqunJbZIimmO00d6ULlv5BUwZ2gtFrsiRcKWtvx5BgmLWA6yZQT86XwuRiNSt+CajcKU8TvTXbhyKbwOMonpb9P2QF1p6dC7LZAoe1WN7pRc2GAd5VAMax65iDh9yZ3lO6a6fOEqArdW3rZ5qzQ3Jv0i81p5UHsdJj7G/xhOPu0eXjvA3HPzSyWmjjSOABMEEn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(346002)(136003)(1800799009)(451199024)(186009)(6666004)(54906003)(66476007)(66556008)(66946007)(6512007)(6486002)(6506007)(4744005)(2906002)(478600001)(26005)(6916009)(7416002)(5660300002)(83380400001)(41300700001)(3450700001)(316002)(8936002)(4326008)(8676002)(38100700002)(82960400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U8eTsebPoGzEP48VgNDlx3f9kUVLxB0q/pQ/QKKA3IE5LHCRk3gxVLZyHmGa?=
 =?us-ascii?Q?6o90LWxjHP7p3vu6w0Rj+x2tLb/yERQe4GRVkJ8vTKQXjSeO1l1FSx+ZTYri?=
 =?us-ascii?Q?iNJF15p/ybL4ZAlPxEx8HSkqdiWX2XdsFFFHQD4SG14XX2eRWjfkZfw1HneO?=
 =?us-ascii?Q?n7GTvOIhnyPFYRCOHg6t2RvOIjbFuidvrs5mJWx/CM1+pu79X5VUOT9AplNl?=
 =?us-ascii?Q?cbFOGVsO2Evp24R6vq0s/OUngNJs/GqFcd3ZfFAW5FBskeb3RFR+3n4Wpfv2?=
 =?us-ascii?Q?uxBtrPF3UkNaDI2ck/bEfWzz8+YdlZPr+6Ftou3iaD35ddz8MvrIlO5Zm12m?=
 =?us-ascii?Q?c6jtc2BEMkI4RQRES77XoHgJ1tEIPAwVBnD2z08ldcGk4mOMHHFr2Q0HjhBe?=
 =?us-ascii?Q?JgGSh9113edgLb05P+cxBVKtu6TLnYXCLN4aIgRQgGMZTiggxFWj1H3nxhRO?=
 =?us-ascii?Q?TcYCaLYhw1PqeH/VtoKpheeO9OAKcw1qnJ3TdJjpebY/kS+9GyPY++XC/BNs?=
 =?us-ascii?Q?Wg7dcVqxkV9qRZ5ihm+0Dszt5PkEc1ytdGtapP9ZVg66qkvYyMEw+I5VT5k9?=
 =?us-ascii?Q?l8WwdTxZ7mRMp0IivD6DS/Pi2itmcWjxLoerprhO563h2sEwwf8EGJvIc7IX?=
 =?us-ascii?Q?WkdKjyu8h6s0pE1L+caTAAZr+16yOdm3MfZLYSOl1/xPd/0LzUNPptmobJ4x?=
 =?us-ascii?Q?Ywra4F2IQHClsMtRFPrw4Lp4WxGNdIMohih5mBOddDXXqZSmKgar9RCgNjnT?=
 =?us-ascii?Q?ns7LKZrcHTFuG3N/TNT66/hgz99IUYYO/+22+aOjwu6RuV8lpVZbzXV+1dna?=
 =?us-ascii?Q?06pmwnkbssHa6bTfO7YxwQbQf73Oe0ynQou5mO9sNMbjLzi0Gh2nSwdSE5V9?=
 =?us-ascii?Q?SKWFRE9U8ArvexmnV6PfaF4dLHEdVgtVecmzNSxuyv/GMukUJc/GL+uobWfy?=
 =?us-ascii?Q?D7vicXFbTQYhRMd0xBauAOyU3hcKG7oASA09Ii1+AuL54z4GEMjBfIYvx29u?=
 =?us-ascii?Q?2+hFEJKPHbaefpidMOtz/OAk07A8QaU5UAulM+fC4oN463jrARx8h4AFcHB1?=
 =?us-ascii?Q?kaJh3fS9WQ9PWoNbSiALj8o3d0A6zEvvi2mh3oCX1SklSPvtbbM4wvF06/F/?=
 =?us-ascii?Q?Yxk5BcaCW5geZcDNXrJCVth/bLMxOyq2kLXS24KkYmt30S1u4Z6BVmmiQEtl?=
 =?us-ascii?Q?kzPPmMrdZr7n0X4AOw1LjBZONYKQiNN/zW1VYXFgIWB7eFKaLfBIONuMu/Ol?=
 =?us-ascii?Q?kR46Bab0UV11jbQt9MnNO3YaotXQKy+ZaYvqhV/rUN332DXk9kbV4RkIC+h+?=
 =?us-ascii?Q?lvzzhKpu1/i42I+U3B84z655kLbLUqCMGbyKQz3/zZKOPeYxPVfg4d115L+T?=
 =?us-ascii?Q?KrOpCpcuoYUqGpWw5YGvlzEmL5lcMYCkVyrHNP7kHoLLJBTF37n5NYj6FBgX?=
 =?us-ascii?Q?fR0L2Hhx3tC2HCx3b1fhx7dV206pvVdozRL7WpYjiCq9dVD8tGqF+2717EzU?=
 =?us-ascii?Q?igDwllbUgdZWTu0Jmwrhf81MhLQzeg0DJF465a2hUOSj3YMbNMMFyptaPuBV?=
 =?us-ascii?Q?gF5W97573ymnmdvVLHk0p9BuDTCjF5X7YaBIeFh4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2ac78e-13d1-4925-99b4-08db9e2cbef6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2023 07:45:22.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbThyDpkwoul/rCaBj9qkg5Zex117TyzE2IAt/NrgRIGa0sXrlHyRjYlgpWymSY7K25+TzftpS2w28deHv2Hjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7552
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023 at 03:29:22PM +0800, bibo mao wrote:
> > Flush must be done before kvm->mmu_lock is unlocked, otherwise,
> > confusion will be caused when multiple threads trying to update the
> > secondary MMU.
> Since tlb flush is delayed after all pte entries are cleared, and currently
> there is no tlb flush range supported for secondary mmu. I do know why there
> is confusion before or after kvm->mmu_lock.

Oh, do you mean only do kvm_unmap_gfn_range() in .invalidate_range_end()?
Then check if PROT_NONE is set in primary MMU before unmap?
Looks like a good idea, I need to check if it's feasible.
Thanks!



