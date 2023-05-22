Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3270B940
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 11:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjEVJlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 05:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjEVJlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 05:41:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B59B9;
        Mon, 22 May 2023 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684748503; x=1716284503;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/Q//oWEWD3dvoRgvNGi6Jtr89aI5EwVf0OmRfy6fXPc=;
  b=ICWcZM0jLAQvIMfTwDOtagnGnsDYljYbCqgEhlw6BnOrTUv7poFqYDtm
   9vDfyBEF+bB9UcIJmSSp1S2C/wG75sB6jecB+Ekr/v0PgHWJznABDPK+4
   veoJ3RIQEHxkGEoYh/PACskKmYANtdaOD/nXpbXOaL6t5FiultCpPtYM2
   eQBnjKSU/yfnpwX23vEdssdNfM74cXx8stQqvjHfe/IT5cGVgp+5224iE
   BMMHNFah/9Fua6hQZg2ygfqR62yZ4fk08Qeis9Rq+SPcK4uzbngLHzSL4
   sziZzpQ64Z0Te57xdiqgXiK/pQLGJOV8ik5YjOg7TAGvd9qZBekSJBAVP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="355221318"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="355221318"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 02:41:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="734202140"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="734202140"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 22 May 2023 02:41:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 02:41:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 02:41:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 02:41:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 02:41:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/62iAR2tECOJCOmQcJBDVg4wrK8ySkiUqC05uRTSH1MGyAagqA1aFow41wMRMdJvXh2vCknNgo38+dHydRkavqEVW4kfqJB+iKx7nHjLyrfwXWEOTc2XPQEt5VPJSqKE7b0usf1RMnLw3HYD7sJiRccwbSUjauQFtfvW3J6XKp6vtTwcgBis9L2pK6BQZ+n8a4zuDwoIN2j18Z6q3OpNyEh5MoNlOqUzME2q3k0w4lu9TenCyxEgBx9ZLjHvtgKH644e+tyjJBVPr4eaUF3dOhabAq8AWrs9GchfEuve0/5sNSR0vmB6B5YeX3k5DdHAY16EKxa2UiHTxbhbiCL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q//oWEWD3dvoRgvNGi6Jtr89aI5EwVf0OmRfy6fXPc=;
 b=HZCyY6X7VazhJx5Xo9ZMrBzjfNhmWDbNy4aKbG664mQWifk+ILrbHXiGMGTg9HAfH+UKTFW3Ry/RPvkcy7Qx22DeJkuxhENSnvTcrPh9HpNcWDgWwrPmQwcMtoxaXxlYkZutoMgkwG2XcBVnYXyCSxfIIsKmvk/xvOoDwF5IwrTUR1CEYbTC6MQJ840AezsRyozg59w2vuv7tLEG3S6ZHaTch7kgnv1cEdbUf2uO790cRqqRHAMmT/j2VJ1wWyuHbHOg1w4IFVnHTTdzhWJ+NonSZ5uPnpdLPm/PQgoulDlqRDJ3svEr9rQhwr5vwHk6izRM2MANrsVDUrHtCLQV/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by MN2PR11MB4520.namprd11.prod.outlook.com (2603:10b6:208:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 09:41:37 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b%4]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 09:41:37 +0000
Message-ID: <0498b338-45c6-41f2-6243-3eed3e2d46d3@intel.com>
Date:   Mon, 22 May 2023 17:41:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v2 09/11] KVM: VMX: Advertise
 MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>
