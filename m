Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0C567197
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGEOxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiGEOxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 10:53:31 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2081.outbound.protection.outlook.com [40.107.96.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D93ED86;
        Tue,  5 Jul 2022 07:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgwGeFMwGRAr7A5B5ZjaC2PUxY9yNrRxn1FewnQNyQ6jDr/CIJzq1e3C4f+jl9XeIWq8n/kIjRKEtFaLcCRbiMerP1e2g7e2aB0PD8roFn821YRyEs23e0V3OI+jfHuGfdHj8iEjDFQi6ioXBYgYWt+M9/YNhj8xMXWVJUuchhc8BN6oYuwFPh3UT95dOqTaby8oJvs8g5GZk5PUv+kZH091psmzUgTtZC7lmfSqdFmMHtcOAEcvaz9OaIeV8FZanetI6AGGJhPXA1Ftd0jqalldGS32WcxNkDIcdJIwqKuxhpVxQpVQ5YRlLCEpRF5xmCxigbBSTLYzW12yuABv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o15Y5xb3AjvcnYGS0xeRGrbapEtl0VB4pxnKXHnTloQ=;
 b=ano2iDIsoyyPj9FEiHfwL1czRCfstLHKFf/vzVjmEjeNsGrXx4uQBpvJacC+NZxtGEUPMMnkKQKB46GV0vThpXZ6ToQI2i/Xf0cIavxabbHIKxTxZH2zrX8Qu2TcXu+HcTMoFLjecY/42Db4oEhR1TJ3oep1Fvs/euG79svkRATBCAeK4PSzkeHu6IugEi5yVpfziz94SGrjuz2UPHVmttSODSVwzjkUzkfhaW9Y9yl/gj5psJrLnWJdqZRURHiYeE4rxb13vGrx3meeBDZrvxSjlI2zchJfzK2Q79Ho5j4yCS5H3ioTu6BqVG4kZGQEqDCC/quZDfSuhoy83jbhJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o15Y5xb3AjvcnYGS0xeRGrbapEtl0VB4pxnKXHnTloQ=;
 b=NCbfa0nKeHdiSLN7IsEEZ5xSK4Vc7xY1tLt37idCoNfzS0gcBR+uoWymvD1fMQpnwsYueKEbmqsBq0wF7tJSqSGW6B6bgagmbcE0YO5JbCs0Aoi82SRydkKae0qzLxoqTo3Ho2hzVo+9eh2mibanBBKKZVXSUjLV6mWYRnzkPgo=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB2812.namprd12.prod.outlook.com (2603:10b6:5:44::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 14:53:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 14:53:22 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Topic: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Thread-Index: AQHYjTdG/Jq12JdNiEyvNHxMVTEAQ61v0QXggAANAwCAAASgcA==
Date:   Tue, 5 Jul 2022 14:53:22 +0000
Message-ID: <SN6PR12MB2767F64593EE0DD11E578FAF8E819@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <Yr7Pm/E9WsAjirV0@zn.tnic>
 <SN6PR12MB27673AC95A577D5468A949598E819@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YsRLyoylnTHkgfa1@zn.tnic>
In-Reply-To: <YsRLyoylnTHkgfa1@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-05T14:50:19Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=3e510786-e978-47ef-b660-fcbbf49efe1c;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-05T14:53:19Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 8095f5be-af6d-4f4f-9485-75b20e698e53
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdd19d6a-e6d9-42b5-5534-08da5e961b6d
x-ms-traffictypediagnostic: DM6PR12MB2812:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ur4OsPjv8pSB49RI4/aDJiSuU7c/0zyZdqvjwW1nwlymUIF5GmablwteX6RYndpZyYdIVmXxJ6pXoLGcj6kFlutYvbtD3fg/QSJ9WLSEUbxmzWZBPxim+T8Eat8g5MR01sIlxk3uKkSKbySEYlk0h2bBAktWKvmaIGXBlonwFLgnczBvuIeYkNgCUT2YB/fWfCJRVlAQQ10ej0mvyezZs5ov6rbVTkvFTxZBJ0v5pMN3jvToAi2AwMtIUL1UWDDBRXO9tPM7EhUsifS814oHKI5sxVOqeSQO/VrkFyG+vOrkreiLSE+ZOKwlPprJ8HrA9PBBHKcV2bsiAxM1MG/v16wLWHuMZBwaEePjnfYIZHWBLPmuUc5mcK9n47jqxG2wgQmqNMjTlOAE//twMJBZvPn6sz8/hkedan7Q8ukSlW8FGaocou59BQ4fXPZmjRt42vrI7iMLSKjfeHMkkgVlqsAGomH+9tdWWIH+NbBNwYI565bJN+eOOIv4JVpzyudTT1Oq0zIKolOA1AJq19+DcHc4zRvJb5Pe0ETHz5jljeFxI7HItsfihkUeo7HY/s0jpzNZXFTWdWMJ+DURG2S/7DhxrfRKJTjICRRb5/nolffhYo1JU6NoNSi0MDYuaWmSAGehlVhGjSEoWi8k+hosNUQMhsuy7qT93jNg6+Fp1n6z4/UFI4fctOdjZMArSt03MSeWgkfkvh3eyrFNOl1TOW5W3cXjcFKP6Bh1mUw9JAwFqkV0VhojKEDqjIrZbowSroOaJQncghiC9EqVfUm2HiHA5anclLAwPF3+NLjEdiLXDvibvk0t9Hmpp2WciFmU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(38070700005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(71200400001)(41300700001)(86362001)(6506007)(2906002)(7696005)(478600001)(7416002)(7406005)(52536014)(55016003)(33656002)(5660300002)(8936002)(122000001)(26005)(9686003)(4744005)(186003)(316002)(38100700002)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OXe0KzhI2oPNcy+Hmd2qjdNNDjEcXyKg2BoBlHumQCaD0oGIQiRx7Nfak2Ts?=
 =?us-ascii?Q?ocbK1I4lDrtpSf+cOQwG0P0sIvZJVt/cEBd9zh67xju59IWmQx6qEqZYHZrq?=
 =?us-ascii?Q?6XyaBOD89Arg+2biAR1b4l+SP16cx6cbIy/YtmIY9ueGTJoPfj3uYCR0tATt?=
 =?us-ascii?Q?3bGtL2euCvlzP/m5q1jIQVL1c7SXcyuZ8wpdTcFzkexoEXDih2Rufa2TB0qv?=
 =?us-ascii?Q?A/liM/Hj8ayfZjaTFtU4WTBPvGSBs9LSzXEtuEH5LyZfJnRVZ8+pGJWB/L3a?=
 =?us-ascii?Q?q2hjvWO7CVSncQ1jw47NKkiPvDO3FEj38tEHkTovdvB5b6hu3DmTmwx7k3KG?=
 =?us-ascii?Q?8NvH8BGuw7haiVnQl5cW+ol1Y5qlDXnCYCxBwTa8LaP/pbPpPFkKEzDSjpxQ?=
 =?us-ascii?Q?ReVpQGocoev/rDHJIVP9ZVJEu/lL0UHXJZ7uYjHaUC6swmOp7BshHgGbqOHY?=
 =?us-ascii?Q?sF24S1/vSsYr4UFmWAg7VuGlVgpOKfElxfKZcQ988rgrGWFjhI34qq2Oq79D?=
 =?us-ascii?Q?ZPTiHisEP+RTjm6pBl6RBaODDy8tqBs5k3aRqqlLY9ayFnmno0TQxBfXOkWX?=
 =?us-ascii?Q?q1hZMkD1FphRqMvvEtgz86HyU/VkxltDi3ikL5e68AFewmWjAxeMZlmh4Hvu?=
 =?us-ascii?Q?2OWLnA3Rx588Uz1OyAAj4qX2Kngr+5yvbIjaAjsx5CRupc4SxMltY26tlHmZ?=
 =?us-ascii?Q?kxQNFlGSEz3t6VwPi5mmSghYGA1wrWJXb5goyi/NcEtERSjOXcvGXBJWVr/z?=
 =?us-ascii?Q?QPLd6j0YLDGUw2Kxve1Br89l8QqS/af8WRnI2E1pExtFHFJn0DVXdO+LBGbv?=
 =?us-ascii?Q?Bsc3GvquzdMB+Eyhmffa/dYUQRmuS9ZUcPcxX/I9Yjj4Ef4oSX4XompMQtQ7?=
 =?us-ascii?Q?yRVCGjjEVWlt1ad/gt1rtkLEiO71Jy74q5Jr2nxAtnWK4IGlLjHidU8Vji2y?=
 =?us-ascii?Q?3V3sfgKQF0xUiUc7l7e3+nvMRP/zHS9noUx5m4jc80uvROJu84tqeQPK6d5c?=
 =?us-ascii?Q?PR2SbRJ/hLHYW0R3cFsH1+NcoN8hMae4X+0Y7nP14m/+Msln9RVnwzGSeAgL?=
 =?us-ascii?Q?qnxwGiprhxuCt04dH5rySR0yt9ga7WApR3SJXRyhscwSBTUcXGr2sQ0exgTs?=
 =?us-ascii?Q?d+hB/OSvqfHcAxUnFEflxOU2j0lAc32Zv2MIomA33x0v8GEeIjSPAlR3O+3f?=
 =?us-ascii?Q?VaqlZf0aKeoY8yifqTn4BKeAw5tinOcoWveLfhFvohrJrgFFl5L+xudiG9jF?=
 =?us-ascii?Q?PAbjZOKce4MimKu6jXnPJvM778meAhxhGvNe6jILrpu8asVLJdDyuPpuKwgg?=
 =?us-ascii?Q?EjFDUR1VbHTpSGzK6d9/0ojht0F7yIawOJGLFHEOe67BtfAOd4PPf7bSAUFx?=
 =?us-ascii?Q?oe6RCO0Z3do8va/h5Ls50dwdfofcFll8rXokToYf9HmsuviiraNn9ysQlZ0+?=
 =?us-ascii?Q?expuqdVqGPvPJRHHRVEVI1bH4wIK5dBw7RwYgcG4itUsYsvYbK1V02Pbe9Pk?=
 =?us-ascii?Q?9YnuWHh2GyGMP9HAOZJR5YrQpsdGrS2iR7W6msoKiKrCJAmW6jSA2bj61Ugs?=
 =?us-ascii?Q?j73Y8rhSVauy/s9Ea1M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd19d6a-e6d9-42b5-5534-08da5e961b6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 14:53:22.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVkso0Xxewlm1vOZKcjZ9j2+471RUxy/kyfaGwAeZmpW8EH/1jftEpQX3vFIuLfhpqMMgvdSWDAeGnODj/YTNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2812
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Boris,

>> This function is required to ensure that IOMMU supports the SEV-SNP=20
>> feature before enabling the SNP feature and calling SNP_INIT.
>> This IOMMU support check is done in the AMD IOMMU driver with the
>> iommu_sev_snp_supported() function so it is exported by the IOMMU=20
>> driver and called by sev module

>What sev module?

I meant the kvm-amd module.=20

>The call to iommu_sev_snp_supported() is done by snp_rmptable_init() which=
 is in arch/x86/kernel/sev.c. AFAICT.

>And that is not a module. But function exports are done for modules.

>So that export looks superfluous.

Yes realized this is called in arch/x86/kernel/sev.c, so yes the export is =
not needed and will remove it.

Thanks,
Ashish
