Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0206960C95A
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiJYKFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 06:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiJYKE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 06:04:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D9F15ECDC;
        Tue, 25 Oct 2022 02:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666691956; x=1698227956;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5s3y7pIRNlJ2QMP00Nh2VqvPAD4lTvdFZIuRa3vLKYg=;
  b=ID2hv6woEyqNNXA3Nl+T8dcZRDIIrJjuUo1Ew1RrhCmfQcadbWNawkB4
   0w8rlJYm731CiGud9HD1BaEJnxpvzbEDti8FAe/z+G49suM/7SOUzntzA
   HydZooQkw1abq1dufBxt/D/5C77osV89Po96729V2rg9HkNMURD9DjXBl
   79z9fZlclauo7/OmOBk/xNhNyHMvBVwvL0z1DuatJyQUHzhhNRC0hRc6b
   YGIRvrIRx2GsxFusSYYpGoRQVflTfmdmT6UkfduQKAUyGmC0ZjWTIvJFf
   wtEBfVo53MZ0l7OjKWGc9eal+mXgMww4gr4ufyOb+duNMM2yWuZ0X149v
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="295039568"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="295039568"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 02:59:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="634034688"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="634034688"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 25 Oct 2022 02:59:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 02:59:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 02:59:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 02:59:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 02:59:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbb63LxYVvmWx2G3d6jl4ffeRvPfDuJQslNdOOF/w9LNP+5D+WcjhU2/wRJ/CaMSBUepNOlr55/8HKFAzInboxKaxiLy0RkPLYQvXHsXOK8dfMVQ3sGUHlZp0QjoNIDDMfaEFWR4x2HOAbd0U7JdbkfRxXPQInjdtwsfZVfOf7GNjgO89Dqpq+3XgQYjl44KpzDRLVEubG1DnfZOrsm5VCn9/pf+LcBqnLuSVJs++SY0VcZRx0fiWl1ZVFJvOXAnlYX8j6EP3OVjQNtwGfdkp3+M1h3gw8oYRlhWOYDZpZwGChkO2n75m87g9RhRGzBMfbu4a/K7Av00LAAH7x3sAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yT3cy5akhMjzsyFqmAPFuV78Wlje7AwyYsnSmrz1c3s=;
 b=AHg9Xav7HQNWxEKyVqm9g8/ZDND0SoTrAyMBG327WQU7A7Kdl62uVgLuvCPosOar1jl2eY7wHW552OzGH/p94iJ6YV9n6N5CY32TPj/FUQS7oebLFBErngqXqaeXdWjMI+enNgDTWMjJaypuHPAXXaWDxfi4mvG4Bu1iHx5RuxldtyWkah/wo+R+FbT5QuFtQseRUObZ94YmmzEngOY5sPEuftBJzviajW8lywN5U3kSB5hFgrOVJL7eTRw6e/G+tkBaB1GloyGGNzNDzLhMwiOkNTfx/idlpWupfoehqQ3QlEMPTey9BLbTtMFDVpJ9Wsso0P0JjYVln9lBEc1d/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 09:59:11 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::a397:a46c:3d1b:c35d]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::a397:a46c:3d1b:c35d%7]) with mapi id 15.20.5723.033; Tue, 25 Oct 2022
 09:59:11 +0000
