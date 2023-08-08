Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E583A773E3A
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjHHQ1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjHHQZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 12:25:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820A08919
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 08:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNy36oalGKqz5M527wIGgVIVrGGhsFgh30L+tGm0t4DuJ7/JvlBVYKxeeG7pro59tDzK3DulHiKrbPDhGhbKb3KWKRZfrSYGMfClUpcONyDuqZOwzOVxZZLm0N3p0l8obs7B+jIN35Qr3tlpdTs4FUurUBJQpvik2frlJCx/HO4E+u9aO8tRQESFNqT0154zno9DLsPbVJqlacAKxlIeu/aQVRDGdn7hzuNm+aN//r/cxK0WjHGm/rYtkystG53roGoBhIs2K2lz0NlTIuZdOFCPRyu/goFYGKKMULuviPiW7YPwVA4Thlp+r94fG0rwirecNiSNLSnFY7BVYMLI3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nhKHbSL2AkjY6Equ0TAxu1WJCAmhv1vrwJ3PJs1xK8=;
 b=RX+7Z/z/OYptOBznAHQhDE+MSzY6gAjJKwjHoDMGcQ/Su0ybUrNZV7hvMZ2Hgel2+2Q9ei6EPIThpKDFq43+7ohDU8s5knrj00Har/uraQ23jrpTHFdNE+xB3OOHHGSJM4N9QTkec498FUBPk4RYcbBOVFVPmdlneOlFt9LfPWRYVUJ3a3YoxaNvMWosR0dD67oSKQJ4NoDMiTbRhvu2kJgeSbCfIDdeXlCKigj7sQFiMCUIqhKzjbTrWmfCpnQA3Nz3huZ+bHvuYjYBsAZVfq1kkjBNHIpDXRwmiFgjgWfAp8e7ytZ9TeUAQ8Uu7xVt+kRPGCQdjwtF9g+ggFrIPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nhKHbSL2AkjY6Equ0TAxu1WJCAmhv1vrwJ3PJs1xK8=;
 b=0lr++oCGL44F+bF4L3t3mVEvczOKV/qv+aOAlmZ8rkNpLxb57JHa3BPRVr0pAsfTyEmHNbwwMub28NBE+WMoICDjRk0ia9Evh/MyvLj7Ext7g+eZffPz/OmcOp3fR/4OxdHt2geNfyng/fO4YOvEmXJBhaB2SlSLwDWdb/fcdIc=
Received: from BL1PR12MB5333.namprd12.prod.outlook.com (2603:10b6:208:31f::11)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Tue, 8 Aug
 2023 04:23:58 +0000
