Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1915785A3F
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbjHWOS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjHWOS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:18:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C0AE47;
        Wed, 23 Aug 2023 07:18:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gC1hiTfRbd/HTrrZphHTHcNGGIAevVb+H8JaljBwmxVz8gfnXSbn3XMMkHIlphrvgQb365w3cWRmH6ItuZP8hKU+DI/QI3t92U+aQ40oXSaLBD+TLbklZTcxo9mq90aHVQRq1cva2B13Hqsx470TlLrrMlFUAQQBK40TLohAnZvIlIeXlVULuG8mfSCehDjF3YhdzivOPsAAkNcBmMjCXNxGMXCluMYBOrI4Np78YMA8TMV3hjTt8ih7af/lONCZHTm5mrWf/HDYEiskC9+hS7fJ9eE3GFGGFIpw5FDTbAcjXDTmQPzvpvlYoLJjmMR5DH51J98r5TLCbj6zkOGgmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q1+PY6JGQHzTp+gVq1YSU/RQi0saf+qy1vLZ1+JBQw=;
 b=Gc/5aWzvtyN20Yg3Tdef7PZBhUm8g11RKBFQJF7whq8QOiaureXt6Ums0LDHwDkrEk7cjyQr1npPnt8KwFMcgheSH1XaCZR8rfEl0zgaOzwt3qAI64qWGOyfVkPxDII78Jcp7c0Egs5jxHlOnPXiMhorzbuUvQfLcXSnlyReACOOFJ9Jb2hI8bihcbCsjEhx4986BSadOc5pEaJ7g4nCsQ90AhWlfOLPaP8FrFlxFyjHxSIsECBbkBFZk2Hpmhf5Z8khriAfVg14y/31BGGiCmN2+BCAENHJ/CuspQ4QoUR+hH9lJKO0LrxkHH6TrgG+7SaKoyUArBOH/uENaYpyqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Q1+PY6JGQHzTp+gVq1YSU/RQi0saf+qy1vLZ1+JBQw=;
 b=EQL5Le5qNxnHhJIWdAgeJyzwx+xTiAOmQc79g56ABx5C1feLbUlKZWWy+ROLFAJTcpNPoBkKkc4hnr42T35W147VnZMKXC7VC+QmEfTfF7KosLRmdX8yRF7q9tQd6f9hzsMCj562dv+RM69UjRYfVHijFev+2XmPQuwkYRV1Hn8RyHRfwlOzmG3KFvVvyaF692CfoQ6X7Fg0tJ6/Oi/885wP7NYRecbbpnnNerz+sL66/i7OMPpUlaUw0zCx3DnP1Fava42aFteqdqllGlOn4/HrY523XJvBB2eXg0LQ6bxs+LF+80kz3Lor9mg5Jw45SWpLNmlF2J2X6IJCFfRs9A==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.26; Wed, 23 Aug
 2023 14:18:53 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060%2]) with mapi id 15.20.6699.026; Wed, 23 Aug 2023
 14:18:52 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ1TZ6Nms5b5NPG0K9tyfNGGuGJa/36LOAgAAEwjA=
Date:   Wed, 23 Aug 2023 14:18:52 +0000
Message-ID: <BY5PR12MB37635FB280AECC6A4CF59431B01CA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
 <ZOYP92q1mDQgwnc9@nvidia.com>
