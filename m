Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6BA7AC9E5
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjIXN7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 09:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjIXN7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 09:59:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C26FC
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 06:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695563933; x=1727099933;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=o7qpIUjdjqm1sbjifNSXMYmNxBJYgeirKHuAswG15l4=;
  b=dW91aZJ3xMayvIARfsBMrxUmSgb3bPeEDLgKQoy+A4J5yrg8q2hSK/If
   zdjVFmQUMuBiabjj4MOGi8SNsGsXiAXtGU+i/YApqFPKwfCa6RWBHid05
   Clll7YW79jjBHieH260zSmPjeln71gHGULOrKfNzR9jX9k+7xXmJmTFln
   ETbzycFry4KDeEhzg4gOn3wJ6viWVP88zkgLmwkpxRL7C+wEteQlBvRm/
   2GBcu+e9hgQX4VVx2SwkKKyvdY1rIkfPxTvYnofO7yqYSsnPffvs3ObPS
   e9zVZLo7E/rTT3oH+74ljqT7ihDMkZ4yEDKGUiuYu2o4ohx1CqxcPWojG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="360486123"
X-IronPort-AV: E=Sophos;i="6.03,173,1694761200"; 
   d="scan'208";a="360486123"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 06:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="777393910"
X-IronPort-AV: E=Sophos;i="6.03,173,1694761200"; 
   d="scan'208";a="777393910"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 06:58:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 06:58:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 06:58:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 06:58:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 06:58:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lm2GvKQ+qHG0QvvUZSqP7lfCbZO4Hy3w7hUygzgAziVS0aardk6J8xFUeo++Qj09uJA2dgD2Ikn48ptwVjID8yy8vP21eXZy8VBDpC2Iv0EoM2e80pZuBThui+wyd5tkpbdUXdxLHGRSB9ec9ynxAY2r1umwJ5tkh/Wv0fCj3Vq8mxjCqRHtw18bGLIQ/7+QVkmnf+LG/Iu5ycrz5P9vkC1J6Z923t2NhyBruYhGQK3nbUN1h72f/2yBsFHWf246rSTiAhFS2oIXaooUIPLMsW/tvHa0YPC47IMyMHk3vu0mmf22RjtyArYf5qLpbpic3w5b972I+BcS4QKZo85Inw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLi+6iJvGANjKJ/EFzZYutLIfvDu1MxOj/N9kVq8kAI=;
 b=S/m1Z9MX1wQ8H80AKoUuTtpjzy2VzT00gzWt6qKMFF8e0TMvL0FTaAGOUqx8fg07v7zEUXGeDqRLQ5Nxsrq1crX9c/8W/NKeNVAEvsMMDuWiHK0hzeMRtFqX5eCLXMQxKOGAaCCEwwiaoQVEMe4HG7JfOXSR99lqv9UGHW9WHxnuUum6hWW4MhLson/iWossbCdbfbBITDbdY1VhoYooqEDOb9iKGTorO1zh1ilydMFv1WfaCx9eZaLYplOq9UFZfIQIFg3DdN6Z/mg2GfWwuu/dPnVU65MQsM9u9xZAVsc4/NOtoxul4j9Qqssz3xiLpkW1yMIgc9UsbZjT4Sc/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by BL1PR11MB5223.namprd11.prod.outlook.com (2603:10b6:208:31a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Sun, 24 Sep
 2023 13:58:47 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::73c6:1231:e700:924%4]) with mapi id 15.20.6813.017; Sun, 24 Sep 2023
 13:58:47 +0000
