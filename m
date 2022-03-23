Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E787C4E4B62
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 04:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbiCWDX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 23:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241479AbiCWDXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 23:23:25 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D585E16E;
        Tue, 22 Mar 2022 20:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648005716; x=1679541716;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XIfRWjEGfNMX6ibJfPtmnxSY1SMu9id+mL65MJpDFqk=;
  b=JKGKA4o0Y+jFGcG5X4o+QvfRkXqX4GdNgfamMIkfe9mxL9fQ100PYHZi
   9NV/znJ0+etptTiFbF1v8SQ1Tcp1PwI0P53jnwKEYs46Vm60RJhHoy2Mp
   Tk2kKoC3Xv5ognciEgvWcZbyk00wMbL/+M1PnXPB7KWxjz7IVaJsFhZml
   m06mjGlzjnAMjhk6yW0J5wX8r6TbF4Nhq4dYSByacLQ5z1ZjVNWQWr3e/
   fc7nZv78K0RxkmO3FygMY+gKz58kexdYnlwyw8lBZAxwdT5SbQ/2/ZjHZ
   4QVZBO336qJGYnrtEUPpAfHcvKlHuEvdAIYjEy3xPrwUMvDXn093kRQM3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="318720294"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="318720294"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 20:21:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="560710185"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2022 20:21:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 22 Mar 2022 20:21:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 20:21:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 22 Mar 2022 20:21:54 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 22 Mar 2022 20:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7ddt7VEBywTS8fW/AX5b8xTD//zICbObdIGhSCQAYUn9bJKt6nzmlg0bsFAvlZNpbQjJfdxtWLkfEgqIfeXxPR2LjZWYz48K0S9q9nOX/XYRSH8DZLWgelci+IT1eGky6dZE1+ekXRE3Mlxn1G72M3j7a0hvJPVQM175K3VLAq8dA7icykIr51PUeZTJ/oxuiu9b/aAbjCpCBQu8Nz/bxx448/JM2FaeXTB0a05zsa8bjOaKtHukkrQl2IC6Z8JJMZ1+FEVgZ4bwaqUopmTk/kgGiLJYKmWsQ1he9/T+V7aM82QLwDTabN2vS7OjnEssf9fi72ZhTBkR3RM0yxu7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcXeocYqu0zs+VFuDQuS4fGI1abH8BJ9GQ7zPnMbFk8=;
 b=kIpbEUnhkuoak2uMJG7PLGfckRQe68IolXX2DW7nHbNE/YBgIMLgP9wTvbHr9OkJXNynj8fp7lUNV1hNeSyZUwM7pv77P7W6O36DK6ebxMMZr1lZ7yS9NtruRGonAy/iXFUy3PdaS62Aa/yViywfa6gUQOzd66IBdJAs5iK8JRgsmIdh+Vo/MB0ACXI3RL2gnoF0XiGsK8AwkJAZUEQhK956/A76BxdkMRvk93jLwfDOmHRf3sGZUpKvA7p84RyVHqQDNCq/qtZmbTDsRoqulvTlWe0HQVLrgGszX8JA2gbRfwNabbRcwxOMC8xCeSUlaGner28IDfAcMe3wREo+Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR1101MB2094.namprd11.prod.outlook.com (2603:10b6:301:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Wed, 23 Mar
 2022 03:21:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 03:21:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Thread-Topic: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Thread-Index: AQHYNsguZd+eTSAGi0uYcpCMOLG73KzMW1/Q
Date:   Wed, 23 Mar 2022 03:21:50 +0000
Message-ID: <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
In-Reply-To: <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef1d64ef-b4e0-4cdb-735a-08da0c7c45ee
x-ms-traffictypediagnostic: MWHPR1101MB2094:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR1101MB2094289C56C923445EAAF4078C189@MWHPR1101MB2094.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DWxw+5e/b4WSfYKtHjQwVgovckK9W9ltTTHmGZyRPoeU1IPWTs+rz63tNp3JVyZ0YfyptmzWM82TmgzM1VDtzIqZNxmeCwMdbsifvipu3CVLPA3EmuNMRfC8ugs6c560/rY1/VyMZUtBx0bU3xg+2IXJJv5iYnXhPjw0D3MbgD5YoR38lfK0/qgl5nYibqpZOxjNl+EPHHSagKdGnRcf7wheBcB1cT2fqbakOtt8RWTcHNVqOK3QDN3NTiCkReaKJ2/xtFwoTvPXWwuqztYXAp49Esafn5Da7a7+qB/qrLJ0l5qHr8w9fDFkHPj5h+eNoOxjMjCsK5/ie2KxB6LRgwcG4V89jmACxQ8ldYp67oDHP8dJHM3G16kz5EZ7Zg1oH8uvStQw14RXIRfR8hM5TR3QIfIbxFwMSCr2BE0J2FtIqPh+DSEG7GLwUIy4NUVkU6cOHnbCjKiWSulIqDPZ0Zk1B0d4GC81VeW45gxEEnG3HuqhP+1x0EtuGELbslHvhwUwacsqerc2YrMM0Cs0lMcQ82xp+VhFHAbWn1D7YcbwxWzrNqP47PqUTTl3ZICsKN+xkgkKLEkMO3paxJrfT4U6L24AlHo+G3Pgc0+Kal/5GnuRmkjWRghGE6qoAm/EOR38plm9xGKy3qgiNEZJHpjsSNlaW/f1woj8uiTrz0icWLTL7LM77Zm6vl6sQLeifwv915aD+8B/PPr91SEhJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4744005)(54906003)(7696005)(8936002)(76116006)(66476007)(64756008)(66446008)(86362001)(110136005)(8676002)(66946007)(52536014)(4326008)(9686003)(38100700002)(66556008)(5660300002)(82960400001)(508600001)(122000001)(38070700005)(2906002)(6506007)(83380400001)(186003)(33656002)(71200400001)(55016003)(26005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6+u/HlR2gIuqALTnLNEmysg+B+ysvND+HTk3zaxJZmslIRqjjW35duWmTdU3?=
 =?us-ascii?Q?ztaXqjExv+rLdRn0nkJKYBJfj/1o5xblTk8PhdL/l0wnz6ZNyPA4b3NItLET?=
 =?us-ascii?Q?wkMhxfjuwwp1MuoethSI/cHxrgaVPd/65tR8uBWIzE2MFvYy7DvPQS2RZjRa?=
 =?us-ascii?Q?CuTYaB2BOyBOaClKNA9UnoV3TcmdEIl2oPxE25xU1iEMt1ZtcE1usE9e623k?=
 =?us-ascii?Q?HEL3PDfarsVw8d5vJHn9UMTZ3BPY8JrmMYVCFr6io38+MasmpKi139+YtuIg?=
 =?us-ascii?Q?8TF8PozI3Lhd3llaePGYLMHMap9xvDAl1ZS8+RK7ERxGAeDoyGoWQ0MqM4yJ?=
 =?us-ascii?Q?vyg+JJoE5Hu21bq6JuFiJILfou4snSX9RMoJQDGNepnhjQNPfyzJ+uCaYcQe?=
 =?us-ascii?Q?mSTPhwaBxwj5s33Ze10W4hPKEjbY0f3NltvhMufRUVT8ou+sA6GmO+QgIxJ4?=
 =?us-ascii?Q?Ys6dXtozZEeFSHd38M/CaIgHqcxl/dagAmCkLinpBXx6Ca+THW4QIGBipWY7?=
 =?us-ascii?Q?SDct5oQWem9jJkk/Nt5R488ODHkkaAr/F+6i3mSplyKctCVhf+67g3bDd9eZ?=
 =?us-ascii?Q?oF/tBDKXldAeBp9gX9WbpuugTWLAKNe0PmYu5yUOEzdszUrUSSV4zIeX+wHS?=
 =?us-ascii?Q?G8ojFpl0B5T4Mx+9dBHZN2U8Xdr+u3xaE5UsjSvTXJL1IrqiBBgGhWog/sB3?=
 =?us-ascii?Q?Wt/KzaC/Om4F+MDJ4NH4kAYiYHvXIFqaHo+8+xiSzI+RW6Lr82ovV+bZIyvT?=
 =?us-ascii?Q?Hk5+v8dO5uByeyoXjfj1ZzooeuZpphQ0e4IpVBs+2uS+fncLEKRFxvOyjkpr?=
 =?us-ascii?Q?xG0dDLzC+U439RUw5UJsiLFJRLoeWA84RRVN7lHRs301pgFBgnXtvsD1E9dd?=
 =?us-ascii?Q?6VwFQlkntzCr2fWEzzcgtXCN/kBLBFsdu+6pG6ZaXoO9YFRc8xYKOO0z4CjP?=
 =?us-ascii?Q?fH4NKZa/kVpJ5KoWXyauZOF9DcJPbq7ueA42ph5lM2u3ruBaoxNxBIP6wmxL?=
 =?us-ascii?Q?SS0dH2YsMZ6N3rktyJa95iGS5WBuw7Che0ZmeMcsZFaeAurG7AW9FUVIypF4?=
 =?us-ascii?Q?xWiIavihO8lKb29N3+QqQJD393VLRM1w9sqzzc+Xcq3NQndiYgEXJDQvY2aq?=
 =?us-ascii?Q?cR7j8TvrLBbGxov3CctH2388ln8htKTgjoUDDm+eyMWRE+uGF+dN6R5T5/1I?=
 =?us-ascii?Q?r+2wV5Xg8Al1CEDqyCzWV3af90o+B/7JmDUFFw0+1Bmd/fWMJdM5Z7TkY2K/?=
 =?us-ascii?Q?S+8FvvEiT3Hyd13zuAmn6SriR/3kq6uKWKMfF+5VJp1hbqooyUfP0XZ9cOzV?=
 =?us-ascii?Q?iOyjXXAODaIUAyBLwJ+gl90wx4aK0alZOvaEqnWhegeam1v9YdY3SFgnwhaa?=
 =?us-ascii?Q?EBe3nnmZdK6bXmHqRHZNS9fxcnU20ZXhVRpAg7r+D618jQ2nJHCqY2b3fbj7?=
 =?us-ascii?Q?9XctwBPFWs9cvrd0aOLVqyNTB9SfHcDb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1d64ef-b4e0-4cdb-735a-08da0c7c45ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 03:21:51.3985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E29lC5qOU3+bGvYivftMU+bhluocjxIJXNMPnRJ7o/DhKhwQV8dV6Hp/LJMpZ39SY3tVQmxoCKG/yKIWDS/kMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2094
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Kai Huang <kai.huang@intel.com>
> Sent: Sunday, March 13, 2022 6:50 PM
>=20
> @@ -715,6 +716,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	if (cpu_has(c, X86_FEATURE_TME))
>  		detect_tme(c);
>=20
> +	tdx_detect_cpu(c);
> +

TDX is not reported as a x86 feature. and the majority of detection
and initialization have been conducted on demand in this series
(as explained in patch04). Why is SEAM (and latter keyid) so different
to be detected at early boot phase?

Thanks
Kevin