In-Reply-To: <ZOYP92q1mDQgwnc9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|BY5PR12MB4082:EE_
x-ms-office365-filtering-correlation-id: 823333ad-7501-4b9e-3633-08dba3e3e0a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jBBPmXiotw2DEtzPgolWaR5kLci0xfMFMJKmxCCIRp5fKxx4Nke1GWiN8SnrYyegSezHL9sBnR07Fq+mRnxGQq+/YRHnKtaPIcOqeQ1HCmnr37oQPPd7hm86AN3l8mmUUUxlF5pCvZB5lMKDEq3IcESqAkNmKTxllzEFx8OYTT4JsZTc/ZJcgUuNR1J/kS2rb3NJehkacfQCBSQiwjdz/+RaQpXyr/ubVLolv9qsJYYatCaYgEygrcs7PFOI8UfkFKEn3aMy7xx7nIBHt23bJCs7EF8g7vONNp1iMR0KEqWlXd0YQCTd1Ks7k5Z/KJzmr8dRrvegywkq6udma6tyuEb5tiC954m6nBCmliJuKN8HfKLR7XdntsbU1L1FXoZXfc9ZFkmwf14/NOpZSCpM3XivcREVwxPNOprjc1QVhN8IH+RrIwgr6AjceF8iV3MqRFEatrJ5c+84MAuJXYwBcPCv7K5JoRYOHPTUISzAmjTotYlKSn5eift7MPbqKlxzQbSWa3vvtfEMmDxK+llJcJmwIjxReXea9fsJlv689A+tAATXuwiHlHpcqn0NofCBggBU4p7/bg1RG/GTHobRgPegjAUIS/gTMhwFV2i0F1w1fU010PsLGUrLYuARhcka
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(136003)(346002)(39860400002)(1800799009)(186009)(451199024)(86362001)(33656002)(55016003)(52536014)(5660300002)(26005)(6862004)(4326008)(8936002)(8676002)(2906002)(83380400001)(4744005)(478600001)(6506007)(71200400001)(7696005)(66946007)(76116006)(6636002)(66476007)(54906003)(316002)(64756008)(66446008)(41300700001)(9686003)(66556008)(91956017)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7kWYluxpJutSCeiZQOMnxt+CeFM0D9u260DylVwQA5IBkSuFegnIyWGmXc?=
 =?iso-8859-1?Q?ZSA6jwEHx1lau4+KXttdJLLfF1+P54ZPdJPLfJSGtlKRE7S6UN07inS0us?=
 =?iso-8859-1?Q?rTCKYq+aSn0MByxTkyEwrSIF0MzvvBLOU27fWVa4U3PNcNiLsouzGQuLeR?=
 =?iso-8859-1?Q?J7br6Z4KJBX8q8qIMv+GZKSVn9k57oVfnunlOakcq33viXiPC5c7TQbVBP?=
 =?iso-8859-1?Q?CPB0rEOm0SbnCUDP8fRkBPfOnJlCac36SfwjUlpn5jZZlYz6flc+DQGl5N?=
 =?iso-8859-1?Q?9jCPKWEEBCpqskYbJPM6VMkg0i/KQe0T6YZFfEXMPQP9/NL7YRHDhl8jG/?=
 =?iso-8859-1?Q?Q5M8OI5fbfxYtuFum+i6tTxrkEza5NKS6hkNiz1Tpzis5nELh/7GKC47qo?=
 =?iso-8859-1?Q?mLcnYxLxfjek9vfjwKQUVqfewtyAy/oMOSFF/qDHigSxG99PAspuQ2LpWD?=
 =?iso-8859-1?Q?TybxscnJl95iHy/y/MSHdxuGWtDa7bx72EDWPV9r52nJbiwtCTI5BQyULD?=
 =?iso-8859-1?Q?erwPJ5CK2hBVAI4FlM5y5MyDB68Qv5vSRVGU1y2g3D4Fq0zKZwFOawjQgW?=
 =?iso-8859-1?Q?NXziCmFPq8urigheXidYnTLp1KMcQ0FxIMijGDvC/0++nlO5PcIidPRUsB?=
 =?iso-8859-1?Q?z0GpjTroRIBA5eJZ1Wg0nHOneNOtEtrRZCXmXfDsgw+D6AjMFgFC3WB2pN?=
 =?iso-8859-1?Q?R5N9yX2QQydUbVcl8SamMbBvsKchRf7teOg3vcOGIXNE90L+I6Mw1IAhag?=
 =?iso-8859-1?Q?MKhw3TGGAXxRDGsIF0dXONpCaIIkgPN987uKDBXJLUU1cNSmih4N4QXBZ6?=
 =?iso-8859-1?Q?RJsWJMNbFF8oKgacEPtsFtvSM38n4bAjRwUFD3iM6UPPg4hfk9yb6Zwz3v?=
 =?iso-8859-1?Q?GMYO+26tCn0NaCwZWYYWUjudt8EDONBbTs0/g821rR+YhfQkhzK2F34d+Y?=
 =?iso-8859-1?Q?Url1YFM9Gr9u2tYSmYVBbze6fdYAQLSonM+jlrPfv5PiXF2KALjmI2ZvnC?=
 =?iso-8859-1?Q?0e/56e08Qk8a4CjOPnhrlw20mPcVbANa5MGD5KUL57vuWMHexuVlfCjyID?=
 =?iso-8859-1?Q?1DH3OWSSsLCfKUx39/vbuuNOMfst15upF14C/mQS+ary4einqdcQ1DMbs1?=
 =?iso-8859-1?Q?EHqoVVvPboMRP9zj7Rvfrh0tUESmj3OrANPjyx26bxwEfFQtbzhRI7u8ok?=
 =?iso-8859-1?Q?Prr/sZyD7RPL2wquHtHA86dHZYIdpjDTThSK1IB2EiMZusWShSnEO6BR+Y?=
 =?iso-8859-1?Q?ccu7ra6pCyDFpuXEw/URixGy5zuZLI5Gtl7UTUyTSAE7JImG6C3fNPsgUl?=
 =?iso-8859-1?Q?STgUni9wvAeO0V7mCNLYc87lTx3pIH8bGomVYDy9DBrzAv+cAymulReuiZ?=
 =?iso-8859-1?Q?KpiDTeYYKDZ1mMkQAjmhEvfVRSJvFTelnTskJ0XMI0eivQnfVIBW195BeH?=
 =?iso-8859-1?Q?areXLt++axB0NNHsNgTSMlhqLV5lOCeQHvYDFEALlI0VFD1f4FTjx/tFNl?=
 =?iso-8859-1?Q?kx8xA9m2EFGN+/WHMmi9dy6rgeul87W1pJKcUcscNN2qKpPMw7miS7E8Lx?=
 =?iso-8859-1?Q?kThi9YzB1Wk7kOj1Inuy1AYP4tzHNn8UuoYbMS+9UCNtdIHbel8yRfSxpG?=
 =?iso-8859-1?Q?NGkgXl906hiNE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823333ad-7501-4b9e-3633-08dba3e3e0a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2023 14:18:52.4889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N1LvPMjrpwq3ASIq4L10bFFbdisrK/qKJGRUk7S9QGIMvs/Z1IQK1K+7Z2DjBMvbB5iBsI4O/rAUNO8zTN6i9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> +=0A=
