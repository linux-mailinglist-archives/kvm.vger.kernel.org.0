Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE50078677E
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 08:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbjHXG2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 02:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbjHXG1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 02:27:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5942C1705
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 23:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692858457; x=1724394457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8aM+sqBV4sQ9TdaXG5K2TtK6Xjb+DChR56YrNcQiunU=;
  b=RIK+SPD3LtoqY+9+KgZvIbBh6wWYasQQTwekZ08KS0sICjPqHTex9sm7
   Xnd3pMu6XK4sVnQZu2C7FY/pngBJBoroYhchmclCPI0FiB+RVCTX/bMrG
   uyZQ8FbwBIQ5skv/5LIjRvz51Z92Eca2+736zw0AmID29U7S2/fVGQ0Mp
   YyFqVukRRDS0KughMhaPaL+p9PYnGWBNi0+6p6XGBEpRhlgmvYZ21+YkR
   M+NbTfA64RS9ISyduIRriusqEp8TPJDZFOjMF6yYXUge0rWNB88BGw5im
   dLwqjeDJawNqq85Bl79ECWRMaff9PbfQJ+wB4CvriGZ0b8B5cCP0e0PnG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="374327238"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="374327238"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 23:27:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="983580581"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="983580581"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 23 Aug 2023 23:27:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 23 Aug 2023 23:27:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 23 Aug 2023 23:27:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 23 Aug 2023 23:27:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 23 Aug 2023 23:27:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWNsjmt25a2OSMLOrxMfEh4Uiwm8vxiEBOOIPhsasEM3JyCPyjpVaecADhMk1RfZp9X7STgYAfUMJBBBN+NratVHI0dg19cDrPMNKCn7x+4lMzSe1aETF6MhALeUu86iAIrxWeBL2UuF1hireQ7qg966nbPrEaXEgKdcqGgPquAhpLjllcKwv0Nbej+F69fS8Va/NlH1dU8r8o5FqgvC625+S8qvL/4qrb9jpk9Et375U0vpgHEN5gUS1O70YPwowb6yKQK8TVrdFS/oUjRAqgpon5keyZJCssdY47ecYTpIlI93FIgDw/VLrLYKY8ZOJ/3tnh2Wc0ZIouAO9qFuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7xNU4iNh4HIBnwVATmngknTtNnn+/QrUup/Oz2+z7A=;
 b=OSugt6C4CJ+j4HfUqIFJfgdpVk5ZxApMGg48XturYHjVHkgYik9by6OvtWUoeo/XIUar2bsBGfW0+loimO1bfGuom/wpxl3WbxqonTTOm+n7pH/sGq1WV3+sIMBPN6K3CIeW88RBUI7obp3zbtFaOyv8zgi62KaMuPJtaRunhIaaW/hI8UGuAOIM4+9WS1kIGToBLornfh8NkF0o7wxDhgT+frXnIpvWENCtG2UNyBavte1aWzzXNLlnbSrculI6LVltYRXov9SOE+32Zlg2YzZe1wpR4HFTI5D/PnftQUOblpOgEbzPhlBwPJRYuMsltYbcIWkEQ7orqF218MxbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 06:27:32 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::3f7:57fe:461d:83c2]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::3f7:57fe:461d:83c2%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 06:27:31 +0000
