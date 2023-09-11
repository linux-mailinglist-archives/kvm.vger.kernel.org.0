Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5C979C03F
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjIKUrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbjIKJTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:19:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D2ECD3;
        Mon, 11 Sep 2023 02:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjULUbcdB1f5WVdtQqfmTqrCLkqe9ZjZx17mDjdcj8Xbm/7U1BGoF+WRWEPD0Hy9MEipSSim7nLSl/hpfxWWse7sEsgLYoaoVdt/UK7Vic5GmfcHqGKW5Hc23Le3t1MMrv5vkqHRo4IGiE30Ofxq13LchONr0+m4D55p5/C8ZZhpxgUExyQavN/0Xmzns7NAms1n35zDkWKFZ2Rf9IFyf0qOYla/ZYDbJ/DkuOOa+7My9eOo92K8hb6iarKTxwSG0PUFbAHbQDvMMIOC3oqRhLSxsURaa3/m5HMTsvad+PylNjUQpi6fRRcpSN4Dx3eypLBJmHG0pdqFI/c3l6Wtjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBryHqzH+NZNx0VM3cFWVB0q8UQ62c+zlr8T9OLVyZk=;
 b=k1++d1aQ/xxGQ9GN8WCeVnNZTC0O6pa8Jn8q4uE+1le765jGjC4YYNExoFNqB604gFJeGklJT5dfJGRLAjwLfkXt2qhgMx/JRX9gguSjolop9N+Pw1qMH3rqkpsM7Xft8ft1rwQL1tXsZqVHbmKAUH6wDEq0OD0sATQYQdLeDYoCo1hWcbiqZFh3fqhwd/OoNpSjt6vfGElJHDqfo+HpzPeN4WcSkFjDuBIkflUnA2lYsJAImJy7Zb0remIImcbNS3WpT+lXmWmbMQJtdTFcX/Cel0z786h0BK47QyNNqbxf0gdRS0gUJogoD+jBmlSkWNRYrZJl+n4OLuG7tlnapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBryHqzH+NZNx0VM3cFWVB0q8UQ62c+zlr8T9OLVyZk=;
 b=V5X4piyOP6mvK/wlnw+/j9LG38kz03UL8rf6P58F+Ke84FgUalnFjQTLdmTso9nOQvJv4+qcQcEP8waGp4M8lwtm+VCpvCCYIw7SLe8nOLW/wN1oDU1vgavKGeEFZnqLx4/wC3JxEweLKRc3ZXxJWGxhtNkoX1hsUQ33MgGT+TUI/REfxVX1m7VPVKwuDg13ULybwkkYmRqK9+oRoGS6sk1VWkM26lghVQBY49ldA2FejGAFqs8wGJPuFDpecYYlV61wxVhBrRVpihnaluDXvM6WXMiF2gjeKs021x5KsU2F1bklTi+bwKprRVyLfM8srXi1qqSXN9bRDGjezD+jHw==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 09:19:31 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::9e7a:4853:fa35:a060%2]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 09:19:30 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZ11GEd4uKBig/Bk6gFqMLb5fS47AP2/IAgABN7YCAADqIAIAAUAcAgAA5YoCABGIpgIAAEEZXgAAD0gCAAAnLIA==
Date:   Mon, 11 Sep 2023 09:19:30 +0000
Message-ID: <BY5PR12MB376342616237C2F216461FF8B0F2A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
 <20230907135546.70239f1b.alex.williamson@redhat.com>
 <ZPpsIU3vAcfFh2e6@nvidia.com>
 <20230907220410.31c6c2ab.alex.williamson@redhat.com>
 <ZPrgXAfJvlDLsWqb@infradead.org> <ZPsQf9pGrSnbFI8p@nvidia.com>
 <BN9PR11MB5276E36C876042AADD707AD08CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BY5PR12MB3763D6DA3374A84109D0B2E7B0F2A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <BN9PR11MB5276CC0D0E21F8A1C335A3828CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276CC0D0E21F8A1C335A3828CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|DS7PR12MB6095:EE_