>> +     /*=0A=
>> +      * Handle read on the BAR2 region. Map to the target device memory=
=0A=
>> +      * physical address and copy to the request read buffer.=0A=
>> +      */=0A=
>> +     if (copy_to_user(buf, (u8 *)addr + offset, read_count))=0A=
>> +             return -EFAULT;=0A=
>=0A=
> Just to verify, does this memory allow access of arbitrary alignment=0A=
> and size?=0A=
=0A=
Please correct me if I'm wrong, but based on following gdb dump data on=0A=
the corresponding MemoryRegion->ops, unaligned access isn't supported, and=
=0A=
a read of size upto 8 may be done. =0A=
=0A=
(gdb) p/x *(mr->ops)=0A=
$7 =3D {read =3D 0xaaab5e0b1c50, write =3D 0xaaab5e0b1a50, read_with_attrs =
=3D 0x0, write_with_attrs =3D 0x0,=0A=
  endianness =3D 0x2, valid =3D {min_access_size =3D 0x1, max_access_size =
=3D 0x8, unaligned =3D 0x0, accepts =3D 0x0},=0A=
  impl =3D {min_access_size =3D 0x1, max_access_size =3D 0x8, unaligned =3D=
 0x0}}=0A=
=0A=
Thanks=0A=
Ankit Agrawal=