Message-ID: <3d7389cf-8cea-624b-2fdd-f3fadfa65ba2@intel.com>
Date:   Tue, 25 Oct 2022 17:59:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH] KVM: x86: Exempt pending triple fault from event
 injection sanity check
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220930230008.1636044-1-seanjc@google.com>
From:   Yujie Liu <yujie.liu@intel.com>
In-Reply-To: <20220930230008.1636044-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0027.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::7) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|PH0PR11MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: cb950525-823a-4917-3f99-08dab66f90d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vrDBncnjYee7SXFA4jlzVj0YetAXKRLGi6PvuYNB46Xs55Ikd04r60XG+rts8JHbXu381Sjs9xSEitQUal3OH/TOLy9A0BEzM5HoZvAiooGSuza4lmEAJNtdBEgWt4BvrIhm5wIvmXl1qafTETzJ4wuf1/Qf6J3kqj7DjOcWVxbGVjk43bKx6zm06l5epG6NXm63x0eNTfIn2u3imJu6/sc111LanilsG9JK/zUnPDZ4prj5DrQd7OjugqaLFiiFqzLpxA+PDxFrlRZGfznoBbIilAKtyJTLGWMJVHKhXiD8vu8ZhUOfKdYfP7y/QxrnZyaPo7TOvziUJvvQwrth0wZXz3p2+yjYwB5sGiIHDTj7TXN6tRLP+lS7/5WYPX0AXtbozkPCA2cL4tlJkMbQOARw/jSDAdHKo6SWREeOz/pTfscu69BbGTICLvboEymAYNXtKV60q2UHBBOR9Woa+KkjTvY3B5dOJBJBps8xQCkXQV6stL6LYTmDZFmt7JRN8+Edn/blhOKoFCtj0gDXKynuoqr9Z8baReJwecVCkSwUcv7M6r2WJ+jFGpC/Gs0CuWAKRPDGpcEEipkrXcrU6hRq4/TuG587oo9nOZgJIq2zB5Bw2EwUsZgFNb8fxRdcnkTW4PWbFO8GIfiqtDLAHJ/8MjRSxYa0P9Yj4pOC/9hNu9Ne1fP5zJpTtRHACk1W6D/mu3/6JrMKOXNkEPyJaJlcN6NSL1Hp3XdyIpwDtAA2wfxONvsqRNczcLTeyr0XyAtzYwXbI0i1SIidQ7UWNdVccNDE3hIiaghepdoo63RedDDc25EuUAEUJqg+OxkDQmucrfbE45li2K/5zN1obQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(36756003)(31686004)(66899015)(38100700002)(8936002)(5660300002)(2906002)(26005)(83380400001)(44832011)(86362001)(31696002)(82960400001)(186003)(478600001)(110136005)(53546011)(6512007)(2616005)(316002)(6486002)(966005)(66946007)(8676002)(41300700001)(66476007)(66556008)(4326008)(6666004)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHpvWU9HNnpaai84MUZqd0RWakJWWjNMOHdONllRcVU0eE1BeUF5QUo4Zlkz?=
 =?utf-8?B?TkhvWDc3ei9NNlBJUUFBVitBekRPc0p0QTNUeXI0QXcxb1QwbnZGL0gxOXVJ?=
 =?utf-8?B?RjhreXdpdzE5dGtwcGlXZ1pKRC9wa2JUanREeXQwbnFjMHV0WE5SRjJRcGdF?=
 =?utf-8?B?bU9TelgyUjl6c1FaVnU1dldGU3JWclR0alpDQ3R0TWhnRHpickpWSnArUjVa?=
 =?utf-8?B?OVJmdmlNSHRmNmZ2em1lMWdjWTBOcTdhbzZPcUFlWndWU0RObHBpd3kzakx0?=
 =?utf-8?B?VHYrOE5zZExFVFQrbStlSmw4bWJDczdVYVEvQkdCZldmSzhGUlVEUVAyaWhY?=
 =?utf-8?B?WjJFQlUvZ0NVZ21Fa2ZDWXlZQjZnMFlEMmZuRlMrZFlSVE9TVlE4TzJJeVFE?=
 =?utf-8?B?a2JuNnJQK0M0SmhQSGJDaVJhdU1xbUQ3ajZFK1BJL3dmZXA0UU9JVkUzdEFJ?=
 =?utf-8?B?QzJHQnNFbWhFZm15Y09ld0xyMStXQnhKZzNpZGRudXVEWldaOTdlMENUeVQ5?=
 =?utf-8?B?eUE4V1lJREpJNE1lZExwbXNKQS82dE41ZWRsS2ZWUEZqZERSeFFJeGZjTDJy?=
 =?utf-8?B?N3hDZmFQeGxDbFR3YWFnK2cvdmZzd1B6cVhkUmNwTUpKSzBjQkpOTVlpQ3Vp?=
 =?utf-8?B?MzVickJYUmQzdDVqY2ZyQzBpU1hoYjYwSzMrV0x0QmJtZ3V3RER0bjlqN0h2?=
 =?utf-8?B?QnhuMVg2a1ZFYzVWWWtscWRlTWNRdXZ2RW9GMTBsVDQzQi9VY1VSaEhib3NF?=
 =?utf-8?B?Y0pSRmxkV1ZPc01rRHpWdVIxT21FdUwvaFpNMmx2NTBKbVQrOEVCZEZlQ29E?=
 =?utf-8?B?dm5HbElJOW9UcFdFa0F5ZElnVDdXTmRMd0Y1ZjhIYXYxRjQyQW12aG43eEpZ?=
 =?utf-8?B?NkZ2MEJLL215dXpqNU9DVEVVeGxpbjFmSGh3NjM5MDVVQVNseEw1WHdRdHRk?=
 =?utf-8?B?a0c1Y2h5b2pFYnNoUzVsZW04aS94Ylp5RCs4VkJmMXhxbDk2QUR5TVp0ZnZn?=
 =?utf-8?B?bVltZkw5UksrdWhBNFlKZGsrcnJtNFVEanFJYmxHZDB6Z25PWld3b2FYOTFM?=
 =?utf-8?B?RWRmZ0dLSXBPOEJscGkwczlUTkFBTFVSSklyUUU4dVlTNjh6YTFJa2RlVWl2?=
 =?utf-8?B?cGxWckhHazNSazFGZHA4TUpkQitzZ0sybkxCSHF4SjdhOFBCRENCa2JwMmsr?=
 =?utf-8?B?T1RIdjgzZnljWFZXRUJFdU1VK1BZOWpWdmcrcFJ3YytvTlg1ODVVbm92YUZC?=
 =?utf-8?B?NDBwTWNLOFRYTjZ4REhWU1J4SFNGOElBUnB5WkhvNnQ3Z1lWcm8yUk5QUldR?=
 =?utf-8?B?R0R3VUpvT0lPTTRtUU1pTHhiZnlRcjlwYWV6OHRFWCtKb21Uc29SanFCdzhH?=
 =?utf-8?B?TDRQKzk5UEtkbGFOTWkwNmNjK3JUMmE4dVlHQWZTUUhwVDJiME5jTDVZeE5M?=
 =?utf-8?B?VmVxYjdGSGhsbHNKSXFtN2NUM3J0NnRub1V1M1NrWUFjYm5IRnlLYWlmQzRw?=
 =?utf-8?B?dHpxMmxxMW5nSmM3UHF2ZWhpck5hWHYyZmFDZEQxTE94REhJZmJJejV3cDht?=
 =?utf-8?B?UVc2QXoxMWhYRkdNSHdGL0IxdWt3T1RBZ0tvRWp3RUJZMmNzMlhRZXV6WFF2?=
 =?utf-8?B?cU1ickJhZ1ZtZXNEcXEzT0F2TEV3ZXZPd3FQR1J2UDlFR1o3VnFZTE93Y3JL?=
 =?utf-8?B?S0huS2Y5MVJ2R1ducnZQZFUyMjVOeURSVkYwaDB1VVBkeHQxZ3lvT0Yzb1Fr?=
 =?utf-8?B?bW02ZWVhMVUxUEN1UXVqdmhjUmlENU1CWUxDZ3Y5WXpoRkt3NDVRM2MwWGdL?=
 =?utf-8?B?R0R4SWJJOVdsN1RMYklzQ0dDV2xnYlFheXh4akFrcGhZOWNiMmNVNlFqRS8r?=
 =?utf-8?B?ZkNIWkhxNDFwcHczM2NYRjEyc0RWbGtrd1dJTi83L0o0QmJDZnRNdkFKT1Rq?=
 =?utf-8?B?YWUxRUNINXd4cUtMUzJGZjZuYWlySWtpSHpHY1R5NnpUcjZUcElKdlNwNnBD?=
 =?utf-8?B?RVJHdXNhdnFiZVg3THd2OEpLL1dUZnI3UGhQKytMSnJsVmpYbm05RkZqejUx?=
 =?utf-8?B?UXBDNzgycGVsOWQyaVlpdGhDOGx5RXhxWVYyUmdoNW80RkdsRVREc3ltQTVw?=
 =?utf-8?Q?8GCLQvODWikAlpqcW9R+q5cSg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb950525-823a-4917-3f99-08dab66f90d2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 09:59:11.6371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szsHnkxY/ATRjJrKG5M+ASDpeDgZSZcZDUaxnG/tTAVD7M+yRaw6CPzSsKAbsXVreP0W7rtJDD2cRMa3DNgcJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean and Paolo,