Date:   Sun, 24 Sep 2023 21:58:38 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Tao Su <tao1.su@linux.intel.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        Yi Lai <yi1.lai@intel.com>, <kvm@vger.kernel.org>,
        <xudong.hao@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <chao.gao@intel.com>, <guang.zeng@intel.com>,
        <tao1.su@linux.intel.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <202309242109.43637c74-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904013555.725413-3-tao1.su@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0193.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::18) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|BL1PR11MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db4cfb6-4556-4815-d8de-08dbbd065f2e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7LrlKomnX5C/sPmn5G6304thk2S897LwkKKj+4kfigLVtC8EcZ1dQoBoWAXgpJTSf7oO4UNDA4Y4giiVgZOOZECuUGmTh4bxjywaYuNIXfTiKpoju0iq7Cxxqv0SZQ2kgsWQbFvIzfjrQb6YqPo6jeB1eSe/Q9tCFbgTohWjkuGHQfx6il74LwfGj6fzBxQ3WpepqS+1zBJMec+dxO9N9Lmr2QYsIbsIc/OZOAwIt19TIF7BLo69lvI0BeIdMUlK/ISHZ324icHJgWA+OaoXhEwR0iuousrKDkgdG9A+jUKa6vlaZSs/nuNK9+iDehTOIlaGven65akevi4xW9imhFDPGuISkUvbSR6VdkDB6at3vL/6bvhNNXRrwbALn+fqdBueKNpkB+yFkwKyhWtWJFyt/JwBwd/W+PBW+ZxUBC1Iqjg30kLM+GRc3ATIlgdHDjfzLqPGS3iKXQwIafx3/dYg3hPIzjEY7CPMRpx+IvCrCG1H3bSUPrL41iZ4gJkuNM5Q6M1zQvlP2q5ZE19di6W1NcfHTV63uR3swzjcOQ3s3qzHLT2i5FFdfiaHKiv99UIav3r172in4ukI1qxkXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(346002)(39860400002)(230922051799003)(186009)(1800799009)(451199024)(2616005)(26005)(36756003)(8936002)(1076003)(5660300002)(8676002)(4326008)(6512007)(41300700001)(82960400001)(38100700002)(2906002)(83380400001)(86362001)(6666004)(478600001)(966005)(316002)(66946007)(6506007)(6916009)(6486002)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QktmD1XG63HWDCLjVTe13GS29yjj7N9GmdR+8PQpPI51hN3VLpsRtTWPRxTX?=
 =?us-ascii?Q?42VcuCBCIj+QD530nLXJZTy1pj3CJ3Gk8wZwsXZYZUO6T2BQ5MobCAu2FSgR?=
 =?us-ascii?Q?3Ga84SgKelCJjONjHDKXUMhWpEIXQEImVAQeRANrSsjSHzqIeF2+zAvm4rtk?=
 =?us-ascii?Q?5i2p+L+9NbuE0P1vt9WNnRRZwg5Z6XGKFPXRcoHXNwwzW1muR8p3v6gpI0eV?=
 =?us-ascii?Q?6CiSbaEUbdNe9e3dQZxP6CIhK5hcybfExWRLQNiJ7U7NwXLwxXNopoHC0euW?=
 =?us-ascii?Q?WGejmSXTXkE/Wka1oaCn0mhUtIZ13PCyr88jLmi9n8DR/08eiKAey91MONPP?=
 =?us-ascii?Q?a72T7TXfSku/6F45lAkjdMyOegGYXVvd78TVEsShf1A6+KrVKP7QKBAB2hE0?=
 =?us-ascii?Q?+hxenl3ZWBn6yF8zwXQOvhuKQJgk1iiDvWfJgh3uDBXdeSQJ6Zpx2tYxg55i?=
 =?us-ascii?Q?VOvJ47zBQJ9ZxOkXcOVQ4kVTVvX2OBu76hKvFKCYs/f4lvN/P+faNSHPqdTH?=
 =?us-ascii?Q?QVEqymVOAAZe7zbxBSHg5cRi9JDF/EV54ktPTiXITKCdTJvmm8aypWIB78l0?=
 =?us-ascii?Q?yDqXcQVX9qMt+MEA4WI9VJhpB+g/bgYtufjHZEVzpK+q04RPXHjO41R41FyZ?=
 =?us-ascii?Q?OzxzySiiYqVQiCTcVhVwwMgspo8PcZ1sMQz1L5pZZtBzJpDhCuuxEXXPL2Kk?=
 =?us-ascii?Q?NNEr8VEgtvb76LHCzH6Rkly1l2w8GyFJJauHZbdaHrQ2sOY9tNyKCy78STFs?=
 =?us-ascii?Q?pLLZ6hAJH3m603NpSHfjYcQ+3hhecrmk4lAqSJQsibkltYlB/64AWMkYejno?=
 =?us-ascii?Q?azF7Nk89Ali5+UylOQmRmwgK2hqn/6Xahzkkb9kyIroWb6Hm1qHeLUqSmiYO?=
 =?us-ascii?Q?KkUHVwdWKJD9zUSLjOhNsoQnExXXi/MkUlwktEEgiPZXG/+6bbI0Fh/DNB3R?=
 =?us-ascii?Q?wwdNFQE0ZXZgsLIOTlfNY4ssTsGERDfuEEUpGZNRMDGwXgvctfgFsIERKcW2?=
 =?us-ascii?Q?y9nQ9NIrLyeSpW11tZxnKLIqmHg6MOerhVAWacgq7650xnikKa6UwFXN0Hfb?=
 =?us-ascii?Q?I7Do9iYOkuqj015kSKYWBA79fGY6e+7jP8JrDZzu8vCRVmHIYVIzP3Vsdd8o?=
 =?us-ascii?Q?BGE9KxJegBssRhFdZd80spGii4mrBC0YjueqxxaBl/BRNIZNazGarZZXditA?=
 =?us-ascii?Q?3gx94EBG+7fgUSegLdop9ppmLZe5xye8LftivRenTlE2/3XLrWygblpY0RRt?=
 =?us-ascii?Q?Wl1ggSpN4JxemkVbovUxQfvlAW+KGMvkIL14+9XPKpYsNuFbqKT6x5h57kcO?=
 =?us-ascii?Q?RBIs/BL7hI58rQ/WuRv4gJUThXZg1UDlGC2p3fFNRNte+yj6agF/cY8fFI9p?=
 =?us-ascii?Q?EGRvtsXZiJ8LRs0OdSF/QA670vk+J5gp78j4lE7/xD1fT8/tkgsqSuswSIcF?=
 =?us-ascii?Q?xolgfHGYE6Yi2CuWwz3Np/AQPAYlb5X2Nvxf6SO3r+Wx/Ln/fsj2jePVWKeJ?=
 =?us-ascii?Q?1O60HY+IE5rpAw8xxPQyy3AT5jZ8Whxm0JKaGbMor1hSO+LAL6IwRGkIsxrc?=
 =?us-ascii?Q?0IwHfZdayhYEJjoFAVMhP+RZpAJkjX79PoKuJe8iuNn+YEotC2h4qKCL1fE5?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db4cfb6-4556-4815-d8de-08dbbd065f2e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2023 13:58:46.9434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GL1ENkAl0ZYDtxGShJQo/PXMa1OoQzEgiYJ1jdQVtMfC2C9CcFviXuuobMw4gltjpEPqMIZSNRmzmWASqKKVLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hello,

