Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22E57BF006
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 03:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379286AbjJJBFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 21:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378608AbjJJBFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 21:05:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F489AF
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 18:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696899921; x=1728435921;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KJ2w8R+JTilFufXynM34z9ov96CxwTTTa09l/lfrRLA=;
  b=B2nl12UJzaMhY5oyTbLUQQPUITb5PVQxEqoRfRdc5Q/EdKyc4Wseil5s
   sMsoUEmg36YlDh8OUlid1KvP0xYN2l9qfn7c4RMm9x/2zsVw5aIiqDRdT
   Keo2djDAwTOt4hRvmqTYgPi9JbCcKhENgLtaHPpjhjrG710oW6Io60T+F
   S71JnhNIH9S2PUvt7v2M+Uu+oSbIktupZ7XTjDp/0rCq4/Gk2Szi3IYGI
   Fft0+EGoQy9J9p/EQzQfqrN0FYsreZv4bHkKcrEANWmOV0wDlekSCZxTt
   PFxCdr0ZHCtGQPsurkEPyWkEALGXSW0zSJah1RcLZ8/MUDepbhlDShbw5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363636435"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="363636435"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 18:03:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="753214934"
X-IronPort-AV: E=Sophos;i="6.03,211,1694761200"; 
   d="scan'208";a="753214934"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2023 18:03:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 18:03:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 9 Oct 2023 18:03:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 9 Oct 2023 18:03:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 9 Oct 2023 18:03:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWDBQ8UgBrUP5W3SugUFMtNUgtguLHxFJz2wXh70sTJoQQdEiM9ntBpfQUdJYkHIJSqTjuz8k29EOUqZnAog2cVZa1PmHNfdp7WKea1b8VPSJoB7Pyf7VtKT4U27leW3bN+8uys8Lf+n4dVq/dWjtdYS4ozpRaPQZaiIiOTAE053tRLhW15oD7jruutnUZeF4G2ALVI4VR2iyDNpFzSvwOht9JbRdPhjIGEUUKY/4ZouYMNtHzMksUZXidoGwdB26sXjHdhA1HyjsFb9VFphriQ/qsCURmVhMJR7yOPsFJ2A0FdLOdmbz2ZmCeKStkD2RbnCxX4GSIhzCcdZ7Eh2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vsd2uozQQo33LR9wBxsJMm7JnFaCNjYdaUy8ZIuGB0=;
 b=HxWNgYFsGdyBhMicQN3V5sBllq658Hz0gig5qsborw1xjPJeYlmlbGnas+lueQdlP8AVFA096L5pw+ER9IT30TkNjrd01JH5ULB3KFZOo1IFVJ6BsyqecqC53K8UECC71yQF3q71fkEH4z/IxqOx5BgWOq7PwKthy4CiBVn5SR3XQRIFRjL3MYzLA4RMd9roX6PNnpDqHo5hy3ihN+ciyGu0yiBJ5qW72QMHqK957kg2s799xE5PCUU8Oi/ieL6HW61hq4l3ORLdy0nVCr/ctOgrwt5u91axy6b8lE/IDXwVOyA8Tb7PQ4HWu7fJ1759edpKeCkBJHEaoN5Wbcm9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5881.namprd11.prod.outlook.com (2603:10b6:303:19d::14)
 by IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 01:02:57 +0000
