Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8762B769992
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjGaOc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 10:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjGaOct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 10:32:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6F19AA;
        Mon, 31 Jul 2023 07:32:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h18/6dg0dHFOxDWgkZxiUsziDawCNbaVsXpwV0u76AUMPagIznNNJzP+0PtLYLQuySgOeDD4wXhTCt3UNX5zTlV02zh9NMRuf64DW1i/5c7uTkYc1N4Yagz6u6pv6Vo6v6HWFHUC3kVQNH2RbjRKw+4PLYoiha9u7TUpkZii+D4jP6JsHXUxM5MFa5EGPqWeb2zzAXpWaawpOMrxCEBybes7+/fNPemRL3mr8BGHiLS3PUoC4J/rGCsqPoUdaTQOUkVX8OYS7pRXbuvNOVWZcfKMbviORzh3JH0Hsrie3TnY/cFflhO/hMuhqg91KQPjo4ApXU4p/rLp1EY+2omwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhD3WvaCtIxTNiPPOhO5pHx2n7wgZpnBPvu6DOtZidg=;
 b=iZreBT76/rIHOUvQY0u8X9pLMWP8jWGU3NruGNYdoZbPP/MQjfketl4oBvzT79SpisvQyN3kog/GTffsw0GOJh2/h4+zP8LlG7rkavqcOZISkDk5JL4BR0F8Md9AAq3BmFpPdjEJm1epojBgPLLKlBDHAhGGODfUflFKqiNQSyMmhf3xti52lbNaY+uRB/GVr8POjlDeub9XfZUHP7yI4o34KvU7kzXXTusmKV19gnRUAEHMG8Li0sHvuy0lkW8j3ldAMKFH0Qxs5eEZRIWx4xthp+ZKMxrCfn9YJJ8rS8Nvq4z7B8zRnnl5E4S2vjR25nNbcHJoDdNC077JQO3YMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhD3WvaCtIxTNiPPOhO5pHx2n7wgZpnBPvu6DOtZidg=;
 b=cjuxSiau9dQ+scNVsXe9dhIK0Qim8KiodkUiCQNBxI1zNJa/Bcr9pxXOS2yr1zDmJcLCVzpRdccgtAJos2xzaeqGx04rPXbtM6KCtELUUUr8hyw23g6cxqa7AJg3SihgN0tuvuit2rDSMXLXBnDcSAnRbzS/kj2DErd3Fdmm51/nwxmF7uO7bp9eRJ6cuNKvOX7mhXkrgFS6qVcdRWBal9ZYKwsM+hL1wXx9NRE3K076YMhfhxFehr6RPZl2wFUVAQQIpErL0WC/MKx4TrTOLeb+GjKYR9BoCgPNQD14tib8FITB/fUpRHUeE0xcZAm+OOc3hvXtCjjyOOlC22D2lg==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by MW6PR12MB8959.namprd12.prod.outlook.com (2603:10b6:303:23c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 14:32:26 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::f4eb:dffb:214a:7862]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::f4eb:dffb:214a:7862%4]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 14:32:26 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZuA0UNBO/J73IH0aqgxgx4YgKL6/OIgWAgACFKceAAIeTgIAAL5MAgASfhTk=
Date:   Mon, 31 Jul 2023 14:32:26 +0000
Message-ID: <BY5PR12MB3763993E153A8A1B9E73A3D0B005A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230716174333.8221-1-ankita@nvidia.com>
        <20230727142937.536e7259.alex.williamson@redhat.com>
        <BY5PR12MB3763F22DF104E2B3BC65C628B006A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <ZMO1H/uepDTtAaet@nvidia.com>
 <20230728092144.5f51343f.alex.williamson@redhat.com>
