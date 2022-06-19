Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB62E5509B5
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiFSKgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 06:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiFSKgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 06:36:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F04101C8;
        Sun, 19 Jun 2022 03:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655634992; x=1687170992;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G9eAJym/nFIzB+XohcHy7aTrn98Z2gzHhy+jfNI0H3g=;
  b=iZ7XVqFUde4CEmYJK2EEGLtFWildm3tsZOGQ9o7JGpxllpj5LoxBp7wa
   BWjD7UAzYvRb9NjcmTiohp1z3cW6FcBKGgI00wOxtZIlwqqAKRC/kpij5
   EapF0gG3EMcOt+n2AWzqj52MibHhtbkyRQTdvDp/hK6sFV+E2ELUtn2gg
   HqtKzOhFBkwZGRORj8hwVkK+Sev+WqrRMzzpus2CWVh6ScXxwz9HN5aXc
   /YZo/4BvA46uALUH8GNrWXAXq9MkYDCfUyqeGPuLwArP3u7rmirmPyYAe
   496m+zpe/D/eYXv9y6Yc0QE06i1U0I9U4POGomTRB60toK+E5t9SamBRF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343712799"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343712799"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2022 03:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="654266919"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jun 2022 03:36:31 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 19 Jun 2022 03:36:30 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 19 Jun 2022 03:36:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 19 Jun 2022 03:36:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 19 Jun 2022 03:36:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNwwPOun1Jamccdi6ANodaU8Gx3FJ7zlJKE0czK3hT23dxwiD4x24Kpm/LhJuyxG1sHiwcc5yzZkEDAXwvSVm4d0tmJZgsb5kbTSKw+VBgAx5Qb8QlzypUh3Go0Lb6oSv9RTPSfUDpJzB8iAnPUFsyvLZywDKTyxBzqZpZkK7IS33oeVuquL6VERrqdbWNb2TRlIrxj80xiXvnFQ8eF6Tbf9ySgoZ7nqs58nZ+iXvX3fX6snxquZgPr2dxvAs6k5pSVWQyQGy4AVgQZ1HSOdupBerbTWHlJGPn1eUnpXCMQAA3wuzqo9l8fBcagmblS4Qb4PL7mIUcG9PdSi6t0hWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxZ6sNLsj+oS8q/Yvha4l2xkI9EhtSUnkzNCAoMj58s=;
 b=NkndaybSiy/XWyT8Sjya/H9JbM5+pCTdZce58iJyk+XUpqvY5n+KobFj55PPLphBWlj/giKOcOi1upxAe4InBirRGDODp0Jk8o5jrKzF6ucL3Bwj+w2y/Ams4fZQudFU+QOsNmMoY+who0PlFSQ5Ev8WtXWn58LHiKKDy9suw9RFxc0D5K+Zr9Ff/+ObgfsmgWBGoKFM1OtIjZmI0EUDrFSBy6EU2j6GDi3J3/SGaUYwZ3BwdOxpl15x1C75B2TqJ3jkRoaVyO6W+oR4IY8n2rZt3dd8eYiXpxoYWfxXcjHGidSUJzz/DPjguyt26omLFWDOYOyyeSD66Hq5aygqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by BN8PR11MB3681.namprd11.prod.outlook.com (2603:10b6:408:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Sun, 19 Jun
 2022 10:36:27 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74%3]) with mapi id 15.20.5353.020; Sun, 19 Jun 2022
 10:36:27 +0000
Message-ID: <de35d629-e076-e02d-7482-c93de628dd82@intel.com>
Date:   Sun, 19 Jun 2022 18:36:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH 2/3] KVM: selftests: Consolidate boilerplate code in
 get_ucall()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
