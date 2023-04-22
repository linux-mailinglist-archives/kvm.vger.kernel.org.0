Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3C6EB768
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 06:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDVEnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 00:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjDVEnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 00:43:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DE31FDE
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 21:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682138610; x=1713674610;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kUWmROrhWpSjSVOlQnkIn1QxctYMO+lpo8vgBNghUQk=;
  b=Md5sDt1tw4mCuv1MnFuN2tbm7QKIY76AXpAS7sAwHCzq+EM/WGvy4UEj
   azjEq6QhgEu6tae3CKRrIrThKUXhiPgrx0QfCx4POz0SZ0K1wLaSb/KPu
   AFd2CT9LDIJMTDTZPnwVuFPZWAlBYdRYcdURZ1qyk9rZt8Gwcya9Bq/89
   3tmZlpB/exRyaKfCwMBs5OLVMIXMfoXo1HHroE3qaQnQc56Kz1TIjVol4
   hoVam6eyO7kj1O8YMOxTuvpt65rC6+ZC0nc9+900YkNeZqWnLdaQ2zmDz
   DSxWUCdY1PvbdQQvRIr+1rVTeh8SFMiBRqFCfSURgEzkMJH0XvcvDXkbC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="374064926"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="374064926"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 21:43:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="1022108686"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="1022108686"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2023 21:43:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 21:43:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 21:43:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 21:43:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 21:43:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1wGdmFKzkzD+a2GmpllrD27Mj5vGvGxZ8HmhfPjpA9xpEz+PzuBzGKbD8BbI7fWE2k0MQ4dPygK9EDpI2ATYvmDrT+MW/oZxnp4mPLA1MdNRysASs3QYEXdNUEZdVIKwuB9TuXpfbycQlD7/1emo+xL2KiWugI59+CsamiSyddJ/UrGoywrSLThIoiYsxtol/UzcIoUHZoxZKFvA4RRzW7MiLFVM12RRN+vdIiHga0+Os57lAReZuxu1YY9muD2V3I4okzh9+g9Ur6zKN6cgBzneil+i+xkFCCXtbDyzZNCiyaal8I1qLYJChGM1Rmvh4gfKZdSzZUAFSZ143k/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xlGURmXkwjexUr080WbaUegzRtedd1CyQvl0oToUe8M=;
 b=AASe6vQU3JQQcA6aeOLHzhcPlIHS4918Tq57wg+AXzz8fd2lQ7SYgXyDYAyKeCLSwijEl5FtNaufh86ZjRRsZcGNraaOKVPPsgpVVLz/tLn2qbRLyGS2MMAqcz9zScJm+WjJlY6/mOxrq654dWOCck3ZRnV2v0hSTtuAWGREIP8fiVHoQALRs8faIrxD9PxzUWDK4MXCBhVm4mbzF2J+ng9kOCYebSbY+IujNFaIxCK7Il/sjiy0ANbyFA0aBHwArrjM6bOs4Mo6nAgAQe0PIc3ya3bBj5ClNqbtcMknpE9gU8Sg85WswOqZSJ95xpGuxK9ZkLyJm1DgdUg/ToTMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4936.namprd11.prod.outlook.com (2603:10b6:510:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 04:43:22 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.029; Sat, 22 Apr 2023
 04:43:22 +0000
Date:   Sat, 22 Apr 2023 12:43:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZENl3oGrLXvVaI1O@chao-email>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
 <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <612345f3-74b8-d4bc-b87d-d74c8d0aedd1@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 58802df0-2319-44ce-9aa3-08db42ec19ba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKWsZTJHKPLPcZatLOHHnsMmCSoVte7dBs3fPMCueUqj7ISs8Vtd82cd5PMUkH/UPD+w+cx4RkR+VL+mh9zeh8MEaDu3jUyIxKFXILcpgfv3nUrgFTPmH5upuyHa0Q2TwJ23hM/+8TjWDP1Vh3q114AyObVZG5Gd08x4HyaRuDRiz9NicX4TI6PZDMvsaZqXhZ9JEmZuIkbxVvnbcglJs3OwObprWg2hDzR04J4PBv3V/dxgq22SmosP7fZJEWiIO9Jzh37LtcJqH5UDSHwNyD6HSc/nbsvD3ym89q5YaWWV5DebokJtYcUesINc0Uv1y6Stgl6QMlHyEKrTHGjkt0UnMiyuPjPhZkhQuXav/EpWeHCgT2o9ZsGBS07gduOvYsXEkKEwWwMyzYY0Ig0aMLnayaBcNf+miXC3HR5zL5ZQFB8OSPOsXvXDkrLcfC4dtnZGWFo9qU1LymIVSYeA4rzZtZKe0RcQxwParAaBtdAQ/Qzfk3mqWPl3MR5jii7N476IBDJoT9p19wLGTzBhsobejKnt8ON0YFrRIMFA9yl0dKlZqaykJkU/7drPzaBK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(4326008)(316002)(66946007)(6916009)(66476007)(66556008)(54906003)(6486002)(33716001)(6666004)(86362001)(478600001)(8936002)(5660300002)(8676002)(41300700001)(2906002)(44832011)(82960400001)(38100700002)(9686003)(26005)(6512007)(53546011)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?y67CDCKW2ANKdbVAPaiscdO/+C7YOZSTM+Ehn4QcZqpp87NR6nG2eBhZ0h?=
 =?iso-8859-1?Q?L61I/KB/pPAf2pOhW4XqN/ywh9O8EB8ND8BGAHbEIPyviF69P+JwQTuhvl?=
 =?iso-8859-1?Q?ACWVV8nJG2PdpaIUs4Pnxgtwn5WIwRgvgNDkvCLkWMYhxRH4wdght/Djqr?=
 =?iso-8859-1?Q?arw3cZ4wQEoDU4dfiVokYcaruzQpNHZp5vBv6qDd1RO4ZYeMDXFVVGCONt?=
 =?iso-8859-1?Q?OtdRehZdDRwbihnDvTNL753N+woXeEeXEa7RFHHJ9L9RpEvLk2cK1QMhR0?=
 =?iso-8859-1?Q?wz6A3/ui6mdfgTeC9Ezt/SLIjLg5B/v2TEbUOXQc6Pn3TbFZynw+yN9UNh?=
 =?iso-8859-1?Q?OO8lz+Jj6qgse8QcJdIcCfoRdxTokwKBS75qZa3+mJsbj8DFZJK0xumIIN?=
 =?iso-8859-1?Q?AXVZv8MdFkb2MYQ8CP6u8L0+w1C8BsI4oFlz7rXkzBUS4W6ZiMUl+UyTZQ?=
 =?iso-8859-1?Q?Bq8tdZYhXXWzBkgng+O1lUOJAqheSz0/OgqdH3oW04IkyVbZjnLpY85mLX?=
 =?iso-8859-1?Q?JRsKhgQWmumMHuX7z9OmlUUzFj9hRM/Mw8LM3gZDmzaniy06oDMduPp2OI?=
 =?iso-8859-1?Q?CzBKcYdrjEVapR9btFknohiIpCFss/1YBDe2gSWKvOyXKKf1Sbq4iVrg7z?=
 =?iso-8859-1?Q?ZBzb6MCQ1pXfXMXOamVUQebTiRUUvEDvVqB8fQ4hPkvDr+PbeZ+FEC8mVI?=
 =?iso-8859-1?Q?w3Xw8G6erosaTp/XxsOJVD//NjjcOZGL2j8FFkTPg9FHpZXDvuG07a9hHf?=
 =?iso-8859-1?Q?KXkqkZJcJUJynU+yCihwuf5ARfDnZqXdEPxtEfPJ/+DjtiKAVI4Cp4yw0v?=
 =?iso-8859-1?Q?icRmBK7pb4uO/PANrvOAOqDb8v6odVsqzlZMt/THKzQ4MwLWIxJ8ErAvJW?=
 =?iso-8859-1?Q?qiW94HyiqVfSOAt66lif/hkOye0IAVUx+J2x3Glk6Q24RrvYdFxyJKEo0D?=
 =?iso-8859-1?Q?s62aTbY/iZc0R7gBe63qJSvU1Op6cx69xJlWsrMHY3mIoQfSXK6uLUJXqE?=
 =?iso-8859-1?Q?60ARQ2Vrjc2Ypp+yRcno9yjPDarxpsYk/cRn7oYRIDb8uNfSmGkcdviSBj?=
 =?iso-8859-1?Q?9qUL8T62BvTf2kEJwRmH3K78XmSfAC/ymr6X9yCLmCkBlC64yyG4pdLqSA?=
 =?iso-8859-1?Q?0NE06jo1gMx1mM6VF0ISN4A2LRUPsC+jZnEL2h2L75tEtH1kIOOIwARmro?=
 =?iso-8859-1?Q?BPCkdW4tgrOIyEaziF2Q0TZ74gPRydczzACjdFMmRXRDgOvYn0Khjvecl0?=
 =?iso-8859-1?Q?n5DKUaXVmwKhhoTMvpC9/rHSOWpDJwgJX+2dOzCtZPPxrFCgcFygjAVAz9?=
 =?iso-8859-1?Q?8fVWYEUozeQvmOoyHYerMLHpAuTvIySW1Ax31QqDe+owNU8zq2udt0G6B4?=
 =?iso-8859-1?Q?rYapebHvzBF9RrHdDY/KrchUusSchrJ12RCLdw+AW/XNh1l/VVWFaqpFU9?=
 =?iso-8859-1?Q?3LABV8NXUN9/q2xrIYjI8YmPK2V7p2atZZu8dQej8t35UHFKfxBMivd/rI?=
 =?iso-8859-1?Q?XRLzf2naJAT8ZJQkADRhJDOuFLQBFD/EHCDMVscasngEDiZlAPjxwXsB5W?=
 =?iso-8859-1?Q?bYZTN4ywDvS/gTGvP60vzYNFvUEVpoLoU9Q3TiyzBDIceNOTVIEutImbme?=
 =?iso-8859-1?Q?LIJAg8HQJ5gKHUpzICbuA5Oxt5BezDz2Di?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58802df0-2319-44ce-9aa3-08db42ec19ba
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 04:43:22.0542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mH40J61Y71icSmlV8KLIq/eESDWLJhd8Em4JBEmxQkdnZUP8320KN2RKQ5yqEif61yjvbmEeVDyBFoLjih3xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4936
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

On Sat, Apr 22, 2023 at 11:32:26AM +0800, Binbin Wu wrote:
>Kai,
>
>Thanks for your inputs.
>
>I rephrased the changelog as following:
>
>
>LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
>masking for user mode pointers.
>
>To support LAM in KVM, CR3 validity checks and shadow paging handling need to
>be
>modified accordingly.
>
>== CR3 validity Check ==
>When LAM is supported, CR3 LAM bits are allowed to be set and the check of
>CR3
>needs to be modified.

it is better to describe the hardware change here:

On processors that enumerate support for LAM, CR3 register allows
LAM_U48/U57 to be set and VM entry allows LAM_U48/U57 to be set in both
GUEST_CR3 and HOST_CR3 fields.

To emulate LAM hardware behavior, KVM needs to
1. allow LAM_U48/U57 to be set to the CR3 register by guest or userspace
2. allow LAM_U48/U57 to be set to the GUES_CR3/HOST_CR3 fields in vmcs12

>Add a helper kvm_vcpu_is_legal_cr3() and use it instead of
>kvm_vcpu_is_legal_gpa()
>to do the new CR3 checks in all existing CR3 checks as following:
>When userspace sets sregs, CR3 is checked in kvm_is_valid_sregs().
>Non-nested case
>- When EPT on, CR3 is fully under control of guest.
>- When EPT off, CR3 is intercepted and CR3 is checked in kvm_set_cr3() during
>  CR3 VMExit handling.
>Nested case, from L0's perspective, we care about:
>- L1's CR3 register (VMCS01's GUEST_CR3), it's the same as non-nested case.
>- L1's VMCS to run L2 guest (i.e. VMCS12's HOST_CR3 and VMCS12's GUEST_CR3)
>  Two paths related:
>  1. L0 emulates a VMExit from L2 to L1 using VMCS01 to reflect VMCS12
>         nested_vm_exit()
>         -> load_vmcs12_host_state()
>               -> nested_vmx_load_cr3()     //check VMCS12's HOST_CR3

