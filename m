Return-Path: <kvm+bounces-4302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 030FD810C4F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264F11C20944
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F881DDE1;
	Wed, 13 Dec 2023 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fZz2nr5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B04DC
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 00:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702455850; x=1733991850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E0vm/AkMj3pLN3HMAdMSmRKCkGe2CZ4Wf0VDbneCoMw=;
  b=fZz2nr5QD5XKpUiIBiCzHBTAIIUQLhqcVQGEmulgMDaEcs4wFBQhdIfz
   EQaRQrfaKSoEf/+RoeO3GcLmbyOVinKlA5dHYF7yCeh6I46XdLt9TwpNZ
   EIbYEaJtCJOInT9ei6c4aJ22yp9EnVxwdxGAMNATtxqNMJXKnXDms24B2
   Wkk/jQdDhavKN2w4onP0ftmyVICyduqm6eCGW/uOArWhFQSyqjxZhZY+1
   EnnRi/A8IZfFgliN6vIdf3DQ+/fmUGQZOQ/mAPygnsoB3p251e9v548jn
   l14UHCUsAjI0AaRWlQEZ6NxhP8Prv8TOYIyIuH62Ph9v1cCUTHVc+XW8L
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="8318868"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="8318868"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 00:24:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="839775887"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="839775887"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 00:24:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 00:24:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 00:23:59 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 00:23:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 00:23:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buVp5yyaOB0Nru03FnlT54n2tEBZaYO1WFrKqjD8wn893GZarBCRF8ShQMnM/sxWppjBGOKJwSfDRK8OM2brwm06Dc9Y1NRHh16zPNgozIHX3QDdoWYb4gj3XiH1bNgP9eWKnqkndzGctUvyT4r3R7JJYMPVH+yEo7VNyqzRogAoHAywEQhmV41x4CwVdDhpILiPZjKWCj2tL0c7DvFrvcwyj5h5+Ei6Y5RfKrL3VChUCZO325VculmdztKTGI8F1bE62O3Gdqc9IY3HX7wQKsk9/hpBXrhElHlC2cYIiN6GGGi+IX1lAKzy7U1Nv6fFVlWbP1IKMPmohHzQQNeQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbAs2gIHOu1lPbspXdrgWeMFBvrjkTnM/NBbQM9AO4A=;
 b=PFVS0K7fS3zlQCYaQ4y+7uBRhKBO1VpISOX7mri/tfqTkSGiytp5M+y/3uvjP/iaYPPnkDWrzPs0YLIyC3e2Qxbbv6jKZJMDdLxWRBLDY+1aQZ94+XHg9epW3Q8jkWJeYJ9Ipnc/VMGVhzu0Blp++8Ohc9/yP2u5dEGCwW1pDqMyMXiwj9YVuppWEA7ekf9hUjtDkh1ENTzrSz6OXUyBeKdAMe9UnTvBdlMwBmXJAxixtu3GMhXGpIEunE6UKKUZdtycaHd5+nV73RAVyoylJW8anYOz80M6ZBaijhD5RZHZdS+bQQz6SPPojsDUgNXIeYrTW9O9iHDcMnuyBbKarA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB4898.namprd11.prod.outlook.com (2603:10b6:303:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 08:23:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7091.022; Wed, 13 Dec 2023
 08:23:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaKPhWxx9HXujfsUi0tG4mXIDTXLCm0VsQ
Date: Wed, 13 Dec 2023 08:23:50 +0000
Message-ID: <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
In-Reply-To: <20231207102820.74820-10-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB4898:EE_
x-ms-office365-filtering-correlation-id: a35a4df5-7729-4b41-6973-08dbfbb4d5af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MEkI+McoHko6CXPwwEx6o53sM0V1KwDLbj/zgv1hStm/0aCVhHBpbODvCEXXgLNYbG1UgquCRRuZcmU2VGaMZ9tv4LNOUvWKfTPwYduIenEPuM3ny74GKn5NjJyPubNH2eUizFDApjU7zuAaEMaIpU+XV7rjaROvulKz6jz48u2qufPwbrmbJRnSfzmoSquqRuCiX8sRaRu87q0/rr5QICH5qrJsQu3BbVVWtZXAP/jdQPM3lfBuQi2H6Tb+nh5eSCLBOf8liRPvIWdldOntXpUJUrLPBbdZ9l9fV3AIxxmBALVxXe9vMNlTBZuqzoBcROc2B3y7ui9jSVDCZeXQBtMc8njLK9uEVWIFS9aZVD6MeSua4y5gZpXOXZkjwy99BEgAyFzdp7KygXQJTcOX37vhFIB3GYujrA18J2x0yNP79AHtZEgaTaaChXV3VqNzmIPovCbgNC9nr/F6hGbbk8rJQ3556zwCIlf7Y42wiQKvZKLp7bDv/pIBwG7V35J/FQua7cAcaWXvTo5i8frCSkMsydJlLqemgndZn9pW5AhXqGEqm056FAlYCPC6QUxlbrHP+OLJ5fEdxefQ3NYbpFMPlZmJMklq6/S3TYjGoAO/jq4ajsNd6iNJA1UUj4Ge
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(366004)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(5660300002)(55016003)(2906002)(7416002)(4326008)(52536014)(8936002)(316002)(54906003)(64756008)(66446008)(66556008)(66946007)(76116006)(66476007)(110136005)(8676002)(478600001)(9686003)(6506007)(7696005)(71200400001)(41300700001)(26005)(83380400001)(122000001)(38100700002)(38070700009)(33656002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qwGdOyOKrwdslsT8QBtfUeRQIQxVkoRgIkc5yiP49EPfVEFQTAplxRpJMzbi?=
 =?us-ascii?Q?ONxwllrVQ52H0a8mK8JfkoAXYPzlwDy5T+inYB2qb51UA2kS6WEo6uFmEbNX?=
 =?us-ascii?Q?cxkI03D+0xOn/SCU+Mv4BsCRBFdjRuDy7BorqsEMjrSrOciQUbUxFHpry6u8?=
 =?us-ascii?Q?59C63IsSm1MZgKMlihxIBDzIyLHbreDbcUyL4yheHzfruZvUoK3L4N0mGicF?=
 =?us-ascii?Q?Zxtpm5DUiCghmfPzIVbjxEqwVNPEtu/zlYqd6b+hDHtAvL3EGK5+/lWQf2XM?=
 =?us-ascii?Q?CCv5kgnulFrBdNrDDfx+t82xuisUGHe5uaHlt1dvi6eYLnfMplntTNtwVdf7?=
 =?us-ascii?Q?7QNa9HXKI7DoekKvEldRDjUyhNvohG/IJDZHahUicxrqh/GhMJeAlBFC4Hfa?=
 =?us-ascii?Q?xpYoDrKftCuIKfZslh1N9Lzlp2z2C1ogqYe16WIBG4ZkoYATZVM/ybK6WMWy?=
 =?us-ascii?Q?foSmkKevZhREunC85t09u63vfE33dCmLDvnn4uBjQv4vCjFrtN/CFQJlMLC4?=
 =?us-ascii?Q?hbIlLQ0wn26Ok/LTxxzsyHy/xtCgRpNmiuVuClsuopfYnXAZXPyTtzmx+29X?=
 =?us-ascii?Q?M+ZekOx5LcmSI+ymIQeK93d9CqxgaDaK2meyWrSQ7RyH/AdPNfvAtsFYwZRF?=
 =?us-ascii?Q?qopBPiE1/K5yb1NEAAU+yZO5Ov3CMPHVUgim13TdIF3XsrfJU3bi2PpG/ZB4?=
 =?us-ascii?Q?hDPAWpgrMVddpL7LlapboZtMt2sBQG++kqBBLPultUxj6M8oZjLt+Wkp20T8?=
 =?us-ascii?Q?tro74flr+3j0xCf8Qk9+2SeG3w/jNNT4iZILERAtwq0NE0qmoOs/PIrcBoa+?=
 =?us-ascii?Q?ZJdp/JWLJM0WbbFfM13W/aVY4eKMelWQDhOsvnZh9ou6ZGcHXJN2aXpbEcfJ?=
 =?us-ascii?Q?0wX1/+8QnM8Dvt0/pFL4lTg9ARcJEHa5raenGhofEdAZTFOGIMF1DqflBz8O?=
 =?us-ascii?Q?5IUJHAa66p3NdK28IVoVuTTqEC50YBxZ2ym23G52IjGgfMGWDgxOZZFy8gXR?=
 =?us-ascii?Q?454fzSsa7Xt63MvEbG1B1DOZ/x0nHADOTqJ/P+sD0KBOWuQ8GtsnvgAJQWwx?=
 =?us-ascii?Q?fF1RM1fj9r13gk/AsosGKOKMdH657p8gwYEfC6P4FKcbOTCey9j0y2rP9KPz?=
 =?us-ascii?Q?QKls8CvEzhulyxcYd84QrGt4/cxIt0yWOraMXZH+90gEEau9n8xRgcQKERGu?=
 =?us-ascii?Q?l23IHpkicPfbee0touP7v4Cbd6+Rp87dFJi5JqbeqC903f7OvVH9fqSTLIAw?=
 =?us-ascii?Q?I631jZPHgCQzWV1l0wziPHL7gwSVd5w4Ojy4g4iZR0LSpdlLqzj3P9TYzFd0?=
 =?us-ascii?Q?UQWbDTIN7kcohhtsA9c7qoiXVPNeYKB5SbfoDS1oSgASLWMt20xPSP8jL2Fy?=
 =?us-ascii?Q?zVGHuQyWdriireAEdenR+Ph4jyJT52T1n7YxmZVeVmWvPahe8gfQInDp7O5m?=
 =?us-ascii?Q?aI3Upi61nAgV60kPQEThe8ReZSyqHnF4NmzvGhA4osJompsDvmuL3H4AKO0q?=
 =?us-ascii?Q?jaFdLNJyDDyf3ybnmx4pXctH14RylUeqNdI9n5TIwSCieQRQnYYbWI906Iv8?=
 =?us-ascii?Q?8/P8X1pGPb/lUetYkcocYSgtFqg9XK2v/J+k2Np4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35a4df5-7729-4b41-6973-08dbfbb4d5af
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 08:23:50.0722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Q137WpbBLXklTd1wsDBcaqD6DgedOW4nJi27RkrHj2GRICDZjU1L3PRlcXUAN6wlDgwKW5kFaorXE+W5Mfxtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4898
X-OriginatorOrg: intel.com

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Thursday, December 7, 2023 6:28 PM
>=20
> Any read/write towards the control parts of the BAR will be captured by
> the new driver and will be translated into admin commands towards the
> device.
>=20
> Any data path read/write access (i.e. virtio driver notifications) will
> be forwarded to the physical BAR which its properties were supplied by
> the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
> probing/init flow.

this is still captured by the new driver. Just the difference between
using admin cmds vs. directly accessing bar when emulating the access.

> +config VIRTIO_VFIO_PCI
> +        tristate "VFIO support for VIRTIO NET PCI devices"
> +        depends on VIRTIO_PCI
> +        select VFIO_PCI_CORE
> +        help
> +          This provides support for exposing VIRTIO NET VF devices which
> support
> +          legacy IO access, using the VFIO framework that can work with =
a
> legacy
> +          virtio driver in the guest.
> +          Based on PCIe spec, VFs do not support I/O Space; thus, VF BAR=
s shall
> +          not indicate I/O Space.

"thus, ..." duplicates with the former part.

> +          As of that this driver emulated I/O BAR in software to let a V=
F be

s/emulated/emulates/

> +          seen as a transitional device in the guest and let it work wit=
h
> +          a legacy driver.

VFIO is not specific to the guest. a native application including a legacy
virtio driver could also benefit. let's not write it in a way specific to v=
irt.

> +
> +static int
> +translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
> +			    loff_t pos, char __user *buf,
> +			    size_t count, bool read)

this name only talks about the behavior for VIRTIO_PCI_QUEUE_NOTIFY.

for legacy admin cmd it's unclear whether it's actually conveyed to a
mem bar.

is it clearer to call it virtiovf_pci_bar0_rw()?

> +
> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
> +					char __user *buf, size_t count,
> +					loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev =3D container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +	__le32 val32;
> +	__le16 val16;
> +	u8 val8;
> +	int ret;
> +
> +	ret =3D vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
> +				  &copy_offset, &copy_count,
> &register_offset)) {
> +		val16 =3D cpu_to_le16(VIRTIO_TRANS_ID_NET);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
> register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
> +				  &copy_offset, &copy_count,
> &register_offset)) {
> +		if (copy_from_user((void *)&val16 + register_offset, buf +
> copy_offset,
> +				   copy_count))
> +			return -EFAULT;
> +		val16 |=3D cpu_to_le16(PCI_COMMAND_IO);
> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
> register_offset,
> +				 copy_count))
> +			return -EFAULT;
> +	}

