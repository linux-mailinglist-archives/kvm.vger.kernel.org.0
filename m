Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309A86FD2DF
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 00:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjEIW5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 18:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjEIW5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 18:57:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA424488;
        Tue,  9 May 2023 15:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683673041; x=1715209041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D20nlWKSSkDDkf2LfQ/RC+afYZsHp4Z5N5P9mLjifBU=;
  b=ZgtoZZn6hMiDVlwjne+OaTbalT5QQHb/wL0ego+ZVT89zQWaILamirGE
   jSZuTuQOBESd2/V65hlRcy0YzPTdl0VQ6Re657NKVlrxfEcx/2M3VKkfS
   fUcMkVX86GE5WBSmh4teUIBYQjy5UiWOOus4lplYdSf27ZdxwJhhCU9WO
   8Gnoa9tv+ayXz0k+togvN9j7c7ApnSzJtMYnM18yHHIPmxv/H8q9XRq6R
   m7NqjMYJeQutxqa6rU/lyQr6q37WXQWGwJI7Sd/6hfXgKZe1Nxt4q730y
   qToiQXvvYiw8NzPTLHEYJh+ihBBQEKURMxrkVl37OBU3bavzNS6WSmOVd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="350109799"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="350109799"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 15:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="699065697"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="699065697"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2023 15:57:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 15:57:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 15:57:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 15:57:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 15:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpTdLH4nbFd69y2jFFiJh/TjZyVrnoO5AnJLbMzQmllIm0VGIYvuO/ISAmttLz6Qb6WlGcgiziWuU/ow444LOrbxhfW/WE1x37MaGHz5xkXMGMzOE8HWvofD1nzWBrwdVI283mVLaZiUIba0dsTXTI9IEF9DzkQPJaNdqlAkJxr4VIiiqc9ITp4kDdxby/lRqPrPHyzcZ/5KAGV+SlQrVRSoZ+h+B56kkcIinK232FET3XHci/IthgtekBDct9yLrcYwjriG9tav0HO6XAm0+ZQ7dtr5oGAe0Iw5o3opggyemT4c3dxH47U9jBwFkIdwJdZljqVC1SAPOS2cVp3ksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75IHVVB0Ew4t3g/ZNIjYitNSwigrxrwgiZtpksfgczk=;
 b=RXD0f4vORYCRO+J/QiK7vBIhSAp/FdoX4g6BcSl28+GuqEhITse3nXOy6C5+eQFQPdkg0I33IlMcC7qIZq0AkJzxsT0leCVOU82z6T1EHFfl+9Bybqbl5YTS72vLuSS9I08GS5U9aDemhIAhyY6hL+P56oRX2hujjS9Ltj3qkhf9JxqL4ArYrynYi+m9eSka+oNTJF0pMoFMgYOp5TLRiXfaRCmIMuQykegpvUdGDCNCR3WFFdkwJhlUXE8YsgozPOqgZlbEuaWjrbq6pLNbTk0LKokb8zjXb0wbMZx3+h6yfeSR3g9RpmlcuIQO/MEwsOS87FkSuprmfiaD6jZmFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 22:57:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 22:57:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5AAeawOAAABU4SA=
