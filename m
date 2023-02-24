Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98306A1648
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 06:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBXFdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 00:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBXFdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 00:33:37 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942EA158AD;
        Thu, 23 Feb 2023 21:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677216815; x=1708752815;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NDCcYiBLbGtC8hu62rw3TxdXypRKMLlxXXhz2JeUn4Q=;
  b=PsUn17dOIonQUIwg8/oGDGX0y4vESjfnYNr6+1V77zXd6pj1YyVaUUKC
   3KwXxCo9EPvzXMvByfH4SeS0YQt0Ab3iwd/JTfaF9FQoUfrNG5JEvPnSh
   Hd+vJfMWY9urOM0pftAQS9jcTbFq6J6QU1UohkkBqDhF0Erak7BbCJ88H
   uQgUhNz4PDK5Hg0sdioUZ0FiToYsbG3Mq9XTQzahk8CLkY9KScm+uG6yY
   8hDIJlEp0bcW2uTrgLapc6eRAH+bkBwn1Kq6ETgVGRLmdV+KA/jzhT1fY
   L45BOUZk4tWWIr2KGIpMoOYBP1TElGsBgOC9Dhe3qXQWmwmGr0JifGSfW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="360905896"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="360905896"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:33:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="736686015"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="736686015"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2023 21:33:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 21:33:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 21:33:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 21:33:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 21:33:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku/WO3YR6IVgiRKcUAhImq9oA67BxB1ENUqVcARG25VoWbL8Os2RZY5lUTzOaHxIfgDJPcTqduxTUJjjxCQUHKB9k/O3hoTXIkmUsd/ASClaNXHBYeISdZ/MAS5BYiFm/ntyPeLFkK4CO4D8fgTiMVuEke4oT1Rdp9DDEYesA3pVUR97vLwxtCkcej11eUy6TzdGaD0ERUFaoXjz/oHLL6tMgddqdFBQDvZ3+vlsab1lYoYTqFNtXHbvi3QafLPnPG8wjKl3OsAQYUtYYaOJ5G7cTLt+p7ScKrMxa/DAWkY8sX9DeN+zCElNyPk3CeK1DCtMhZpwPEjvJH0UfwI2Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sM9m8puFL/g9xSoLacwGTPP1EJHSv+XGkoI5gj5QMOc=;
 b=dM0xO4xyrv04tDE/uHKnAbq7OHDNuPwJ8eGm+No/+y1x+9RnzwMwXlDKgJ7jjlvKfpxQODwQYHIqkQ3QuKhmciXH8djACIMfq2L9SLQNEXzY74UjkrHQpB1cqRXbkLOQs8/MUPvO6+7+gh0TGg6gI2gZR/6Ve9h1bXO76eaI126mX3CmwoCHI3WsoepPj+i9JNZA7JpiwN4svh59BSAz5fAgNByoiA6eyV77wv7zxIsKD/jajk0KBUuQz2Dg3gppA1v8GBd8vwYnjsT1A/x9CBdvRIbNMZOTRWWSqZHgfxNCJu36awSJ+bSNmSZFPgQnDUv3kd86X5BzxBY/vRhcfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7199.namprd11.prod.outlook.com (2603:10b6:208:418::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Fri, 24 Feb
 2023 05:33:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 05:33:30 +0000
Date:   Fri, 24 Feb 2023 13:09:47 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH 03/27] drm/i915/gvt: Incorporate KVM memslot info into
 check for 2MiB GTT entry
Message-ID: <Y/hGmyneWgDlmFwE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Y7SaklDQD0EoIs8l@google.com>
 <Y7Y+759IN2DH5h3h@yzhao56-desk.sh.intel.com>
 <Y7cLkLUMCy+XLRwm@google.com>
 <Y7e3fT8/V2NoXAUP@yzhao56-desk.sh.intel.com>
 <Y7ioYegkgKIH8uJL@google.com>
 <Y7vlOCKkJ+QyO3EM@yzhao56-desk.sh.intel.com>
 <Y773+EB35bAchVTC@google.com>
 <Y8ix4lqk8QYH4g3h@zhen-hp.sh.intel.com>
 <Y8jUom2voLubfqxE@yzhao56-desk.sh.intel.com>
 <Y/fPePRoP6sOiD14@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/fPePRoP6sOiD14@google.com>
