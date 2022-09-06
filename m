Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF03F5AE079
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbiIFHDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiIFHDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:03:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A166F268;
        Tue,  6 Sep 2022 00:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hnd+jUjNST8mQM3WTkjR5nCj1y7IQ5pIo1G6TJp47ORhn8F0Llc6pD8HnCviUNhhHdP/jeWcXGcnRY8bMi40sCYHGRmIm5+xOP8jgrvK87a6HXarGYfdTl6BbQClRgLmaEvP+upFDFRVqtfUy5TSNDJBrd09V52g3VCPLYmK/rYxk1y3kKh+LRaWN85uNh8Qq8NZs3qy6Ri9znUsA/jDp96x7RhFQn3fVAxAUeSIXWaWJbiO3AlqXWcVYkui0IsCawA/SaCWpVtGFLdL2PczOQ4LiMy0Qdtq4T55/FbdM1D1LgPn0tqRycd7w3yxoEFRFON4jyZeMiphh6/ShQu+Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQV5kGZj8QJZ0e/+gKJHnT0JsiVa7ikPTapm0OXVQBs=;
 b=XBbz6oIJis0ISWnvcSJODYgLeCystyhf08L4lNc6gyxJ1oODkL1hcOEruEWnFc5l1nCzHd7QgmwssvaINKxSJCoQ2RBxuDrurMsSbSWQ20kv/zYPpDpGvvJ91KYMsfe9aWZogQRc92GZdLaamnugdoy/EnwA4cCjmaBJeUT1lOdAdJjPjdzp1l68DIF8GQgFZZe+CVhP9P80P8Tt2sP9ZiptdglklJfu9HgGbndNV7/yoTiTAZ2h2u2UN980qyzq2GcDiXHEZ9UobUbp68zLEiH2L0wgsNdlbau8LOmD58XwWiUHJ6tnte297a7MmPsZqNphOn+4Zf0h7YBBOpu38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQV5kGZj8QJZ0e/+gKJHnT0JsiVa7ikPTapm0OXVQBs=;
 b=41UFS8b3PqI54tGuC1eChxZ2qfl2L2oyAoemrBhF9qaxNVMYdCQOvfi4fM79yurg8EPTX8OVGwkDs7da+vLXu+v9qr+QBTe9kex5e9SGqX+Ad+Ew5dvgxhOZ8wonQSm+nsavrA8+XDAINHBLJHk3vDOCr6bZ/u7j9DIkvR437RA=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 07:03:07 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4c82:abe6:13a6:ac74%3]) with mapi id 15.20.5588.014; Tue, 6 Sep 2022
 07:03:07 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
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
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Thread-Topic: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
 controller
Thread-Index: AQHYskrtUUKhcm3XXUSWCYusxie1ua20bGaAgByNxZCAARx/gIAAAaFg
Date:   Tue, 6 Sep 2022 07:03:07 +0000
Message-ID: <DM6PR12MB3082867B1BDCBBC9C25F560EE87E9@DM6PR12MB3082.namprd12.prod.outlook.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
 <20220817150542.483291-2-nipun.gupta@amd.com>
 <93f080cd-e586-112f-bac8-fa2a7f69efb3@linaro.org>
 <DM6PR12MB308211F26296F3B816F3F005E87F9@DM6PR12MB3082.namprd12.prod.outlook.com>
 <8712e2ff-80e1-02e9-974a-c9ffcf83ffab@linaro.org>
