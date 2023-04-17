Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7941A6E4965
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjDQNIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjDQNH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:07:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75A8BBAD
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681736762; x=1713272762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQDEBduLyMsRNYNSy0f64RKBlcrAjWzlXppoMvwD6bY=;
  b=Fu6rada50NRiqaKINelqu7NG5Kk9NGCu/HPahRIOIw0IeI4sw5uKiM54
   /RufVB3vwC5xezzBYipwb01LydQz1QIprI+9xLnTUhl2d5hn+kk+JFmA6
   1M5r15VTK2xZMfkKnKAWcxF5OUaFyb1NMcPiK1NpQIssy4OQpPRzgTfYr
   tWQ/qn+PbaCcIgL0/f9GsEJTfqcoUoaIngYJjiK3WJZkAqTUknapzHgTu
   pQtC9t54TZ7jOvkx7+jeAs0jOQhQY4dvhdJcZVrE+6PfvOUdsz+gB+hYb
   IRiUUHCVpwvnio19R5fsrq516nCCyB7a2eLoszT/U49cW9KdqARe+5cJX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="342379965"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="342379965"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 06:04:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="755310481"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="755310481"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 17 Apr 2023 06:04:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 06:04:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 06:04:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 06:04:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 06:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U57niNSZM9H1CUzPSdu4gRDcNjXjxZWvB6iBD3pV0LVs2G47K+27u4FTp8TY4t3pVzjE6ZwrGfB934WWLzqB+TzwgcYrItqmctVodVof36h+4g6OcU9ZWrOD2gTpMuv4Tj7On4nIV1SM5k2+/MRPFwZ3YK1gXAN01+XRPLvx5hCtY+/5+xkzLRmbkyPUuFZus+zl9xloYq4RQ82GcjRG42rnCDMkamatKs0XpVy/tttr5fbIivPhXWlsZL5E1tNACEuJPnmFP7fXkIZpogBVTJK7OIloUnqqJeBTQSFxlcDtNHjilWu+qvmuwxipAUVG81d8wcu4rTGRQui1Ul+F+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xkz36/qZhgD1C4uJ969+AZXe9C9JUFnwTbwxFV6quCM=;
 b=dsRJdvMb6yih+fBIR5y80S+WoNXso5cEH74/H+HFdbbEHNe/qgNgYipZhJ+f6kwxHoQTXzA7I1oZeNhSGd2J6lQMueT0KVccPMfz+PPqVSaSMJvDYfg50/ez+Sw9/ubSzrYckP6zQBC2lPp8HY04ZmPQeaIRSu6mYmzsXN1BPxR85yainhkaa/6kx/my8oFQ8aGJCZa1949cwYJg4QbOpm24w0zYT1jXMaObivUX0du1odQA3OseUr2Ux+1LGQe7EYfL9sd2a3L93ApjhcbrQPDNsokymPgQRwwJwb6wGnCGXcNaKF6qLGjMaLKWGa+SkJs+zCi9XuQcDMqFHt0Mfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6030.namprd11.prod.outlook.com (2603:10b6:510:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:04:50 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%4]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 13:04:50 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Topic: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Index: AQHZbKu7SCn273Q8LUmQ31uY2aWRUa8rQEmAgAQ/zLA=
Date:   Mon, 17 Apr 2023 13:04:50 +0000
Message-ID: <DS0PR11MB75294B4B9E061F7CFEF94829C39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
        <20230411132803.4628e9fc.alex.williamson@redhat.com>
 <20230414140801.17d27396.alex.williamson@redhat.com>