CC:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-10-chao.gao@intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20230414062545.270178-10-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0176.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::32) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|MN2PR11MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc51a4e-7107-40e0-e4b2-08db5aa8bce0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRld9vFWxd5IYbX04mWJqkwImVGosCrc9VrS9yBm2T32HmQkfbGCElSUz38ofbz3xCKNfSGf32U7dmx23fHszorryT1Tj4Zew5f2FRsJCq1QapQm6JlfurT0m+j/hYLGxTJDWxK2xm2+c4oE/Kuoto0BcFr2RJl6b2YbeuFmQ7Bi0hGofHjcteX0K1a0Xl5eZuR3nN7U+80x9li05tJD14+RuSowjmlAUWI0psFDwJ8zt1ZnZWLqsnuTbgb0zziqxg7JkJmnQlkuXRqDldnyU/DJ7Q+mPEgiDHF5zb3aItD//vhqPdPPOmwnhGcqVcyOnf7xaq9O2RwfQWgngadpj7i/tQnUBE5+uPYdyTnMQrG7XAtBBVzUQMT5gj/lRxEA5JB73/Oe80paHkx7glUCrAn9QJH5aJixRzJB2q4T4tre389JUPsZvMxPiFM9kFBX4dfuuBzfBm5f71/UGjxurC9SsX1jkfj2Bphh0lB8bTJoG7MNhV21e3+CjR+2tgRyhp8qYFJbkbqfIIh5vqMed4IB8PPyDe3HgKLGmuliEcdNvyjD5J9aAOED7EuZcyCPVz5Hz2HJmPf8KObvgxhlQqdGPe+zwmaAF7KsB+vCv0fB6R01AzNip0/gFaPcb/t2JPfvwzgIg7JbjyagT0M+OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199021)(6512007)(6506007)(26005)(53546011)(6666004)(31686004)(6486002)(54906003)(41300700001)(66946007)(66556008)(66476007)(4326008)(478600001)(316002)(8936002)(8676002)(5660300002)(7416002)(31696002)(86362001)(4744005)(82960400001)(38100700002)(2906002)(36756003)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1hIYTY5WTlmZzdVTUNsQ3VPYnlGNlN2a0l4S2JQck11OWIrTzAycE5BcUY2?=
 =?utf-8?B?ZGRDdkZZd0cyMDY1eGxNNWlmL3NRWGZQN2lVSVd1bkVObmFEdjJpU09iQW82?=
 =?utf-8?B?bUkxcGRmb2RCOVF3OXQxc3k4QkdPU1FmRmp1VUo3WGNKU1NmQmRFZWNQOWVn?=
 =?utf-8?B?aDcrY1NVZkhibUt0UU9hSHllREV6TU5VVEIxc1Z3bzlqK0l0bU9kOFFVZ1d1?=
 =?utf-8?B?dENpamZJY3kxeU1mQnRMQ0hLS3I2MG9XNHp1YTFTcXRGRVY3TmZlTHVRd0Er?=
 =?utf-8?B?Q1d6ckdQTk5ZQWVlWGdoaXl2Q3BMT3V5TXVZNHVKc3EyOHVCcG5oblVvMFA2?=
 =?utf-8?B?Tm5BdktaK2F4YTFWUkVXcDczYllLTThxcmxBendQejNYNkVvR1NCeWxIb21i?=
 =?utf-8?B?US9jOFFvZDJqMjFWcCtyT3g3Z3VIREZOdGVlaUgxNVJyZytBZDArTWJpS2t5?=
 =?utf-8?B?cmtSMkgyTVNYU1dmTUFzU1plb0I4SkEvNWd5MFZCTkpqckhQSmI1NERwcDZ6?=
 =?utf-8?B?eDFWRVMwOG5XTGw5VnVKZ1dSVjBwbVd4WE1rdWx6WVg4V1NaN05Td0pXWTYy?=
 =?utf-8?B?OEhwUHoxZnF4R0l3Wjdwd3hZbFhtODNTdCtaU0pYeGlidUhRQlAzRk0rQnc4?=
 =?utf-8?B?MXdTdCtoa3AvSnlSUEV5akRVeGV1aE96VVdBMVo2YzJzd3ZEaDBxYS9tTEJU?=
 =?utf-8?B?SkRiOXB0UHVEZS9iVzVjOGh2R1UvZnhVY2g0bFJ4N0lOZXZoMjh0S0xXaUNw?=
 =?utf-8?B?SFhLcFZsVHVDZHVLeWpkNEoreTdNUlVwTmI5Y2wyazBzZEhkYmdrMGpwekhV?=
 =?utf-8?B?dk1XQkxYaFpMamhQY2p0dDg2VHJhekpDK3dwQVpvM3J5YnJvMGk2aTE4diti?=
 =?utf-8?B?V3RNWTFSUjluakYrWHZKQ245WTczbTVROUZBMHJQMEh0Y0l5bHBjcWFuSUFu?=
 =?utf-8?B?bTVXSHNRSUZSUmk4Q0gyQ3JMYXo5YlkrZ2ZFc1VwZ0lCaW1tRFZZQmJKbVN6?=
 =?utf-8?B?Zng1S2NEdXZsdlZRdjF5TWF5Z3NaaSs0MXFmam44VS92bFA0ZDVXQ1YxSXVu?=
 =?utf-8?B?QVR1Qk9tYy9hK1p1NU9ZZHJZNmJ6ZUYwTGJaRVMzSlBjTEdyZXpEaEFMbWsr?=
 =?utf-8?B?cm1XSHlMbmxWcWk1N29TTDlaTk44WWx3NDFRZG0yLzY3UFVLWjcxc1VrSnRh?=
 =?utf-8?B?anVEUU5md3QxOE01QWI3SjJQTDdVUGNKQzR2M25NckRuMHlPU0x0WWhlYzYw?=
 =?utf-8?B?cm8wZFJRdzlSL3pYQ2ZuMmd1UEFlRWFCeHZwelE4eVpTdlQxbVB4R2hiRElB?=
 =?utf-8?B?TVFLSG9welNiVVFrbXFrNHNQQSt0ZE1IUjdrOXlRNHRzUldkYStEd1dnRjhX?=
 =?utf-8?B?MldnQ2p4cnBnaHZnaFBlQ1c1dGdnaVljUzRKZW9MSndUSHkrc0Q4aCttRS9F?=
 =?utf-8?B?bHhhZkdxMUNpM1hUMnd1ekNWcHpPVjN4VDFWWktYSGRmbkJqeVBiV24raWd5?=
 =?utf-8?B?eUpzaTlhL3NJNEV2Qm5VZ01KWlpzc0UxOGEwVnU2ZG1GNlpRZklKalZjODFi?=
 =?utf-8?B?UzZkcU5jazU4dFJmaDA1eG9qZ1BYc1dMa3NmSHBMazd3ekorVm5VWk9DRXd2?=
 =?utf-8?B?VnVlKzRFTHJneU5KWElKNDJiOVRhelUzVmZoY2l3VWdZQ2JXOUlaQXN6d0kx?=
 =?utf-8?B?WUducFlud2pDeEhlU1ZjbCtqQW90aTRMekNvTld3MERRTTVCN2NSOFl3YVVv?=
 =?utf-8?B?RU16bFpkL2pnSXhnYTM3R0c3c0tjbzFrU2pZd0dBcG55L3BjQUpvT1FramVr?=
 =?utf-8?B?aGdUamxYYVpNa1NIeVpIaHZSS2k5Wks3SDEyUmhxT3M5QU5SQkUyN1AwSUds?=
 =?utf-8?B?Umpac0w0THlOYlNkdlUyMGgzYWhuK2ZxRU1rUU5YZmVCYytxRVgwL2c2Tk1Z?=
 =?utf-8?B?Q1hBdzJ5K2xnTWFlVUtHZG45SHFuQVF6UzF0Mm8wQUlVdDhVdUZ4SGl6NWo0?=
 =?utf-8?B?R09DejNpZ3pRS0lQVDkvVXZvc0ZuQjNXcE9CTy9GL0o1Z09tNmRGaFRuczVN?=
 =?utf-8?B?NzJEVkxmcWYxNTBHVm5jS1ZFY0wySWdRYU9kOXFhcllkaVU3WjdyQk1OSEVT?=
 =?utf-8?Q?BckcCxqDgJGMY+GIXp46JqUUd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc51a4e-7107-40e0-e4b2-08db5aa8bce0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 09:41:37.6843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6gEQxfy8ZtMWY9EErFOfKGhu/bEBC9rGeUeh7Eo2DnUv/ako24yuFXoyNEAI7wsDIRirEt4YGZgZcNno+U1rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4520
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Zhang Chen <chen.zhang@intel.com>
>
> Allow guest to query if the underying VMM understands BHB-clearing
> sequence and report the statue of BHB-clearing sequence in suprevisor
s/statue/status
> mode i.e. CPL < 3 via MSR_VIRTUAL_MITIGATION_ENUM/CTRL.
>
> Enable BHI_DIS_S for guest if guest is using BHI-clearing sequence and
> the sequence isn't effective on the processor.
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
Thanks,
Jingqi