Date:   Tue, 9 May 2023 22:57:04 +0000
Message-ID: <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
In-Reply-To: <ZFrMneCMKuCtu7JF@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6083:EE_
x-ms-office365-filtering-correlation-id: f7dfbc44-be99-4d7a-1722-08db50e0b4f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uO7+bDEyDJge7almVkmdQ2Tc89sxpmxbDh8LqgaBYcWZgCf2/bq/ryShngp+g82hcSZ3awkKPL92UcD8xaQBRvlq7Ue7ROsPjsPAFqUjvM+Yp91z48m8jEdHHi271ywNK94MqRbzmw4xKVna2bhZmin6CV2zC788pbpAdTVMiRtfICqIAClrffHbi2eFczC36Sl0NoJsvIl/XqofsZFtR+Fp5/39naYAUWyuWODPOxMTbXMUmuzGCA9BiZho0caWHm08BeV0vO0IglxzOQEgFNk0AdMgsH8VSfQ0abzW9CKHBVDY3xLaQ1ijAJSvi0THdP1JxiUqwgyH21KCnnx+fuXrVQY6GpcmnzYiw6u9ZK4dsbAHiqh7un2rxzqLwovnCp1a5V/bQufujND+bs16i/ZdLkrHvPpjlNJgIHUP6zd3ahC0EdQcYlabTa3sUz/SrJsTnRiaKD8iMQKy2YRvJuoLMYZKUoUHaCXOGpITI1MIJi7Kf1ib45ZkN5N3buCphBnNA0ProkZ8trvGk0ZJI0pEqgx9nt91IFl7Rz/3SiPU4a4TYkPW+ajqnZ3llGxqNXlM+vJ6ByyjeY6kPS18tSjLH+CofLBzewWoCLFdosSOlCA5N+TeAzthoi0ZWP6S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199021)(86362001)(33656002)(54906003)(4326008)(478600001)(66946007)(7696005)(66476007)(6916009)(316002)(76116006)(66556008)(64756008)(66446008)(55016003)(8936002)(5660300002)(41300700001)(52536014)(2906002)(8676002)(3480700007)(122000001)(186003)(82960400001)(38070700005)(38100700002)(9686003)(26005)(107886003)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4flOJuUcOrHX1MVQv053xOlUvH8txTWPGsNJWvZQKgJ2GJJo3ngUOvOjxvDo?=
 =?us-ascii?Q?tGSms+YN+wJsWWzOjyMuaBYH9c0oVbPDj3/yexmJ1Z3wDE2go41QS+XN1PUs?=
 =?us-ascii?Q?2nlpzII53j32v5qwRPzS1cpTitrA6pBAbyXfb8/PokQPiZgBUdhqNRhrBszg?=
 =?us-ascii?Q?q/Wu57JYWKue+pmWXjGK8JpPTuoZFhzJUdprAzAJVQ7kiApMD2NrVBpeAvlF?=
 =?us-ascii?Q?Q+ZBPW0IjXuZIfILSii+2amGEH3K5Sr2FJIBD8cau+aPn43ef6jdwxGN6wvK?=
 =?us-ascii?Q?DRZvwoLRTJgH6RmpKMKJ9jVlziPfYu6lJ/1eyRlSjNF0Y5hAPVY4CYd857R2?=
 =?us-ascii?Q?4mHDYsMdpwBG9EJ0DvVnry6IsE/UPNQ39WhEyyfoTw2mIBerWy55pas29CZV?=
 =?us-ascii?Q?Pv5RbYsT/cZfsOkD/VkzSrtNfvtsFpenidUfR9ImgfnmjhYd0Tnrp3OSGc4U?=
 =?us-ascii?Q?J8ZIMIscNKwCSEFBbfMlsqooLAyPwta2fqq8/BUo84+gEs1lgrBKBSqniC3V?=
 =?us-ascii?Q?Hd7bBERQdJweYv/0ECneeAheoai+RKM5y6P/HAL7eICxXmRfzzRx+Kf5DlXf?=
 =?us-ascii?Q?gnnXDhyZw7Dq+NAFp30Odfr5O+Y99GBRwiBZKBCQAwnNYKHz5DZYtVw9NEgX?=
 =?us-ascii?Q?n66KnV2gXlxMnJC2i/2hAn+bVQUr4eGETBm7pm+V6kTUxAsxrGOxuIC3UvEg?=
 =?us-ascii?Q?uMA4EMfsopMxAwzZ7H0FGSibYTCM02ltdIBq/dAhpaA2xWhrRG0aM0VQghpK?=
 =?us-ascii?Q?gK/wNos1n1qzyPARrTbzu6ii584pEWZyPdtg55MYsTkEZGfGNtk9VwKYJWtT?=
 =?us-ascii?Q?63c0sg+IoSzHAjfFzl0ZL8TJD6br6Cz/Zjf/m3sWz/AEbLPl2OR0CiGbRZl3?=
 =?us-ascii?Q?mHhDNyUizRDktJGMco1GugtcvCnZzNmFe7eaY7rK6uGibwaNww1BxbH1vrW2?=
 =?us-ascii?Q?8SGVNV3Zf0yg8R3CkDBYAEMWDDgmz4fWj6VliuMvHqMH4sBoDaptG7cp56Wv?=
 =?us-ascii?Q?dSiKlkwNlD+Mi3j0Brpn79aJ9rM7sdLL0BqDuBMozV6b+FqbDzC43mKAsYhS?=
 =?us-ascii?Q?L5IGCUMxkR0vSF2zHNt+TXCDx6tPH7bexCBjRbLgIr3EpFe9x/kgAIWpA6X7?=
 =?us-ascii?Q?c66OXQIftR0/WNv9ZUgck7N+AhVCmahNuM0DxOHNpmDxPuSzH3Kzj9ofRr8/?=
 =?us-ascii?Q?jzHMSNkF/d9Acb23EiVrXWkColtOlV+fL1UK5btZVqAgtMJB32janNAjKwlh?=
 =?us-ascii?Q?bxbry/dEaLmwx6Nvwt3hHu9eIr3EvT7G+ClGExTP8Z1mZGK8TTpwu3RpKGYb?=
 =?us-ascii?Q?0MUvtyTS7mnTjbPPCgM6NaAqdLul5UxxXX5qoDyHlgB54TXE3b2SN8DaNGnR?=
 =?us-ascii?Q?fZa8j6D2DI8YUYqU3kjcdfIwgkY2+UeTASXku4LTqcQeXjfnnfKN/3oX8nGF?=
 =?us-ascii?Q?UV++m6yPIy5n9BWxUjRWNZHbNxuaZVXL27SW1sxYMcV9JjDkNWZRZTxNL9EZ?=
 =?us-ascii?Q?myC9Ucd5hgHaw7zAR+k+/0QGthdn84JyrtSl3pxbuMFVgMDUawJMiLfz8MOK?=
 =?us-ascii?Q?14BGxm1S6gLX9cWAa2tSPZ3bTuuxeVX4p+Tvutbq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7dfbc44-be99-4d7a-1722-08db50e0b4f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 22:57:04.1587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOyy25IWR9E4CA02WevfARJ+KL8tMK9pLPsRVL/QHQ+XChn4aloDuPi9IOhjwo6VwmTnau9K2XpaUtPvB/X8AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6083
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, May 10, 2023 6:44 AM
>=20
> On Tue, May 09, 2023 at 08:34:53AM +0000, Tian, Kevin wrote:
> > According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> >
> >   The PASID configuration of the single non-VF Function representing
> >   the device is also used by all VFs in the device. A PF is permitted
> >   to implement the PASID capability, but VFs must not implement it.
> >
> > To enable PASID on VF then one open is where to locate the PASID
> > capability in VF's vconfig space. vfio-pci doesn't know which offset
> > may contain VF specific config registers. Finding such offset must
> > come from a device specific knowledge.
>=20
> Why? Can't vfio probe the cap tree and just find a gap to insert a new
> cap? We already mangle the cap list, I'm not sure I see what
> the problem is?
>=20

PCI config space includes not only caps, but also device specific
defined fields. e.g. Intel IGD defines offset 0xfc as a pointer to
OpRegion. I'm sure Alex can give many other examples.

So it's easy to find the gap between caps, but not easy to know
whether that gap is actually free to use.
