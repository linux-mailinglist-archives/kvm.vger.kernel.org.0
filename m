Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2074AD9E
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjGGJKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjGGJKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 05:10:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CCA1FEE;
        Fri,  7 Jul 2023 02:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688721038; x=1720257038;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QFIKpGg9KfbIb8RZqAL6GRcfMF6LzCHFIiAGN7o8OH8=;
  b=N5OnpV6SO8YkBUFwm9vupTotffMezN9q2vcIth73m/yd1gMmmc61fCTH
   R5aeqe6+HqqqMehhosGVtBkO5ASnBo8UlJqiTxYQwTH75I8ErRY4T80gg
   +Gk/QkMs4DGMWhz+ELueqULcl7aWgDOiMuHphVQCfGvMdMY0ZJriLuHY4
   Ev4cMJicYraOatN8r7iztR/UbkiUOkfUyMqNT/cKGvu58nu9UL1za8C04
   dQqbNR1pvoQzygcdB4xAgV1ZDabjtMZKHTyU5xoLaSdVOhm7/wdJxMl3c
   zvQGUviCjnfzlif7ug0vnMLSjeonugpIRiDXpyTppHN9rU8El4HQaPvCh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="394610858"
X-IronPort-AV: E=Sophos;i="6.01,187,1684825200"; 
   d="scan'208";a="394610858"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2023 02:10:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10763"; a="755110551"
