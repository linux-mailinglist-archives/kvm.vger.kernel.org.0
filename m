Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3657646CC
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 08:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjG0GYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 02:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjG0GYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 02:24:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D69C1;
        Wed, 26 Jul 2023 23:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690439049; x=1721975049;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J6zKGGmMyTwOXbeuX7h5Bu1db3e4R2xVDtZ/aYkMLBo=;
  b=QP0lFU1H+5AsqR39J2Escw9TWl4Swtz0eu2YSKoyiddMa58Q6wKw/vAH
   rbzSPsbn4k0/IqIHbooNcpgNWx+0ycFhGlHT2Z8mDovxuga/W/SWzwHho
   5TWUIuIMjiI5cu9Z/ETs8a/QZXnh30oPBcOBiYH0/fkZDtMze4wUCC+Zo
   bpoVYCBXFAtXSG5onbhcQR1zyQSdSwzPf3er/6qCoXKPMmlCJf9J93uvi
   H+YFYr2rgiCsoOMAHm9VIvVSqO8X9/pP3LziJXTXI3BTSQ8HUBg4rLxQr
   DndWfWQ4mTx+41aozY01W/7gv9iAKCU4G1TAf08VREgyDOs9RdkPEgkbF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="353119128"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="353119128"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 23:24:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="816989344"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="816989344"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jul 2023 23:24:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:24:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 23:24:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 23:24:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 23:24:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StLYsl/U/92NhqlO7PNkTwPMYDNqPxw8dRl+Od25M8FuH8gJsAf+qmAUzbU8P5IOnRkhP6hG+yqYOGiKUEuf/+E2vuXhqURzWlAckhPtxvktwHGqDWz4Ta3jPA+EPnFPZ55jpmMmcr0ewjo1bIvJrizNhsFsz5Z8xq04TwsbqjAhZl/E4aXl8Avo9pOZuetSuSDolwOrsJY0k1LT+YBldzcRqPxeVvA3UAkWZJrM2zJ7+dxxOY9CAqSjD8NON/QC+SzpfTmh3nKGkSTPiW1uyGGyCYtFagL73l560FPBSWnQ1U7FAHfgTTdkOyKP01+aXoqAwZmdbct0tbybwRUtAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcllsWqG6XEQK1DC18mw6Tdci19LRA1fz8B2naPkg9Y=;
 b=kATLKOwbtpBkrSYsmSuvTbfRu+vAQ2VqKlbT8R8iLN9ij7zphtWPf2Oxze7I3p/A8lT5kq+8LGX6+pXacVulE3znfrX62g69EZL52Ozk0TYLavV1XL+RfLN/m0brYP5910mPNTZRAhdyjgW7iteOA6fDTYGZ6h7ud09nNZ4lOPlLeN0r9sCu1nbIKh62lDbENorlV4jeG2FYtM+d63uR3zjTccjWFsbvMmXjfvUAq3RDN1NeqGvxlpyy2oio2QdpgtBRJGBmkhrgK3mdlc8OUZsbYC/4jj9Y+WEv/iRQzjdcmT9T9UNqN0V5Ksc11o9mNrScUKxrdgvCLFe3r8jTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV8PR11MB8510.namprd11.prod.outlook.com (2603:10b6:408:1e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 06:24:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::e19b:4538:227d:3d37%6]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 06:24:02 +0000
