Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7420A7C6BF3
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 13:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377488AbjJLLL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 07:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343805AbjJLLL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 07:11:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2171994
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 04:11:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCED4Mhz3bz2/oRH4c6Lmu60k+a6HcFJePpxLqfDi5AtX+du+A6M9I68eZFRvNeaxEB/sSHviOsQTg1hAfxUk+sFQQ001XZV6i+ea8E1b5BmQiP8GfMKJqHcXNFJOLFxuH4qkjJURIPa6mwHQ7c4us8XLX+MLxa9NUCtKVUNgSWOmOgj1JMEyoobBrK+IdwEQXVzoROK6cZvOblkHOiF34Ncyf6F5PMNQma7rNrqgyzS7xJBxSonBFUzH3lUWwaa7n8yzjGzANr+/cwGWFgB0qCIcGcsvW5hvsJ8NJAwlM+t5OwL3+SOavMafMsuPzUp4gF+N9sJQSvkOzz+3dxRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8jGzel1SgOmAzau/1xvtlATpwvaq3KTcVCm9e8ikFc=;
 b=kP6fXwDhPHK/9TIJDAmX1NdMkgeqWTmTcFv/C6wdgsxsO8+DZdvShnCah8uUn/jO0fMwM0Z9I2alqLVDaVd0QuuwornY2PqcRe/G7deBrLuxcXCVpA9VLohjGSBCa0LQp3hWZ0ZDB8D4+2+rKhfUw7/p5LcBQmreZDf275/akfOzbW24dsXM1olAt08zmjOojWBojKJD37chM9vDLeFncTYFAKPhepp0hLf6CHBH6eQS2IBbwRxPEogmmX171n/oZa+3U7YdLnF2XJop3J511frLZTTbTghymPPMAviSHoWi0cHijcJkZ4nbTCk92y3/9gWWzy3F6UnmzGO/NChO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8jGzel1SgOmAzau/1xvtlATpwvaq3KTcVCm9e8ikFc=;
 b=AnEWKr6+poluLoLZmllkffbk46CqtFTcGF4buLKRYoqxX6xTIwKMU7DmDTAtCAQOhg5ALAt0YUMxandDOia5hy5sRWJ3WZc4lwQvwDFG76+IL3INPV8YMD2fS61eFXMZZOyADKPpo7qTwXiCNAH7DZ5IUu557Owaz7HRm1WHfrCCGvZjdOLpL8xxqzmbP/63Bb+Gr3bGdI8FK/wWKxkg9yN4OPpfy1nWDV0NOrGfdP9U2BxZsze/U/HACe3Mi3PwQbQtUPdGXwmwfiYt0fwvTpvo/D1dldW7J23bCf/Xqz+4JZ+OBHvtK1aaPSlKf/PifSDGzNxqKh06DqGXUwuejA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH7PR12MB6717.namprd12.prod.outlook.com (2603:10b6:510:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Thu, 12 Oct
 2023 11:11:20 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::23d0:62e3:4a4a:78b5%6]) with mapi id 15.20.6863.032; Thu, 12 Oct 2023
 11:11:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlfIYAgAACZQCAAAJ1AIAAAaqAgAAD/QCAAAaKAIAAAwkAgAAF2ICAABWjgIAABYGAgAAGVYCAAHFrgIAAnJQAgAAAJ7CABBFQgIAAYeqAgACr64CAAJhp4IAZncEAgAABy1A=