Message-ID: <b6d2f0af-a2ac-849b-e9be-49731ad5d3ce@intel.com>
Date:   Thu, 24 Aug 2023 14:27:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 42/58] i386/tdx: register the fd read callback with the
 main loop to read the quote data
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        <erdemaktas@google.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-43-xiaoyao.li@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20230818095041.1973309-43-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: edb17dc9-9612-4f6c-09cb-08dba46b3221
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UouHRvjH/FcEimKkj0wZeapmyr73twTaIj7A4QCaioJ3ubM1yiI2bF9J1oCjTIkG6mITELOfl9AcTMX2NnmC1Kg+M0o+16KKHP9jHdHof0gH+eEYmCFx7KboM6FzkZsYgkT3s4kRJK3Lt5jtN7E97rYTiwG+0U1u70l1N4CsFa2zbnNIp/XfX/xcBHEsgPZDGxnz5x1O4VCuDv+3WDLCkVCIF2YfAsM26TKzU41vPGKqDhtMPc8mFIyDWq/nG09NTxqAMUPVzvDPOFJxinnrkQKBIsZ54wQyKb0RsCWdI8C+3Sr9jkf5nr17ZfeB2n/JCNlR6FMfXkrZxFftjeARJGFLcjcMzRg89T9pgLUpiaimGqnZ/CmPESE88gF8tENauJLk+sfE/VvYmSGigADdwe12uEjXycyHHgHDaqQqJuzL/afePlHbVZtFuABu83DuaRkv2sV0Skg1/Aw8saIPpYEXslGCDmZzDs0vNbHQDCQ010jsM+CS3fYOAVyXj0YZS95aiEIRVM8QIKBFGj7Txz+BAoLf8J2iSNDUiMmk13pwejaezq0cj5rrI/Tzl8rICbY0boMiykLYBwHiXyl7Bnh2fXV/Nnpw8UuoBV7vLC/FTbD/i/CgHuVanInExvaytCDLAPE6CEj5FsgmY8lJTkszY0MTns6OhoJ8yeWiL0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(396003)(136003)(346002)(186009)(1800799009)(451199024)(2616005)(5660300002)(4326008)(8676002)(8936002)(36756003)(4744005)(83380400001)(7416002)(44832011)(26005)(921005)(6666004)(38100700002)(82960400001)(66946007)(66476007)(66556008)(54906003)(316002)(110136005)(478600001)(31686004)(53546011)(41300700001)(6512007)(2906002)(6506007)(86362001)(31696002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0QyQWpGWkJTbTN0QStYbG9ybUtMMytkQTRaUGkvSWNGY2dKSG1ZOG10UktX?=
 =?utf-8?B?WjdrTXlMRWNjbytIdExvb1IrQW1lNnE5RjhSeU8veE5qMldHVk41ZFQvalFh?=
 =?utf-8?B?STNCL1pEUnBXOEt3VFlsbm1FNUVhVWJkN1VwWHBpOG01MkFXVGJ1Zm01QTdG?=
 =?utf-8?B?RzZma1pmSUx1eVcxM0RCelpKRVNRc3NKVklSRkRLM0NoZmdJdkRJVU1jQTBJ?=
 =?utf-8?B?Rmx5cE4wbEFBOEsySUU3aE5XQnJBZGI2YlliZ1J0bDVEeFo1czMzcmxmeS91?=
 =?utf-8?B?MXRUSytnTkJNNXVwVkdjU1MwSy9oWE5mY2VOSUM1cm1sbXdDTDVKUUt5VWdy?=
 =?utf-8?B?bkM2TTNNamhvVDc4M0ZVdDFqWDZBL1dOVlVTWW1HczJxdUZHUS94RlZvUzBa?=
 =?utf-8?B?Y1lEWjdTTFZUMEdkTVA5WlQvamtObzRHZ0Q1R3diUDhWeDRjcTBibWdWZWN5?=
 =?utf-8?B?RVFvbm5VMERFblJtRFIvN1dtUDBTN3U2OVcwTFZpV3JabjQzUzkxNFgwVmla?=
 =?utf-8?B?aDFCb3BXS2JnWERyRGdBaEJ4OFJ3VWx6c3ZmUTVKVWlsY2ZDeVQ2ZlJ6T0w5?=
 =?utf-8?B?S3Y5SDRBU3BER3IrU3BqUFFpOEd5ZStHcW9lYm1tNEhOTHU1c04zQkQ3blMz?=
 =?utf-8?B?Ylh1NS81R3NxVDZWY2s2QkhHa3RVdEJOSlFtanQrbVZMQXJsWWJ6WnRBVVNw?=
 =?utf-8?B?WHdNRDJUWGhlQm9lNWFvQ0VmbWRsMzVMVkhxVFM0UTBqWXRnUWllTFkyZlRC?=
 =?utf-8?B?MHVPcDg3Z3F6Q2xBaURqY243MHhPRndQQmZoTWFCZjVIVFF2Ry9LczhGazUv?=
 =?utf-8?B?U2lKZzF6ZVIxTjBTMnlSUjZ2dHB0NjVVR1lKM3p6Qm5ockFxWEtCZ2FJb1p0?=
 =?utf-8?B?bTZSU2Y4WEMzQkorZ2w5Qis0OHVYYnpkQW9ibks0MmFtS3FTaWRJZlRpYXl5?=
 =?utf-8?B?ZCtLd0h6U0RoeWx2Rk5SeUVBYVo5R2ZMUHZ1QTFKaVZoL2xUSTVhenVzKzdk?=
 =?utf-8?B?bDA0akRKeHdMVzBNdVpsMm1LM25PS2xMU3FwaXNBajFKcExBbHE3N0svTlZk?=
 =?utf-8?B?dUxvcFRRaXlDOW0wOHJFcDVhU09HRzJzL1Evd3AwQTNmZDBtNmRscDIxcjBk?=
 =?utf-8?B?TmNvcUt4K1hUZ0NSMmZLaXcrdGdYeENQU0ZBVkpxbXl0K21vN3oreWdCT3RT?=
 =?utf-8?B?ZjZzaEZ6M0VoNzRwWWhmNXFRM0p0WU1qU2E3aEd2WUtYL3lKQ2cvMVl6VlF0?=
 =?utf-8?B?UjlWUWJBci81dU15SG1HUDlNTnBwaTVaN1dLNE9ERGhvcDByRUc3RTJlZG42?=
 =?utf-8?B?bWlNRXhPRDJ2ejBkWlBwbnhBbEgzMnc1QTlxU2oxUDBjRmhLaWJ4YXZYOWRj?=
 =?utf-8?B?OUV4dll4WHhrNzR3akxvSFRvM0k2VE1EK1FodXJzZHBmVHdtN2tid3E2YWxq?=
 =?utf-8?B?VkQ4M1VMZlZkWHRoeldiT1BaV3FpWUowWVZkUDZ3V3gyL1RxeHFlRWRQTDlJ?=
 =?utf-8?B?VjVXMGVPV3N5NDM2Ky80Sk5GTG11aVprODRmc3VVeTNnTGJQZ01jMjl6N251?=
 =?utf-8?B?T0c2R042U0F2REdkcU9ueGJLN3NnUFNxY1Z4dFRpYnNXZHBwSlFzcHpxSk5p?=
 =?utf-8?B?ZFV3ZFBJS3pwUm1uVGZPQmViWXFJNlhPK1FaYkhrWHBCMVR1UTZJS3Boa21Y?=
 =?utf-8?B?eDNyUjYzSHFLMVFSN2k1a0o2N2o4WVR0dGwvbGx3ZUtrb2w2aDlscnRVM25o?=
 =?utf-8?B?K1o4amVlcmhzQVNVVGJhd2pvKzVNbGsvNlhxd0VRYkJNWDlxU2w5bHQ2dnJq?=
 =?utf-8?B?ck9KdWdFZk1OWUpLaEJWNThqMDRqU1pJcDNDOFBDYlRONW1WYTlDR3lkUGhh?=
 =?utf-8?B?VjFOOFpMWkZEWHlGTS9Mb3JxOTRxNGNmUDZJYlFiVVRSSFY0RHhiU0VsY2Uz?=
 =?utf-8?B?MWR0NHhRcXNlamtHang4cFZqVW53d1ljOTQydjRya1F2R0hLbDNuaFAzOThY?=
 =?utf-8?B?QlorVTN0Q0E3WTRBcUs3WjB3S3N1dS9ZRjlmTmF6MzVabmtwZEptN0s3VXB4?=
 =?utf-8?B?L1c1M01ScnYzUHhxMVBLSklRa2Rha0pFek9lSkNjMGRwK0JvOEdqQUEwWUhz?=
 =?utf-8?B?L1dNdjJzdDNwZ1pwaFg1QzJVdjVpUXZHRDhXVjUwT2xZMWI1eWFxckV4Y0xE?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edb17dc9-9612-4f6c-09cb-08dba46b3221
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2023 06:27:31.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0oHcCp7ABVFRCLv3G4/4wxTwsUlRC3YKv5OTaIzdBxv9JRsY6uZC8iDL/6p/znkFyZsW3+SCvXW6xpH8ljGig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/18/2023 5:50 PM, Xiaoyao Li wrote:
> From: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> When TD guest invokes getquote tdvmcall, QEMU will register a async qio
> task with default context when the qio channel is connected. However, as
> there is a blocking action (recvmsg()) in qio_channel_read() and it will
> block main thread and make TD guest have no response until the server
> returns.
> 
> Set the io channel non-blocking and register the socket fd with the main
> loop. Move the read operation into the callback. When the fd is readable,
> inovke the callback to handle the quote data.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 147 +++++++++++++++++++++++++++---------------
>  1 file changed, 96 insertions(+), 51 deletions(-)
> 

How about squashing this patch with the previous one? I think this patch
is somewhat a bug fix for it to resolve the thread blocking issue.
