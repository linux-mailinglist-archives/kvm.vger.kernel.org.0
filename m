Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5997289DE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 23:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbjFHVEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 17:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjFHVEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 17:04:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9D2728;
        Thu,  8 Jun 2023 14:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686258246; x=1717794246;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7I2bMMLXfOY5FSRQBIV6jQInEbWZkrrAFBkie4VaDnc=;
  b=dT83CEJrTME8YAl857iaPhlv/ce5N4w2BirvSaSU+KrdDKTbmKOn0+NZ
   RpbH71MySV5aUAJ/EyAfM8Gw3lhDzKNCrtI/O2UeTMeJ6IDLTqfN+EGMe
   SKK83Bu3ZY0S6JBGXFbte72XtMUO48GL3MZq3C5Hglckm/aqu3D2IUTGZ
   IK+WlDz6voQMLSedkV54eemry2jfY/t5S5ghgIW2u8dP7bRurwEVUuXZ0
   sfmrIhBzW9AESI8Jwx6Q61LizFrYrfLNG/9DI3cYJreAUJp7K1PAmpuA6
   wZ4e3B5cq6GR3Z45NkG77NrHWIXejh6/cjbzVUL5nS93mFyp87jb44Auc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="360789745"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="360789745"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 14:04:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="704284798"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="704284798"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 08 Jun 2023 14:04:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 14:04:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 14:04:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 14:04:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 14:04:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StyB9gmlSsXydsqr1eM4N7Lr8y6hbb8riedhhSZYISUdJgQ6X2CmDamp+X3DwTc7faBy+cxgzPS2/tALa+ZQFU3aMYad6+DOe7cny52rdHG79xPE0t+LzwJ9N0sBqErsyZTe+EtBZUUuw7Yq/bCSJU2Ho8iR4ZtN3JbfmRRbBrqkY1fI0hlpJiwxMrXdH86+w74aWvgNm2Bjos8H3e9WvoERZBCDjA+AXk8VWl61OCof95cQewAc3v0LR13Jm6SyrXamRBBtg78nG5ociWOds+Vjse+zepfxSzInZj0fqHfFYrLU67DpT+EU9Eug66TKbamgFLOl8JaKL5OSlqgcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLZDQuSbBUSTxHa6LocLQQCkJCs5mVEXl7vkrcjZLKU=;
 b=QdWGLqc7+dsDOQlFNIjUhw3/OYnyKUJUx07o+h5AxPJX328iXmyZIH/imR3WB3i3bSIgoHlePwyoQDXcVkpM85/34PwDuQi6AzGk5ZqwtHQBMH0O3hr1WQH/G1EY3nSClkUHOL2hWwXQWPy2R/pb8zos8yrwXuBSoPOFGrAIPHGXQTFSOf4AILOwpV12QmU7CTin7G51mKVe9LWC3nSBiPRpkVSpSm9uxdylMOepnvckT/Xut1WVgxm8JqMhHIzU/CgMVYdl/EZXKmQnrtI5M9KVU0s0xiaGblrXy5tnEY+O5YgWZwqPR7zfRUABDvoyPGEZQPh7k+6GZA/8s+A3mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB5038.namprd11.prod.outlook.com (2603:10b6:a03:2d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Thu, 8 Jun
 2023 21:04:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 21:04:02 +0000
Date:   Thu, 8 Jun 2023 14:03:56 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Kai Huang <kai.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <linux-mm@kvack.org>, <dave.hansen@intel.com>,
        <kirill.shutemov@linux.intel.com>, <tony.luck@intel.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <david@redhat.com>,
        <dan.j.williams@intel.com>, <rafael.j.wysocki@intel.com>,
        <ying.huang@intel.com>, <reinette.chatre@intel.com>,
        <len.brown@intel.com>, <ak@linux.intel.com>,
        <isaku.yamahata@intel.com>, <chao.gao@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <bagasdotme@gmail.com>, <sagis@google.com>, <imammedo@redhat.com>,
        <kai.huang@intel.com>
Subject: RE: [PATCH v11 00/20] TDX host kernel support
Message-ID: <6482423c7c52a_142af8294a6@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
X-ClientProxiedBy: SJ0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB5038:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfc1c91-b5b7-49ec-5298-08db6863e293
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMAUijXRytibV4BF2T20VHVp1Pe0/Tha7NZcSb8wqIWt9ATF3wDqGr1vl+K9ombeJcy4vjEHSHyzElewUlXXqNcXUhdXSCl7N/14FBh7CxDIn5I3SYdX2FRJdSvKsRY+4YF3LNN7jB2UttSDPtYuYL88X+BWPgEiNi0LPkVSLzDZfaSaUd/xfBX7ildgrX3q2H3y29Kk0EhmXl6BOqx33BVVEO6avrqO8jcEglR6V4CPBzi1d3Jyp0PHfVAadnBAwt3kHOIAN33AlfLl3ZfDOiMMF6sWazWkzOdJFd5U2tgauqUwKx6Hv6KCcRAXV+WxpY/6aolJbYXDAOyAGdC1GcfM++494fnJCh/j/oMPZVjioJdiiBmkJ7T9lInK0RkEzE8mv6bcigWmWT46HvqpTBVr2Rfv4XzLnHYBg4bIheTBmPNkMrIBLSZKkNrKFesk688eM09FOP+orDyOHsEPU71smCdc+P49rG8vy35XDlyRaju/BdzXsZ5fyQhirHw3MzEL5LXErfZHoNpUSZD8zW5wM0Au8aG0QHMeea+1MSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199021)(26005)(6506007)(6512007)(9686003)(966005)(83380400001)(186003)(6666004)(6486002)(66946007)(66556008)(66476007)(82960400001)(2906002)(7416002)(38100700002)(8936002)(8676002)(5660300002)(41300700001)(478600001)(86362001)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYFa7YxFMuhxOyUgdiQf8vBWdoQJkzddubsfox6t525CEGKxyEj+yP773bED?=
 =?us-ascii?Q?At8t6j9znUTiK/3GW3TbaAiVBujHGgw6I9iJ2Ztxo7NHkOTF52kD/UGgILtO?=
 =?us-ascii?Q?t+7K/xRL8AEAqbTY40/nsd2dhYJazO+IEFLOg0WxT6LkuiwHMyDRuLOLwjPr?=
 =?us-ascii?Q?YSH7hmrsSR3wolbqAQs0B2Aw2ubLLhRL2BRPwnWJnBS2nf2J+ge8arpT7ufi?=
 =?us-ascii?Q?G/WQWmrtzZo3wlJfpaPJFs+DY2vhqVisEmfAoPHthvsdfo2NM5ZrEE4axCjm?=
 =?us-ascii?Q?E7bm6JBJYJeGxkMrxfSL13DBGAYXyZ5a0ptj06A0ADPLfo9Q2kffbGqbZgn7?=
 =?us-ascii?Q?yM2kWLItPJMzlOUPaidYks9nYVQe2Q65x6jxDkD5sNehHfPIYhItQYBQqC1s?=
 =?us-ascii?Q?ajqaNuIF3TbnRuVquSTbFohEGbTPdMVPp2Wlwnm91YELb6lnR6Q2JuxU/+if?=
 =?us-ascii?Q?6NfQr2MTPMku6YFi4ZvI1Jswbe8vhm0/v5ENa0vzEU5ENd79m3VblR4GG9Ds?=
 =?us-ascii?Q?G0VmgiuuiQu4+oVHpHoL4KLPF8frg0PjBxexo+3t/qWd5EYOWaH1TN77M01L?=
 =?us-ascii?Q?6b77zusVEh1y15ZttAM/sFCwXLshtTr0RAByhZEMHONF08AlO8bZ6oG77EYD?=
 =?us-ascii?Q?brjzU5slpSl2gc0s1dattAJ01/3DCTMT6QxaFO7pdRpOlvxR0wBHPL8xxf+X?=
 =?us-ascii?Q?k8uiq8VOvw1NShvnQTy9yp9fosrAqrl278V9/gcrdFpBP0AERULX3QC4cmD0?=
 =?us-ascii?Q?/nKk0L76LYYjOT9M1JfUeuTW76RJhi1M/gCG9XjKAvUAq+zlHcE4sHeogYFD?=
 =?us-ascii?Q?Z5ReHAm7CsfC3aDA+/SS3nNjhzaiAUr0M6gCfug0ziY/tE8mq9A1aqho7zY6?=
 =?us-ascii?Q?9A8AK/ri57EoOQLWaSxRYl3RXwUDqOeJ3kBzlCe911mu4JwLLV3bo+Tjc9Y2?=
 =?us-ascii?Q?MFZDaJNYuWX5O5HBtQeIyRFamoz/3fK/OeOkUvncQXWncjBffiiMrwOCVmK5?=
 =?us-ascii?Q?K2yFhWJGUpd5KZ4SfBnM+lz2aK6Oe1Uy3il5kPV1vpXDTxYJQCx+C82cjfvi?=
 =?us-ascii?Q?awAKARHg9f2WFsY/TeTIQoLrCf6b8l1IUhCqge05ow00xPLmAsc5MKTnfD+C?=
 =?us-ascii?Q?F/CR3jYpWQjfNiygQviMVFpPaHwp63BVBMT5cvd5oYXr1UU0qZK8N3iHzNMN?=
 =?us-ascii?Q?XzlKMFl/FKERrgro9WRvoq0Vn4w5Kgd9ZApBy1O9RLb7bvgISjuPS7SeWQLZ?=
 =?us-ascii?Q?3s+kFkxmwZPwJbPv222qSkojJDJFJ8hhvTZxFZqxymuhqtpVq+tuH/+VGOpB?=
 =?us-ascii?Q?4ty7YRAaKVsXLb9g8CEKVWw2JKSYw/1aHlXG021+o25sueVx0TcorWQM1I3+?=
 =?us-ascii?Q?0RSvRXXrHQvSf5qgZ4OsJw0786XuW4mby6eFaoE9PF30wxU4iwt+52+2J4VX?=
 =?us-ascii?Q?ZICanO1ofSSGcRwb/EX+iuzs0sKHDzmHZXlS9zFS6LxnGpy5qLo5E0vK7Ugr?=
 =?us-ascii?Q?/0KGeM1imRNsp3gHyOfOlNCoaRHgEIrVALMOgUWIqFcmkCHE3FRUkJn3veyt?=
 =?us-ascii?Q?yJP9iWcUDMfl7zCpMRJDJ3Q6a1uR2esYF3z+QQ/QxuwSEPmmuNliXYXtwzGy?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfc1c91-b5b7-49ec-5298-08db6863e293
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 21:04:02.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F4Nb9Ex58uyqOfTnyL3j3ZCJiZ/3n4KvYA4bAXDWXnWVLuvRqWXsRB4KSaP8/JU1vWI+jjE5Lfkb8qB9ij8C3HGvboGvSV6nzNZfcGiLfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5038
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

Kai Huang wrote:
> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].
> 
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new "userspace inaccessible memfd" approach
> to support TDX private memory is also being developed[3].  The KVM will
> only support the new "userspace inaccessible memfd" as TDX guest memory.

This memfd approach is incompatible with one of the primary ways that
new memory topologies like high-bandwidth-memory and CXL are accessed,
via a device-special-file mapping. There is already precedent for mmap()
to only be used for communicating address value and not CPU accessible
memory. See "Userspace P2PDMA with O_DIRECT NVMe devices" [1].

So before this memfd requirement becomes too baked in to the design I
want to understand if "userspace inaccessible" is the only requirement
so I can look to add that to the device-special-file interface for
"device" / "Soft Reserved" memory like HBM and CXL.

[1]: https://lore.kernel.org/all/20221021174116.7200-1-logang@deltatee.com/
