Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD536A6815
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 08:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCAHZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 02:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCAHZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 02:25:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C2C211FA;
        Tue, 28 Feb 2023 23:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677655513; x=1709191513;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cK+1GJ1u/JQV1bTaWi1z9MdfXG/Y/QxJsjxm6Cg9U0k=;
  b=m+r6PcISybe0J9ZpCT/iItg2hEgnSYNfxrQwi8A3DHKFPX5OIm9khzoE
   i5JkIdMvMh0Bx1ci2sWQ6P66yaKx06hDg/XXqyE+xmlL7ohQf1lLfsVU6
   DV8+dIKsOgUR80sk3jPDupLYmPHjDBASTI97NHVw7ACfA34h7FeF2SVu5
   IKxDVb992rk0jM7Z0ZYMMhOC7cnsa19msfATkPRfpWxg+HCQfrQE6s7w5
   jkIwU0CyISQYQHnypQF2GD4XnryScWUWYR33MrC3LNmsrVNLyTa2Wulbx
   tgOq5IE6u5sFcEGkq8z6jbjfty2MrYKzrblMzgiYQWR9zUsRr3hYSMeWO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="334378956"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="334378956"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 23:25:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="674461032"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="674461032"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 28 Feb 2023 23:25:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 23:25:11 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 23:25:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 23:25:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 23:25:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieZLMv9U1Xr1NFEWjSCw9mthUFBufK90gQKvrCs1shiadpUMixfkB/sgVdpRCoaBxtWzq5ov7BZ4yXIsFt/JPqCG+rj1SNM7kVesdi6igJ8AxQNr4oBoLWSTI976bZP8esaSNgmDQSn3UwnJP3t+5ofKnpdqG+YBluGq/ysMBFCla7M6rSIFRXbbD6+mwRvSmRACfOsSmN8fhI7VdQlXm7z84WnffBuVk+NPSPDLEikLsJvFbtnqDm9teKtXtj6tdqXeCsFW9mD9mloZoFkAYNfYfJeegLhTHWn2VFyoUCQPA8SvmDTdmMhAImKqGRFohvpvddpeEAK1UYRBtAXsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/nQagLcFTwO+ra0oJPq+wvhUum+cZxmH2RLRNkVw98=;
 b=P1b5RIgzrtgfeI4g6kpEQH/+8QLVIXTzQDJMgjJEAb2UzPuhKJm3wKpxaRWSKWAdPdC1xri0zvJlCT64FRUDlSfFLNnuF/1vFjOo3wCIYcfKG+Fs5BXNQTA4NVf0hYjmW/pWpQqA3S7mDcr86Rj4bhbaaWa4vM8hFok2osV5UDSpy6kEMIwi1Km+jccpyIVJVC+aggsb/tsYitWkyvjvMnBUCbqIahZVZjOKGEiHcoyV72EuH98UZisYHjpgNNTb15Aqk5J3aNZn20pcw9hV6/CKSJU4s/utniQitVG+2IJ9hRBYLDc19si3bQuprsgmOLBFooVIHudVjhGJdFo3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 07:25:02 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::1b90:dcc5:3513:486c]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::1b90:dcc5:3513:486c%9]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 07:25:02 +0000