Date:   Thu, 12 Oct 2023 11:11:20 +0000
Message-ID: <PH0PR12MB548135D0DF3C8B0CD5F73616DCD3A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231012065008-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231012065008-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|PH7PR12MB6717:EE_
x-ms-office365-filtering-correlation-id: 9c185f52-e511-4a29-a30e-08dbcb13f69d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mLHB7P8nMXKl3rlKmxOmJPEWOBiHv9mPKe5P6Sn3Mo/CFKX0YcTS2uoZYVoKyfm4oPWSpInuyICu8w7nr59sxDYeP6AnTi4OD1EBQWyQOVEGcrw4n2IFsSJWFqyl8bn5E1Vow41Eg4GpmEpQbL0cxbzJ5F3itORjgtIHS/+SUr0BLy7zYUzdyuGQ/hrxdZxMhtmVK67M3XqldkjUqUVRIxn1V2pmK6uF3n2ubYTH9ftP3P+aTSCfS+5cVPsaCiSQ0UtEgAKJ6FnHHFVnxcw5POyUziceUxuDTjoXZ4Iizuj7/WEOLhS1DTFhx2urp/yGQ1Ztzfk5vpQwunYzp4UcW5s08ThtP4RwWXPghVMuUKxetsRTMT3LG51IzsxHeYneHvp9VSC79pQa6FkZTP5uyyCIf8djsDJhS4N/7n2rETQnJNidmzv3b/RPwpg5Lc8nPYqz3QAhdkuJQgykO534dq6nk3vsc2aNcmMYKsqVMBAyEqs/9EvJJIfNv7A9Qb3J7nptIgthD3ILJiAbtA+khZewt2nqEu6/5mBY4Mas4rXtYzJDNfiiTY7KWArKify8oUSvP/PvuPlW2aT09sb3muQXfbQGE0ZfOR+icAChF5jrw5FNBKlshGtKZ4lAQld1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(86362001)(33656002)(38070700005)(55016003)(9686003)(6506007)(478600001)(2906002)(66446008)(7696005)(41300700001)(66946007)(54906003)(66476007)(76116006)(52536014)(66556008)(107886003)(316002)(5660300002)(71200400001)(64756008)(26005)(6916009)(4326008)(8936002)(8676002)(83380400001)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g9lu2LMmbUJHLkrytbuac0N6xbWtpzEYXn7ubMmLcpXuK7jh1lQxxwEjL0dr?=
 =?us-ascii?Q?6vEIUIq2y4toZBvzJlZ5DD0A5+iNhi0CuQnb6WDi521qd3cm1lnosYOSj426?=
 =?us-ascii?Q?HJn5VfUu07+16mlLUIqR7I9uJb0g7P74e87pOkunbjzopWMEJTRmEY6j9QdM?=
 =?us-ascii?Q?9x7mWu1DuaNhJl3crRZ5G9UINZjRB5t1kxMdA7gfiOh6Z8YqfICceDFAxPGn?=
 =?us-ascii?Q?dyFGPAoIE1jDI/qv8xldjRQ8SH0qMzag/JbisLRx6/lrllL3MHU4ZtL/K501?=
 =?us-ascii?Q?HVenDqJ5+T+VdSLJ6CdFBuOEEmw4Sqg92DA/BXpP727yAc0AaQ5aM1odz0Dc?=
 =?us-ascii?Q?5NKIWB5EGQkGypCRIV8mjgqXvfkF0U7WWRGtra7/Ee75/Vq+mvgDtdqP64El?=
 =?us-ascii?Q?scN5pcfkOo0CpTvJH4RN1yrnWFHqqBoZsg/yFSm+/tlnVZEKARRAWNhRrHUi?=
 =?us-ascii?Q?l3uJU+TtREbvI6OmK9VWRe+/NYwaeJ/sVJzp1BwdPVlxolD0lUWAsPnfC1rd?=
 =?us-ascii?Q?CWVCzm3P9QW3sdj3mshAZ8DxS1NehX285+aMo9H1+acEthQuTn0e9XSn2O9f?=
 =?us-ascii?Q?7eE3+HrLKUdBppwwRZVpkUa54xwtOZh5nzoGTXIh6aAiDb0RGGUtS7+WHAsq?=
 =?us-ascii?Q?cOweUGP0jiNy/9dLWtZul/ldFCSmWAL53h0KYiLVLirPB5h/EACM4MjvlRi8?=
 =?us-ascii?Q?LNsVDf5jx4vCm4J3maNqcFglFVzJ7SkbTA44QthoJLRLcKjLITS21ewrRv0U?=
 =?us-ascii?Q?qj5qLiQ0Sg5B2ckus47cjX/f0CgrU0e1CP3yZ+BYEaPUSddLG6iChqIHy0wW?=
 =?us-ascii?Q?5Gpi7YRmfq1A8RXKgzZoC13Xv/XHKwUT4N4m2IfwAKr8qTfqCkHDSKs4vOUf?=
 =?us-ascii?Q?+rg8nn1PL0BFZqf0A16dada54+tC4spaGyx8PEWGUNUngOyIrPXAWEM7zTV0?=
 =?us-ascii?Q?n1dh7R6vEH6le6fDH6U6tB3Z9H46kSwJNjF34kZLenLnhXzUKXzy6WGpb0+x?=
 =?us-ascii?Q?b0V+TBWLI4ETprIBUy98wrUHfgwHgWg4p1L/zJJpOVhBjCZ8rkoQERxVwX5z?=
 =?us-ascii?Q?6X9dATpU/maimEhk5y5/r0l1Z25aEFkdRiaDr2a+UE9eqvrJOF9ACAxEoPvD?=
 =?us-ascii?Q?clOt3lKMat4wMZAwvlC17601Hk5Xs3JK1BasC+wXu1/9zZf0zBnRX/Htrtei?=
 =?us-ascii?Q?38e0xTsZra5gO0iMLC7LcCGhVxJ6WkGRFomALziOWs772y6Nu/oNzqzfVVcJ?=
 =?us-ascii?Q?vjKuJMhuIApUoz5jwhvdhzzbU+/9SKKbX+Nhy3RZh2XsMvz7pER+j8CisTEV?=
 =?us-ascii?Q?8GrVINXfTFgkjHvvqnTiqpNurjRN0aFLTy/+zbv5zfXlzuucQfZqeUSqP4WF?=
 =?us-ascii?Q?3J8SQxAV1VG4eAMfTYqVpE88bqrJzZW5cR93vUbkiw0awGWy6mzt6DQ0dRx+?=
 =?us-ascii?Q?6uaYpUHHouxEtWEVEOyhZ6MVoP2nFyTXFL6EfmwcTPsL5EBVfwEoC6Q69LsZ?=
 =?us-ascii?Q?BCvEU5+H4aN+kvhhlLhFteYlFhot7mk2SjeeynJLp2agnlEvPa0w3Usa06+b?=
 =?us-ascii?Q?A9CNUlnvB65tNL56IVY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c185f52-e511-4a29-a30e-08dbcb13f69d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2023 11:11:20.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TL8L/4VAtNZwqitOHz/OaCpQ4hQChdz1OPlVc9Af/wg5LlX5YqZB1A5RZm3TDqnJQbafLgug5oA4e/WI4P04Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, October 12, 2023 4:23 PM