x-ms-office365-filtering-correlation-id: 898bee01-6e21-4df8-ca67-08dbb2a83456
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CR/ziWJ4Ucm5sT8jdMSWCQJeTOVa3y5iWZJ2lkYkq23ikfmja6R6GAHQlnl5Jk+6bZNyWaBy6rdG77y4Nw5teu61mm/fmQXn/gp6mGliwI9k93DpN3WlKy8sjp3koaUBjKbbhPYccuNqbvAJyUGO42nQCAJDI+0Wu2rIT2aAXIIoIwN4CnQEpBbY3PQN7TOrM7mLO/hF5avAzSGpGEXH6Nb5gWZS/o/clCv9Wk9C8MNOqtT9YL0cXRwHvfkrnIJtZfmWaqqvhls6OMfo9UGZYvyrsfF1I6+Ou07rttOo97u8u/jawOMzIzTT8XPZfDOpEWtamuai123eiV9hZJ+/rcUW7MTp6VssGMuSlotNEZT21nKRdT3sjXuLuoK/fPi6ENOK8Ip4c6aeKEX6A7qKhYO+YUUE434Kt9pm/1+/gEd40hWNcNTZKMibGHil/p3yD6rLx8vV8CPZCpyfejDwY+070+FcNhqgTJSyUoc61EO98pMHHGAlqaA5gZyz3NfEykW88mc5TpMkG4WTN2RqkpOuZ5HH6BRA3Wh8NnxidVaiwu7u9ZRsSW8LCAG3hfwBXK0OO4nykbQruSzrurQ2Un1gB4tUKj1vq7e4fB5ygzqipEgFup2CclP4XKzmWPSa942YTrCB/4WVLlBA+dXAtaN6IcdfFThXw/m6FaPIOX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199024)(1800799009)(186009)(4326008)(26005)(8676002)(8936002)(55016003)(52536014)(5660300002)(83380400001)(9686003)(41300700001)(7696005)(6506007)(71200400001)(91956017)(66476007)(66556008)(54906003)(110136005)(64756008)(66946007)(38100700002)(66446008)(38070700005)(76116006)(316002)(478600001)(86362001)(33656002)(122000001)(2906002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?0kNnADPTvcSJ7Ts+GKvb2g0KounGCHT8gj0HwsmMAe79yaKTq8xB67o7/0?=
 =?iso-8859-1?Q?6zB1eCnjSvPtSaizXyZAzROldAFXZua8/0Ig+IVrgzlBqVWtI5Wzd2ZxXi?=
 =?iso-8859-1?Q?7tJYMceRCQurWXvvXqs3ELhyX6DsIvq6qTvrMkFqRcBjRfcraV3kMXAXMM?=
 =?iso-8859-1?Q?d99Ck+YA1fHTd+ikjfGYTa+7tiqQwYmOaRogG57B/2pD55JjIUep2Ae8nf?=
 =?iso-8859-1?Q?WzyHSykdrjXYr2v74AjS9CLRqfZToBqNRwVDeOxP3SEn/m3hdMQwJByTUz?=
 =?iso-8859-1?Q?+Vesvh7gcsiCsSFytzkJOj4kjcoLJQAhTN3BNPaP16t7fM2iIVdZhWKXZ6?=
 =?iso-8859-1?Q?xQkx/qvQiRF45Ix/SpeHHF8qyHCmcKRLMRqc4ba0dTBzXa5ywokClSy6d3?=
 =?iso-8859-1?Q?oKGh0D2qWIYhTx9ns2cpT6lLuOxbrbKM/Od8KehNGL6gSR/UTblvEF3GaL?=
 =?iso-8859-1?Q?thQvloVqRQ5nsmtxW4Map4xvv8j4LvOJ+2oYNozuikJkM/e5Io/2IWPJ/f?=
 =?iso-8859-1?Q?c5hhQuutj6gts6Tikm3y2UcH+zAAkR3brFzvFyX/L2f49kLeGi4YcrqHoa?=
 =?iso-8859-1?Q?6Z243hCA6+YfaHZTFTNOtzYh/1GPnGsygH5Hxbkf/88l7W6WOtBqLihszq?=
 =?iso-8859-1?Q?Wqvm8Xx+eg7gHvBUhYnD3sV9mbC+EqhjlnAas7eYRmfPEXtcxLzgoKAi5J?=
 =?iso-8859-1?Q?d+A7hSyOsZTpfE+Gq+7SMwaKanQVDIa/r6UjRi0hUx3jFSB0JWdv7xExHG?=
 =?iso-8859-1?Q?7lEZp8KNrbjVFX5/1Pu7ddEvmzl3dJq8RTtyCRqlegfDGU8o66zgCvT0jb?=
 =?iso-8859-1?Q?NVSjib23+UbiGcCqZQTnnbTvnxqf6ESH3ebxhfcAzKoLsQ+SoNuFCsHxGt?=
 =?iso-8859-1?Q?sex8SuCeHTBQoUZfOkkjdcR33ps5kzFtvHfp3gUFr1zJ4O4UEFTg54Dpvl?=
 =?iso-8859-1?Q?rnobs6+si39La4ChVX956TdLwTwPQDTOxjlSm+wWVguV9/J0nkOqRUEmGG?=
 =?iso-8859-1?Q?tddZbViBshDqVz052rE4CSrNJqYbDqxb3DWquphf6mj2GmUvuOXbqapnvg?=
 =?iso-8859-1?Q?EbdYkDsnWF/FzEnSgItVeQPji3kLDLnj5OK7NRokWePpDktU1EmttYovYQ?=
 =?iso-8859-1?Q?T6AbTzQKqvsFfnaLf+ButkjoOont5PYouLhiamBrFmkv93aSeOfrwR39E7?=
 =?iso-8859-1?Q?8alnxlwCYxCwZUMsbpTPJXT0ZUNhNgFjsSsxCGXiL9MTLKhOhJxpaWuO5U?=
 =?iso-8859-1?Q?uiAjD9wudQ7e6lI39vlASr5io4ExI1PCJKR8u7IuPR6rbxdiELYba2IUpe?=
 =?iso-8859-1?Q?vRIGvuVE2sicMlViFkp54ze5JnIHrIb24N+2DhySVbeAoFAp2GziTMAlaM?=
 =?iso-8859-1?Q?EINH9RZf2OEa1kpYi6PQQs7b5fjPPAaeAwGafzHRgAHtFqatduU2+/vwJu?=
 =?iso-8859-1?Q?yfFTHoVLnSwZqAFIapZ9swSiVUxcY/ow+P9YSeroW76fMhp2+fwN3JYFqU?=
 =?iso-8859-1?Q?zcCfZTE0l8QF7uwOeAGaKYH4OISvDRF06T4Fde/eYf/C6bklq2KtsV7Ryd?=
 =?iso-8859-1?Q?eNoUUrbKi2PyUrDTtA1h/xv5vHYnVk9gum83YCUFzyUn7quyo1+++tFuvW?=
 =?iso-8859-1?Q?cBzI0o0/BdqBM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898bee01-6e21-4df8-ca67-08dbb2a83456
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 09:19:30.5253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ip41/CXHcxV9bhmmHjX7AlVhF9Od3LGAvnLEXTB2p7HEuHNcAOL4x5S8k98SXdXTAtl7szqtsuA93JYT9ig+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > Does it mean that this requires maintaining a new guest driver=0A=
>> > different from the existing one on bare metal?=0A=
>>=0A=
>> No, the VM would use the same Nvidia open source driver that is used by =
the=0A=
>> bare metal. (https://github.com/NVIDIA/open-gpu-kernel-modules).=0A=
>=0A=
> because this driver already supports two ways of accessing the aperture:=
=0A=
> one via the firmware table, the other using this fake BAR2?=0A=
=0A=
Yes, exactly. The driver supports both ways. An absence of ACPI DSD device=
=0A=
property describing the device memory (that happens for the virtualization =
case)=0A=
when Qemu does not expose them via VM ACPI) provides an indication to the=
=0A=
driver that it needs to use the fake BAR (and determine the memory properti=
es=0A=
from it); use the memory region otherwise.=0A=
