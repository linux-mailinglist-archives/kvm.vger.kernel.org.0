Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D514699BB4
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjBPR66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBPR64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:58:56 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020025.outbound.protection.outlook.com [52.101.56.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0F137737;
        Thu, 16 Feb 2023 09:58:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3/hk3XzwwZX/rScqpBbxBEYzdnr5kBzsIeYWCUy8wHTi4xUHC6TaV9tbYbCzlS/S9+QPocmXsBVZHqjoL2iSGpOJbTxdex/f6jwJbUJx7uN5rCPyuaqPZVs7vVcKrC+qJbshJCz8ra1FlGwBilInGppRMZHdba7dtunVr37BEJhNTnieeuNwsPCmfvgRCbv7MxDC6bthrvTaU8MGT40JKq9SJiPn/ZBVDRXCBT0s7WJhopNXO5xbbB8ToqoMbQDz9XprE78E+CGqwSKnmsi+e7fz9SXFVkAbo+qrxp36WC4CeI5ChpK7b3AC8P85vmdGrbpPDLX3FKjnNOQynI18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDnZ5l3P6wXoPC6SmlLhxgrt79Qw1ypNWkpGJei8ID0=;
 b=kyp2ZJBQfr6Q3xYRBiaYq6u8fr/O5QGE1xWQvz+zKqb1nDnk5pZ0DuXp20e1YVQANcYSKRgOKAsV1cJKcXXHuE5LELee8FSXHby4OaGx7n0jERujUCiSsJjZUfMe+Y6dMcxoHuM4DKtGEHyEOjQFOp9jo0e4DzNYcZp4bDzzXVucfzVfLxcsI46lMM5G8Dg1BzLplaanZWkPlZ+JxE2+btI1854lbp1ZrKhMG1jFJBNdDf0TIoUg/FbdsdL3dhihm1071WXEMz5riPV6F/JCKMpSiptXecm7ABlADuqDdTt+jk2qxFdoI8BmF7t8gt+Dav+en7+3wdWARsk17XMAMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDnZ5l3P6wXoPC6SmlLhxgrt79Qw1ypNWkpGJei8ID0=;
 b=UJz3qG7C2ocMznBXdse9W8/C+/+hwSg62hJOZIpnqoD4N0t6XrPkiyWhYRghU/OqpGr3YGDG4rFIgoVfTuqaXWZHZkk90+fqMohW2iPW3eEEhv3pqC6XbiyvAw8CI+oUNl98ZkLJpa6ggRDnxfv5LrB4jQzr59FvUsqIJzcrlWM=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by MN0PR21MB3169.namprd21.prod.outlook.com (2603:10b6:208:379::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Thu, 16 Feb
 2023 17:58:49 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::3747:daf4:7cc9:5ba2%3]) with mapi id 15.20.6134.006; Thu, 16 Feb 2023
 17:58:49 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "sandipan.das@amd.com" <sandipan.das@amd.com>,
        "Gupta, Pankaj" <pankaj.gupta@amd.com>,
        "ray.huang@amd.com" <ray.huang@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Topic: Does earlyprintk=ttyS0 work for an AMD SNP guest on KVM?
Thread-Index: AdlBv/2siHbGoHczQeyMVKtAUkBIZwAJxYmAABIBUjA=
Date:   Thu, 16 Feb 2023 17:58:49 +0000
Message-ID: <SA1PR21MB13358707043E2901958819AEBFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <SA1PR21MB13359DBABC5625368E369A42BFA09@SA1PR21MB1335.namprd21.prod.outlook.com>
 <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230216091431.GA10166@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f4dc50d8-f9c6-41a9-b1fe-a45b22c95b9b;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-16T17:50:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|MN0PR21MB3169:EE_
