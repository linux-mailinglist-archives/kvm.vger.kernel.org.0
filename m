Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295C46FF002
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 12:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjEKKiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 06:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbjEKKiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 06:38:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A22D56;
        Thu, 11 May 2023 03:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683801483; x=1715337483;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JMcovTYlX7VlCZoTDrnOvog5VF8GQf6P/q7vlKBn4TI=;
  b=gGHvT3m8T2LGRQKnstVEb2rH749fuRr9Wg2jzN5u8hcpixrzyQRYuLxX
   DmI3bVv9iycpAZN/WbgcpwULXSJQJSqfwm+qhwAjXZ6VJz1HDKaLfQaRo
   eHMV13WtKJFDY1GK+g2LgP0BJ3FJGgwyh7h7k/sZ6gTHTpQxH6l7TtGvW
   ZdDvBnpmmXyCY60W/w5TbJuMKFIo2/1Fvm8Bgq3L93V97hZmr4aKiP3uA
   3QJIHwBqTkHqPuoSNmck7NsQJPApwwx0S4l7NTPgMmJrTVA+Q+ofgro7A
   YuONjjeaJsDze8AxOyXjkqHbsH4jbM/FoYDQudObcTzXMvUkf4Z5QsoSb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="378584116"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="378584116"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 03:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="789341601"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="789341601"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 11 May 2023 03:38:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 03:38:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 03:38:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 03:38:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 03:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTR9raO3cPqcIbgJIWkN5kG1u+MekhqhOsO4O0EmABhyYH7RD9KcAjQEQ6skJ1OEG61+SQDSpdZLPfZIZY3VS7fbWOdSywIdC5hTDqsghNOYXl65a6+IwcBjvv1BCRkfi6lmlHdRrTV1VgEEPtKTkbqw/txysS8VN6gC6DvWGM8hSfMRHOQ0XfdP/m3eo3zUXhm8ZO6KVvSI0sMEkXQlzbd8aaAiEgxqLT81xEHR65qUfXNOwfG/zgG+BQ0aMe3p7A/C2QM1WEyHjd2MOJqMA4khgY3ZVifJI04kricWxD1L0CAkCpBmCYBeoG6AFRfoLxoMm0xH7Xe1L3K1LRsstg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfSEN+WuT6u1Rafi/mYjb0RRlp6Oc1j/O2d117W6w7Y=;
 b=adiVDzW9s0rrxMAi6OhFp2SigIvyf/qzOIYQecX+rj0HKmLLL0rs+nkKmHbsMEXDcZ2glwiweuCyZOYJUqvQki4261/fo+Hr7VDKG/KBBdaJkFHDlJpXHepDhAKXOVwqzwHUF+O/yJ3EznEKBoxOpuBOSM9KG66zFH/DOzco9MgT09fnsvHcy23oCWYMmhKa+XpR14pPs31O7LBTuIJYeSIUzde9ReNezyejMAkDjjP+w05+UIAIUHE5XNZ+qID4TsKB6HJGOjpiJv8oiikwKdQ8qlEcPaxnwEx1o0iP6dc97K/NprQiJ5ZRVEO557K1nAe+ZWkp5QsPMQpuPxu7aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN2PR11MB4615.namprd11.prod.outlook.com (2603:10b6:208:263::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:38:00 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6363.031; Thu, 11 May 2023
 10:37:59 +0000
Date:   Thu, 11 May 2023 18:37:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <kai.huang@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v8 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZFzFfZkZtcc37x2A@chao-email>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-5-binbin.wu@linux.intel.com>
 <ZFyFPOo2Fp+yVU2n@chao-email>
 <a2ef5302-d27d-945e-3c67-0bc9855fc4a6@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a2ef5302-d27d-945e-3c67-0bc9855fc4a6@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:3:18::13) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN2PR11MB4615:EE_
