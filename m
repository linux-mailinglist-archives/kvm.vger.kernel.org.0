Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7065660D91E
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 04:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJZCQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 22:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJZCQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 22:16:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59C59D514;
        Tue, 25 Oct 2022 19:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666750579; x=1698286579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vFg1JRTxUsdU3HqTB7fWrxGpsH6nWle5wqrlWdUtEQc=;
  b=Q2cUAo9KjON3dTkqkC7ZyyNy827EV524aX+NUA4qrfTuOwsFLMVtsc3/
   dYyhF4orVxTtT+06t/J3I8XZOc3Lbzz0MxtOkYL7H77dMCY+rL0KG1izo
   9548L4ACoCGUabf8N1xZnVuFGIbODD3ZYHu1KimsNV5LbUBUNy33qlG5L
   plTSCifgFPPg9g2JJ3tfUsX/e3OsPLYmDfMRtQsUz6f3g/jqWu7xxeywP
   a//B8F7Hmdn+fd85H9MVeEooJV4F7xu7M/GigVq/xhbrQa1UupZmf694d
   PFkWcN+aRGiETYgLPLTE2z7aiUCsIud7+b79ZU3d5dKsYWPoRJietBCGa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="369906334"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="369906334"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 19:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="806885308"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="806885308"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 25 Oct 2022 19:16:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:16:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:16:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 19:16:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 19:16:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wzv/7J4wwtM0kuBfPBm/YuO5kqn2V+VRjo/o0WwJQ91EQW6XNc3qewhrERf3Wg5suulPSDgJcwHRxqXAmzmmACHTyfPRjVkDfBeAa6EQdjNZ9QJ9FpXOeX9EqnvbNFlLuLlQ7+d7PGYJeFOzmvowvpeB0TgcgMnLTdWsmZQ4LDl8KxbPeTsWI6vgaFa13Mt5oFS+JWT/nTHvPFYreynXNqacyMIz+L86C71ubyPQCmyeHrCvn96aSQAC/RE8JraidN0HrrRxcHZyXSfO2VBFbewQjTCAm2rXAkXCa76AQy5KtgpBgD+7ji0IhY5rEyGC/hXPT31r3zrq8H1dAlcqYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1D16yuHS/z0rAQZ1AZTCC6fUNaUqgz4W6M3qtOgdaPs=;
 b=f7H43qRC8uywFU1FN8RcLyNoVLM60iJFK12Y54goTMVrFNY06lJdsMwJ2RYXYg43Dafk8esv1sTb1+gpSm5lhMADVk2TK9O4erTIGzbEYLwd6QgRnAPBrY+f9xtNFQCbEPdpJTqshInJqTl/Ck4aIEtHh+obA5bVSm5rmWb2srp1td2n1pA5OTqZZ4+ZUiTP2cETjY8XQA9HxGlNLJTP60g00JDUvUH/ODIBU3+pfeTKHTlfwid5OHSpsNNMsUTkIdPirW7gFdc/Hk84FDZoPY9IeJkqUbQYHAfEyvrpFpzyUX9p171zdKpsWd0OE6DazXpcxzigag8CSTic5+nP/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 02:16:14 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Wed, 26 Oct 2022
 02:16:14 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 3/5] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Thread-Topic: [PATCH v6 3/5] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Thread-Index: AQHY5ZK9WB7/4eYpskWM6ax5rvhZCq4fMIwA