kernel test robot noticed "kernel-selftests.kvm.xapic_state_test.fail" on:

commit: 6ccade077c151e719397b0a86f48554db9aa1c24 ("[PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit")
url: https://github.com/intel-lab-lkp/linux/commits/Tao-Su/x86-apic-Introduce-X2APIC_ICR_UNUSED_12-for-x2APIC-mode/20230904-093801
patch link: https://lore.kernel.org/all/20230904013555.725413-3-tao1.su@linux.intel.com/
patch subject: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit

in testcase: kernel-selftests
version: kernel-selftests-x86_64-60acb023-1_20230329
with following parameters:

	group: kvm



compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480+ (Sapphire Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


besides, we also noticed kvm.smm_test.fail which keeps pass on parent.

83c02e23e21fec27 6ccade077c151e719397b0a86f4
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :6          100%           6:6     kernel-selftests.kvm.smm_test.fail
           :6          100%           6:6     kernel-selftests.kvm.xapic_state_test.fail



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202309242109.43637c74-oliver.sang@intel.com



# timeout set to 120
# selftests: kvm: smm_test
# ==== Test Assertion Failure ====
#   x86_64/smm_test.c:179: stage_reported == stage || stage_reported == SMRAM_STAGE
#   pid=6354 tid=6354 errno=4 - Interrupted system call
#      1	0x00000000004026fc: main at smm_test.c:179
#      2	0x00007f08310cb189: ?? ??:0
#      3	0x00007f08310cb244: ?? ??:0
#      4	0x0000000000402810: _start at ??:?
#   Unexpected stage: #3, got 4
not ok 25 selftests: kvm: smm_test # exit=254

...

# timeout set to 120
# selftests: kvm: xapic_state_test
# ==== Test Assertion Failure ====
#   x86_64/xapic_state_test.c:78: __a == __b
#   pid=7081 tid=7081 errno=4 - Interrupted system call
#      1	0x0000000000402a1f: ____test_icr at xapic_state_test.c:78
#      2	0x0000000000402c51: __test_icr at xapic_state_test.c:95 (discriminator 3)
#      3	 (inlined by) test_icr at xapic_state_test.c:106 (discriminator 3)
#      4	0x0000000000402433: main at xapic_state_test.c:197
#      5	0x00007f8a0c660189: ?? ??:0
#      6	0x00007f8a0c660244: ?? ??:0
#      7	0x0000000000402640: _start at ??:?
#   ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY) failed.
# 	icr & ~APIC_ICR_BUSY is 0
# 	val & ~APIC_ICR_BUSY is 0x44000
not ok 47 selftests: kvm: xapic_state_test # exit=254



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20230924/202309242109.43637c74-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

