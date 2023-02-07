Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA83F68CD83
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBGDg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBGDgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:36:54 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69EE15C96;
        Mon,  6 Feb 2023 19:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675741012; x=1707277012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BGdYhRoehH55QmrlSv1AP7DN77DvIhahxMYnSw2XxRs=;
  b=DJ6X3mR6/s/oQhJ0d0m1kokp5b9Y9ipAxeK8D5sQDc4XfKobTvTGCf52
   1x3Lbz4dYmbNfa+B7LCcFTlmNorLhG/tk9ePOlbV+17VhdhZAmBdkSOVB
   OmUSLTlsiPuoEGcm0xrscp1AADGfJguLALR0/RcRQiZU41jk+38MyN2iL
   WuWZEnMPZL8Xxpc+2YnvhCuKssOTJvcfL2wb34aZ85eg6s04EV9E18bN1
   8gZvXIB+T0vqt+cRNKOTfUNQ6XOsD+LZ1lr/kSoFCb+uh1wZxAYKoRcaR
   PiBD5l7Gt3X+upwHULwcn9csvyLMtdijsUzS+XvoCFvgmEsLf64GGhJ2i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="391790023"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="391790023"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 19:36:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="840614847"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="840614847"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2023 19:36:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:36:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:36:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 19:36:51 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 19:36:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNzjCnMkXXYvVHgCCIk5JKB9JBXRSwXH0NTFv1+qDwi8Ql8ev1dbp1hGhllDRb2sN0Bi/sMGHZnrhV3s69asgylBc7E8w8WrFZmC0+I1JrqMD4aedmklwZZBEpBAFZrFHB4sivZPrB3FOUrZsn9NEXK56Zwx499WN6Zj8Am2ELuY39BdpcZ1mXtmg6HMcTZZU0xm3b3HhbHY28vbGBA9YUwxKpYh2AiGd0/Vu+mzlnMqh2zmoil6C7bDNNHVYxtrklMV9mFQALgMSMCj5QvPPandbPWNzEu3vLft+iD6TjUnfVe93a205YVU3/v/YkHXtNUnzIRDi3QB9dUNfnyLrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0adv70J1r1j3DhlxRk+ReUl4aspJ42wDI9rWNn8ypoY=;
 b=ltQBCL6KMTstTrEAI5bfL59iKl2grYVmG4i5IXqrRAqqdxDoAEDTThnufI96sfI9aMXkqNPRYHMmtGlyEAeYac4UQ0FzM+0xMOJoiXtJDcj1Two+wY+jdMdD0URE0ayaQOwjGNlbf55I8EzpevYOWeWC3gcz6GSwQPnC59+3UE+39JClYmt6a1SW97JhIBwNgQZSR3AG9EMWirdD7vOKuIqD9CC5xZRyHDbCaJKFWtTgIDaZC560KfuB+wqN8tPJtcNuJLQgqfXOhmnjSElYIWd4TLYgsE3UfY7mRBeLuo38K2XTTPFWM58LlI/8xiC8phVVtbspJ7EMmI3+dcZUIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 03:36:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 03:36:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 05/14] kvm/vfio: Accept vfio device file from userspace
Thread-Topic: [PATCH v2 05/14] kvm/vfio: Accept vfio device file from
 userspace
