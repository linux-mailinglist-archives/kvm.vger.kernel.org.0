Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5863E923
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 05:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLAE4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 23:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLAE4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 23:56:06 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDECB8EE73;
        Wed, 30 Nov 2022 20:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669870561; x=1701406561;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=qyLuTIjA6EViE3PVlI9BTM88dXJa1MOP7Js0HsbX8SM=;
  b=lb4scT1f8hv153hdmac2juUWSED343eZVaqphlg3FhNSAONu7T3YJNqN
   bUGGEPKxETdY1LRdcU6V4aygMValXn4tBlauc4vH9FRnKsXA6CHNZvNMG
   Z4vI7vlP9VI3HNValpC40PQFdUUIKK/GIqnLyQ96hYhgHIaKiDkYH9UoM
   HTc/8dG8lN/Uwut1WfADjv7lPqrAnsLvteIR4l/EL2bs2MhmgOwtSZIks
   R10FpEFJbXCLjIqi6WkbTeb8lY46gnkuZZuBQZ4rcKqvsbkvsqGuHTIQN
   ZPNRbjNtfdV9NGBdlFFcWTrzaOdABEn6EaQKFnfg648BN0T9Yk3jH051Z
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295278934"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295278934"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 20:56:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="675291586"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="675291586"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 30 Nov 2022 20:56:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 20:56:00 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 20:56:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 20:56:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 20:55:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fy5DrG3cEOaUGOymY7AYgWmklh2hwUBaONnfO5pVU1uRcFecVWzW7XtlI1ModB9mh6y7wFJ6TS46p1PBbkFlOVx0UXXkq5jIkn9jgNxatAr5e4nc166H64NP+ayoQR0pCyoTIAqSNjvcqGABDZNpFlH+IW9liPbMHLzOg6YMaWWC7NNr7vvlwlj8Q6ZEfiEuykeUp77q79aL43xgbJFCQMGp+LGuRoEG0/0k4WIn7NZLce5p2sNnvOVI3Xisvsmzu6zZVzTeZNBCPv81IAyjxqBu0VKF0XvNTE30K1t+WAmxsR+fuengN13JFs/PQ4//Y3RErf0jTJtE4k7AKR1iBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tKKNknreju3DuIw8rUmlDOJ4TJWGnYGcsbSOF3Q7iE=;
 b=h5pGPrpYYAfisS835x7VBdKMDj8iLQwmAmDWqX1AMRNgQN+ckyfyOzMeQWTfmqMA4RdqQqxH9GoDWAFiGGSeFub4zjQ08LwNwohMymW1VYequ6cKpZVaZpGDPuHl57GRJD45EZ7wv2epuKVOWGthrfx+EoSdXKOF59gAI6mErQeoZNK2eGOjRV8PYyPnA7rY2CpQvaCkh5tElvQbcEeZS8QLGAGnkA9roF7CGtIDIt6hWnnB7cnm9gry5KeNAhkHi4NRisM4QflSRyqlxUudIVCcacy4Z5bhHQRw25TEhPHLqiwQOXa8nKuwd5KjoI6iBYUU2RLSfMAQ9bnP7ncPrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR1101MB2214.namprd11.prod.outlook.com
 (2603:10b6:910:19::10) by BN9PR11MB5514.namprd11.prod.outlook.com
 (2603:10b6:408:103::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 04:55:50 +0000
Received: from CY4PR1101MB2214.namprd11.prod.outlook.com
 ([fe80::c152:47d9:6822:4e03]) by CY4PR1101MB2214.namprd11.prod.outlook.com
 ([fe80::c152:47d9:6822:4e03%12]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 04:55:49 +0000
Date:   Thu, 1 Dec 2022 12:55:47 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jon Kohler <jon@nutanix.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Message-ID: <Y4gz02jGZpNFbnAE@gao-cwp>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4b4UURccshroVV9@gao-cwp>
 <7248AC8C-FB3A-48D0-8DB2-F96CB6C15C17@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7248AC8C-FB3A-48D0-8DB2-F96CB6C15C17@nutanix.com>
X-ClientProxiedBy: SI2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:194::8) To CY4PR1101MB2214.namprd11.prod.outlook.com
 (2603:10b6:910:19::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2214:EE_|BN9PR11MB5514:EE_
X-MS-Office365-Filtering-Correlation-Id: 27191b25-484e-404c-9fac-08dad358501c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzME2UQVwNcbA7bbNdq8UfL5IXm2+jJxMK4KUJ1plN9+ULe7SQPcv4UqOu9o4rTg7JabZpafpzvtmq7NTdOaB1gAO3SxOQGegtSjag13R6kra2zLIejOjT3JXxmLrMjqQ1GMLCHI9Bf8iKXUALgt2jN1Gr5EINc5RRsDQGFA9svkJ9OFa5pK0ObCaLaZZMitAX6qYORfPhDj6gl/igeVkuLq7zDwtXPwuIv8LiZ2yVGStRkHoFV3EK7cz4ZPfGf8w4qynx+NdqVE5rse3H9sa6C/N2rayaL84mAlZv//fOc1t/bJ7kfEi+uqud+nt+4jhmymfvgPmEuC42X8eHa3ApoO7kl8yZevpd8wxAVZN5EQMkKhjLA/ch9wh4ZZj+32gFgx368z1On4lJON+9nB+1raWwcRQNi2wRbjFVWG3DO1bgQPDutOhjvSyYUTXarEnWlLoRvW+LnifuteR+DNm5F3p2nkZS1MxTxei2zY3U9yky1YW3aVHzfun1IIMJmF7UQicY6mIFEUurcedRi5AtlDqB0vH8lz+H9ogtF3YK8aSFnaiR3bXo7INI8Up1Rren24zErybCofob8ePIF2OLLPT04sDIsujrqAd36vCSEqQiAgBN+4nJJY3EkQeOcWop3KPhRFDG3TxGm8O1b+Ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(6512007)(6506007)(26005)(316002)(9686003)(186003)(296002)(54906003)(6916009)(6486002)(38100700002)(478600001)(82960400001)(86362001)(83380400001)(33716001)(66556008)(7416002)(44832011)(66476007)(4326008)(8676002)(66946007)(5660300002)(8936002)(66899015)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek1IWmtqcFJkek9FcWJ4SWJSQ0JSVGt1cDh5b0NheUs4UXZOSVpubWFiSlIr?=
 =?utf-8?B?eUFwMDhrd3JEdTZUcHdZT0RkN0JMR0NTOTFxVDgrZk5CU21rZndRMVhUY21Q?=
 =?utf-8?B?eFprQlJkRlBXQlg0cGFPdE5CZU1LMTFsY09sMTlYVmtKMUh2UXVPb0JjRURK?=
 =?utf-8?B?eWFFWHVZbDZoVktMWGxEaFRZY1o1UUE0KzNMbFdZYnh0K3QxRy9wQnplZzlu?=
 =?utf-8?B?VHlKTVduZG9JTnJvNmIwSVZma0dpVnQvd05ORFBJcitLUklWb1o2S2F0dnpz?=
 =?utf-8?B?eU83T1lMZVkvMlNrcnU5QTlaZ2Y0b2NlNTh3cDF6MTZDckxhMkMwamg0K3VP?=
 =?utf-8?B?MVRJcnNuRTRHenlqSWhScnhEdjFjSkYrK0o3SFpvbVdSMVBsajF4RFVEVkcy?=
 =?utf-8?B?S2cyUGxDZFV6a3hwdi9QOFVxaGpNaE9vZDdJcUkzNFZrL0ptN1pRamxXVUZO?=
 =?utf-8?B?MTdqUU5jWFpyRVBRQnNsWEFJRVhFcjhaWFExdzZ1SzJTMUI3dmRtWldsTW0x?=
 =?utf-8?B?Mll4ZEltV0RGZytvK2ZLV2hqNlFuTENOZlQ5U2NNT2VxcFVDZ29xYWpvN3I5?=
 =?utf-8?B?ZTlPM25CZ2hkNkVEdVN0V3ZFaEQwTkp3TURMMzNVWW5JOUljaHpQT1k0c2V3?=
 =?utf-8?B?TDJrTkF3eTh5cFBKTnN1Zlg0V1RETituVXVrUE1XdnE4SmZRdkNPQXNkbXpV?=
 =?utf-8?B?UUhzU0lMckVlUlZpeEIrZUJUUGJ1Q2wzSXc0dGIrbWVSODVUYzdEZm9jL1Ba?=
 =?utf-8?B?S2U4Q0ppNzg4S0tQSHhLY0lYMXpsRUJ5WFZaWERQWUNpK2gvY21oTFdwUW51?=
 =?utf-8?B?eVNkVlZDOFEybVM1SGRDNUpVdk1IY0lGekVTSXlZdGFJMzdtQTFtZ3lxVXdX?=
 =?utf-8?B?UkNmTjhVTlk1WlhaWmZoMTZFMHhGRXRkK293TWJ0U0xHd2t2RThReFhKcEww?=
 =?utf-8?B?ZE1YWVBIU2ZYdGVLTkVyeEtyTUEwdjZVcDFVbVV6TEZhVXBqa1FSTG5XWEoy?=
 =?utf-8?B?OXljWTdmYW54RnZzMFMrY0VHeFpuZFFwUVpncG1oU0tycWxPcnNST2w3Tkk3?=
 =?utf-8?B?aFpZTjRYdVllbFJyUUhpWUMyNUhOKzVpazBjLzd2T1hZUEZ0TGUxajBPRU0r?=
 =?utf-8?B?bXVSeEV0d0Z3a0F2c1UxbG5Sbkhub2tyck9sR3RuQ3ZHZjg3TlZJNTVGMm1U?=
 =?utf-8?B?cVlXSDc4d21sOWgyWjhVNzJYWUNVdk00cytYQ0VDbEpEdSt1WHFoU0s2cVJK?=
 =?utf-8?B?Q1lLcnU3MkkxeTI4YS8wSXNXbGNGc2xHaWUwc2dIQS9jWnI2bllJTkdQTURE?=
 =?utf-8?B?d3h6OTJCMUdJN3hvd3BmNGZjYks5QmtiMEFTVFVwWFcrb0R4YyswRk1ON1pa?=
 =?utf-8?B?cWxSaGJDRGJjSFVwNzAvSk8rYVNSYnNkTytoUnNuRHpubE5hN3NIRUZiMjJ3?=
 =?utf-8?B?Nk52UmFmdThUNGNDVlpNZERheGllM2NkZ1EwLzZwTnJWRXpiN2VObHFSdU5W?=
 =?utf-8?B?WGJ1Y3UrSUtrejVtbzl4d2YrU2tpYys2b1cwMHpYbUtGbWMyOUdVcWtKdk1r?=
 =?utf-8?B?cmJMdU9RVHkyQjVCVDM5eDNWWjNvMjY5UDhaQitwVTFOM1pqSXBQUHJxRDN5?=
 =?utf-8?B?ZnRBTHNJK2k5VWlFejJGYmdXaENUcytINjBrc1Rhd0cyWklYQmk5TGRydm9o?=
 =?utf-8?B?cGF3Z1pXWXg5RDh3cXQzcFg4NEpBZ3BNLzh2ckVRVWlnTnJONWd1QU5ueDlt?=
 =?utf-8?B?anRUVm05c01xc2orcHNCdHJOMVZPa0JXcXNramtrcmhHV2pMTnFpZm5OL2xG?=
 =?utf-8?B?ZlgyZ21WQVVtZCtkQ1A1T3R6algwdFV0blRpWit5RDRUdHFRSlNvM0hHWU9J?=
 =?utf-8?B?ZTNnOUlmU3BsTUxSOXd6RE9PT04ydVREQi9NdjhYVTBjdld1cnhyaCsvTzdz?=
 =?utf-8?B?NjE4cDFjZjl2RmlKWXRTdCtBR2tOcDdqZlhkVkxvSXljWG94aEc1TXg5Mm1O?=
 =?utf-8?B?N2g4RnhjWlpVeC9idnFzcTNwbDBYSWZWK1V1dnFKWnIwVExVd24vU0dkeUdE?=
 =?utf-8?B?bGxXajY4QytBK3R5aFY3UjFSSjgvVjc2Z3NsLzk0dC9tQXN3ODdvNWdzSVVI?=
 =?utf-8?Q?e7spruH5mXut/Oszzz+1Q4IU/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27191b25-484e-404c-9fac-08dad358501c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 04:55:49.3481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AU2SrkqzICFdwKSrI+u98KRNn6c/YAnGakRK40itz4jbpw2PPGG8NSXsD0DjkaGtKXVdTFlvmK+LqGjUpounbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5514
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 02:07:57PM +0000, Jon Kohler wrote:
>
>
>> On Nov 30, 2022, at 1:29 AM, Chao Gao <chao.gao@intel.com> wrote:
>> 
>
>Chao while I’ve got you here, I was inspired to tune up the software side here based
>on the VTD suppress notifications change we had been talking about. Any chance
>we could get the v4 of that? Seemed like it was almost done, yea? Would love to 

I didn't post a new version because there is no feedback on v3. But
considering there is a mistake in v3, I will fix it and post v4.

>get our hands on that to help accelerate the VTD path.
>
>
>> On Tue, Nov 29, 2022 at 01:22:25PM -0500, Jon Kohler wrote:
>>> @@ -7031,6 +7042,18 @@ void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>>> void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
>>> 					unsigned int flags)
>>> {
>>> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
>>> +
>>> +	/* Optimize IPI reduction by setting mode immediately after vmexit
>>> +	 * without a memmory barrier as this as not paired anywhere. vcpu->mode
>>> +	 * is will be set to OUTSIDE_GUEST_MODE in x86 common code with a memory
>>> +	 * barrier, after the host is done fully restoring various host states.
>>> +	 * Since the rdmsr and wrmsr below are expensive, this must be done
>>> +	 * first, so that the IPI suppression window covers the time dealing
>>> +	 * with fixing up SPEC_CTRL.
>>> +	 */
>>> +	vcpu->mode = EXITING_GUEST_MODE;
>> 
>> Does this break kvm_vcpu_kick()? IIUC, kvm_vcpu_kick() does nothing if
>> vcpu->mode is already EXITING_GUEST_MODE, expecting the vCPU will exit
>> guest mode. But ...
>
>IIRC that’d only be a problem for fast path exits that reenter guest (like TSC Deadline)
>everything else *will* eventually exit out to kernel mode to pickup whatever other
>requests may be pending. In this sense, this patch is actually even better for kick
>because we will send incrementally less spurious kicks.

Yes. I agree.

>
>Even then, for fast path reentry exits, a guest is likely to exit all the way out eventually
>for something else soon enough, so worst case something gets a wee bit more delayed
>than it should. Small price to pay for clawing back cycles on the IPI send side I think.

Thanks for above clarification. On second thoughts, for fastpath, there is a
call of kvm_vcpu_exit_request() before re-entry. This call guarantees that
vCPUs will exit guest mode if any request pending. So, this change actually
won't lead to a delay in handling pending events.
