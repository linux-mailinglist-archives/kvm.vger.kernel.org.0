Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A2C7D8393
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjJZN2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 09:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjJZN2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 09:28:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE941BC
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 06:28:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlsyhAnLUeGF6kvVl1S12JLScv9qSCbGIp3Ht7pIqIgCNyekpap66pVxX0SyBoVoxVlpQ0GCQmxkytFks2KSjvnKwFNfOi3BdXhNbyyZOXbm9eqjn8FGo2Qn9RtA03/x3TdRAJM/9xbbY3U3AnRuc7oiefrmLLKV7VEE52s78iSKqZL05WnKQo7fBXw9Sy5nKY4vg2GCvXtejMlehrY45/lUM2725EuVAgiRASVKIA03Jef/0GHGYq59XVcFQ18MzXpw3w1uo8BJbcDSxDedwUKzDa2RzCBZEH9LWyDR3fkYnU5PxEejDXVsEOs2eKoc7lqfEFH8VlBLbCiWEt+cWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oH6FXkmVl3GDZzRvNPacE1jPvbJKmXowitWKsIAAhE=;
 b=XtdvpJIQFLbQgsMbkJRlonb9cSEJpXyO1rjn01yCsnZWFrE+rXfmB/spxenEeGyykBh65xra+m+S0q4HmdmYTOLXnQ88jWvtC+U5ZElchXSv/jYSYN5PDy/FW5K/OzBYAUGkalvbzmFbQC16msmrk832DcA+tG6kMY9GsIv22n9KBA/B+cdMjbkKREKJQdFcCcz85e7S6NeFWBa+GOqeF7bOAcvzQTwEAWuX6Ow/pCWvk4xNq9aT7AJLdYZ4O1YHy6r/7BD3CobEiQydys70noNovf7pFXio+qi0rtECGx+CVw5SnH/seUZxrtSeZzWNJ670ruQ8yvBMcGYFHFh+8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oH6FXkmVl3GDZzRvNPacE1jPvbJKmXowitWKsIAAhE=;
 b=c8EuJSMHrJCunzME8NMjnjCmf9U56mZ5q6xWV6u52Y0ob+scJtVAEsKV4Sv7klHgsRoeoLxqt3xSNK18sOy9u/v7ui4L1aTf/hExOALvTtBYHQz89QXLkdHIEMeOcpp5vka44UUYQ40Ziy4fQM4AiySuln3EEnMWxAs6vs1khM+0gSK6zUzACmtL++Z/CVobVDbL7yDXV3BRHlAIfVeRsQW+IPoul0zlWjfAWD+5AbsvmUJBRfZLqpgFtnZcI7M9/OSxJNG+bMBj+GxlfenSBGBQZ3500rvlxyeOAHWdAQO6HrVDbYAbU6KEyu2H2H9QcK1xCMhduNB+H0iA62q4Rw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB7765.namprd12.prod.outlook.com (2603:10b6:8:113::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 26 Oct
 2023 13:28:19 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c%4]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 13:28:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaAP/t3dG05nYg50S7FQsh4+CEA7BZZo+AgAE4i4CAAE2RAIABG4MAgAABLoCAAAcq0IAACmMAgAACvMA=
Date:   Thu, 26 Oct 2023 13:28:18 +0000
Message-ID: <PH0PR12MB548167D2A92F3D10E4F02E93DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-10-yishaih@nvidia.com>
 <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026091459-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231026091459-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM4PR12MB7765:EE_