Thanks for posting this fix patch to address the issue we reported.

We noticed that commit 7055fb113116 has been merged to mainline, but seems
this patch is still under review, so the mmio_warning_test kvm selftests
still fails on the current head of mainline. Could you please help to
update the status that whether this patch will be applied? Thanks.

We tested this patch on the head of mainline, and confirmed it does fix
the problem:

commit:
   a970174d7a101 ("x86/mm: Do not verify W^X at boot up")
   1a98b7142ef26 ("KVM: x86: Exempt pending triple fault from event injection sanity check")

a970174d7a1010cb 1a98b7142ef2695ee3d522ab1de
---------------- ---------------------------
        fail:runs  %reproduction    fail:runs
            |             |             |
           3:3         -100%            :3     dmesg.RIP:kvm_check_and_inject_events[kvm]
           3:3         -100%            :3     dmesg.WARNING:at_arch/x86/kvm/x86.c:#kvm_check_and_inject_events[kvm]
           3:3         -100%            :3     kernel-selftests.kvm.mmio_warning_test.fail

--
Best Regards,
Yujie

On 10/1/2022 07:00, Sean Christopherson wrote:
> Exempt pending triple faults, a.k.a. KVM_REQ_TRIPLE_FAULT, when asserting
> that KVM didn't attempt to queue a new exception during event injection.
> KVM needs to emulate the injection itself when emulating Real Mode due to
> lack of unrestricted guest support (VMX) and will queue a triple fault if
> that emulation fails.
> 
> Ideally the assertion would more precisely filter out the emulated Real
> Mode triple fault case, but rmode.vm86_active is buried in vcpu_vmx and
> can't be queried without a new kvm_x86_ops.  And unlike "regular"
> exceptions, triple fault cannot put the vCPU into an infinite loop; the
> triple fault will force either an exit to userspace or a nested VM-Exit,
> and triple fault after nested VM-Exit will force an exit to userspace.
> I.e. there is no functional issue, so just suppress the warning for
> triple faults.
> 
> Opportunistically convert the warning to a one-time thing, when it
> fires, it fires _a lot_, and is usually user triggerable, i.e. can be
> used to spam the kernel log.
> 
> Fixes: 7055fb113116 ("KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions")
> Reported-by: kernel test robot <yujie.liu@intel.com>
> Link: https://lore.kernel.org/r/202209301338.aca913c3-yujie.liu@intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb9d2c23fb04..20497685e6d1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9972,7 +9972,20 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
>   	    kvm_x86_ops.nested_ops->has_events(vcpu))
>   		*req_immediate_exit = true;
>   
> -	WARN_ON(kvm_is_exception_pending(vcpu));
> +	/*
> +	 * KVM must never queue a new exception while injecting an event; KVM
> +	 * is done emulating and should only propagate the to-be-injected event
> +	 * to the VMCS/VMCB.  Queueing a new exception can put the vCPU into an
> +	 * infinite loop as KVM will bail from VM-Enter to inject the pending
> +	 * exception and start the cycle all over.
> +	 *
> +	 * Exempt triple faults as they have special handling and won't put the
> +	 * vCPU into an infinite loop.  Triple fault can be queued when running
> +	 * VMX without unrestricted guest, as that requires KVM to emulate Real
> +	 * Mode events (see kvm_inject_realmode_interrupt()).
> +	 */
> +	WARN_ON_ONCE(vcpu->arch.exception.pending ||
> +		     vcpu->arch.exception_vmexit.pending);
>   	return 0;
>   
>   out:
> 
> base-commit: c59fb127583869350256656b7ed848c398bef879