Message-ID: <e23b30cc-80a1-774f-7d58-a676d989b5ce@intel.com>
Date:   Wed, 1 Mar 2023 15:24:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v12 013/106] KVM: TDX: create/destroy VM structure
To:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
 <fd52ff91fbce051ecf9781af2e5c54138c995230.1677484918.git.isaku.yamahata@intel.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <fd52ff91fbce051ecf9781af2e5c54138c995230.1677484918.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0021.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::8)
 To SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|MN0PR11MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e26cb1f-7d74-4b2c-cb11-08db1a2611bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TAS1c/g637i0KXNUzmnu/ndrkPgfyFvOHt4/Z2/tjSv6z3lHnajFz5yx9HkzR1Vnhnc39mu3OQ9kgPjGZ3AirR7/XFHLpHmUL6GpIbmFwHYTsaiHhHm2WStCMWvnFbjeMe8hbfwJ3hHPdtzjcVqloTNk6Z0qlmVTchMOjN4fVOxr2qYWXZ3+agrRop9h2ntuCBh2ewEWHDyacEX3Tzoqf7zjdlpfrvpnlkh/kiWIeZQRpnu590avO/rL6DN8JS8xNp6/SI8diyjiU0Ddc63o39/UaVkkqqb/xstfr8j91BL3bTI1XX+2S4ArCq3mJEtMqK6yJz1IUuP4bBE5ZDQgjnsS2wpt07csT82putsnL9nhvqX0JcQ7IMmpIZcjS26bvS1g0vuUQoPRJKyfVrK3sFDA5qX2O86/OU4zoDN+wJ7u4D0xe3NtaY8hONSFR5Su4v5cy4rgysrhBWmMF5oftGK6RWxWtZ+qWcXn+OUBWsgl/iR1uoWueRJr8e4Er+wn8rxBB2+z+cnomjhnSXBqTaRflgzS7Sl4MeBaQvkfp/tiupm0wlqz9ItxIheFRbe7ELw5R+01DrLM7oZcd0cRLUI4k2oXMtAQm0cIKmtT5mfy3FL3+TiZysBlNSvNr28WtlRMBgohDro/Hfv5vFTDbA0t4oMPkPyOm+qY3idM1V5FW7sP0TLHCw3WVy9TSO6wGwyFrUQ7jsa7jmlOGKvoXWGPgALWgyVMld3vESUkuho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199018)(82960400001)(38100700002)(4326008)(31696002)(36756003)(86362001)(2906002)(44832011)(30864003)(41300700001)(5660300002)(66946007)(66476007)(66556008)(8676002)(8936002)(53546011)(6512007)(6506007)(2616005)(26005)(186003)(83380400001)(478600001)(54906003)(316002)(31686004)(107886003)(6666004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEdTSTdremZPbmM5a0VoWnZIUzlJamtQTG8zLzhOWWMwdCtmSys0d0hrdS91?=
 =?utf-8?B?cHNwL1Uvck9ZVW9XaGU1VXRJTy9XNWVYUkZiK3QzMDdrUlNUdkdtNmdraTMz?=
 =?utf-8?B?bjQyNC84dFFoNzlqV1VZVmdqUytHcUFGM3ZicGZLVzJHQlFGVkR5YWxjcGF3?=
 =?utf-8?B?MTdXbzBHcTlGNms5a2NjT3l6OWw3dW9EbDVUdTJQbGVzd2VSWXpRQ2NNMFZN?=
 =?utf-8?B?YjhGMWdHR1JiV1VWbVEvWG12UmFwandUdUJkRWl2TXFMSUJTdFB4SzBCczkr?=
 =?utf-8?B?elBlTWpuYWlYMy9VUmtJbHlDWXNOczJKU3FTZTFtS3NGTlRlZFdvUjFtRy94?=
 =?utf-8?B?QUNmSkxuV0VZZ2JnNXUyNjVUM2wwTWFNY3FTbEhIZWhHYTE4TThCa0swMG1q?=
 =?utf-8?B?MUJSNjdaYjZ0SkJZQkhqNHljNjRQY0ZmZTd5b09HVFdFNWYzdmFLalR5NktR?=
 =?utf-8?B?bVhUd2ZidGNaN3k5WHpBTzIrWHBwSDgxRWREWGRiRjRRaFBwUXVyZXdERXJ6?=
 =?utf-8?B?L2g5bStReVVETjIySjl5bC9nS3BFSWczODVIVXd5Q3dPclhmdHUyOWdvWktS?=
 =?utf-8?B?ZnFyaDAvSmtFUUY0aEU5T3hRSzJxeEsyMnVmOFUrTVc2bWVDc0tRVGlIVWFw?=
 =?utf-8?B?R01iQ09rK3hBNWZGMjhDVW1jUFRQQWxZYWF6aHpBc0kxc1k0WFBGRGFvSTRG?=
 =?utf-8?B?Rk1lcXZ2eEVzUm9PUEdKbncwVk11YTIzRWZUZThJaktGVnlwTTU4a1VvVWRS?=
 =?utf-8?B?b1l0My9mYnVrSlgyUnFGMnZQNk56YnlvWUFsbHZUb0YrSWJZQ1J5SVdRaG52?=
 =?utf-8?B?RXZqSVg0WGtyUCtCVkQ2TE1JcVdXbmkxeU5NT2VtYWc3VlB6Q0hTbU9Ea29C?=
 =?utf-8?B?YUdYbkpLNnBTaTdZLzUwakJxekVaNDdKb05DQjgxbW5Bck1KMG51NE5FV2l6?=
 =?utf-8?B?Vm1lNFdEVk45eVdxUm1XSHZpRHhsQ3R1cGFvQUhnc0dqRklQeTZ1SFlsVWNp?=
 =?utf-8?B?VnpvaDNGWmQ3WVExVHgvdjNOYS9oQytyUHg3cUt2WVp4Uk1PdlVNRW9RSFdV?=
 =?utf-8?B?NjU4NWR4MS96amhiMHA4UEtMYTVhOUtBWWpxNXorcG1sejlVcFJad1N6YXpz?=
 =?utf-8?B?NHU0Nmh1V1pleEl6SzB6U2x1VlFycXdId2swWkd0dEpyRjcxNjMzR284M2Z6?=
 =?utf-8?B?K2Zxais0K3dKazhLdGVIUHc0ekdncEwzelJTSGtDamhaWmpyTElEeVZmTUtv?=
 =?utf-8?B?TVdhMUprK1FsM0tMMThHdi91dFpweHhoV241VFBNSytzanN3a2FFazk5VUky?=
 =?utf-8?B?cVBXbGl5RkRDdUNLR1cxVGljdFkwT1V2YkdjOEFYL0FFaFlaaGZJM0ZCcURK?=
 =?utf-8?B?TjhQckhwMjNxM3VQbWJ0Y2lMUUxKaWNWUW8vWTJXanEzTHhQN1N3ejE1cU0w?=
 =?utf-8?B?ZXp3VVdLcDBYQjk5SmU0bW9FdStramk2eXg5ZHcwTjVBUWJmQi95dW5waExC?=
 =?utf-8?B?cHVMcXJxS3pwMEw3OUdvYnlzM3BHa3BLUklrL0N3dUJkMkVwVExiN050a2x0?=
 =?utf-8?B?bUJ4ZHo1NEt3TnBDajBuUkM4Q28veDZnNnltVm1TL0cvbFNqTXROQU1sSldV?=
 =?utf-8?B?VWxER0UrMWlMMGlQVklkTERSakVVSGpWU0wwcUo4NkczbmxlTHB6cnU4U2dC?=
 =?utf-8?B?NElIenpCejJYTGRRT05ieE9ubGtkSndHYkhRYUlYVVpENXJsZyt1M005L3lt?=
 =?utf-8?B?dWN6ZXU4OUs3S2gvUStxdGZhUVN2cFdWMXpYb1NjRWdDQ2MvWlBta2pyRzc5?=
 =?utf-8?B?eW1KK1FZWEg3ZGVMUDhQeUlKM2xSeE1UTmo0cVdrOGQ3bWtYZXpQN1lWOTlF?=
 =?utf-8?B?UjA1QklOTkhEMTl2cDVPRXp4cy9SbUNXNWpDYVFEb1dNK2drMzNuRTFRckU5?=
 =?utf-8?B?Y1hWYmk2SVpDUTJkSG9XeUN5R2lwcmVxcnlWWDJRUU1RR1htTXdrVVJmcE1V?=
 =?utf-8?B?RTcycjNvREdzWnIzbDdwaHEwV0tpTGpXU0ZkSTM1cTYzWXdtNTBvRG1mbGJK?=
 =?utf-8?B?bTZCaWhmZ1dIT1RTVFNlQURicHRSbFkrdEVqS0JrKzFmVDZqcnltWEdxRHdp?=
 =?utf-8?B?UFZyUG5CYzNPUnRPZFdna3dVemdFVzNsais3YjhMV1J6REplcWVlRTF3djlW?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e26cb1f-7d74-4b2c-cb11-08db1a2611bb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 07:25:01.3531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqPn/3ui52+O09X+sNh8qptOxQAbUH0f2pGA/Ut+/YuE4OBTLdDcLcvy65UUbS2xXXMpdBWFK2rXuBhfAuhkLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5964
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/27/2023 4:22 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
> 
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> flush_shadow_all_private callback before tearing down private page tables
> for it.
> 
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.
> 
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> Changes v11 -> v12:
> - use cpu_feature_enabled().
> 
> Changes v10 -> v11:
> - Fix doule free in tdx_vm_free() by setting NULL.
> - replace struct tdx_td_page tdr and tdcs from struct kvm_tdx with
>   unsigned long
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>  arch/x86/kvm/vmx/main.c            |  34 ++-
>  arch/x86/kvm/vmx/tdx.c             | 440 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h             |   6 +-
>  arch/x86/kvm/vmx/x86_ops.h         |   9 +
>  arch/x86/kvm/x86.c                 |   8 +
>  7 files changed, 496 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 7522c193f2b4..c30d2d2ad686 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -24,7 +24,9 @@ KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP_OPTIONAL(max_vcpus);
>  KVM_X86_OP_OPTIONAL(vm_enable_cap)
>  KVM_X86_OP(vm_init)
> +KVM_X86_OP_OPTIONAL(flush_shadow_all_private)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
> +KVM_X86_OP_OPTIONAL(vm_free)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
>  KVM_X86_OP(vcpu_create)
>  KVM_X86_OP(vcpu_free)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index bc9ecba514a9..f4e82ee3d668 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1551,7 +1551,9 @@ struct kvm_x86_ops {
>  	unsigned int vm_size;
>  	int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
>  	int (*vm_init)(struct kvm *kvm);
> +	void (*flush_shadow_all_private)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> +	void (*vm_free)(struct kvm *kvm);
>  
>  	/* Create, but do not attach this VCPU */
>  	int (*vcpu_precreate)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a090c029efd5..cdc73c09bf0b 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -49,14 +49,40 @@ static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  	return -EINVAL;
>  }
>  
> +static void vt_hardware_unsetup(void)
> +{
> +	tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>  	if (is_td(kvm))
> -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> +		return tdx_vm_init(kvm);
>  
>  	return vmx_vm_init(kvm);
>  }
>  
> +static void vt_flush_shadow_all_private(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_mmu_release_hkid(kvm);
> +}
> +
> +static void vt_vm_destroy(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return;
> +
> +	vmx_vm_destroy(kvm);
> +}
> +
> +static void vt_vm_free(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		tdx_vm_free(kvm);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -81,7 +107,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  
>  	.check_processor_compatibility = vmx_check_processor_compat,
>  
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>  
>  	.hardware_enable = vmx_hardware_enable,
>  	.hardware_disable = vmx_hardware_disable,
> @@ -92,7 +118,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.vm_size = sizeof(struct kvm_vmx),
>  	.vm_enable_cap = vt_vm_enable_cap,
>  	.vm_init = vt_vm_init,
> -	.vm_destroy = vmx_vm_destroy,
> +	.flush_shadow_all_private = vt_flush_shadow_all_private,
> +	.vm_destroy = vt_vm_destroy,
> +	.vm_free = vt_vm_free,
>  
>  	.vcpu_precreate = vmx_vcpu_precreate,
>  	.vcpu_create = vmx_vcpu_create,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 16e207168dc1..928eb47e7379 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>  #include "capabilities.h"
>  #include "x86_ops.h"
>  #include "tdx.h"
> +#include "tdx_ops.h"
>  #include "x86.h"
>  
>  #undef pr_fmt
> @@ -46,6 +47,271 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  	return r;
>  }
>  
> +struct tdx_info {
> +	u8 nr_tdcs_pages;
> +};
> +
> +/* Info about the TDX module. */
> +static struct tdx_info tdx_info;
> +
> +/*
> + * Some TDX SEAMCALLs (TDH.MNG.CREATE, TDH.PHYMEM.CACHE.WB,
> + * TDH.MNG.KEY.RECLAIMID, TDH.MNG.KEY.FREEID etc) tries to acquire a global lock
> + * internally in TDX module.  If failed, TDX_OPERAND_BUSY is returned without
> + * spinning or waiting due to a constraint on execution time.  It's caller's
> + * responsibility to avoid race (or retry on TDX_OPERAND_BUSY).  Use this mutex
> + * to avoid race in TDX module because the kernel knows better about scheduling.
> + */
> +static DEFINE_MUTEX(tdx_lock);
> +static struct mutex *tdx_mng_key_config_lock;
> +
> +static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> +{
> +	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
> +}
> +
> +static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->tdr_pa;
> +}
> +
> +static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> +{
> +	tdx_guest_keyid_free(kvm_tdx->hkid);
> +	kvm_tdx->hkid = 0;
> +}
> +
> +static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
> +{
> +	return kvm_tdx->hkid > 0;
> +}
> +
> +static void tdx_clear_page(unsigned long page_pa)
> +{
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	void *page = __va(page_pa);
> +	unsigned long i;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> +		clear_page(page);
> +		return;
> +	}
> +
> +	/*
> +	 * Zeroing the page is only necessary for systems with MKTME-i:
> +	 * when re-assign one page from old keyid to a new keyid, MOVDIR64B is
> +	 * required to clear/write the page with new keyid to prevent integrity
> +	 * error when read on the page with new keyid.
> +	 *
> +	 * clflush doesn't flush cache with HKID set.
> +	 * The cache line could be poisoned (even without MKTME-i), clear the
> +	 * poison bit.
> +	 */
> +	for (i = 0; i < PAGE_SIZE; i += 64)
> +		movdir64b(page + i, zero_page);
> +	/*
> +	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> +	 * from seeing potentially poisoned cache.
> +	 */
> +	__mb();
> +}
> +
> +static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
> +{
> +	struct tdx_module_output out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> +		 * Because we're destructing TD, it's rare to contend with TDR.
> +		 */
> +	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	if (do_wb) {
> +		/*
> +		 * Only TDR page gets into this path.  No contention is expected
> +		 * because of the last page of TD.
> +		 */
> +		err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +			return -EIO;
> +		}
> +	}
> +
> +	tdx_clear_page(pa);
> +	return 0;
> +}
> +
> +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> +{
> +	if (!td_page_pa)
> +		return;
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (tdx_reclaim_page(td_page_pa, false, 0))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.
> +		 */
> +		return;
> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static int tdx_do_tdh_phymem_cache_wb(void *param)
> +{
> +	u64 err = 0;
> +
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);
> +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> +
> +	/* Other thread may have done for us. */
> +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +		err = TDX_SUCCESS;
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	bool cpumask_allocated;
> +	u64 err;
> +	int ret;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (!is_td_created(kvm_tdx))
> +		goto free_hkid;
> +
> +	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	cpus_read_lock();
> +	for_each_online_cpu(i) {
> +		if (cpumask_allocated &&
> +			cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +						packages))
> +			continue;
> +
> +		/*
> +		 * We can destroy multiple the guest TDs simultaneously.
> +		 * Prevent tdh_phymem_cache_wb from returning TDX_BUSY by
> +		 * serialization.
> +		 */
> +		mutex_lock(&tdx_lock);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_phymem_cache_wb, NULL, 1);
> +		mutex_unlock(&tdx_lock);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
> +			kvm_tdx->hkid);
> +		return;
> +	}
> +
> +free_hkid:
> +	tdx_hkid_free(kvm_tdx);
> +}
> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	int i;
> +
> +	/* Can't reclaim or free TD pages if teardown failed. */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs_pa) {
> +		for (i = 0; i < tdx_info.nr_tdcs_pages; i++)
> +			tdx_reclaim_td_page(kvm_tdx->tdcs_pa[i]);
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
> +	 * TDX global HKID is needed.
> +	 */
> +	if (tdx_reclaim_page(kvm_tdx->tdr_pa, true, tdx_global_keyid))
> +		return;
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +
> +		/*
> +		 * If it failed to generate a random key, retry it because this
> +		 * is typically caused by an entropy error of the CPU's random
> +		 * number generator.
> +		 */
> +	} while (err == TDX_KEY_GENERATION_FAILED);
> +
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm);
> +
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	/*
> +	 * TDX has its own limit of the number of vcpus in addition to
> +	 * KVM_MAX_VCPUS.
> +	 */
> +	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> +
> +	/* Place holder for TDX specific logic. */
> +	return __tdx_td_init(kvm);
> +}
> +
>  int tdx_dev_ioctl(void __user *argp)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> @@ -97,6 +363,160 @@ int tdx_dev_ioctl(void __user *argp)
>  	return 0;
>  }
>  
> +static int __tdx_td_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	unsigned long *tdcs_pa = NULL;
> +	unsigned long tdr_pa = 0;
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_guest_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		goto free_hkid;
> +	tdr_pa = __pa(va);
> +
> +	tdcs_pa = kcalloc(tdx_info.nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdcs_pa)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va)
> +			goto free_tdcs;
> +		tdcs_pa[i] = __pa(va);
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +	cpus_read_lock();
> +	/*
> +	 * Need at least one CPU of the package to be online in order to
> +	 * program all packages for host key id.  Check it.
> +	 */
> +	for_each_present_cpu(i)
> +		cpumask_set_cpu(topology_physical_package_id(i), packages);
> +	for_each_online_cpu(i)
> +		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> +	if (!cpumask_empty(packages)) {
> +		ret = -EIO;
> +		/*
> +		 * Because it's hard for human operator to figure out the
> +		 * reason, warn it.
> +		 */
> +		pr_warn("All packages need to have online CPU to create TD. Online CPU and retry.\n");
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> +	 * caller to handle the contention.  This is because of time limitation
> +	 * usable inside the TDX module and OS/VMM knows better about process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +	 * TDH.PHYMEM.CACHE.WB.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +	kvm_tdx->tdr_pa = tdr_pa;
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with an
> +		 * encryption key associated to a TDX private host key id
> +		 * assigned to this TDR.  Concurrent operations on same memory
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> +		 * mutex.
> +		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr_pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret)
> +		goto teardown;
> +
> +	kvm_tdx->tdcs_pa = tdcs_pa;
> +	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			for (i++; i < tdx_info.nr_tdcs_pages; i++) {
> +				free_page((unsigned long)__va(tdcs_pa[i]));
> +				tdcs_pa[i] = 0;
> +			}
> +			ret = -EIO;
> +			goto teardown;
> +		}
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_info.nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i])
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +	}
> +	kfree(tdcs_pa);
> +	kvm_tdx->tdcs_pa = NULL;
> +
> +free_tdr:
> +	if (tdr_pa)
> +		free_page((unsigned long)__va(tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +free_hkid:
> +	if (is_hkid_assigned(kvm_tdx))
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -137,9 +557,11 @@ static int __init tdx_module_setup(void)
>  		return ret;
>  	}
>  
> -	/* Sanitary check just in case. */
>  	tdsysinfo = tdx_get_sysinfo();
>  	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
> +	tdx_info = (struct tdx_info) {
> +		.nr_tdcs_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
> +	};
>  
>  	pr_info("TDX is supported.\n");
>  	return 0;
> @@ -153,6 +575,8 @@ bool tdx_is_vm_type_supported(unsigned long type)
>  
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
> +	int max_pkgs;
> +	int i;
>  	int r;
>  
>  	if (!enable_ept) {

...

> @@ -160,6 +584,14 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  		return -EINVAL;
>  	}
>  
> +	max_pkgs = topology_max_packages();
> +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> +				   GFP_KERNEL);
> +	if (!tdx_mng_key_config_lock)
> +		return -ENOMEM;
> +	for (i = 0; i < max_pkgs; i++)
> +		mutex_init(&tdx_mng_key_config_lock[i]);
> +
>  	/* TDX requires VMX. */
>  	r = vmxon_all();
>  	if (!r)
> @@ -168,3 +600,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  
>  	return r;
>  }
> +
> +void tdx_hardware_unsetup(void)
> +{

To align with tdx_hardware_setup(), add some check like:

if (!enable_ept || !enable_tdx)
	return;

> +	/* kfree accepts NULL. */
> +	kfree(tdx_mng_key_config_lock);
> +}