the write handler calls vfio_pci_core_write() for PCI_COMMAND so
the core vconfig should have the latest copy of the IO bit value which
is copied to the user buffer by vfio_pci_core_read(). then not necessary
to update it again.

btw the approach in this patch sounds a bit hackish - it modifies the
result before/after vfio pci core emulation instead of directly injecting
its specific emulation logic in vfio vconfig. It's probably being that
vfio vconfig currently has a global permission/handler scheme for
all pci devices. Extending it to support per-device tweak might need
lots of change.

So I'm not advocating that big change at this point, especially when
only this driver imposes such requirement now. But in the future when
more drivers e.g. Ankit's nvgrace-gpu want to do similar tweak we
may consider such possibility.

> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> sizeof(val32),
> +				  &copy_offset, &copy_count,
> &register_offset)) {
> +		u32 bar_mask =3D ~(virtvdev->bar0_virtual_buf_size - 1);
> +		u32 pci_base_addr_0 =3D le32_to_cpu(virtvdev-
> >pci_base_addr_0);
> +
> +		val32 =3D cpu_to_le32((pci_base_addr_0 & bar_mask) |
> PCI_BASE_ADDRESS_SPACE_IO);
> +		if (copy_to_user(buf + copy_offset, (void *)&val32 +
> register_offset, copy_count))
> +			return -EFAULT;
> +	}