In-Reply-To: <8712e2ff-80e1-02e9-974a-c9ffcf83ffab@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-06T07:05:11Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a1f18f02-81d2-429d-b1a0-100936abca65;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0124825-8abd-4561-3788-08da8fd5d9ee
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6CkodrXiA6GTYuEv6DaeOzjisKpYliu1rMb9nN9UYp8m1LekdMr4h8nqKiySnLtUCjqMTquCGVnrhUMxzcNKq+axCrdDGGBLDskG//5yPEs3PXsBACU8xHq7Hl4AeCMgxSjCISsPznpSPu5Qu/txwI0MQm47h0rnAEVscux81TrPKmxVTJQrPF5P8gyGxXK8OQ2wn0iC5dxKrUA29fuc8I3g7/CZURhtwoKQ9lwDLHk3y9ieo+I8j7h06Soi1tUPb0PAghO/GU3hSqpjaApfhbgzfGeeCcUQ5JD/PcaB5HmOHqN/EN41un5kVW2XO71jaVmLBaPcJ364IWwwYHLxCSHOBIU1+Lso3CGbCty7semNR7UWJZjqbNATIDNMkLE9IedTyHDWSIkFehTo6hHuHNYzd6+zhkFDNomeVPqvqcbUzBiD1GJnJ1AxVEOAsbCApRvCMO2OqFlVVMjqo6lP89GmUUfwtbH7OrVS8LBN9cyrbT+ApXFm1UG1i+Qh4YfPlDjAkrRasDkp2nROBQr/9mYQHVVRMRwVmK5s2ItlXz+0FweGMTZu/vLg4CdW+cOXl8zeBA77vwFw6rntDLw5BnKgH2yGesB+RQKlOspDWTQAKeCl8owtK5QdrY3aSeub39sp8vlh/EgOdFUymBdvqP7JCRpF/xTQErXJX9z4Jn7xrxTeIL9u3H0KyTENb/86b6juI/5KANtEZoYGslDHPIBlCts8+gfD9Ur4ti8Nf9ajWl/LGs3Lb4bzqlo3/7IuOatFBOm0+ARIkS3sjUTuRHBpdO10Q5XvPG9oRIe4SOQVZ+lPM/qQy7+TulawODrQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(38070700005)(921005)(122000001)(66946007)(64756008)(66476007)(316002)(66556008)(8676002)(4326008)(66446008)(76116006)(2906002)(54906003)(45080400002)(38100700002)(110136005)(83380400001)(55016003)(52536014)(26005)(7416002)(5660300002)(8936002)(53546011)(9686003)(186003)(966005)(41300700001)(6506007)(478600001)(7696005)(71200400001)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M7sk7SjtqFgAEFnHRIJ8X9L3KGANQnbK8a75WUPmNpsAtbvSuldaguGVIlVX?=
 =?us-ascii?Q?JuPnZmJknzEo8T2FjS0bCse9OwMUZ+IgmVU64567ZSkri711Ci4DoaVgYdAq?=
 =?us-ascii?Q?OGbs1YfLnAu76emcsbkp3YASGIgQho/rE9YavIGARJNnIRiEavOEp2HtlaGD?=
 =?us-ascii?Q?lpbfXbsrRebjQeu2PmWWJzvNyx8xvVLeVeYnfXK9smQoneY6fR1cujyO6KD8?=
 =?us-ascii?Q?hc/RUqauz+/Qa3/MC5BZcXMw8pV0zHddQzqsMMJDQiQGQbbc3vJ012Y6AdBu?=
 =?us-ascii?Q?U2ZAe990RdbIsE5AV/MHLtMq41Mvi1pysDKEvonNY58zkh4CmANRkr+oAcA+?=
 =?us-ascii?Q?MNHJXLxnYq4YUUJ22mpXHmryMkWbEZlQ6E77suwiqh8UZcdYNiKkpX6ZvD9k?=
 =?us-ascii?Q?yt6hlNV2k5tBXKUjtk3jG1Yfx6sRLs5S7epCpbfEmVRjByPVsgVqqo074FBH?=
 =?us-ascii?Q?xF9vnlHCj60XlPWVM2mpEvdD8dcr58qENfvMAHC4VzD3Ut+6aLHC7BJP6QgJ?=
 =?us-ascii?Q?odT1XWNOZQbMUwvyOlJj2xE1vrOb3OHJ6NKUyZHQQgfGHTqF43IwCbZDa+yB?=
 =?us-ascii?Q?3UHUEtQEYZWoUNL8AMybRswRo77oV00H+acgsY04j58rBCNWvupN1iYjlSbO?=
 =?us-ascii?Q?4l/6V/bFVFgNVVYEvC/5gcZal/mNLZeVo7VZHy741dTZQLWKQ1VUH059VAZ8?=
 =?us-ascii?Q?ANMPdjY2j4aa1B9xplyJer/H2uJiOeinNNRn0cMZxpAwufyB21GP+0yoISai?=
 =?us-ascii?Q?KW4Hi5Jkqyce0m563lP0x0Udhz114X1MQdHrVDlXXjNQk/1L4kdzaLRk9Ses?=
 =?us-ascii?Q?DB2ITUakR9OkiqF6cLtYGePuVV6uEQGIfi+f/tiK4Em3+kogzMXBUm3KOFBO?=
 =?us-ascii?Q?dAdRcwFFZjWD/sFKMa932vWCsZpVLva59Bmhnfq+na30HKVWpfs+I52sYlif?=
 =?us-ascii?Q?TrW1nrDQ5DFvloaiOsP/WvEPtfSTmUcbj/w82rbDPjWSCh/ks0SsfOgc62Hl?=
 =?us-ascii?Q?XSKzksEzFJXl9MUBQ+k1K1RSx4CnyaQk2yifcDNLO1lS8E6xNQsonhaz8JYW?=
 =?us-ascii?Q?0uo7VYMEoqv2OFDQzdbIAbQ466H2vtxFoSUpx0CLes9cpAfZdPXFmVeSJdtx?=
 =?us-ascii?Q?8U3+nksRluFjT1WC5Qnis31ZKMLyXGcZ95ZVx+Ex+MZBwyaMA3a59mGwK1wv?=
 =?us-ascii?Q?oI24frb4h1x7x75zr5ucIvAkzxDIRsBV1VK9AWokT2MHJETOrj7jThhnBHj8?=
 =?us-ascii?Q?kEPP/mh6egyOvpkEbFqFN2rPbre314/sEkGhP99YlObOdnTbPQv8RYxfwQhw?=
 =?us-ascii?Q?FDOB75+AMLJtAeYbOuth7gnC8EcFzjnNNNVrGek1BN0Xn3FRexz4J+n9nkkZ?=
 =?us-ascii?Q?Ftr0vY4ByzcphjVNcfvkBlrv4fJBxQ9N2xKpO9PY7BsiT4l5eLD2QX3/kHJM?=
 =?us-ascii?Q?ZAgFXwgslOlYU/tcuZY/DFgmNxRpTxaJvlIkbe3FOWxE2T8vgmHhQcm6hiQg?=
 =?us-ascii?Q?xIo76C3nJ/nCaiyYZCqAnHDLaGdFtpd00+B1nbx12MqO8v+8SDoVUMH3rMZQ?=
 =?us-ascii?Q?+/5rT78jQNw72BgHMg8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0124825-8abd-4561-3788-08da8fd5d9ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 07:03:07.2795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KX/gC0KlGUc/51IaGaoZ8zTrvQ4qwXT18J8Q87ChD7WsxW2Fhm9O4VVQqE6ByReV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5357
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



