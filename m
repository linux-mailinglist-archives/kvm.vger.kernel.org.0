Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5B2600C08
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 12:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiJQKJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 06:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiJQKIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 06:08:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9448B444A4;
        Mon, 17 Oct 2022 03:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMEbwIkzDs3hkftUTLTmKr//A7q835Orugm95JOTM16lj6TYnZitDH7pQTlogNMa/pjbvNMIszXQcmX7NlRJx/QYODQXIYxZNm/w8hvPJDmDDdJKVHHeTMsN0WMkRhMR6TV150PCSjBjVlij626wT0v1xzXDbeydiEevXhiEVhg5kAyJxtjUQEcUy39u3zmcpTCvsE1q6S6cp6XCG4f1fTBggKX3DnvZWtMUjiPvMcbaT46rY3TJ85HhFOn7CDMtB/2E2OmMe/P5YoTDnPyo/HpKyk/YvojiDL43ossUFDjVCZXeDF2g4pMtP/iQIvogh6uH+tAhf6QPRCm/LZjMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GM6U17y2OFYZ3M44j/9SkA0eae7MVBseDq72DdRR+vY=;
 b=MztzWob0x7GeaF42MKIhkAPdnOhU8EGaFFbQbFk3d2tHgTHYaQZAwQPsvFO+wEC13TTiMfoT3AD+q7kLu9U1DnOKt7Ii4dWb1zXrqshO96ub3HJ+bhYa13Yq50TB1L9eVZmweaqh3B7aJKSVbNE4M0QmpL+2v63WLKfIbMS0C6FdObZzOQ9UjPofsT4KROWNjHLobQJ0iuF0BcBNVoSSYgu8hltd5z2+eUZSPCLZ+HDtn78rfQQABmZ6pismqQNmt6KZgngy3o8Opc/wlAV0mWbSlzPiOBmw5E6dph1zBmkN2DMCqZ3CPJoi/yO+kDrIevnxi2EgpscCirJ/t2I0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM6U17y2OFYZ3M44j/9SkA0eae7MVBseDq72DdRR+vY=;
 b=ZdyorfCIsRrOJCxiIA07u8K/rmbMDh75rZNXYFKknWH19J2zrZcUet2pQcYdOkDVMyXnc0Nh59osUWF0XEX9wM/V4Pg49ugQ+dBMQ5234MAt3/fyMX0ivi+HlKnqUk/I5JFOwiGnFcREoEkz5HOodylAyipD0xbeLdmKPVlG+o4=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by CY8PR12MB7660.namprd12.prod.outlook.com (2603:10b6:930:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 17 Oct
 2022 10:08:37 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::377f:69eb:dcb:3ea8%6]) with mapi id 15.20.5723.026; Mon, 17 Oct 2022
 10:08:37 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Rob Herring <robh@kernel.org>
