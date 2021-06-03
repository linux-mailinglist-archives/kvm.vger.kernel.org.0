Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D169C39A1C7
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 15:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhFCNHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 09:07:07 -0400
Received: from mail-bn8nam08on2084.outbound.protection.outlook.com ([40.107.100.84]:20448
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229955AbhFCNHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 09:07:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBZP9J1YwNqaV+RVtQaOp8yPgsEU/Rv6+qz9+TgQo33VyHi08N6rFxtcXVdljj8C0Ykc8u78lUUyjavk2+UYzmDiV0uGrYCK/uYmKpUFcV00H37Mt0VahdxvYkv5RewgRzM/4k14uclzZCIGQc4MUDbBZzi6l8hAJ/mJ3KwIccnjyMZOh9/owiAf0yVDRwiINWTRlszkPBbB0OWgh/P12VAbo4Xamx5OmGm6DeHsZJi/pCUdIJh7GZNua0TCpw+WBr5k5sc7GcT6zKT/qVAysVfrHGJnqNpVQMYFVIxYW2N+bFQJ+vgwLdMX4VkeF/EXwkswQjWGbwvuygGRbFX9jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYVqBMvB+2IM9aJbjm15TLnU4Zfav5YBCAdSOxf/n2w=;
 b=O5p45QU4lEyDBnOiv/ozeXrK0QtI/RxThatZK5RDzoDozYk3TiD4fmQ1FoOjE04uxk8TW2qUjQdkYt9s3iO+apAzn7bMNQjDQoq7rEghRcPA7ceED3xilm23dLg/kD+w8ju7Mbpdz49r0vJXQqBTqQrP6RICKGYWd/11edbiWm/Q1K3/a37qLhVjQwoxRnOKSszNt1LXAqt3gOhrWYy0iIIl/+4Q2eAX7nJ2ZIf82fjMFvgHlAjhOjD+7t2dDmP7UF/4H0L9Mx0GtZw+MujF/+0Le0jFLuD30jmm9bzsmjxK2YCm7e88e/7yPJZEwN5Sks+zD1xwZguOJsbY6sKARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYVqBMvB+2IM9aJbjm15TLnU4Zfav5YBCAdSOxf/n2w=;
 b=eRmm0Dp60dA+31P0eRSgIB0RdZvTA8GKymv2KfhvA87QPF3r1ZTdDbWAe64zam/Oa+LxJSXv1lt6OfGekiSTiEQf1TxOKvSiGkyT5qBLCb7EXpqjNDZZVyg3Ln3cEz3VHZAW+rjV8GBK4nxNMQmnpebIOz5fcSuz+WEY9yKv3ta4x68c2YLBeR+GX/MUjB1mFN2iBBEbw9YcBiJsaa7h8gGPOW56hwcDtc/SGUzCclTzBgRGaIpdPOJaejydNjhelJXADlMXM4NT21pD3E+fke+0iMb6ormMlQLm67gmLzhgNoHS53EGEtr2ABCfapQqtwnLJ1K6CPcXvZDLLoa6Jg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5173.namprd12.prod.outlook.com (2603:10b6:208:308::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 13:05:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 13:05:20 +0000
Date:   Thu, 3 Jun 2021 10:05:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603130519.GY1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528233649.GB3816344@nvidia.com>
 <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188621A9D1181A414D5491198C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:208:23a::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0018.namprd03.prod.outlook.com (2603:10b6:208:23a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 13:05:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lon2F-0015Ji-B6; Thu, 03 Jun 2021 10:05:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ebf6979-0e11-44f9-58f1-08d926903df1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5173:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5173A10FCC79749356DA99C0C23C9@BL1PR12MB5173.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqVkPWwcoxtNLfYy8EFxW0VnU9k6kGDioa6WsH/mlqduh1MYfJ7qyS+8RP71B18vZoRLFSMpPA5QCS7IpT/teh9r03kSCeYAjNfDq+nUrRw6IhaUqMbAqV3cq1m7m+SmSJKYItDNxV0aHyM1apesrSl5G83+nNAE3BEcUi0DAiQtvqzz/XdL/RYNrEFGgd/PopAMMMFxTl9BloT94ksfDQ9epF4bJT/MrpOnwCdCTv6uZwtKc83Z8/dLYLPJcQVXM2HhglKOHuagaI3CBQ2dd7XariBB+WLIshTYqMHMyzDs1hVtryfZBcnbjn48xHEjQSk7fwPW6BPnVTcJ+tbqSVxkervBS0p44ak5947nQjcmCjwUBmbJsNZGGxRMFHf8pYvUlv4ISjttRvGSckQGk2GDTgOYwHzya4oYaP9IGaA10avO//NS+zMR2pY95cxxEdg20OuECqtChR5+qGQm4oGGV7PqFK1GT4ck7aCwkXeuAe1V2YXOnOeUMQZ044JVIryQYELYcVOAV/bs7Y8beh+iZ6R3AlDJyVNkPPUWy2zGe/acRFbPtxXejiefGQtu/yhikm8pRkFB2jF9OtmQX/v5HwL5Wh075oZE21fXs5A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(9786002)(9746002)(316002)(478600001)(86362001)(54906003)(83380400001)(8936002)(8676002)(33656002)(4326008)(7416002)(66556008)(66476007)(26005)(66946007)(6916009)(2616005)(186003)(426003)(1076003)(38100700002)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HJ+A1/9ZWzGuZCQkF6tDT6jH8hFKwP+gE2AVbczKgOfZNNZD4VfK+KVXb05A?=
 =?us-ascii?Q?OzYcPXjkyRRvgcSDYZu/n1WS3laLDG1sQTBuAm9cFlDPxjf05d+uSg/XmdhQ?=
 =?us-ascii?Q?nY+Ez6OablmP1QsOYZUtnKQYVqYanbQ1EDZC37F5S2XjiIls5fFbl9lwM6L3?=
 =?us-ascii?Q?yNCouqzI8qC2zXRofUkHrFjSP3z8uU4iqhkuIjd4HjQy+x9jdHrEtreysfcF?=
 =?us-ascii?Q?cf5taNhn3FxENhj3sZnhW8A13eohEjgWwf4+TNSv6FZ1ZRPvOEnGM11iZY4Y?=
 =?us-ascii?Q?Fqp0Y1+9DuYroaJT6ZVovvk5CQcCfwyaBTkJi7w2OsQdqmnSkrw1v4vbZM/4?=
 =?us-ascii?Q?JwMenPbLkx58WF23VLp0O58XH8qazvSdHfITrbXK90lnw0bk5wYJKYAkd/Z1?=
 =?us-ascii?Q?razxhJw/Qd6GSsUHIuPMZBkTHD9iA79AdJjK2pJVKfwXUgd7gysbM9txEkxo?=
 =?us-ascii?Q?7oqEFtz7DG/q8CRHIlDUyp2ExXWdI/gR5tdW6OivQy+Z4/lxpTdnfNyGbsSo?=
 =?us-ascii?Q?WImIFbodxuhZ3XL8uypHaejsWeN1XGDLDERI2x+skKbmJ2gBw+Nw2XoJe0Nc?=
 =?us-ascii?Q?5gz4mduK4hMa378gc3A3i23lJI9k9V35t+yJDCEwiqmfIx44B7fK2EywX7Ni?=
 =?us-ascii?Q?RGuMUzZq8EmrtEODYqJ5uIkfS5J+Wwpsvy1tH3j6s/tcsAARhCclYHwiV9ev?=
 =?us-ascii?Q?XbKdEsx5wxobvPKVaTXNUFdvee2CU8eJ/XKNwrVfiHCR11Y9yvvm/4Q/yI6+?=
 =?us-ascii?Q?OWowRzE8YtlL944DJXW3iDAc+k1BlzCFp8aDw6EK9Wrhy2KmV8AUI82S3hxz?=
 =?us-ascii?Q?alOd3y9PEadrmGYoHELxmi9n0ARbiVfuI5yyhT8NRixj4T3rIt73A+hU9bqZ?=
 =?us-ascii?Q?VxV6xQX882iJPUsk4ADdj72LTG7guP5ChFerSobYa01txKkoMgTEg+vGV7eq?=
 =?us-ascii?Q?42a21aKlWIBdhHdqJg5xxwPbQ0+K2wR1pkby6Znceyny8WnuYjKbEFoZCS1s?=
 =?us-ascii?Q?nJz7HNT3dL43JRpAlmST825fLJERfwLEMc7i5mEg2//fWK/WFc23pTcRGurA?=
 =?us-ascii?Q?iXqylwDin415Td4X8NVSYboaU8htfjXiaYBkbS87RCUXQNx843eRKgeuA9kT?=
 =?us-ascii?Q?mQugHdfToY88mkck0yYP5ogKC8zLCJx/imPv2ax0kqLqsLaZxkM03+uKuuvS?=
 =?us-ascii?Q?LD9RueKjQg1PE/4bzGS5gA7owcb04gwGtjFGCU+/YaL0Hh2U8wLoH2GD5CIi?=
 =?us-ascii?Q?raPzqZ40i7Qbgn73x1fqhiXrA7BZP3RAL2yZttYYzlo8xWTfUX+B/4THi2P/?=
 =?us-ascii?Q?29bTqMlk86OkoBOXlzFJX1ky?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebf6979-0e11-44f9-58f1-08d926903df1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 13:05:20.7930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duYo6oIrTfLslGpKZ6wZY0Ysy1kawCadPyotSPPwINlCnMDvVR4eVteEAW6Hz2fG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5173
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 06:39:30AM +0000, Tian, Kevin wrote:
> > > Two helper functions are provided to support VFIO_ATTACH_IOASID:
> > >
> > > 	struct attach_info {
> > > 		u32	ioasid;
> > > 		// If valid, the PASID to be used physically
> > > 		u32	pasid;
> > > 	};
> > > 	int ioasid_device_attach(struct ioasid_dev *dev,
> > > 		struct attach_info info);
> > > 	int ioasid_device_detach(struct ioasid_dev *dev, u32 ioasid);
> > 
> > Honestly, I still prefer this to be highly explicit as this is where
> > all device driver authors get invovled:
> > 
> > ioasid_pci_device_attach(struct pci_device *pdev, struct ioasid_dev *dev,
> > u32 ioasid);
> > ioasid_pci_device_pasid_attach(struct pci_device *pdev, u32 *physical_pasid,
> > struct ioasid_dev *dev, u32 ioasid);
> 
> Then better naming it as pci_device_attach_ioasid since the 1st parameter
> is struct pci_device?

No, the leading tag indicates the API's primary subystem, in this case
it is iommu (and if you prefer list the iommu related arguments first)

> By keeping physical_pasid as a pointer, you want to remove the last helper
> function (ioasid_get_global_pasid) so the global pasid is returned along
> with the attach function?

It is just a thought.. It allows the caller to both specify a fixed
PASID and request an allocation

I still dont have a clear idea how all this PASID complexity should
work, sorry.

> > > The actual policy depends on pdev vs. mdev, and whether ENQCMD is
> > > supported. There are three possible scenarios:
> > >
> > > (Note: /dev/ioasid uAPI is not affected by underlying PASID virtualization
> > > policies.)
> > 
> > This has become unclear. I think this should start by identifying the
> > 6 main type of devices and how they can use pPASID/vPASID:
> > 
> > 0) Device is a RID and cannot issue PASID
> > 1) Device is a mdev and cannot issue PASID
> > 2) Device is a mdev and programs a single fixed PASID during bind,
> >    does not accept PASID from the guest
> 
> There are no vPASID per se in above 3 types. So this section only
> focus on the latter 3 types. But I can include them in next version
> if it sets the tone clearer.