X-IronPort-AV: E=Sophos;i="6.01,187,1684825200"; 
   d="scan'208";a="755110551"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 07 Jul 2023 02:10:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 7 Jul 2023 02:10:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 7 Jul 2023 02:10:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 7 Jul 2023 02:10:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 7 Jul 2023 02:10:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzSk34PdrpDcbY1Iaernhe1/wadHTtyVzmMvtoLxXsnwVPZt6Op7mK/pGkBsl6qKX8ZL0qBsRN6LFK7HH3nePCzBXtyBDrdRgqbGxh7OHd+Zyw3lacxNcRqQdZHAWsEYdMjDRwRU7fdElNcxXKujG8r2nB0mXRVCmqqLt31dp9j54aFNCOjJHAZ+5jgEW2xYffEBLi0RfTcOo9qMK/ktGFG8EWTWu6+xvVy5LjETQ/iAuI3HsEVJz9Maw152QnkOd6r1dhzCKAp2+15+V0ZvB2PtSGhUXnEGZVhD9o68ZGdLktk5QmUNkhbZ11kKBSsv+TnqD/VBRRIwnc0xaYLxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zd72IUKHRqBbwHkRJNhV70rAgXrWfDrq0pGuW2ScoTM=;
 b=Ej75ryy+DLhifVuEE3Zh86okjjojgQFLAFYwdIvfZppm4Jpgzfvj1pcZb++rj8kqDz0wDeP4+ry5nfYBfMfkgccOQVWCDTkN3k6brOUblxd1ND8QoMLj/MGtk+Haxj7MErTP1JkkaukDcOy/3gS3Bp6WsHt7YDYaVstM5A1BO9z0zn+tGE51YwbBjq7u3lvaiZMVYkBa5uoTeiZnbjLFMIvnSzoYsE423XmARgj8SKGxpysDXJf0kPKqDayOpjZZWDaYjhPVHuM9Dsz3NtrDhNR1OnMLmZQjAjMZdyrmS809H5rb5k1MHsLbzz0t3Fpqf6tPgq0NjgsVJZJKkolzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV2PR11MB6071.namprd11.prod.outlook.com (2603:10b6:408:178::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Fri, 7 Jul
 2023 09:10:33 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6565.025; Fri, 7 Jul 2023
 09:10:33 +0000
Message-ID: <30b8d82b-ae2a-7022-2343-6cef9416510a@intel.com>
Date:   Fri, 7 Jul 2023 17:10:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Neiger, Gil" <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com>
 <ZJYwg3Lnq3nJZgQf@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJYwg3Lnq3nJZgQf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV2PR11MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: f149ce8c-135e-428e-885c-08db7eca049b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAAVP0JnazCJ5rBMVpCuRQmshPbftvX9s3ROQrhnMRVbr0RqSirANQPadxCmdjwluU4oevBB82Nwf16pxp7Sn57xGlxe9/UnMW7ay5wxfkk2Q/oackYWKS1Q8h0yuQR8vH882NQaBMefBquh2AXY4fw6V78CDrilmSaydXmVBwnuUu+CDFcJ2Y+yGGDqYojM57epjs+LwRWS9Su50CTS229vr0WlOYxCNx34FVkiioKPGB5xQeA68eUi5hYLFh3AxzJuodkik+WedpUpmkSNhPd1v742HYUTsdj4pDJAcgNHsG1cE6OK2Q1hccqMwperJSs7zYM4GAaJEXAxfpNt6gcHSwnkjim/LKb4sn/swl09Sg/W2KVYmvuED9BGYTfDxK0UDk4cq0QfAtP5lIzNO7LpdHKcnPAEUJSR8US6KMVv8OoR9oZ/GhdXmReYNqxqSeOxFoMed27af1h/ezKOfjLs03CoCL4w9vC2ICCzNbZopL4OB0/1S0TkKHopbJyhVr3aKCAR4pi9Nc1RsCncxxX0uDC9asmsNWKXaVby2F9LJDuJ39YWkgNSpPFYm6WwMKecXnlnyJVGAOoQZMTfTAzcQRnkR2fyAgJ7Bpi5P+gZPdOhdrgLFh/0N9Sk+XGG8QYbjVUDCzW/rtwh3JSyCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199021)(66476007)(6916009)(66946007)(316002)(66556008)(38100700002)(82960400001)(4326008)(6506007)(26005)(6512007)(186003)(6486002)(6666004)(478600001)(31696002)(54906003)(66899021)(31686004)(83380400001)(8936002)(2906002)(5660300002)(2616005)(86362001)(36756003)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDZaRktySHRMMW1kdTRuaFNrbWlzQ2RMaUhuYThGRThKZmhwOWNTa1RuUklX?=
 =?utf-8?B?d0hiQjRtazZ1VU9USjFsVVdNTnpNSC95UGVRaHh1dzlzeHpCaURJWGdBZkpa?=
 =?utf-8?B?V2c0QXE1TjVNSUF3bEtaclpuYlpNZStBd2xJOEZ0ckJrYmpvWHZUN0RmSEl2?=
 =?utf-8?B?RXpWcEFnK05rMkcvZnB2SW4rL2xXMEUrT1FEemQwMGs2anFkaGg5emJQT0tC?=
 =?utf-8?B?d0RJR0thUEc5SXRBRUduWUs5Mm9WdHlJMkxqK2NkMGQ4R2lHWFNISURTazJS?=
 =?utf-8?B?dHNwNWZGejNGVzNQR3hka2lpNWZ0Smg3MzN3dE1lTldqSjJPUWgvZENhWkUw?=
 =?utf-8?B?RE5PMUpmd1Rzb1ZOb2ZDZzRkVTE4d3ZBTUpUdWllS25hYXlid29JSHZCQVlO?=
 =?utf-8?B?eTBBSVN5UmhxODNieEtjZ3Flek13ZVdHVS9TRElEZk8rMmVaS3p0VWs0WDNX?=
 =?utf-8?B?K1Y2b0FGdGtxRUY1b0JUMjhIeWgwajdUYnlDQ1lxMHFrVjhaT0ljaWRrSUpa?=
 =?utf-8?B?NFdVdUlScVg1WnVMaFhuNmFGWUVId3YwN3ZVMXZJb3puUzhVdmk1NDVLaWNz?=
 =?utf-8?B?b1ZmOVdNSkdXRnBRK05mYzNtRkZ6UlZValBlZjNNeFd6VnVhQW9wR0hMYXpH?=
 =?utf-8?B?QmVUanVHUjd5dTRaUHhzYUdyTExiZ2NHeUpUZnprNllXMXRPWUJiOEFJbE9w?=
 =?utf-8?B?dWg1ZDIvVTNKRUNUaDVObjNCR2xQZ3pyVjRJRnE5b1k1N2ZqSTlKQnc2ZS95?=
 =?utf-8?B?WDdMUEtlZWZJa1ZPbDJkLzRYcHJad3Zocm1SU2FOcVB1eElkME5yY05RSEVH?=
 =?utf-8?B?WS9PTVlGK3IwQ2kzOXpvNnRDeG5NOGoyVXJRdXpXWVdUYVFTUnlqZUp6bTMr?=
 =?utf-8?B?enZyTHBqa3VyUVBkKzVtVjJUc3FDZGt2eXVGd1VGdkhZbzBKL1VuR3JIb01P?=
 =?utf-8?B?T0JLS2tyb3R6MDBYdDFXWEloa0tLUS9uTDFGTzBXTEJ4T1E2eFdvZ3RlMnNv?=
 =?utf-8?B?T095OE9LblgzaHFPLzljMkROL0F1U0ZMbUxMZ0pZWGE4Nm10aUowV1JLVnd0?=
 =?utf-8?B?U2FWdjRhY1ZMSnFobDk4UHR3NmZDd0hKSUZwNEpBQmttMThyQ2xIR1psWHIr?=
 =?utf-8?B?c1JmanB2RDM5RW9aVDFrTGtwRnJPSnBnK0s5UzExUHZ6dFVOS1FsMlZYeXZ0?=
 =?utf-8?B?dHd0T2ZsN0FJZXpVdEQ1L2x5R0pIb0xFWFRKbkJVRERKWEI1d0JGWnk4TXM1?=
 =?utf-8?B?TVA0TVBRZmpqR0h1eTFta3E5VTRkbW1YZE1SKzd1bDl5eGw5TjBEL2ErZnky?=
 =?utf-8?B?VHVSajdJeEFDbTdBQVJUdWo1MXBqVWxEOWVDdzNoTkhNRm1yWHpjVHJaY09l?=
 =?utf-8?B?VWtLQjBHNVVxT3M0SDRaSW1Cc3k2d2ZaTHUxWm9QZkJyWUMzZlJLazVndHp2?=
 =?utf-8?B?RzVTTmRDNHowWGlMVVlOWE9kTjRDbnMzTURZb3FJTzVoenhyeE51M1U5YkhY?=
 =?utf-8?B?TGdXQlJhS2JZZW9vdDZPSURJc2I0RlI5ZVR0UG9IM2FrZlRNTG9DQ3lWdGtH?=
 =?utf-8?B?aS9WdFlaVWZuMzBLVC9TLzVCWDloRzdsOUJEalRMSDAvZzlkVlZJYW1aUHRE?=
 =?utf-8?B?OExFclRGOXVEenJKNTUxWFpwcEFoSm5RUTBOV2NqSnloNE1Dd2phYW9DSVpF?=
 =?utf-8?B?dGZBN3YwVmpXWm1RS3QxOGdJT1N4NUtWYkRSYjNFVE9YZEsrei9QWnBuZ2Jh?=
 =?utf-8?B?bHg4Snl6bmNPQXdORmRsd2NmRjRVOWQ0cTcyQWlEeDRDekNoR3UzWEkzaFhR?=
 =?utf-8?B?NkRTamxWUDFoWXkyMFJGMEM3SU5NcDBSbnNlVHV2cGVxN29pQWNNUkYrK0JD?=
 =?utf-8?B?RDNJOWUzK3dsZTZFSk40bGFTb0FzOTB0dkx0T1duLyt1ZkRYL21vQ3BUWjk3?=
 =?utf-8?B?Ly9uNXBTNHhRbWlPU2VVZzE4czFpdUlBekNrVFFzWHlxOEhhelNFSlZxelJC?=
 =?utf-8?B?cXBYM0oybHRGTWRHZXJ6bTQ2NDcxMmpLK1Z5OGp3Wm42QzVkd1VDOUd3YkFO?=
 =?utf-8?B?NGxjaEdHc29lVFFZdnAvaDVzWkQzVk1tN0M0SzN6OFpDUHhyOUdyRnc5ajNh?=
 =?utf-8?B?MnJtTDhqVFoxOTdFc3NKbGRseVp0QURWdnhNN2F3NVh6R2tqbE02cGR5WXRT?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f149ce8c-135e-428e-885c-08db7eca049b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 09:10:33.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3X+DRwOjjVzttkeZ3AwQ83LcSeRqUD4GYNjXB6RxbjEyVPFW+N0FVqkWEIQdSUGDNyddFXT+41a8Lnn4qha/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6071
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> +	case MSR_IA32_PL3_SSP:
>> +		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
>> +			return 1;
>> +		if (is_noncanonical_address(data, vcpu))
>> +			return 1;
>> +		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
>> +			return 1;
>> +		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))
> Please #define reserved bits, ideally using the inverse of the valid masks.  And
> for SSP, it might be better to do IS_ALIGNED(data, 8) (or 4, pending my question
> about the SDM's wording).
>
> Side topic, what on earth does the SDM mean by this?!?
>
>    The linear address written must be aligned to 8 bytes and bits 2:0 must be 0
>    (hardware requires bits 1:0 to be 0).
>
> I know Intel retroactively changed the alignment requirements, but the above
> is nonsensical.  If ucode prevents writing bits 2:0, who cares what hardware
> requires?

Hi, Sean,

Regarding the alignment check, I got update from Gil:

==================================================

The WRMSR instruction to load IA32_PL[0-3]_SSP will #GP if the value to 
be loaded sets either bit 0 or bit 1.  It does not check bit 2.
IDT event delivery, when changing to rings 0-2 will load SSP from the 
MSR corresponding to the new ring.  These transitions check that bits 
2:0 of the new value are all zero and will generate a nested fault if 
any of those bits are set.  (Far CALL using a call gate also checks this 
if changing CPL.)

For a VMM that is emulating a WRMSR by a guest OS (because it was 
intercepting writes to that MSR), it suffices to perform the same checks 
as the CPU would (i.e., only bits 1:0):
•    If the VMM sees bits 1:0 clear, it can perform the write on the 
part of the guest OS.  If the guest OS later encounters a #GP during IDT 
event delivery (because bit 2 is set), it is its own fault.
•    If the VMM sets either bit 0 or bit 1 set, it should inject a #GP 
into the guest, as that is what the CPU would do in this case.

For an OS that is writing to the MSRs to set up shadow stacks, it should 
WRMSR the base addresses of those stacks.  Because of the token-based 
architecture used for supervisor shadow stacks (for rings 0-2), the base 
addresses of those stacks should be 8-byte aligned (clearing bits 2:0).  
Thus, the values that an OS writes to the corresponding MSRs should 
clear bits 2:0.

(Of course, most OS’s will use only the MSR for ring 0, as most OS’s do 
not use rings 1 and 2.)

In contrast, the IA32_PL3_SSP MSR holds the current SSP for user 
software.  When a user thread is created, I suppose it may reference the 
base of the user shadow stack.  For a 32-bit app, that needs to be 
4-byte aligned (bits 1:0 clear); for a 64-bit app, it may be necessary 
for it to be 8-byte aligned (bits 2:0) clear.

Once the user thread is executing, the CPU will load IA32_PL3_SSP with 
the user’s value of SSP on every exception and interrupt to ring 0.  The 
value at that time may be 4-byte or 8-byte aligned, depending on how the 
user thread is using the shadow stack.  On context switches, the OS 
should WRMSR whatever value was saved (by RDMSR) the last time there was 
a context switch away from the incoming thread.  The OS should not need 
to inspect or change this value.

===================================================

Based on his feedback, I think VMM needs to check bits 1:0 when write 
the SSP MSRs. Is it?

