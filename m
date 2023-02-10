Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC245691B30
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 10:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjBJJWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 04:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjBJJWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 04:22:47 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A949721C9
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 01:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676020963; x=1707556963;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X7fyHOuD3Bi+ipCC6rnyOPnJe0NQEQI2MVLDTk5kB74=;
  b=dnPojcGwfZFyOtDCIzl4bRQ87Cg2oFZSYPNcoVwPnxFAhiCm83MtxGR6
   t10bu0Qtme50hQd0HCEaKQ6DhMUv/B0mIr8NAsnYPjfrYSR9ecnqTWfzV
   YjSkLrSQ3rcZs/zvxK7rGoiMvn1AhYiJaTIBB4nHrONGS7gZnW6cCwguj
   QeLSgTri4rBQ46C9H/x/z5J+D8wOv/ja4vi2i1iNxNYWM6CIF74ZSWoM7
   8OoFSQBYoDzCnJAU7hoPDhP4QJMxRiV/g5LxZNurF0aTyXfVhestuoZBS
   xQY2BQB7M5ZdTVsZuVSPKKAtzVEhsX2DEJz7CbD4D1k9g/GyxH8zjF7uC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="329005746"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="329005746"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 01:22:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="791899485"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="791899485"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 10 Feb 2023 01:22:42 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 01:22:42 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 01:22:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 01:22:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 01:22:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPsmz3AJdtTobjCH4NWzjJQp+VF2HpBospyWue+fKjtf2xAJAg2S3JYUh1/HodBGxy+A4G7QXVziA6cY72CbIm7JWUqWazE78c6DSgEujIF5Pl4HdVMQfv958+js8Di9nD41FWAEivvNSaXO7I6VlDezMV4TnvLQxCRrIsMIJsZanhduT/3Jn7lohfStXFgBXz2MGMwC0EWTu14PkDXZXWvBbaK5xLdS4fVQ8x35Kvx4hpUNITgQYBe48ET9SMqJgNnR7jZbXFwVaSEZ7D2pd00NM6fjtoKvv8CXid0C73iZM2+giszBhFDscpKMYOsyAtewQ7d0kicrZ0RKGT/6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6ZuK6T4c4H67fITTK2JygMMALkbMBnWDWbx2ou7Sa0=;
 b=T5OfYzbWmAR9bGokdCHQVW5CQWIdFe1h/e+Vi+h1Jf6s8GUMjUr1xWBQ/EYre7mPfC6la8ZsjaFTYxFzculthcV2TI1uN9J63R61FYx1KFHYVQwd9b5OdmQvzLPs0QGIuiTSBVRc9MzfayU70vqRhTxVRkaOndytIYQX8kjFkrxsEWMu9p9kkKz3yF3GCDtJ2VDjfQ8zdvMjzBYrmfW1W44dQvXU0Iam8jxMlIrY5xsdlmoyuMJX3n5eRvwxXDgFYLcEH+K42/ejlA+psF+mKu/ZFg/tCFriJGziFnulFSZ7VXyYuKOoLVM78PbKo6qg0XlssimuPAWWij39A9seug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SN7PR11MB6996.namprd11.prod.outlook.com (2603:10b6:806:2af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 09:22:39 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 09:22:39 +0000
Date:   Fri, 10 Feb 2023 17:22:55 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
Message-ID: <Y+YM7xsHtwsdHXO5@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <Y+SPjkY87zzFqHLj@gao-cwp>
 <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
 <Y+UtDxPqIEeZ0sYH@google.com>
 <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
 <bfbd8fe3b01539d10ff71b6c9bad5694592880be.camel@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bfbd8fe3b01539d10ff71b6c9bad5694592880be.camel@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SN7PR11MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: 170ea2e8-4a4c-4d1e-572e-08db0b485a8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOONwKNX+UWOGwaGSx8vevQu5k9ePkjgYu9Y1QEkZvdyDG+ZGEqqNrmotjANAIv/W8Knc7ZaYNbPNq7bDvNxAGR0JfCzQiWekVwEk2WXqz/ASqHyTMO63+hjc3NE9bFNRvYdrvsEhfCk+UTrqRt6HBDNE96mUtdDryg6NUNGbpqVqRtwIEQQy9JvZDYfk3DTiaONP++tys4qE7m9+64h3e1suvAs06WZ9NRRInWGW3k4YDZgJUzhK/KdQe5/6zD6f1THuuzLlnn5/anUudj6/MABTcAiuCyFoOZhal/4IRgpGAMPMUULE6ESbETh4ZyCYAm4BkiwNp1qeTx+ZMSUPhYOnoRYTUL/zMs9Dts+vqbqvzIqunFc854XADuiNSNvymxTgmm2H5DVF9zYeWYK80nnA8BNztLK0hqdiWvnqBYrCc5LlC/yg2pjnuLkUd/iXp5eUuXqsch2f5ud9UkztBVNneZg89YHQpih5FXIdEPJ1LANNDihdA+StxjG7gy9G+m8RDJDEl7F9XxjDpFVJKOel3/fA/1lJBSWAf5nbt5kD5HruqJA8Pgzsd5s1he/bWbDuVLhMLU6kLqPwySLaG60Y5BYLyH1tBcl6YNY1er5NaCTXLC/PC1ba0YKK7pTPkhs4s/E91BPuTtcGG/+w9TZsg48+tK0yZy5rIkCOaNtFX/caoVa7ROZyVhevcqQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(6506007)(6512007)(26005)(186003)(82960400001)(6666004)(38100700002)(9686003)(2906002)(6486002)(33716001)(44832011)(41300700001)(316002)(83380400001)(478600001)(8676002)(66476007)(8936002)(4326008)(6916009)(66946007)(66556008)(86362001)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?chJyX2PTpaQPh4cf1E2zdM3uzjvrLPXkX5JCrOzZugf3SnxBxLtpwFLexbhW?=
 =?us-ascii?Q?eMChKMawf+23cmvR+KnGytcP/3tyrZPTlmvJ2kxKDuasv30NPVRm38aiNB14?=
 =?us-ascii?Q?L/Kse3btfCcF6/UBTANjXfdDMs2HchgSEAaoQDOCJHneBWk6AcqZV5RFQVdt?=
 =?us-ascii?Q?b4uLGWsHy1UDH2j3RhjiP+A2VQ7pBmWJDrL8xMvom+GQmQEDrhWsMBKnuGbb?=
 =?us-ascii?Q?999TdhHz0dEiv4sWYrOANtD/F4tdZ52ieafiClrHV2C7sXlmYnr48U5JF7oq?=
 =?us-ascii?Q?iQyGfyV0D4c7Kecorzzq74fzniTrcoPhCWanxqH1VcI06RrVyQYJB/j6IzTG?=
 =?us-ascii?Q?YaauYVmEc5pxcMKtJWtPslATSjOSJR+A3pURK6og62dFOmQEGL5XgootPS1e?=
 =?us-ascii?Q?QXnEGM3xlsak33dU78WYjAo75fxjfQUXSfBUbvQGa4QzNfFiDXE0ATnZc29o?=
 =?us-ascii?Q?r/Lh83rC8GobnfrBFeojGHfocXOdsjoVzvp9qAn0JP5s/0IhYwktLn1RzmX6?=
 =?us-ascii?Q?UtjsuH02pN6/V0l/pbEUdVdbOpnjCISs50OFB6YdVNjwUN1UQLLw4fzKmXhC?=
 =?us-ascii?Q?EUvASSTloHXH8HCk1PAFMm5Pfegq96RN3jWvmMA343vn8o2NTsLMLQsPMolR?=
 =?us-ascii?Q?VXHK/35j0xZmFFH0BA18uq/3BZBETY4qXJNZY8kVSiFacOJWBntbMD/4dOrk?=
 =?us-ascii?Q?fgrOch2r0tsJkk/CLbzkHt39XCVU2M85pdUTzU4zN4hbOOvsQ9Ymxsq8EHt/?=
 =?us-ascii?Q?IYsX0X2ZlOvUUBikrey38hwXGJhqTLudkL6gRMhxhOqB/lisIS0nRZRzgjEO?=
 =?us-ascii?Q?hnV6o1DpUv+3B0hnRPCU2rW793gCv6f6fCpYCww1q/wLzKY554ck8+mkXF0w?=
 =?us-ascii?Q?rA+a4J491aT+zdjya6WMhvVrPCen42xV2H1LuWZuEDuzJTVP7WGNRotfwY+B?=
 =?us-ascii?Q?IxWfRNH4EPeuJXvkw7bxA/AjbAuZBL1nILTNZhdEcXGo0o1DABC6WyOxtosN?=
 =?us-ascii?Q?66NFLksgTldbHypPQKam1YL8eXFudoSQqMQS9xu/LfxuRG5E86GASZEpNVms?=
 =?us-ascii?Q?MYaZKXo7hS+Kfjv9Fu0ossLG0xYEReLdvdmfvp/2KUc4pKY9ri4WMuQU2Dga?=
 =?us-ascii?Q?SjfOVA7tFoGCoioR3KfYIGPVjKCkl2U74qIaEgEx/gfDmVyi9SQpqOdHSpp7?=
 =?us-ascii?Q?67tpvEWuECkxmDnq/uA26tnKmQ680tWSEBOPGuDalScOv+q9Dg/0zX38yuqM?=
 =?us-ascii?Q?fUl/q0gQ5FrTTfzyoyUs/Zkl6J+2oDtRCKoywwmB8bJG3Yjh1f5AsXQuPp4t?=
 =?us-ascii?Q?puC3L68dSwhaOySAPtVs25O4i/ud/XzAJOasbI+YroqioaEopskFmffgWREf?=
 =?us-ascii?Q?7oASC4iG2LnS0nJGxz4NE8/2uTJVukPYcmAYaTAdHz5RoN/VKLxQqidf2TLv?=
 =?us-ascii?Q?nfZhf2RQ8TrCFy39ngP0Y04gdu++1XP+5IFPmTz65JzZy+qVxstVjWx0GYPR?=
 =?us-ascii?Q?uQUCxXBiyoJvtijagpgSulFBN5yBsGfiREW4qEEOlKOLmr35fIoDodJXHQpv?=
 =?us-ascii?Q?uygYEF/jd4pFmA+ajECM5vWO+IrDD3O1MvDkJ+qz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 170ea2e8-4a4c-4d1e-572e-08db0b485a8e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 09:22:39.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/n3jcNp9XZ/toPGMs3HisNvtwpE84L/mFaXcF6JEOgVUisSAqx9JDas2lVtgOVXQI2AjZfZhq51ZNa/MWSKyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6996
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 04:39:49PM +0800, Robert Hoo wrote:
>On Fri, 2023-02-10 at 10:07 +0800, Robert Hoo wrote:
>> On Thu, 2023-02-09 at 17:27 +0000, Sean Christopherson wrote:
>> > On Thu, Feb 09, 2023, Robert Hoo wrote:
>> > > On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
>> > > > On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
>> > > > Please add a kvm-unit-test or kselftest for LAM, particularly
>> > > > for
>> > > > operations (e.g., canonical check for supervisor pointers,
>> > > > toggle
>> > > > CR4.LAM_SUP) which aren't covered by the test in Kirill's
>> > > > series.
>> > > 
>> > > OK, I can explore for kvm-unit-test in separate patch set.
>> > 
>> > Please make tests your top priority.  Without tests, I am not going
>> > to spend any
>> > time reviewing this series, or any other hardware enabling
>> > series[*].  I don't
>> > expect KVM specific tests for everything, i.e. it's ok to to rely
>> > things like
>> > running VMs that utilize LAM and/or running LAM selftests in the
>> > guest, but I do
>> > want a reasonably thorough explanation of how all the test pieces
>> > fit
>> > together to
>> > validate KVM's implementation.
>> 
>> Sure, and ack on unit test is part of development work.
>> 
>> This patch set had always been unit tested before sent out, i.e.
>> "running LAM selftests in guest" on both ept=Y/N.
>> 
>> CR4.LAM_SUP, as Chao pointed out, could not be covered by kselftest,
>> I
>> may explore it in kvm-unit-test.
>> 
>When I come to kvm-unit-test, just find that I had already developed
>some test case on CR4.LAM_SUP toggle and carried out on this patch set.
>Just forgot about it.
>
>Is it all right? if so, I will include it in next version.

You can add more steps to the test, e.g.,

1. check if CR4.LAM_SUP setting takes effort by storing metadata into
   a supervisor pointer and dereferencing the pointer.
2. turn 5-level paging on/off and check if LAM width complies with
   the spec.
3. add some negtive tests. e.g., if LAM isn't advertised to the guest,
   setting CR4.LAM_SUP isn't allowed.

...