I think it helps

> > 
> > 3) Device accepts any PASIDs from the guest. No
> >    vPASID/pPASID translation is possible. (classic vfio_pci)
> > 4) Device accepts any PASID from the guest and has an
> >    internal vPASID/pPASID translation (enhanced vfio_pci)
> 
> what is enhanced vfio_pci? In my writing this is for mdev
> which doesn't support ENQCMD

This is a vfio_pci that mediates some element of the device interface
to communicate the vPASID/pPASID table to the device, using Max's
series for vfio_pci drivers to inject itself into VFIO.

For instance a device might send a message through the PF that the VF
has a certain vPASID/pPASID translation table. This would be useful
for devices that cannot use ENQCMD but still want to support migration
and thus need vPASID.

> for 0-2 the device will report no PASID support. Although this may duplicate
> with other information (e.g. PCI PASID cap), this provides a vendor-agnostic
> way for reporting details around IOASID.

We have to consider mdevs too here, so PCI caps are not general enough
 
> for 3-5 the device will report PASID support. In these cases the user is
> expected to always provide a vPASID. 
> 
> for 5 in addition the device will report a requirement on CPU PASID 
> translation. For such device the user should talk to KVM to setup the PASID
> mapping. This way the user doesn't need to know whether a device is
> pdev or mdev. Just follows what device capability reports.

Something like that. Needs careful documentation

Jason
