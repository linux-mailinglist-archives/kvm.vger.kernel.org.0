Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDE6685AE
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 22:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjALVmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 16:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjALVmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 16:42:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6C06B1A1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 13:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673559217; x=1705095217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5rz+DJ0pq4uF1Wg/22k/MdxkeexXrdVb4XA65ex9Dck=;
  b=Takw/KQf/HP+Ikof8EH18iw8bUcOcA6PXoBV+nLWqbfymqMLRANNjd8d
   q8DhBkGPN4+vJUN5EIUG7xr6g017ob3wS82uayk78rM9j6SVsXrP1fYs8
   9nGyVtKMm2kq4PX1sjaLKc4GETeqhqWYJHxFkpJ+Y//OdyWjb5nUQ9ykz
   aTzn9czJffyMfrD8bAVnnyDGliNWYJz1/E2/4Xxt8RzDoZ4PLmXG3xLmU
   U3K1r1frZ2EIb/2IYiFMd09MuXjb41itz/8A6VapjpSN8fExdJK0AISfW
   fcih1oJNN+Zr9Wqr0GN1ZH5tcHZCmpetNTzb0hj5zTWh0zF1Q/J5XrTgt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386180363"
X-IronPort-AV: E=Sophos;i="5.97,212,1669104000"; 
   d="scan'208";a="386180363"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 13:33:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="607950266"
X-IronPort-AV: E=Sophos;i="5.97,212,1669104000"; 
   d="scan'208";a="607950266"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 12 Jan 2023 13:33:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 13:33:35 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 13:33:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 13:33:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 13:33:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ9sAqhCa/VhpfOYufbJ4WtYniPtLlf97twdHM2Vy3qb2w9QmwjXHafXc0KUeamGK87Zpck+mniiW6EGGjSswa84PyWvB+SnxDo8XBY2Oz3i+7xJ70XOyzpO6NHe23bOrCOio+dP6NDd4FxWyRvPw1N848WsyQSzUJA620coDA2VfBes/9JXFmEBbDNLecotXj6bzmWI8m023eD1MiDbrE9MGkcv/QMSA6UJfw3vxMYgEl5by0mnY17WmpqdG6t2j8PWLaGxD9LPFFNepSz1pgUpzsaZruqEuSoHRzPt9DyshhSplRQAi7b+9jsGWt4hkb7iuaMXI6M4MtdVbHXP4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mw5GqAWrXuLhgrz3fww38pKnLj5zuY+DZ/QPmgaO7eg=;
 b=aMHfwTc+7xGgDqm5UE1uStP5mtI/GCS+J+b7WBb0+DNi1FiJ+cmIl301avyScPIcC+Q/qwRf/mU4xzleziJh3QEv+KYoL7RPPdkbeHBXuwQifWRe52AIq8ZTYOqc+Z8Ae2I8usizzBEQHDKdMuUsGTcFH3KF6jPX8S8yB4OKZBbEuweUqvSq+9ZRrC5mxjCLsnyy/VhHPZc64l5U7V7J+fbB0z/KVjiwYeSlNia5upCGeV883MKQQnJ2fuA2LMJAbPqGu21YLHatB9K1nY/8dG7h6Mvy9tPTh3LBzrxr/jk9+udHY1WZNWTnC9vx6h1Gl1EaWUbMfFpdDmHFJac3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 21:33:32 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 21:33:32 +0000