In-Reply-To: <20230728092144.5f51343f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|MW6PR12MB8959:EE_
x-ms-office365-filtering-correlation-id: 298e0a07-4916-4de6-6f13-08db91d2f612
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cu2Hxw6SI1GHQWCsjQ7J3kUE1m3XvhoBkZxiA+fyMVuUNHKpFk624xEbtFaOTuaCH3cxZfi7Zb6qZm5F1v/oPmLEuXEcey0gKPF+bubWXIZBi9PZOYiRyZEhWgmumsQShh8pBg1L+xpeqbj0VGLiRUUJIi/b5KJ2YqygaN7zasUmPpnxHHl+c98hTy8YaKdSiWFcXFQYfTndDiKghhAe3t4CdDd2J0Ym0tdX9QZ6tgnPUFYnl09C1FzrcTmtdjhtAn5CczT5UlzGSUsVRR34FYIHX4jRa39sMKh23mqOl/VflGo5CG3OAzo7Q/HWCjhIYRjbeGW+UE44TNvOGuP8pUlCSO2g8N21J6liJgaZj9nYsbMxuW4m7nhK/hC/P2Ii1YGw8ZvYH1cvazPiGuf/uFGed1Cxqev7biLQZVee3wed8G+wBNCgY/IIQ41Ym1LAi3kavZFv4G9y2PpSUrSVH80DUEnANclsW6c5Y1b6jgBRUQe6rVOYtvB4YQH/gN8gBLK+1QhFhosx2aBuIXXS6S+JJb/VA+rd1kLY3dUFLA+lzJIIOKV4Act8Ownmupza9VpMCEiaJLFDj1L1yqVJmbSNCj+ZqYqkGok7fvssjU5cluqqjtMX1gMfRGIPj4cv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(9686003)(7696005)(55016003)(26005)(6506007)(83380400001)(186003)(33656002)(76116006)(91956017)(66946007)(52536014)(66556008)(54906003)(41300700001)(122000001)(110136005)(38070700005)(66476007)(86362001)(316002)(4326008)(5660300002)(66446008)(64756008)(6636002)(8676002)(8936002)(2906002)(71200400001)(478600001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?76yBA6NoXQk5/16wdeyQGAwfP39xRbjYLR649kNUjoUKfH7q4FIqPrjCM/?=
 =?iso-8859-1?Q?s7/PE4ZKz3n4mYnW0l3cUBslkyMymah1tf1OgflXYL41KqfJhZmVoUO3Q3?=
 =?iso-8859-1?Q?srCHUeMMlkgU7Q2Q//vmW5YTZyT7r3XjWx7SNO5I6BK6JMW25bdV5EDlcx?=
 =?iso-8859-1?Q?n4BaJgf9KGXCJE/vCAPrvKmq2gkRWIHY/Ry9aou0hMrSY2gv/WOXDL1ND4?=
 =?iso-8859-1?Q?DqZVpcTlnPOmhi19OA8XKpGY2Ij1IQ2SWulD1R+dO8HZb+ve1C7AET4TnZ?=
 =?iso-8859-1?Q?ZKLiyAobGKaSf3S2OmtnUmANt9+r74cO3DNia501AvYQRK3fxZmeGGfpTQ?=
 =?iso-8859-1?Q?n+NgbesPTdvMGI/DBQItxPmh4EslAXK65cKJF4hl3TLc7Ow8eAht5sTOHs?=
 =?iso-8859-1?Q?FRbY0pkCmG1AGDhqpYPEmbdTLucFUwlQQLFH52RWAWPU/pwDiA9rL+lXne?=
 =?iso-8859-1?Q?dV+SEdkR+T7lUGnSqYstgm9DBzhgEB8Q9I3uAGxzUQuFqar0hLcC0n+P38?=
 =?iso-8859-1?Q?kES3J86dSb+Ti50d+gAqWO+RHxA1HNKEhYFGWmmssRwFfa5Qtkt0RX0nTJ?=
 =?iso-8859-1?Q?Vbd3gwptvxJqfo5ppLqdBp3mnyBWtYcIWxJZYSDSV0r/DLsUr90mEHufZZ?=
 =?iso-8859-1?Q?iqcBonv/RIHlq4DOXJqTzmro4K85QYrgUlPWvVPaUqwdTySI7oewO8bxRY?=
 =?iso-8859-1?Q?p/UECrotlaz4AeioSYMPmGRWFqgge93Tks/RWTyAwZT7uG5918YLQbDtj1?=
 =?iso-8859-1?Q?pli/EVxWTMkvGNkcc7Wcr7ixUZ3Z1PXSgFvhqQjWwk9l2UW38HCuk6xCLY?=
 =?iso-8859-1?Q?SYjtkuetRXCfsRsNmZw6KYkBPEzSuaKvTrYoetBk9lJUDD9L4woryiMgCM?=
 =?iso-8859-1?Q?sZXbwwZWM9clY6ir4O9tC6RjNIab099F4rCD4mkHWjBcaeSr7TEFsLn+Nw?=
 =?iso-8859-1?Q?G/nfDPzbg3KWoTVZ9d1b57uVEmEOKqRIyIDHh/EKyr+CLBMRVH4EggCas9?=
 =?iso-8859-1?Q?q1OFHcx+FU15D41717DNiOLjn4+4Q6VOEPvjlR8pgJZvoisVS6PlHdDoG5?=
 =?iso-8859-1?Q?KA1ieCg+T5c+H01LYaFa3qfsvzt9R1jfUMjw4dPvVOKdCS8JltBtdzrzRH?=
 =?iso-8859-1?Q?QOLZYidXlieEIWZA40bmpKjQei1gsBcchBo0BfnqgU0P3VSzk18T/fQdy9?=
 =?iso-8859-1?Q?7DxURpFA7S8sqcBKaY0fjEHWhXtj2noRNzxR40bUINEpl0YP51bEfCkPEf?=
 =?iso-8859-1?Q?esOtkSYjE+3Kh2jHVxE54n5b4oOkI7TK1dgkj2GcM6nSzJMzwv/advIO6l?=
 =?iso-8859-1?Q?vDg9X1l8PD2z9cE7AqSmtEEp3exM4Kpy5Mxisy3SBJxrLap/Vjr2Xn1r6o?=
 =?iso-8859-1?Q?R28sX1KP73HXJwVWYVeNFxoDy/5cxaXGHCpL81YctjTeGwmh1EfP5cXbAt?=
 =?iso-8859-1?Q?M4IWLrojkvMakd2ZDtEPSn5pd5hbCNKoHIEY5jEfFhI6HhkZNTwEyE0k0s?=
 =?iso-8859-1?Q?Bnm0BwJeIH0wt6C4XLXj8zwwmsq84heylQGEYX7dd8NU8cWlrGrCBPkDev?=
 =?iso-8859-1?Q?FI+nOLMN+eLbNZwcriSOKnJ3LE2t74tW8JTT07v5hUJlcLRZ0UNScCpX+k?=
 =?iso-8859-1?Q?qa29epuVAVWeA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298e0a07-4916-4de6-6f13-08db91d2f612
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 14:32:26.0184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J1qsIFAb0ebUvr/n/Bn2GPVT8lbeb1TIcYj8B3TiqWTxBI+GM8LlBKz2p6tNhkNAglWhgs1LHCZr5krAhDmTAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8959
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> >=0A=
>> > Just to confirm, the ask is to just update the comment to reflect the =
behavior,=0A=
>> > right? (I missed to do that in this posting). Because we do redirect t=
he call to=0A=
>> > vfio_pci_core_read() here which will perform the read that is within t=
he device=0A=
>> > region. The read response to synthesize -1 is only for the range that =
is outside=0A=
>> > the device memory region.=0A=
>>=0A=
>> This doesn't seem right, vfio_pci_core_read() will use pci_iomap() to=0A=
>> get a mapping which will be a DEVICE mapping, this will make the=0A=
>> access incoherent with any cachable mappings.=0A=
>=0A=
> Right, but also vfio_pci_core_read() doesn't know anything about this=0A=
> virtual BAR2, so any in-range BAR2 accesses will error the same as=0A=
> trying to access an unimplemented BAR.  It's not just the comment,=0A=
> there's no code here to handle a read(2) from in-bound BAR2 accesses.=0A=
> Thanks,=0A=
=0A=
Got it, I would do memremap() to the target device memory physical address =
=0A=
here. The memremap() and the data copy would be done to only the number =0A=
of bytes asked with the read/write operation.=0A=
=0A=
Will post that with the next version shortly.=0A=
