Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786647D6218
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 09:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbjJYHHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 03:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjJYHHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 03:07:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B33A116;
        Wed, 25 Oct 2023 00:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698217627; x=1729753627;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0RwyRUVCe6Y5eM2B9b/pZJ3y2v8Fp8GS8vwygW0BbUE=;
  b=WtwLj4d/f/IqKg7r79PVyrE14HC7wAo2FZAAEG1q8fDyqDE1qlE6yYdS
   UzDK2DUTtDgcbOrEU6UN94Snjc9ly5oeZ3q3E++pHol5jS0l5lFkQ8Dsr
   KaQ8YMzo9KnyXarved0B09AoZqph731qpn0rC8jPbp+SiMAiMED1rIxBR
   buHfcpfGQo/YL7of5mdU2LLfZICAIAjHApOz54aXI7eheBPjtzBT+mrfR
   M/poZkpj3cAUYdcX/CQxAT8hU9Wb3fHlSmiIDTYnQhJI9zvC1HBb8M9Er
   FWL8rJyYeV1rzDDm0TgaXU6XFgD0fXYuOmA00FKGBTYqL9+BfwtseR5Yl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="390106982"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="390106982"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 00:07:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="708610449"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="708610449"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2023 00:07:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 00:07:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 25 Oct 2023 00:07:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 25 Oct 2023 00:07:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 25 Oct 2023 00:07:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+lqIWrfCcP9FkJ5vymAThuxCh98bgR8XePQjJ6o7UjUsa/S3hqZFL121ofxPrAsDzaE4tXXZlpxhgOmJvLucLM20qzqDwPSwi6aQxDkbKNA7hgOyJUtPn++HQ1OFJi/87yqBgmZ1FJKFhjJjxav2fgD2GQ67jlMPaRmy5uuiAwNRoExJM68GM7Qovsx/kHxhGJ6qtnar7+47MObih+ssyjXyeu0aLuOD23vL3sHicwHI83YNciTpvreeRTSq9uwYRbv48T/F5RVLVp7WWJ5ISZt2ncCgmcUbVikbxrafk96YkJq/ujbdA5xqaixjdy1SYPVpL3udB8qeRKmHz/nkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RwyRUVCe6Y5eM2B9b/pZJ3y2v8Fp8GS8vwygW0BbUE=;
 b=Ac1kG1F83ga6d02tc3F3zRGGN7Ne7OpYJeswG5MFEwAn1cInC1Yw1HNQu57SgKC3aUY1HGwcs9ZQOJwr5WzAIgcHXcs01Egz+8nHndpawT+4j0ummaghJfgn+v1nIwMcQGwzbyqX48pAIjdnfbhr4NCtndkE7Uo1zivnj/XQbKdZ3qaLBub88Y7cm3FpVf9hmOJFHFSvsZQXn5sfkFfXz9oQLE1ppHwBS856xm+YBrQW+QWoQOlaeXlI4eFj2KTJdN3M6uI374Vj9msnbZZA2sVN1YTwWkpt04h9QddHoVQSH7qC3NmOE58kwBeCuEPcSHWci9/slcVrN3Rzr8ynPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA0PR11MB4608.namprd11.prod.outlook.com (2603:10b6:806:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Wed, 25 Oct
 2023 07:06:57 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::e14c:4fbc:bb3:2728]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::e14c:4fbc:bb3:2728%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 07:06:57 +0000
Date:   Wed, 25 Oct 2023 15:06:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        'Paolo Bonzini ' <pbonzini@redhat.com>,
        'Sean Christopherson ' <seanjc@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Advertise CPUID.(EAX=7,ECX=2):EDX[5:0] to
 userspace
Message-ID: <ZTi+iTwNh28Amkp8@chao-email>
References: <20231024001636.890236-1-jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231024001636.890236-1-jmattson@google.com>
X-ClientProxiedBy: KU1PR03CA0041.apcprd03.prod.outlook.com
 (2603:1096:802:19::29) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA0PR11MB4608:EE_