x-ms-office365-filtering-correlation-id: fd62c95c-50ca-47db-c69b-08db104774ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UlM7Plbqgwhm69Vo5YA2jnyQoQs3nxQmM/V4CphfzsmJrvRPxBkRHAkQGiGkOVYzM2inOSsgJV+lK6OF5tIuOWUyGxHOyaRQ3A6cCjEi3QbF5zl79JFd05Qi9tLFEcNmw5lPAmCbb1KF2x1nd0yojPFAdFrVGYFg9DrmujxCfd5g4PZesCfpy4G3bigUCx50w89LWbo0Vwe9OiHj2pMCB90xAbcA0fF588+C+RwS3EVSiNx6avqoIZS5svsgVnfwjeQXhN6X4aYL/Cr73XLLq0TQ/8Mne/YOY57t5nWIyhjcJBjTL+4H6gl8ZcV2aNwx8Qj1YgxyZwlfkD8LqmcTWNtIMwjR7Dyea9cBhr9pAAzYu5njxgOfHcN0KswJ/GIp/nCrTZOjnM9pnO7rNCm3e4IVq2/6xsE4d/bOHPGUOrOd7Wkq0SVqyealh/StS8trOdKCELPcXqp2t/wy/DZ4JxatfzOSb2ObgIM62YcOkSFf0+VMc8uU8xuKkSI4jlbWMPFhl6VK+L+PJ7HDvD6AnG1VIpBMvVh1SnY3z3x+vKXjgxJUkp6P4ppoUYW212wo5LFeD+HDeky8PeflzNYoeu9emGtD1/9Jcg0HrDtE4MPlAuvYi9TSuRSpUMUL8J9VXgfmhlJZlHXPOGd6heOEMaw5bTttNAs/mYwhb8HUSY+a47UcIq7J+Lvr8Nxk4Op88C7HkKWbMUGwUGZTA9L9TP4bKR5hwVohniHKctiH9+1ZIcO7n0Rrl1et2f8UXmcp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(4326008)(64756008)(7416002)(316002)(41300700001)(66476007)(66556008)(66446008)(66946007)(76116006)(8936002)(6862004)(5660300002)(52536014)(122000001)(38100700002)(82950400001)(82960400001)(86362001)(33656002)(38070700005)(26005)(9686003)(71200400001)(54906003)(6506007)(10290500003)(478600001)(186003)(8990500004)(55016003)(8676002)(2906002)(7696005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d6/HaBuX71nyqzk8QbU2Klu4fKZb/30cTDIS1XsYW+sit8GwnwIJgmcFGMax?=
 =?us-ascii?Q?smSIuyPoFyCLvR7JgmhfvUHbhmYLnhkZDFwbua72GndXwfLtFmdQWrBVod22?=
 =?us-ascii?Q?WuqRUgs3eDo3I7V5VwmbQiiJux2N+5trHh4iFzBr7Z2FKb7e43X6fX3m8bEv?=
 =?us-ascii?Q?ga6VaVSzIIxHFuHpTHpIklU5FnZBpqEw+5aN0qS2JayipL09JSIPbeZ+ufGt?=
 =?us-ascii?Q?Pa+lMnZ5VyX9rn7h9HbPh0vKc32Cp3faiBSD/MOPVzC9ORlxdgzHupFKMZgh?=
 =?us-ascii?Q?NDSsQ7CbjAe6oTGo6XMLWxpNFZOIS8E1kQhj+Sk8JwVTbK/wk+Up9nEICDpZ?=
 =?us-ascii?Q?sJCHuwUnmsDIulgOEp+1A7q0gjboFp1iW4wXeeX3DOGk051wLSx5fv2AnU+T?=
 =?us-ascii?Q?ysWZOfsTfvCBW5Q0ORySisNTySp/+hApUmoZnmq1cZelZZcvrqXkIudwIdtp?=
 =?us-ascii?Q?5xWc5BnJ3xu7iXOkbS/hZiR1AqnkvzNoQIYLQpfriccXGfaFka5YTLZY0hRx?=
 =?us-ascii?Q?qFEQZjfEpQ7GHd7UMl9mFoNjbrt+ti5tiyIjYvurv7Dyuyfdf4nqBcehojSv?=
 =?us-ascii?Q?HRLVe3FcG5BfEBFyWMW9von6Z9DXrsHDuq+P24u5BTFg7QFEILEpmTxvuqxo?=
 =?us-ascii?Q?CBFFaaHVbvVeBucQm6KCobA03Y62oYw1/GTWW+NxPeAOUL+TqvIDzsZTWIwG?=
 =?us-ascii?Q?LzDYzrPnZViAS8Az0JcYXbMbEjxuL44OxO8EFCbtfwpChOWWr16nAkq+sLqI?=
 =?us-ascii?Q?ZWZ74QygkvLyIq++fZ/CKaV4VQ/G4vvitg2dQExKF+/ov9geo6xdGDwIS5Iw?=
 =?us-ascii?Q?bfSh+Qd24NtaQ9vVVXzjjhOE+FJ866LxRGB1GdXTfMbt63CSmCjHigyZiSCv?=
 =?us-ascii?Q?Qf6ff2YXEqHvXPyC+KHtLA+GMkOTDrczCSJYSe6w4fGHB6UzeVnHGDQBAfkt?=
 =?us-ascii?Q?ebLUlisNI0HzzlPFu4a6ifNks6Tm8R5mj1ou/R2PubemKMOXd9NQvkMvGTSS?=
 =?us-ascii?Q?bMHzwQ4B76RfDxQBzpu9sbX88oK1wDQrMHSvwjHjOL/fM2ZvVG2pQ/quKsQh?=
 =?us-ascii?Q?YqgzCOZR4ix4rTGvyAvNPv7D3KD5v49YPhonfnS+IkqCl/yCYXexYDmtI14W?=
 =?us-ascii?Q?oILpY/Ivz0FjgxBjYgmZPPeGMj8bXcPDRth4e5iWhMc1ZmBjkPcKFQdnq4QA?=
 =?us-ascii?Q?D8BuJp9ijlAZtBK0xrX8ip4yq7ncgIRgpFCzUSuifp45G17w7UcP76BsVsSz?=
 =?us-ascii?Q?YHuOmhdar1Z95/Cys1/qLrkF4+WVGhfmt+DjxAHdvqUKsG9BItvs7ATl0fYY?=
 =?us-ascii?Q?oLA614oCzornBS0WqexBJZOiRcckjtBL7IR5gDX7VlUvQs//PvZ6EbTxxVp+?=
 =?us-ascii?Q?7jfJWdgejOXOrpB6/Rre5sfdv6Z1RN0spg97kxsNY30snIT7aElpGsjUHMjJ?=
 =?us-ascii?Q?eHi54WWa8rJ6B3A3dTxFLPOa2QaQr3BQKM8d6iOdHoeJKyQDyk4gEdlo/ZWN?=
 =?us-ascii?Q?K3DNpKlDwquaJWisqgYjUXRsmlNXSbZpytpGmNpAw/uSMZYscGJ9riyfZRu7?=
 =?us-ascii?Q?4+YtJcy1X+SodP65h/XhqjYhZ1s1dwCQmySl3QWh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd62c95c-50ca-47db-c69b-08db104774ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 17:58:49.2956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDTKYkKH0p8eB406bUUCKn1e+MgWqInAHFeZT7ajDZ7pf5CsMmSGhtLcIhUkHP/Z7AoC7IWObokkc20U1Cr87g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3169
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> Sent: Thursday, February 16, 2023 1:15 AM
> > ...
> > alloc_pgt_page() fails to allocate memory because both
> > pages->pgt_buf_offset and pages->pgt_buf_size are zero.
> >
> >
> > pgt_data.pgt_buf_size is zero because of this line in
> > initialize_identity_maps()
> >      pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE - BOOT_INIT_PGT_SIZE;
> >
> > void initialize_identity_maps(void *rmode)
> > {
> > ...
> >         top_level_pgt =3D read_cr3_pa();
> >         if (p4d_offset((pgd_t *)top_level_pgt, 0) =3D=3D (p4d_t *)_pgta=
ble) {
> >                 pgt_data.pgt_buf =3D _pgtable + BOOT_INIT_PGT_SIZE;
> >                 pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE -
> > BOOT_INIT_PGT_SIZE;
> >                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
> >         } else {
> >                 pgt_data.pgt_buf =3D _pgtable;
> >                 pgt_data.pgt_buf_size =3D BOOT_PGT_SIZE;
> >                 memset(pgt_data.pgt_buf, 0, pgt_data.pgt_buf_size);
> >                 top_level_pgt =3D (unsigned
> > long)alloc_pgt_page(&pgt_data);
>=20
> I just tested an SNP guest on KVM with and without
> CONFIG_RANDOMIZE_BASE.
> In both cases we end up in the else() branch.
> With CONFIG_RANDOMIZE_BASE BOOT_PGT_SIZE=3D0x13000
> Without CONFIG_RANDOMMIZE_BASE BOOT_PGT_SIZE=3D0x6000.
>=20
> So in both cases pgt_data.pgt_buf_size !=3D 0.
>=20
> Getting into that first branch would require having 5-level paging suppor=
ted
> (CONFIG_X86_5LEVEL=3Dy) and enabled inside the guest, I don't have that o=
n
> any
> hardware I have access to.
>=20
> Jeremi

CONFIG_X86_5LEVEL is not set for my kernel.

The comment before the first branch says:
  On 4-level paging, p4d_offset(top_level_pgt, 0) is equal to 'top_level_pg=
t'.

IIUC this means 'top_level_pgt' is equal to '_pgtable'? i.e. without=20
CONFIG_RANDOMIZE_BASE, pgt_data.pgt_buf_size should be 0.

Not sure why it's not getting into the first branch for you.