Message-ID: <74a728c0-6f63-260b-de9d-348fb6efb41b@intel.com>
Date:   Thu, 27 Jul 2023 14:23:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 16/20] KVM:x86: Optimize CET supervisor SSP save/reload
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-17-weijiang.yang@intel.com>
 <ZMHkFOwsNaAm3WWu@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMHkFOwsNaAm3WWu@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0167.apcprd04.prod.outlook.com (2603:1096:4::29)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV8PR11MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: b0ff498a-6916-4b93-4657-08db8e6a1211
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzQ3XA5FrzK3YkMDG5EovY3ngGLu+yrw0cfwrKZGU9jZoBphXzZml4gT6U3D9r6QxHzGy0lxTaz182evccYoM6zZfq9EXxdGr+wSYXGEBdpfg8cEcSqFPXj+MgxKVljG6zk6bVCglg1w50QXif9DQAmige6Jf5jHvh3BUVYxLUdrZz1UCf198uI3ePdON/TbkbW4E0wgOjGK3H6pUJ9NqkR+awiXT6L3FUl5/OsJpzQioCkC7F7prkVF7eFyRbUC36661pDO2NERIpXRqYIXHbmJ8y8d6kL2qSDAdgqJAWSbdLoU9gnvEMEPnhv+a7segVPr5Ti/Dh+ovXDTry8JOtl4OfcQY7hmSD7jiK94xTQldct8be1FDtJWJMcd7AIvcRP3Qa8bEhHWZc7fYWebPYzJxJ9bkCOsrcRgrotUiSf+BHPFZ6iGdqO1iVC5iyZqbk+LByEXfi9C8nQ4LUd+TAL8ldu8dfJo0zfMOtlEuoPRdlYq2XvBq9Dl25B9SZdhKum3KBFprcFAKGUAmJmYfAzXnKzP4uU7wqQitxJzaQxPQdsDbFN7qhw6bZp9fX7uKMBwQKSmffv3OB6ikmaIvQu8WCYp3fBv82+6vQz+77FMh5nyd3MekrsIHxLHGrJG32M+LLnDBmhEdI+o3wrIMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199021)(6512007)(6666004)(6486002)(186003)(36756003)(38100700002)(86362001)(31696002)(2616005)(82960400001)(6506007)(53546011)(26005)(6636002)(66476007)(4326008)(66946007)(66556008)(2906002)(316002)(5660300002)(41300700001)(8936002)(6862004)(31686004)(37006003)(478600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVZjd2Q1UzhxY2Z1amFWV3BzTmRiUmJITWd6YUNOVWE4bzNPOUtiS0JyMmVm?=
 =?utf-8?B?cVFKaStmNnQ5UHpYZ3BkTEM5S2Rua1RNZHdlNW1mbjQ2RGw4cEw4VjVIaW1O?=
 =?utf-8?B?eWpMVGxBZENaQURGQTI4MXJmcjM5N3dmQVRnQ3lwVzVqTmtTQnpSOFg3TThK?=
 =?utf-8?B?czJNdTJCSTd4aERpWFNqSnNIanBGTjc2Tjdjb3J5ODlDalE5UlpYL3R0VUlp?=
 =?utf-8?B?L0pLL2lHcWZyMkFrN1FjYmpZSGZ6VHl2VTJ4dkhNVXZqVlFtRTRTVlpFeEtI?=
 =?utf-8?B?U0ZQRks2SGdqRjE3d1l0MXR1dTY5NHhxRDFmbWRydk0rYmlrUFA2RnlhRy9P?=
 =?utf-8?B?b2lkZFVvUGxGdzdPbG10TVNEcFFIc0hQbUFmNWFyaVN2bWVYZ095MzhXN3RL?=
 =?utf-8?B?ckZPS203VElDL0RsREZVNmE2YXphb1dtN0lEeXg1UmdkYlNONDdIdDJkb1ow?=
 =?utf-8?B?V01oZVZyNk9DSHI5Tkp6bXh0MjNpbmIrTFN5UmlYV0hldlVrRmw1ZWFVVDB5?=
 =?utf-8?B?Z2dkTzRlbVFoZkhNSUd2bE5JMGpNTXZSVmFmdm5zT2dzVlM1TW1yS1hqV0RV?=
 =?utf-8?B?MlFrbjBFeUQrdmhhYzFabXpXV0N4Mk5rM2JEMjFZcUlYaFRvYXNIMTlad3V2?=
 =?utf-8?B?OERSTStPUFNiT01pZTM4R3pFZlJOcU9TQU82VTk1NmFNRGhyTzZaRUYreDVw?=
 =?utf-8?B?MkdQa3VlTFkweHduUDk0NVlzVDMyNVd5cmRsT2RjYW8zUjFyV2tYODZHY2t1?=
 =?utf-8?B?WU1HVi9GdmIrL1N4Qld2bmdQTjZBQm9EM0RjeWp5c1Z1eGpZUW9ueDRlUFY0?=
 =?utf-8?B?SXJDY1NKWmZZeFRKVTIzNFpyeUZBRVVVU0wrWTVLd25zNWZ2aXhRL2ZZbFla?=
 =?utf-8?B?c0g1R1F5RWNEc0FRcGNaMTZuRFhQUjJPbjFkc2lNNm5uNWR3SVlPRmRDOVAw?=
 =?utf-8?B?dWlpV2pmK2duZmx5NUhkaWZZV3BBREZ5V3NBUm5oQ2tRbTdFcFc2bU1LTjRF?=
 =?utf-8?B?NUJ1M3JzK0VlTW1aOGJOWTVIZFFPdHczWDQ4SkE0SlVWUGJKUmtsV1U3NlJN?=
 =?utf-8?B?WVRMWExuek9KbEkwRG1CWFZralcxWWRDL3FMOVpJTE0zV1VnL0dZTUhIeklM?=
 =?utf-8?B?bjIzMEE5MFNXMWNITm85bEZuWlpQOE1mOXl2WTEzZitWRXZQQWNZTmQ0K1Z6?=
 =?utf-8?B?ZkFkckE4QzU0cXdaSXgyRjRtVWVxMGZmdXVLZXVuUzlrWm55YzVkQ2xnVFZo?=
 =?utf-8?B?K3R0VmdSUGxXaXVlNHk4YThZeUI3d2piZGdCOTFRUFYzd1JETGZyS2Yvd25D?=
 =?utf-8?B?WnE4cm1TekpOdzhSaG1BblM5aHpUNUFibFA3RjlrV2I4ZkVheitzdVVjRkpS?=
 =?utf-8?B?aHNmVlkyRWdwZlVhZ0duSWFCbWpzQjc4V0NZSnM2VWhycWo4MnoxZWIrbCtY?=
 =?utf-8?B?Z1k0VG85Y2hBNlZSeDY4anM1dTQycjBmUlhxSEpicU1EME9UWElEK01XWE5S?=
 =?utf-8?B?UTRFUC9FamZTVGMxbEpwS0NlNklQakg0MXg0cXljRHB1U2FmMVdXY2llTmJ4?=
 =?utf-8?B?YzYzRUV0K0R6SllSK2dkcW1NWURKWmMvdHJaOXNTQ3hISU9hVC9zSGR2bysw?=
 =?utf-8?B?Q1B4UlRGaUtPUUNMYlBxbHJkMFJoVldiRlBSSlZrV1Y0SGo2d2tGQnczenpT?=
 =?utf-8?B?RmNhdTVacEFRa3VoQ3JRZVJWayt1WGI2SVIzcnF2V09iRkNOL3pSaHdkazIz?=
 =?utf-8?B?ekt1SzMxYXIrRHcrR1NrQXI3T3dYQjdzclg3ZlJ3WlNxUzRuTHJ4L2pROXg5?=
 =?utf-8?B?ai9WWldBdzBPdzh1Wk5xckJmWHh6Wk12dG9rSEhWOWZVK3JrRWJWUndJR2w1?=
 =?utf-8?B?bFkrQkhhM3VEN0dMSGNVTnFFZmUvTGxUdTlJeVdJRGJWak9IclhHaXRvanJu?=
 =?utf-8?B?OVd1UlFlRWdJNkMyZ25TVXduc2tTNHluRWdTaEk1S3R1aHBMNVQ3UHoxMFBq?=
 =?utf-8?B?T3l3QnJUbE41cERtWWY3QzJUSGJIYVpiZi96SC93TWM4N1ZqVUhtTkw0OFYx?=
 =?utf-8?B?cDhCMnFOSHpOOEZlbVNtdFQxZ3hEWlRNSlQzWUtZclp6ZmoydlZMT1hqMmRP?=
 =?utf-8?B?OVJjYXFUWkxuNUxPQndGTytzSlN2VGtGN2h4L1dQcDF1Ri9ud3piU3ZpMnBy?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ff498a-6916-4b93-4657-08db8e6a1211
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 06:24:02.6776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVRUD/xnr/2KS4XEBAqfjaqokOHi2PtVSW+V43WV5dd6nhoPzD6DZNCF4BAWpHfOzXzUjVDwnq0x7P+BeaPz5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8510
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2023 11:27 AM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 11:03:48PM -0400, Yang Weijiang wrote:
>> /*
>>   * Writes msr value into the appropriate "register".
>>   * Returns 0 on success, non-0 otherwise.
>> @@ -2427,7 +2439,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> #define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
>> #define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
>> 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
>> -		return kvm_set_msr_common(vcpu, msr_info);
>> +		if (kvm_set_msr_common(vcpu, msr_info))
>> +			return 1;
>> +		/*
>> +		 * Write to the base SSP MSRs should happen ahead of toggling
>> +		 * of IA32_S_CET.SH_STK_EN bit.
> Is this a requirement from SDM? And how is this related to the change below?

No, after a second thought, the usage of the supervisor SSPs doesn't 
necessary mean

supervisor SHSTK is being enabled, e.g., used as some HW registers. I'll 
remove it.

>
> Note that PLx_SSP MSRs are linear addresses of shadow stacks for different CPLs.
> I may think using the page at 0 (assuming 0 is the reset value of PLx SSP) is
> allowed in architecture although probably no kernel will do so.
>
> I don't understand why this comment is needed. I suggest dropping it.

will drop it, thanks!

>
>> +		 */
>> +		if (msr_index != MSR_IA32_PL3_SSP && data) {
>> +			vmx_disable_write_intercept_sss_msr(vcpu);
>> +			wrmsrl(msr_index, data);
>> +		}