x-ms-office365-filtering-correlation-id: 7dd781e7-ff50-4fd1-b579-08dbd6276afd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sepWkm7+FWyHfvsxhgG5CrpYbUmGpJW7+t7Zl0pVFMYp3kJ2dBV9786tinc/EaWU+RFXkwBpnkmSLi9qxDRbT548HlZgoawEakiLJJs58MSnMhqEcyv8XMsDZEGkt9QqPV4i+aZkEOrWjhSyQefR8U9DQB09uPdiu7W0STLp/xsIL1NpS11vmjWxcsJUsUT26sRE9yCWPZU8WSTgoubyKbmptiL3gTUdIHPYfXWjosaxmhBM20hRdoxv1waNMtUzJ0S5nPzkI226cR41LwpA8gRjpMtcEwzMYez5FvNmbYN1CwSpw/1rdCeFGRn5Vjb0fNR+W2c3UBcdvHy2/dM3yTsmus4kv34ANnqJqsTivhouGaPpGM7pJmlCAZ7S7TmIOG0qV8Oa7bKvpz5PTmxcGVEPodWqjJXVlxTI7av8szFIfC5FQ3fYyv5WuWXVuLDeQZaR/uXgapstCPgkOn4CgkC1hvio9/drhgg0gnmU69uFadxAeJQqOXagmgnBt8pf8lt1mZLCZ0xh7HV1MYH9RqU25abJ40BLImZnS/7Jl6kqr5dyQUEGOnj4TBjWlsBFSalgrgH+xkpWkNPS7/kfQxtUtJWiiwM2PXfHaqNdxCVaFnU7DrEs733EMoeMeGbE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(366004)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(9686003)(41300700001)(122000001)(5660300002)(55016003)(107886003)(26005)(8676002)(4326008)(8936002)(478600001)(66556008)(66946007)(6916009)(54906003)(64756008)(66446008)(66476007)(76116006)(316002)(38070700009)(6506007)(7696005)(52536014)(71200400001)(86362001)(33656002)(38100700002)(2906002)(4744005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gy4HDgJg3LrXw0SoEbCJ6O/xxI5iVoXk18yK2L8mvbAGi1xNrZ6oq6vyA/b8?=
 =?us-ascii?Q?L4jgb60rB3fgQsy6RtS5kTixjcJSoTY+I64CLGzPXTHA4wUMih+GgZ9c8KWj?=
 =?us-ascii?Q?Ml8B64VxDbwNCt+904D65RXA7QcvIM+cJ5SXEaKC9ZgTW6i1mhn1QnAL0/Q5?=
 =?us-ascii?Q?Ss0iqGp7THqXZHrmz2VoAUC//hkKhGwHakWW2PqwJ8FYck0mCy2R0+VdZ70X?=
 =?us-ascii?Q?ShU0F/IYvj2Vrk3M0FqumWoohHTanu7ZEszoUQg7eJKk4PTeQsrcNLxsrNfj?=
 =?us-ascii?Q?wY6rhc1UEvOqMNDFjUDD4G0KKn7GcouUsGwA0VE8eCVzJuK9Fn9UQVYKwi1C?=
 =?us-ascii?Q?iWz1yFHE221JqX6sJfP09A8pUwAVhCD3JpY2fm81VIbMompVTPvcA/OnGpyx?=
 =?us-ascii?Q?RbUs83IAyAj3KeDX4bVKElpEkAKOciowiYtkz58ZH/MdWnLsdEAfjHQ18zhw?=
 =?us-ascii?Q?PkT2qiOW4YHaTKBFgL7eRD3xni/Szbd9/+dpqYx+keuVrmbi9/m9fAF6PFwZ?=
 =?us-ascii?Q?KQGcwwM3MWtliyfOJohpSsMFvqmM/AN4Tfv16oPgV2AjGpBLdlCHwMmvWe4t?=
 =?us-ascii?Q?RtKsxncdt4z3SjbcCBtJrCbISsPiO09vbQUAjQevVfDVHJtQ1CUqcABC6dnO?=
 =?us-ascii?Q?KuDOaVLwndJoqi9aIqIYS7Ox8zEqM/BwtEcb6TmCLAnalvMB5ctA8W2zLXnl?=
 =?us-ascii?Q?QETytnpNdBxoh6dI/KCfgXxzK3Mbp3S2GL2qLWD3s30kis+6/tUgdgdIMy6P?=
 =?us-ascii?Q?pIJNpRLlVn+T1cWNM4I4GfW3TdlFJN2cSKamhywEkOcn1/MJL7DV9tzT9PPN?=
 =?us-ascii?Q?HQXCfuoev+h6MrZKilLMUytRy3A9BTtD3Sxthy/fyQFqehmzyg9GiPHvfP+m?=
 =?us-ascii?Q?9QZpEX/sznlGL6sPm1t6FtXblHWIHWbFovIi4JzIPYRy0qmgFIVE3dQE7tIy?=
 =?us-ascii?Q?AP8tCSjk0v361CNQkaBhDcrX5iZ8giGWQKh/ILJ2rOLi3+g9aLNamIoHA5tk?=
 =?us-ascii?Q?5IbEe3BSmRLOHfCrRggIHgnIjC2ZUFydBDv7xKvLW5PJL8NOsd3KIKuVCYUp?=
 =?us-ascii?Q?Eg7qkjXbzKh6HmvaWB1XcyXYNbmYDRCVrginiJ+Htq1MIbBqJulDJVtV28od?=
 =?us-ascii?Q?t5mpoGPMxat5J791YApH1YHmDAQ/5igINkC1u/dcchCXbZ9pKaAegRhVE9cL?=
 =?us-ascii?Q?9swbVTt/1erBLluqe/Zd/7lSzlAzNhqboPpqHzYSiHI9I6zLfd2NU0Bha4+F?=
 =?us-ascii?Q?XTORaR9qtzvdwxj/LZdsnAi6pUryH4whaW8YKXzrpYMxZ/sPp2QMFnq3ySVq?=
 =?us-ascii?Q?zxk4eX6nDnCY9D7U20p0a1CQ95tRlmMjsXnbntuXgLrRFnkJuZqw5GOiujdC?=
 =?us-ascii?Q?3MXAs+7vxz/fH/7KLyHoMBP/kLif/KXpQW3G3rSskWFw8wLswVjTLBwKLVBu?=
 =?us-ascii?Q?EYVTo/ogA4HPuGVY2VRgZ94kazVSePO/6ghWFB104v81+EpwZ5yUR7T237+w?=
 =?us-ascii?Q?B9YtYTISuHtStrfHBLjRGy1IDaGUcBpApNC32aGqkGM0eQXtSZdCYdpLCXwU?=
 =?us-ascii?Q?n8EJ02gJeAAVLaYwNGI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd781e7-ff50-4fd1-b579-08dbd6276afd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 13:28:18.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqNt7Elsyyv2G7FoEgx5E17nz2L1sFHQ8YF1zypU1vviYisqYDH/lvlTNhEBf98ER8YGz/tTTbheFKlWycEzIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7765
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, October 26, 2023 6:45 PM

> > Followed by an open coded driver check for 0x1000 to 0x103f range.
> > Do you mean windows driver expects specific subsystem vendor id of 0x1a=
f4?
>=20
> Look it up, it's open source.

Those are not OS inbox drivers anyway.
:)
The current vfio driver is following the virtio spec based on legacy spec, =
1.x spec following the transitional device sections.
There is no need to do something out of spec at this point.