In-Reply-To: <20230414140801.17d27396.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6030:EE_
x-ms-office365-filtering-correlation-id: 1e69c247-a5cd-4d8d-f569-08db3f445447
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MsLOf43AnpR3vGseh65zYfjROA8FO/yAvbCpAdOAXfL4L4hdGjXff5FfDUfr1p5Rsxhfb+wueCfzZQU8JwmgpuRr30dCavzLaIywnGbhbjym9dh/Z+TKs0llsLkW3G+PGujedo39cRvO+ighulvGLT0yQj71vGzozLhvhmkG3wXmYzoUCbUPV2RiT7am9vi4b1Wkqko6hUqlihskP6rr+4bhfYropT+mZdfSlq5ppoZfl09xLI1GJUgY5s1nIT5neovykLnUoo62g2dTjApEtvO8r9GuEu4F92FhmvcHfdpj0vW2Y1XyeUVEKb50oXbHLDVkz3EsXTvzpsmkwuBschmfeksSNNFST+SHYMwd22Kx1ezUY4y3/PVEcy5IJOQoQ15PiVRkqGIQQnUhqkKhOn2z8wq9bDoyEHKqfZBNcQ3BdOkalU6jxNgsDqJbooSpB+tRcIuAAPvs4FRc5w0KhdzBv99/x6oNkyUEYH8RPOH2ad2/Ddbn4CN5Rd27w3mc9UHaa1uAcrqPsnp7r82htjd2FGZqiC589k/Uw6/XugR+2XvVWClgGMg6R/x7M4LM7DZBIpmSod1sw5fYhX3W+2Q/miktPvXdJZxzmedUqcer2jlDWwTIDZuhNWrYPgBPe5x+hmR+da+E/pC4c1hF103uQ529PEq/EQ+7LpeCBsA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199021)(38100700002)(2906002)(6916009)(4326008)(7696005)(55016003)(71200400001)(122000001)(64756008)(82960400001)(66446008)(76116006)(66476007)(66946007)(66556008)(54906003)(316002)(33656002)(83380400001)(8676002)(8936002)(41300700001)(5660300002)(52536014)(9686003)(478600001)(26005)(53546011)(38070700005)(6506007)(186003)(966005)(86362001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mPxstrz7zK5ZVeeLJC90o14S35WAajmHird3EpEs/ot/nlHYGqa4Hspsc647?=
 =?us-ascii?Q?wDYYjAIIubqcrIWse1f6nLaxG3WWpBsWbHVMtrGgvaK9hb5Xho359Z0vfB0l?=
 =?us-ascii?Q?h1ojiVup6HhEUfpiU71oy9YuUxw8O/3jx0OqVNOQ83mVLWLNkGqpBmOsbzL9?=
 =?us-ascii?Q?cWW2BeqEcUNfh96xgrIsPul3pA0iTmGFhMqx23DnJwzEySMCO0bIRzRXodC6?=
 =?us-ascii?Q?h2A+fl24A/5Z2+o7TXqQa8FkQz6KC6Jf9OGXgBoEiwAWCDSZu3FZDYhS+noD?=
 =?us-ascii?Q?yk3lT575PxywajzoTODyy8Z2JPlKT/AKonnfJxhRhlcyNVA7RDp2Qc+jZX8i?=
 =?us-ascii?Q?AphAVbDExCfKZ+ozY7zkNJxUXSKdSUhjsytG1NR6B0Xf/Zdqh1c8nBzkFexn?=
 =?us-ascii?Q?EtPeTuYSDzz9k7/jRGKHAJLzcA9OVqrOUlQNFMR4cQEQ4E+daJfuGk1awoxP?=
 =?us-ascii?Q?jsJfCkHHJtq0bA8mvHIAUAJJW8DY8dl2fQFpDIXn+k1E6rBawsKTq4v5+e8Z?=
 =?us-ascii?Q?+8HHTHIpRPFDYCoSzklizlpLBoVb084IObsI+2gH6m4Evrw/MQufJ18lXp+2?=
 =?us-ascii?Q?GzGcyqgb4x2wHho8gR21KW/1OL9w4nZQlxDGIqmwKNUrhq8M+wKH+CDvxINc?=
 =?us-ascii?Q?OU+NJ6o0A7ejhcRlxcqDLVCxjwJxaSLo8jVqnXZlk6HWQudGPZIHtlonQOZu?=
 =?us-ascii?Q?FaaYuhoHSyh2Xl4vVhPJSH+8FKPCwoya/5D1TcAa7zma2oDurc0o3b+bT62f?=
 =?us-ascii?Q?CecZE9YAsSTBtgff7HIz/B9nq7rim4bG97h8KvAOxEMfVSokMxw6GzaA70C9?=
 =?us-ascii?Q?yHXSxxgHDEZPp/1If1YmzRJEyAMviZ3HtA9N9/sdyclP9tx/FJRTw40PhfV4?=
 =?us-ascii?Q?21TxvgEfEFW8YjCDKwmkO6LZEmKswSBZBlCzbMBAXEV4X+dgoL2/6r+qwhB2?=
 =?us-ascii?Q?wzbwJ2ZzCf7bUia9Bu878iQFK1HUyyJpgWvsyknA7sAGi7LIPOJZQ0pLxQ/J?=
 =?us-ascii?Q?AbXGMAj6t+2bMo10OeEoi4iKfpXRGUrz/rOdHenYVaQX95R7YJ5upf4wtPqI?=
 =?us-ascii?Q?gt2QLd5sauJZoOSJlz30aYfb9ClvH52oAJ39XJQyYb+JoeJUSiYMCMzQ03YA?=
 =?us-ascii?Q?9ze07uT66fzXfL8sUcLg6nFTzzvmRilcp0pDY2RvtcvuCQClMDtn8/Yk2kct?=
 =?us-ascii?Q?rG1cTJBifML7Hhzdtv8HCIAkjTwYAt9k1MH4so7HgWP11amfsVVSN1GYaRH0?=
 =?us-ascii?Q?TmAH1MzAFGptbN9dG7qq3H9zOXVnTTGJxd53NcnbhBJBKuOlRcljMJZg34Gz?=
 =?us-ascii?Q?MqlvLuShq9lbnsoXc938LtWOwtxQFrSB3sm730jqqEgw79Im3gAXOSda7oX4?=
 =?us-ascii?Q?i9HxjyHuM+mFZaIVbuLDbwfO0yZF1kn+7oK9AbOdgNdGhBcUdpW3Qw/UnaMK?=
 =?us-ascii?Q?GfLHSy6Dw2nXW3FDyDObLA0fdL/3pf7EXnqPQZ9H3JsjvPtLFl/iId/7nRNi?=
 =?us-ascii?Q?HGKIKEZCivz/9Kp4IzG1p7RED5Vurwe6+NX7nCzrA70veXnVSRIKDvIUBD8C?=
 =?us-ascii?Q?vdWsd5fn2zUUf98RDh4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e69c247-a5cd-4d8d-f569-08db3f445447
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 13:04:50.6963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akZIC9x8s+skVRSgt+9sHuCkZBM8OmyjycnGU3N4YhLSZEYc0bmvIj3oRpVlo/N8DyB606Bcs5HwM/d28ytsqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6030
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, April 15, 2023 4:08 AM
> On Tue, 11 Apr 2023 13:28:03 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
>=20
> > On Tue, 21 Feb 2023 18:22:31 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > > as some vfio_device drivers require a kvm pointer to be set in their
> > > open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > > v2:
> > >  - Adopt Alex's suggestion
> > > v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@inte=
l.com/
> > > ---
> > >  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/devices/vfio.rst
> b/Documentation/virt/kvm/devices/vfio.rst
> > > index 2d20dc561069..79b6811bb4f3 100644
> > > --- a/Documentation/virt/kvm/devices/vfio.rst
> > > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > > @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
> > >  	- @groupfd is a file descriptor for a VFIO group;
> > >  	- @tablefd is a file descriptor for a TCE table allocated via
> > >  	  KVM_CREATE_SPAPR_TCE.
> > > +
> > > +::
> > > +
> > > +The GROUP_ADD operation above should be invoked prior to accessing t=
he
> > > +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to supp=
ort
> > > +drivers which require a kvm pointer to be set in their .open_device(=
)
> > > +callback.
> >
> > I updated the title and commit log so as not to further construe that
> > documentation can impose a requirement, otherwise applied to vfio next
> > branch for v6.4.  Thanks,
>=20
> Dropped
>=20
> https://lore.kernel.org/all/20230413163336.7ce6ecec.alex.williamson@redha=
t.com/
>=20
> Please resubmit, resolving the warning and change the title since a
> requirement of some drivers does not equate to a requirement of the
> API.  Thanks,

Sorry for it. May just remove the "::". So a version as below. Please let m=
e
know it is ok, then I'll submit it.

From abfc87425aa2977c08511b648a194bcfb072dcb8 Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Thu, 16 Feb 2023 02:37:28 -0800
Subject: [PATCH] docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs VFIO_GR=
OUP_GET_DEVICE_FD ordering

as some vfio_device's open_device op requires kvm pointer and kvm pointer
set is part of GROUP_ADD.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/k=
vm/devices/vfio.rst
index 2d20dc561069..79b6811bb4f3 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
 	- @groupfd is a file descriptor for a VFIO group;
 	- @tablefd is a file descriptor for a TCE table allocated via
 	  KVM_CREATE_SPAPR_TCE.
+
+The GROUP_ADD operation above should be invoked prior to accessing the
+device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
+drivers which require a kvm pointer to be set in their .open_device()
+callback.
--=20
2.34.1