Message-ID: <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com>
Date:   Thu, 12 Jan 2023 13:33:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Content-Language: en-CA
To:     Mingwei Zhang <mizhang@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
 <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
 <Y8B5xIVChfatMio0@google.com>
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Y8B5xIVChfatMio0@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::24) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|MW4PR11MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: b56226f4-db24-4595-8c5c-08daf4e4a762
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SCxWAzGRwp7/Mo7d4BpHWBh6PaTX6SQ9PiS5FtQHYOPVoFehwkb3q+y1/aivQsb/opHy92+jr8nv3j5786N8l1e957rZppOEwcf1oyQs2Sx32I8mgTDAiuEaYOKhiribt+DzKFI64r2eA2WLPbCBFaCsTiYUry0Uqhw8JwyCASEeUS2uFV7SFiHWN2XP3qj3El9ic/0SOSP5Xzx1Q1jcxFGGsxmrXjeVNZcIJWO6JYZt2OGcUFhw99VFCCBHG3bz9x2gVBAh20t6909uaePb7riDE83qd7fofyG+tSHHjaIcoMFAXl6+Of1mjVU+T//E8dkSElyLuOjnz12WiD/7O5jc2g33LjzyPODTABuQv/bT/ub/gSwEP0tApt43X07e7w/8rcup63oWNRS1EzRFI92hZYbmApC1X8/wJXXh9hNME14e14wjm4rSpFtXJFN/33EyiYCqtqokKF2uYfN72ERVEUKuN+GmfpAvR1bgC6set/Kw+QqBofOSYSyRW95kxX83CLxsag1CTAnH2wADjGtYFbyu/scM5CuQnarbzUU3YmAI4bybjeQmStgM3YQPbGdiVz4O0Ub1taiMGJ2zcT+tydM5JhB9/PPVLeZ/x3GzRshbgmvHqW4KQ+ICplHNbfXXjbIaZ/70S0caW7hoeQl2N/fRkapy1nDcMvQwg6aBHL8nisnlVejOS3LoZ1zJYZS7wI40Rql2fSjoKxIsoywmf56a+vUvUuRVESDh7Qk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(4744005)(6512007)(5660300002)(316002)(26005)(186003)(6486002)(478600001)(2616005)(31696002)(66476007)(4326008)(66946007)(54906003)(6916009)(66556008)(8676002)(41300700001)(83380400001)(8936002)(86362001)(38100700002)(36756003)(53546011)(31686004)(6506007)(82960400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnU0K2hrTGxCUG0wR1lONEdncTlIelZUQmVybjBYOXc5YXdxUnZEYmNXclpZ?=
 =?utf-8?B?bVVSRWxtSlllWnZYaUJTdjl6eDBxRmFjS1pLdXFiRTAxMXVzSVFDWjFJTWJX?=
 =?utf-8?B?d1ZDM2FDR2lVNi9oVG1CQ01lWHNHZEdnVE5QZzdyMU5VV1hWQWtSL2xPWHU4?=
 =?utf-8?B?MkR1QUREOTZDdDZoQk5MY3FwelNwQXJ4Q05reWtuZVptMEUrTHFzdnhMUENH?=
 =?utf-8?B?SEJqbEU1SFN2dkhYK3dNSmh0V0NKeWliaEtoK3BWZkJjU3FER0ZXS2h6a2RV?=
 =?utf-8?B?QjFpUWZTNU5XOGI2RVRHdytBaWZwckdHUm0vNEN3UnJyNERheGozMW1CM1NE?=
 =?utf-8?B?YU5ZM0FkS1dVcEYwWVVNQngrMVBKUWtRajdYQ0ZCZC84SCtPQlVkRFF1cWgr?=
 =?utf-8?B?T1VtK0JDbkhzV3VDcWVEUkE1dnFPQmZXK01Ub2I5cm1CRXAvTEhOb25lNlBV?=
 =?utf-8?B?MTV5MnFzYlg2MUJiM3BKSDUvYVJ0NTFUV0pxYnN4Y1JMMVgrS2w1cmtJZjVo?=
 =?utf-8?B?eElMSzRPTks0cnlsTzB5VGdaSzVXeHpTYVBKR1VqUVNpeG9tUHBKT1JPeXZl?=
 =?utf-8?B?clpjaWZYQy9BNnNmVzQrLzdmQWE2YnkyQWNaNFdzajBYNkxKWEYreTljZjV2?=
 =?utf-8?B?OERqUWgrOVRpVWRoK29xUWVjYllNc2pMZ1EyYnRGaHpjbXRWeC84OGJxR1Vx?=
 =?utf-8?B?WExzSm1LcTR5U0h1eHBBbTdxNjBCTDQwQkRnMnZVRWdBT2VQUWNTTGx3R1pJ?=
 =?utf-8?B?M2lid3d4NjRWOUl3VU1OUUFlRXV0VTJ1MFZDREVRZ28vWTNYNEM0akRLQTRU?=
 =?utf-8?B?QS8yQWVnT0F2VFFCWkxNbzdhUVlCZWk0ZFh0ZTFMU2VNTHgxMTNPZEJROVJw?=
 =?utf-8?B?QkhnNUFVVStjbzFVZFJiS2xBRldOSHordWJqeHg4bCs2OTVnMWEyNFd1KzY1?=
 =?utf-8?B?VUFJNnVtR3FmN1lhd09LOWdGU3kvZVpPQkFOeGZRT2JjTng1R3U2NUErTHN1?=
 =?utf-8?B?N0JVNjB6K0ZiVGszSzRtRlAyekxnQzVOd1VueWdCN29aVEM5cXRlMGtVMG9i?=
 =?utf-8?B?U3VkanlEZXlNUHdJWmthTG83Ymgxc3hUbUNtTzVBQVo3QjlZNy9PdDQrQUN0?=
 =?utf-8?B?MUticEN0SnBUaVo4MkhHdDlnMm9uVGpvbWQ5NElocEdXYnRPYURmb1VCMzBT?=
 =?utf-8?B?b0dueWcxWCtIOHE0aWlZRVFlUSs2VklNOVF2dS9RRHVyV1Q3MW5jTURWMDNl?=
 =?utf-8?B?Wm1TdjNJcTJtZHFHUkR0TUROL2ZsVEJmc0kwQnRSMXNmOVVhT2poK3dpR1E2?=
 =?utf-8?B?QWFmbHU0WGFMSzk1Q0Z3S29ydjRac2Z0MXdaUUtnRGJDdkhiQ21SbnFnZ2xB?=
 =?utf-8?B?cXBSUGI2VUxFL0NOaEtMaUpqazdaaE0vMExGdWhUbzJic2FtL1lrQnh5VDdq?=
 =?utf-8?B?eFJZVmEwWkowb29wQzkvcWV1dzN4TlhpREdIajc0YW11NWdSalk5aDZVK2c4?=
 =?utf-8?B?UnM1YU1MeGtqTE5tZVJ4UlRvMFhhRDBuZjF3VjJMSW1oL1pVQjRHc3hGTmo2?=
 =?utf-8?B?blZkUlhDenFlVDJ5NWdGL1hoZTdxcU94MUdKMWk0OWFqTW9PcEFyaXhUamRQ?=
 =?utf-8?B?SDEvSHVjZWlabkt5SHl6VUIvaU5tLzBFRzZYRHFkTUI1VGsrZ3pPcEpFenRz?=
 =?utf-8?B?cVhDUFZnM3BqcUFML1FzVm94bi8xb1FHVW83bzB4YjlSSXlZa0ZURlhqY0dI?=
 =?utf-8?B?RXVaaWszYVgvK1ZyRlcxVnV0ZllNcVg3MENGOUo1SERRc1Uvelk3Z1JzQkJ0?=
 =?utf-8?B?YjI1VjVFVm5Jc3FoV2RZVDc4ckVYeHJYQ1NaZmhSQWFLZ1A5cyt6SHpZbHRC?=
 =?utf-8?B?cU5HTjlQSEd3RU9ycWJkWC96ZXMvdWpXcGdQRmQ2dWdndVAyMll3V2ZwN3I3?=
 =?utf-8?B?dHVBN3MxazUwcUtIekZNeld5N0lJVCtINFJBc0NiMHFNMTlWSGxlS28vSmdE?=
 =?utf-8?B?VEdqb2s1andzREhIYVlFTjdjNFNVOWFUK3NhNkF4K1M2dWNVVWY0aDhxbHN0?=
 =?utf-8?B?MHJwc2FlK0xFUWVsYXROL2I2MlhTR21GR1VhelorZmYxNVJ5K3RMWXBPeXdF?=
 =?utf-8?B?RDdnTWt4SWthTHQ0OUNBOHJod01YdXE5RER3eEEvOTM1WVI2clQwMW9FMVdO?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b56226f4-db24-4595-8c5c-08daf4e4a762
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:33:32.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3ch8H+HA/jJE5bXzUZHJ5XBaGhoUBOQOAKbCy44wCJYdcDJiOGwy7grp7ITmN5jvmhweFx3+7yFtCQyvrJQA4kv56KVnrx7U3LLtk0ebpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/2023 1:21 PM, Mingwei Zhang wrote:
> 
> The only comment I would have is that it seems not following the least
> privilege principle as host process (QEMU) may not have the motivation
> to do any matrix multiplication. But this is a minor one.
> 
> Since this enabling once per-process, I am wondering when after
> invocation of arch_prctl(2), all of the host threads will have a larger
> fp_state? If so, that might be a sizeable overhead since host userspace
> may have lots of threads doing various of other things, i.e., they may
> not be vCPU threads.

No, the permission request does not immediately result in the kernel's 
XSAVE buffer expansion, but only when the state is about used. As 
XFD-armed, the state use will raise #NM. Then, it will reallocate the 
task's fpstate via this call chain:

#NM --> handle_xfd_event() --> xfd_enable_feature() --> fpstate_realloc()

Thanks,
Chang