X-ClientProxiedBy: SG2PR03CA0119.apcprd03.prod.outlook.com
 (2603:1096:4:91::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: 6852af93-fc94-460b-40ba-08db1628a992
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9J/xDGDB3mGTpkwo2Pc1aoqOAgOe42v48AYCcoeKJ7BUiM3yzGmgwDBVVQfojCQh32g4erNukRFYip/KtiUPM55BdKOOSikgD0EDbJ4hNngcE54I/FbnH1iKB1v8Ib2cMe13D2gE/VG8WI0ZkIFoXPA86yavO23ttOj45YN+lGeZo/0SlabFEKeQKFjCrLXFSF2+/2Ut8mfAcbWdF+2uBqBlfQuHvMfjdwzltgH4HZFnhedKrG98G+st6dkUkNi0r4nNDeABwX2nY/hKnQ2/FBpGldvd2O51mfy7MvuOFpCmmnwCKSr7+0Po3eiEVyfRpv6MuU7HLgwgxR2BrVqQLEiJ6dwMPPevKptsjZGpPB+FDxJ88rTSFE8gB4ZQGIiI2/is3l31pEHbbsf8Kg84QKi0xIw7DtC7HRrpOdAgynb+2tbH2/yFES+L4DzrQnThazbfAMtq8P1tRX+2101FN4HQpcGSurqR1HCF/P5PFVAny5O5SH0XjwsD9gmLsyQiRc3PKQFLb79H9l2At6Thz9y+v5SkL0S6JhwFUj5au+/6NSnsh7AcmITueo5QR5qxBfq0/Ai1whmJ7D6TSWU461wyBs2dPU12FGziLkZcWsHioyLHl1XqCEFNyvk7FTyYHMhlAZmEBmZENc1FGlOThg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199018)(2906002)(3450700001)(5660300002)(478600001)(83380400001)(186003)(54906003)(6506007)(86362001)(316002)(26005)(82960400001)(38100700002)(4326008)(66476007)(66556008)(8676002)(66946007)(6916009)(8936002)(41300700001)(6666004)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1G37fWGbsk6tQWAO+IptazIrbQ+f8wy/zzNNyUnym2kBhV1/O2CK1Q0O89g5?=
 =?us-ascii?Q?3fQbPZtr16CbsK7rpIpWm43vVEwvl+zqildZ0hIWQSVj/S4FqiXcifRoY1/l?=
 =?us-ascii?Q?N0TYNC9sb9jeQRNom7r9liTDWX+bK5nZfLaxh+hHwJw5OtxfcBPiWJmK+wpH?=
 =?us-ascii?Q?FTFlXFOuTqNZHrhjpaBIOSpEadG+s+VO83goOg7Ox21uO0wA6cyWXA2YVgNG?=
 =?us-ascii?Q?fkda+fJN1OAmlw6BWSv8AmSGEHOnfXPGxvymGJEyMx0pxdq7EVKnDrtwzz45?=
 =?us-ascii?Q?VmjBSwymBTi9hOqNhZ9/2cgwaSmZw7+aray25V6q92AnvsQNUox9+uNkkNV3?=
 =?us-ascii?Q?ilKnEzA1UbJVLpzKnqhN9aHXIxhOrh7ggXRK1IO2r04hXlSjHEZR/twkvTUv?=
 =?us-ascii?Q?xskKLwxREhNPbk6C00md/HkSpeCGYuXnVfzJtItoeW6nBNejJDJYM9TbnF46?=
 =?us-ascii?Q?wYA7zRuG+u7u+sCLZKNFvMHF4EJBy6H5in4IYuDBcV4oKqFFuALa89wknmch?=
 =?us-ascii?Q?Dmrt/kXk3YBghIRpLEOTXkH0S+AzesITwmzt8ap2RAvpkffCaLLf5iswuJJV?=
 =?us-ascii?Q?8O2b6f1/JdjqLAZ6ZnZomPhy7A1+HQgl0WjwUAheZdCW/xaFGF3i5uFJKaH8?=
 =?us-ascii?Q?yBLMgK7smrLL4bQI/AX1PWYPw83Y/Xzlw3DoaPf3EPP09J8liTyWA89luvvz?=
 =?us-ascii?Q?0jm+FZc5en7tRz1v6nf8fm08qxLXWw2vT47FImeApXOA/1ome5vqHWbf522W?=
 =?us-ascii?Q?u8BRrSrbLbkUrlYYYbnNFXt7fLG+/woaLv57Q6pneHwklsAWosVhbrBtVOd2?=
 =?us-ascii?Q?5/QxlSzPwFw+4/M0GT5QmqnZUnpjLWm7J2x7mTY2WFaorH/Tr9kwMHO0YUND?=
 =?us-ascii?Q?aSS7rhpWit/v0ngIEqdVAJmzJTObop9pbgoTYf/NL49dLkB3O4UcjYd9hnIG?=
 =?us-ascii?Q?ESPIp9KHqFMzKzmHhYfFhxHfEaHGY5hd1lbCy5o0o6ojXLyYMxTmxCNzVghj?=
 =?us-ascii?Q?DCWjrhioTBUXMbOrrgfNDIAm5PxYSwrMQat04vD/P13QTzR8rRPCEs29vzkf?=
 =?us-ascii?Q?ge9BGrGQIJdWSoROcLLywPCphMvuks2xcnobWMZjLoqsjFN6U7y3l2VUStB+?=
 =?us-ascii?Q?owgLsB8M3qMs3oHhGaDkpmhcAXr+rWQ9C0ZYVIEfx6nheIjrQ8muKvHTbS72?=
 =?us-ascii?Q?0hhZ1EvdKnMEvLpuyfMIvmp3izF5+rW9aOAEIhBYi0MhI3XmBRzYREFO6207?=
 =?us-ascii?Q?P7AuFK3iiGjMePBU7M8ol4nM1BYQ6yKhH7Poob6EjMJF4Jgz1PuRX9vLDJ/r?=
 =?us-ascii?Q?tcITN5O/OCxADkmKNmDOD9i0c3djU5lEnZPH6ounOD1PlKiV7TWOmVN8ihU6?=
 =?us-ascii?Q?37Fia3hPJthAYKCjWoreJGecRFqysgBzzhZ5nCOE/rJp666mhlW9kkT2q5WH?=
 =?us-ascii?Q?OOa7rXTzUBLSLwKy1pqe/6HCU+MOjxRh7DLk6rb/U0loiD/xUmPe6Yea/fPO?=
 =?us-ascii?Q?F1nGL4unIE92/cu1bcXaj0HIFQ515Uf8ykOeH16D1nvI8OfHbfyeuqKtKMiS?=
 =?us-ascii?Q?XAofRYUjWTNA6dboQ0vrNNdrwIsi8V3Hi+ze9vJr7x6iNV5F/LxGFZTnwbzx?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6852af93-fc94-460b-40ba-08db1628a992
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 05:33:30.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdXibiQYOZzAQ7s1RvqyGFiTA5GWCmekAnER1/e4qQ/AhmFsXu/2UoS40Nahyr9Z500/mo279jokcNWEo+RDYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7199
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 23, 2023 at 12:41:28PM -0800, Sean Christopherson wrote:
> Apologies for the super slow reply, I put this series on the backburner while I
> caught up on other stuff and completely missed your questions.
>
Never mind :)

> On Thu, Jan 19, 2023, Yan Zhao wrote:
> > On Thu, Jan 19, 2023 at 10:58:42AM +0800, Zhenyu Wang wrote:
> > > Current KVMGT usage is mostly in controlled mode, either user is own host admin,
> > > or host admin would pre-configure specific limited number of VMs for KVMGT use.
> > > I think printk on error should be fine, we don't need rate limit, and adding
> > > extra trace monitor for admin might not be necessary. So I'm towards to keep to
> > > use current error message.
> > > 
> > 
> > Thanks, Sean and Zhenyu.
> > So, could I just post the final fix as below?
> 
> No objection here.
> 
> > And, Sean, would you like to include it in this series or should I send it out
> > first?
> 
> I'd like to include it in this series as it's necessary (for some definitions of
> necessary) to clean up KVM's APIs, and the main benefactor is KVM, i.e. getting
> the patch merged sooner than later doesn't really benefit KVMGT itself.
> 
> Thanks much!

Then please include it and I can help to test once you sending out next
version.

Thanks
Yan