Date:   Wed, 26 Oct 2022 02:16:14 +0000
Message-ID: <DS0PR11MB63733C7CA0B1497215B40F8DDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-4-vipinsh@google.com>
In-Reply-To: <20221021211816.1525201-4-vipinsh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CO1PR11MB4963:EE_
x-ms-office365-filtering-correlation-id: a5c7c044-bdbe-46b3-8268-08dab6f80f15
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iZsKN83nKqgu/CRbuRZWSTgM4E0wnpR3VkLiewGQCm7zXJ7VtfbFNJbw10Qvki3k6P7pPICfdktW5EWSwNp864iHlGEZB08iuSnW0GvCSdeCEWjrzqF/68ZHsm8qcO2OzXIMMND/3ON6IjhA9YtEQxu5pRTs4FcQY3BsOeDWsjCn43oCs65ywj1DJTZxImtoP/zfxB3Or6q10yP2ykDGHEgB8XWgOyzrUhZYUPNwXUhkNtAR6REe8QeM8PATya6+lhzn/34JVbPrSEKitpsjS6O8YBZE9aYVvjj7HI2mF0x5uUNcEckjlwmSPpCBgcuzubeQ/VHGpgUKrnV11o3USZMzlm7z1UVm8vg8d8OmwbHt6rTAJ+Fc17TkskiUMXHKiZw3sMHt3hzdaBoFrk30sWBnh3r4MYPyVxLSt45WlEmiX+UcAG9OgXVZq3PS9wZH6qIhXpEXdTMa144lpa23AEDtm9oi9gjVIBq3XabX4GpVh7joOjDzO3Yj7PkDjlGOYYk5+VL371y9OZ831gYVcFBLbzBObOmIMOpaAeJKmyOYb5SaPUMgr50Z+ZQD82X+B5sbbZM1SOABtbX/wXPD61d9VuTWL9go62laAr7onHe90T2pP/UYzMOBrijkl51oYywuTBgicf5l/A06y/+MqwhX2w3sn5Gc6ftRpSJVlN6U/d+sANzS/r9SeRStwMN4TtH/sSphivIuzeGMkp//Wm+fmHjzH3SVNFFoDg8z/o1fPjiPTo6h9n6Epx0T2LYJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199015)(316002)(110136005)(53546011)(54906003)(186003)(2906002)(33656002)(64756008)(8676002)(4326008)(6506007)(7696005)(66446008)(52536014)(8936002)(9686003)(26005)(4744005)(41300700001)(66476007)(66556008)(86362001)(5660300002)(76116006)(55016003)(66946007)(122000001)(38070700005)(38100700002)(82960400001)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LxECocQemRhgB2K8bSiZS98iWdrw6zBSRyOeDxv37EJLq9aNPta7p3tE48Q+?=
 =?us-ascii?Q?4ZGGTvTLPwGGwatsmWOASfnbXTA4SpPzrVTSTN+34RbM1bYMqYXCxuLXfJud?=
 =?us-ascii?Q?krhOttRb8v5u5IMxnD2SUChB7qLH3ed7G0khRa6QLAl0wV6bj3zI8iYWSu9K?=
 =?us-ascii?Q?hejiqstghDzB/pQKcrOLWGCgnVQYQdPUlrn6Lbgw0CG3KIiF3DXJPg80HxhW?=
 =?us-ascii?Q?a1H3BMY/ixkleJvnbh/ahkaMSpKK/BkJfm69bsYWN+wWt08Jbb1vXV+E17vp?=
 =?us-ascii?Q?9vHyrktK1T+xD/RWFyHEcxO6T1Zx1bFlkCZKTrWln68+UAEvxFBX3EMY9Lf7?=
 =?us-ascii?Q?8aADw06EW0zM7TjwradDHC0u/zvqvc63Pqre4AfEYF3ezSHFB9cn6S8QoA8h?=
 =?us-ascii?Q?7p4uYpBpUyQygxKA88GONnDktkf1MQzNeaSrxxjU32VztLcNMvSkJ7nm/qEp?=
 =?us-ascii?Q?qWKWDTLLqwt9zlTHSAz78ShWXMbqzp4VtTW7u3m42DdIuNFH1KF/ptSZYI6v?=
 =?us-ascii?Q?As4FwijC+xfZSk/rfmI8bAVkuu1Dgofmjaxz83x0RaAcwec1cSjg0jmsKCI6?=
 =?us-ascii?Q?YohGBgcDVihc+YdRYTSsaRArA2btYuvaO68gA5agj0J0+isnkq4ul/s9DfAG?=
 =?us-ascii?Q?HNMVRM80Gt+UcC7Y82oP9+UyoQl/2P3lMOBNfRTIcdkOBmhvqPLYxjo1B04A?=
 =?us-ascii?Q?rDokLA0L+rQHJP3EjzvUa8DeRsCSOpXuvhOCL4W3z6yOvAjKLNixabqnXykr?=
 =?us-ascii?Q?52oL4ENadWn8jUMVCdeMHp4LuJGXsbayznatjA77ONSNp+MCCZH0XZyjkpOA?=
 =?us-ascii?Q?firAWRFk73E1j/6mnCxIyOz61eOTPmTZDBrb/E+y9NNdM6aehqAnj4Nvm5g4?=
 =?us-ascii?Q?WSmDX2BCFy1hRdvuoeLGalABrkE/FqXGUtccV0mCjg8dreLrjvBk5qF7HHtq?=
 =?us-ascii?Q?VJI6LfDBpaGCrdqgNSQgLSdbASeYTEVs6gNvQaqEmkkyYZsqKmqgyFbm6oB8?=
 =?us-ascii?Q?dTT+1nq5zmM0iggWHpYoA0CCPUS0ZspID4uJNVa6tCNuXHFzwpte/Xn/68Mo?=
 =?us-ascii?Q?/9o9MBUinQaWhG2h85X14mS0lSw/uDe+mCGQp9HaCWKZKEV8XE1lkF7DIzH7?=
 =?us-ascii?Q?9uk/aYWGldJAV9xGe9HoZ8yg4PP6fWax1w4tryfC3AG6qaa+SDVAI8nPrGn4?=
 =?us-ascii?Q?OI1hopGP2KA7BcHMNj9qDPvpV/cwUpkT5IeNvDbN76oXOW+bzyXAYTKU8HQ/?=
 =?us-ascii?Q?km9eGPpnZGZxTBuptNahcz8+130dPfkMLZJ4LOBApDoCoH9fT1a1nbNwDxzq?=
 =?us-ascii?Q?YRzZRBh9r/i5pZVzzw1DMvM77eEAl9rr6MOD/sA7iMRRcqiE1tZ3+6X7nPtH?=
 =?us-ascii?Q?drZnfPjq6cvjzt72KsXMD1NqwVWUAH6rK6YZOh//8nH5H2wxCcWppovC8aY4?=
 =?us-ascii?Q?1sJnCoRcwg8cEX58fV/7mUwLTfkjudFfMYrtQ8MCcfze6UmfIol0YA4NT9+A?=
 =?us-ascii?Q?uLpcWcnX5wkOg6L6PGmLzOVL4BecBSRnQPWRqcfC0mORkf7cY6z5/BPwQ22p?=
 =?us-ascii?Q?YZbxuOl8plguQ3mVMQLCTt9F+2T7rbB1khKCl83I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c7c044-bdbe-46b3-8268-08dab6f80f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 02:16:14.7090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IKAKdwTHDOo5F3UrTFtfD7a+afzPJHrjaIia9I7k7kyPjm4SDe1HN0glhN71jLX8hAUdW9JgRNhnKO+dyYv0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> +int atoi_paranoid(const char *num_str)
> +{
> +	char *end_ptr;
> +	long num;
> +
> +	errno =3D 0;
> +	num =3D strtol(num_str, &end_ptr, 10);

Why not use strtoull here?
Negative numbers will result in a huge "unsigned long long" number,
and this will be captured by your TEST_ASSERT(num >=3D INT_MIN) below.
Then we don't need patch 4, I think.


> +	TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);
> +	TEST_ASSERT(num_str !=3D end_ptr,
> +		    "strtol(\"%s\") didn't find a valid integer.\n", num_str);
> +	TEST_ASSERT(*end_ptr =3D=3D '\0',
> +		    "strtol(\"%s\") failed to parse trailing characters \"%s\".\n",
> +		    num_str, end_ptr);
> +	TEST_ASSERT(num >=3D INT_MIN && num <=3D INT_MAX,
> +		    "%ld not in range of [%d, %d]", num, INT_MIN, INT_MAX);
> +
> +	return num;
> +}