CC:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Atish Patra" <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Colton Lewis" <coltonlewis@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20220618001618.1840806-1-seanjc@google.com>
 <20220618001618.1840806-3-seanjc@google.com>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <20220618001618.1840806-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0158.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::14) To MN2PR11MB3870.namprd11.prod.outlook.com
 (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686f0146-d5cd-41fa-02c5-08da51df903e
X-MS-TrafficTypeDiagnostic: BN8PR11MB3681:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR11MB3681F08053D27BDEA1D88959F7B19@BN8PR11MB3681.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwTg9Rf2S2jyD++wMd4VV06qTn1F7qvx5sjRUlLZfBg3RuKxnTf/a90uTVyCEakpUXMKxM2xAlhpQ9dsgn+pQp0BrNmPlKVO5VA1DVjUP9numQdT+gtSYn0dlrXbmHWoP4sOdSjZnM9UNJ0olSEGmljv04nmwkYzV1Uu2aRggO5A55bNfPP+sFC+3UNW96DBtm8AjAKiVCqAWylMgIWjrCpYC+d/S5gYhW1d3y+By/IBd3HyW6V0qDItvFD87oskZPYQmuQKcE5EFVxKEuVzU5KhZbxrUexPvLyh7+Fg6OjSsd6tSQc0Ea4GRWRgqYBcEcuuVRrTo0DEsZknSpLnTIwPBpcq57y1OZEfQgLHVEMJOyCECsfPEZUg3rsb61MSac1v8MCn6o8NIdLAQnwJKpppQOIgnL05Kn9fXrZxuEFq2BLAM4JOYKBMmyQbw/bTNbp3laQYZ9qSfRVW0j6TDJ0Ep8BOffr0f0ZPN9hX+5ZKTYj3SG9B2jC9GGlU3M6ZZtxwUdppmh07ZT//Exxk2tqj0H8DJHIO+jqVePwlUOI4T2VKErvH9mFKYjMd5Ak/2FalmzH2z9gFrmu0+xj786ad0pr1Hn0jSHYvsUQdXIDwYJJ+/C8iMqqCd6RKB6zz+WrvKMwi0kar8lmu4jzj0mCRj0+JP5FrrVfTk4vR821isblrLm5KLVNI1dAfb2XxvopfBikp15sbXhCWI8m232IJGCKNDJt3HSMCnZyQot2nf+uiSBKViv/zNk84SQ2p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(921005)(8676002)(82960400001)(110136005)(316002)(54906003)(6506007)(38100700002)(498600001)(6486002)(6512007)(5660300002)(26005)(7416002)(83380400001)(6666004)(53546011)(2906002)(66476007)(66556008)(66946007)(31696002)(8936002)(86362001)(2616005)(31686004)(186003)(4326008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anhrSllJdlZ0WnF0dGlmREJWT1VLeDJXV1ZseTk3bGNia0hjZGNoLzFZbEJm?=
 =?utf-8?B?M3JCWTgyRW10VWhzQ2UydWlnWUlSUHU5cHRVWUF5LzAyNit4R29GRlV5UWty?=
 =?utf-8?B?VjZ1eXh2dEtWNk1WWTZjNklyT2Nmd1BNcnhhZlI0TzFvSEpIb2xlTXlFUCtL?=
 =?utf-8?B?RENiTkRXKzh2Qy9tM0hmRWdwc09mcnpGUGljWnRHbmJwb29pU2c4UnlFSmkv?=
 =?utf-8?B?dk4ycWhhT1RPSGhWd25DTjdYT2pjRnJkS0RtNXlqTkgxVFFGNjExNDFPM2JI?=
 =?utf-8?B?K0VPTHd4cC9TKzZRRlh3Y0YxUElQOVpmYk1vTHhZM1FLMHFyMHM5ZnZxQ2dM?=
 =?utf-8?B?ZmNNNm9YbStkVEJsaWNzR1FzazVmVEREZFZWVlM0bmN5MTAzNHVaZzJxemdj?=
 =?utf-8?B?RU9jcmVnN3VtYXZ0V3F5YWZxekJDdDFoRmtHT0NSYnBmbC95SGFwS1FzdjlC?=
 =?utf-8?B?YjN3ZXowS2dabFRZUFJsQlk3d1pFYWg2TTdtSS9iM0R5YUtCOHkrNldwT0ox?=
 =?utf-8?B?akc4YmR0U0dXQnVXaCs2YjFCNk1DeWFjZ1FKRzJ2bExsaTNaaHVQdTdaZnM5?=
 =?utf-8?B?WWRJU0FCWi9qZllNRTVmRTdMaGhwY1JlSkEreFJlcGx0RXMyazdEUkRwNm8z?=
 =?utf-8?B?OHBkY3NrMjAwd2d2eDhFWUxRNFFOKzJDZXNIYXM2YUlDcWJCZTlST0p6Rm1V?=
 =?utf-8?B?UEMrYXlUcGJlRDIvZGhuYUJKZktOUnMrNk1hdTlKVHZoNEMzUll2NmNaaXZP?=
 =?utf-8?B?ZHhqZW1KeCtmV0ZnMEtZUmd2K0tjUzJCdjhuaEZ5bjRxWmRvZDA1YWErMStU?=
 =?utf-8?B?dkttdkZaTzR4K0xHelJoM3FIdmNMREZIejc5cVNLbVd4YTNPQkVDbWJ2cVFj?=
 =?utf-8?B?TjZTckp1UGZvT3hmNW9KbERJZTMrZXpsSm9ic3F2aEhnQUVMWmt1MU9oczAx?=
 =?utf-8?B?QWZvZTNvTWJrNHE3cGpsQm9Icm9zNzJkc0t2cExwUkYwb1hnbXd0SzVZU3BC?=
 =?utf-8?B?OEw0UzRCR1BwMGpXeVByN0ovRjJLYjkycDhld2hHNXQvc0tIdGs2U0dLeEN6?=
 =?utf-8?B?V2k4b0NwUnh6THo5WERGOTNOOTUwM21CM3JuamswaXZTS3lQQkFkZDdvbTFv?=
 =?utf-8?B?cmp3Vk96Ny9PcmFuTk1xaDB0bkhyWHoxaVJ0Z2lBeG81Y0tEM1UyYUJEd2o0?=
 =?utf-8?B?NWZHV1JmSVlKZW1DVHJIaVltUzRIams4aFlJZm9vb0o4OVUwYm82blVOeFJq?=
 =?utf-8?B?bWs0Tm1XOVVLeHAwVVJCdXpBUjIwY2gwTmNWSlY5bUdNWGI3dnVQSzg5VmZi?=
 =?utf-8?B?N1VTQ3VMZUV4WFlLclFrbVZDNmkxNS9kbEVhMHVCb1ROdm52Qk84YUJRc0xG?=
 =?utf-8?B?WkxRdEczN1h3RGd6OEhJc3h1d1BWY0VuQXZkZzZlakhxVlZNSjk4dkExUlFR?=
 =?utf-8?B?azBKdWU5R2NVUkJ6bXFMd053NW1ld0JMZWp4ZGFKR0s2Z0N6YjdUQ1BLcjJs?=
 =?utf-8?B?eHNrclprQmdsa2tLSzYvSXY3bGJ1ZTAvdjUwWkh6bENrSGxSUmp0NTNCMExS?=
 =?utf-8?B?dkNCTVo2Vk5YaUd0MGNtZ2lxNlBscEN2V2FNTU9XNWtRa3cvNXVFdW1USjRZ?=
 =?utf-8?B?cHBkRWtCWmhKRTQ3ZmZ2Tk53aXRmN2tTeVkybWNOMzFJZE43cFhveFNZMDJa?=
 =?utf-8?B?Uml5c3UvZVFoYWZIK0RmeUdXRi9HNEdZTThlc3owOUY4Y2dBZ1RzNVhkNmcv?=
 =?utf-8?B?QXg2U1c5ZVpSOXFXOVB4ZU1tS1B4Vk53bnNVZkNFRWFBSGgwaFoxUURkVmI5?=
 =?utf-8?B?bG93Q0FtbFV0cnJVU3ZnT29PM0NKdWJVTTZhVmNwUFFiSHhTclBQeDBiL011?=
 =?utf-8?B?b3ppeUNpT1l6NjdpeHpiZmFScnN5cWJsOTBtak83RG1SbUx1SEhrWlZlVnJa?=
 =?utf-8?B?RDc2VDhkUzMvQWREdndxMmpLd3AzOHZPbTAwWU04WHdpU2k1Q2pVdTJVUDZ0?=
 =?utf-8?B?azdQbTRpbWRkQzkwK3lxNTMxdXZCTHRlSkJPd3lHTnJSSTZnV2RwbUMvSExN?=
 =?utf-8?B?ei9sbiszMEJ2WFJGbmlCd3lvY2I1aGJMVnZFemExQXpBNzhCSGdOQ1FoTlhT?=
 =?utf-8?B?U0czOGJyWjl5NHNsWCtTTWZFOFNNOS92eHppbXhwSmZOSjZxWEhiNVlKS0Qz?=
 =?utf-8?B?RWEwUTBNUWRhSWllRFM2cFk1eC9DMW9BVDl0NWZ5TS95Q21CR0NYN0p2ekhw?=
 =?utf-8?B?M0FjWGtzKzZCcURDZHppVXFBaFB3ZVgxclFYU0lKcjJJQ1d2Ujc3cFU2RlNl?=
 =?utf-8?B?Tk8rRlhEUE5SRWVmZ0l2QlFHckxEVC9TNGJ0YmdXdTQ3NEFlYzB5TkczYVc0?=
 =?utf-8?Q?AlrfM2Vd51hToa1E=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 686f0146-d5cd-41fa-02c5-08da51df903e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:36:26.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ja28G+zVbxnTE9Zsd1qjoa4S2TLis7tWIIDRukCXTLxxMtKtFrdhjkWSSxTptAYTfKtUfjWz3eX5WymGnPjeqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3681
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/18/2022 8:16 AM, Sean Christopherson wrote:
> Consolidate the actual copying of a ucall struct from guest=>host into
> the common get_ucall().  Return a host virtual address instead of a guest
> virtual address even though the addr_gva2hva() part could be moved to
> get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
> should return a host virtual address (and returning NULL for "nothing to
> see here" is far superior to returning 0).

It seems the get_ucall() returns the uc->cmd, the ucall_arch_get_ucall() 
returns a host virtual address.

> 
> Use pointer shenanigans instead of an unnecessary bounce buffer when the
> caller of get_ucall() provides a valid pointer.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/include/ucall_common.h      |  8 ++------
>   .../testing/selftests/kvm/lib/aarch64/ucall.c | 15 +++------------
>   tools/testing/selftests/kvm/lib/riscv/ucall.c | 19 +++----------------
>   tools/testing/selftests/kvm/lib/s390x/ucall.c | 16 +++-------------
>   .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
>   .../testing/selftests/kvm/lib/x86_64/ucall.c  | 16 +++-------------
>   6 files changed, 33 insertions(+), 60 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index c6a4fd7fe443..cb9b37282701 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -26,9 +26,10 @@ struct ucall {
>   void ucall_arch_init(struct kvm_vm *vm, void *arg);
>   void ucall_arch_uninit(struct kvm_vm *vm);
>   void ucall_arch_do_ucall(vm_vaddr_t uc);
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>   
>   void ucall(uint64_t cmd, int nargs, ...);
> +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>   
>   static inline void ucall_init(struct kvm_vm *vm, void *arg)
>   {
> @@ -40,11 +41,6 @@ static inline void ucall_uninit(struct kvm_vm *vm)
>   	ucall_arch_uninit(vm);
>   }
>   
> -static inline uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> -{
> -	return ucall_arch_get_ucall(vcpu, uc);
> -}
> -
>   #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>   				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>   #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index 2de9fdd34159..9c124adbb560 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -75,13 +75,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>   	*ucall_exit_mmio_addr = uc;
>   }
>   
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>   
>   	if (run->exit_reason == KVM_EXIT_MMIO &&
>   	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
> @@ -90,12 +86,7 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
>   			    "Unexpected ucall exit mmio address access");
>   		memcpy(&gva, run->mmio.data, sizeof(gva));
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, gva), sizeof(ucall));
> -
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return addr_gva2hva(vcpu->vm, gva);
>   	}
> -
> -	return ucall.cmd;
> +	return NULL;
>   }
> diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> index b1598f418c1f..37e091d4366e 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
> @@ -51,27 +51,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>   		  uc, 0, 0, 0, 0, 0);
>   }
>   
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>   
>   	if (run->exit_reason == KVM_EXIT_RISCV_SBI &&
>   	    run->riscv_sbi.extension_id == KVM_RISCV_SELFTESTS_SBI_EXT) {
>   		switch (run->riscv_sbi.function_id) {
>   		case KVM_RISCV_SELFTESTS_SBI_UCALL:
> -			memcpy(&ucall,
> -			       addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]),
> -			       sizeof(ucall));
> -
> -			vcpu_run_complete_io(vcpu);
> -			if (uc)
> -				memcpy(uc, &ucall, sizeof(ucall));
> -
> -			break;
> +			return addr_gva2hva(vcpu->vm, run->riscv_sbi.args[0]);
>   		case KVM_RISCV_SELFTESTS_SBI_UNEXP:
>   			vcpu_dump(stderr, vcpu, 2);
>   			TEST_ASSERT(0, "Unexpected trap taken by guest");
> @@ -80,6 +68,5 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   			break;
>   		}
>   	}
> -
> -	return ucall.cmd;
> +	return NULL;
>   }
> diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> index 114cb4af295f..0f695a031d35 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
> @@ -20,13 +20,9 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>   	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
>   }
>   
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>   
>   	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
>   	    run->s390_sieic.icptcode == 4 &&
> @@ -34,13 +30,7 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   	    (run->s390_sieic.ipb >> 16) == 0x501) {
>   		int reg = run->s390_sieic.ipa & 0xf;
>   
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]),
> -		       sizeof(ucall));
> -
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return addr_gva2hva(vcpu->vm, run->s.regs.gprs[reg]);
>   	}
> -
> -	return ucall.cmd;
> +	return NULL;
>   }
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 749ffdf23855..c488ed23d0dd 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -18,3 +18,22 @@ void ucall(uint64_t cmd, int nargs, ...)
>   
>   	ucall_arch_do_ucall((vm_vaddr_t)&uc);
>   }
> +
> +uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	struct ucall ucall;
> +	void *addr;
> +
> +	if (!uc)
> +		uc = &ucall;
> +
> +	addr = ucall_arch_get_ucall(vcpu);
> +	if (addr) {
> +		memcpy(uc, addr, sizeof(*uc));
> +		vcpu_run_complete_io(vcpu);
> +	} else {
> +		memset(uc, 0, sizeof(*uc));
> +	}
> +
> +	return uc->cmd;
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> index 9f532dba1003..ec53a406f689 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
> @@ -22,25 +22,15 @@ void ucall_arch_do_ucall(vm_vaddr_t uc)
>   		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory");
>   }
>   
> -uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> +void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_run *run = vcpu->run;
> -	struct ucall ucall = {};
> -
> -	if (uc)
> -		memset(uc, 0, sizeof(*uc));
>   
>   	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
>   		struct kvm_regs regs;
>   
>   		vcpu_regs_get(vcpu, &regs);
> -		memcpy(&ucall, addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi),
> -		       sizeof(ucall));
> -
> -		vcpu_run_complete_io(vcpu);
> -		if (uc)
> -			memcpy(uc, &ucall, sizeof(ucall));
> +		return addr_gva2hva(vcpu->vm, (vm_vaddr_t)regs.rdi);
>   	}
> -
> -	return ucall.cmd;
> +	return NULL;
>   }