>=20
> On Tue, Sep 26, 2023 at 03:45:36AM +0000, Parav Pandit wrote:
> >
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Tuesday, September 26, 2023 12:06 AM
> >
> > > One can thinkably do that wait in hardware, though. Just defer
> > > completion until read is done.
> > >
> > Once OASIS does such new interface and if some hw vendor _actually_ wan=
ts
> to do such complex hw, may be vfio driver can adopt to it.
>=20
> The reset behaviour I describe is already in the spec. What else do you w=
ant
> OASIS to standardize? Virtio currently is just a register map it does not=
 yet
> include suggestions on how exactly do pci express transactions look. You =
feel we
> should add that?

The reset behavior in the spec for modern as listed in [1] and [2] is just =
fine.

What I meant is in context of having MMIO based legacy registers to "defer =
completion until read is done".
I think you meant, "Just differ read completion, until reset is done".
This means the hw needs to finish the device reset for thousands of devices=
 within the read completion timeout of the pci.
So when if OASIS does such standardization, someone can implement it.

What I recollect, is OASIS didn't not standardize such anti-scale approach =
and took the admin command approach which achieve better scale.
Hope I clarified.

I am not expecting OASIS to do anything extra for legacy registers.

[1] The device MUST reset when 0 is written to device_status, and present a=
 0 in device_status once that is done.
[2] After writing 0 to device_status, the driver MUST wait for a read of de=
vice_status to return 0 before reinitializing
the device.
