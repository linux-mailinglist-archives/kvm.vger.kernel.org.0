Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38166A51BA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 04:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjB1DOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 22:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjB1DOU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 22:14:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5169B6EB8;
        Mon, 27 Feb 2023 19:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677554049; x=1709090049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ic0HP87kV5TRhDzCUq08G6jhYiJou0hkq2jhkOb0SQY=;
  b=SCdNScRbqanAJrbMk80AR6GMoeYxeOzt94FusUqTXqpVwf8l6Ac0buO6
   9+l80RYYamKPzpUzxOMltQkqqY6+ieBvpN/3KShA3z8RgDTxPASbiXLRE
   xNwWyb2R8YpFrAOrKZ7kNF1QYhD2/GOaIDcf8rGHZpeUC90WSLIclTFqd
   GlBojNptxoraUS2I5uxKu8VjBdzc47dF8ASfXFe+WnerLtB41JEohigdz
   drB/EwtWO2G2C7EO2biq6OAC/XS4DW+VGeuy5Ex/Z8CKVN0LGMK3rDKsI
   rSokfCJ+dVGfg/Zgi54SpYWaD+LChcxnnV81K7Q1v9yga09cC7Bz3sdQX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="420294901"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="420294901"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:14:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="797909731"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="797909731"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 27 Feb 2023 19:14:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:14:07 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:14:07 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 19:14:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 19:14:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVswwm9hmRdLxqxzIDpVE/hyvs0QDJTFWXSS331u4LwVoDeCK5U02ajI/EXIqnoUFis+F2PcgWcMhPIkohBBaJ4ETCi0FZHslFB6HDaAFuH3Irqf8gS2327WgAI9voemU5GqVNDFVGzVjhf2c6B/KS+03DtVP+Pv5zr2AuKparZe7NZkP1eWYMnJIq614f1vsRWyTlcXu65+58h4/HHWelvfEG+PbS7g/XA/+NSaAk94O6wCf4NgrV8BQneBfdY9/v6MZ19iESiFTctW2KpEqkQ6N84t7cyScgtF+TU/5YmOoIJmnAKO5mwinRzOnmg7VtgOh7gA4b/DZx3/PvyfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbQxP1IDnyr8V+IsjhjTzwY0hrXxnKRMRGKvmaKd6kk=;
 b=XDuMDzQ1fNZITyKCdf6d7mgmhVKhelll5Iz+bLQkts6nidI1JlJrzvRo6eU038ETdtNoUpq9J9yfuSXHR94owz1iAyn3yheEEWwEhShUAMsNcC10BPY+6S5PPat21x4AdLOA+3UT2EAEOgzylMwoQK3eklKXOyR0s8n9jNhOXeba2Hanrqrmoe5qc+Hx9mHAUrQ75XjaGJNrGzFa5yMcRV0sWHUVFlqNHiwBrTx7LIKxw+wr0mcIgbYZCeLYU3YEpCYWpt739+4jW3tGdEFMVWXia8IMWG1Cfd3ePKztx1pQHBPKTe5XQkyVcr1n9tCtJrNFLZn20eXyP2Kz6XELqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6322.namprd11.prod.outlook.com (2603:10b6:208:38a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 03:14:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 03:14:04 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Topic: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Index: AQHZSpxOoJwf0hV6f0O8CRj2qSU0yK7jK9+AgACEOqA=
Date:   Tue, 28 Feb 2023 03:14:04 +0000
Message-ID: <DS0PR11MB7529947F73B96F1CEF11FB56C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-19-yi.l.liu@intel.com> <Y/0Ce/D7KOmM+K3L@nvidia.com>
In-Reply-To: <Y/0Ce/D7KOmM+K3L@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6322:EE_
x-ms-office365-filtering-correlation-id: 8e99a93e-6935-4776-2601-08db1939d8e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PZ9dkO39ZO9gG3uhUK4hhkKtGGVZePoQsbJFZ8VGhrL0VZMa33/6yssQtnSSgIIai2dLDpJ+WIEy1jwR+oHhRqs8dVcrOLto7I8yMiOsvZYCcwOK0BRVk3/80EoOQplBBy0RKaWG4tynNOj3bQqm1o6RWPyTfeZp8Ga8ENi92ia3tKLtEOnbzHssYFxNZFpoyD48QB57RzXbf9FWG8YTktL7oFGblMrtP45MUGAnR4lmW8GkCffO5jk8Cra/l1ELd8JeP0G2nIfXbd0X/2GPwYoMOCvqAKIgIwFHflctM+uJXLehxlSt37cjRj0nIpESOvkCzVoXkqRkgP9iMDNkhtlffzIfSeHOo6q01Fe9g4DuOE+rFmh/rzFcaJ+bJ8XwR+YeAYmj2md9tH6c32lm95CKDYqtOKfmOCbeHCe6XTUyf2vw6feO6f8jnPEXiJd37jP01p2wAjU9WU+Hvp4zl0QFVgkArpKlyNwejcgGouMfMnCEzwAL2uUf582vjZih5Eon+UCiJlnZlye7Qyg9BG9YXcVOviSV8y/VQO2NgqcnN2480djjcnaX2vm/1iKV+iTdz+eoeVTz9P/czrwGxZ2991hL1XfDzGyjRopJ97S+bzlP+XcB528ADmzFBswTjfAa4h9HaWAqjMsu9NXlC0KSVPA+36wvqdvhkUxjzDBJio9DBE+f6cZfHsvexvbRcOJ+hqoa+u8O68CLNMlaDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199018)(6916009)(8936002)(5660300002)(52536014)(7416002)(2906002)(66476007)(4326008)(64756008)(8676002)(76116006)(66946007)(66556008)(66446008)(71200400001)(478600001)(54906003)(316002)(7696005)(41300700001)(6506007)(9686003)(26005)(186003)(33656002)(82960400001)(38100700002)(38070700005)(83380400001)(86362001)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iiUY9jORAzjv9RpQBIFF9KkgFfP1m/S0VICiWZ9Id5nGG4Ds6gRBLytbQzia?=
 =?us-ascii?Q?ZvCGkkNaHXpitiS75dtDCIxbwJyGXvDZVCiChqMJATar4DjV7jc88/0ES9XO?=
 =?us-ascii?Q?bfkmQdUd/5453+eNrvDxZ/7DPkP3FKsMv5y6wj7YAnWpoldOVsU3E144bfG1?=
 =?us-ascii?Q?//RlK2GECLYlaj9gSBNZkMSvjz4pXcBfrmG6ZvYC7WuBgUAfsE8oYhwBejeE?=
 =?us-ascii?Q?AJ/t9AsnwZRrB+vA6vZnOJniKeKqgX/dBstsj4XsbMr2kRueZlS6g3s5X8FM?=
 =?us-ascii?Q?nfJxwe8htUg2HD98oQW1UQ2SkrxNJ4VdahfswAM/GSMeZhJXAXGiFsGDlGYM?=
 =?us-ascii?Q?b7cJC/77MVtCb5lhaqOE0mzcTU+4VfrB2E7YJpd28p9O5SyN1dP4zKzKx+1S?=
 =?us-ascii?Q?y4uM13bybMSrRP9MYD7rUNT3eVPXBCKLi+bTvZBM723tqQHJxyp4QQWH/vLg?=
 =?us-ascii?Q?RN5hWFb57kSfv0Sz5/+GdUU8oRl2EZ1n+grWgMC4t/5olvA6PRVfhEPN+Oa6?=
 =?us-ascii?Q?rluLwjeXoW+/BIgqWKquB60uf9li4Aqkc/crVf/I+CRzAr57+nGD4fijL6Jb?=
 =?us-ascii?Q?SS38fWsDJzgLWzOOj+9mEe9l5hpKB1/oN+b8Jb1CsNpKjWP01iJRbbx1uVeU?=
 =?us-ascii?Q?KDtlZTFc1szsf2/RuevQNkHH1a4qXqhG87Qf0vesyhAzIBrxH6HYU78G7msK?=
 =?us-ascii?Q?JNuZ0If3Kbg7kUtEOj/fEZhfnnVQMFWN7nOdADQtDBdbsXnoUUaybWHamnjR?=
 =?us-ascii?Q?5qwWNNwE1N6Ii6Efes7QNib8zTsyAciygpfZY661+i8/z3l16ifIaKoxSiew?=
 =?us-ascii?Q?79qib5CCPkMSQ4qKGIOM7OC1WHCt/fdKiZreFtzB8vw5TZmMp7wCR18iJOjR?=
 =?us-ascii?Q?YMa5i5miFuuHV51Sp2wEukZUN2bmyfxBch6jdhOMGelwWqL+BxD9NzWfmHhs?=
 =?us-ascii?Q?Jfxn0qbgxNQm7kISoHScNkyO4YVBbBZJrrxBT2gs8YfyNt92tw6o/7Ih4H6x?=
 =?us-ascii?Q?B7kYiTP3BC8QGRTaIkLdyhDD26DEDGHADUM2YPUfq5RY6jI9sHHwcNa5t8Pt?=
 =?us-ascii?Q?YAOtG575eu8LD/zWDL7kG6ozauYDMxDJlE3GcYR888RX8R4jVufGAbrj1gry?=
 =?us-ascii?Q?oGlI6cE4zWvRVpHtiv/wa7f5/FScxzLKKqkGBNW+4EBEgm5lZmb+eVvXvXW/?=
 =?us-ascii?Q?Q8z3ozP5IjfkN3lNYGYyHRm6XtWQTvPYPIH2rn8uHKCiiC+9x16R9oh3qEZI?=
 =?us-ascii?Q?G5BLhtFvJTXNf3Fp6DK+s9pZbPzq8YXtQLM2Vbf6PIGkJWbpPrzaUrwWSnoP?=
 =?us-ascii?Q?7ekQah9RtW5/Hfm22O037JrmZgb4TOhFSyrSN8lIovr42qoI/Eo4zveDnwLR?=
 =?us-ascii?Q?IjE8vAz5ivkfuGjwF5mof6O/r/7fqpb2l95Qk8UdhcKKMRpG1Wng1Ion660m?=
 =?us-ascii?Q?YnOvhZHdSToX41qwtC7DXFKizOp9DydCsgPKq5GO9n2MGQ6xKj00eiJzkntQ?=
 =?us-ascii?Q?8QBCV4NCSs9rsVLWhlt5k4Uo+pJ+tcH/hmOsVzYg3iA6i6YHVBZUBSEgf3z/?=
 =?us-ascii?Q?qi+v3txn8DLms5syvPdZDgK/3/+7tIa4twhntod8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e99a93e-6935-4776-2601-08db1939d8e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 03:14:04.5299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dYNM3/8QdFMyb+NIaoMxn5QzZb1LJD4Id8J6V9WVYhW6qUCH9fd1vQ76fEQJIlRPMGVAN6x+NDHlC7k5g1bJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6322
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 3:20 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:34AM -0800, Yi Liu wrote:
>=20
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index ce390533cb30..d12384824656 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -43,7 +43,9 @@ struct vfio_device {
> >  	 */
> >  	const struct vfio_migration_ops *mig_ops;
> >  	const struct vfio_log_ops *log_ops;
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  	struct vfio_group *group;
> > +#endif
> >  	struct vfio_device_set *dev_set;
> >  	struct list_head dev_set_list;
> >  	unsigned int migration_flags;
> > @@ -58,8 +60,10 @@ struct vfio_device {
> >  	refcount_t refcount;	/* user count on registered device*/
> >  	unsigned int open_count;
> >  	struct completion comp;
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  	struct list_head group_next;
> >  	struct list_head iommu_entry;
> > +#endif
> >  	struct iommufd_access *iommufd_access;
> >  	void (*put_kvm)(struct kvm *kvm);
>=20
> I'd combine these for readability

Sure.