CC:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v4 0/8] add support for CDX bus
Thread-Topic: [RFC PATCH v4 0/8] add support for CDX bus
Thread-Index: AQHY34c74HOa7on0qkCTYkXoz4N/wK4N7kKAgARzQmA=
Date:   Mon, 17 Oct 2022 10:08:37 +0000
Message-ID: <DM6PR12MB30828A6C817B17FF576FBCA8E8299@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014141005.GA1862711-robh@kernel.org>
In-Reply-To: <20221014141005.GA1862711-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-17T10:08:34Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=763a7ca8-a825-4855-a2ed-63dbe18b7623;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|CY8PR12MB7660:EE_
x-ms-office365-filtering-correlation-id: 83ea7dab-c744-4e82-8b62-08dab0278edb
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HNCKa2w+9uNEFN8DWQN+ZUjDYehaoFFDkP5ojJcKlAaO89fIwQaswTxAiU2TNuIN4dI0nhRLyV9LXtyzEiDG3BKz5ez/G8YupE21t9y1emdl3RMYpa4KTr7p6DRfBn1wu8meXSl6FFmd4Lmuw/3lrx6TR5e5Do25IREjX2lSe4ekzrTmPrzjycU7voQcmnr6xbbO+0+RIKD+853nKlmfLEbfV+N7E3SsTtk8ce7v2M4e76DWtAomXpOJog6eRy0KOxBKb99k/CE8QnLakh4ytPs+y+bu9195CVPkHlXf700LpeAAREVU09pPx5qayBWjihS2huMsYF6XJRLmty+UJxscRqcjaJCYRpurHU79ZJ2dGrbZ31BbCHKxJCr2SKTf8GsaYvji8rj3qQJ75Aiwh5HpVxYNZP7CcYdDgjVQCM0BUGG5a1YYTMX0CfUO3wRVLWBtJkymVoaRMXMsk6QX/rdh68FdIqC2tLqST/hgraiHm9kyt8P87t5XUDNBgPGDA3cnT87/jG8MDZ2YwhSLyAqLDacB/nM774LiLX9znUtbZZmzpn2/XaOjQR3ODtO550yFui6MAaSrsZCXl6TVqhECrbgubTA/W89grX7yTZLG9rQgUNVCOT8GrJb4QM2eNfRPnLKp91+6TuWFnKlBcZqW663gdPGtZqPQXlQb+rgoR0HLgcz333HXeHX6iyIhKDOFMZMgYd8C2QTQlRxctoC7QLL5xButjag/Nj9wUp6CpaUpyJUXeHz1MC5lwx3y4HLdBx7S7rtsLsh1JchBWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199015)(54906003)(5660300002)(7416002)(7406005)(66946007)(76116006)(66556008)(6916009)(316002)(64756008)(478600001)(7696005)(6506007)(53546011)(41300700001)(4326008)(52536014)(8676002)(9686003)(26005)(66446008)(2906002)(71200400001)(186003)(8936002)(66476007)(83380400001)(38070700005)(38100700002)(55016003)(86362001)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?li9fH6qrjbE9zFc5iAFEnQ4w0HYjEmdnUI+L/uwaGote5oejAwb/Svrf17Lo?=
 =?us-ascii?Q?cyYB+eE2bZvAhY4whbfdaJZg0P2qSc3q/wyllF6zPEJ9Tj4NQxSGVfJ4lIeo?=
 =?us-ascii?Q?E+nE6Ldd7OBbG3r6U22Xd0FjwZ/3HkZFSyrH6EasGiEXJ8PsWxxDMtj/DjkS?=
 =?us-ascii?Q?Tsq4XmVVZjrhfWteJKvnjhlGXQfOVQYXVu0SlBj4OWQJyEZhvvANCpnXyaLc?=
 =?us-ascii?Q?ABKqvHWfHkSDSL0MMsk7d2pESSz1A+JXphL3kJgs2sGhCCuRNFXT34FBJD8x?=
 =?us-ascii?Q?bXeNx9qWrAVnFYRj0RN3uidoNEz4s5uHbCu5fA3r3O30czs+t9HDVaO8sRlE?=
 =?us-ascii?Q?lVhaUJlzRjGC+Y6+XHvTV/WSG3nCpr+ZM/njI6p35SR2wqx5uaNOgfDTpUVq?=
 =?us-ascii?Q?qOZ+IQL1hqSuVBmTTrpn2ze2kOKQ8+7qSBT3QeRTExAdvu5kzTrDEpWa1mjY?=
 =?us-ascii?Q?gNieOBgbPHaTWkPWY5jXlWvXNK0XczchuHyHHDxMwUaRbEOKL1G4XadFBcDC?=
 =?us-ascii?Q?008HXDILEz0GH8SAiqGasNfbw1t9pMb3GUAI6yZn7AMxLfzu2Q+BxbYhI3BN?=
 =?us-ascii?Q?+Wv8bX8kPXCPUFKWdJuOnQGk3C5xXuR8sk+CxTtvAcEyGqjKwhD73PuUzgVv?=
 =?us-ascii?Q?JnuP8AGoiKvTRjA6zmHZExQkl2jDp+m5FFPycdUaLDHC954bZVEz94NTOcbY?=
 =?us-ascii?Q?AyPWgbRNI+N8yS9EBHZUdtyunKwJmb/A8avPHCywdPd9i/S8Aq00e1VkSshl?=
 =?us-ascii?Q?GCJtuTqrlvAXwmnCMJRGRnjjxEC4SRapCin9wdCUnZ94FUz94WyaU59XW4/O?=
 =?us-ascii?Q?crBV65zWQwS1jFUSfQ+ncjMlsvBpLUPgBWfWmGz89eIEfps7LyJg0eoThyPI?=
 =?us-ascii?Q?ohP98MZilGOH3BvL5CuGVSO+ju4vNm76W+po4vH9XNOmBJke20i/5kkfAzrk?=
 =?us-ascii?Q?WHYTs/OLgnzOA58Vfyntrcs/H3DOfJ1AI5O9LtZ27QuatsLetqigA501HcMg?=
 =?us-ascii?Q?N3xuOwjSeUgs2ySmg7J62xBkffsW34EwPH4ZFwHHTwTD8i/CJRcJqKfjq0vn?=
 =?us-ascii?Q?Zc/jsq0sEV8r2orqvIvZvVeu8UME7eTJ3jLyVjaRSJIxFWPfEzUe/9cDY1Yt?=
 =?us-ascii?Q?QLuwxUMPYrI/LtojDOt5NjEdSsGw39fDUenvveWSso/aYmwgntCoWh8DpU31?=
 =?us-ascii?Q?ohvlPUFE+Rk6NagSml+wfXFd5C8Ip1svbVfM1WB5a6CGzZ3V8y2ijNT4b+/Y?=
 =?us-ascii?Q?mtRziNj67v2JMmP4Nz/xpXGQIS0uDHeK0ZjnKY0JpvkiMr8DNquHBJKAfL7T?=
 =?us-ascii?Q?RHTfvPkV9VytQ16lBmAFFEc7OBX5jWRIhrQxpRlSRQp0O9gkrvFnzTpQKjIX?=
 =?us-ascii?Q?boSRmkXXcfBrRgIpKSEkiS4CItT3Yc5dIn2XO78EmoOvrfAa8evFNADG1Mcv?=
 =?us-ascii?Q?isTwZR/OWIajkbXs/LHtf4Nb0p6DwD9zIs7ufllRyE6TBZSf+I5VZAdMRYSm?=
 =?us-ascii?Q?X+BYi0IqAmldhRb2z8yj2r0Qc4b36Hs9LF5oPgX0HnacqPhIGdoQ8TWtsRfq?=
 =?us-ascii?Q?mDs48JNJCiHOGWP7lqg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ea7dab-c744-4e82-8b62-08dab0278edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 10:08:37.2843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jw1imZSFI7IZUN9eYXdZokKuDrz7ndi5roWE6tJkU3wrr3sYTUr1PmZlLxwdeTiw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7660
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]



> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Friday, October 14, 2022 7:40 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> Cc: krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG) <puneet.gupta@amd.com>;
> song.bao.hua@hisilicon.com; mchehab+huawei@kernel.org; maz@kernel.org;
> f.fainelli@gmail.com; jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com; will@kernel.org;
> joro@8bytes.org; masahiroy@kernel.org; ndesaulniers@google.com; linux-arm=
-
> kernel@lists.infradead.org; linux-kbuild@vger.kernel.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; kvm@vger.kernel.org;
> okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>; Agarwal,
> Nikhil <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx=
)
> <git@amd.com>
> Subject: Re: [RFC PATCH v4 0/8] add support for CDX bus
>=20
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>=20
>=20
> On Fri, Oct 14, 2022 at 10:10:41AM +0530, Nipun Gupta wrote:
> > This patch series introduces AMD CDX bus, which provides a
> > mechanism to discover/rescan FPGA devices on run-time. These
> > devices are memory mapped on system bus for embedded CPUs, and
> > added as CDX devices in Linux framework.
>=20
> Please don't send a new version of a series as a reply to older
> versions. Just provide a lore link to older versions.

Okay. Will provide lore link instead of in-reply from next version.

Thanks,
Nipun

>=20
> Rob