> -----Original Message-----
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Sent: Tuesday, September 6, 2022 12:25 PM
> To: Gupta, Nipun <Nipun.Gupta@amd.com>; robh+dt@kernel.org;
> krzysztof.kozlowski+dt@linaro.org; gregkh@linuxfoundation.org;
> rafael@kernel.org; eric.auger@redhat.com; alex.williamson@redhat.com;
> cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> jeffrey.l.hugo@gmail.com; saravanak@google.com;
> Michael.Srba@seznam.cz; mani@kernel.org; yishaih@nvidia.com;
> jgg@ziepe.ca; linux-kernel@vger.kernel.org; devicetree@vger.kernel.org;
> kvm@vger.kernel.org
> Cc: okaya@kernel.org; Anand, Harpreet <harpreet.anand@amd.com>;
> Agarwal, Nikhil <nikhil.agarwal@amd.com>; Simek, Michal
> <michal.simek@amd.com>; git (AMD-Xilinx) <git@amd.com>
> Subject: Re: [RFC PATCH v2 1/6] Documentation: DT: Add entry for CDX
> controller
>=20
> [CAUTION: External Email]
>=20
> On 05/09/2022 16:05, Gupta, Nipun wrote:
> >>> +
> >>> +    cdxbus: cdxbus@@4000000 {
> >>
> >> Node names should be generic, so "cdx"
> >
> > Would be using bus: cdxbus@4000000.
> > Kindly correct me if this does not seem to be correct.
>=20
> I don't understand it. I asked to change cdxbus to cdx, but you said you
> will be using "bus" and "cdxbus"? So what exactly are you going to use?
> And how does it match generic node name recommendation?

I was also confused with the name suggestion as in one of the mail you
sent out later, you mentioned:
" Eh, too fast typing, obviously the other part of the name... node names
should be generic, so just "bus"."

That is why needed to confirm. To me now "cdx: cdx@4000000" makes sense.
Hope this seems correct?

Regards,
Nipun

>=20
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fdevi
> cetree-specification.readthedocs.io%2Fen%2Flatest%2Fchapter2-
> devicetree-basics.html%23generic-names-
> recommendation&amp;data=3D05%7C01%7CNipun.Gupta%40amd.com%7C4a
> e1b96c542949574f3a08da8fd4c64d%7C3dd8961fe4884e608e11a82d994e183d
> %7C0%7C0%7C637980441269905225%7CUnknown%7CTWFpbGZsb3d8eyJWIj
> oiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3
> 000%7C%7C%7C&amp;sdata=3DpA0kWXNJGQw9y5zLNNXpfRMjH1i2QRM%2FK
> YsNk0C%2FCQM%3D&amp;reserved=3D0
>=20
> Do you see any other buses named "xxxbus"?
>=20
> Best regards,
> Krzysztof