This is just a byproduct of using a unified function, i.e.,
nested_vmx_load_cr3() to load CR3 for both nested VM entry and VM exit.

LAM spec says:

VM entry checks the values of the CR3 and CR4 fields in the guest-area
and host-state area of the VMCS. In particular, the bits in these fields
that correspond to bits reserved in the corresponding register are
checked and must be 0.

It doesn't mention any check on VM exit. So, it looks to me that VM exit
doesn't do consistency checks. Then, I think there is no need to call
out this path.

>  2. L0 to VMENTER to L2 using VMCS02
>         nested_vmx_run()
>         -> nested_vmx_check_host_state()   //check VMCS12's HOST_CR3
>         -> nested_vmx_enter_non_root_mode()
>            -> prepare_vmcs02()
>               -> nested_vmx_load_cr3()     //check VMCS12's GUEST_CR3
>  Path 2 can fail to VMENTER to L2 of course, but later this should result in
>  path 1.
>
>== Shadow paging handling ==
>When EPT is off, the following changes needed to handle shadow paging:
>- LAM bits should be stripped to perform GFN calculation from guest PGD when
>it
>  is CR3 (for nested EPT case, guest PGD is nested EPTP).
>  To be generic, extract the maximal base address mask from guest PGD since
>the
>  validity of guest PGD has been checked already.
>- Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination.
>  It could potentially increase root cache misses and MMU reload, however,
>  it's very rare to turn off EPT when performance matters.
>- Active CR3 LAM bits should be kept to form a shadow CR3.
>
>To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
>the bits used to control supported features related to CR3 (e.g. LAM).
>- Supported control bits are set to the field after set cpuid.
>- the field is used in
>  kvm_vcpu_is_legal_cr3() to check CR3.
>  kvm_get_active_cr3_ctrl_bits() to extract active control bits of CR3.
>  Also as a quick check for LAM feature support.
>
>On 4/21/2023 7:43 PM, Huang, Kai wrote:
>> On Fri, 2023-04-21 at 14:35 +0800, Binbin Wu wrote:
>> > On 4/13/2023 5:13 PM, Huang, Kai wrote:
>> > > > On 4/13/2023 10:27 AM, Huang, Kai wrote:
>> > > > > On Thu, 2023-04-13 at 09:36 +0800, Binbin Wu wrote:
>> > > > > > On 4/12/2023 7:58 PM, Huang, Kai wrote:
>> > > > > > 
>> > > > ...
>> > > > > > > > +	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
>> > > > > > > Or, should we explicitly mask vcpu->arch.cr3_ctrl_bits?  In this
>> > > > > > > way, below
>> > > > > > > mmu_check_root() may potentially catch other invalid bits, but in
>> > > > > > > practice there should be no difference I guess.
>> > > > > > In previous version, vcpu->arch.cr3_ctrl_bits was used as the mask.
>> > > > > > 
>> > > > > > However, Sean pointed out that the return value of
>> > > > > > mmu->get_guest_pgd(vcpu) could be
>> > > > > > EPTP for nested case, so it is not rational to mask to CR3 bit(s) from EPTP.
>> > > > > Yes, although EPTP's high bits don't contain any control bits.
>> > > > > 
>> > > > > But perhaps we want to make it future-proof in case some more control
>> > > > > bits are added to EPTP too.
>> > > > > 
>> > > > > > Since the guest pgd has been check for valadity, for both CR3 and
>> > > > > > EPTP, it is safe to mask off non-address bits to get GFN.
>> > > > > > 
>> > > > > > Maybe I should add this CR3 VS. EPTP part to the changelog to make it
>> > > > > > more undertandable.
>> > > > > This isn't necessary, and can/should be done in comments if needed.
>> > > > > 
>> > > > > But IMHO you may want to add more material to explain how nested cases
>> > > > > are handled.
>> > > > Do you mean about CR3 or others?
>> > > > 
>> > > This patch is about CR3, so CR3.
>> > For nested case, I plan to add the following in the changelog:
>> > 
>> >       For nested guest:
>> >       - If CR3 is intercepted, after CR3 handled in L1, CR3 will be
>> > checked in
>> >         nested_vmx_load_cr3() before returning back to L2.
>> >       - For the shadow paging case (SPT02), LAM bits are also be handled
>> > to form
>> >         a new shadow CR3 in vmx_load_mmu_pgd().
>> > 
>> > 
>> I don't know a lot of code detail of KVM nested code, but in general, since your
>> code only changes nested_vmx_load_cr3() and nested_vmx_check_host_state(), the
>> changelog should focus on explaining why modifying these two functions are good
>> enough.
>> 
>> And to explain this, I think we should explain from hardware's perspective
>> rather than from shadow paging's perspective.
>> 
>>  From L0's perspective, we care about:
>> 
>> 	1) L1's CR3 register (VMCS01's GUEST_CR3)
>> 	2) L1's VMCS to run L2 guest
>> 		2.1) VMCS12's HOST_CR3
>> 		2.2) VMCS12's GUEST_CR3
>> 
>> For 1) the current changelog has explained (that we need to catch _active_
>> control bits in guest's CR3 etc).  For nested (case 2)), L1 can choose to
>> intercept CR3 or not.  But this isn't the point because from hardware's point of
>> view we actually care about below two cases instead:
>> 
>> 	1) L0 to emulate a VMExit from L2 to L1 by VMENTER using VMCS01
>> 	   to reflect VMCS12
>> 	2) L0 to VMENTER to L2 using VMCS02 directly
>> 
>> The case 2) can fail due to fail to VMENTER to L2 of course but this should
>> result in L0 to VMENTER to L1 with a emulated VMEXIT from L2 to L1 which is the
>> case 1).
>> 
>> For case 1) we need new code to check VMCS12's HOST_CR3 against guest's _active_
>> CR3 feature control bits.  The key code path is:
>> 
>> 	vmx_handle_exit()
>> 		-> prepare_vmcs12()
>> 		-> load_vmcs12_host_state().
>> 
>> For case 2) I _think_ we need new code to check both VMCS12's HOST_CR3 and
>> GUEST_CR3 against active control bits.  The key code path is
>> 
>> 	nested_vmx_run() ->
>> 		-> nested_vmx_check_host_state()
>> 		-> nested_vmx_enter_non_root_mode()
>> 			-> prepare_vmcs02_early()
>> 			-> prepare_vmcs02()
>> 
>> Since nested_vmx_load_cr3() is used in both VMENTER using VMCS12's HOST_CR3
>> (VMEXIT to L1) and GUEST_CR3 (VMENTER to L2), and it currently already checks
>> kvm_vcpu_is_illegal_gpa(vcpu, cr3), changing it to additionally check guest CR3
>> active control bits seems just enough.
>> 
>> Also, nested_vmx_check_host_state() (i.e. it is called in nested_vmx_run() to
>> return early if any HOST state is wrong) currently checks
>> kvm_vcpu_is_illegal_gpa(vcpu, cr3) too so we should also change it.
>> 
>> That being said, I do find it's not easy to come up with a "concise" changelog
>> to cover both non-nested and (especially) nested cases, but it seems we can
>> abstract some from my above typing?
>> 
>> My suggestion is to focus on the hardware behaviour's perspective as typed
>> above.  But I believe Sean can easily make a "concise" changelog if he wants to
>> comment here :)