Received: from BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::8dc1:76be:ae4a:6c29]) by BL1PR12MB5333.namprd12.prod.outlook.com
 ([fe80::8dc1:76be:ae4a:6c29%2]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 04:24:01 +0000
From:   "Agarwal, Nikhil" <nikhil.agarwal@amd.com>
To:     Li Zetao <lizetao1@huawei.com>,
        "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>
Subject: RE: [PATCH -next] vfio/cdx: Remove redundant initialization owner in
 vfio_cdx_driver
Thread-Topic: [PATCH -next] vfio/cdx: Remove redundant initialization owner in
 vfio_cdx_driver
Thread-Index: AQHZyZ1297Bqi+fzdkOfCGfdRv5Yv6/fzKPw
Date:   Tue, 8 Aug 2023 04:24:01 +0000
Message-ID: <BL1PR12MB53338F49B93B4BD727CEB2A29D0DA@BL1PR12MB5333.namprd12.prod.outlook.com>
References: <20230808020937.2975196-1-lizetao1@huawei.com>
In-Reply-To: <20230808020937.2975196-1-lizetao1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ActionId=ed1d176c-ff61-456f-befd-31b7dcc674ca;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_ContentBits=0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Enabled=true;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Method=Privileged;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_Name=Non-Business-AIP
 2.0;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SetDate=2023-08-08T04:22:39Z;MSIP_Label_64e4cbe8-b4f6-45dc-bcba-6123dfd2d8bf_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5333:EE_|MW4PR12MB7309:EE_
x-ms-office365-filtering-correlation-id: e14dca2d-6380-41b6-0ff9-08db97c74b02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IABLofnOUpo0ZK8OtauAZuSBvHkZL0anSRSnCDLv2EKUrNZfPImumehAVhbec7hdPgvJCOc0Exj7jqdjRX5hoGAxZ1Q0fO/XqnBJCAxhNSZ+wG4u6fpFuCqpnWY9uSc0wITRqZLDJZB1WakuCp8+cKJlNYTXnRRkmkodPFRbZr3L5mNHkDgRp85UT8oKRLCdOo3Xi4Ve0RQSfmYAfYlVHAFIXhB8TReHXnkIS+l5Nt8TR0Oqdnmh46NncfglghUFcqRNyvHUFPwXRrW+VHd62X8fcsoH1NjfdZxtG2TnRtkVGUjRQBo+VDlyeIwaVlm0/7DVs+fGut1mO6i2fuRvw6CMPIYTO657XPUThlqmDDNxvnHexVD8ooe2qL8uQV/baiALCSVsJNNRmgSbBRvT71pKlAijjqnFfwrc3KB3sG1OfS1wc/odnwYzenyKSK0PX1XYZjZa0bYkjo2b2ASbOc4+C7ME0Q5kE2pamQ++E7YwZAOk2ao18Tohhhd6HSgIAMjXyHvV9PZ2WROODcjUAXE2YraLJp1S+3qY8SGLaA8DtoLjK0oTGw4tcYg8M9O326jgK6yVOT/Ynoj/KZwmKwuoomolRvvFCBXK4kOFr2E4s8rup79xnTNTjqCe9MBZS7XMCzX6k99jiFj6AAq0U9X9b4AEvGMT/PXjuWhZHiMC54VWrhapDY1v4pjy/zC4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5333.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(1800799003)(90021799007)(186006)(451199021)(90011799007)(4744005)(8676002)(8936002)(478600001)(33656002)(26005)(86362001)(9686003)(7696005)(71200400001)(316002)(41300700001)(5660300002)(55016003)(64756008)(4326008)(66476007)(66556008)(66946007)(66446008)(52536014)(83380400001)(110136005)(54906003)(76116006)(2906002)(6506007)(53546011)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b2WTe6DAd/nVnN5nRVE5wzSFupVH/8yrboipLzc/3b1DaDN8pLtulPHV5fmL?=
 =?us-ascii?Q?6CkeIDQV14W27WRAGy88+Y6PpUU6/uXnhXzljyyNxpD71Tj39gz46yPn9ba0?=
 =?us-ascii?Q?RT6bzHZ342eBdVig6PTZ/w3V3rmDkBtsMJMYqm0G5/9TwR96CLO/Egzm9kk2?=
 =?us-ascii?Q?H5QSgs/yIZe65m/JVosf+Sg4oGBJ0hTwYvJI4s8/6SizBpX3L9t/lC2/7B30?=
 =?us-ascii?Q?R/F+2Bhmicrl6fnEXm6Xufu1cgf2ADXg8ktpEWFggR9NaE/ri8gYGpb9VgDQ?=
 =?us-ascii?Q?GG7oDKRJEjqQ0n2UCOzp6xnhdHXZTaxSkyVi/7sC7eL2uyFtI2A1rrKolAog?=
 =?us-ascii?Q?rWJyj+IgwQ6u7d2HI4MDt99O9W0lg1308H/ivBTRttEPGZIjhSPRwcrSzMST?=
 =?us-ascii?Q?vbvzTqMy3DA0PQEhWl55uVMjNa0F/u4UyiPckI9yoe6OxuIbmeu6aSH1297r?=
 =?us-ascii?Q?ggVGS+327C2crv8PlNv2J2Ppq8VI8NmxWI9lJ9+uFLEy89Ljf9TWBqGTEqoH?=
 =?us-ascii?Q?43X36ikBDTYxhkaqa58PuNlEnLuu2bBXsScgUQRoA75seqVgW1CGYQyDBvqZ?=
 =?us-ascii?Q?566GAIsUuNDJMkKKrwJQiu0lycRTojRGtBY8b6Z1GoNUEQGqazdI46JJ7A17?=
 =?us-ascii?Q?3Gxt5h/2oLY3GwTqs849pHj2HZ+dp+ctSXRurVNevRC7/Obve9dg97vyVPyL?=
 =?us-ascii?Q?1um/bvdy80lS3MunhhhKrxcjrKv+mDf/5n7+/NxXZUES/E5NL7XxiJY3f6SM?=
 =?us-ascii?Q?7/FzlHnBKT37ANnjBsTWG/XXJagt9Gt1EgaGYXLSkNd1mYHOK01USdcH7m6p?=
 =?us-ascii?Q?4qr8etOT1wDq4w5lGlaVVvyc12TTQAQfGtkUgoSc0vK5hknzhf3XGfWIuUlp?=
 =?us-ascii?Q?k23FowDvdQ0rhnUOmWlBi7CD+hTDSY9QOab1r3tw2IZBeB8syucvUi4Ob48R?=
 =?us-ascii?Q?c/l/ErM0i0EQIcDaQG1uQ84urcaZRoBmtlYMq6eewuAwELlCoDLOBPuT6CQw?=
 =?us-ascii?Q?CUfDkuWNmxLUxx5JCpFqmySGOejCV6r4d87Qu/WncWa3wTWnCQ4NQr5roqB2?=
 =?us-ascii?Q?hsvbtvLylzb8J6yfPTuejmye6OfHej2OhVd0YnWak7uH3V4mTnA3bpyMH7P9?=
 =?us-ascii?Q?6DD2LLqWm1ISefAwIzUCytn9o/Iqj1NpWhfw/F634vS0tUQS0uCvGRx9ptTl?=
 =?us-ascii?Q?L7RDkX8Hl7wqU2FDB5ehAtnGF4sCDXIq0Ul5YjfY15XWYmHwrE/kNu6YhXnt?=
 =?us-ascii?Q?CkRY9yqzm21HmvIFjS24lGTQWB0yNN7k5/+3pX3lYDaSlOtvj7RVgtPS3YWs?=
 =?us-ascii?Q?XwP94JpIRZvEv6LgNPCUJE5c5fPH4ZU2e3epOu8dVTnxKODSgDn/t+n9Ce2y?=
 =?us-ascii?Q?cdRgDyR8+v0cihNyum52kvZWVpxW7klm6UCP4wshWmugkimeobNbTFnaKvJY?=
 =?us-ascii?Q?PBXwRolxntBP9VqUBOLv4nKuBaOxBn/C1rHqefjGu3SKGkfFfIjwcsIpuhfy?=
 =?us-ascii?Q?5y0fyhQRy02PjgLZZ1NBu4uAvaCclMPNlLFQ5VenN5++wV/JMprClLNhNntk?=
 =?us-ascii?Q?OFfVqG0Y6yQb987dykA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5333.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14dca2d-6380-41b6-0ff9-08db97c74b02
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2023 04:24:01.5373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hF7xE9sRUX3eNvBh5ND60hmdlLNSou7uezb9rgPaxKxjuU9G1xhRnn4yfhmxPSlq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Li Zetao <lizetao1@huawei.com>
> Sent: Tuesday, August 8, 2023 7:40 AM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>; Agarwal, Nikhil
> <nikhil.agarwal@amd.com>; alex.williamson@redhat.com
> Cc: lizetao1@huawei.com; kvm@vger.kernel.org
> Subject: [PATCH -next] vfio/cdx: Remove redundant initialization owner in
> vfio_cdx_driver
>=20
> The cdx_driver_register() will set "THIS_MODULE" to driver.owner when
> register a cdx_driver driver, so it is redundant initialization to set dr=
iver.owner
> in the statement. Remove it for clean code.
>=20
> Signed-off-by: Li Zetao <lizetao1@huawei.com>

Acked-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
