Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA276BDD0B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 00:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCPXkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 19:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCPXjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 19:39:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C1EB719C;
        Thu, 16 Mar 2023 16:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679009941; x=1710545941;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mWDrTYNokVQihEiTj3LsrmsqZVxgzNc6M6NFGVJD9oQ=;
  b=T9m8tTA3HZjQ4FSV0UKJveBElcrLRq+22n99DKE2+229Vuge+jsx0jzY
   G1pn9496s+lOVwOPIxTGsx7n3N7elWlC6qDQd4jBdq/RVNOzoWQ2FaJPv
   WethAh56Dhy/mtjvo73EbrUc/1ncZVcqaLSNvJYI68mGf8LuWOqqemfvj
   oNoE9v8rFzb97YEOA7KUPqMVHYL9RaxJx4iq1ifk11zi4VdG/49tPLo25
   pzfyhXG3Zx6J90DzMv8sYvvho/exz7X60aqjrmY9DESAqezHK/Xp9FzPi
   ESi8Fnz+0Jl7U/RE+czihsaNwN4+oaUCr7qymkdIIeNHJQE6x8gMLzaSP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318533032"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="318533032"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 16:38:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="682487294"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="682487294"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 16 Mar 2023 16:38:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:38:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:38:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 16:38:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 16:38:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABpZw0zYYHVoezF7JEy8cRP3YVj/QhMjN+TgoTXyH65xmy4oiUNKEoker8hYQY68jU5hjkK0cmyh1MBLSG6FkNxPsv3iY60P/eiPhqYGilym6Lg08f5c83oc9k1Vjq7ZjLLDbQVVAab2NvKifPDyhyvGQb4XzBfgviOz87V2YAGN5Fm7e55xb6566vKDHt9q0iNDWR5X7mZi/ZsV1ZA+NLCDSKSjCbZCrsXGwPi/SzRpqkJblQUd1HBapnskjbPvmmNdziMQcndxLDEqM4d4ZYrkfwSdyudryU3GRolt/iuf22ahM9P7nmIQyMH7OuUFqehDViDgIIOrtHaUM4eUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdAF9rQz6+ME3LIJzwNb1e3laW9A6q0ZBjGzK47dnE8=;
 b=WZdA5Zzbr8Pk5/L7/Ig0tvPizQgr01E8V5FkRNFIjl7/99V5ob5TIO8/yaTlAyn5P687xTXhWzoIKVAV83+t7flXT3sSvXIEdjff2QBrfjO+jbViRjCfbjnRBzq65RHxRMjRCiGlI/kOCDXNhcRjIBXA505ZHv0vtgATDUSNn+TzMrb4nAyXi8cb5rCDhlj03CA/WT4VXHXlrY1uZUDC/s3reY2/J6N7tLf8GJusbJfTOe3ivPHbmitcpIiQUJUwqnINTcCQCludQEjtQeqQm3RIuuor8eF9Qp/2TjKnu/5oeHQS8ScLidlvieHSV06zEYR8uJnacEldN29b9HNFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by IA1PR11MB8097.namprd11.prod.outlook.com (2603:10b6:208:457::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 23:38:33 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6178.035; Thu, 16 Mar
 2023 23:38:33 +0000
Message-ID: <4d72821b-36a2-70c9-ee58-f7a21b13510f@intel.com>
Date:   Thu, 16 Mar 2023 16:38:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <20230316155646.07ae266f.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230316155646.07ae266f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|IA1PR11MB8097:EE_
X-MS-Office365-Filtering-Correlation-Id: e7818b05-bf6e-45b5-8187-08db26778de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrkoC4Db42oT2O8hR4HhEhT9m7d33KCEt5VsOvTjJqRQtG4zaXUnyJh6NxaR+V6uRIQGHYpPTmPjPdF122KPQgChk072p2GyFlOzcq/moPGMFODZziE2UfhwfKUjpdlx57S+RTNjkzl46CkS8vrVp083DwbcZw3nB7KaVfj8kMyP+7NK8xR6Qnkcda4Ev6LNZdOUII1+XIly+0AL8m/idMsp5vbdSrMbwj4KSGsxAfon2q8JNwU12K8d70vx6ohrUdHvbZV09OB7K1LMwxmvIVeJ5WH7NzOYpqaOgnyI7dJaikL+noavX3nKUw48rWjvxMQRQSWoy+XGTIsK6Jx82pO9BTlIoti07K/vpc2FIW2PSwjW16FmKpsKZvA6BUMjsRHMPJcCWRRCGLgrq4dseGpIqNsGRa7KVe0P36V8Vi/BLUxwk+5Kb7NYjqhmoDDtgsQLQHTTg5UpNI45k/9NGdHXrrFMgjhP/4zT+BJ/vLHRprWnRG2aHZTrag3yZpEJZGTWYz2f9oC2+PLt/v9vSCWaZh5vFLsRN3f/cWy5jI3HLRkREqI9xLdjPMxMS9i5Trc5bzznMqpce/PC0TwZKvPSuPh37ykBcb0d6zTda/k1Yb7lwmW3INJim4KeakaRpN+iWNSSyucLNI2HCZfNlYtjUrXrbrGy9t19LygDJhySWYwElacqjySzmMZrFcxFnGJ21PvmMVVza5XKjTp2ecdMmDWtLK+bzcEPYEsWCTQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(8936002)(186003)(31686004)(2616005)(66476007)(44832011)(5660300002)(66556008)(316002)(66946007)(6506007)(26005)(6512007)(53546011)(41300700001)(83380400001)(36756003)(8676002)(6916009)(4326008)(6666004)(6486002)(31696002)(86362001)(82960400001)(2906002)(38100700002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUFYTVh6eWhpazZsck0zQVBoSTdMUjl2SllwTUpBVGgzZ1NwWTE3YTFKdndl?=
 =?utf-8?B?N0c3bTFnSFo1YU9VSDhRamRKMXc2TkxFNUdVVFRxWnR1c1RaWk5zZVJrTG5F?=
 =?utf-8?B?MFVBbDBybFE4VEs0R3AxeTFVMlBEUzFwQ3BlTkk2RWNiVUNwVkl6aUtFOFFU?=
 =?utf-8?B?Q3YwMHE5ZnZmOUNTVzVsT3QvTTl2REt2THl3a2N3WFZ2SUk1NXkxT3VTa2xI?=
 =?utf-8?B?Q0tSTGVJRUpvc0lMRGtPbXgxSlNzT2hxSThXTnNienZQaXlETVRmNVFvaVh5?=
 =?utf-8?B?dERSYmNxcGtLRkxaaGNNVGh5eFhvVUk0ekhlbTBMcktOT20vN1FReHkzNzhV?=
 =?utf-8?B?OXNPQXZkOVd6T0Nvd3VFVlNXVkFDbkRlbXlEQmpRUjVkMVdIdG5Lb2dINXhX?=
 =?utf-8?B?TnRoWXdDSWIxemxZSFN1MmlNRkQxREdFSFJYbU5mREMyYmd6UkRwNHR4clFy?=
 =?utf-8?B?b2JtcGcweWdlcUFQMmNlaXNzZVN5OXZ6bDdBR081L3REMGxDR1ZTemJoRVpU?=
 =?utf-8?B?ZUdVQ05MSGpWOVFZWEVhV1hvRzFjYUdCWmVsZk5DKzkwQkttZVVBWXRTenhn?=
 =?utf-8?B?TU8rcnBBR0k4T0dJOTdFTzE3TU1RTjkrYkI5bmEyeCtRazNaS0JVV21VUWtP?=
 =?utf-8?B?SURDZU9Ib1MrK3prVnJtQ1R3eHg1WFFrZVp0WCtLZm9CRXRDTEhjdGI3ODI0?=
 =?utf-8?B?UVRjVFZNU0VwclFldGRFOVA1bkJmOTd6QS9hRGNNZTBJT3paUXNRMVhPQkUr?=
 =?utf-8?B?dTBERWNuWUVXUGlETDQ5SWR2L05QbzJSaTBYVE4wY3YreFJPMUZNN09rZ2pq?=
 =?utf-8?B?bDkza1o4WU05OE50TUUrY0NtUjdxc3ZwOUkvb3FETGtUaEplWE03N1BpU1p4?=
 =?utf-8?B?OXBIQVZMT0lScmlXd0NkVUNVOU84bVI3ZkdnTllqek5BdlpsTXh2OGlaUXVq?=
 =?utf-8?B?dkREd2lZVnRVQWRyV1EwZy9VL2ttWmFaOFFIL2F0WkczZlpLNlhKTTVHQ2FN?=
 =?utf-8?B?Yjg4c2FrSXZuN05xcFVnWXJvVzNoQTZVc1FNZWZaSWFSdmF3dmtGSkFCRWJ3?=
 =?utf-8?B?M1dveUNkNVY3ZU5ZQjIwa3lLZzlCOTlBNjUzRklGdkE5RE0vNnUvbHF0ZHJm?=
 =?utf-8?B?VkRKdGprNkd1K2oxU3pFYUNWTzVCZ0djWE9iNGFLNElaVXU3MVlLMkVxU1A3?=
 =?utf-8?B?SFZsTVo2WDRra2dqdTR5bElMTkVUWUNjRnpQMU83Uk5seEhEVnNreit0WWhG?=
 =?utf-8?B?NUdjYU9BaE9rM2FJd21GRnl4QU54WE9yYnRrV01pRzliTVhBTEp2MUlZN3Rp?=
 =?utf-8?B?SkhLbXYwdUw2VVd0T2lQS3pwWjFOcFB1MFMwUkZ5QlRQcGZacXFnRk9tckxP?=
 =?utf-8?B?dEVSMitlRTJ0U1pJbFdlVTFCMEwzWlo4c25iL0JvSW5raU1VMkxmYjdUQkRI?=
 =?utf-8?B?L1g5TklIZkp5Y1FScGVyNEN2Zk9TVVI3ZmNONHdzaFdyRHplMXloVzd3eDNC?=
 =?utf-8?B?a0VCNXNVUnlhV1VTTFozZW5neGc1S1VVR1huR3VVdno2QU5jU25vaHp0RWhV?=
 =?utf-8?B?dkFOSjJVc09ENTJuWUdOTm9MNFhmODFyMWEwK1hjZHpuUjgwSTJMdEg2UFFt?=
 =?utf-8?B?OEJ1MEs4Wk9xWm1OV09YYW1zWXE5SHBvOGsrdkwydGNhVHRnNUpwRXRmS01Y?=
 =?utf-8?B?VkVEL1BrekwzT0dnSjg5cVlqMHVOVGpSU1c4enJORDRMcnZvOE8wVjdqVDFQ?=
 =?utf-8?B?b0VmZ1ZqTEg2emkwWlBPU3UxOTY2RUZiT3NwQnJkd2NKcXJsRUExdGpuNkJE?=
 =?utf-8?B?V1JNQmFaNCtCRFJLMnJSengyVS9McTBIclF4NjlTMGRmTWhhYWltS3gyQ1pi?=
 =?utf-8?B?SGxVOERJMEFONGpGSU1qMEhrWm9jWGJtS2dtMmhmWHdINlVRZG9UaVF2Tk03?=
 =?utf-8?B?RTU1ODk3eUxxNjVLUk5vK2wybm1BS2dTYitYU0hHNGFEZTJWR1poVWs3Tzkw?=
 =?utf-8?B?Vmc2ZzlSK2k3VTVZZE9GWWo2aTh5ZSt4RCtnbGhLVGpJSkdycVVraEVKZlVT?=
 =?utf-8?B?cGZ5VnB0dmdMYnQwdWNaREpqWHFxKzZUTUZpdTNMcUxRbFFpUjUrNXEwMjRV?=
 =?utf-8?B?TCtnVk9KYU5mT3dnTC8yemlDY1lCSitEMCtIblU4YzRiSE5JOG5JeXpkd2NH?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7818b05-bf6e-45b5-8187-08db26778de6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 23:38:33.2183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlygoSbuK516zKK+biYl0hUKOBzPmnyeVLlof+B1cLTTsyfERkXU18fbJd8oXJN5tS5YN+6h4yzscOSMJOwwOoLm1emvdgraRW4+fbLYcUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8097
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

Hi Alex,

On 3/16/2023 2:56 PM, Alex Williamson wrote:
> On Wed, 15 Mar 2023 13:59:20 -0700 Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> 

...

>> == Why is this an RFC ? ==
>> 
>> vfio support for dynamic MSI-X needs to work with existing user
>> space as well as upcoming user space that takes advantage of this
>> feature. I would appreciate guidance on the expectations and
>> requirements surrounding error handling when considering existing
>> user space.
>> 
>> For example, consider the following scenario: Start: Consider a
>> passthrough device that supports 10 MSI-X interrupts (0 to 9) and
>> existing Qemu allocated interrupts 0 to 4.
>> 
>> Scenario: Qemu (hypothetically) attempts to associate a new action
>> to interrupts 0 to 7. Early checking of this range in 
>> vfio_set_irqs_validate_and_prepare() will pass since it is a valid
>> range for the device. What happens after the early checking is
>> considered next:
>> 
>> Current behavior (before this series): Since the provided range, 0
>> - 7, exceeds the allocated range, no action will be taken on
>> existing allocated interrupts 0 - 4 and the Qemu request will fail
>> without making any state changes.
> 
> I must be missing something, it was described correctly earlier that 
> QEMU will disable MSI-X and re-enable with a new vector count.  Not 
> only does QEMU not really have a way to fail this change, pretty
> much nothing would work if we did.

Thank you very much for confirming Qemu behavior. 

One of my goals is to ensure that these kernel changes do not break
existing user space in any way. The only area I could find where
existing user space may encounter new behavior is if user space makes
the (pre dynamic MSI-X) mistake of attempting to associate triggers
to interrupts that have not been allocated. Thank you for confirming
that this is not a valid scenario for Qemu.

> What happens in this case is that the QEMU vfio-pci driver gets a 
> vector_use callback for one of these new vectors {5,6,7}, 
> vfio_msix_vector_do_use() checks that's greater than we have
> enabled, disables MSI-X, and re-enables it for the new vector count.
> Worst case we'll do that 3 times if the vectors are presented in
> ascending order.

Indeed. While testing this work I modified Qemu's vfio_msix_vector_do_use() to
consider VFIO_IRQ_INFO_NORESIZE. I saw the vector_use callback arriving
for each new vector and having Qemu just associate a new action with the
new vector (call vfio_set_irq_signaling()) instead of disabling MSI-X followed
by enabling all vectors worked well with the changes I present here. A single
interrupt was dynamically allocated and enabled without impacting others.

> Based on above, there really can never be an error if we expect the 
> device to work, so I think there's a misread of the current status. 
> Dynamic MSI-X support should simply reduce the disruption and chance
> of lost interrupts at the device, but the points where we risk that
> the host cannot provide the configuration we need are the same.

Thank you very much Alex. In this case, please do consider this
submission as a submission for inclusion. I'd be happy to resubmit
without the "RFC" prefix if that is preferred.

Reinette