Thread-Index: AQHZOgo2enquzi+bhkCRgt8XFHLg9q7C1IrA
Date:   Tue, 7 Feb 2023 03:36:44 +0000
Message-ID: <BN9PR11MB5276CC3B1773CF183E147D6B8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-6-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7194:EE_
x-ms-office365-filtering-correlation-id: d220efcf-1bdd-4c60-7dce-08db08bc88df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XAUMkLq7KsPrKFYsT71fAv1btWViLBJPMCFptsRNplRrN2QmrFn7rGcoigz2ABOdA7tSkTVuXdTtljbmBwa0rry9EZtzZUhK/7h9ZB4GwWrVQ8oJQR6ruZuaSyFzbl9zFafNPmw2eb6dEY3qr+2ZaQRNdvHqvnKrEXz1JVV5oMhLquuxnufzzA+8fwRFl/19pBRMI10CRrtaKnGDivv2YL7iUekmjXVScMZA1Eaomw4PDYJ0jXetNyRmESqEuzZkntg93NhSBOLIb4vZNGlUERExMY1P0GMuHum0K09iM+WUnNPjmIvEPESBbtzXUI+PIugsB6+FNrMUIQQzD1BFiK0YBkhl/86spKj6B0GpGgsWoxofuBJ+nOPIZV3qc27pPr73deCAzeB3/U8Eu+uGQqcbQBIk2ktfh1YzMh3Z0OIFDX+gl1eBkd28azs5L/25sA9Hzjrso2A+9r/RNj8LIcBcZ5SRX82e4kDfp64Ln/bvulUDpCOXMdtNgjYZYtlbss95i9D9EU7zAnOpvLrl38/em1N4/pfSxf/+zcOK0rEzO89+O7MQTOu8mwqjbO2QHYfR5ywn2sqJv8uiERb86yrSKJ5e3FIB4mnYIYYk7kBwQ2cEaVMYKX8AnnqZlgYG4ZNJVn0fgCb2bo7C2TD/ksPeh1aiN2VhYS8i6ydNX+ZCYOqOCC3P0sKlmXC3OcpY2DNxH29YKwrG6MSzdlsg/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199018)(33656002)(110136005)(122000001)(86362001)(38100700002)(54906003)(82960400001)(38070700005)(478600001)(55016003)(8936002)(7696005)(71200400001)(316002)(41300700001)(52536014)(64756008)(7416002)(83380400001)(66946007)(76116006)(66556008)(66446008)(66476007)(8676002)(186003)(5660300002)(4326008)(9686003)(26005)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aoJLJNfHnaDMWS9a3XJ64Puciweh7OMWDlqzyHFxiYdmq/q1+A4Azn+2RG2F?=
 =?us-ascii?Q?VKBDA2nGzhzmFVEyO9QK1VyGcLpCGfUP6A6idXfeWdIxKtvmxGUFIgBZHbWU?=
 =?us-ascii?Q?vfTw9l8sBSPdPnA8LdD/A93bUavcpadQfVO01jBQpKe9N4gS/GlOw9ttFo67?=
 =?us-ascii?Q?JKJ2jO/h45I3tirFMuzMVLAaQw0FkOMY54al7sGXMQRti8sQ/8OH9p0LNEb0?=
 =?us-ascii?Q?rvDi6Y+gb3OTXQqs9HTuDHHBdfp9fP3Zi45ArLbXOLiHe5DhFS4EBnc9WxUP?=
 =?us-ascii?Q?HfJZoTU2FEe01GUWjEQwLHhQAl9aQcSnKJ5d9Aa9eUru/REubSMElpP3J7tn?=
 =?us-ascii?Q?Mn5VDDU1mSxjqBSwwxzRpkOMdTwhCOZazEMSi8Ux1fxaTCv8i4fXucI6rEum?=
 =?us-ascii?Q?fcR1kadbY3Hg3RsMNVO9UD9GZ90cbdcqMLtfvJ7QWwWT8fi8Lf6f6dN7lV0z?=
 =?us-ascii?Q?wYsPtu7Um9OnpWqgEbQFI1n0XnY01PEhnJqglgjaK7veuoQbTRdMWtBckMJ9?=
 =?us-ascii?Q?qgln998p9S+ky75AkXZW/N/Msm35rOcKAdslMHJ+FYcFavuW6D7fDID2acXU?=
 =?us-ascii?Q?TU1PyIvkRSwALepW5FTixjz0JdWnwBVpUnFS7p98znCqoV4BllrACzNv82Iu?=
 =?us-ascii?Q?7U7jE1da+5ZevCg7CGLRC2AHGnnyviVwbdch19eIqMKJY+aMMvoq7gF+p2WB?=
 =?us-ascii?Q?BNfPi3K5tHbMIWrL23F84A3eYqyz7wkG6bXaoIXtut2lCfb4uDguxGP4TXLf?=
 =?us-ascii?Q?opTA9Hg88pyI/3xwJwmKmb3KZ7hec2r3/xwt6PCBijN6u/vyMwfmeUdxUF/n?=
 =?us-ascii?Q?FprSiq063DMzHpu2ArdGaMsIcDZx08T2kSNCgktKhqcEEvpEbFzYydet/n4S?=
 =?us-ascii?Q?QpWNA9rvpZmTlRJ3Y1XJBEiJAXcX58YmNbFn1gAvtObaTyksUJ8S5LIgu66y?=
 =?us-ascii?Q?Qs3BX8SUjNKmzgl62yN5BukPWQC8m8fmujI7FMvAFSNTx6QYmRaGDkPAY4Lw?=
 =?us-ascii?Q?grjfAHjLyDBRKDD2ASgvHn6BtMWsr8qHqb59CysAhhHDyBPviN9oEAaZNSIP?=
 =?us-ascii?Q?eaF3KzN0YKy78MmEX6RNUKFKAzKxms3QDyp8F3eGivoYdXejA3pcN2rj9q7+?=
 =?us-ascii?Q?srsuPRDFAns++Qy1ro64FqETAEerV9+5gloEvo3EEyX3VZJ+zGabtLr6WjjC?=
 =?us-ascii?Q?ngoLChsnVpB593O5Ld9Cxe1eDf5bJM77hQn8ke0F7Zta+P5Fvbl867a0tFmP?=
 =?us-ascii?Q?G+DFokJ3pQ1d6jdNTLvqEM/sHDFd9Sub/Dq8XAIXlIX+Z646rH8Z+m2Kycpe?=
 =?us-ascii?Q?Nn+iG1lhoIb513Ye3yftPHn+6MfR4mT32OQAPLEjPAN6tBgyEQeOqcj4VMGF?=
 =?us-ascii?Q?CgA8k+DGE43kFWFph6Wp4fvaUEET2F+mhKKGzw1zInBQZkips8CNUVPi693H?=
 =?us-ascii?Q?IviED+V1z1iNehyDkRZxlrhb6ihcNt6/I6g8GnfGrgI7ggq5vZ2vvpf/hFxU?=
 =?us-ascii?Q?ZlldQHZx+51TJUxf0dX+IzSHpQCmxRPZaEh4LcwrOjzEyhILoh/vtJPDmCjA?=
 =?us-ascii?Q?9NrqEqLac2QsUIMd0Z7QBZBEW0i6dNY3ls4ZqNhI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d220efcf-1bdd-4c60-7dce-08db08bc88df
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 03:36:44.5966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCjFwrdTRB2OvvoyqpCoOVzyctlOgqXn0Z1hcI5aAWk/A3XK67u4KQj/NQxSkzt3cc5IJ0/nmDiVjV5Iwx2IIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:05 PM
>=20
> This defines KVM_DEV_VFIO_FILE* and make alias with
> KVM_DEV_VFIO_GROUP*.
> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 40 ++++++++++++++-----------
>  include/uapi/linux/kvm.h                | 16 +++++++---
>  virt/kvm/vfio.c                         | 16 +++++-----
>  3 files changed, 42 insertions(+), 30 deletions(-)
>=20
> diff --git a/Documentation/virt/kvm/devices/vfio.rst
> b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..7f84ec26ca4a 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -9,23 +9,26 @@ Device types supported:
>    - KVM_DEV_TYPE_VFIO
>=20
>  Only one VFIO instance may be created per VM.  The created device
> -tracks VFIO groups in use by the VM and features of those groups
> -important to the correctness and acceleration of the VM.  As groups
> -are enabled and disabled for use by the VM, KVM should be updated
> -about their presence.  When registered with KVM, a reference to the
> -VFIO-group is held by KVM.
> +tracks VFIO files (group or device) in use by the VM and features
> +of those groups/devices important to the correctness and acceleration
> +of the VM. As groups/devices are enabled and disabled for use by the
> +VM, KVM should be updated about their presence.  When registered with
> +KVM, a reference to the VFIO file is held by KVM.
>=20
>  Groups:

"Files"

> -  KVM_DEV_VFIO_GROUP
> -
> -KVM_DEV_VFIO_GROUP attributes:
> -  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device
> tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM
> device tracking
> -	kvm_device_attr.addr points to an int32_t file descriptor
> -	for the VFIO group.
> -  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE: attaches a guest visible TCE
> table
> +  KVM_DEV_VFIO_FILE
> +  - alias: KVM_DEV_VFIO_GROUP
> +
> +KVM_DEV_VFIO_FILE attributes:
> +  KVM_DEV_VFIO_FILE_ADD: Add a VFIO file (group/device) to VFIO-KVM
> device
> +	tracking kvm_device_attr.addr points to an int32_t file descriptor

"... device tracking" and "kvm_device.attr.addr points to..." are two
sentences. They are deliberately arranged to be in different lines.

> +	for the VFIO file.
> +	- alias: KVM_DEV_VFIO_GROUP_ADD
> +  KVM_DEV_VFIO_FILE_DEL: Remove a VFIO file (group/device) from VFIO-
> KVM
> +	device tracking kvm_device_attr.addr points to an int32_t file
> +	descriptor for the VFIO file.

ditto

> +	- alias: KVM_DEV_VFIO_GROUP_DEL
> +  KVM_DEV_VFIO_FILE_SET_SPAPR_TCE: attaches a guest visible TCE table
>  	allocated by sPAPR KVM.

somehow here it should emphasize that the file can only be group

>  	kvm_device_attr.addr points to a struct::
>=20
> @@ -36,6 +39,7 @@ KVM_DEV_VFIO_GROUP attributes:
>=20
>  	where:
>=20
> -	- @groupfd is a file descriptor for a VFIO group;
> -	- @tablefd is a file descriptor for a TCE table allocated via
> -	  KVM_CREATE_SPAPR_TCE.
> +	*) @groupfd is a file descriptor for a VFIO group;
> +	*) @tablefd is a file descriptor for a TCE table allocated via

why changing above two lines?

> +	   KVM_CREATE_SPAPR_TCE.
> +	- alias: KVM_DEV_VFIO_FILE_SET_SPAPR_TCE

GROUP