Received: from MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::3346:a9d1:1c70:eec2]) by MW5PR11MB5881.namprd11.prod.outlook.com
 ([fe80::3346:a9d1:1c70:eec2%6]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 01:02:57 +0000
Message-ID: <2175b694-c21f-464e-afee-b9ee9da154c1@intel.com>
Date:   Tue, 10 Oct 2023 09:02:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/58] i386/tdx: Adjust the supported CPUID based on
 TDX restrictions
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        <erdemaktas@google.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-9-xiaoyao.li@intel.com>
Content-Language: en-US
From:   Tina Zhang <tina.zhang@intel.com>
In-Reply-To: <20230818095041.1973309-9-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To MW5PR11MB5881.namprd11.prod.outlook.com
 (2603:10b6:303:19d::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5881:EE_|IA1PR11MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c7bd24-87ac-4246-97f4-08dbc92ca43a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jswUmE1+83KqvILtCe0f2UoEez5vR0uCHbRS9Jx0Ely4y2w76hiYE+hACDbX2BWroNvEO7TkHwzrEmYCx2GLHBesKLoKXcx6S0Kplt72vhB7HhO+B0DBQip7lVvqMRXeMwvaW4mjKuJLGLGg9Tzhewn9TimSK/6ulRxLRvMoAXqk2dHrIUd82uFVYd/q4e39SnFgwYgIIn2sZr9YZHB2zp157zAvrMwIU4Oo/OQWRfl+t0R2yhgbtwYhHXatk4rZPZEeodyyBD1PVvFQVbVDo84qxg24nNA9Yy2t8VhoqarBulrl8tkGQVeFDtGFBWX2QkqN5nLbozVDSWofEpAfDYoCBkR7vKrDD5WeihmRSxy4v+CGdIpm93sumyCZ252habhOXF4xiscPlm0w5pxW8XZc59OXjCjF1StZiBd5pEkWApQuxp5f/LCiEVu/Sh1pLrS4vW+4KYdgCPElYKGfWhEzZac7P80RhKbc6qwsfjm8cn71YEmMiyOOfSjIHjteTHN0sdAP8MXlSxfR9Lg3uW2j20O4kBVZ3dV/xDK5QhNlqKQOycRjSP25X72CWGOGPPgIPb5AIO8JOQBcbG0AwiTSX6NqWAxgE7qsrHJU5eAFvDApip1kxyl4Vg6W5E1ilZjy8knLTq/q0PP/pZYLMc5u+9Z4Pm4L8wZE+K38eQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5881.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(31686004)(26005)(2616005)(53546011)(31696002)(82960400001)(38100700002)(86362001)(36756003)(921005)(107886003)(7416002)(2906002)(4326008)(44832011)(6506007)(478600001)(83380400001)(6512007)(8676002)(6666004)(5660300002)(8936002)(6486002)(316002)(41300700001)(54906003)(110136005)(66556008)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TU0wQ0dRN21vWmhIeEZ0WmVoaCsyaEpPNUJTbzJtMFRMT0xEMEREZFRRUWUy?=
 =?utf-8?B?SDM2WkpKVm5naGxwK2syRUtSbG1XQy9weCtmMHBKRXBEU3ZCU0pVaFI5RnZS?=
 =?utf-8?B?YjRQYkNYZktMbkpBbzAvYjlVaTB3b3c2Ylp5Wk5ZNytWck5iejllWi9oSTFZ?=
 =?utf-8?B?L0dtN1NZYTJ4cjlxL2swZElyVVdORGFGaXBYcjFhdk1iM3Byc3dqZzk0RXQv?=
 =?utf-8?B?cXNUSDNMRHdTeC9MWE96Y1hOenJSMTFIYWFhNWg4dEhVTVk0eG5oUFN5YWRa?=
 =?utf-8?B?Z2VPSGt0WnJBTVZhVjhOMU05Zk9zYkhmb1NQSEdjTTl5bjc0Q1Z4YUpwWmtZ?=
 =?utf-8?B?VjN4MVlDL3lQUGFMbzQxcmg4c3BaSVdQVTVrMnRtY0Y1ZWVSZjZ4a1pOcVJq?=
 =?utf-8?B?bDVkeU9LV3pFbS9NbmhOWFNrZ0VxdzdOcnd5enFPSWs4WFJKdnpwd3NKQ1BS?=
 =?utf-8?B?Vkl1NVVteERETDJGbVgyeW5PQm1nNlJLcXliNTlmSzUzL2Q4cUFoR0QzNkNa?=
 =?utf-8?B?MlNRL1dZMmNkbXBwN3dIUlh0TFZqRkx3dVVHNGpsdFRBV3doSDAyNDRzdVlI?=
 =?utf-8?B?MEhjN3Rrd1hKcU5YWC9HVXBWWGFTRFZlSS9jTnVkMVpoT2o5TXB3N2JrSmw3?=
 =?utf-8?B?NWdtVHBMWEllaDJDVXJ3UmQ4N045dEdnaTV4dnpIdDl1cUtGMndJaWFXclNk?=
 =?utf-8?B?aENJT0d2TlVCNWMrQ2I5V1NBd3hvaFVxZ2pCR3NidlpRNGxmNXJSTHNodUMz?=
 =?utf-8?B?bzdKQ3Nra092UXgyOWV3M0NxYUxiQUR2KzIxYUg4Q05DdEdlUS8wTU5hcVp3?=
 =?utf-8?B?M1ZNUUlqR3R0M3NqUTFvRm5MVzJNd0kyVjM3Mm9zdzJPeVQ3RWo5dVpkdWJo?=
 =?utf-8?B?RHZXVEZBbEdhb2FMZjRjR3NBbXl3TXBrUmcyVnhhdkVZT2NiTXBJRHB3cVZ0?=
 =?utf-8?B?NHE0R0pNR1FsOUd5blpBWlpSVDcxWmFQbGMxRGw4UUhwLytmSUNtY05TZmFa?=
 =?utf-8?B?NjdVeklTR1dvWTMvQ0RPWStZUWFRTE05OHN6U1hGbHl2MnZKR1E3bjQ5cVIv?=
 =?utf-8?B?QTdjQStIOGhxa2VFSnUzMlNSYm9meTc5ZWovMndwblJtR3J2WENRakdKWWJK?=
 =?utf-8?B?dTBxNllnd3dJUy9jWFZGSUNpWG96WDR4RlZxSURMOHBNNm1RbWtpeENPUXp4?=
 =?utf-8?B?RlF2aEo5TC9Vay9wZitzMHNNbytneERHR2EzZURXWlRVQ01XYm13MEFzdXVa?=
 =?utf-8?B?UytnL3RzWWg1UkJGejhXRHJ4ak9WYlZlUStXR2xkaE1FODk5MGJCait0U1hI?=
 =?utf-8?B?eGtnT3ZuUEd4ZzdTalBEMjQzWDV0V05OdlRURHN0bi9RaTZzZDNBKytxK2Ro?=
 =?utf-8?B?Mks0bEtuOUllaGxucGQrVHZYNFVRNTNxOTJtTUZVU1lGRmJzSGhVd0d0WXZa?=
 =?utf-8?B?bTA4dkNPZitkQ1FDVU1WZ09rU1R3bzdhaE9NNzJOV1IvSnM4L3doMGVrdkVs?=
 =?utf-8?B?MmZ3UEpiT25kWG14YzVPZE9qS21XSkNJbS9JMUh6T25reC9SWkVWZjBzTTlQ?=
 =?utf-8?B?MUtraGFPWUI5MGNLdnZ4NjE1Ty9zRXdtQ3VzRkpNampGNCsySm5NQTIwbG5a?=
 =?utf-8?B?V3RacXBWSTRBVzQyb1N2c29QVHJMSmVHOTh2eEMrNmR0b3RIU1RVd3ZpVytK?=
 =?utf-8?B?eTZFdkVVL1E5empiODJvMUJEWHRkS0hvcU1vYWhzMmY5U2lpbnZwYitSSFMx?=
 =?utf-8?B?dmpnUlBpNGx6RDB1QWhrTzRvalI3dDNFd2JJMXUxUHdRS2lpYTdwM0JPMTJP?=
 =?utf-8?B?R3RvVTM5M09ETU9uSEFMUjVOYlZRL3RTVlM0UUw5Ym4zNlcxMnprSW1kcGU5?=
 =?utf-8?B?RVAzNXhrK0dCQUM0Z1Z0Nk5wc1ZRUEE4UWhLSTF3WjRJdGs0RDBjNG84cjRN?=
 =?utf-8?B?ZGU0ZXFIK215MzJOZWJWKy9uRW0zTXQyWnhEWGhSbFRLTys1NkI2NGVoY2VT?=
 =?utf-8?B?ZmswSXZaMURLZmk2NTVFYUxpeFh1OFJMVW5EbjhXTVJQUmk0aXIyamdETytz?=
 =?utf-8?B?L2xPS1BKbVVjcW5kZGVHc2FpYThaQzhvYlg3RWpJRk41Z0l6d2pXY1JNemVS?=
 =?utf-8?Q?zZr2rCrfJChEjsCUng9r6Wf/3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c7bd24-87ac-4246-97f4-08dbc92ca43a
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5881.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 01:02:57.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiO9bFJmf+VXO22oWAaWx9E3v0ZhOpNuueXwUPw/LGz0Gi0pe5LGqY7Sz2qsiqZPtwAZIPfpHBYh0Lp5kzdi+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 8/18/23 17:49, Xiaoyao Li wrote:
> According to Chapter "CPUID Virtualization" in TDX module spec, CPUID
> bits of TD can be classified into 6 types:
> 
> ------------------------------------------------------------------------
> 1 | As configured | configurable by VMM, independent of native value;
> ------------------------------------------------------------------------
> 2 | As configured | configurable by VMM if the bit is supported natively
>      (if native)   | Otherwise it equals as native(0).
> ------------------------------------------------------------------------
> 3 | Fixed         | fixed to 0/1
> ------------------------------------------------------------------------
> 4 | Native        | reflect the native value
> ------------------------------------------------------------------------
> 5 | Calculated    | calculated by TDX module.
> ------------------------------------------------------------------------
> 6 | Inducing #VE  | get #VE exception
> ------------------------------------------------------------------------
> 
> Note:
> 1. All the configurable XFAM related features and TD attributes related
>     features fall into type #2. And fixed0/1 bits of XFAM and TD
>     attributes fall into type #3.
> 
> 2. For CPUID leaves not listed in "CPUID virtualization Overview" table
>     in TDX module spec, TDX module injects #VE to TDs when those are
>     queried. For this case, TDs can request CPUID emulation from VMM via
>     TDVMCALL and the values are fully controlled by VMM.
> 
> Due to TDX module has its own virtualization policy on CPUID bits, it leads
> to what reported via KVM_GET_SUPPORTED_CPUID diverges from the supported
> CPUID bits for TDs. In order to keep a consistent CPUID configuration
> between VMM and TDs. Adjust supported CPUID for TDs based on TDX
> restrictions.
> 
> Currently only focus on the CPUID leaves recognized by QEMU's
> feature_word_info[] that are indexed by a FeatureWord.
> 
> Introduce a TDX CPUID lookup table, which maintains 1 entry for each
> FeatureWord. Each entry has below fields:
> 
>   - tdx_fixed0/1: The bits that are fixed as 0/1;
> 
>   - vmm_fixup:   The bits that are configurable from the view of TDX module.
>                  But they requires emulation of VMM when they are configured
> 	        as enabled. For those, they are not supported if VMM doesn't
> 		report them as supported. So they need be fixed up by
> 		checking if VMM supports them.
> 
>   - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
>                  totally configurable by VMM.
> 
>   - supported_on_ve: It's valid only when @inducing_ve is true. It represents
> 		    the maximum feature set supported that be emulated
> 		    for TDs.
> 
> By applying TDX CPUID lookup table and TDX capabilities reported from
> TDX module, the supported CPUID for TDs can be obtained from following
> steps:
> 
> - get the base of VMM supported feature set;
> 
> - if the leaf is not a FeatureWord just return VMM's value without
>    modification;
> 
> - if the leaf is an inducing_ve type, applying supported_on_ve mask and
>    return;
> 
> - include all native bits, it covers type #2, #4, and parts of type #1.
>    (it also includes some unsupported bits. The following step will
>     correct it.)
> 
> - apply fixed0/1 to it (it covers #3, and rectifies the previous step);
> 
> - add configurable bits (it covers the other part of type #1);
> 
> - fix the ones in vmm_fixup;
> 
> - filter the one has valid .supported field;
> 
> (Calculated type is ignored since it's determined at runtime).
> 
> Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/cpu.h     |  16 +++
>   target/i386/kvm/kvm.c |   4 +
>   target/i386/kvm/tdx.c | 254 ++++++++++++++++++++++++++++++++++++++++++
>   target/i386/kvm/tdx.h |   2 +
>   4 files changed, 276 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index e0771a10433b..c93dcd274531 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -780,6 +780,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   
>   /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
>   #define CPUID_7_0_EBX_FSGSBASE          (1U << 0)
> +/* Support for TSC adjustment MSR 0x3B */
> +#define CPUID_7_0_EBX_TSC_ADJUST        (1U << 1)
>   /* Support SGX */
>   #define CPUID_7_0_EBX_SGX               (1U << 2)
>   /* 1st Group of Advanced Bit Manipulation Extensions */
> @@ -798,8 +800,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_EBX_INVPCID           (1U << 10)
>   /* Restricted Transactional Memory */
>   #define CPUID_7_0_EBX_RTM               (1U << 11)
> +/* Cache QoS Monitoring */
> +#define CPUID_7_0_EBX_PQM               (1U << 12)
>   /* Memory Protection Extension */
>   #define CPUID_7_0_EBX_MPX               (1U << 14)
> +/* Resource Director Technology Allocation */
> +#define CPUID_7_0_EBX_RDT_A             (1U << 15)
>   /* AVX-512 Foundation */
>   #define CPUID_7_0_EBX_AVX512F           (1U << 16)
>   /* AVX-512 Doubleword & Quadword Instruction */
> @@ -855,10 +861,16 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_ECX_AVX512VNNI        (1U << 11)
>   /* Support for VPOPCNT[B,W] and VPSHUFBITQMB */
>   #define CPUID_7_0_ECX_AVX512BITALG      (1U << 12)
> +/* Intel Total Memory Encryption */
> +#define CPUID_7_0_ECX_TME               (1U << 13)
>   /* POPCNT for vectors of DW/QW */
>   #define CPUID_7_0_ECX_AVX512_VPOPCNTDQ  (1U << 14)
> +/* Placeholder for bit 15 */
> +#define CPUID_7_0_ECX_FZM               (1U << 15)
>   /* 5-level Page Tables */
>   #define CPUID_7_0_ECX_LA57              (1U << 16)
> +/* MAWAU for MPX */
> +#define CPUID_7_0_ECX_MAWAU             (31U << 17)
>   /* Read Processor ID */
>   #define CPUID_7_0_ECX_RDPID             (1U << 22)
>   /* Bus Lock Debug Exception */
> @@ -869,6 +881,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_ECX_MOVDIRI           (1U << 27)
>   /* Move 64 Bytes as Direct Store Instruction */
>   #define CPUID_7_0_ECX_MOVDIR64B         (1U << 28)
> +/* ENQCMD and ENQCMDS instructions */
> +#define CPUID_7_0_ECX_ENQCMD            (1U << 29)
>   /* Support SGX Launch Control */
>   #define CPUID_7_0_ECX_SGX_LC            (1U << 30)
>   /* Protection Keys for Supervisor-mode Pages */
> @@ -886,6 +900,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
>   #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
>   /* TSX Suspend Load Address Tracking instruction */
>   #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
> +/* PCONFIG instruction */
> +#define CPUID_7_0_EDX_PCONFIG           (1U << 18)
>   /* Architectural LBRs */
>   #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
>   /* AMX_BF16 instruction */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ec5c07bffd38..46a455a1e331 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -539,6 +539,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>           ret |= 1U << KVM_HINTS_REALTIME;
>       }
>   
> +    if (is_tdx_vm()) {
> +        tdx_get_supported_cpuid(function, index, reg, &ret);
> +    }
> +
>       return ret;
>   }
>   
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 56cb826f6125..3198bc9fd5fb 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -15,11 +15,129 @@
>   #include "qemu/error-report.h"
>   #include "qapi/error.h"
>   #include "qom/object_interfaces.h"
> +#include "standard-headers/asm-x86/kvm_para.h"
>   #include "sysemu/kvm.h"
> +#include "sysemu/sysemu.h"
>   
>   #include "hw/i386/x86.h"
>   #include "kvm_i386.h"
>   #include "tdx.h"
> +#include "../cpu-internal.h"
> +
> +#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
> +                                     (1U << KVM_FEATURE_PV_UNHALT) | \
> +                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
> +                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
> +                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
> +                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
> +                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
> +
> +typedef struct KvmTdxCpuidLookup {
> +    uint32_t tdx_fixed0;
> +    uint32_t tdx_fixed1;
> +
> +    /*
> +     * The CPUID bits that are configurable from the view of TDX module
> +     * but require VMM emulation if configured to enabled by VMM.
> +     *
> +     * For those bits, they cannot be enabled actually if VMM (KVM/QEMU) cannot
> +     * virtualize them.
> +     */
> +    uint32_t vmm_fixup;
> +
> +    bool inducing_ve;
> +    /*
> +     * The maximum supported feature set for given inducing-#VE leaf.
> +     * It's valid only when .inducing_ve is true.
> +     */
> +    uint32_t supported_on_ve;
> +} KvmTdxCpuidLookup;
> +
> + /*
> +  * QEMU maintained TDX CPUID lookup tables, which reflects how CPUIDs are
> +  * virtualized for guest TDs based on "CPUID virtualization" of TDX spec.
> +  *
> +  * Note:
> +  *
> +  * This table will be updated runtime by tdx_caps reported by platform.
> +  *
> +  */
> +static KvmTdxCpuidLookup tdx_cpuid_lookup[FEATURE_WORDS] = {
> +    [FEAT_1_EDX] = {
> +        .tdx_fixed0 =
> +            BIT(10) /* Reserved */ | BIT(20) /* Reserved */ | CPUID_IA64,
> +        .tdx_fixed1 =
> +            CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_APIC |
> +            CPUID_MTRR | CPUID_MCA | CPUID_CLFLUSH | CPUID_DTS,
> +        .vmm_fixup =
> +            CPUID_ACPI | CPUID_PBE,
CPUID_HT might also be needed here, as it's disabled by QEMU when TD 
guest only has a single processor core.

Regards,
-Tina