X-MS-Office365-Filtering-Correlation-Id: 5af1a9f8-38f4-4c56-ff48-08dbd528fa20
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5tAaRXyEKW7SLJfjjsSekzWHVsvPPjD/vYNlzcXKPCZ2rCs1iyMp3oVH/7lMv50Oq5v6j6K2ks6PJTgB8Im+SuP/cLr4LOBDZ2PGjjKoTZDlgjTQVTBRvjwsjQzfsgS6og4P1LmG3AlpqPooFGuzIeBI0pg64Dl06Yj0E7aVDJ6NpbiNi82xKLmN+LUpNfBc6w2Jm+PO/HchoXjb1oTsUCf5UxBqNXj0t7GpSgJlf+c9zC9KNTLGmrlZItalvsCF1iSNgpGzc00ofwVdD3yBAQ2fcHh/FOaTQONcRD/2tnstTCdBYYoB776an4kU0cqiVjlsNlx5l2NVdBqFuq/WYXy66VRl3h7CvYoy82AekAC3klA8GvA0USAW2j9Cd7N74uQsQGgIzJapcXbLApkcritg9wV5hG9MgV/MD296k7G0APtzmiIXSY73jb2ABhep3a+MDtKKlbN3uSFn5W2yNPwknBcJIQ/ZR6iyI8I8zNk8L88jxj6mQ0jiSxHo1GRZiseBPzp2B+0+j+Na3GMK969vh/hgsotZfCIbAfeI1n7LEuE75zQJ7QJptYO3uRwBmCoNM3xmQlI3x7t/9WqBTwCGM6sFoUtbWeHwdGbfoHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(136003)(366004)(396003)(346002)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(33716001)(26005)(38100700002)(2906002)(4744005)(41300700001)(44832011)(5660300002)(86362001)(4326008)(8936002)(8676002)(66946007)(6666004)(478600001)(6916009)(6506007)(54906003)(66476007)(66556008)(82960400001)(316002)(6486002)(6512007)(9686003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ssMi0lAcbZVPtgH4O/33TWVmmCx/d0b6NkNMOg4bqGwdrnVH69HXBcArHHjz?=
 =?us-ascii?Q?RAUNuCKQCJoqocO6YGeAKN90LBhBb3JpA4z24dh3f2bR3D80Lq0RkGvCCRNM?=
 =?us-ascii?Q?FwDcHxkTnEPcL+7x9lFG/LA8ae/hOaQFKKPhsAC2kgQtgvXfBS/VbRPF1jTR?=
 =?us-ascii?Q?6u0GkkLnC7whpoD5SCe1YIIa9A/feC0yiYrCPnvqbLiBP0QhyNac4PIogqpD?=
 =?us-ascii?Q?wLPyNwghewz5URFMBaMwh/krKNxS+qcvUJzZ2u/29e2GDuK16MaM6xzKwlPg?=
 =?us-ascii?Q?mwHUgMVttLbgSC9JRHMoXJWujyGoBlcCUwil03LfV6hd2IZXChjVcm47Tke8?=
 =?us-ascii?Q?urZnNjC+Mu9sVV7x6fomO/ybsATvwDq/cQ+ygBJBaWQHdQuo6OltHRQjTz+d?=
 =?us-ascii?Q?NdFR4K7DaTvc2m46p/l0fza2dNUUWvZwhNQjwYdaK1v6AVCBlQeb2m2oE/vU?=
 =?us-ascii?Q?+dUAQR2+Spv48DX5bT1xIutcLltRX4CjicH8AugpjMmMiNlsnNfoZnXNK1OH?=
 =?us-ascii?Q?Ob74KD/0DWBOGlJiAwbcoklZ9SL6j5FGCPjcZmaWJ/7QaiRHnKiVCpvSOJ5U?=
 =?us-ascii?Q?+4sGYgRvLN7+1TTfD1cJdhsWMRjSFKDTB8sv226H1OU3ofnDRptLydG9wx/M?=
 =?us-ascii?Q?f7SXu0lkCq5cHPfg5YYGjaaWeGyZmVSNCNMFYgsgR9/OEbQvCW3141jaBD2l?=
 =?us-ascii?Q?s1DUrk1D8HSLRWtlxAaC3bK0T9iqNaGbSoRimtnXeyhsTUiUMXzNMwtEimCs?=
 =?us-ascii?Q?v+T4MYrJni/eTaUxz+xb9s9k9dweMiIqo0SbrPWuy5IVlf278k8ibrKqkwI9?=
 =?us-ascii?Q?0tNxdZygm43tkyNGSh3grhEMaOJQ8emnBNqOqZz0E3ee+hVuQ6L55dR4DojE?=
 =?us-ascii?Q?tzR4CJzcpuJVFQHWQMmbludbAD8Ahk5gYKMc9h86eteF1y+3Ivoq05NAe3Qw?=
 =?us-ascii?Q?m1A9VQssS5RTMUn76Tetwjvdsia4eIR71LONnuScaq1MbXI3K+/+CZGba+I6?=
 =?us-ascii?Q?snFMrOoxDUy3yZpbKoItqY9muFPWZyUVrJyMXSWNUGrr8e57RWsXergrLpy9?=
 =?us-ascii?Q?VyO15HsywFedRVzmZe7r3fIup1S1phwtFbdk4UF4E8ff0Y0U5Fo36+a5DI2W?=
 =?us-ascii?Q?d3CITFiu+TC2SfWg54WBVmiEmvpm8KU3KICAdDnXOpz0l51gpr+ncmhZA93R?=
 =?us-ascii?Q?5VFu0l2mumdkPu1fwfraxhaAeBZC53hb34bXN5VjwlfJ+cw5a46+Z3tXp+w5?=
 =?us-ascii?Q?+OdMzxArHj/17FJu7dA6saqh2a0HoMI+7DSOs1l8Ez/G09D68AKWsc4Erp/2?=
 =?us-ascii?Q?azJGVXvy93jKGdl1ldpGB4i5IyP7Mt7R74s0QsB/AqBnY7xMzil5juxW3nF5?=
 =?us-ascii?Q?+s+ezHCfDDTuRV6hQSXyMjRRsex3+yFC7fDRaRVpd9qRSpfw7lmyQ72FfVeh?=
 =?us-ascii?Q?phbvaROUThEnFEVfI2013C7vwVh7zX1E3rJ6eHLvnj6STkmnmnLDOqIhCngs?=
 =?us-ascii?Q?W7lyOCcAChbu/n6RYaC78rUA8zkCHVate1bQ4KSebEkRqyFembleABo7OVGx?=
 =?us-ascii?Q?zONkxu02KRETjnik2ebEs3mrvc30apxB7mNIdH4i?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af1a9f8-38f4-4c56-ff48-08dbd528fa20
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 07:06:57.6123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgAJoZgBnxcxPT7uJoiQFLwueWIbJ1W9koulFrSmYgGpMfffoaDiZ7k4r7hQyyen7KQfDcp+RsiTEVk3l5UrQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 05:16:35PM -0700, Jim Mattson wrote:
>The low five bits {INTEL_PSFD, IPRED_CTRL, RRSBA_CTRL, DDPD_U, BHI_CTRL}
>advertise the availability of specific bits in IA32_SPEC_CTRL. Since KVM
>dynamically determines the legal IA32_SPEC_CTRL bits for the underlying
>hardware, the hard work has already been done. Just let userspace know
>that a guest can use these IA32_SPEC_CTRL bits.
>
>The sixth bit (MCDT_NO) states that the processor does not exhibit MXCSR
>Configuration Dependent Timing (MCDT) behavior. This is an inherent
>property of the physical processor that is inherited by the virtual
>CPU. Pass that information on to userspace.
>
>Signed-off-by: Jim Mattson <jmattson@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>