Do we care about the initial value of bar0? this patch leaves it as 0,
unlike other real bars initialized with the hw value. In reality this
may not be a problem as software usually writes all 1's to detect
the size as the first step.

raise it just in case others may see a potential issue.

> +
> +static ssize_t
> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user
> *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev =3D container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index =3D=3D VFIO_PCI_CONFIG_REGION_INDEX) {
> +		size_t register_offset;
> +		loff_t copy_offset;
> +		size_t copy_count;
> +
> +		if (range_intersect_range(pos, count, PCI_COMMAND,
> sizeof(virtvdev->pci_cmd),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_cmd +
> register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +
> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +					  sizeof(virtvdev->pci_base_addr_0),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev-
> >pci_base_addr_0 + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +	}

wrap above into virtiovf_pci_write_config() to be symmetric with
the read path.

> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
> +{
> +	struct virtiovf_pci_core_device *virtvdev =3D container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev;
> +	int ret;
> +
> +	ret =3D vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	pdev =3D virtvdev->core_device.pdev;
> +	ret =3D virtiovf_read_notify_info(virtvdev);
> +	if (ret)
> +		return ret;
> +
> +	/* Being ready with a buffer that supports MSIX */
> +	virtvdev->bar0_virtual_buf_size =3D VIRTIO_PCI_CONFIG_OFF(true) +
> +				virtiovf_get_device_config_size(pdev-
> >device);

which code is relevant to MSIX?


> +
> +static const struct vfio_device_ops virtiovf_vfio_pci_ops =3D {
> +	.name =3D "virtio-vfio-pci",
> +	.init =3D vfio_pci_core_init_dev,
> +	.release =3D vfio_pci_core_release_dev,
> +	.open_device =3D virtiovf_pci_open_device,

could be vfio_pci_core_open_device(). Given virtiovf specific init func
is not called  virtiovf_pci_open_device() is essentially same as the
core func.

> +
> +static int virtiovf_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops =3D &virtiovf_vfio_pci_ops;
> +	struct virtiovf_pci_core_device *virtvdev;
> +	int ret;
> +
> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
> +	    !virtiovf_bar0_exists(pdev))
> +		ops =3D &virtiovf_vfio_pci_tran_ops;

I have a confusion here.

why do we want to allow this driver binding to non-matching VF or
even PF?

if that is the intention then the naming/description should be adjusted
to not specific to vf throughout this patch.

e.g. don't use "virtiovf_" prefix...

the config option is generic:

+config VIRTIO_VFIO_PCI
+        tristate "VFIO support for VIRTIO NET PCI devices"

but the description is specific to vf:

+          This provides support for exposing VIRTIO NET VF devices which s=
upport
+          legacy IO access, using the VFIO framework that can work with a =
legacy
+          virtio driver in the guest.

then the module description is generic again:

+MODULE_DESCRIPTION(
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");