X-MS-Office365-Filtering-Correlation-Id: b151e0a5-54a5-4ac4-c73b-08db520bca44
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJ0YQKUzds6EyQ+Jvzx/pt6pacjPHoAK7CZrOdju7IkkjGV+6XsqOXf8BTRfBqWzFTQ2o5GUKe6BKYly9aGFzc9poFtOntgPvFmbrxkgfs9MZ4LzEAqpnm2toyxRQ/3NEQ3yLauzesgAp2FJUyErAW0Pvb0oBUEGy/G/rGe1bJ9XR7i7plqoNTGIL72bQGBAZB98kaiZCURkZGE94YF1ek4s/SdGhqJauVchNe/8UsehBn12ckedwsZix6s5TCJgz61I5NmVDvs55vWDEbFZDu7DJqlp+Pb5QkNZVqwm3q2iGCtYIxAk3K7mZ204Fqq/jVhePSBF6I0i2CNBe2m/53M3SkuyESl6JtAUuvWqtQWnJt8DipTKLk0p00nCS5SqtkbpKVLwvN2NjTJ2RYAqa33rQkb8HwXHte7ETTsxKWpqtcgY6rUHh6IIhMXbdc40q6OMIHyvSXvz0AAAQMz2T4s6WOdxnX8p9mDUI1GnPmVM9SybCBgZxr4u7FCwCH02l4ycTNgbQsaek6aQZw1N0A3oZ6o0Tjz9Jhut/0sMizE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199021)(86362001)(2906002)(4744005)(44832011)(5660300002)(8936002)(8676002)(33716001)(38100700002)(4326008)(41300700001)(82960400001)(6916009)(66476007)(316002)(186003)(66946007)(9686003)(66556008)(6506007)(6512007)(26005)(966005)(478600001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O6aXtXoGhEbAJ2ZKZwhgJJDbOuXPtI4BdtAA6hSk/Cf404MpZYf2PF6EqvBa?=
 =?us-ascii?Q?b2h5GMOygM0VTj1IJNebQuwlHg19jL2kZI6LaiKJu812e+m3pOn1zJy9JPfA?=
 =?us-ascii?Q?bnFNU7MsJnpnN9eyLNhFch9Uln11dgF3Uy4rHv5QLpCfTMCFL6UletR6J6E+?=
 =?us-ascii?Q?IHxsSY0gtZeCdo1NfgujVwY7fVzMyaRXc89nTzAE3xWdpA1yV8kt17haiYt1?=
 =?us-ascii?Q?8ZqBlXZOHTjnrQkRAxWy+KhZVwnORcO6zFeHtCofuTfCQSTQpuGldRrgkZI9?=
 =?us-ascii?Q?KSwq8BmQmrGDi9wMpUkcwPaAHmy3GnzSLtb/OEdqVz6BiqRcGR2Vvyhy+NC4?=
 =?us-ascii?Q?CwrVKeSWP9jhkPh3eFhnowxyF3L6HbmRoTKGmMewg0j20FFSjcLYhnMZk0RT?=
 =?us-ascii?Q?wBx/IQpR9wWulVTqyugytGZGdj+f5IpXuzaXByJtvmVksXlhGvmVLQxvGzuK?=
 =?us-ascii?Q?z2Cd5FjLMZ+rJufvpI+Ok3i5JZCIaNNaW0n8sXH4gnTwyFvAdAtSonaASLYY?=
 =?us-ascii?Q?U/1t3hL13pqNYocHipt4W5EqzoVJyXyzmQv7XlsKwY5GH1UsEqeTSnSherrs?=
 =?us-ascii?Q?0wrGI2QKgIJ62TRVtNjDJxqhD7YDjB/lS7+ukvu7cVf5XSq9q7XYpnciEtwI?=
 =?us-ascii?Q?U7gjtwkJwPp5cfqF1D8LPLvrxXrpPxZNEgrSu2MGg+lR3YPeP4YVWzRydINn?=
 =?us-ascii?Q?da28VaDxrX8BpSNnS6g5Z3Lr6Zq3+WKmcA2swa/NdBd+VLicqjssEKHf4IB2?=
 =?us-ascii?Q?EHWp3PUT9akcBch39J5v4Vp+GWHycYN8HCQZ8cwjHHxOPNbKQpWcn4317N0s?=
 =?us-ascii?Q?2gjbBD6Bh+r6uv4J/cv7i6U8Q2ufwN6pYI49AO7uC+9yOubSw0/TuXg/+XNa?=
 =?us-ascii?Q?YLNkjiuwAvflSR+AVpY4dG8IiTBATL6OKQ/8SKXOtMCFV/rZvx9WIsCU7d6e?=
 =?us-ascii?Q?JL9XVUjTKN3MMk/sfl60M0hxyMzaGT8Monz+ylwPeToQ06CejJDI7ug8T1d4?=
 =?us-ascii?Q?jMa0nrYkejrXhHmr5Od+gA0mF37Jb77kPldwVfIoWCrNTqbdEh93eLuQW+r8?=
 =?us-ascii?Q?CkceIaiil+PzTqaiV8ZwbPWdZOLtjtxG8vNeFZXOtmO8T2TYrnL5pq8pOS23?=
 =?us-ascii?Q?S/BCU2eEQe9Gn5MyjAqhXj4rRZSubroTYEwmkNKFYPArxA+zoaK+xJAT3z6n?=
 =?us-ascii?Q?ySkq5/jI2jaROew7TctB196cYtNNVQP5F65y2p/XrGutE5y9LgVHL/yvIG5o?=
 =?us-ascii?Q?nvO0MSrPOFVeY6bgkrItNmDpoLcUSoOFMM4BOBYIlq/1qy4WQYFetj3qftRR?=
 =?us-ascii?Q?xWzy7CLin7b9WIu26QnXNNMB4Mj4J5jR6mTnHwATWV7oHW+vHnrSthNVboYg?=
 =?us-ascii?Q?0VFnuoclVWwMDpmeXcPgqgigpAkHMQ6x7a6ByS+rkaghZRGjIwb4NxzAuhet?=
 =?us-ascii?Q?oIB9DVbBdlw14AMhw9XBmWkLopfzeEuM94bIgWVx8noZw0GVIWHIcN7tg8U3?=
 =?us-ascii?Q?PXugbqV5avBuNHuqCdqaDdZaXhXm8PgQkmH5F39aAWu0NBt88X+2bGv8tdaU?=
 =?us-ascii?Q?eOgEwlf0KHn2joNwMpEu65+UGCWw5y8xMOwvmSzZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b151e0a5-54a5-4ac4-c73b-08db520bca44
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:37:59.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SojxKHQ+3k94qAT/+ve3bqOtB8sz+AMhVuNPJ0GJxLrELjhyE15dQw9nAXXzJXa7LjCeae/dqAcOYpZg+fDq+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 05:18:31PM +0800, Binbin Wu wrote:
>> > +	if (sign_ext_bit > 0)
>> > +		*la = (sign_extend64(*la, sign_ext_bit) & ~BIT_ULL(63)) |
>> > +		       (*la & BIT_ULL(63));
>> nit: curly braces are needed.
>Even if it's only one statement (although splited to two lines), curly braces
>are needed?

I was under the impression somehow -- braces are needed if the statement
is split into two lines. But Sean said [1] curly braces are not needed
in this case. Thus, please disregard my comment.

[1]: https://lore.kernel.org/all/Y9B9Ey1hK9A7NDVb@google.com/
